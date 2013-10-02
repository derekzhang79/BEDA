//
//  Channel.m
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "Channel.h"

@implementation Channel

@synthesize source = _source;
@synthesize view = _view;
@synthesize offsetOverlay = _offsetOverlay;
@synthesize name;
@synthesize btnOrderUp;
@synthesize btnOrderDn;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setSource:nil];
        
        [self setBtnOrderUp:Nil];
        [self setBtnOrderDn:Nil];
        
        ///////////////////////////
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onPlay:)
                                                     name:BEDA_NOTI_CHANNEL_PLAY
                                                   object:nil];
        
        ///////////////////////////
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onFastPlay:)
                                                     name:BEDA_NOTI_CHANNEL_FASTPLAY
                                                   object:nil];

         ///////////////////////////
         [[NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(onStop:)
                                                      name:BEDA_NOTI_CHANNEL_STOP
                                                    object:nil];
        
    }
    
    return self;
}

- (BedaController*) beda {
    return [BedaController getInstance];
}

- (void)clearControls {
    [self setOffsetOverlay:Nil];
    [self setBtnOrderUp:Nil];
    [self setBtnOrderDn:Nil];
}

- (void)adjustControlPositions {
    NSSize sz = [self view].frame.size;
    
    if ([self offsetOverlay] != Nil) {
        NSTextField* overlay = [self offsetOverlay];
        NSSize my = overlay.frame.size;
        overlay.frame = CGRectMake(sz.width - my.width - 10, sz.height - my.height - 10, my.width, my.height);

    }
    if ([self btnOrderUp] != Nil) {
        NSButton* btn = [self btnOrderUp];
        btn.frame = CGRectMake(sz.width - 20, 50, 20, 20);
    }
    
    if ([self btnOrderDn] != Nil) {
        NSButton* btn = [self btnOrderDn];
        btn.frame = CGRectMake(sz.width - 20, 30, 20, 20);
    }
}

- (void)play {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
    
}

- (void)fastplay {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
    
}


- (void)stop {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
}

- (void)zoomIn {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
    
}

- (void)zoomOut {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
}

- (double) getMyTimeInLocal {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
    return 0;
}


- (double) getMyTimeInGlobal {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
    return 0;
}

- (void) setMyTimeInGlobal:(double)gt {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);

}

- (double) getGlobalTime {
    return [[[self source] beda] getGlobalTime];
}

- (BOOL) isNavMode {
    return [[[self source] beda] isNavMode];
}

- (double) offset {
    if ([self source] == nil) {
        return 0.0;
    }
    return [[self source] offset];
}

- (double) projoffset {
    if ([self source] == nil) {
        return 0.0;
    }
    return [[self source] projoffset];
}


- (double) localToGlobalTime:(double)lt {
    return lt - [self offset] - [self projoffset];

}

- (double) globalToLocalTime:(double)gt {
    return gt + [self offset] + [self projoffset];
}

- (double) windowHeightFactor {
    return 1.0;
}

- (void) updateAnnotation {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
}

- (void) createOffsetOverlay {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return;
    
    if ([self offsetOverlay] != Nil) {
        return;
    }
    // Overlay window
    NSTextField* overlay = [[NSTextField alloc] init];
    overlay.frame = CGRectMake(10, 10, 100, 30);
    [overlay setAllowsEditingTextAttributes:NO];
    [overlay setEditable:NO];
    [overlay setBordered:NO];
    overlay.backgroundColor = [NSColor yellowColor];
    if ([[self beda] isNavMode]) {
        overlay.alphaValue = 0.0f;
    } else {
        overlay.alphaValue = 1.0f;
    }
    [overlay setStringValue:@"default"];
    [[self view] addSubview:overlay positioned:NSWindowAbove relativeTo:nil];
    
    [self setOffsetOverlay:overlay];
    
}

- (void) createButtons {
    NSSize sz = [self view].frame.size;
    if ([self btnOrderUp] == Nil) {
        NSButton* btn = [[NSButton alloc] init];
        btn.frame = CGRectMake(sz.width - 20, 50, 20, 20);
        btn.alphaValue = 0.9;
        [btn setTitle:@"UP"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"up" ofType:@"png"];
        NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
        [img setSize:btn.frame.size];
        [btn setImage:img];
        
        [[self view] addSubview:btn positioned:NSWindowAbove relativeTo:nil];
        [self setBtnOrderUp:btn];
        
        [btn setTarget:self];
        [btn setAction:@selector(onBtnUp:)];
    }
    
    if ([self btnOrderDn] == Nil) {
        NSButton* btn = [[NSButton alloc] init];
        btn.frame = CGRectMake(sz.width - 20, 30, 20, 20);
        btn.alphaValue = 0.9;
        [btn setTitle:@"DN"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"];
        NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
        [img setSize:btn.frame.size];
        [btn setImage:img];
        
        [[self view] addSubview:btn positioned:NSWindowAbove relativeTo:nil];
        [self setBtnOrderDn:btn];
        
        [btn setTarget:self];
        [btn setAction:@selector(onBtnDn:)];
    }
}

- (IBAction)onBtnUp:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

- (IBAction)onBtnDn:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (void) showOffsetOverlay {
    if ([self offsetOverlay] == Nil) {
        [self createOffsetOverlay];
    }
    [self offsetOverlay].alphaValue = 1.0f;
    [self updateOffsetOverlay];
 
    
    [self createButtons];
    if ([self btnOrderUp]) {
        [self btnOrderUp].alphaValue = 1.0f;
    }
    if ([self btnOrderDn]) {
        [self btnOrderDn].alphaValue = 1.0f;
    }
    
//    [self btnOrderUp].frame = CGRectMake(sz.width - my.width - 60, sz.height - my.height - 10, my.width, my.height);
}

- (void) hideOffsetOverlay {
    if ([self offsetOverlay] == Nil) {
        [self createOffsetOverlay];
    }
    [self offsetOverlay].alphaValue = 0.0f;
    [self updateOffsetOverlay];
    
    
    [self createButtons];
    if ([self btnOrderUp]) {
        [self btnOrderUp].alphaValue = 0.0f;
    }
    if ([self btnOrderDn]) {
        [self btnOrderDn].alphaValue = 0.0f;
    }

}

- (void) onPlay:(NSNotification *) notification {
    Channel* ch = (Channel*)[notification object];
    if (self == ch) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self play];
}

- (void) onFastPlay:(NSNotification *) notification {
    Channel* ch = (Channel*)[notification object];
    if (self == ch) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self fastplay];
}

- (void) onStop:(NSNotification *) notification {
    
    
    Channel* ch = (Channel*)[notification object];
    if (self == ch) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self stop];
}


- (void) updateOffsetOverlay {
    if ([self offsetOverlay] == Nil) {
        return;
    }
    if ([[[self source] beda]isMultiProjectMode]) {
        NSString* theProjName = [[[self source] projname] lastPathComponent];
        if ([[[self offsetOverlay] stringValue] isEqualToString:theProjName]) {
            return;
        }
        
    }
    NSTextField* overlay = [self offsetOverlay];
    NSSize sz = [self view].frame.size;
    NSSize my = overlay.frame.size;
    overlay.frame = CGRectMake(sz.width - my.width - 10, sz.height - my.height - 10, my.width, my.height);
//    NSLog(@"sz = %@ my = %@ frame = %@", NSStringFromSize(sz), NSStringFromSize(my), NSStringFromRect(overlay.frame));

    
//    NSLog(@"%@: overlay.frame.size = %@", [[self source] projname ], NSStringFromSize(overlay.frame.size) );
    if ([[[self source] beda]isMultiProjectMode] ){

        NSString* theProjName = [[[self source] projname] lastPathComponent];
        overlay.backgroundColor = [[self source] projcolor];
        
        [[self offsetOverlay] setStringValue:theProjName];
    } else {
        [[self offsetOverlay] setStringValue:[NSString stringWithFormat:@"%lf", [self offset]]];
    }
}


@end
