//
//  BedaController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

extern float BEDA_WINDOW_INITIAL_MOVIE_HEIGHT;

@interface BedaController : NSObject {
    IBOutlet NSSegmentedControl* modeSelector;
    IBOutlet NSSplitView* splitview;
}

@property (retain) NSMutableArray* sources;
@property (retain) NSSplitView* movSplitView;
@property BOOL isNavMode;
@property double gtAppTime;

- (NSSplitView*) getSplitView;

// Responde to menu
- (IBAction)openFile:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)stop:(id)sender;

- (IBAction)changeModeFromSegmentedControl:(id)sender;
- (IBAction)navigate:(id)sender;
- (IBAction)synchronize:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

// Time related functions
- (double) getGlobalTime;

// Responde to notifications
- (void) receiveChannelPlayed:(NSNotification *) notification;
- (void) receiveChannelStoped:(NSNotification *) notification;
- (void) receiveChannelCurrentTimeUpdated:(NSNotification *) notification;


- (void)addSourceMov:(NSURL*)url;
- (void)createMovSplitViewIfNotExist;
- (void)spaceEvenly:(NSSplitView *)splitView;
- (void)spaceEvenly:(NSSplitView *)splitView withFirstSize:(float)szFirst;

- (void)addSourceTimeData:(NSURL*)url;


@end
