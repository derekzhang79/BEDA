//
//  GraphSettingController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SourceTimeData.h"
#import "ChannelTimeData.h"

@interface GraphSettingController : NSViewController{

    IBOutlet NSColorWell* graphColor;
    IBOutlet NSColorWell* areaColor;
    IBOutlet NSTextField* graphName;
    IBOutlet NSTextField* selectedColumnName;
}

@property (retain) SourceTimeData* source;
@property (retain) ChannelTimeData* channel;
@property (assign) int columnIndex;
@property (assign) BOOL isAutomatic;
@property (assign) BOOL isGraphVisible;

@property (nonatomic, retain) IBOutlet NSTextField* txtMinValue;
@property (nonatomic, retain) IBOutlet NSTextField* txtMaxValue;


- (IBAction)radioButton:(id)sender;
- (NSColor*)getGraphColor;
- (NSColor*)getAreaColor;
- (NSString*)getGraphName;
- (void)setGraphTitle:(NSString*)name;
- (void)setSelectedColumnTitle:(NSString*)name;

@end
