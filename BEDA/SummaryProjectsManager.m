//
//  SummaryProjectsManager.m
//  BEDA
//
//  Created by Jennifer Kim on 6/28/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "SummaryProjectsManager.h"

@implementation SummaryProjectsManager
- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[spc plotXData] removeAllObjects];
    [[spc plotYData] removeAllObjects];
}

- (IBAction)loadProject:(id)sender{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Show the OpenPanel
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"xml", nil]];
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
    [self loadFile:url];
    
}

- (NSColor*)colorFromString:(NSString*)string
{
    NSArray *componentStrings = [string componentsSeparatedByString:@" "];
    NSColor *color = nil;
    color = [NSColor colorWithCalibratedRed:[componentStrings[1] floatValue]  green:[componentStrings[2] floatValue] blue:[componentStrings[3] floatValue] alpha:[componentStrings[4] floatValue]];
    
    return color;
}

- (void)loadFile:(NSURL*)url {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSXMLDocument *xmlDoc;
    NSError *err=nil;
    xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:url
                                                  options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                    error:&err];
    if (xmlDoc == nil) {
        xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:url
                                                      options:NSXMLDocumentTidyXML
                                                        error:&err];
    }
    if (xmlDoc == nil)  {
        NSLog(@"Load failed on file %@", url);
        if (err) {
            NSLog(@"Error: %@", err);
            
        }
        return;
    }
    NSLog(@"Load OK on file %@", url);
    
    NSXMLElement *root = [xmlDoc rootElement];
    NSString* projectName = @"*^^*"; // Some temporary random not-meaningful name
    // Read app time
    for (NSXMLElement* child in [root children]) {
        NSString* name = [child name];
        if ([name isEqualToString:@"source"] == NO) {
            continue;
        }
        for (NSXMLElement* child2 in [child children]) {
            NSString* name2 = [child2 name];
            if ([name2 isEqualToString:@"annotbehavior"] == YES) {
                NSString* annotBehName = [[child2 attributeForName:@"name"] stringValue];
                NSString* colorString = [[child2 attributeForName:@"color"] stringValue];
                NSColor* annotBehColor = [self colorFromString:colorString];
                
                for(NSXMLElement* child3 in [child2 children]) {
                    NSString* name3 = [child3 name];
                       if ([name3 isEqualToString:@"stat"] == YES){
                           double percentBehIntervals = [[[child3 attributeForName:@"percentBehIntervals"] stringValue] doubleValue];
                           projectName = [[child3 attributeForName:@"projectName"] stringValue];
                           NSLog(@"percentBehIntervals = %lf%%", percentBehIntervals);
                           
                           // NOTE: this function does NOT add plot if there exists the plot with the same name
                           [spc addPlotAndDataWithName:annotBehName inColor:annotBehColor];
                           
                           NSMutableArray* data = [spc findYDataWithName:annotBehName];
                           [data addObject:[NSNumber numberWithDouble:percentBehIntervals]];

                           // [[spc plotYData] addObject:[NSNumber numberWithDouble:percentBehIntervals]];
                       }
                                        
                }
                
            }
        }
        
    }
    // At the very end of the function, we add X data (just one for each project)
    [[spc plotXData] addObject:projectName];
    [spc reloadGraph];

}

@end
