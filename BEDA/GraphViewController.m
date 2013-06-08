//
//  GraphViewController.m
//  BEDA
//
//  Created by Jennifer Kim on 3/24/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "GraphViewController.h"

@implementation GraphViewController

-(void)dealloc
{
    [graph release];
    [super dealloc];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    // If you make sure your dates are calculated at noon, you shouldn't have to
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSDate *refDate       = [NSDate dateWithNaturalLanguageString:@"12:00:00"];
    NSTimeInterval oneSec = 1;
    
    // Create graph from theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    
    // Add some padding to the graph, with more at the bottom for axis labels.
    graph.plotAreaFrame.paddingTop = 6.0f;
    graph.plotAreaFrame.paddingRight = 0.0f;
    graph.plotAreaFrame.paddingBottom = 5.0f;
    graph.plotAreaFrame.paddingLeft = 57.0f;
    
    graph.paddingRight = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    
    hostView.hostedGraph = graph;
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow       = 0.0f;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 60.0f)];
    //////////////////////////////////////////////////////////////////////yRange should be dfferent
    //plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5.0)];
    
    plotSpace.allowsUserInteraction = YES;
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 5000.0f)];
    //////////////////////////////////////////////////////////////////////yRange should be dfferent
    //plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5.0)];
    
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    textStyle.fontSize = 12;
    textStyle.fontName = @"Helvetica";
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.15];
    
    NSNumberFormatter *labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    labelFormatter.maximumFractionDigits = 0;
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    CPTXYAxis *x         = axisSet.xAxis;
    x.labelingPolicy     = CPTAxisLabelingPolicyAutomatic;
    x.majorGridLineStyle = majorGridLineStyle;
    x.axisLineStyle      = majorGridLineStyle;
    x.labelFormatter     = labelFormatter;
    x.majorIntervalLength         = CPTDecimalFromFloat(oneSec * 10);
    x.minorTicksPerInterval       = 1;
    
    //////////////////////////////////////////////////////////////////////xOrthogonal coordinate decimal should be set to starting y range
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter            = timeFormatter;
    x.labelTextStyle = textStyle;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    y.axisLineStyle = majorGridLineStyle;
    //////////////////////////////////////////////////////////////////////yRange should be dfferent
    //y.labelFormatter = labelFormatter;
    y.majorIntervalLength         = CPTDecimalFromString(@"1.0");
    //y.minorTicksPerInterval       = 0.1;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
    y.labelTextStyle = textStyle;
    y.titleTextStyle = textStyle;
    y.titleOffset = 35;
    
    
    // Add an extra y axis (red)
    // We add constraints to this axis below
    CPTXYAxis *y2 = [[(CPTXYAxis *)[CPTXYAxis alloc] initWithFrame:CGRectZero] autorelease];
    // Set axes
    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, y2, nil];
    
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Date Plot";
    
    //////////////////////////////////////////////////////////////////////color should be different
    
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth              = 1.f;
    lineStyle.lineColor              = [CPTColor redColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Register self as notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSensorDataLoaded:)
                                                 name:@"sensorDataLoaded" object:Nil];
}

- (void) reload {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //    NSTimeInterval oneSec = 1.0;
    //    double maxTime = [dm getMaximumTime];
    //    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    //    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(oneSec * maxTime)];
    
    //    int newSize = 25 * maxTime;
    //    if (newSize > 3000) {
    //        newSize = 3000;
    //    }
    //    int HEIGHT = view.frame.size.height;
    //    NSString* szString = [NSString stringWithFormat:@"{%d,%d}", newSize, HEIGHT];
    //    NSLog(@"new szString = %@", szString);
    //    [view setFrameSize:NSSizeFromString(szString)];
    
    
    [graph reloadData];
    
}

- (void) onSensorDataLoaded:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self reload];
}

- (void) setCPTHostView:(CPTGraphHostingView *)_view {
    hostView = _view;
}

- (void) setDM:(DataManager*)_dm {
    dm = _dm;
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [[dm sensor1] count];
}

//////////////////////////////////////////////////////////////////////number for plot should be dfferent
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [[[dm sensor1] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:0]];
        case CPTScatterPlotFieldY:
            return [[[dm sensor1] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:4]];
        default:
            return nil;
    }
}
@end
