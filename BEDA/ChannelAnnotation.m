//
//  ChannelAnnotationController.m
//  BEDA
//
//  Created by Jennifer Kim on 7/15/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelAnnotation.h"

@implementation ChannelAnnotation

@synthesize t;
@synthesize duration;
@synthesize text;
@synthesize isTextVisible;

- (id) initAtTime:(double) _t withText:(NSString*) _text {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setT:_t];
        [self setDuration:0.0];
        [self setText:_text];
        [self setIsTextVisible:NO];
    }
    return self;
}


- (id) initAtTime:(double) _t during:(double)_duration withText:(NSString*) _text {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setT:_t];
        [self setDuration:_duration];
        [self setText:_text];
        [self setIsTextVisible:NO];
    }
    return self;
}

- (BOOL) isSingle {
    if ([self duration] < 0.00001) {
        return YES;
    } else {
        return NO;
    }
}

@end
