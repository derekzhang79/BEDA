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


- (void)saveFile:(NSURL*)url {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSXMLElement *root =
    (NSXMLElement *)[NSXMLNode elementWithName:@"bedaproject"];
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    
    [xmlDoc setVersion:@"0.1"];
    [xmlDoc setCharacterEncoding:@"UTF-8"];
    
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
    for (NSXMLElement* child in [root children]) {
        NSString* name = [child name];
        if ([name isEqualToString:@"source"] == NO) {
            continue;
        }
        NSString* filename = [[child attributeForName:@"filename"] stringValue];
        NSURL* fileurl = [NSURL URLWithString:filename];
        NSString* offsetStr = [[child attributeForName:@"offset"] stringValue];
        double offset = [offsetStr doubleValue];

        NSLog(@"name: %@, url: %@, offset = %lf\n",  name, fileurl, offset);
        [[self beda] openFileAtURL:fileurl];
        
        Source* source = [[[self beda] sources] lastObject];
        [source setOffset:offset];
    }

//    NSLog(@"\n\n%@\n\n",     [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint]);

    
}


@end
