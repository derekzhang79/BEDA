//
//  ViewRangeController.h
//  BEDA
//
//  Created by Sehoon Ha on 7/10/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface ViewRangeController : NSObject<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate> {
    IBOutlet CPTGraphHostingView* graphview;
    CPTXYPlotSpace *plotSpace;
    CPTScatterPlot *plot;
}

- (void) reloadGraph;

@property (retain) CPTXYGraph* graph;
@property int selectedIndex;

@end
