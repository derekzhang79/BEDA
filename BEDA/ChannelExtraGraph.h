//
//  ChannelExtraGraph.h
//  BEDA
//
//  Created by Sehoon Ha on 10/5/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@class ChannelTimeData;

@interface ChannelExtraGraph : NSObject<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate> {
    
}

- (id) initWithChannel:(ChannelTimeData*) ch asLineColor:(NSColor*)nscolor asAreaColor:(NSColor*)nscolor;
- (void)reload;

@property (assign) ChannelTimeData* channel;
@property (assign) CPTScatterPlot* plot;
@property (retain) NSMutableArray* data;

@end
