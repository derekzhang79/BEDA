//
//  IntervalPlayerManager.m
//  BEDA
//
//  Created by Sehoon Ha on 7/9/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "IntervalPlayerManager.h"
#import "BedaController.h"

@implementation IntervalPlayerManager

@synthesize isFastMode;
@synthesize ffInterval;
@synthesize normalInterval;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setFfInterval:10];
        [self setNormalInterval:2];
        [self setFastPlayRate:4.0];
        
        [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                  target:self
                                                selector:@selector(onPlayTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
    return self;
}

- (BedaController*) beda {
    return [BedaController getInstance];
}

- (BOOL)isTimeInFastMode {
    int total_seconds = (int)[[self beda] gtAppTime];
    int duration = [self ffInterval] + [self normalInterval];
//    NSLog(@"total_seconds: %d and duration: %d, (%d/%d)", total_seconds, duration, [self ffInterval], [self normalInterval]);

    if (total_seconds % duration < [self ffInterval]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)onPlayTimer : (id)sender {
//   NSLog(@"%s : %d", __PRETTY_FUNCTION__, [self isFastMode]);
    if ([self isTimeInFastMode]) {
        [[[self beda] playButton] setIntValue:1];
        [self setIsFastMode:YES];
    } else {
        [[[self beda] playButton] setIntValue:0];
        [self setIsFastMode:NO];
    }
    
    if ([[self beda] isPlaying] && [self prevIsFastMode] != [self isFastMode]) {
        [[self beda] stop:self];
        NSLog(@"%s : stop (prev = %d, now = %d)", __PRETTY_FUNCTION__, [self prevIsFastMode], [self isFastMode]);

    }
    
    [self setPrevIsFastMode:[self isFastMode]];
    
    
}

@end
