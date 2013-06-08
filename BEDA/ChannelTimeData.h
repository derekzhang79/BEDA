//
//  ChannelTimeData.h
//  BEDA
//
//  Created by Jennifer Kim on 6/8/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import "SourceTimeData.h"
#import <CorePlot/CorePlot.h>

@interface ChannelTimeData : Channel<CPTPlotDataSource>  {
    CPTXYGraph *graph;
}

- (SourceTimeData*) sourceTimeData;
- (void)initGraph;

- (void)createEDAViewFor:(BedaController*)beda;

@end
