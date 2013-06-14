//
//  ChannelMovie.m
//  BEDA
//
//  Created by Jennifer Kim on 6/7/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelMovie.h"

@implementation ChannelMovie

@synthesize movie = _movie;


- (void)loadFile:(NSURL*)url {
    NSLog(@"%s: Load URL %@ ", __PRETTY_FUNCTION__, url);
    
    
    NSError* error = nil;
    QTMovie *newMovie = [QTMovie movieWithURL:url error:&error];
    // If there's an error, ..
    if (error != nil) {
        NSLog(@"Error for openMovieFile: %@", error);
        return;
    }
    
    [self setMovie:newMovie];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(rateDidChanged:)
												 name:QTMovieRateDidChangeNotification
                                               object:newMovie];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(timeDidChanged:)
												 name:QTMovieTimeDidChangeNotification
                                               object:newMovie];
    
    
}

- (void)createMovieViewFor:(BedaController*)beda {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Create a movie view
    QTMovieView* view = [[QTMovieView alloc] init];
    NSArray* v = [[beda movSplitView] subviews];
    NSView* lastView = [v lastObject];
    NSSplitView* movSplitView = [beda movSplitView];
    
    [movSplitView addSubview:view positioned:NSWindowAbove relativeTo:lastView];
    [beda spaceEvenly:movSplitView];
    
    [view setWantsLayer:YES];
    [view setPreservesAspectRatio:YES];
    [view setMovie:[self movie]];
    
    
    [self setView:view];
     // [view addSubview:overlay];
    
}

- (void)play {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([self movie] && [[self movie] rate] != 1.0f) {
        [[self movie] play];
    }
}

- (void)stop {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([self movie] && [[self movie] rate] != 0.0f) {
        [[self movie] stop];
    }
    
}

- (double) getMyTimeInLocal {
    QTTime qt = [[self movie] currentTime];
    double ltSeconds = (double)qt.timeValue / (double)qt.timeScale;
    return ltSeconds;
}

- (double) getMyTimeInGlobal {
    QTTime qt = [[self movie] currentTime];
    double ltSeconds = (double)qt.timeValue / (double)qt.timeScale;
    double gtSeconds = [self localToGlobalTime:ltSeconds];
    return gtSeconds;
}

- (void) setMyTimeInGlobal:(double)gt {
    if (fabs(gt - [self getMyTimeInGlobal]) < 0.01) {
        return;
    }
    double lt = [self globalToLocalTime:gt];
    
    QTTime qt = [[self movie] currentTime];
    qt.timeValue = (long long)(lt * (double)qt.timeScale);
    [[self movie] setCurrentTime:qt];
}

- (double) windowHeightFactor {
    return 3.0;
}

- (void) rateDidChanged: (NSNotification *)notification {
    if ([self isNavMode] == NO) {
        double gt = [self getGlobalTime];
        double lt = [self getMyTimeInLocal];
        // gt + offset = lt
        double offset = lt - gt;
        [[self source] setOffset:offset];
        NSLog(@"%s : gt = %lf offset = %lf lt = %lf", __PRETTY_FUNCTION__, gt, offset, lt);
        return;
    }
    
    if ([[self movie] rate] > 0) {
        NSLog(@"%s : PLAY", __PRETTY_FUNCTION__);
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"channelPlay"
         object:self];
        [self updateOffsetOverlay];
    } else {
        NSLog(@"%s : STOP", __PRETTY_FUNCTION__);
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"channelStop"
         object:self];
        [self updateOffsetOverlay];

    }
    
}

- (void) timeDidChanged: (NSNotification *)notification {
    if ([self isNavMode] == NO) {
        double gt = [self getGlobalTime];
        double lt = [self getMyTimeInLocal];
        // gt + offset = lt
        double offset = lt - gt;
        [[self source] setOffset:offset];
        NSLog(@"%s : gt = %lf offset = %lf lt = %lf", __PRETTY_FUNCTION__, gt, offset, lt);
        [self updateOffsetOverlay];
        return;
    }

    double t = [self getMyTimeInGlobal];
    NSLog(@"%s : %lf", __PRETTY_FUNCTION__, t);
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"channelCurrentTimeUpdate"
     object:self];

}

- (NSString*) SMPTEStringFromTime:(QTTime)time
{
    NSString *SMPTE_string;
    int days, hour, minute, second, frame;
    long long result;
    
    if (time.timeScale == 0) {
        return @"";
    }
    
    // timeScale is fps * 100
    result = time.timeValue / time.timeScale; // second
    frame = (int)(time.timeValue % time.timeScale) / 100;
    
    second = result % 60;
    
    result = result / 60; // minute
    minute = result % 60;
    
    result = result / 60; // hour
    hour = result % 24;
    
    days = (int)result;
    
    SMPTE_string = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second]; // hh:mm:ss
    
    return SMPTE_string;
}


@end
