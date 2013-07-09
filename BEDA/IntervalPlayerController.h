//
//  IntervalPlayerController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/25/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntervalPlayerController : NSWindowController  {
    IBOutlet NSButton *muteCheckBox;
    
    BOOL isFastMode;
    NSTimer *timerOnPlay;
    
    int ffRate;
    NSString *displayCurrentTime;
    BOOL isMuted;

}

@property (assign) NSWindow* mywindow;

@end
