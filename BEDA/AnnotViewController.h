//
//  AnnotViewController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/21/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "SourceTimeData.h"

@interface AnnotViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet CPTGraphHostingView* graphview;
    IBOutlet NSTableView* tableview;
}

@property (retain) SourceTimeData* source;
@property (retain) CPTXYGraph* graph;

- (CPTGraphHostingView*) getGraphView;
- (void)reloadTableView;

@end
