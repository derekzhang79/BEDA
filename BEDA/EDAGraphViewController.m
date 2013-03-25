//
//  GraphViewController.m
//  BEDA
//
//  Created by Jennifer Kim on 2/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "EDAGraphViewController.h"

@implementation EDAGraphViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    // If you make sure your dates are calculated at noon, you shouldn't have to
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSDate *refDate       = [NSDate dateWithNaturalLanguageString:@"12:00:00"];
    //    NSTimeInterval oneDay = 24 * 60 * 60;
    NSTimeInterval oneSec = 1.0;
  
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow       = 0.0f;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 60.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(3.0)];
    
    plotSpace.allowsUserInteraction = YES;
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneSec * 5000.0f)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(3.0)];
    
    CPTMutableTextStyle *axisTextStyle = [CPTTextStyle textStyle];
    axisTextStyle.fontSize = 10.0;
    
//    // Grid line styles
//    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
//    majorGridLineStyle.lineWidth = 0.75;
//    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
//    
//    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
//    minorGridLineStyle.lineWidth = 0.25;
//    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
//    
//    NSNumberFormatter *labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
//    labelFormatter.maximumFractionDigits = 0;
//    
//    // Axes
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
//    CPTXYAxis *x          = axisSet.xAxis;
//    
//    x.labelingPolicy     = CPTAxisLabelingPolicyAutomatic;
//    x.majorGridLineStyle = majorGridLineStyle;
//    x.minorGridLineStyle = minorGridLineStyle;
//    x.labelFormatter     = labelFormatter;
//
//    x.majorIntervalLength         = CPTDecimalFromFloat(oneSec * 10);
//    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
//    x.minorTicksPerInterval       = 1;
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
//
//    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
//    timeFormatter.referenceDate = refDate;
//    x.labelFormatter            = timeFormatter;
//    x.labelTextStyle = axisTextStyle;
//    
//    CPTXYAxis *y = axisSet.yAxis;
//    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
//    y.majorIntervalLength         = CPTDecimalFromString(@"0.5");
//    y.minorTicksPerInterval       = 0.5;
//    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
////    y.title = @"EDA";
////    y.titleLocation =  CPTDecimalFromInteger(0);
//    y.labelTextStyle = axisTextStyle;
//    
//    // Add an extra y axis (red)
//    // We add constraints to this axis below
//    CPTXYAxis *y2 = [[(CPTXYAxis *)[CPTXYAxis alloc] initWithFrame:CGRectZero] autorelease];
//    y2.axisConstraints = [CPTConstraints constraintWithLowerOffset:410];
//    
//    y2.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
//    y2.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
//    y2.labelOffset                 = 10.0;
//    y2.coordinate                  = CPTCoordinateY;
//    y2.plotSpace                   = graph.defaultPlotSpace;
//    
//    CPTMutableLineStyle* y2Style = [CPTMutableLineStyle lineStyle];
//    y2Style.lineWidth = 2.0;
//    y2Style.lineColor = [CPTColor redColor];
//    
//    y2.axisLineStyle = y2Style;
//    y2.majorTickLineStyle          = nil;
//    y2.minorTickLineStyle          = nil;
//    y2.labelTextStyle              = nil;
//    //y2.title = @"EDA";
//    //y2.titleLocation =  CPTDecimalFromInteger(0);
//    // Set axes
//    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, y2, nil];
//    
//    
//    // Create a plot that uses the data source method
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
    

    // Adjust the panel size
    //[view setFrameSize:NSSizeFromString(@"{1800,225}")];
    
    // Register self as notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSensorDataLoaded:)
                                                 name:@"sensorDataLoaded" object:Nil];
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [[[dm sensor1] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:0]];
        case CPTScatterPlotFieldY:
            return [[[dm sensor1] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:1]];
        default:
            return nil;
    }
}

@end
