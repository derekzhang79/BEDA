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

@interface ChannelTimeData : Channel<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate>  {
    CPTXYGraph *graph;
    CPTXYPlotSpace *plotSpace;
    CPTScatterPlot *plotHeader;
    
    int graphScaleX;
    int graphScaleY;

}

@property (assign) int channelIndex;
@property (assign) BOOL isHeaderSelected;
@property (assign) double headerTime;

@property (retain) NSTimer* playTimer;
@property (retain) NSDate* playBase;


- (SourceTimeData*) sourceTimeData;
- (void)initGraph:(int)data;
- (void)createEDAViewFor:(BedaController*)beda;
- (void)createTempViewFor:(BedaController*)beda;
- (void)createAccelViewFor:(BedaController*)beda;


// Play/stop
- (void)play;
- (void)stop;
- (void)onPlayTimer : (id)sender ;

- (void)zoomIn;
- (void)zoomOut;

- (double) getMyTimeInGlobal;
- (void) setMyTimeInGlobal:(double)gt;
- (double) windowHeightFactor;

- (void) onDataChanged:(NSNotification*) noti;

// Header related functions
- (void)createHeaderPlot;
- (void)selectHeaderPlot;
- (void)deselectHeaderPlot;
-(NSUInteger)numberOfRecordsForHeaderPlot;
-(NSNumber *)numberForHeaderPlotField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;


@end
