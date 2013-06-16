//
//  TableViewController.m
//  BEDA
//
//  Created by Sehoon Ha on 6/16/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "TableViewController.h"

@implementation TableViewController

@synthesize source = _source;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    {
        // Add TableColumn for Time
        NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:@"T"];
        [[column headerCell] setStringValue:@"T"];
        [column setWidth:120];
        [tableview addTableColumn:column];
    }
    
    {
        // Add TableColumn for EDA
        NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:@"EDA"];
        [[column headerCell] setStringValue:@"EDA"];
        [column setWidth:120];
        [tableview addTableColumn:column];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 2;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSTextField *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    if (result == nil) {
        result = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 18)] autorelease];
        result.identifier = @"MyView";
        [result setBezeled:NO];
        [result setDrawsBackground:NO];
        [result setEditable:NO];
        [result setSelectable:NO];
    }
    NSMutableArray* data = [[self source] timedata];
    
    // If we do not have data for the given row
    if (row >= [data count]) {
        result.stringValue = @"---";
        return result;
    }
    
    
    if ([tableColumn.identifier isEqualToString:@"T"]) {
        NSDecimalNumber *num = [[data objectAtIndex:row] objectForKey:[NSNumber numberWithInt:0]];

        result.stringValue = [NSString stringWithFormat:@"%.3lf", [num doubleValue]];

    } else {
        result.stringValue = @"???";

    }
    
    
    return result;
}

@end
