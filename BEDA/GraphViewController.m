//
//  GraphViewController.m
//  BEDA
//
//  Created by Jennifer Kim on 2/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "GraphViewController.h"

@implementation GraphViewController

-(void)dealloc
{
    [plotData release];
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
    //    NSTimeInterval oneDay = 24 * 60 * 60;
    NSTimeInterval oneSec = 1.0;
    
    // Create graph from theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    
    // Add some padding to the graph, with more at the bottom for axis labels.
    graph.plotAreaFrame.paddingTop = 10.0f;
    graph.plotAreaFrame.paddingRight = 10.0f;
    graph.plotAreaFrame.paddingBottom = 25.0f;
    graph.plotAreaFrame.paddingLeft = 10.0f;
    
    hostView.hostedGraph = graph;
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow       = 0.0f;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 50.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(3.0)];
    
    plotSpace.allowsUserInteraction = YES;
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 5000.0f)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(3.0)];
    
    CPTMutableTextStyle *axisTextStyle = [CPTTextStyle textStyle];
    axisTextStyle.fontSize = 9.0;
    
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromFloat(oneSec);
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.minorTicksPerInterval       = 1;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.timeStyle = kCFDateFormatterLongStyle;
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter            = timeFormatter;
    x.labelTextStyle = axisTextStyle;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromString(@"0.5");
    y.minorTicksPerInterval       = 0.1;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(1.0);
    y.labelTextStyle = axisTextStyle;
    
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Date Plot";
    
    // Do a blue gradient
    CPTColor *areaColor1       = [CPTColor colorWithComponentRed:0 green:1.0 blue:0 alpha:0.8];
    CPTGradient *areaGradient1 = [CPTGradient gradientWithBeginningColor:areaColor1 endingColor:[CPTColor clearColor]];
    areaGradient1.angle = -90.0f;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
    dataSourceLinePlot.areaFill      = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    
    
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth              = 1.f;
    lineStyle.lineColor              = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Add some data
    NSMutableArray *newData = [NSMutableArray array];
    NSUInteger i;
    for ( i = 0; i < 30; i++ ) {
        NSTimeInterval x = oneSec * i;
        id y             = [NSDecimalNumber numberWithFloat:1.2 * rand() / (float)RAND_MAX + 1.2];
        [newData addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [NSDecimalNumber numberWithFloat:x], [NSNumber numberWithInt:CPTScatterPlotFieldX],
          y, [NSNumber numberWithInt:CPTScatterPlotFieldY],
          nil]];
    }
    plotData = newData;
    
    [view setFrameSize:NSSizeFromString(@"{900,225}")];
}

- (void) reload {
    NSLog(@"Reload");
    [graph reloadData];
//    [view setFrameSize:NSSizeFromString(@"{1000,225}")];

    NSLog(@"Reload OK");
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSLog(@"number?");
//    return 0;
    return [[dm getSensor1] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = [[[dm getSensor1] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    
    return num;
}

@end
