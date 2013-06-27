//
//  ProjectManager.m
//  BEDA
//
//  Created by Sehoon Ha on 6/14/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ProjectManager.h"
#import "BedaController.h"
#import "Source.h"
#import "SourceTimeData.h"
#import "Channel.h"
#import "ChannelTimeData.h"

@implementation ProjectManager


- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (BedaController*)beda {
    return [BedaController getInstance];
}

- (IBAction)openProject:(id)sender {
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

- (IBAction)saveProject:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Show the OpenPanel
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"xml", nil]];
    long tvarInt = [panel runModal];
    
    // If user cancels it, do NOT proceed
    if (tvarInt != NSOKButton) {
        NSLog(@"User cancel the open command");
        return;
    }
    
    // Get URL and extract the URL
    NSURL *url = [panel URL];
    //    NSString *ext = [[url path] pathExtension];
    [self saveFile:url];
}

- (NSString*) NSStringFromDouble : (double)v {
    return [NSString stringWithFormat:@"%lf", v];
}


- (NSString*) NSStringFromInt : (int)v {
    return [NSString stringWithFormat:@"%d", v];
}


- (void)saveFile:(NSURL*)url {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSXMLElement *root =
    (NSXMLElement *)[NSXMLNode elementWithName:@"bedaproject"];
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    
    [xmlDoc setVersion:@"0.1"];
    [xmlDoc setCharacterEncoding:@"UTF-8"];
    NSMutableDictionary* bedaAttrs = [[NSMutableDictionary alloc] init];
    double apptime = [[self beda] gtAppTime];
    [bedaAttrs setObject: [NSString stringWithFormat:@"%lf", apptime ]
                  forKey:@"apptime"];
    [root setAttributesWithDictionary:bedaAttrs];

    
    for (Source* s in [ [self beda] sources]) {
        NSXMLElement *nodeSource =
        (NSXMLElement *)[NSXMLNode elementWithName:@"source"];
        // Set attribute
        NSMutableDictionary* attrs = [[NSMutableDictionary alloc] init];
        [attrs setObject:[s filename] forKey:@"filename"];
        [attrs setObject:[NSString stringWithFormat:@"%lf", [s offset]] forKey:@"offset"];
        
        [nodeSource setAttributesWithDictionary:attrs];
        
        // Add to the root
        [root addChild:nodeSource];
        
        if ([s isKindOfClass:[SourceTimeData class]] == YES) {
            for (ChannelTimeData* ch in [s channels]) {
                NSXMLElement *nodeChannel = (NSXMLElement *)[NSXMLNode elementWithName:@"channeltimedata"];
                NSMutableDictionary* chattrs = [[NSMutableDictionary alloc] init];

                [chattrs setObject:[ch name] forKey:@"name"];
                [chattrs setObject:[self NSStringFromInt:[ch channelIndex]] forKey:@"index"];
                [chattrs setObject:[self NSStringFromDouble:[ch minValue]]  forKey:@"minValue"];
                [chattrs setObject:[self NSStringFromDouble:[ch maxValue]]  forKey:@"maxValue"];

                
//                [ch initGraph:@"Annotation" atIndex:index range:minValue to:maxValue
//                withLineColor: [NSColor blueColor]
//                    areaColor:[NSColor magentaColor]
//                     isBottom:YES hasArea:NO];
                [nodeChannel setAttributesWithDictionary:chattrs];
//                
                [nodeSource addChild:nodeChannel];
            }
        }

    }
    NSLog(@"\n\n%@\n\n",     [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint]);
    
    NSLog(@"attemp to file %@", url);
    NSData *xmlData = [xmlDoc XMLDataWithOptions:NSXMLNodePrettyPrint];
    if (![xmlData writeToURL:url atomically:YES]) {
        NSLog(@"Could not write document out...");
    } else {
        NSLog(@"Write OK");
        
    }
    
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
    double apptime = [[[root attributeForName:@"apptime"] stringValue] doubleValue];
    [[self beda] setGtAppTime:apptime];
    NSLog(@"AppTime = %lf", apptime);
    
    for (NSXMLElement* child in [root children]) {
        NSString* name = [child name];
        if ([name isEqualToString:@"source"] == NO) {
            continue;
        }
        NSString* filename = [[child attributeForName:@"filename"] stringValue];
        NSURL* fileurl = [NSURL URLWithString:filename];
        NSString* offsetStr = [[child attributeForName:@"offset"] stringValue];
        double offset = [offsetStr doubleValue];

        [[self beda] openFileAtURL:fileurl];
        
        Source* source = [[[self beda] sources] lastObject];
        [source setOffset:offset];
        
        for (NSXMLElement* child2 in [child children]) {
            NSString* name2 = [child2 name];
            if ([name2 isEqualToString:@"channeltimedata"] == NO) {
                continue;
            }
            
            int index = [[[child2 attributeForName:@"index"] stringValue] intValue];
            double maxValue = [[[child2 attributeForName:@"maxValue"] stringValue] doubleValue];
            double minValue = [[[child2 attributeForName:@"minValue"] stringValue] doubleValue];
            NSString* name = [[child2 attributeForName:@"name"] stringValue];
            
            ChannelTimeData *ch = [[ChannelTimeData alloc] init];
            [ch setSource:source];
            
            [ch initGraph:@"Annotation" atIndex:index range:minValue to:maxValue
            withLineColor: [NSColor blueColor]
                areaColor:[NSColor magentaColor]
                 isBottom:YES hasArea:NO];
            [ch setName:name];
            [[source channels] addObject:ch];
        }
        NSLog(@"name: %@, url: %@, offset = %lf\n",  name, fileurl, offset);

    }

    
    [[self beda] createViewsForAllChannels];

    NSLog(@"gtAppTime = %lf\n",  [[self beda] gtAppTime]);

    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_CHANNEL_HEAD_MOVED
     object:nil];
    
    
//    NSLog(@"\n\n%@\n\n",     [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint]);

    
}


@end
