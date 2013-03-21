//
//  GraphViewController.h
//  BEDA
//
//  Created by Jennifer Kim on 2/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "DataManager.h"

@interface EDAGraphViewController : NSObject<CPTPlotDataSource> {
    IBOutlet CPTGraphHostingView *hostView;
    IBOutlet NSView *view;
    IBOutlet DataManager* dm;


    CPTXYGraph *graph;
}
- (void) reload;
- (void) onSensorDataLoaded:(NSNotification*) noti;

@end
