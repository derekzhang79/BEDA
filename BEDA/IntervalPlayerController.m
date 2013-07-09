//
//  IntervalPlayerController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/25/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "IntervalPlayerController.h"

@implementation IntervalPlayerController
- (id)initWithWindow:(NSWindow *)awindow
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    self = [super initWithWindow:awindow];
    if (self) {
        // Initialization code here.
        [self setMywindow:awindow];
    }
    
    return self;
}

- (IBAction)closeMyCustomSheet: (id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [NSApp endSheet:[self mywindow]];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[self mywindow] orderOut:self];
}

@end
