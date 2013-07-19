//
//  ChannelMovie.h
//  BEDA
//
//  Created by Jennifer Kim on 6/7/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>
#import "Channel.h"
#import "BedaController.h"

@interface ChannelMovie : Channel {
    
}

@property (assign) QTMovie* movie;
@property double savedRate;

// Initialize functions
- (void)loadFile:(NSURL*)url;
- (void)createMovieViewFor:(BedaController*)beda;

// Channel Inherited Functions
- (void)play;
- (void)fastplay;

- (void)stop;
- (double) getMyTimeInLocal;
- (double) getMyTimeInGlobal;
- (void) setMyTimeInGlobal:(double)gt;
- (double) windowHeightFactor;

// Local functions
- (void) rateDidChanged: (NSNotification *)notification;
- (void) timeDidChanged: (NSNotification *)notification;
- (NSString*) SMPTEStringFromTime:(QTTime)time;
- (double)duration;


@end
