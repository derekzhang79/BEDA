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
    data = [[self source] timedata];
    
    for (NSString* cname in [[self source] columns]) {
        // Add TableColumn for Time
        NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:cname];
        [[column headerCell] setStringValue:cname];
        [column setWidth:100];
        [tableview addTableColumn:column];
    }
}

- (int) selectedTableColumn {
    return (int)[tableview selectedColumn];
}

- (NSString*) selectedTableColumnName {
    return [[self columns] objectAtIndex:[self selectedTableColumn]];
}

- (NSMutableArray*) columns {
    return [[self source] columns];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return (int)[data count];
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSTextField *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    if (result == nil) {
        result = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 18)] autorelease];
        result.identifier = @"MyView";
        [result setBezeled:NO];
        [result setDrawsBackground:NO];
        [result setEditable:NO];
        [result setSelectable:NO];
    }
    
    // If we do not have data for the given row
    if (row >= [data count]) {
        result.stringValue = @"---";
        return result;
    }
    
    
    for (int i = 0; i < [[[self source] columns] count]; i++) {
        NSString* cname = [[[self source] columns] objectAtIndex:i];
        if ([tableColumn.identifier isEqualToString:cname]) {
            NSDecimalNumber *num = [[data objectAtIndex:row] objectForKey:[NSNumber numberWithInt:i]];
            result.stringValue = [NSString stringWithFormat:@"%.3lf", [num doubleValue]];
            
        }
    }
    
    return result;
}

@end
