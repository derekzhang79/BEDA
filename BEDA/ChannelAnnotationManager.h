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
//@interface ChannelAnnotion : NSObject {
//}
//
//- (id) initAtTime:(double) _t withText:(NSString*) _text;
//- (id) initAtTime:(double) _t during:(double)_duration withText:(NSString*) _text;
//
//@property double t;
//@property double duration;
//@property (copy) NSString* text;
//@property (assign) IBOutlet NSTextField* annotationtext;
//
//- (BOOL) isSingle;
//
//@end

@interface ChannelAnnotationManager : NSObject<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate> {
    
}

@property (assign) ChannelTimeData* channel;
@property (assign) CPTScatterPlot* plot;
@property (retain) NSMutableArray* annots;

- (id) initWithChannel:(ChannelTimeData*) ch;

- (ChannelAnnotation*) addSingleAt:(double)t as:(NSString*)text;
- (ChannelAnnotation*) addDoubleAt:(double)t during:(double)dur as:(NSString*)text;
- (void) makeVisible:(ChannelAnnotation*)annot;



@end
