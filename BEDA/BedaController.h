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
#define BEDA_NOTI_SOURCE_ADDED @"BedaNotiSourceAdded"
#define BEDA_NOTI_APPLY_SETTING_PRESSED @"BedaNotiApplySettingPressed"
#define BEDA_NOTI_ANNOTATION_CHANGED @"BedaNotiAnnotationChanged"

@interface BedaController : NSObject {
    IBOutlet NSSegmentedControl* modeSelector;
    IBOutlet NSSplitView* splitview;
    IBOutlet NSMenu* annotmenu;
}

// Singleton
+ (BedaController*) getInstance;

@property (retain) NSMutableArray* sources;
@property (retain) NSSplitView* movSplitView;
@property (retain) NSWindowController* controllerWindow;
@property BOOL isNavMode;
@property double gtAppTime;

@property (assign) double duration;
@property (assign) double interval;


- (NSSplitView*) getSplitView;

// Responde to menu
- (IBAction)openFile:(id)sender;
- (void)openFileAtURL:(NSURL*)url;

- (IBAction)openGraphController:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)stop:(id)sender;

- (IBAction)changeModeFromSegmentedControl:(id)sender;
- (IBAction)navigate:(id)sender;
- (IBAction)synchronize:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

- (IBAction)addAnnotation:(id)sender;
- (void)createAnnotationMenus;

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

- (void)spaceProportionalyMainSplit;

- (void)spaceProportionaly:(NSSplitView *)splitView;

- (void)addSourceTimeData:(NSURL*)url;

// Manipulate views
- (void)clearAllViews;
- (void)createViewsForAllChannels;
@end
