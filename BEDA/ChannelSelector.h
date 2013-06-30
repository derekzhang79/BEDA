//
//  ChannelSelector.h
//  BEDA
//
//  Created by Sehoon Ha on 6/29/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@class ChannelTimeData;

#define LEFT_SELECTED -1
#define RIGHT_SELECTED 1
#define NOT_SELECTED 0

@interface ChannelSelector : NSObject {
    
}

@property (assign) BOOL visible;
@property (assign) double left;
@property (assign) double right;
@property (assign) ChannelTimeData* channel;
@property (assign) CPTScatterPlot* plot;
@property (assign) int selection;

- (id) initWithChannel:(ChannelTimeData*) ch;

-(NSUInteger)numberOfRecords;
-(NSNumber *)numberForField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;

-(void)select:(NSUInteger)index;
-(void)deselect;
- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point;


@end
