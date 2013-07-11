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

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);

        
        ///////////////////////////
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChannelHeadMoved:)
                                                     name:BEDA_NOTI_CHANNEL_HEAD_MOVED
                                                   object:nil];
        
    }
    
    return self;
}


- (void)loadFile:(NSURL*)url {
    NSLog(@"%s: Load URL %@ ", __PRETTY_FUNCTION__, url);
    
    [self setFilename:[url absoluteString]];
    
    // Create only one channel for SourceMovie
    ChannelMovie* ch = [[ChannelMovie alloc] init];
    [ch setSource:self];
    [ch loadFile:url];
    
    [[self channels] addObject:ch];
    
    NSLog(@"%s: channels.size() = %lu ", __PRETTY_FUNCTION__, (unsigned long)[[self channels] count]);

    [self setName:@"SourceMovie"];

}


///////////////////////////////////////////////////////////////////////////////////////////
- (void) onChannelHeadMoved:(NSNotification *) notification {
    if ([ [self beda] isNavMode] == YES) {
        return;
    }
    if ([notification object] == Nil) {
        return;
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    ChannelMovie* ch = (ChannelMovie*)[notification object];
    
    if (self != [ch source]) {
        return;
    }
    
    double gt = [[self beda] gtAppTime];
    double lt = [ch getMyTimeInLocal];
    // gt + offset = lt
    [self setOffset:lt - gt];
    //    NSLog(@"gt = %lf lt = %lf offset = %lf", gt, lt, [self offset]);
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////

- (double)duration {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([[self channels] count] > 0) {
        ChannelMovie* ch = [[self channels] objectAtIndex:0];
        return [ch duration];
    }
    return 0.0;
}

@end
