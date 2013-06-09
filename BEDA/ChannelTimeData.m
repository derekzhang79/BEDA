//
//  ChannelTimeData.m
//  BEDA
//
//  Created by Jennifer Kim on 6/8/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelTimeData.h"

@implementation ChannelTimeData

- (SourceTimeData*) sourceTimeData {
    return (SourceTimeData*)[self source];
}


- (void)initGraph {
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
    
    // Add some padding to the graph, with more at the bottom for axis labels.
    graph.plotAreaFrame.paddingTop = 5.0f;
    graph.plotAreaFrame.paddingRight = 0.0f;
    graph.plotAreaFrame.paddingBottom = 20.0f;
    graph.plotAreaFrame.paddingLeft = 57.0f;
    
    graph.paddingRight = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    
////    hostView.hostedGraph = graph;
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow       = 0.0f;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 60.0f)];
    //////////////////////////////////////////////////////////////////////yRange should be dfferent
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5.0)];
    
    plotSpace.allowsUserInteraction = YES;
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 5000.0f)];
    //////////////////////////////////////////////////////////////////////yRange should be dfferent
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5.0)];
    
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
    y.title = @"Accel";
    y.titleOffset = 35;
    
    // Add an extra y axis (red)
    // We add constraints to this axis below
    CPTXYAxis *y2 = [[(CPTXYAxis *)[CPTXYAxis alloc] initWithFrame:CGRectZero] autorelease];

    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, y2, nil];
    
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Date Plot";
    
    //////////////////////////////////////////////////////////////////////color should be different
    //CPTFill *areaFill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0f green:0.0f blue:0.0f alpha:0.2f]];
    //dataSourceLinePlot.areaFill      = areaFill;
    dataSourceLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth              = 1.f;
    lineStyle.lineColor              = [CPTColor redColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Create a header plot
    [self createHeaderPlot];
    
//    // Register self as notification observer
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSensorDataLoaded:)
//                                                 name:@"sensorDataLoaded" object:Nil];
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

- (void)createMovieViewFor:(BedaController*)beda {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Create a movie view
    QTMovieView* view = [[QTMovieView alloc] init];
    NSArray* v = [[beda movSplitView] subviews];
    NSView* lastView = [v lastObject];
    NSSplitView* movSplitView = [beda movSplitView];
    
    [movSplitView addSubview:view positioned:NSWindowAbove relativeTo:lastView];
    [beda spaceEvenly:movSplitView];
    
    [view setPreservesAspectRatio:YES];
    [view setMovie:[self movie]];
}

- (void)createEDAViewFor:(BedaController*)beda {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CPTGraphHostingView* view = [[CPTGraphHostingView alloc] init];
    view.hostedGraph = graph;
    
    NSSplitView* splitview = [beda getSplitView];
    CPTGraphHostingView* lastView = [ [splitview subviews] lastObject];
    
    [splitview addSubview:view positioned:NSWindowAbove relativeTo:lastView];
    

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HeaderPlot functions
- (void)createHeaderPlot {
    // Create header plot
    plotHeader = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    plotHeader.identifier = BEDA_INDENTIFIER_HEADER_PLOT;
    plotHeader.dataSource = self;
    plotHeader.delegate = self;
    
    // Set the style
    // 1. SavingPlotLine style
    CPTColor *headerPlotColor = [CPTColor orangeColor];
    CPTMutableLineStyle *savingsPlotLineStyle = [CPTMutableLineStyle lineStyle];
    savingsPlotLineStyle.lineColor = headerPlotColor;
    
    // 2. Symbol style
    CPTPlotSymbol *headerPlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    headerPlotSymbol.fill = [CPTFill fillWithColor:headerPlotColor];
    headerPlotSymbol.lineStyle = savingsPlotLineStyle;
    headerPlotSymbol.size = CGSizeMake(5.0f, 5.0f);
    plotHeader.plotSymbol = headerPlotSymbol;

    // 3. DataLineStyle
    CPTMutableLineStyle *headerLineStyle = [CPTMutableLineStyle lineStyle];
    headerLineStyle.lineColor = [CPTColor orangeColor];
    headerLineStyle.lineWidth = 2.0f;
    plotHeader.dataLineStyle = headerLineStyle;

    // Add the plot to the graph
    [graph addPlot:plotHeader];
}

-(NSUInteger)numberOfRecordsForHeaderPlot {
    return 5;
}

-(NSNumber *)numberForHeaderPlotField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    double px[6] = {0.0, -0.5, 0.5, 0.0, 0.0, 0.0};
    double py[6] = {4.0, 4.8, 4.8, 4.0, 0.2, 0.0};
    double t = 20.0;
    
    if (fieldEnum == CPTScatterPlotFieldX) {
        // Returns X values
//        return [NSNumber numberWithDouble:20];
        return [NSNumber numberWithDouble: (px[index] + t) ];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        // Returns Y values
        return [NSNumber numberWithDouble: (py[index]) ];
        //        switch(index) {
//            case 0:
//                return [NSNumber numberWithDouble:0.5];
//            case 1:
//                return [NSNumber numberWithDouble:4.5];
//            default:
//                return nil;
//        }
    } else {
        // Invalid fieldEnum: Should not be reached, probably
        return nil;
    }
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
    
    // Otherwise, plot it data plot
    NSMutableArray* data = [[self sourceTimeData] timedata];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [[data objectAtIndex:index] objectForKey:[NSNumber numberWithInt:0]];
        case CPTScatterPlotFieldY:
            return [[data objectAtIndex:index] objectForKey:[NSNumber numberWithInt:3]];
        default:
            return nil;
    }
}


@end
