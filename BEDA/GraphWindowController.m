//
//  GraphWindowController.m
//  BEDA
//
//  Created by Sehoon Ha on 6/13/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "GraphWindowController.h"
#import "BedaController.h"
#import "Source.h"
#import "SourceTimeData.h"
#import "ChannelTimeData.h"

@implementation GraphWindowController

@synthesize tvc = _tvc;
@synthesize gsc = _gsc;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"%s: # of beda sources = %ld", __PRETTY_FUNCTION__, (unsigned long)[[[self beda] sources] count]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSourceAdded:)
                                                 name:BEDA_NOTI_SOURCE_ADDED object:Nil];
    
    [self setTvc:Nil];
    
}


- (void) onSourceAdded:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    s = [[[self beda] sources] lastObject];
    if ([s isKindOfClass:[SourceTimeData class]]) {
        [self onSourceTimeDataAdded:noti];
    } else {
        NSLog(@"%s: No tab view for source [%@]", __PRETTY_FUNCTION__, [s name]);
    }
    
}

- (void) onSourceTimeDataAdded:(NSNotification*) noti {
    //////////////////// TESTING /////////////////////////
    NSLog(@"%s", __PRETTY_FUNCTION__);

    s = [[[self beda] sources] lastObject];
    NSString* name = [s name];
    NSLog(@"creating a tab for source [%@]", name);
    // Create a tab view item
    NSTabViewItem *item = [[[NSTabViewItem alloc]
                            initWithIdentifier:name] autorelease];
    [item setLabel:name];

    // Create a custum view and assign it to the tab view item
    TableViewController* tableViewController = [[TableViewController alloc]
                                            initWithNibName:@"TableView" bundle:nil];
    [self setTvc:tableViewController];
    [tableViewController setSource:s];
    [item setView:[tableViewController view]];

    // Add a new tab to the tabview
    [tabview addTabViewItem:item];

}

- (IBAction)openFile:(id)sender {
    [[self beda] openFile:nil];

}

- (IBAction)onAddGraph:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([[self tvc] selectedTableColumn] == -1) {
        NSLog(@"%s: there's no selected graph", __PRETTY_FUNCTION__);
    }
    
    NSMutableString* name =  [[NSMutableString alloc] init];
    
    [name appendString:[s name]];
    [name appendString:@":"];
    [name appendString:[[self tvc] selectedTableColumnName]];
    
    // Create a tab view item
    NSTabViewItem *item = [[[NSTabViewItem alloc]
                            initWithIdentifier:name] autorelease];
    [item setLabel:name];
    
    GraphSettingController* graphSettingController = [[GraphSettingController alloc]
                                                initWithNibName:@"GraphSettingView" bundle:nil];
    [self setGsc:graphSettingController];
    [item setView:[graphSettingController view]];
    [graphControlTabview addTabViewItem:item];

}


- (IBAction)onApplySettings:(id)sender{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    s = [[[self beda] sources] lastObject];
    
    // Step 1. Create the proper channel
    ChannelTimeData *ch = [[ChannelTimeData alloc] init];
    [ch setSource:s];
    
    // Step 2. initialize the graph
    int index = [[self tvc] selectedTableColumn];
    double min = [[self gsc] getMinValue];
    double max = [[self gsc] getMaxValue];

//    double min = [[self tvc] minValue];
//    double max = [[self tvc] maxValue];
    
    BOOL isBottom = YES;
    BOOL hasArea = YES;
    
    NSColor *lc = [[self gsc] getGraphColor];
    NSColor *ac = [[self gsc] getAreaColor];
    NSLog(@"GRAPH COLOR:%@, AREA COLOR:%@",lc, ac);
    
    NSString* name = [[self gsc] getGraphName];
    NSLog(@"GRAPH Name:%@",name);
    
    [ch initGraph:name atIndex:index range:min to:max withLineColor:lc areaColor:ac isBottom:isBottom hasArea:hasArea];
    
    // Step 3. Add to the created channel to the source
    [[s channels] addObject:ch];
    
    // Step 4. Create a corresponding view
    [ch createGraphViewFor:[self beda]];
    [[self beda] spaceProportionalyMainSplit];

}

- (BedaController*) beda {
    return [BedaController getInstance];
}

@end
