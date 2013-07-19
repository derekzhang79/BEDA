//
//  TableViewController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/16/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SourceTimeData.h"

@interface TableViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSTableView* tableview;
    NSMutableArray* data;
}

@property (retain) SourceTimeData* source;

- (int) selectedTableColumn;
- (NSString*) selectedTableColumnName;
- (NSMutableArray*) columns; // Mutable array of NSString, with Column Names;
- (double) minValue;
- (double) maxValue;
@end
