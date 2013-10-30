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
#import "ChannelExtraGraph.h"
#import "ChannelSelector.h"
#import "BedaSetting.h"

@implementation DataAnalysisController

@synthesize channels = _channels;
@synthesize results = _results;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [comboBoxScriptSelection removeAllItems];
    for (NSString* script in [[[self beda] setting] scriptnames]) {
        [comboBoxScriptSelection addItemWithObjectValue:script];
    }
    
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

-(IBAction)addScript:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Show the OpenPanel
    NSOpenPanel *panel = [NSOpenPanel savePanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"R", @"m", nil]];
    long tvarInt = [panel runModal];
    
    // If user cancels it, do NOT proceed
    if (tvarInt != NSOKButton) {
        NSLog(@"User cancel the open command");
        return;
    }
    
    // Get URL and extract the URL
    NSURL *url = [panel URL];
    
    NSString* filename = [[url absoluteString] lastPathComponent];
    [comboBoxScriptSelection addItemWithObjectValue:filename];
    
    NSString* src =  [url path];
    NSMutableString* dst = [[NSMutableString alloc] init];
    [dst appendString:[[NSBundle mainBundle] resourcePath]];
    [dst appendString:[NSString stringWithFormat:@"/%@", filename]];
    
    NSLog(@"src = %@", src);
    NSLog(@"dst = %@", dst);
    
    NSError *err=nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:dst error:nil];
    
    [[NSFileManager defaultManager] copyItemAtPath:src toPath:dst error:&err];
    if (err) {
        NSLog(@"Error: %@", err);
        
    }
    
    [[[[self beda] setting] scriptnames] addObject:filename];
    [[[self beda] setting] saveDefaultFile];
}

- (IBAction)editScript:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString* scriptname = [comboBoxScriptSelection stringValue];
    bool isR = [scriptname hasSuffix:@".R"];
    bool isM = [scriptname hasSuffix:@".m"];
    if (isR == NO && isM == NO) {
        NSLog(@"This is not a valid scriptname");
        return;
    }
//    NSLog(@"script = %@", scriptname);

    NSMutableString* filename =  [[NSMutableString alloc] init];
    [filename appendString:[[NSBundle mainBundle] resourcePath]];
    [filename appendString:@"/"];
    [filename appendString:scriptname];
    NSLog(@"filename = %@", filename);

    // Use "open -t filename" command to open it with the default text editor
    NSArray *args = [NSArray arrayWithObjects: @"-t", filename, nil];
    
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/open"];
    
    [task setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    [task setArguments:args];
    [task launch];
    [task waitUntilExit];
    
}


-(IBAction)doAnalysis:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

//    NSString* scriptname = @"mean.R";
    NSString* scriptname = [comboBoxScriptSelection stringValue];
    bool isR = [scriptname hasSuffix:@".R"];
    bool isM = [scriptname hasSuffix:@".m"];
    if (isR == NO && isM == NO) {
        NSLog(@"This is not a valid scriptname");
        return;
    }
    
    
    NSMutableArray* currentResult = [[NSMutableArray alloc] init];
    
    int chIndex = 0;
    for (ChannelTimeData* ch in [self channels]) {
        chIndex ++;
        [self writeToCSV:ch];
        [self runScript:scriptname];
        NSString* result = [self readFromCSV];
        NSLog(@"result = %@", result);
        [currentResult addObject:result];
        
        if ([scriptname isEqualToString:@"peak.R"]) {
            [self copyResultResultImages:chIndex];
        }
        if ([scriptname isEqualToString:@"allpeaks.m"]) {
            [self copyResultDetails:chIndex as:@"allpeaks"];
        }
        if ([scriptname isEqualToString:@"tonic_auc.m"]) {
            [self copyResultDetails:chIndex as:@"tonic_auc"];
        }
        if ([scriptname isEqualToString:@"SCR_amplitude.m"]) {
            [self copyResultDetails:chIndex as:@"SCR_amplitude"];
            [self readProcessedDataFrom:@"/output3.csv" into:ch];
        }
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
    int validDataCounter = 0;
    
    ChannelSelector* selector = [ch channelSelector];
    double lo = [selector left];
    double hi = [selector right];
    BOOL isSelectionVisible = [selector visible];
    int timeIndex = [source timeIndex];
    
    for (int i = 0; i < [[source timedata] count]; i++) {
        validDataCounter++;

        double t = [[[data objectAtIndex:i] objectForKey:[NSNumber numberWithInt:timeIndex]] doubleValue];
        if (isSelectionVisible && (t < lo || hi < t)) {
            continue;
        }
        double v = [[[data objectAtIndex:i] objectForKey:[NSNumber numberWithInt:index]] doubleValue];
        [content appendString:[NSString stringWithFormat:@"%lf\n", v]];
    }
    [content writeToFile:filename atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];

    NSLog(@"Total %d data are written", validDataCounter);

}

- (void)runScript:(NSString*)scriptname {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSString* stem = [scriptname substringToIndex:[scriptname length] - 2];
    NSLog(@"script stem = %@", stem);
    
    NSMutableString* filename =  [[NSMutableString alloc] init];
    [filename appendString:[[NSBundle mainBundle] resourcePath]];
    [filename appendString:@"/"];
    [filename appendString:scriptname];
    
    NSLog(@"filename = %@", filename);
    
    if ([[scriptname pathExtension] isEqualToString:@"R"]) {
        NSArray *args = [NSArray arrayWithObjects: @"CMD", @"BATCH", filename, nil];
        
        NSTask* task = [[NSTask alloc] init];
//        [task setLaunchPath:@"/usr/bin/R"];
        [task setLaunchPath:[[[self beda] setting] execR]];

        [task setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
        [task setArguments:args];
        [task launch];
        [task waitUntilExit];
    } else {
        NSArray *args = [NSArray arrayWithObjects: @"-nodesktop", @"-nosplash", @"-r", stem, nil];
        
        NSTask* task = [[NSTask alloc] init];
//        [task setLaunchPath:@"/usr/bin/matlab"];
        [task setLaunchPath:[[[self beda] setting] execMatlab]];

        [task setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
        [task setArguments:args];
        [task launch];
        [task waitUntilExit];
        
    }
    NSLog(@"%s: OK", __PRETTY_FUNCTION__);
}

- (NSString*)readFromCSV {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableString* filename =  [[NSMutableString alloc] init];
    [filename appendString:[[NSBundle mainBundle] resourcePath]];
    [filename appendString:@"/output.csv"];
    
    NSLog(@"filename = %@", filename);

    NSString* output = [NSString stringWithContentsOfFile:filename encoding:NSStringEncodingConversionAllowLossy error:Nil];
    return output;
}

- (void)readProcessedDataFrom : (NSString*) filename into:(ChannelTimeData*)ch {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableString* filepath =  [[NSMutableString alloc] init];
    [filepath appendString:[[NSBundle mainBundle] resourcePath]];
    [filepath appendString:filename];
    
    NSLog(@"filename = %@", filepath);
    
    NSString* filestr = [NSString stringWithContentsOfFile:filepath encoding:NSStringEncodingConversionAllowLossy error:Nil];
    NSArray *lines = [filestr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    
    NSLog(@"file has %ld lines", (unsigned long)[lines count]);
    
    ChannelExtraGraph* graph_tonic = [[ChannelExtraGraph alloc] initWithChannel:ch asLineColor: [NSColor colorWithCalibratedRed:0.109 green:0.363 blue:0.526 alpha:0.6] asAreaColor:[NSColor colorWithCalibratedRed:0.109 green:0.363 blue:0.526 alpha:0.2] ];
    ChannelExtraGraph* graph_phasic = [[ChannelExtraGraph alloc] initWithChannel:ch asLineColor:[NSColor colorWithCalibratedRed:0.055 green:0.097 blue:0.164 alpha:0.7] asAreaColor:[NSColor colorWithCalibratedRed:0.055 green:0.097 blue:0.164 alpha:0.3]];

    int MAX_LOG_LINE = 10;
    
    for (int i = 0; i < [lines count]; i++) {
        NSString* line = [lines objectAtIndex:i];
        NSScanner *scanner = [NSScanner scannerWithString:line];
        [scanner setCharactersToBeSkipped:
         [NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
        
        
        float tonic = 0.0;
        [scanner scanFloat:&tonic];
        [[graph_tonic data] addObject:[NSNumber numberWithFloat:tonic]];
        
        float phasic = 0.0;
        [scanner scanFloat:&phasic];
        [[graph_phasic data] addObject:[NSNumber numberWithFloat:phasic]];
        
        if (i < MAX_LOG_LINE) {
            NSLog(@"tonic = %f, phasic = %f", tonic, phasic);
        }
    }

    [[ch extraGraphs] addObject:graph_tonic];
    [graph_tonic reload];
    
    [[ch extraGraphs] addObject:graph_phasic];
    [graph_phasic reload];
}

- (void) copyResultDetails : (int)index as:(NSString*)name {
    NSMutableString* src =  [[NSMutableString alloc] init];
    [src appendString:[[NSBundle mainBundle] resourcePath]];
    [src appendString:@"/output2.csv"];
    
    NSMutableString* dst = [[NSMutableString alloc] init];
    [dst appendString:NSHomeDirectory()];
    [dst appendString:[NSString stringWithFormat:@"/Documents/beda_%@_%02d.csv", name, index]];
    
    NSLog(@"src = %@", src);
    NSLog(@"dst = %@", dst);
    
    NSError *err=nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:dst error:nil];
    
    [[NSFileManager defaultManager] copyItemAtPath:src toPath:dst error:&err];
    if (err) {
        NSLog(@"Error: %@", err);
        
    }
}

- (void) copyResultResultImages : (int)index {
    {
        NSMutableString* src =  [[NSMutableString alloc] init];
        [src appendString:[[NSBundle mainBundle] resourcePath]];
        [src appendString:@"/baseline.jpg"];
        
        NSMutableString* dst = [[NSMutableString alloc] init];
        [dst appendString:NSHomeDirectory()];
        [dst appendString:[NSString stringWithFormat:@"/Documents/baseline_%02d.jpg", index]];
        
        NSLog(@"src = %@", src);
        NSLog(@"dst = %@", dst);
        
        NSError *err=nil;

        [[NSFileManager defaultManager] copyItemAtPath:src toPath:dst error:&err];
        if (err) {
            NSLog(@"Error: %@", err);
            
        }
    }
    {
        NSMutableString* src =  [[NSMutableString alloc] init];
        [src appendString:[[NSBundle mainBundle] resourcePath]];
        [src appendString:@"/peaks.jpg"];
        
        NSMutableString* dst = [[NSMutableString alloc] init];
        [dst appendString:NSHomeDirectory()];
        [dst appendString:[NSString stringWithFormat:@"/Documents/peaks_%02d.jpg", index]];
        
        NSLog(@"src = %@", src);
        NSLog(@"dst = %@", dst);
        
        NSError *err=nil;
        
        [[NSFileManager defaultManager] copyItemAtPath:src toPath:dst error:&err];
        if (err) {
            NSLog(@"Error: %@", err);
            
        }
    }
}


- (BedaController*) beda {
    return [BedaController getInstance];
}

@end
