//
//  ProjectManager.m
//  BEDA
//
//  Created by Jennifer Kim on 6/14/13.
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
    
    [[self beda]setNumProjects:[[self beda]numProjects] + 1];
    NSLog(@"# projects = %d", [[self beda ]numProjects]);

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
    
    NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"bedaproject"];
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    
    [xmlDoc setVersion:@"0.1"];
    [xmlDoc setCharacterEncoding:@"UTF-8"];
    NSMutableDictionary* bedaAttrs = [[NSMutableDictionary alloc] init];
    double apptime = [[self beda] gtAppTime];
    [bedaAttrs setObject: [NSString stringWithFormat:@"%lf", apptime ] forKey:@"apptime"];
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
                
                NSMutableString* graphName =  [[NSMutableString alloc] init];
                [graphName appendString:[[ch source] name]];
                [graphName appendString:@":"];
                [graphName appendString:[ch name]];
                [chattrs setObject:[ch name] forKey:@"name"];
                [chattrs setObject:graphName forKey:@"graphName"];
                [chattrs setObject:[self NSStringFromInt:[ch channelIndex]] forKey:@"index"];
                
                [chattrs setObject:[self NSStringFromDouble:[ch minValue]]  forKey:@"minValue"];
                [chattrs setObject:[self NSStringFromDouble:[ch maxValue]]  forKey:@"maxValue"];
                [chattrs setObject:[ch getLineColor]  forKey:@"lineColor"];
                [chattrs setObject:[ch getAreaColor]  forKey:@"areaColor"];
                [nodeChannel setAttributesWithDictionary:chattrs];
                [nodeSource addChild:nodeChannel];
                
                if([ch channelIndex] < 0){
                    NSXMLElement *nodeNumBeh = (NSXMLElement *)[NSXMLNode elementWithName:@"defbehaviors"];
                    NSMutableDictionary* nbattrs = [[NSMutableDictionary alloc] init];
                    [nbattrs setObject:[self NSStringFromInt:[[[ch source] annots] countDefinedBehaviors]] forKey:@"num"];
                    [nodeNumBeh setAttributesWithDictionary:nbattrs];
                    [nodeSource addChild:nodeNumBeh];
                    
                    for (Behavior* beh in [[[ch source] annots] behaviors]) {
                        NSXMLElement *nodeAnnot = (NSXMLElement *)[NSXMLNode elementWithName:@"annotbehavior"];
                        NSMutableDictionary* abattrs = [[NSMutableDictionary alloc] init];
                        
                        [abattrs setObject:[beh name] forKey:@"name"];
                        [abattrs setObject:[beh color] forKey:@"color"];
                        [abattrs setObject:[beh key] forKey:@"hotkey"];
                        
                        [nodeAnnot setAttributesWithDictionary:abattrs];
                        [nodeSource addChild:nodeAnnot];
                        
                        for (NSNumber* time in [beh times]) {
                            NSXMLElement *nodeTime = (NSXMLElement *)[NSXMLNode elementWithName:@"time"];
                            NSMutableDictionary* tattrs = [[NSMutableDictionary alloc] init];
                            [tattrs setObject: [NSString stringWithFormat:@"%lf", [time doubleValue]] forKey:@"t"];
                            [nodeTime setAttributesWithDictionary:tattrs];
                            [nodeAnnot addChild:nodeTime];
                        }
                        
                        NSXMLElement *nodeStat = (NSXMLElement *)[NSXMLNode elementWithName:@"stat"];
                        NSMutableDictionary* sattrs = [[NSMutableDictionary alloc] init];
                        [sattrs setObject: [[ch source] name] forKey:@"projectName"];
                        [sattrs setObject: [self NSStringFromInt:[beh numBehaviorIntervals]] forKey:@"nBehIntervals"];
                        [sattrs setObject: [self NSStringFromInt:[Behavior numTotalIntervals]] forKey:@"nTotalIntervals"];
                        [sattrs setObject: [self NSStringFromDouble:[beh percentBehaviorIntervals]] forKey:@"percentBehIntervals"];
                        
                        [nodeStat setAttributesWithDictionary:sattrs];
                        [nodeAnnot addChild:nodeStat];
                        
                    }
                }
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
    NSString* projname = [url absoluteString];
    NSLog(@"projname = %@", projname);
    
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
        [source setProjname:projname];
        // Clear old behaviors
        [[[source annots] behaviors] removeAllObjects];
        
        for (NSXMLElement* child2 in [child children]) {
            NSString* name2 = [child2 name];
            if ([name2 isEqualToString:@"channeltimedata"] == NO) {
                NSLog(@"Annotation behavior: %@",  name);

                NSString* name = [[child2 attributeForName:@"name"] stringValue];
                NSColor* color = [self colorFromString:[[child2 attributeForName:@"color"] stringValue]] ;
                NSString* key = [[child2 attributeForName:@"hotkey"] stringValue];
                
                Behavior* annot = [[Behavior alloc]
                         initWithName:name withColor:color withKey:key];
                [[source annots] addBehavior:annot];
                
                for(NSXMLElement* child3 in [child2 children]) {
                    NSString* name3 = [child3 name];
                    if ([name3 isEqualToString:@"time"] == NO){
                        continue;
                    }
                    float t = [[[child3 attributeForName:@"t"] stringValue] floatValue];
                    [[annot times] addObject:[NSNumber numberWithFloat:t]];
                    NSLog(@"Time : %f",  t);

                }
                
                continue;
            }
            
            int index = [[[child2 attributeForName:@"index"] stringValue] intValue];
            double minValue = [[[child2 attributeForName:@"minValue"] stringValue] doubleValue];
            double maxValue = [[[child2 attributeForName:@"maxValue"] stringValue] doubleValue];
            NSString* name = [[child2 attributeForName:@"name"] stringValue];
            NSString* graphName = [[child2 attributeForName:@"graphName"] stringValue];
            NSColor* lineColor = [self colorFromString:[[child2 attributeForName:@"lineColor"] stringValue]] ;
            NSColor* areaColor = [self colorFromString:[[child2 attributeForName:@"areaColor"] stringValue]] ;
            
            ChannelTimeData *ch = [[ChannelTimeData alloc] init];
            [ch setSource:source];
            
            [ch initGraph:graphName atIndex:index range:minValue to:maxValue
            withLineColor: lineColor
                areaColor: areaColor
                 isBottom:YES hasArea:YES];
            [ch setName:name];
            [[source channels] addObject:ch];
            
            //for (AnnotationBehavior* beh in [[[ch source] annots] behaviors]) 
        }
        NSLog(@"name: %@, url: %@, offset = %lf\n",  name, fileurl, offset);

    }
    [[self beda] createViewsForAllChannels];

    NSLog(@"gtAppTime = %lf\n",  [[self beda] gtAppTime]);

    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_CHANNEL_HEAD_MOVED
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_ANNOTATION_CHANGED
     object:nil];

    
}


@end
