//
//  ViewRangeController.h
//  BEDA
//
//  Created by Jennifer Kim on 7/10/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

#define BEDA_CONST_VIEW_RANGE_ALL_SELECTED 100

@interface ViewRangeController : NSObject<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate> {
    IBOutlet CPTGraphHostingView* graphview;
    CPTXYPlotSpace *plotSpace;
    CPTScatterPlot *plot;
}

- (void) reloadGraph;

@property (retain) CPTXYGraph* graph;
@property NSUInteger selectedIndex;
@property double xToLeft;
@property double xToRight;

@end
