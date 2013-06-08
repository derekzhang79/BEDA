//
//  SourceMovie.m
//  BEDA
//
//  Created by Jennifer Kim on 6/7/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "SourceMovie.h"
#import "ChannelMovie.h"

@implementation SourceMovie

- (void)loadFile:(NSURL*)url {
    NSLog(@"%s: Load URL %@ ", __PRETTY_FUNCTION__, url);
    
    // Create only one channel for SourceMovie
    ChannelMovie* ch = [[ChannelMovie alloc] init];
    [ch setSource:self];
    [ch loadFile:url];
    
    [[self channels] addObject:ch];
    
    NSLog(@"%s: channels.size() = %lu ", __PRETTY_FUNCTION__, (unsigned long)[[self channels] count]);

}


@end
