//
//  SourceTimeData.m
//  BEDA
//
//  Created by Jennifer Kim on 6/8/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "SourceTimeData.h"
#import "ChannelTimeData.h"

@implementation SourceTimeData

@synthesize timedata = _timedata;
@synthesize basedate;
@synthesize columns = _columns;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _timedata = [[NSMutableArray alloc] init];
        _columns = [[NSMutableArray alloc] init];
        
        ///////////////////////////
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChannelHeadMoved:)
                                                     name:BEDA_NOTI_CHANNEL_HEAD_MOVED
                                                   object:nil];

    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
- (void) onChannelHeadMoved:(NSNotification *) notification {
    if ([ [self beda] isNavMode] == YES) {
        return;
    }
    if ([notification object] == Nil) {
        return;
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    ChannelTimeData* ch = (ChannelTimeData*)[notification object];
    
    if (self != [ch source]) {
        return;
    }
    
    double gt = [[self beda] gtAppTime];
    double lt = [ch headerTime];
    // gt + offset = lt
    [self setOffset:lt - gt];
//    NSLog(@"gt = %lf lt = %lf offset = %lf", gt, lt, [self offset]);


}
///////////////////////////////////////////////////////////////////////////////////////////


- (void)loadFile:(NSURL*)url {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSError* error = nil;
    
    // Allocate a new string with the content of file
    NSString* fileContents = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    if (error != nil) {
        NSLog(@"error = %@", error);
        return;
    }
    NSLog(@"File read OK. contents length = %lu" ,(unsigned long)[fileContents length]);
    [self setFilename:[url absoluteString]];

   
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    const int MAX_LOG_LINE = 60;
    
    // For each line
    float basems = 0;
    
    for (int i = 0; i < [lines count]; i++) {
        NSString* line = [lines objectAtIndex:i];
        if (line.length == 0) {
            continue;
        }
        if (i < MAX_LOG_LINE) NSLog(@"line: %@", line);
        if (i == MAX_LOG_LINE) NSLog(@"... hide the below lines ...");
        
        // Create a scanner for it
        NSScanner *scanner = [NSScanner scannerWithString:line];
        [scanner setCharactersToBeSkipped:
         [NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
        
        float zAxis, yAxis, xAxis, battery, Celsius, EDA;
        NSString *time = nil;
        
        // If we can parse the sensor data
        
        if ([scanner scanFloat:&zAxis] && [scanner scanFloat:&yAxis] && [scanner scanFloat:&xAxis] && [scanner scanFloat:&battery] && [scanner scanFloat:&Celsius] && [scanner scanFloat:&EDA] &&[scanner scanUpToString:@"" intoString:&time]) {
            // Process the values as needed.
            NSArray* tokens = [time componentsSeparatedByString:@"."];
            NSDate* date = [NSDate dateWithNaturalLanguageString:[tokens objectAtIndex:0]];
            float ms = [[tokens objectAtIndex:1] floatValue];
            if ([self basedate] == Nil) {
                [self setBasedate: [date dateByAddingTimeInterval:0]];
                basems = ms;
            }
            
            float secSinceBase = [date timeIntervalSinceDate:[self basedate]] + (ms - basems) / 1000.0f;
            float Accel = sqrt(xAxis * xAxis + yAxis * yAxis + zAxis * zAxis);
            
            [[self timedata] addObject:
             [NSDictionary dictionaryWithObjectsAndKeys:
              [NSDecimalNumber numberWithFloat:secSinceBase],
              [NSNumber numberWithInt:0],
              [NSDecimalNumber numberWithFloat:EDA],
              [NSNumber numberWithInt:1],
              [NSDecimalNumber numberWithFloat:Celsius],
              [NSNumber numberWithInt:2],
              [NSDecimalNumber numberWithFloat:Accel],
              [NSNumber numberWithInt:3],
              [NSDecimalNumber numberWithFloat:xAxis],
              [NSNumber numberWithInt:4],
              nil
              ]
             ];
            
            if (i < MAX_LOG_LINE) {
                //                NSLog(@"zAxis:%f, 1:%f, 2:%f, 3:%f:, 4:%f, time:{%@}, date: {%@}, ms:%f, sec = %f", zAxis, yAxis, xAxis, battery, Celsius, time, date, ms, secSinceBase);
                NSLog(@"x:%f, y:%f", secSinceBase, EDA);
                
            }
        } // end of if
    } // end of for
    
    [[self columns] removeAllObjects];
    [self setColumns:[NSMutableArray arrayWithObjects: @"Time", @"EDA", @"Temp", @"Accel", nil]];


    
    NSLog(@"basedate = %@", [self basedate]);
    NSLog(@"data.count = %ld", (unsigned long)[[self timedata] count]);
    
    
    NSString* fileName = [[url absoluteString] lastPathComponent];
    [self setName:fileName];
    
    NSLog(@"%s: channels.size() = %lu ", __PRETTY_FUNCTION__, (unsigned long)[[self channels] count]);

}

- (double)minValueForColumn:(int)index {
    double minValue = 999999999.9;
    NSMutableArray* data = [self timedata];
    for (int i = 0; i < [[self timedata] count]; i++) {
        double v = [[[data objectAtIndex:i] objectForKey:[NSNumber numberWithInt:index]] doubleValue];
        if (minValue > v) {
            minValue = v;
        }
    }
    return floor(minValue);
}

- (double)maxValueForColumn:(int)index {
    double maxValue = -999999999.9;
    NSMutableArray* data = [self timedata];
    for (int i = 0; i < [[self timedata] count]; i++) {
        double v = [[[data objectAtIndex:i] objectForKey:[NSNumber numberWithInt:index]] doubleValue];
        if (maxValue < v) {
            maxValue = v;
        }
    }
    return round(maxValue);
}

-(double) maxTimeInSecond:(int)index {
    return [self maxValueForColumn:0];
}
@end
