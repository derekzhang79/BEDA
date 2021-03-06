//
//  SourceTimeData.h
//  BEDA
//
//  Created by Jennifer Kim on 6/8/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Source.h"

@interface SourceTimeData : Source {
    
}

@property (retain) NSMutableArray* timedata;
@property (retain) NSDate* basedate;
@property (retain) NSMutableArray* columns;
@property int timeIndex;

- (void)loadFile:(NSURL*)url;
//- (void)loadEDAGraph;

- (double)minValueForColumn:(int)index;
- (double)maxValueForColumn:(int)index;
- (double)maxTimeInSecond:(int)index;

- (BOOL)exportSelection;


@end
