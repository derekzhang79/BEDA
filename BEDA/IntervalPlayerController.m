//
//  IntervalPlayerController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/25/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "IntervalPlayerController.h"
#import "BedaController.h"
#import "IntervalPlayerManager.h"

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

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [txtFFInterval setIntValue:[[self ipm] ffInterval]];
    [txtNormalInterval setIntValue:[[self ipm] normalInterval]];
    [cmbFastPlayRate setDoubleValue:[[self ipm] fastPlayRate]];
    [chkMute setIntValue:0];
}

- (IntervalPlayerManager*)ipm {
    return [[BedaController getInstance] intervalPlayerManager];
}

- (IBAction)closeMyCustomSheet: (id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [[self ipm] setFfInterval:[txtFFInterval intValue]];
    [[self ipm] setNormalInterval:[txtNormalInterval intValue]];
    [[self ipm] setFastPlayRate:[cmbFastPlayRate doubleValue]];

    
    [NSApp endSheet:[self mywindow]];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[self mywindow] orderOut:self];
}

@end
