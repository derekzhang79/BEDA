//
//  DataAnalysisController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/25/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "DataAnalysisController.h"
#import "BedaController.h"
#import "Source.h"
#import "ChannelTimeData.h"

@implementation DataAnalysisController

@synthesize channels = _channels;
@synthesize results = _results;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _channels = [[NSMutableArray alloc] init];
    _results = [[NSMutableDictionary alloc] init];
    [self populateChannels];
}

- (void) populateChannels {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[self channels] removeAllObjects];
    
    for (Source* s in [[self beda] sources]) {
        for (Channel* ch in [s channels]) {
            if ([ch isKindOfClass:[ChannelTimeData class]] == NO) {
                continue;
            }
            ChannelTimeData* cht = (ChannelTimeData*)ch;
            if ([cht channelIndex] < 0) {
                continue;
            }
            [[self channels] addObject:cht];
        }
    }
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return [[self channels] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([tableColumn.identifier isEqualToString:@"GraphNameColumn"]) {
        NSTextField *text = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 30, 10)] autorelease];
        ChannelTimeData* ch = [[self channels] objectAtIndex:row];
        SourceTimeData* source = [ch sourceTimeData];
        NSMutableString* name =  [[NSMutableString alloc] init];
        [name appendString:[source name]];
        [name appendString:@":"];
        [name appendString:[ch name]];
        
        [text setStringValue:name];
        [text setBezeled:NO];
        [text setDrawsBackground:NO];
        [text setEditable:NO];
        [text setSelectable:YES];
        
        return text;
    } else {
        NSMutableArray* resultArray = [[self results] objectForKey:tableColumn.identifier];
        NSString* value = [resultArray objectAtIndex:row];

        NSScrollView* scroll = [[[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, 150, 50)] autorelease];
        [scroll setHasVerticalScroller:YES];
        
//        NSTextField *text = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 30, 10)] autorelease];
        NSTextView *text = [[[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 180, 50)] autorelease];
//        [text setStringValue:value];
        [text setString:value];
        //        key.identifier = @"keyView";
//        [text setBezeled:NO];
        [text setDrawsBackground:NO];
        [text setEditable:NO];
        [text setSelectable:YES];
        [text setRulerVisible:YES];
        
        [scroll setDocumentView:text];
        return scroll;

    }
    return Nil;
}

-(IBAction)doAnalysis:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

//    NSString* scriptname = @"mean.R";
    NSString* scriptname = [comboBoxScriptSelection stringValue];
    NSMutableArray* currentResult = [[NSMutableArray alloc] init];
    for (ChannelTimeData* ch in [self channels]) {
        [self writeToCSV:ch];
        [self runScript:scriptname];
        NSString* result = [self readFromCSV];
        NSLog(@"result = %@", result);
        [currentResult addObject:result];
    }
    [[self results] setObject:currentResult forKey:scriptname];

    // Manipulate the table
    NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:scriptname];
    [[column headerCell] setStringValue:scriptname];
    [column setWidth:150];
    [tableview addTableColumn:column];
    
    [tableview reloadData];
}

- (void)writeToCSV:(ChannelTimeData*)ch {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableString* filename =  [[NSMutableString alloc] init];
    [filename appendString:[[NSBundle mainBundle] resourcePath]];
    [filename appendString:@"/input.csv"];

    NSLog(@"filename = %@", filename);

    NSMutableString* content =  [[NSMutableString alloc] init];
    
    int index = [ch channelIndex];
    SourceTimeData* source = [ch sourceTimeData];
    NSMutableArray* data = [source timedata];
    for (int i = 0; i < [[source timedata] count]; i++) {
        double v = [[[data objectAtIndex:i] objectForKey:[NSNumber numberWithInt:index]] doubleValue];
        [content appendString:[NSString stringWithFormat:@"%lf\n", v]];
    }
    [content writeToFile:filename atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
}

- (void)runScript:(NSString*)scriptname {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSMutableString* filename =  [[NSMutableString alloc] init];
    [filename appendString:[[NSBundle mainBundle] resourcePath]];
    [filename appendString:@"/"];
    [filename appendString:scriptname];
    
    NSLog(@"filename = %@", filename);

    NSArray *args = [NSArray arrayWithObjects: @"CMD", @"BATCH", filename, nil];

    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/R"];
    [task setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    [task setArguments:args];
    [task launch];
    [task waitUntilExit];
    
    NSLog(@"%s: OK", __PRETTY_FUNCTION__);
}

- (NSString*)readFromCSV {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableString* filename =  [[NSMutableString alloc] init];
    [filename appendString:[[NSBundle mainBundle] resourcePath]];
    [filename appendString:@"/output.csv"];
    
    NSLog(@"filename = %@", filename);

    NSString* output = [NSString stringWithContentsOfFile:filename encoding:NSStringEncodingConversionAllowLossy error:Nil];
    // output = [output stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return output;
}

- (BedaController*) beda {
    return [BedaController getInstance];
}

@end