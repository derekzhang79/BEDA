//
//  Channel.m
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "Channel.h"

@implementation Channel

@synthesize source = _source;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setSource:nil];
    }
    
    return self;
}

- (void)play {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
    
}

- (void)stop {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
}

- (double) getMyTimeInGlobal {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
    return 0;
}

- (void) setMyTimeInGlobal:(double)gt {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);

}

- (double) getGlobalTime {
    return [[[self source] beda] getGlobalTime];
}

- (BOOL) isNavMode {
    return [[[self source] beda] isNavMode];
}

- (double) offset {
    if ([self source] == nil) {
        return 0.0;
    }
    return [[self source] offset];
}

- (double) localToGlobalTime:(double)lt {
    return lt - [self offset];

}

- (double) globalToLocalTime:(double)gt {
    return gt + [self offset];
}

@end
