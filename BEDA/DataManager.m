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

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self setMovie1:Nil];
    [self setMovie2:Nil];

}

@end
