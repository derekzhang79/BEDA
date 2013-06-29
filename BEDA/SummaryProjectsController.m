//
//  SummaryProjectsController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/28/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "SummaryProjectsController.h"

@implementation SummaryProjectsController

@synthesize graph;
@synthesize plotXData;
@synthesize plotYData;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    graphview.hostedGraph = [self graph];
    plotXData =  [[NSMutableArray alloc] initWithObjects:@"03/05.csv", @"A", @"B", @"C", @"D", @"E", nil];
    plotYData =  [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:20],
                              [NSNumber numberWithInt:50],
                              [NSNumber numberWithInt:30],
                              [NSNumber numberWithInt:70],
                              [NSNumber numberWithInt:85],
                              nil];
    
    [self initGraph];
    
}

-(void)reloadGraph{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Setting X-Axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    
//    NSMutableArray* test =  [[NSMutableArray alloc] initWithObjects:@"HAHA", @"HOHO", @"B", @"C", @"D", @"E", nil];
//    [self setPlotXData:test];
    
    // Use custom x-axis label so it will display product A, B, C... instead of 1, 2, 3, 4
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:[plotXData count]];
    int idx = 0;
    for (NSString *product in plotXData)
    {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:product textStyle:x.labelTextStyle];
        label.tickLocation = CPTDecimalFromInt(idx);
        label.offset = 5.0f;
        [labels addObject:label];
        [label release];
        idx++;
    }
    x.axisLabels = [NSMutableSet setWithArray:labels];
    

    [graph reloadData];
//    [x setAxisLabels:[NSSet setWithArray:test]];
   // x.axisLabels = ;

}

- (void)initGraph{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super awakeFromNib];
    
    // If you make sure your dates are calculated at noon, you shouldn't have to
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSTimeInterval aProject = 1;
    
    // Create graph from theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    graph.plotAreaFrame.paddingTop = 5.0f;
    graph.plotAreaFrame.paddingRight = 0.0f;
    graph.plotAreaFrame.paddingLeft = 57.0f;
    graph.plotAreaFrame.paddingBottom = 20.0f;
    
    graph.paddingRight = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    
    // Setup scatter plot space
    plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    
    int min = 0;
    int max = 100;
    double len = max - min;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(6)];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(aProject * 5000.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(len)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(len)];
    
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
    
    // Setting X-Axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.title = @"Project Name";
    x.titleOffset = 30.0f;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.labelExclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(6) length:CPTDecimalFromInt(1)], nil];
    
    // Use custom x-axis label so it will display product A, B, C... instead of 1, 2, 3, 4
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:[plotXData count]];
    int idx = 0;
    for (NSString *product in plotXData)
    {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:product textStyle:x.labelTextStyle];
        label.tickLocation = CPTDecimalFromInt(idx);
        label.offset = 5.0f;
        [labels addObject:label];
        [label release];
        idx++;
    }
    x.axisLabels = [NSMutableSet setWithArray:labels];
    [labels release];
    
   
    // Setting up y-axis
	CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromInt(1000);
    y.minorTicksPerInterval = 0;
    y.minorGridLineStyle = nil;
    y.title = @"Cost Per Unit";
    y.labelExclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(0)], nil];
    

    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
    
    // Create a plot that uses the data source method
    dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Date Plot";
    
    // Actual graph line & fill
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth              = 1.f;
    y.title = @"Day View Graph";
    lineStyle.lineColor              = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    graphview.hostedGraph = graph;
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{


    return [plotXData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
        // Otherwise, plot it data plot
        switch (fieldEnum) {
            case CPTScatterPlotFieldX:
                return [NSNumber numberWithInt:(int)index];
            case CPTScatterPlotFieldY:
                return [plotYData objectAtIndex:index];
        }
    return nil;
}

@end
