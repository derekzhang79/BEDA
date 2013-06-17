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
@synthesize graphName;
@synthesize graphStyle;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"%s: # of beda sources = %ld", __PRETTY_FUNCTION__, (unsigned long)[[[self beda] sources] count]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSourceAdded:)
                                                 name:BEDA_NOTI_SOURCE_ADDED object:Nil];
    
    [self setTvc:Nil];
    
}


- (IBAction)onApplySettings:(id)sender{
     NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"graphName: [%@]", [self graphName]);
    NSLog(@"graphStyle: [%@]", [self graphStyle]);
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
    TableViewController* viewController = [[TableViewController alloc]
                                            initWithNibName:@"TableView" bundle:nil];
    [self setTvc:viewController];
    [viewController setSource:s];
    [item setView:[viewController view]];

    // Add a new tab to the tabview
    [tabview addTabViewItem:item];

}

- (IBAction)getGraphColor:(id)sender{
    NSColor *color  = [graphColor color];
    NSLog(@"%s, Graph color name %@", __PRETTY_FUNCTION__, color);
    
}

- (IBAction)getAreaColor:(id)sender{
    NSColor *color  = [areaColor color];
    NSLog(@"%s, aREA color name %@", __PRETTY_FUNCTION__, color);
    
}

- (IBAction)openFile:(id)sender {
    [[self beda] openFile:nil];

}

- (IBAction)onAddGraph:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([[self tvc] selectedTableColumn] == -1) {
        NSLog(@"%s: there's no selected graph", __PRETTY_FUNCTION__);
    }
    
    s = [[[self beda] sources] lastObject];

    // Step 1. Create the proper channel
    ChannelTimeData *ch = [[ChannelTimeData alloc] init];
    [ch setSource:s];

    // Step 2. initialize the graph
    int index = [[self tvc] selectedTableColumn];
    NSString* name = [[self tvc] selectedTableColumnName];
    double min = 0.0;
    double max = 10.0;
    NSColor *lc  = [graphColor color];
    NSColor *ac  = [areaColor color];
    BOOL isBottom = YES;
    BOOL hasArea = YES;
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
