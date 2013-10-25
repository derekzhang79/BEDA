//
//  BedaSetting.m
//  BEDA
//
//  Created by Jennifer Kim on 10/21/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "BedaSetting.h"

@implementation BedaSetting

@synthesize scriptnames = _scriptnames;
@synthesize execMatlab = _execMatlab;
@synthesize execR = _execR;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _scriptnames = [[NSMutableArray alloc] init];
        [self loadDefaultFile];
//        _scriptnames = [[NSMutableArray alloc] initWithObjects:@"median.R", @"script.m", nil];

    }
    
    return self;
}

- (void)loadDefaultFile {
    NSMutableString* filename =  [[NSMutableString alloc] init];
    [filename appendString:@"file://"];
    [filename appendString:[[NSBundle mainBundle] resourcePath]];
    [filename appendString:@"/"];
    [filename appendString:@"setting.xml"];
    NSURL *url = [NSURL URLWithString:filename];
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
//    NSLog(@"root name = %@", [root name]);
    for (NSXMLElement* child in [root children]) {
        NSString* name = [child name];
//        NSLog(@"child name = %@", name);
        if ([name isEqualToString:@"script"] == YES) {
            NSString* scriptname = [child stringValue];
            NSLog(@"script = %@", scriptname);
            [[self scriptnames] addObject:scriptname];
        } else if ([name isEqualToString:@"matlab"] == YES) {
            [self setExecMatlab:[child stringValue]];
            NSLog(@"matlab = %@", [self execMatlab]);
        } else if ([name isEqualToString:@"r"] == YES) {
            [self setExecR:[child stringValue]];
            NSLog(@"matlab = %@", [self execR]);
        }

    }
    
}

- (void)saveDefaultFile {
    NSMutableString* filename =  [[NSMutableString alloc] init];
    [filename appendString:@"file://"];
    [filename appendString:[[NSBundle mainBundle] resourcePath]];
    [filename appendString:@"/"];
    [filename appendString:@"setting.xml"];
    NSURL *url = [NSURL URLWithString:filename];
    [self saveFile:url];
}

- (void)saveFile:(NSURL*)url {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, url);
    
    NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"beda"];
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    
    [xmlDoc setVersion:@"0.1"];
    [xmlDoc setCharacterEncoding:@"UTF-8"];
    
    for (NSString* sn in [self scriptnames]) {
        NSXMLElement *nodeSN = (NSXMLElement *)[NSXMLNode elementWithName:@"script"];
        [nodeSN setStringValue:sn];
        [root addChild:nodeSN];
    }
    {
        NSXMLElement *nodeMatlab = (NSXMLElement *)[NSXMLNode elementWithName:@"matlab"];
        [nodeMatlab setStringValue:[self execMatlab]];
        [root addChild:nodeMatlab];
    }
    {
        NSXMLElement *nodeR = (NSXMLElement *)[NSXMLNode elementWithName:@"r"];
        [nodeR setStringValue:[self execR]];
        [root addChild:nodeR];
    }
    
    NSLog(@"\n\n%@\n\n",     [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint]);
    NSData *xmlData = [xmlDoc XMLDataWithOptions:NSXMLNodePrettyPrint];
    if (![xmlData writeToURL:url atomically:YES]) {
        NSLog(@"Could not write document out...");
    } else {
        NSLog(@"Write OK");
        
    }
}

@end
