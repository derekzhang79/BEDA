//
//  ChannelExtraGraph.m
//  BEDA
//
//  Created by Jennifer Kim on 10/5/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelExtraGraph.h"
#import "BedaController.h"
#import "ChannelTimeData.h"

@implementation ChannelExtraGraph

@synthesize channel;
@synthesize plot;
@synthesize data = _data;

- (id) initWithChannel:(ChannelTimeData*) ch asLineColor:(NSColor*)nsLinecolor asAreaColor:(NSColor*)nsAreacolor{
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setChannel:ch];
        [self initPlotAsColor:nsLinecolor asAreaColor:nsAreacolor];
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) initPlotAsColor:(NSColor*)nsLinecolor asAreaColor:(NSColor*)nsAreacolor{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Create header plot
    CPTScatterPlot* p = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    p.identifier = BEDA_INDENTIFIER_EXTRA_PLOT;
    p.dataSource = self;
    p.delegate = self;
    
    // Set the style
    CPTColor *linecolor = [[self channel] toCPT:nsLinecolor];
    CPTColor *areacolor = [[self channel] toCPT:nsAreacolor];
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 1.0f;
    lineStyle.lineColor = linecolor;
    
    p.dataLineStyle = lineStyle;
    CPTFill *areaFill = [CPTFill fillWithColor:areacolor];
    p.areaFill = areaFill;
    p.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    
    [self setPlot:p];

    // Add the plot to the graph
    [[[self channel] getGraph] addPlot:p];
}

- (void)reload {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[self plot] reloadData];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CPTPlotDataSource functions
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSUInteger n = [[self data] count];
    NSUInteger rate = [[self channel] samplingRate];
    NSUInteger ret =  n / rate;
    
    NSLog(@"%s : %ld (%ld / %ld)", __PRETTY_FUNCTION__, ret, n, rate);
    return ret;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSUInteger index2 = index * [[self channel] samplingRate];
   
    if (fieldEnum == CPTScatterPlotFieldX) {
        NSMutableArray* srcdata = [[[self channel] sourceTimeData] timedata];
        if (index2 >= [srcdata count]) {
            return nil;
        }
        return [[srcdata objectAtIndex:index2] objectForKey:[NSNumber numberWithInt:0]];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        if (index2 >= [[self data] count]) {
            return nil;
        }
        return [[self data] objectAtIndex:index2];
    }
    return nil;
}


@end
