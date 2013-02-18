//
//  DataManager.m
//  BEDA
//
//  Created by Jennifer Kim on 2/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize movie1;
@synthesize movie2;
// @synthesize sensor1 = _sensor1;
- (id) init
{
    self = [super init];
    if(self) {
        sensor1 = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self setMovie1:Nil];
    [self setMovie2:Nil];
    // sensor1 = [NSMutableArray array];
    
    // [[self getSensor1] addObject:@"test"];
    NSLog(@"sensor1.count = %ld", (unsigned long)[sensor1 count]);

}

- (NSMutableArray*) getSensor1 {
    return sensor1;
}


@end
