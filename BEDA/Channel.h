//
//  Channel.h
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Source.h"

@interface Channel : NSObject {
    
}

@property (assign) Source* source;
@property (assign) NSView* view;
@property (assign) NSTextField* offsetOverlay;

- (void)play;
- (void)stop;

- (void)zoomIn;
- (void)zoomOut;

- (double) getMyTimeInGlobal;
- (void) setMyTimeInGlobal:(double)gt;

- (double) getGlobalTime;
- (BOOL) isNavMode;
- (double) offset;
- (double) localToGlobalTime:(double)lt;
- (double) globalToLocalTime:(double)gt;

- (double) windowHeightFactor;
- (void) updateAnnotation;

- (void) createOffsetOverlay;
- (void) showOffsetOverlay;
- (void) hideOffsetOverlay;
- (void) updateOffsetOverlay;


@end
