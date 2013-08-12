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
@synthesize channelsTimeData = _channelsTimeData;
@synthesize movSplitView;
@synthesize isNavMode;
@synthesize numProjects;
@synthesize playMode;
@synthesize isAbsoulteTimeMode;
@synthesize gtAppTime = _gtAppTime;
@synthesize gtViewLeft;
@synthesize gtViewRight;
@synthesize duration;
@synthesize interval;
@synthesize graphWindowController;
@synthesize dataWindowController;
@synthesize summaryProjectsController;
@synthesize intervalPlayerManager;
@synthesize playTimer;
@synthesize intervalPlayerView;
@synthesize window;
@synthesize isIntervalPlayerVisible;
@synthesize timePopUp;
@synthesize timeMenuAbsolute;
@synthesize timeMenuRelative;

static BedaController* g_instance = nil;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _sources = [[NSMutableArray alloc] init];
    _channelsTimeData = [[NSMutableArray alloc] init];

//    _movSplitView = Nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGraphSplitViewResize:) name:NSSplitViewDidResizeSubviewsNotification object:splitview];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAnnotationChanged:)
                                                 name:BEDA_NOTI_ANNOTATION_CHANGED
                                               object:nil];
    
    ///////////////////////////
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelHeadMoved:)
                                                 name:BEDA_NOTI_CHANNEL_HEAD_MOVED
                                               object:nil];
    
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
    
    


    
    [self setNumProjects:0];
    [self setPlayMode:BEDA_MODE_STOP];
    [self navigate:nil];
    [self setDuration:180];
    [self setInterval:10];
    [self setGtViewLeft:0.0];
    [self setGtViewRight:330.0];
    [self setIsIntervalPlayerVisible:NO];
    g_instance = self;
    [self setGraphWindowController:Nil];
    [self setGtAppTime:0];
//    [self setIsAbsoulteTimeMode:NO];
//    [[self timePopUp] setTitle:@"00:00"];
    [self makeRelativeTimeMode:nil];
    [self updateAbsoluteTimeInfo];
//    [self setIntervalPlayerManager: [[IntervalPlayerManager alloc] init]];

    NSSplitView* mainview = (NSSplitView* )[movSplitView superview];
    {
        NSRect frame = [movSplitView frame];
        frame.size.height = 300;
        [movSplitView setFrame:frame];
    }
    {
        NSView* last = [[mainview subviews] lastObject];
        NSRect frame = [last frame];
        frame.size.height = 500;
        [last setFrame:frame];
        
    }
    
    for (NSView* subview in [mainview subviews]) {
        
        NSLog(@"frame.height = %lf", [subview frame].size.height);
    }
    [mainview adjustSubviews];
}

- (IBAction)showInfoPopover:(id)sender {
    [[self popover] showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}


- (IBAction)hideInfoPopover:(id)sender {
    [[self popover] close];
}

-(IBAction)openDataAnalysisWindow:(id)sender{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self dataWindowController] != Nil) {
        [[[self dataWindowController] window] makeMainWindow];
        NSLog(@"%s : we already has DataWindowController", __PRETTY_FUNCTION__);
        return;
    }
    
    
    NSWindowController *cw = [[NSWindowController alloc] initWithWindowNibName:@"DataAnalysisWindow"];
    [cw showWindow:self];
    [self setDataWindowController:cw];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDataWindowControllerClosed:)
                                                 name:NSWindowWillCloseNotification
                                               object:[dataWindowController window]];
}

-(IBAction)openSummaryProjectsWindow:(id)sender{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self summaryProjectsController] != Nil) {
        [[[self summaryProjectsController] window] makeMainWindow];
        NSLog(@"%s : we already has DataWindowController", __PRETTY_FUNCTION__);
        return;
    }
    
    
    NSWindowController *cw = [[NSWindowController alloc] initWithWindowNibName:@"SummaryProjectsWindow"];
    [cw showWindow:self];
    [self setSummaryProjectsController:cw];

}

- (void) onDataWindowControllerClosed:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setDataWindowController:Nil];
    
}

-(IBAction)showIntervalPlayerSheet:(id)sender
{
    assert (window);
    ipc = [[IntervalPlayerController alloc] initWithWindowNibName:@"IntervalPlayerWindow"];
    assert ([ipc window]);

    [NSApp beginSheet: [ipc window]
       modalForWindow: window
        modalDelegate: ipc
       didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
          contextInfo: nil];
    [ipc setMywindow:[ipc window]];
}

- (IBAction)showIntervalPlayerView:(id)sender
{
    if(isIntervalPlayerVisible == YES){
        [intervalPlayerView setHidden:NO];
    } else{
        
        [intervalPlayerView setHidden:YES];
    }
}

- (IBAction)makeAbsoluteTimeMode:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setIsAbsoulteTimeMode:YES];
    [[self timeMenuAbsolute] setState:NSOnState];
    [[self timeMenuRelative] setState:NSOffState];
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            if ([ch isKindOfClass:[ChannelTimeData class]] == NO) {
                continue;
            }
            ChannelTimeData* cht = (ChannelTimeData*)ch;
            [cht makeAbsoluteMode];
        }
    }
    [self updateAbsoluteTimeInfo];
}

- (IBAction)makeRelativeTimeMode:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setIsAbsoulteTimeMode:NO];
    [[self timeMenuAbsolute] setState:NSOffState];
    [[self timeMenuRelative] setState:NSOnState];
    
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            if ([ch isKindOfClass:[ChannelTimeData class]] == NO) {
                continue;
            }
            ChannelTimeData* cht = (ChannelTimeData*)ch;
            [cht makeRelativeMode];
        }
    }
    [self updateRelativeTimeInfo];

}

- (void)updateAbsoluteTimeInfo {
    SourceTimeData* std = Nil;
    int stdCnt = 0;
    for (Source* s in [self sources]) {
        if ([s isKindOfClass:[SourceTimeData class]]) {
            stdCnt++;
            std = (SourceTimeData*)s;
        }
    }
    
    if (stdCnt != 1) {
        if ([self isAbsoulteTimeMode]) {
            [self makeRelativeTimeMode:nil];
        }
        [[self timeMenuAbsolute] setEnabled:NO];
        
        return;
    }
    NSLog(@"%s : enable MenuAbsolute", __PRETTY_FUNCTION__);

    [[self timeMenuAbsolute] setEnabled:YES];

    if ([self isAbsoulteTimeMode] == NO) {
        return;
    }
    
    NSDate* base = [std basedate];
    NSLog(@"base = %@", base);
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    double t = [self gtAppTime] + [std offset] + [std projoffset];
    NSDate* now = [NSDate dateWithTimeInterval:t sinceDate:base];
    NSString* strAppTime = [dateFormatter stringFromDate:now];
    [[self timePopUp] setTitle:strAppTime];
}

- (void) updateRelativeTimeInfo {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([self duration] > 3600) {
        [dateFormatter setDateFormat: @"h:mm:ss"];
    } else {
        [dateFormatter setDateFormat: @"mm:ss"];
    }        NSDate* base = [NSDate dateWithNaturalLanguageString:@"00:00:00"];
    NSDate* now = [NSDate dateWithTimeInterval:_gtAppTime sinceDate:base];
    NSString* strAppTime = [dateFormatter stringFromDate:now];
    [[self timePopUp] setTitle:strAppTime];
}

+ (BedaController*) getInstance {
    return g_instance;
}

- (void)setGtAppTime:(double)gtAppTime {
    _gtAppTime = gtAppTime;
    if ([self isAbsoulteTimeMode]) {
        [self updateAbsoluteTimeInfo];
    } else {
        [self updateRelativeTimeInfo];
    }
}

- (BOOL)isSyncMode {
    if ([self isNavMode]) return NO;
    else return YES;
}

- (BOOL)isMultiProjectMode {
    if ([self numProjects] > 1) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isPlaying {
    if ([self playMode] == BEDA_MODE_STOP) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isIntervalFastPlayMode {
    if ([self isIntervalPlayerVisible] && [[self intervalPlayerManager] isFastMode]) {
        return YES;
    } else {
        return NO;
    }
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
    
    [self openFileAtURL:url];
    
    [self openGraphController:Nil];
}

- (void)openFileAtURL:(NSURL*)url {
    NSString *ext = [[url path] pathExtension];
    NSLog(@"url = %@ [ext = %@]", url, ext);
    if ([ext isEqualToString:@"csv"]) {
        [self addSourceTimeData:url];
    } else {
        [self addSourceMov:url];
    }
    
    
    // Update duration
    double maxDuration = 0.0;
    for (Source* s in [self sources]) {
        double d = [s duration];
        if (maxDuration < d) {
            maxDuration = d;
        }
        NSLog(@"duration = %lf max duration = %lf", d, maxDuration);
    }
    [self setDuration:maxDuration];
    [self setGtViewLeft:0.0];
    [self setGtViewRight:[self duration]];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_SOURCE_ADDED
     object:nil];
    
    [self updateAbsoluteTimeInfo];

    
}

- (IBAction)openGraphController:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if ([self graphWindowController] != Nil) {
        [[[self graphWindowController] window] makeMainWindow];
        NSLog(@"%s : we already has ControllerWindow", __PRETTY_FUNCTION__);
        return;
    }

    
    NSWindowController *cw = [[NSWindowController alloc] initWithWindowNibName:@"GraphController"];
    [cw showWindow:self];
    [self setGraphWindowController:cw];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGraphControllerClosed:)
                                                 name:NSWindowWillCloseNotification
                                               object:[graphWindowController window]];
}

- (void) onGraphControllerClosed:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setGraphWindowController:Nil];

}

- (void) onPlay:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    
    [[self playButton] setIntValue:1];
    [self setPlayMode:BEDA_MODE_PLAY];
    
    if ([self playTimer] != Nil) {
        [[self playTimer] invalidate];
        [self setPlayTimer:Nil];
    }
    
    [self setPlayTimer:
     [NSTimer scheduledTimerWithTimeInterval:0.05f
                                      target:self
                                    selector:@selector(onPlayTimer:)
                                    userInfo:nil
                                     repeats:YES]
     ];

}

- (void) onFastPlay:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setPlayMode:BEDA_MODE_FASTPLAY];
    [[self playButton] setIntValue:1];
    
    if ([self playTimer] != Nil) {
        [[self playTimer] invalidate];
        [self setPlayTimer:Nil];
    }

    [self setPlayTimer:
     [NSTimer scheduledTimerWithTimeInterval:0.05f
                                      target:self
                                    selector:@selector(onPlayTimer:)
                                    userInfo:nil
                                     repeats:YES]
     ];
}

- (void) onStop:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[self playTimer] invalidate];
    [self setPlayTimer:Nil];
    
    [self setPlayMode:BEDA_MODE_STOP];
    
//    if ([self isIntervalPlayerVisible] && [[self intervalPlayerManager] isFastMode]) {
//
//    } else {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"];
//        NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
//        [[self playButton] setImage:img];
//    }
    
    [[self playButton] setIntValue:0];


}

- (IBAction)play:(id)sender {
    if ([self isPlaying]) {
        NSLog(@"%s: pass the control to stop function", __PRETTY_FUNCTION__);
        [self stop:nil];
        return;
    }
    
    if ([self isNavMode] == NO) {
        NSLog(@"%s: not able to play in Sync mode", __PRETTY_FUNCTION__);
        return;
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self isIntervalPlayerVisible] == YES){
    
        if ([[self intervalPlayerManager] isFastMode]) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:BEDA_NOTI_CHANNEL_FASTPLAY
             object:self];
        }   else {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:BEDA_NOTI_CHANNEL_PLAY
             object:self];
        
        }
        

    } else {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BEDA_NOTI_CHANNEL_PLAY
         object:self];
    }
    
}

- (void)onPlayTimer : (id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            // Just for any channel
            double gt = [ch getMyTimeInGlobal];
            NSLog(@"%s : %lf", __PRETTY_FUNCTION__, gt);
            [self setGtAppTime:gt];
            // We are done with update: return
            return;
        }
    }
}

- (IBAction)stop:(id)sender {
    if ([self isNavMode] == NO) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if( [self isIntervalPlayerVisible] == YES){
        NSLog(@"%s: isFastMode = %d", __PRETTY_FUNCTION__, [[self intervalPlayerManager] isFastMode]);

        [[NSNotificationCenter defaultCenter]
         postNotificationName:BEDA_NOTI_CHANNEL_STOP
         object:self];


    } else {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BEDA_NOTI_CHANNEL_STOP
         object:self];
    }

}

- (IBAction)addAnnotation:(id)sender{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMenuItem* item = (NSMenuItem*)sender;
    NSString* name = [item title];
    double t = [self getGlobalTime];

    NSLog(@"item.title %@ at %.lf", name, t);
    for (Source* s in [self sources]) {
        // To Do: select the proper source in future
        Behavior* beh = [[s annots] behaviorByName:name];
        
        double offset = [s offset];
        double projeoffset = [s projoffset];
        double lt = t + offset + projeoffset;
        [[beh times] addObject:[NSNumber numberWithFloat:lt]];
        
        NSLog(@"# Source Channels = %d", (int)[[s channels] count]);
        for (Channel* ch in [s channels]) {
            [ch updateAnnotation];
        }
    }
}

- (void)createAnnotationMenus {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [annotmenu removeAllItems];
    
    for (Source* s in [self sources]) {
        BehaviorManager* am = [s annots];
        for (int i = 0; i < [am countDefinedBehaviors]; i++) {
            Behavior* beh = [am behaviorByIndex:i];
            
            NSImage* image = [[NSImage alloc] initWithSize:NSMakeSize(10.0, 10.0)];
            [image lockFocus];
            [[beh color] set];
            NSRectFill(NSMakeRect(0, 0, 10, 10));
            [image unlockFocus];
            
            NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:[beh name]
                                                           action:@selector(addAnnotation:)
                                                    keyEquivalent:[beh key]];
            [item setTarget:self];
            [item setKeyEquivalentModifierMask:0];
            [item setImage:image];
            [annotmenu addItem:item];
        }
        
        if (s != [[self sources] lastObject]) {
            [annotmenu addItem:[NSMenuItem separatorItem]];
        }
    }


}

- (IBAction)toggleChannelSelector:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_CHANNELSELECTOR_TOGGLE
     object:self];

}

- (IBAction)exportSelection:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (Source* s in [self sources]) {
        [s exportSelection];
    }
}

-(IBAction)zoomIn:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    double d = [self gtViewRight] - [self gtViewLeft];
    d *= 0.8;
    [self setGtViewRight:[self gtViewLeft] + d];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_VIEW_UPDATE
     object:self];
    
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    for (Source* s in [self sources]) {
//        for (Channel* ch in [s channels]) {
//            [ch zoomIn];
//        }
//    }

}


-(IBAction)zoomOut:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    double d = [self gtViewRight] - [self gtViewLeft];
    d *= 1.25;
    [self setGtViewRight:[self gtViewLeft] + d];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_VIEW_UPDATE
     object:self];
    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:BEDA_NOTI_VIEW_UPDATE
//     object:self];
//    for (Source* s in [self sources]) {
//        for (Channel* ch in [s channels]) {
//            [ch zoomOut];
//        }
//    }
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
        for (Source* s in [self sources]) {
            for (Channel* ch in [s channels]) {
                [ch hideOffsetOverlay];
            }
        }
        
    } else {
        [self setIsNavMode:NO];
        for (Source* s in [self sources]) {
            for (Channel* ch in [s channels]) {
                [ch showOffsetOverlay];
            }
        }
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


///////////////////////////////////////////////////////////////////////////////////////////
- (void) onChannelHeadMoved:(NSNotification *) notification {
    if ([self isSyncMode] == YES) {
        return;
    }
    if ([notification object] == Nil) {
        return;
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    Channel* ch = (Channel*)[notification object];
    [self setGtAppTime:[ch getMyTimeInGlobal]];
}


- (void) onAnnotationChanged:(NSNotification *) notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self createAnnotationMenus];
}

- (void)addSourceMov:(NSURL*)url {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
//    // If we do not have movSplitView, create one
//    [self createMovSplitViewIfNotExist];
    
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
    
    [self spaceProportionaly:splitview];
    [self spaceEvenly:[self movSplitView]];
    
}

//- (void)createMovSplitViewIfNotExist {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    if ([self movSplitView] != Nil) {
//        return;
//    }
//    NSLog(@"%s : create a movSplitView", __PRETTY_FUNCTION__);
//    
//    NSSplitView* sv = [[NSSplitView alloc] init];
//    [sv setVertical:YES];
//    
//    NSArray* v = [splitview subviews];
//    NSView* firstView = Nil;
//    if ([[splitview subviews] count] > 0) {
//        firstView = [v objectAtIndex:0];
//    }
//    
//    [splitview addSubview:sv positioned:NSWindowBelow relativeTo:firstView];
//    
//    [self setMovSplitView:sv];
//    
//}

- (void)spaceEvenly:(NSSplitView *)splitView
{
    // get the subviews of the split view
    NSArray *subviews = [splitView subviews];
    int n = (int)[subviews count];
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
    int n = (int)[subviews count];
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

- (void)spaceProportionalyMainSplit {
    [self spaceProportionaly:splitview];
}

- (void)spaceProportionaly:(NSSplitView *)splitView {
    int cnt = 0;
    float factor[20];
    float sumFactor = 0.0;

    for (ChannelTimeData* ch in [self channelsTimeData]) {
        factor[cnt] = [ch windowHeightFactor];
        sumFactor += factor[cnt];
        cnt++;
    }
    for (int i = 0; i < cnt; i++) NSLog(@"factor %d: %f", i, factor[i]);
    NSLog(@"sum factor = %f", sumFactor);
    
    int MIN_SCROLL_NUM_GRAPHS = 3;
    if (cnt > MIN_SCROLL_NUM_GRAPHS) {
//        double fixedHeight = [[splitview superview] frame].size.height;
        double fixedHeight = 400;
        NSRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = [splitview bounds].size.width;
        frame.size.height = fixedHeight + 150 * (cnt - MIN_SCROLL_NUM_GRAPHS);
        [[splitview superview] setFrame:frame];
        NSLog(@"adjust graphSplitView height = %lf", frame.size.height);

    }
    
    NSArray *subviews = [splitView subviews];
    int n = (int)[subviews count];
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
    
    [self createAnnotationMenus];
}

- (void)clearAllViews {
    NSLog(@"%s", __PRETTY_FUNCTION__);

//    while([[[self movSplitView] subviews] count] > 0) {
//        [[[[self movSplitView] subviews] objectAtIndex:0] removeFromSuperview];
//    }
    
    while([[splitview subviews] count] > 0) {
        [[[splitview subviews] objectAtIndex:0] removeFromSuperview];
    }
    
//    [self setMovSplitView:Nil];
}

- (void)createViewsForAllChannels {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self clearAllViews];
    
    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            if ([ch isKindOfClass:[ChannelMovie class]]) {
//                [self createMovSplitViewIfNotExist];
//                ChannelMovie* chm = (ChannelMovie*)ch;
//                [chm createMovieViewFor:self];

            } else if ([ch isKindOfClass:[ChannelTimeData class]]) {
//                ChannelTimeData* chtd = (ChannelTimeData*)ch;
//                [chtd createGraphViewFor:self];                
            } else {
                NSLog(@"%s: unknown channel", __PRETTY_FUNCTION__);
            }
        }
    }
    
    for (ChannelTimeData* chtd in [self channelsTimeData]) {
        [chtd createGraphViewFor:self];
    }
    
    [self spaceProportionaly:splitview];
    
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                     target:self
                                   selector:@selector(onCreateOffsetTimer:)
                                   userInfo:nil
                                    repeats:NO];


}
 
 - (void) onGraphSplitViewResize:(NSNotification*) noti {
     for (Source* s in [self sources]) {
         for (Channel* ch in [s channels]) {
             [ch adjustControlPositions];
         }
     }
 }

- (void)onCreateOffsetTimer : (id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    for (Source* s in [self sources]) {
        for (Channel* ch in [s channels]) {
            [ch clearControls];
            if ([self isSyncMode]) {
                [ch showOffsetOverlay];
            } else {
                [ch hideOffsetOverlay];
            }
        }
    }
    
}

@end
