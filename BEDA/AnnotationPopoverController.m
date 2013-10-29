//
//  AnnotationPopoverController.m
//  BEDA
//
//  Created by Sehoon Ha on 10/28/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "AnnotationPopoverController.h"
#import "BedaController.h"
#import "ChannelAnnotation.h"
#import "ChannelAnnotationManager.h"

@implementation AnnotationPopoverController

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)onButtonRemove:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[[self manager] annots] removeObject:[self annot]];
    [[[self manager] plot] reloadData];
    [[self popover] close];
}

- (IBAction)onButtonApply:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[self annot] setText:[[self txtAnnotation] stringValue]];
    [[self annot] setDuration: [[self txtDuration] doubleValue]];
    NSMutableArray* annots = [[self manager] annots];
    if ([annots containsObject:[self annot]] == NO) {
        [[[self manager] annots] addObject:[self annot]];
    }
    [[self manager] makeVisible:[self annot]];
    [[[self manager] plot] reloadData];

    [[self popover] close];
}

- (IBAction)onButtonClose:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[self popover] close];
}

-(void) setAnnot:(ChannelAnnotation*)ca andManager:(ChannelAnnotationManager*)ma {
    [self setAnnot:ca];
    [self setManager:ma];

    [[self txtAnnotation] setStringValue: [[self annot] text]];
    [[self txtDuration] setDoubleValue:[[self annot] duration]];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
