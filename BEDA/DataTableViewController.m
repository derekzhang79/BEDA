//
//  DataTableViewController.m
//  BEDA
//
//  Created by Sehoon Ha on 6/15/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "DataTableViewController.h"

@implementation DataTableViewController

@synthesize source = _source;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    SourceTimeData* s = [[[self beda] sources] lastObject];
    [self setSource:s];
    NSLog(@"%s: source name = %@", __PRETTY_FUNCTION__, [[self source] name]);
    
    NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:@"MyView"];
    [[column headerCell] setStringValue:@"MYHEADER"];
    [column setWidth:60];
    [tableview addTableColumn:column];
    [tableview reloadData];

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%s = 2", __PRETTY_FUNCTION__);
    
    return 4;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSTextField *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    if (result == nil) {
        //        result = [[[NSTextField alloc] initWithFrame:...] autorelease];
        //        result = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 20)] autorelease];
        result = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 18)] autorelease];
        result.identifier = @"MyView";
        [result setBezeled:NO];
        [result setDrawsBackground:NO];
        [result setEditable:NO];
        [result setSelectable:NO];
    }
    
    result.stringValue = @"HEHE";
    //   [result.textField setStringValue:@"Haha"];
    
    // return the result.
    return result;
}


- (BedaController*) beda {
    return [BedaController getInstance];
}

@end
