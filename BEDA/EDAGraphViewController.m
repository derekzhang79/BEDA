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
    
    // Setup scatter plot space: yRange & yAxis title
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5.0)];
    
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5.0)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *y = axisSet.yAxis;
    y.title = @"EDA";
    
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Date Plot";
    
    // Actual graph line & fill
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth              = 1.f;
    lineStyle.lineColor              = [CPTColor colorWithComponentRed:0.50f green:0.67f blue:0.65f alpha:1.0f];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    CPTFill *areaFill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.50f green:0.67f blue:0.65f alpha:0.4f]];
    dataSourceLinePlot.areaFill      = areaFill;
    dataSourceLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    
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
