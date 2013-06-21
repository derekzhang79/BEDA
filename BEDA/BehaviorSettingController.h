//
//  BehaviorSettingController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/19/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SourceTimeData.h"

@interface BehaviorSettingController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>{
    IBOutlet NSTableView *table;
    IBOutlet NSSegmentedControl* modeSelector;
    NSMutableArray* data;
}

@property (retain) SourceTimeData* source;

- (IBAction)changeModeFromSegmentedControl:(id)sender;
@end
