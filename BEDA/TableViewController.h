//
//  TableViewController.h
//  BEDA
//
//  Created by Sehoon Ha on 6/16/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SourceTimeData.h"

@interface TableViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSTableView* tableview;
    NSMutableArray* data;
}

@property (retain) SourceTimeData* source;

@end
