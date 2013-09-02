//
//  ExtraVisualizationController.h
//  BEDA
//
//  Created by Sehoon Ha on 9/1/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface ExtraVisualizationController :  NSObject<CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDelegate, CPTBarPlotDelegate> {
    
    IBOutlet CPTGraphHostingView* graphview;
    
    CPTXYPlotSpace *plotSpace;
    CPTXYPlotSpace *plotSpace2;

    CPTXYGraph* graph;
    
    CPTScatterPlot* pctpeaks;
    CPTBarPlot* auc;
}

@property (retain) NSMutableArray* xlabels;
@property (retain) NSMutableArray* ypeaks;
@property (retain) NSMutableArray* yauc;



@end
