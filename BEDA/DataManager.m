//
//  DataManager.m
//  BEDA
//
//  Created by Jennifer Kim on 2/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "DataManager.h"
#import <CorePlot/CorePlot.h>

@implementation DataManager

@synthesize movie1;
@synthesize movie2;
@synthesize sensor1 = _sensor1;
@synthesize basedate;


- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self setMovie1:Nil];
    [self setMovie2:Nil];
    _sensor1 = [[NSMutableArray alloc] init];
}

-(double) getMaximumTime {
    NSUInteger n = [[self sensor1] count];
    NSDecimalNumber *num = [[[self sensor1] objectAtIndex:n-1] objectForKey:[NSNumber numberWithInt:(int)CPTScatterPlotFieldX]];
    return [num doubleValue];
}

@end
