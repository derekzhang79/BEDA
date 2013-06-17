//
//  GraphSettingController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "GraphSettingController.h"

@implementation GraphSettingController

- (IBAction)getGraphColor:(id)sender{
    NSColor *color  = [graphColor color];
    NSLog(@"%s, Graph color name %@", __PRETTY_FUNCTION__, color);
    
}

- (IBAction)getAreaColor:(id)sender{
    NSColor *color  = [areaColor color];
    NSLog(@"%s, aREA color name %@", __PRETTY_FUNCTION__, color);
    
}


@end
