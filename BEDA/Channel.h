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

- (void)play;
- (void)stop;

- (double) getMyTimeInGlobal;
- (void) setMyTimeInGlobal:(double)gt;

- (double) getGlobalTime;
- (BOOL) isNavMode;
- (double) offset;
- (double) localToGlobalTime:(double)lt;
- (double) globalToLocalTime:(double)gt;

@end
