//
//  BedaController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "BedaController.h"


#import "SourceMovie.h"
#import "ChannelMovie.h"
#import "SourceTimeData.h"
#import "ChannelTimeData.h"


float BEDA_WINDOW_INITIAL_MOVIE_HEIGHT = 300;


@implementation BedaController

@synthesize sources = _sources;
@synthesize movSplitView = _movSplitView;
@synthesize isNavMode;
@synthesize gtAppTime;


- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _sources = [[NSMutableArray alloc] init];
    _movSplitView = Nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveChannelPlayed:)
                                                 name:@"channelPlay"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveChannelStoped:)
                                                 name:@"channelStop"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveChannelCurrentTimeUpdated:)
                                                 name:@"channelCurrentTimeUpdate"
                                               object:nil];
    
    [self navigate:nil];
    
}

- (NSSplitView*) getSplitView {
    return splitview;
}


- (IBAction)openFile:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Show the OpenPanel
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"mov", @"avi", @"mp4", @"csv", nil]];
    long tvarInt = [panel runModal];
    
    // If user cancels it, do NOT proceed
    if (tvarInt != NSOKButton) {
        NSLog(@"User cancel the open command");
        return;
    }
    
    // Get URL and extract the URL
    NSURL *url = [panel URL];
    NSString *ext = [[url path] pathExtension];
    NSLog(@"url = %@ [ext = %@]", url, ext);
    
    if ([ext isEqualToString:@"csv"]) {
        [self addSourceTimeData:url];
    } else {
        [self addSourceMov:url];
    }
}

- (IBAction)play:(id)sender {
    if ([self isNavMode] == NO) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            [ch play];
        }
    }
}

- (IBAction)stop:(id)sender {
    if ([self isNavMode] == NO) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            [ch stop];
        }
    }
}


-(IBAction)zoomIn:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            [ch zoomIn];
        }
    }

}


-(IBAction)zoomOut:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            [ch zoomOut];
        }
    }
}

- (IBAction)navigate:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setIsNavMode:YES];
    [modeSelector setSelectedSegment:0];

}

- (IBAction)synchronize:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setIsNavMode:NO];
    [modeSelector setSelectedSegment:1];
}

- (IBAction)changeModeFromSegmentedControl:(id)sender {
    NSInteger mymode = [modeSelector selectedSegment];
    NSLog(@"%s : %ld", __PRETTY_FUNCTION__, (long)mymode);
    if (mymode == 0) {
        [self setIsNavMode:YES];
    } else {
        [self setIsNavMode:NO];
    }
   
}

- (double) getGlobalTime {
    if ([self isNavMode] == NO) {
        return [self gtAppTime];
    }
    
    if ([[self sources] count] == 0) {
        return [self gtAppTime];
    }
    Source* s = [[self sources] objectAtIndex:0];
    
    if ([[s channels] count] == 0) {
        return [self gtAppTime];
    }
    Channel* ch = [[s channels] objectAtIndex:0];
    return [ch getMyTimeInGlobal];
}

- (void) receiveChannelPlayed:(NSNotification *) notification {
    if ([self isNavMode] == NO) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            [ch play];
        }
    }
    [self setGtAppTime:[self getGlobalTime]];
}

- (void) receiveChannelStoped:(NSNotification *) notification {
    if ([self isNavMode] == NO) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            [ch stop];
        }
    }
    [self setGtAppTime:[self getGlobalTime]];

}

- (void) receiveChannelCurrentTimeUpdated:(NSNotification *) notification {
    if ([self isNavMode] == NO) {
        return;
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    Channel* lhs = [notification object];
//    QTMovie* lhs = [senderChannel movie];

    for (Source* s in [self sources]) {
        for (Channel* rhs in [s channels]) {
  //          QTMovie* rhs = [ch movie];
            if (lhs == rhs) {
                continue;
            }
            [rhs setMyTimeInGlobal:[lhs getMyTimeInGlobal]];

        }
    }
    [self setGtAppTime:[self getGlobalTime]];

}

- (void)addSourceMov:(NSURL*)url {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // If we do not have movSplitView, create one
    [self createMovSplitViewIfNotExist];
    
    // Create a source
    SourceMovie* s = [[SourceMovie alloc] init];
    [s setBeda:self];
    [s loadFile:url];
    [[self sources] addObject:s];
    NSLog(@"%s: sources.size() = %lu ", __PRETTY_FUNCTION__, (unsigned long)[[self sources] count]);
    
    // Create a movie view for
    ChannelMovie* ch = [[s channels] objectAtIndex:0];
    if (ch) {
        [ch createMovieViewFor:self];
    }
    

}

- (void)createMovSplitViewIfNotExist {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([self movSplitView] != Nil) {
        return;
    }
    NSLog(@"%s : create a movSplitView", __PRETTY_FUNCTION__);
    
    NSSplitView* sv = [[NSSplitView alloc] init];
    [sv setVertical:YES];
    
    NSArray* v = [splitview subviews];
    NSView* firstView = Nil;
    if ([[splitview subviews] count] > 0) {
        firstView = [v objectAtIndex:0];
    }
    
    [splitview addSubview:sv positioned:NSWindowBelow relativeTo:firstView];
    
    [self setMovSplitView:sv];
    
//    [self spaceEvenly:splitview withFirstSize:BEDA_WINDOW_INITIAL_MOVIE_HEIGHT];
    [self spaceProportionaly:splitview];

}

- (void)spaceEvenly:(NSSplitView *)splitView
{
    // get the subviews of the split view
    NSArray *subviews = [splitView subviews];
    unsigned int n = [subviews count];
    float divider = [splitView dividerThickness];
    
    if ([splitView isVertical] == YES) {
        NSLog(@"%s: isVertical = YES", __PRETTY_FUNCTION__);

        // compute the new height of each subview
        float width = ([splitView bounds].size.width - (n - 1) * divider) / n;
        
        // adjust the frames of all subviews
        float x = 0;
        NSView *subview;
        NSEnumerator *e = [subviews objectEnumerator];
        while ((subview = [e nextObject]) != nil)
        {
            NSRect frame = [subview frame];
            frame.origin.x = rintf(x);
            frame.size.width = rintf(x + width) - frame.origin.x;
            [subview setFrame:frame];
            x += width + divider;
        }

    } else {
        NSLog(@"%s: isVertical = NO", __PRETTY_FUNCTION__);
        
        // compute the new height of each subview
        float height = ([splitView bounds].size.height - (n - 1) * divider) / n;
        
        // adjust the frames of all subviews
        float y = 0;
        NSView *subview;
        NSEnumerator *e = [subviews objectEnumerator];
        while ((subview = [e nextObject]) != nil)
        {
            NSRect frame = [subview frame];
            frame.origin.y = rintf(y);
            frame.size.height = rintf(y + height) - frame.origin.y;
            [subview setFrame:frame];
            y += height + divider;
        }
    }
    
    // have the AppKit redraw the dividers
    [splitView adjustSubviews];
}

- (void)spaceEvenly:(NSSplitView *)splitView withFirstSize:(float)szFirst {
    // get the subviews of the split view
    NSArray *subviews = [splitView subviews];
    unsigned int n = [subviews count];
    float divider = [splitView dividerThickness];
    
    if ([splitView isVertical] == YES) {
        NSLog(@"%s: isVertical = YES", __PRETTY_FUNCTION__);
        
        // compute the new height of each subview
        float width = ([splitView bounds].size.width - (n - 1) * divider) / n;
        
        // adjust the frames of all subviews
        float x = 0;
        NSView *subview;
        NSEnumerator *e = [subviews objectEnumerator];
        while ((subview = [e nextObject]) != nil)
        {
            NSRect frame = [subview frame];
            frame.origin.x = rintf(x);
            frame.size.width = rintf(x + width) - frame.origin.x;
            [subview setFrame:frame];
            x += width + divider;
        }
        
    } else {
        NSLog(@"%s: isVertical = NO", __PRETTY_FUNCTION__);
        
        // compute the new height of each subview
        float otherHeight = 0;
        if (n > 1) {
            otherHeight = ([splitView bounds].size.height - szFirst - (n - 1) * divider) / (n - 1);
        }
        
        // adjust the frames of all subviews
        float y = 0;
        NSView *subview;
        NSEnumerator *e = [subviews objectEnumerator];
        int index = 0;
        while ((subview = [e nextObject]) != nil)
        {
            NSRect frame = [subview frame];
            frame.origin.y = rintf(y);
            float height = (index == 0) ? szFirst : otherHeight;
            frame.size.height = rintf(y + height) - frame.origin.y;
            [subview setFrame:frame];
            y += height + divider;
            index++;
        }
    }
    
    // have the AppKit redraw the dividers
    [splitView adjustSubviews];
}

- (void)spaceProportionaly:(NSSplitView *)splitView {
    int cnt = 0;
    float factor[20];
    float sumFactor = 0.0;

    if ([self movSplitView] != Nil) {
        for (Source* s in [self sources]) {
            for (Channel* ch in [s channels]) {
                if ([ch isKindOfClass:[ChannelMovie class]] && cnt == 0) {
                    factor[cnt] = [ch windowHeightFactor];
                    sumFactor += factor[cnt];
                    cnt++;
                }
            }
        }
    }
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            if ([ch isKindOfClass:[ChannelMovie class]]) {
                continue;
            }
            factor[cnt] = [ch windowHeightFactor];
            sumFactor += factor[cnt];
            cnt++;
        }
    }
    for (int i = 0; i < cnt; i++) NSLog(@"factor %d: %f", i, factor[i]);
    NSLog(@"sum factor = %f", sumFactor);
    
    NSArray *subviews = [splitView subviews];
    unsigned int n = [subviews count];
    float divider = [splitView dividerThickness];

    float availableHeights = [splitView bounds].size.height - (n - 1) * divider;
    
    
    // adjust the frames of all subviews
    float y = 0;
    NSView *subview;
    NSEnumerator *e = [subviews objectEnumerator];
    int index = 0;
    while ((subview = [e nextObject]) != nil)
    {
        NSRect frame = [subview frame];
        frame.origin.y = rintf(y);
        float height = availableHeights / sumFactor * factor[index];
        frame.size.height = rintf(y + height) - frame.origin.y;
        [subview setFrame:frame];
        y += height + divider;
        index++;
    }
    [splitView adjustSubviews];

}

- (void)addSourceTimeData:(NSURL*)url {
    // Create a source
    SourceTimeData* s = [[SourceTimeData alloc] init];
    [s setBeda:self];
    [s loadFile:url];
    [[self sources] addObject:s];
    NSLog(@"%s: sources.size() = %lu ", __PRETTY_FUNCTION__, (unsigned long)[[self sources] count]);
    
    // Create a movie view for
    ChannelTimeData* chEda = [[s channels] objectAtIndex:0];
    ChannelTimeData* chTemp = [[s channels] objectAtIndex:1];
    ChannelTimeData* chAccel = [[s channels] objectAtIndex:2];
    if (chEda) {
        [chEda createEDAViewFor:self];
        [chTemp createTempViewFor:self];
        [chAccel createAccelViewFor:self];
    }
    
//    [self spaceEvenly:splitview];
    [self spaceProportionaly:splitview];

}

@end
