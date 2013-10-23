//
//  ChannelAnnotationWindowController.h
//  BEDA
//
//  Created by Sehoon Ha on 7/29/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChannelAnnotation;
@class ChannelAnnotationManager;


@interface ChannelAnnotationWindowController : NSWindowController {
    
}

@property (assign) ChannelAnnotation* annot;
@property (assign) ChannelAnnotationManager* manager;

@property (nonatomic, retain) IBOutlet NSTextField* annottext;
@property (nonatomic, retain) IBOutlet NSTextField* duration;
@property (nonatomic, retain) IBOutlet NSComboBox *annottype;

- (IBAction)onApply:(id)sender;


@end
