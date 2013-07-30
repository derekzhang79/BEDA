//
//  ChannelAnnotationController.h
//  BEDA
//
//  Created by Jennifer Kim on 7/15/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChannelTimeData;

@interface ChannelAnnotation : NSWindowController {
}

- (id) initAtTime:(double) _t withText:(NSString*) _text;
- (id) initAtTime:(double) _t during:(double)_duration withText:(NSString*) _text;

@property double t;
@property double duration;
@property (copy) NSString* text;
@property BOOL isTextVisible;
//@property (assign) IBOutlet NSTextField* annotationtext;

- (BOOL) isSingle;

@end
