//
//  IntervalPlayerManager.m
//  BEDA
//
//  Created by Jennifer Kim on 7/9/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "IntervalPlayerManager.h"
#import "BedaController.h"

@implementation IntervalPlayerManager

@synthesize isFastMode;
@synthesize ffInterval;
@synthesize normalInterval;
@synthesize imageFastPlay;
@synthesize imagePlay;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setFfInterval:9];
        [self setNormalInterval:1];
        [self setFastPlayRate:4.0];
        
        [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                  target:self
                                                selector:@selector(onPlayTimer:)
                                                userInfo:nil
                                                 repeats:YES];
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"ff" ofType:@"png"];
            NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
            [self setImageFastPlay:img];
        }
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"];
            NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
            [self setImagePlay:img];
        }
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
        [self setIsFastMode:YES];
    } else {
        [self setIsFastMode:NO];
    }
    
    if ([[self beda] isIntervalFastPlayMode]) {
        if ([[[self beda] playButton] image] != [self imageFastPlay]) {
            NSLog(@"%s : update to FastPlay image", __PRETTY_FUNCTION__);
            [[[self beda] playButton] setImage:[self imageFastPlay]];
        }
    } else {
        if ([[[self beda] playButton] image] != [self imagePlay]) {
            NSLog(@"%s : update to Play image", __PRETTY_FUNCTION__);
            [[[self beda] playButton] setImage:[self imagePlay]];
        }
    }

    if ([[self beda] isPlaying] && [[self beda] isIntervalPlayerVisible] && [self prevIsFastMode] != [self isFastMode]) {
        NSLog(@"%s : stop (prev = %d, now = %d)", __PRETTY_FUNCTION__, [self prevIsFastMode], [self isFastMode]);
        [[self beda] stop:self];

    }
    
    [self setPrevIsFastMode:[self isFastMode]];
    
    
}

@end
