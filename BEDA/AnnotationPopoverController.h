//
//  AnnotationPopoverController.h
//  BEDA
//
//  Created by Sehoon Ha on 10/28/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChannelAnnotation;
@class ChannelAnnotationManager;

@interface AnnotationPopoverController : NSViewController {
    
}
@property (assign) IBOutlet NSPopover *popover;
@property (assign) IBOutlet NSTextField *txtAnnotation;
@property (assign) IBOutlet NSTextField *txtDuration;

@property (assign) ChannelAnnotation* annot;
@property (assign) ChannelAnnotationManager* manager;

- (IBAction)onButtonRemove:(id)sender;
- (IBAction)onButtonApply:(id)sender;

-(void) setAnnot:(ChannelAnnotation*)ca andManager:(ChannelAnnotationManager*)ma;


@end
