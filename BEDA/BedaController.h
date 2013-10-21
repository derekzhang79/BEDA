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

@class ProjectManager;
@class BedaSetting;

#define BEDA_MODE_PLAY 0
#define BEDA_MODE_FASTPLAY 1
#define BEDA_MODE_STOP 2

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

@property (retain) IBOutlet NSView* intervalPlayerView;
@property (retain) IBOutlet NSWindow *window;
-(IBAction)showIntervalPlayerSheet:(id)sender;

@property BOOL isIntervalPlayerVisible;


// Singleton
+ (BedaController*) getInstance;

@property (retain) NSMutableArray* sources;
@property (retain) NSMutableArray* channelsTimeData;

@property (nonatomic, retain) IBOutlet NSSplitView* mainSplitView;
@property (nonatomic, retain) IBOutlet NSScrollView* graphScrollView;
@property (nonatomic, retain) IBOutlet NSSplitView* movSplitView;
@property (retain) NSWindowController* graphWindowController;
@property (retain) NSWindowController* dataWindowController;
@property (retain) NSWindowController* summaryProjectsController;

@property (nonatomic, retain) IBOutlet NSButton* playButton;
@property (nonatomic, retain) IBOutlet NSPopUpButton* timePopUp;
@property (nonatomic, retain) IBOutlet NSMenuItem* timeMenuAbsolute;
@property (nonatomic, retain) IBOutlet NSMenuItem* timeMenuRelative;


@property (retain) IBOutlet IntervalPlayerManager* intervalPlayerManager;
@property (assign) IBOutlet ProjectManager *projectManager;
@property (retain) BedaSetting* setting;

@property BOOL isNavMode;
@property int numProjects;

@property int playMode;
@property (nonatomic) double gtAppTime;
@property double gtViewLeft;
@property double gtViewRight;
@property (retain) NSTimer* playTimer;
@property BOOL isAbsoulteTimeMode;

@property (assign) double duration;
@property (assign) double interval;
@property (retain) IBOutlet NSPopover* popover;

- (IBAction)showInfoPopover:(id)sender;

- (BOOL)isSyncMode;
- (BOOL)isMultiProjectMode;
- (BOOL)isPlaying;
- (BOOL)isIntervalFastPlayMode;
- (NSSplitView*) getSplitView;

// Responde to menu
- (IBAction)openFile:(id)sender;
- (void)openFileAtURL:(NSURL*)url;

-(IBAction)openDataAnalysisWindow:(id)sender;
-(IBAction)openSummaryProjectsWindow:(id)sender;
-(IBAction)openChannelAnnotationWindow:(id)sender;

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

- (IBAction)showIntervalPlayerView:(id)sender;

- (IBAction)makeAbsoluteTimeMode:(id)sender;
- (IBAction)makeRelativeTimeMode:(id)sender;
- (void)updateAbsoluteTimeInfo;

// Time related functions
- (double) getGlobalTime;


- (void)addSourceMov:(NSURL*)url;
//- (void)createMovSplitViewIfNotExist;
- (void)spaceEvenly:(NSSplitView *)splitView;
- (void)spaceEvenly:(NSSplitView *)splitView withFirstSize:(float)szFirst;

- (void)spaceProportionalyMainSplit;

- (void)spaceProportionaly:(NSSplitView *)splitView;

- (void)addSourceTimeData:(NSURL*)url;

// Manipulate views
- (void)clearAllViews;
- (void)createViewsForAllChannels;
@end
