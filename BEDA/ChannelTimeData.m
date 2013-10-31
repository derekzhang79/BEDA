//
//  ChannelTimeData.m
//  BEDA
//
//  Created by Jennifer Kim on 6/8/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelTimeData.h"
#import "BehaviorManager.h"
#import "Behavior.h"
#import "AnnotViewController.h"
#import "ChannelSelector.h"
#import "ChannelAnnotationManager.h"
#import "ChannelAnnotationWindowController.h"
#import "AnnotationPopoverController.h"

@implementation ChannelTimeData

@synthesize lineColor = _lineColor;
@synthesize areaColor = _areaColor;
@synthesize channelIndex;
@synthesize isHeaderSelected;
@synthesize headerTime;
@synthesize playTimer = _playTimer;
@synthesize playBase = _playBase;
@synthesize arrayPlotAnnots = _arrayPlotAnnots;
@synthesize annotViewController = _annotViewController;
@synthesize minValue;
@synthesize maxValue;
@synthesize channelSelector = _channelSelector;
@synthesize samplingRate;
@synthesize extraGraphs = _extraGraphs;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _arrayPlotAnnots = [[NSMutableArray alloc] init];
        _annotViewController = Nil;
        _channelSelector = Nil;
        [[[self beda] channelsTimeData] addObject:self];
        _extraGraphs = [[NSMutableArray alloc] init];

    }
    return self;
    
}

- (SourceTimeData*) sourceTimeData {
    return (SourceTimeData*)[self source];
}

- (CPTXYGraph*) getGraph {
    return graph;
}

- (CPTXYPlotSpace*) getPlotSpace {
    return plotSpace;
}


- (IBAction)onBtnUp:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableArray* channels = [[self beda] channelsTimeData];
    NSUInteger index = [channels indexOfObject:self];
    if (index == 0) {
        NSLog(@"%s failed: already at the top", __PRETTY_FUNCTION__);
        return;
    }
    ChannelTimeData* temp = [channels objectAtIndex:index - 1];
    [channels replaceObjectAtIndex:index - 1 withObject:self];
    [channels replaceObjectAtIndex:index withObject:temp];
    [[self beda] createViewsForAllChannels];
}

- (IBAction)onBtnDn:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableArray* channels = [[self beda] channelsTimeData];
    NSUInteger index = [channels indexOfObject:self];
    if (index == [channels count] - 1) {
        NSLog(@"%s failed: already at the bottom", __PRETTY_FUNCTION__);
        return;
    }
    ChannelTimeData* temp = [channels objectAtIndex:index + 1];
    [channels replaceObjectAtIndex:index + 1 withObject:self];
    [channels replaceObjectAtIndex:index withObject:temp];
    [[self beda] createViewsForAllChannels];
}

- (void)initGraph:(NSString*)name atIndex:(int)index range:(double)min to:(double)max withLineColor:(NSColor*)lc areaColor:(NSColor*)ac isBottom:(BOOL)isBottom hasArea:(BOOL)hasArea {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setChannelIndex:index];
    [self setPlayTimer:Nil];
    [self setPlayBase:Nil];
    [self setMinValue:min];
    [self setMaxValue:max];
    [self setRate:1.0];
    [self setSamplingRate:[self calcSamplingRate]];
    [self setLineColor:lc];
    [self setAreaColor:ac];
    
    [super awakeFromNib];
    
    // If you make sure your dates are calculated at noon, you shouldn't have to
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSDate *refDate       = [NSDate dateWithNaturalLanguageString:@"00:00"];
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
    
//    lineColor = lc;
//    areaColor = ac;
    
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
    
    plotSpace.allowsUserInteraction = NO;
    plotSpace.delegate = self;
    
    NSTimeInterval xLow       = 0.0f;
    float xMax = (float)[[self sourceTimeData] maxTimeInSecond:0];
    double len = max - min;
    graphScaleX = 0.0f;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * xMax)];
//    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 5000.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(min) length:CPTDecimalFromFloat(len)];
//    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(min) length:CPTDecimalFromFloat(len)];

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
    
    x.labelingPolicy     = CPTAxisLabelingPolicyEqualDivisions;
//    x.labelingPolicy     =  CPTAxisLabelingPolicyFixedInterval;
    x.preferredNumberOfMajorTicks = 12;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
    x.axisLineStyle = majorGridLineStyle;
    x.labelFormatter     = labelFormatter;
    x.labelTextStyle = titleText;
    
    x.majorIntervalLength         = CPTDecimalFromFloat(oneSec * 180);
    //////////////////////////////////////////////////////////////////////xOrthogonal coordinate decimal should be set to starting y range
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(min);
    x.minorTicksPerInterval       = 1;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.timeStyle = kCFDateFormatterShortStyle;
    
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter            = timeFormatter;
    x.labelTextStyle = titleText;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    if ( [self channelIndex] >= 0) {  // If channelIndex is -1 (less than zero), it means this is annotation channel
        y.majorIntervalLength         = CPTDecimalFromString(@"1.0");
        y.minorTicksPerInterval       = 0.5;
        y.labelTextStyle = titleText;

    } else {
        y.majorIntervalLength         = CPTDecimalFromString(@"5.0");
        y.minorTicksPerInterval       = 5.0;
        
        CPTMutableTextStyle *invisible = [CPTMutableTextStyle textStyle];
        invisible.color = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        invisible.fontSize = 12;
        invisible.fontName = @"Helvetica";
        y.labelTextStyle = invisible;
    }
    y.axisLineStyle = majorGridLineStyle;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
    y.titleTextStyle = titleText;
    y.titleOffset = 35;
    
    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
    
    // Create a plot that uses the data source method
    dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = BEDA_INDENTIFIER_DATA_PLOT;
    
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
    
    ///////////////////////////
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelHeadMoved:)
                                                 name:BEDA_NOTI_CHANNEL_HEAD_MOVED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAnnotationChanged:)
                                                 name:BEDA_NOTI_ANNOTATION_CHANGED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onViewUpdated:)
                                                 name:BEDA_NOTI_VIEW_UPDATE
                                               object:nil];
    
    // Register self as notification observer
    [self reload];
    // Create a header plot
    [self createHeaderPlot];
    // For selecting data range
    ChannelSelector* cs = [[ChannelSelector alloc] initWithChannel:self];
    [self setChannelSelector:cs];
    
    
    if ( [self channelIndex] < 0) {  // If channelIndex is -1 (less than zero), it means this is annotation channel
        [self createAnnotationPlot];
    }
    
    // For Channel Annotation
    [self setChannelAnnotationManager:
     [[ChannelAnnotationManager alloc] initWithChannel:self]
     ];
    
    
}

- (void)applyLineColor:(NSColor*)lc {
    _lineColor                        = lc;

    // Actual graph line & fill
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth              = 1.f;
    lineStyle.lineColor              = [self toCPT:lc];
    dataSourceLinePlot.dataLineStyle = lineStyle;
}

- (void)applyAreaColor:(NSColor*)ac {
    _areaColor = ac;

    // Actual graph line & fill
    CPTFill *areaFill = [CPTFill fillWithColor:[self toCPT:ac]];
    dataSourceLinePlot.areaFill      = areaFill;
    dataSourceLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
}

- (void)setGraphName:(NSString*)gName {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Actual graph line & fill
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *y = axisSet.yAxis;
    y.title = gName;
}

- (void)setRangeFrom:(double)min to:(double)max{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    double len = max - min;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(min) length:CPTDecimalFromFloat(len)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(min) length:CPTDecimalFromFloat(len)];
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(min);
    
    [self setMinValue:min];
    [self setMaxValue:max];
    
}

- (void)makeRelativeMode {
    NSDate* basedate = [NSDate dateWithNaturalLanguageString:@"00:00"];
    NSLog(@"basedate = %@", basedate);
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    if ([[self beda] duration] > 3600) {
        [dateFormatter setDateFormat: @"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat: @"mm:ss"];
    }

    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = basedate;
    x.labelFormatter = timeFormatter;
    
    [plotHeader reloadData];
   
}

- (void)makeAbsoluteMode {
    NSDate* basedate = [[self sourceTimeData] basedate];
    NSLog(@"basedate = %@", basedate);
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = basedate;
    x.labelFormatter = timeFormatter;
    [plotHeader reloadData];

}

- (void) reload {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([[self beda] isAbsoulteTimeMode]) {
        [self makeAbsoluteMode];
    } else {
        [self makeRelativeMode];

    }
    
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

-(void) adjustAnnotationPlotRange {
    BehaviorManager* am = [[self source] annots];
    [am updateUsedIndexes];

    float top = [am countUsedBehaviors];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0)
                                                    length:CPTDecimalFromFloat(top + 1.0)];
}

-(void) updateAnnotation {
    if ([self channelIndex] >= 0) {
        return;
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self adjustAnnotationPlotRange];

    for (CPTScatterPlot* plot in [self arrayPlotAnnots]) {
        NSLog(@"%s : %@", __PRETTY_FUNCTION__, (NSString*)plot.identifier);
        [plot reloadData];
    }
    
    if ([self annotViewController] != Nil) {
        NSLog(@"%s : reload annotationTableView", __PRETTY_FUNCTION__);

        [[self annotViewController] reloadTableView];
    }
}

- (void)createGraphViewFor:(BedaController*)beda {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self channelIndex] < 0) {
        AnnotViewController* avc = [ [AnnotViewController alloc]
                                    initWithNibName:@"AnnotView" bundle:nil];
        [avc setGraph:graph];
        [avc setSource:[self sourceTimeData]];
        NSView* view = [avc view];
        [self setAnnotViewController:avc];
        
        
        NSSplitView* splitview = [beda getSplitView];
        CPTGraphHostingView* lastView = [ [splitview subviews] lastObject];
        
        [splitview addSubview:view positioned:NSWindowAbove relativeTo:lastView];
        [self setView:view];
    } else {
        CPTGraphHostingView* view = [[CPTGraphHostingView alloc] init];
        view.hostedGraph = graph;

        NSSplitView* splitview = [beda getSplitView];
        CPTGraphHostingView* lastView = [ [splitview subviews] lastObject];

        [splitview addSubview:view positioned:NSWindowAbove relativeTo:lastView];
        
        [self setView:view];
    }
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


- (BOOL)isSelectedTime:(double)t {
    if (t < [[self channelSelector] left]) return NO;
    if (t > [[self channelSelector] right]) return NO;
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////
- (void) onChannelHeadMoved:(NSNotification *) notification {
    [self updateOffsetOverlay];
    Channel* ch = (Channel*)[notification object];
    
    if (self == ch) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);

    double gt = [[[self source] beda] gtAppTime];
    [self setMyTimeInGlobal:gt];
}

- (void) onAnnotationChanged:(NSNotification *) notification {
    if ([self channelIndex] >= 0) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self clearAnnotationPlot];
    [self createAnnotationPlot];
    [self updateAnnotation];

}

- (int)calcSamplingRate {
    double viewLength = [[self beda] gtViewRight] - [[self beda] gtViewLeft];
    int newRate = 1;
    if (viewLength < 120) {
        newRate = 1;
    } else  {
        newRate = round(viewLength / 120.0);
    }
    return newRate;
}

- (void) onViewUpdated:(NSNotification *) notification {
    double l = [[self beda] gtViewLeft];
    double r = [[self beda] gtViewRight];
    NSLog(@"%s : {%lf, %lf}", __PRETTY_FUNCTION__, l, r);

    if (l > r) {
        double temp = l;
        l = r;
        r = temp;
    }
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(l) length:CPTDecimalFromFloat(r - l)];
    int newRate = [self calcSamplingRate];

    NSLog(@"%s: samplingRate %d -> %d", __PRETTY_FUNCTION__, [self samplingRate], newRate);

    if (newRate != [self samplingRate]) {
        NSLog(@"%s: reload data plot", __PRETTY_FUNCTION__);
        [dataSourceLinePlot reloadData];
    }
    [self setSamplingRate:newRate];

    
    
}


///////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Play/stop
- (void)play {
    if ([[self beda] isMultiProjectMode] == NO && [self isNavMode] == NO && [[self beda] isIntervalPlayerVisible] == NO) {
        NSLog(@"%s : graph only plays in Navigation Mode", __PRETTY_FUNCTION__);
        return;
    }
    NSTimer* _timer = [self playTimer];
    if (_timer == nil)
    {
        [self setRate:1.0];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                  target:self
                                                selector:@selector(onPlayTimer:)
                                                userInfo:nil
                                                 repeats:YES];
        [self setPlayTimer:_timer];
        double playoffset = -[self rate] * [self headerTime];
        NSDate* clickedTime = [NSDate date];
        NSDate* adjustedTime = [clickedTime dateByAddingTimeInterval:playoffset];
        [self setPlayBase:adjustedTime];
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }
}

- (void)fastplay {
    if ([self isNavMode] == NO && [[self beda] isIntervalPlayerVisible] == NO) {
        NSLog(@"%s : graph only plays in Navigation Mode", __PRETTY_FUNCTION__);
        return;
    }
    NSTimer* _timer = [self playTimer];
    if (_timer == nil)
    {
        [self setRate:[[[self beda] intervalPlayerManager] fastPlayRate]];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                  target:self
                                                selector:@selector(onPlayTimer:)
                                                userInfo:nil
                                                 repeats:YES];
        [self setPlayTimer:_timer];
        double playoffset = -[self headerTime] / [self rate];
        NSDate* clickedTime = [NSDate date];
        NSDate* adjustedTime = [clickedTime dateByAddingTimeInterval:playoffset];
        [self setPlayBase:adjustedTime];
        NSLog(@"%s: rate = %lf", __PRETTY_FUNCTION__, [[[self beda] intervalPlayerManager] fastPlayRate]);
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

// newHeader = (now - clicked) + originalHeader
// == newHeader = (now - (clicked - originalHeader) )

// newHeader = rate * (now - clicked) + original
// == newHeader = rate * (now - (clicked - original / rate))
- (void)onPlayTimer : (id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    double t = -[self rate] * [[self playBase] timeIntervalSinceNow];
    
    [self setHeaderTime:t];
    
    [plotHeader reloadData];
    [self updateOffsetOverlay];

}

-(void)zoomIn{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    graphScaleX -= 100;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:plotSpace.xRange.location length:CPTDecimalFromFloat(graphScaleX)];

}

-(void)zoomOut{
    graphScaleX += 100;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:plotSpace.xRange.location length:CPTDecimalFromFloat(graphScaleX)];
}

- (double) getMyTimeInLocal {
    return [self headerTime];
}


- (double) getMyTimeInGlobal {
    double ltSeconds = [self headerTime];
    double gtSeconds = [self localToGlobalTime:ltSeconds];
    return gtSeconds;
}

- (void) setMyTimeInGlobal:(double)gt {
    double lt = [self globalToLocalTime:gt];
    NSLog(@"name: %@ lt = %lf gt = %lf", [self name], lt, gt);
    [self setHeaderTime:lt];
    [plotHeader reloadData];
}

- (double) windowHeightFactor {
    switch ([self channelIndex]) {
        case -1:
            return 2.0;
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
    selectedLineStyle.lineWidth = 2.0f;
    
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

-(CPTScatterPlot*) getPlotHeader {
    return plotHeader;
}


-(NSUInteger)numberOfRecordsForHeaderPlot {
    return 2;
}

-(NSNumber *)numberForHeaderPlotField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
//    double minY = 0.1;
//    double maxY = 4.9;
    double minY = [self minValue] + 0.1;
    double maxY = [self maxValue] - 0.1;

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

-(void) clearAnnotationPlot {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (CPTScatterPlot* plot in [self arrayPlotAnnots]) {
        NSLog(@"%s : %@", __PRETTY_FUNCTION__, (NSString*)plot.identifier);
        [graph removePlot:plot];
    }
    [[self arrayPlotAnnots] removeAllObjects];
}

-(void) createAnnotationPlot{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    for (Behavior* beh in [[[self source] annots] behaviors]) {
        // Create header plot
        CPTScatterPlot* plotAnnotation = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
        plotAnnotation.identifier = [beh name];
        plotAnnotation.dataSource = self;
        plotAnnotation.delegate = self;

        
        // Set the style
        // 1. SavingPlotLine style
        CPTColor *headerPlotColor = [self toCPT:[beh color]];
        
        CPTMutableLineStyle *annotationLineStyle = [CPTMutableLineStyle lineStyle];
        annotationLineStyle.lineWidth = 0.0f;
        
        // 2. Symbol style
        CPTPlotSymbol *headerPlotSymbol = [CPTPlotSymbol rectanglePlotSymbol];
        headerPlotSymbol.fill = [CPTFill fillWithColor:headerPlotColor];
        headerPlotSymbol.lineStyle = annotationLineStyle;

        headerPlotSymbol.size = CGSizeMake(6.0f, 13.0f);
        plotAnnotation.plotSymbol = headerPlotSymbol;
        
        
        plotAnnotation.dataLineStyle = annotationLineStyle;
        
        // Add the plot to the graph
        [graph addPlot:plotAnnotation];
        [[self arrayPlotAnnots] addObject:plotAnnotation];
    }
    [self adjustAnnotationPlotRange];
}

-(NSUInteger)numberOfRecordsForAnnotationPlot:(CPTPlot *)plot {

    BehaviorManager* am = [[self source] annots];
    Behavior* beh = [am behaviorByName:(NSString *)plot.identifier];
    
    if (beh == Nil) {
        return 0;
    }
    
    return [[beh times] count];
}

-(NSNumber *)numberForAnnotationPlot:(CPTPlot *)plot Field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    BehaviorManager* am = [[self source] annots];
    Behavior* beh = [am behaviorByName:(NSString *)plot.identifier];
    if (beh == Nil) {
        return nil;
    }
    
    if (fieldEnum == CPTScatterPlotFieldX) {
        // Returns X values
        return [[beh times] objectAtIndex:index];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        // Returns Y values
        return [NSNumber numberWithInt: [beh usedIndex] + 1];
    } else {
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

-(void)addAnnotation{
    
    ChannelAnnotation* ca = [[self channelAnnotationManager] addSingleAt:[self headerTime] as:@""];
    AnnotationPopoverController* apc = [[self beda] annotationPopoverController];
    [apc setAnnot:ca andManager:[self channelAnnotationManager]];
    
    // Show the popover
    double minvalue = [self minValue];
    double maxvalue = [self maxValue];
    double averagevalue = (minvalue + maxvalue) * 0.5;
    double pt[2];
    pt[0] = [ca t];
    pt[1] = averagevalue;
    CGPoint viewPoint = [[self getPlotSpace] plotAreaViewPointForDoublePrecisionPlotPoint:pt];
    NSPoint nspt = NSPointFromCGPoint(viewPoint);
    NSPoint nspt2 = [[self view] convertPoint:nspt toView:Nil];
    NSLog(@"viewPoint = %lf, %lf: nspt2 = %lf, %lf", viewPoint.x, viewPoint.y, nspt2.x, nspt2.y);
    
    float gap = graph.plotAreaFrame.paddingLeft;
    NSView* view = [[ [[self beda] getSplitView] subviews] objectAtIndex:0];
    NSRect rect = NSMakeRect(viewPoint.x + gap, viewPoint.y + 20, 2, 2);
    [[[self beda] popover] showRelativeToRect:rect ofView:view preferredEdge:NSMaxYEdge];
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)interactionPoint
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Restore the vertical line plot to its initial color.

    if ( [event clickCount] == 2 ) {
        NSLog(@"%@", @"double clicked");
        [self addAnnotation];

    }
    
    for (ChannelTimeData* ch in [[self source] channels]) {
        [ch deselectHeaderPlot];
    }
    [[self channelSelector] deselect];
    [[NSCursor arrowCursor] set];
    
    return YES;
}

- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_HEADER_PLOT])
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        for (ChannelTimeData* ch in [[self source] channels]) {
            [ch selectHeaderPlot];
        }
        
        
    } else if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_SELECT_PLOT]) {
        [[self channelSelector] select:index];
        
    } else if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_CHANNEL_ANNOT_PLOT]) {

        [[self channelSelector] select:index];
        
    } else if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_DATA_PLOT]) {

    } else {
       
        BehaviorManager* am = [[self source] annots];
        Behavior* beh = [am behaviorByName:(NSString *)plot.identifier];
        
        NSUInteger flags = [[NSApp currentEvent] modifierFlags];
        if ( (flags & NSCommandKeyMask) ) {
            NSLog(@"%s: Behavior is selected for REMOVAL", __PRETTY_FUNCTION__);
            [[beh times] removeObjectAtIndex:index];
            [self updateAnnotation];
        } else {
            NSLog(@"%s: Behavior is selected for relocating the header", __PRETTY_FUNCTION__);
            NSNumber* num = [[beh times] objectAtIndex:index];
            double x = [num doubleValue];
            [self setHeaderTime:x];
            [plotHeader reloadData];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:BEDA_NOTI_CHANNEL_HEAD_MOVED
             object:self];
        }
        

    }

    
   
}


- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point
{
    [[self channelSelector] plotSpace:space shouldHandlePointingDeviceDraggedEvent:event atPoint:point];
    
    if ([self isHeaderSelected]) {
        
        point.x -= graph.plotAreaFrame.paddingLeft;
        
        // Convert the touch point to plot area frame location
        CGPoint pointInPlotArea = [graph convertPoint:point toLayer:graph.plotAreaFrame];
        
        NSDecimal pt[2];
        [space plotPoint:pt forPlotAreaViewPoint:pointInPlotArea];
        
        
        double x = [[NSDecimalNumber decimalNumberWithDecimal:pt[0]] doubleValue];
        if(x < 0 ){
            x = 0;
        }
        
        if(x > [[self beda]duration] ){
            x = [[self beda]duration];
        }
        
        double y = [[NSDecimalNumber decimalNumberWithDecimal:pt[1]] doubleValue];
        NSLog(@"%s: %lf, %lf", __PRETTY_FUNCTION__, x, y);
        if ([self isHeaderSelected]) {
            [self setHeaderTime:x];
        }
        [[NSCursor closedHandCursor] set];
        
        [plotHeader reloadData];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BEDA_NOTI_CHANNEL_HEAD_MOVED
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
    } else if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_DATA_PLOT]) {
        if ([self channelIndex] < 0) {
            return 0; // This is annotation channel, so ignore all the data (We should ignore them)
        } else {
            NSUInteger numData = [[[self sourceTimeData] timedata] count];
            NSLog(@"Sampling Rate for Data = %d", [self samplingRate]);
          return numData / [self samplingRate];
        }
    } else if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_SELECT_PLOT]){
        return [[self channelSelector] numberOfRecords];

    } else {
        return [self numberOfRecordsForAnnotationPlot:plot];
    }
    // Otherwise, plot it data plot
    
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    // If plot is header plot
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_HEADER_PLOT]){
        return [self numberForHeaderPlotField:fieldEnum recordIndex:index];
    } else if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_DATA_PLOT]){
        int key = [self channelIndex];
        // Otherwise, plot it data plot
        NSUInteger index2 = index * [self samplingRate];
        NSMutableArray* data = [[self sourceTimeData] timedata];
        switch (fieldEnum) {
            case CPTScatterPlotFieldX:
                return [[data objectAtIndex:index2] objectForKey:[NSNumber numberWithInt:0]];
            case CPTScatterPlotFieldY:
                return [[data objectAtIndex:index2] objectForKey:[NSNumber numberWithInt:key]];
        }
        return nil;

    } else if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_SELECT_PLOT]){
        return [[self channelSelector] numberForField:fieldEnum recordIndex:index];
    } else {
        return [self numberForAnnotationPlot:plot Field:fieldEnum recordIndex:index];

    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_HEADER_PLOT]){
        double t = [self headerTime];
        t = round(t);
        
        if(index % 2 == 0){
            return nil;
        }

        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
        CPTXYAxis *x          = axisSet.xAxis;
        CPTTimeFormatter *timeFormatter = (CPTTimeFormatter *)x.labelFormatter;
        NSString * headerString = [timeFormatter stringFromNumber:[NSNumber numberWithDouble:t]];

        CPTTextLayer *textLayer = [CPTTextLayer layer];
        textLayer.text = headerString;
        CPTMutableTextStyle *labelTextStyle = [CPTMutableTextStyle textStyle];
        labelTextStyle.fontSize = 13;
        labelTextStyle.color = [CPTColor blackColor];
        textLayer.textStyle = labelTextStyle;
        textLayer.paddingBottom = 10.0;
        textLayer.paddingLeft = 50.0;

        return textLayer;
    }
    
    if ([(NSString *)plot.identifier isEqualToString:BEDA_INDENTIFIER_SELECT_PLOT]){
        double t;
        if(index > 1){
            t = [self channelSelector].right;
            t = round(t);
            if(index % 2 == 0){
                return nil;
            }
        } else {
            t = [self channelSelector].left;
            t = round(t);
            if(index % 2 == 1){
                return nil;
            }
        }
        
        
                
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
        CPTXYAxis *x          = axisSet.xAxis;
        CPTTimeFormatter *timeFormatter = (CPTTimeFormatter *)x.labelFormatter;
        NSString * headerString = [timeFormatter stringFromNumber:[NSNumber numberWithDouble:t]];
        
        
        CPTTextLayer *textLayer = [CPTTextLayer layer];
        textLayer.text = headerString;
        CPTMutableTextStyle *labelTextStyle = [CPTMutableTextStyle textStyle];
        labelTextStyle.fontSize = 13;
        labelTextStyle.color = [CPTColor blackColor];
        textLayer.textStyle = labelTextStyle;
        textLayer.paddingBottom = 10.0;
        textLayer.paddingLeft = 50.0;
        
        return textLayer;
    }
    
    return nil;
}

@end
