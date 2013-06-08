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

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _channels = [[NSMutableArray alloc] init];
        [self setOffset:0.0];
    }
    
    return self;
}

- (void)loadFile:(NSURL*)url {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);

}

@end
