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

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setSource:nil];
    }
    
    return self;
}

- (void)play {
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

- (double) localToGlobalTime:(double)lt {
    return lt - [self offset];

}

- (double) globalToLocalTime:(double)gt {
    return gt + [self offset];
}

- (double) windowHeightFactor {
    return 1.0;
}

- (void) updateAnnotation {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);
}

- (void) createOffsetOverlay {
    if ([self offsetOverlay] != Nil) {
        return;
    }
    // Overlay window
    NSTextField* overlay = [[NSTextField alloc] init];
    overlay.frame = CGRectMake(10, 10, 80, 20);
    
    overlay.backgroundColor = [NSColor yellowColor];
    overlay.alphaValue = 0.5f;
    [overlay setStringValue:@"default"];
    [[self view] addSubview:overlay positioned:NSWindowAbove relativeTo:nil];
    
    [self setOffsetOverlay:overlay];
    
}

- (void) showOffsetOverlay {
    if ([self offsetOverlay] == Nil) {
        [self createOffsetOverlay];
    }
    [self offsetOverlay].alphaValue = 1.0f;
    [self updateOffsetOverlay];
    
}

- (void) hideOffsetOverlay {
    if ([self offsetOverlay] == Nil) {
        [self createOffsetOverlay];
    }
    [self offsetOverlay].alphaValue = 0.0f;
    [self updateOffsetOverlay];
}

- (void) updateOffsetOverlay {
    if ([self offsetOverlay] == Nil) {
        return;
    }
    NSTextField* overlay = [self offsetOverlay];
    NSSize sz = [self view].frame.size;
    NSSize my = overlay.frame.size;
    overlay.frame = CGRectMake(sz.width - my.width - 10, sz.height - my.height - 10, my.width, my.height);

    NSLog(@"overlay.frame.size = %@", NSStringFromSize(overlay.frame.size) );

    [[self offsetOverlay] setStringValue:[NSString stringWithFormat:@"%lf", [self offset]]];
}


@end
