//
//  DataAddController.m
//  BEDA
//
//  Created by Jennifer Kim on 2/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "DataAddController.h"

@implementation DataAddController

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)openFile:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Show the OpenPanel
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"mov", @"avi", @"mp4", @"csv", nil]];
    long tvarInt = [panel runModal];
    
    // If user cancels it, do NOT proceed
    if (tvarInt != NSOKButton) {
        NSLog(@"User cancel the open command");
        return;
    }
    
    // Get URL and extract the URL
    NSURL *url = [panel URL];
    NSString *ext = [[url path] pathExtension];
    NSLog(@"url = %@ [ext = %@]", url, ext);
    
    if ([ext isEqualToString:@"csv"]) {
        [self openSensorFile:url];
    } else {
        [self openMovieFile:url];
    }
    
    
}

- (IBAction)openProject:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)openMovieFile:(NSURL*)url {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // If we have both movie, do not need to load a new movie
    if ([dm movie1] != Nil && [dm movie2] != Nil) {
        NSLog(@"We do not have empty movie: movie1 and movie2 are not Nil");
        return;
    }
    
    // Allocate a new movie
    NSError* error = nil;
    QTMovie *newMovie = [QTMovie movieWithURL:url error:&error];
    // If there's an error, ..
    if (error != nil) {
        NSLog(@"Error for openMovieFile: %@", error);
        return;
    }
    
    // Set to the first or second movie to dataManager
    if ([dm movie1] == Nil) {
        NSLog(@"setMovie1");
        [dm setMovie1:newMovie];
    } else {
        NSLog(@"setMovie2");
        [dm setMovie2:newMovie];
    }    
    
}


- (void)openSensorFile:(NSURL*)url {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSError* error = nil;
    
    // Allocate a new string with the content of file
    NSString* fileContents = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    if (error != nil) {
        NSLog(@"error = %@", error);
        return;
    }
    NSLog(@"File read OK. contents length = %lu" ,(unsigned long)[fileContents length]);
    
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    const int MAX_LOG_LINE = 20;
    
    // For each line
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
        while ([scanner scanFloat:&zAxis] && [scanner scanFloat:&yAxis] && [scanner scanFloat:&xAxis] && [scanner scanFloat:&battery] && [scanner scanFloat:&Celsius] && [scanner scanFloat:&EDA] &&[scanner scanUpToString:@"" intoString:&time]) {
            // Process the values as needed.
            if (i < MAX_LOG_LINE) {
                NSLog(@"zAxis:%f, 1:%f, 2:%f, 3:%f:, 4:%f, time: {%@}", zAxis, yAxis, xAxis, battery, Celsius, time);
            }
        }
    }
    
}

@end
