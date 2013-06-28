//
//  SummaryProjectsController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/28/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface SummaryProjectsController : NSObject<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate> {
    IBOutlet CPTGraphHostingView* graphview;
    CPTXYPlotSpace *plotSpace;
    CPTScatterPlot *dataSourceLinePlot;
}

- (void) reloadGraph;

@property (retain) CPTXYGraph* graph;
@property (retain) NSMutableArray *plotXData;
@property (retain) NSMutableArray *plotYData;
@end
