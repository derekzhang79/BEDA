//
//  BedaController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>
#import "IntervalPlayerController.h"
#import "DataAnalysisController.h"
#import "SummaryProjectsController.h"
#import "IntervalPlayerManager.h"

extern float BEDA_WINDOW_INITIAL_MOVIE_HEIGHT;
#define BEDA_NOTI_SOURCE_ADDED @"BedaNotiSourceAdded"
#define BEDA_NOTI_APPLY_SETTING_PRESSED @"BedaNotiApplySettingPressed"
#define BEDA_NOTI_ANNOTATION_CHANGED @"BedaNotiAnnotationChanged"

// Notification for the new structure
#define BEDA_NOTI_CHANNEL_PLAY @"BedaNotiChannelPlay"
#define BEDA_NOTI_CHANNEL_FASTPLAY @"BedaNotiChannelFastPlay"
#define BEDA_NOTI_CHANNEL_STOP @"BedaNotiCHannelStop"
#define BEDA_NOTI_CHANNEL_HEAD_MOVED @"BedaNotiChannelHeadMoved"

#define BEDA_NOTI_CHANNELSELECTOR_TOGGLE @"BedaNotiChannelSelectorToggle"
#define BEDA_NOTI_CHANNELSELECTOR_UPDATE @"BedaNotiChannelSelectorUpdate" 

#define BEDA_NOTI_VIEW_UPDATE @"BedatNotiViewUpdate"

@interface BedaController : NSObject {
    IBOutlet NSSegmentedControl* modeSelector;
    IBOutlet NSSplitView* splitview;
    IBOutlet NSMenu* annotmenu;
    
    IntervalPlayerController* ipc;
    DataAnalysisController* dac;
    SummaryProjectsController* spc;
}

@property (retain) IBOutlet NSWindow *window;
-(IBAction)showIntervalPlayerSheet:(id)sender;

// Singleton
+ (BedaController*) getInstance;

@property (retain) NSMutableArray* sources;
@property (retain) NSSplitView* movSplitView;
@property (retain) NSWindowController* graphWindowController;
@property (retain) NSWindowController* dataWindowController;
@property (retain) NSWindowController* summaryProjectsController;

@property (nonatomic, retain) IBOutlet NSButton* playButton;
@property (retain) IntervalPlayerManager* intervalPlayerManager;

@property BOOL isNavMode;
@property BOOL isPlaying;
@property double gtAppTime;
@property double gtViewLeft;
@property double gtViewRight;
@property (retain) NSTimer* playTimer;

@property (assign) double duration;
@property (assign) double interval;


- (BOOL)isSyncMode;
- (NSSplitView*) getSplitView;

// Responde to menu
- (IBAction)openFile:(id)sender;
- (void)openFileAtURL:(NSURL*)url;

-(IBAction)openDataAnalysisWindow:(id)sender;
-(IBAction)openSummaryProjectsWindow:(id)sender;

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

- (IBAction)toggleChannelSelector:(id)sender;
- (IBAction)exportSelection:(id)sender;


// Time related functions
- (double) getGlobalTime;

// Responde to notifications
//- (void) receiveChannelPlayed:(NSNotification *) notification;
//- (void) receiveChannelStoped:(NSNotification *) notification;
//- (void) receiveChannelCurrentTimeUpdated:(NSNotification *) notification;


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
