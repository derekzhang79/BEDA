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

- (void) onSourceAdded:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    Source* s = [[[self beda] sources] lastObject];
    if ([s isKindOfClass:[SourceTimeData class]]) {
        [self onSourceTimeDataAdded:noti];
    } else {
        NSLog(@"%s: No tab view for source [%@]", __PRETTY_FUNCTION__, [s name]);
    }
    
}

- (void) onSourceTimeDataAdded:(NSNotification*) noti {
    //////////////////// TESTING /////////////////////////
    NSLog(@"%s", __PRETTY_FUNCTION__);

    SourceTimeData* s = [[[self beda] sources] lastObject];
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

- (IBAction)openFile:(id)sender
{
    [[self beda] openFile:nil];

}


- (BedaController*) beda {
    return [BedaController getInstance];
}

@end
