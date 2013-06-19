//
//  BehaviorSettingController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/19/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BehaviorSettingController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>{
    IBOutlet NSCell *customCell;
    IBOutlet NSTableView *table;
    NSMutableArray* data;
}

@end
