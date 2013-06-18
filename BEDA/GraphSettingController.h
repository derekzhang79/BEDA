//
//  GraphSettingController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphSettingController : NSViewController{

    IBOutlet NSColorWell* graphColor;
    IBOutlet NSColorWell* areaColor;
    IBOutlet NSTextField* graphName;
    IBOutlet NSTextField* minValue;
    IBOutlet NSTextField* maxValue;
}


//@property (retain) NSString *graphName;
//@property (retain) NSString *graphType;
//
//@property double minY;
//@property double maxY;

- (NSColor*)getGraphColor;
- (NSColor*)getAreaColor;
- (NSString*)getGraphName;
- (double)getMinValue;
- (double)getMaxValue;

@end
