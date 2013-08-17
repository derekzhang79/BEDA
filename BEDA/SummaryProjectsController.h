//
//  SummaryProjectsController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/28/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@class SummaryProjectOutline;

@interface SummaryProjectsController : NSObject<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate> {
    IBOutlet CPTGraphHostingView* graphview;
    CPTXYPlotSpace *plotSpace;
//    CPTScatterPlot *dataSourceLinePlot;
}
@property (assign) IBOutlet SummaryProjectOutline *spoutline;

- (void) reloadGraph;

@property (retain) CPTXYGraph* graph;
@property (retain) NSMutableArray *plotXData;
@property (retain) NSMutableArray *plotGroup;

// @property (retain) NSMutableArray *plotYData;
@property (retain) NSMutableDictionary* plotYData;
@property (retain) NSMutableArray *cptplots;


-(void) addPlotAndDataWithName:(NSString*)name inColor:(NSColor*) color;
-(NSMutableArray*) findYDataWithName:(NSString*)name;

@end
