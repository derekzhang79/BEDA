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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return (int)[tableview selectedColumn];
}

- (NSString*) selectedTableColumnName {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [[self columns] objectAtIndex:[self selectedTableColumn]];
}

- (NSMutableArray*) columns {
    return [[self source] columns];
}

- (double) minValue {
    NSMutableArray* column = [[self source] columns];
    NSNumber* min = [[column objectAtIndex:0] objectAtIndex:0];
    
    NSLog(@"%s, minValue=%f", __PRETTY_FUNCTION__, [min doubleValue]);
    
    //    NSNumber* min = [column valueForKeyPath:@"@min.self"];
    return [min doubleValue];
}


- (double) maxValue {
    NSMutableArray* column = [[self source] columns];
    NSNumber* max = [column valueForKeyPath:@"@max.self"];
    
    NSLog(@"%s, maxValue=%f", __PRETTY_FUNCTION__, [max doubleValue]);
    return [max doubleValue];
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
