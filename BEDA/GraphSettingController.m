//
//  GraphSettingController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "GraphSettingController.h"

@implementation GraphSettingController
//@synthesize graphName;
//@synthesize graphType;
//@synthesize minY;
//@synthesize maxY;

- (NSColor*)getGraphColor{
    NSColor *color  = [graphColor color];
    NSLog(@"%s, Graph color name %@", __PRETTY_FUNCTION__, color);
    return color;
    
}

- (NSColor*)getAreaColor{
    NSColor *color  = [areaColor color];
    NSLog(@"%s, aREA color name %@", __PRETTY_FUNCTION__, color);
    return color;
}

- (NSString*)getGraphName{
    return [graphName stringValue];
}

- (double)getMinValue{
    return [minValue doubleValue];
}

- (double)getMaxValue{
    return [maxValue doubleValue];
}

@end
