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

#define BEDA_INDENTIFIER_DATA_PLOT @"BedaDataPlot"
#define BEDA_INDENTIFIER_HEADER_PLOT @"BedaHeaderPlot"
#define BEDA_INDENTIFIER_SELECT_PLOT @"BedaSelectPlot"

#define BEDA_NOTI_SOURCE_OFFSET_CHANGED @"BedaNotiSourceOffsetChanged"

@class AnnotViewController;
@class ChannelSelector;

@interface ChannelTimeData : Channel<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate>  {
    CPTXYGraph *graph;
    CPTXYPlotSpace *plotSpace;
    CPTScatterPlot *dataSourceLinePlot;
    CPTScatterPlot *plotHeader;
    CPTPlotSpaceAnnotation *symbolTextAnnotation;
//    CPTScatterPlot *plotAnnotation;
    
    int graphScaleX;
    int graphScaleY;
    NSColor* lineColor;
    NSColor* areaColor;

}

@property (assign) int channelIndex;
@property (assign) BOOL isHeaderSelected;
@property (assign) double headerTime;
@property (assign) double minValue;
@property (assign) double maxValue;
@property (assign) double rate;
@property (retain) NSTimer* playTimer;
@property (retain) NSDate* playBase;
@property (retain) NSMutableArray* arrayPlotAnnots;
@property (retain) AnnotViewController* annotViewController;
@property (retain) ChannelSelector* channelSelector;

@property (assign) IBOutlet NSPopover* popover;
- (IBAction)showInfoPopover:(id)sender;


- (SourceTimeData*) sourceTimeData;
- (CPTXYGraph*) getGraph;
- (void)initGraph:(NSString*)name atIndex:(int)index range:(double)min to:(double)max withLineColor:(NSColor*)lc areaColor:(NSColor*)ac isBottom:(BOOL)isBottom hasArea:(BOOL)hasArea;
- (void)createGraphViewFor:(BedaController*)beda;

- (CPTColor*) toCPT:(NSColor*)nc;

// Play/stop
- (void)play;
- (void)fastplay;
- (void)stop;
- (void)onPlayTimer : (id)sender;

- (void)zoomIn;
- (void)zoomOut;


- (double) getMyTimeInLocal;
- (double) getMyTimeInGlobal;
- (void) setMyTimeInGlobal:(double)gt;
- (double) windowHeightFactor;

- (void) onSourceOffsetUpdated:(NSNotification*) noti;
- (void) updateAnnotation;

// Header related functions
- (void)createHeaderPlot;
- (void)selectHeaderPlot;
- (void)deselectHeaderPlot;
-(NSUInteger)numberOfRecordsForHeaderPlot;
-(NSNumber *)numberForHeaderPlotField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;

// Change style
- (void)setLineColor:(NSColor*)lc;
- (void)setAreaColor:(NSColor*)ac;
- (NSColor*)getLineColor;
- (NSColor*)getAreaColor;
- (void)setGraphName:(NSString*)gName;
- (void)setRangeFrom:(double)min to:(double)max;

//
- (BOOL)isSelectedTime:(double)t;

@end
