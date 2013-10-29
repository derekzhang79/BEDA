//
//  ChannelAnnotationManager.h
//  BEDA
//
//  Created by Jennifer Kim on 7/15/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "ChannelAnnotation.h"

@class ChannelTimeData;

@interface ChannelAnnotationManager : NSObject<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate> {
    
}

@property (assign) ChannelTimeData* channel;
@property (assign) CPTScatterPlot* plot;
@property (retain) NSMutableArray* annots;

@property (nonatomic, retain) IBOutlet NSTextField* annottext;
@property (nonatomic, retain) IBOutlet NSTextField* duration;

- (id) initWithChannel:(ChannelTimeData*) ch;

- (ChannelAnnotation*) addSingleAt:(double)t as:(NSString*)text;
- (ChannelAnnotation*) addDoubleAt:(double)t during:(double)dur as:(NSString*)text;
- (void) makeVisible:(ChannelAnnotation*)annot;



@end
