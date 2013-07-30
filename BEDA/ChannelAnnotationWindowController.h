//
//  ChannelAnnotationWindowController.h
//  BEDA
//
//  Created by Sehoon Ha on 7/29/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChannelAnnotation;

@interface ChannelAnnotationWindowController : NSWindowController {
    
}

@property (assign) ChannelAnnotation* annot;
@property (nonatomic, retain) IBOutlet NSTextField* annottext;

- (IBAction)onApply:(id)sender;


@end
