//
//  Source.m
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "Source.h"

@implementation Source

@synthesize beda;
@synthesize channels = _channels;
@synthesize offset;
@synthesize behavs = _annots;
@synthesize name;
@synthesize filename;
@synthesize projname;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _channels = [[NSMutableArray alloc] init];
        _annots = [[BehaviorManager alloc] init];
        [[self behavs] createDefaultBehaviors];
        
        [self setName:@""];
        [self setFilename:@""];
        [self setProjname:@""];
        
        [self setOffset:0.0];
        [self setProjoffset:0.0];
    }
    
    return self;
}

- (void)loadFile:(NSURL*)url {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);

}

- (BOOL)exportSelection {
    NSLog(@"%s: %@ : Do NOTHING", __PRETTY_FUNCTION__, [self filename]);
    return NO;
}

- (double)duration {
    NSLog(@"%s: %@ : Do NOTHING", __PRETTY_FUNCTION__, [self filename]);
    return 0.0;
}

- (BOOL)deleteChannel:(id)ch {
    int prevCnt = (int)[[self channels] count];
    [[self channels] removeObject:ch];
    int nowCnt = (int)[[self channels] count];
    NSLog(@"%s: %d -> %d", __PRETTY_FUNCTION__, prevCnt, nowCnt);

    return YES;
}


@end
