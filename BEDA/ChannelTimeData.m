//
//  ChannelTimeData.m
//  BEDA
//
//  Created by Jennifer Kim on 6/8/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelTimeData.h"

@implementation ChannelTimeData

@synthesize channelIndex;
@synthesize isHeaderSelected;
@synthesize headerTime;
@synthesize playTimer = _playTimer;
@synthesize playBase = _playBase;

- (SourceTimeData*) sourceTimeData {
    return (SourceTimeData*)[self source];
}

//- (void)initGraph:(int)data {
- (void)initGraph:(NSString*)name atIndex:(int)index range:(double)minValue to:(double)maxValue withLineColor:(NSColor*)lc areaColor:(NSColor*)ac isBottom:(BOOL)isBottom hasArea:(BOOL)hasArea {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setChannelIndex:index];
    [self setPlayTimer:Nil];
    [self setPlayBase:Nil];
    
    [super awakeFromNib];
    
    // If you make sure your dates are calculated at noon, you shouldn't have to
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSDate *refDate       = [NSDate dateWithNaturalLanguageString:@"12:00:00"];
    //    NSTimeInterval oneDay = 24 * 60 * 60;
    NSTimeInterval oneSec = 1;
    
    // Create graph from theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    graph.plotAreaFrame.paddingTop = 5.0f;
    graph.plotAreaFrame.paddingRight = 0.0f;
    graph.plotAreaFrame.paddingLeft = 57.0f;
    
    if (isBottom) {
        graph.plotAreaFrame.paddingBottom = 20.0f;
    } else {
        graph.plotAreaFrame.paddingBottom = 5.0f;
    }
   
    // Add some padding to the graph, with more at the bottom for axis labels.
    
    graph.paddingRight = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    
    // Setup scatter plot space
    plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    
    NSTimeInterval xLow       = 0.0f;
    graphScaleX = 60;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 60.0f)];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 5000.0f)];
    //////////////////////////////////////////////////////////////////////yRange should be dfferent
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minValue) length:CPTDecimalFromFloat(maxValue)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minValue) length:CPTDecimalFromFloat(maxValue)];

    CPTMutableTextStyle *axisTextStyle = [CPTTextStyle textStyle];
    axisTextStyle.fontSize = 10.0;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.15];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    NSNumberFormatter *labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    labelFormatter.maximumFractionDigits = 0;
    
    CPTMutableTextStyle *titleText = [CPTMutableTextStyle textStyle];
    titleText.color = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    titleText.fontSize = 12;
    titleText.fontName = @"Helvetica";
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    
    x.labelingPolicy     = CPTAxisLabelingPolicyAutomatic;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
    x.axisLineStyle = majorGridLineStyle;
    x.labelFormatter     = labelFormatter;
    x.labelTextStyle = titleText;
    
    x.majorIntervalLength         = CPTDecimalFromFloat(oneSec * 10);
    //////////////////////////////////////////////////////////////////////xOrthogonal coordinate decimal should be set to starting y range
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.minorTicksPerInterval       = 1;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    
    
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter            = timeFormatter;
    x.labelTextStyle = titleText;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    //////////////////////////////////////////////////////////////////////yRange should be dfferent
    y.majorIntervalLength         = CPTDecimalFromString(@"1.0");
    y.minorTicksPerInterval       = 0.5;
    y.axisLineStyle = majorGridLineStyle;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
    y.labelTextStyle = titleText;
    y.titleTextStyle = titleText;
    y.titleOffset = 35;
    
    // Add an extra y axis (red)
    // We add constraints to this axis below
    CPTXYAxis *y2 = [[(CPTXYAxis *)[CPTXYAxis alloc] initWithFrame:CGRectZero] autorelease];

    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, y2, nil];
    
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Date Plot";
    
    // Actual graph line & fill
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth              = 1.f;
    
    y.title = name;
    lineStyle.lineColor              = [self toCPT:lc];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    if (hasArea) {
        CPTFill *areaFill = [CPTFill fillWithColor:[self toCPT:ac]];
        dataSourceLinePlot.areaFill      = areaFill;
        dataSourceLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    }

    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSourceOffsetUpdated:)
                                                 name:BEDA_NOTI_SOURCE_OFFSET_CHANGED object:Nil];

    
    //    // Register self as notification observer
    [self reload];
    // Create a header plot
    [self createHeaderPlot];
    [self createAnnotationPlot];
    
    
}

- (void) reload {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSDate* basedate = [[self sourceTimeData] basedate];
    NSLog(@"basedate = %@", basedate);
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = basedate;
    x.labelFormatter = timeFormatter;
    
    [graph reloadData];
    
}

- (void) onSourceOffsetUpdated:(NSNotification*) noti {
    NSLog(@"%s: %d", __PRETTY_FUNCTION__, [self channelIndex]);
    double gt = [self getGlobalTime];
    double lt = [self offset] + [self globalToLocalTime:gt];
    [self setHeaderTime:lt];
    [plotHeader reloadData];
    [self updateOffsetOverlay];

}

-(void) updateAnnotation {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    [plotAnnotation reloadData];
}

- (void)createGraphViewFor:(BedaController*)beda {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CPTGraphHostingView* view = [[CPTGraphHostingView alloc] init];
    view.hostedGraph = graph;
    
    NSSplitView* splitview = [beda getSplitView];
    CPTGraphHostingView* lastView = [ [splitview subviews] lastObject];
    
    [splitview addSubview:view positioned:NSWindowAbove relativeTo:lastView];
    
    [self setView:view];
}

- (void)createEDAViewFor:(BedaController*)beda {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CPTGraphHostingView* view = [[CPTGraphHostingView alloc] init];
    view.hostedGraph = graph;
    
    NSSplitView* splitview = [beda getSplitView];
    CPTGraphHostingView* lastView = [ [splitview subviews] lastObject];
    
    [splitview addSubview:view positioned:NSWindowAbove relativeTo:lastView];
    
    [self setView:view];

}


- (void)createTempViewFor:(BedaController*)beda {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CPTGraphHostingView* view = [[CPTGraphHostingView alloc] init];
    view.hostedGraph = graph;
    
    NSSplitView* splitview = [beda getSplitView];
    CPTGraphHostingView* lastView = [ [splitview subviews] lastObject];
    
    [splitview addSubview:view positioned:NSWindowAbove relativeTo:lastView];
    
    [self setView:view];

}


- (void)createAccelViewFor:(BedaController*)beda {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CPTGraphHostingView* view = [[CPTGraphHostingView alloc] init];
    view.hostedGraph = graph;
    
    NSSplitView* splitview = [beda getSplitView];
    CPTGraphHostingView* lastView = [ [splitview subviews] lastObject];
    
    [splitview addSubview:view positioned:NSWindowAbove relativeTo:lastView];
    
    [self setView:view];

}

- (CPTColor*) toCPT:(NSColor*)nc {
    CGFloat r = [nc redComponent];
    CGFloat g = [nc greenComponent];
    CGFloat b = [nc blueComponent];
    CGFloat a = [nc alphaComponent];
    return [CPTColor colorWithComponentRed:r green:g blue:b alpha:a];
}

- (void)keyDown:(NSEvent *)theEvent {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([theEvent keyCode] == 49) { //Spacebar keyCode is 49
        NSLog(@"Time is: %@", [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle]);
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Play/stop
- (void)play {
    if ([self isNavMode] == NO) {
        NSLog(@"%s : graph only plays in Navigation Mode", __PRETTY_FUNCTION__);
        return;
    }
    NSTimer* _timer = [self playTimer];
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                  target:self
                                                selector:@selector(onPlayTimer:)
                                                userInfo:nil
                                                 repeats:YES];
        [self setPlayTimer:_timer];
        NSDate* clickedTime = [NSDate date];
        NSDate* adjustedTime = [clickedTime dateByAddingTimeInterval:-[self headerTime]];
        [self setPlayBase:adjustedTime];
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }
}

- (void)stop {
    NSTimer* _timer = [self playTimer];
    if (_timer != nil)
    {
        [_timer invalidate];
        [self setPlayTimer:Nil];
        NSLog(@"%s", __PRETTY_FUNCTION__);

    }
    
}
- (void)onPlayTimer : (id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    double t = -[[self playBase] timeIntervalSinceNow];
    [self setHeaderTime:t];
    
    [plotHeader reloadData];
    [self updateOffsetOverlay];

}

-(void)zoomIn{
    graphScaleX -= 15;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:plotSpace.xRange.location length:CPTDecimalFromFloat(graphScaleX)];

}

-(void)zoomOut{
    graphScaleX += 15;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:plotSpace.xRange.location length:CPTDecimalFromFloat(graphScaleX)];

}

- (double) getMyTimeInGlobal {
    double ltSeconds = [self headerTime];
    double gtSeconds = [self localToGlobalTime:ltSeconds];
    return gtSeconds;
}

- (void) setMyTimeInGlobal:(double)gt {
    double lt = [self globalToLocalTime:gt];
    [self setHeaderTime:lt];
    [plotHeader reloadData];
}

- (double) windowHeightFactor {
    switch ([self channelIndex]) {
        case 1:
            return 2.0;
        case 2:
            return 1.0;
        case 3:
            return 1.0;
    }
    return 1.0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HeaderPlot functions
- (void)createHeaderPlot {
    // Create header plot
    plotHeader = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    plotHeader.identifier = BEDA_INDENTIFIER_HEADER_PLOT;
    plotHeader.dataSource = self;
    plotHeader.delegate = self;
    
    [self deselectHeaderPlot];
    [self setHeaderTime:0.0];

    // Add the plot to the graph
    [graph addPlot:plotHeader];
}

- (void)selectHeaderPlot {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CPTColor *selectedPlotColor = [CPTColor redColor];
    
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = selectedPlotColor;
    
    CPTPlotSymbol *plotSymbol = nil;
    plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:selectedPlotColor];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(15.0f, 15.0f);
    
    plotHeader.plotSymbol = plotSymbol;
    
    CPTMutableLineStyle *selectedLineStyle = [CPTMutableLineStyle lineStyle];
    selectedLineStyle.lineColor = [CPTColor yellowColor];
    selectedLineStyle.lineWidth = 5.0f;
    
    plotHeader.dataLineStyle = selectedLineStyle;
    [self setIsHeaderSelected:YES];
    
}

- (void)deselectHeaderPlot {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Set the style
    // 1. SavingPlotLine style
    CPTColor *headerPlotColor = [CPTColor orangeColor];
    CPTMutableLineStyle *savingsPlotLineStyle = [CPTMutableLineStyle lineStyle];
    savingsPlotLineStyle.lineColor = headerPlotColor;
    
    // 2. Symbol style
    CPTPlotSymbol *headerPlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    headerPlotSymbol.fill = [CPTFill fillWithColor:headerPlotColor];
    headerPlotSymbol.lineStyle = savingsPlotLineStyle;
    headerPlotSymbol.size = CGSizeMake(15.0f, 15.0f);
    plotHeader.plotSymbol = headerPlotSymbol;
    
    // 3. DataLineStyle
    CPTMutableLineStyle *headerLineStyle = [CPTMutableLineStyle lineStyle];
    headerLineStyle.lineColor = [CPTColor orangeColor];
    headerLineStyle.lineWidth = 2.0f;
    plotHeader.dataLineStyle = headerLineStyle;
    [self setIsHeaderSelected:NO];
}


-(NSUInteger)numberOfRecordsForHeaderPlot {
    return 2;
}

-(NSNumber *)numberForHeaderPlotField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    double minY = 0.1;
    double maxY = 4.9;
    if ([self channelIndex] == 2) {
        minY = 31.1;
        maxY = 36.9;
    }
    
    double px[6] = {0.0, 0.0, 0.5, 0.0, 0.0, 0.0};
    double py[6] = {maxY, minY, 4.8, 4.0, 0.2, 0.0};
    double t = [self headerTime];
    
    if (fieldEnum == CPTScatterPlotFieldX) {
        // Returns X values
        return [NSNumber numberWithDouble: (px[index] + t) ];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        // Returns Y values
        return [NSNumber numberWithDouble: (py[index]) ];
    } else {
        // Invalid fieldEnum: Should not be reached, probably
        return nil;
    }
}

-(void) createAnnotationPlot{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Create header plot
    plotAnnotation = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    plotAnnotation.identifier = BEDA_INDENTIFIER_ANNOTATION_PLOT;
    plotAnnotation.dataSource = self;
    plotAnnotation.delegate = self;
    

    // Set the style
    // 1. SavingPlotLine style
    CPTColor *headerPlotColor = [CPTColor greenColor];
    
    // 2. Symbol style
    CPTPlotSymbol *headerPlotSymbol = [CPTPlotSymbol diamondPlotSymbol];
    headerPlotSymbol.fill = [CPTFill fillWithColor:headerPlotColor];
    headerPlotSymbol.size = CGSizeMake(15.0f, 15.0f);
    plotAnnotation.plotSymbol = headerPlotSymbol;
    
    CPTMutableLineStyle *annotationLineStyle = [CPTMutableLineStyle lineStyle];
    annotationLineStyle.lineWidth = 0.0f;
    
    plotAnnotation.dataLineStyle = annotationLineStyle;
    
    // Add the plot to the graph
    [graph addPlot:plotAnnotation];
}


-(NSUInteger)numberOfRecordsForAnnotationPlot {
    return [[self source] numAnnotations];
}

-(NSNumber *)numberForAnnotationPlotField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    double minY = 0.1;
    double maxY = 4.9;
    if ([self channelIndex] == 2) {
        minY = 31.1;
        maxY = 36.9;
    }
    
    double middle = (minY+maxY)/2;
    double px[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    double py[6] = {middle, middle , middle, middle, middle, middle};
    
    for (int i = 0; i < [ [self source] numAnnotations]; i++) {
//        NSLog(@"Annot %d at %lf : text = %@", i, [[self source] annotationTime:i], [[self source] annotationText:i]);
        px[i] = [[self source] annotationTime:i];
    }
    
    
    if (fieldEnum == CPTScatterPlotFieldX) {
        // Returns X values
        return [NSNumber numberWithDouble: (px[index]) ];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        // Returns Y values
        return [NSNumber numberWithDouble: (py[index]) ];
    } else {
        // Invalid fieldEnum: Should not be reached, probably
        return nil;
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Delegation functions
- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event
          atPoint:(CGPoint)point
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Restore the vertical line plot to its initial color.
    
    for (ChannelTimeData* ch in [[self source] channels]) {
        [ch deselectHeaderPlot];
    }
    return YES;
}

- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_HEADER_PLOT])
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        //[self selectHeaderPlot];
        for (ChannelTimeData* ch in [[self source] channels]) {
            [ch selectHeaderPlot];
        }
    }
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point
{
    point.x -= graph.plotAreaFrame.paddingLeft;

    // Convert the touch point to plot area frame location
    CGPoint pointInPlotArea = [graph convertPoint:point toLayer:graph.plotAreaFrame];

    NSDecimal pt[2];
 //   [graph.defaultPlotSpace plotPoint:pt forPlotAreaViewPoint:pointInPlotArea];
    [space plotPoint:pt forPlotAreaViewPoint:pointInPlotArea];


    double x = [[NSDecimalNumber decimalNumberWithDecimal:pt[0]] doubleValue];
    double y = [[NSDecimalNumber decimalNumberWithDecimal:pt[1]] doubleValue];
    NSLog(@"%s: %lf, %lf", __PRETTY_FUNCTION__, x, y);
    if ([self isHeaderSelected]) {
        [self setHeaderTime:x];
    }
    
    if ([self isNavMode] == NO) {
        double gt = [self getGlobalTime];
        double lt = [self headerTime];
        // gt + offset = lt
        double offset = lt - gt;
        [[self source] setOffset:offset];
        NSLog(@"%s : gt = %lf offset = %lf lt = %lf", __PRETTY_FUNCTION__, gt, offset, lt);
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BEDA_NOTI_SOURCE_OFFSET_CHANGED
         object:nil];
    } else {
        [plotHeader reloadData];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"channelCurrentTimeUpdate"
         object:self];
    }
    
    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CPTPlotDataSource functions
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    // If plot is header plot
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_HEADER_PLOT])
    {
        return [self numberOfRecordsForHeaderPlot];
    }
    
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_ANNOTATION_PLOT])
    {
        return [self numberOfRecordsForAnnotationPlot];
    }
    // Otherwise, plot it data plot
    
    return [[[self sourceTimeData] timedata] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    // If plot is header plot
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_HEADER_PLOT])
    {
        return [self numberForHeaderPlotField:fieldEnum recordIndex:index];
    }
    
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_ANNOTATION_PLOT])
    {
        return [self numberForAnnotationPlotField:fieldEnum recordIndex:index];
    }
    
    int key = [self channelIndex];
    // Otherwise, plot it data plot
    NSMutableArray* data = [[self sourceTimeData] timedata];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [[data objectAtIndex:index] objectForKey:[NSNumber numberWithInt:0]];
        case CPTScatterPlotFieldY:
            return [[data objectAtIndex:index] objectForKey:[NSNumber numberWithInt:key]];
        default:
            return nil;
    }
}


@end
