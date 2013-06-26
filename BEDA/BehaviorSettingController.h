//
//  BehaviorSettingController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/19/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SourceTimeData.h"
#import "ChannelTimeData.h"
#import "ColorCellView.h"

@interface BehaviorSettingController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>{
    IBOutlet NSTableView *table;
    IBOutlet NSSegmentedControl* modeSelector;
}

@property (retain) SourceTimeData* source;
@property (retain) ChannelTimeData* channel;
@property (retain) NSMutableDictionary* controls;

- (IBAction)changeModeFromSegmentedControl:(id)sender;
@end
