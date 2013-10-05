//
//  ChannelExtraGraph.m
//  BEDA
//
//  Created by Sehoon Ha on 10/5/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelExtraGraph.h"
#import "BedaController.h"
#import "ChannelTimeData.h"

@implementation ChannelExtraGraph

@synthesize channel;
@synthesize plot;
@synthesize data = _data;

- (id) initWithChannel:(ChannelTimeData*) ch asColor:(NSColor*)nscolor{
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setChannel:ch];
        [self initPlotAsColor:nscolor];
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) initPlotAsColor:(NSColor*)nscolor{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Create header plot
    CPTScatterPlot* p = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    p.identifier = BEDA_INDENTIFIER_EXTRA_PLOT;
    p.dataSource = self;
    p.delegate = self;
    
    // Set the style
    CPTColor *color = [[self channel] toCPT:nscolor];
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 2.0f;
    lineStyle.lineColor = color;
    
    p.dataLineStyle = lineStyle;
    
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
