//
//  ChannelTimeData.h
//  BEDA
//
//  Created by Jennifer Kim on 6/8/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import "SourceTimeData.h"
#import <CorePlot/CorePlot.h>

#define BEDA_INDENTIFIER_HEADER_PLOT @"BedaHeaderPlot"

@interface ChannelTimeData : Channel<CPTPlotDataSource>  {
    CPTXYGraph *graph;
    CPTScatterPlot *plotHeader;

}


- (SourceTimeData*) sourceTimeData;
- (void)initGraph;
- (void)createEDAViewFor:(BedaController*)beda;

// Header related functions
- (void)createHeaderPlot;
-(NSUInteger)numberOfRecordsForHeaderPlot;
-(NSNumber *)numberForHeaderPlotField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;


@end
