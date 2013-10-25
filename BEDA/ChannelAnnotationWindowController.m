//
//  ChannelAnnotationWindowController.m
//  BEDA
//
//  Created by Jennifer Kim on 7/29/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelAnnotationWindowController.h"

#import "ChannelAnnotation.h"
#import "ChannelAnnotationManager.h"

@implementation ChannelAnnotationWindowController

@synthesize annot;
@synthesize manager;
@synthesize annottext;
@synthesize duration;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (IBAction)onApply:(id)sender {
    
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, [annottext stringValue] );
    [[self annot] setText:[annottext stringValue]];
    [[self annot] setDuration: [duration doubleValue]];
    [[[self manager] annots] addObject:[self annot]];
    [[self manager] makeVisible:[self annot]];
    [[[self manager] plot] reloadData];
    [self close];

}

@end
