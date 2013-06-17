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

@implementation GraphWindowController

@synthesize tvc = _tvc;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"%s: # of beda sources = %ld", __PRETTY_FUNCTION__, (unsigned long)[[[self beda] sources] count]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSourceAdded:)
                                                 name:BEDA_NOTI_SOURCE_ADDED object:Nil];
    
    [self setTvc:Nil];
    
}


- (IBAction)onApplySettings:(id)sender{
     NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"Selected column = %d", [[self tvc] selectedTableColumn]);
    NSLog(@"Selected column name = %@", [[self tvc] selectedTableColumnName]);
    NSString *selectedColumn = [[self tvc] selectedTableColumnName];
    
    NSTabViewItem *item = [[[NSTabViewItem alloc]
                            initWithIdentifier:selectedColumn] autorelease];
    [item setLabel:selectedColumn];
    NSViewController* viewController = [[NSViewController alloc]
                                           initWithNibName:@"GraphSettingView" bundle:nil];
    
    [item setView:[viewController view]];
    [graphControlTabview addTabViewItem:item];
    
}


- (BedaController*) beda {
    return [BedaController getInstance];
}

@end
