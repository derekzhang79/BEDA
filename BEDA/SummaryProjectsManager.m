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
    spc = [[SummaryProjectsController alloc] init];
    
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
    // Read app time
    for (NSXMLElement* child in [root children]) {
        NSString* name = [child name];
         [[spc plotXData] removeAllObjects];
         [[spc plotYData] removeAllObjects];
        if ([name isEqualToString:@"source"] == NO) {
            continue;
        }
        for (NSXMLElement* child2 in [child children]) {
            NSString* name2 = [child2 name];
            if ([name2 isEqualToString:@"channeltimedata"] == NO) {
                
                for(NSXMLElement* child3 in [child2 children]) {
                    NSString* name3 = [child3 name];
                       if ([name3 isEqualToString:@"stat"] == YES){
//                           int nBehvIntervals = [[[child3 attributeForName:@"nBehIntervals"] stringValue] intValue];
//                           int nTotalIntervals = [[[child3 attributeForName:@"nTotalIntervals"] stringValue] intValue];
                           double percentBehIntervals = [[[child3 attributeForName:@"percentBehIntervals"] stringValue] doubleValue];
                           NSLog(@"percentBehIntervals = %lf%%", percentBehIntervals);
                           [[spc plotXData] addObject:@"hello"];
                           [[spc plotYData] addObject:[NSNumber numberWithDouble:percentBehIntervals]];
                           [spc reloadGraph];
                       }
                                        
                }
                
            }
        }
        
    }
    
}

@end
