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
    
    {
        // Add TableColumn for Time
        NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:@"Time"];
        [[column headerCell] setStringValue:@"Time"];
        [column setWidth:100];
        [tableview addTableColumn:column];
    }
    
    {
        // Add TableColumn for EDA
        NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:@"EDA"];
        [[column headerCell] setStringValue:@"EDA"];
        [column setWidth:100];
        [tableview addTableColumn:column];
    }
    
    {
        // Add TableColumn for EDA
        NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:@"Temp"];
        [[column headerCell] setStringValue:@"Temp"];
        [column setWidth:100];
        [tableview addTableColumn:column];
    }
    
    {
        // Add TableColumn for EDA
        NSTableColumn* column = [[NSTableColumn alloc] initWithIdentifier:@"Accel"];
        [[column headerCell] setStringValue:@"Accel"];
        [column setWidth:100];
        [tableview addTableColumn:column];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return (int)[data count];
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
    
    // If we do not have data for the given row
    if (row >= [data count]) {
        result.stringValue = @"---";
        return result;
    }
    
    
    if ([tableColumn.identifier isEqualToString:@"Time"]) {
        NSDecimalNumber *num = [[data objectAtIndex:row] objectForKey:[NSNumber numberWithInt:0]];
        result.stringValue = [NSString stringWithFormat:@"%.3lf", [num doubleValue]];

    }
    
    if ([tableColumn.identifier isEqualToString:@"EDA"]) {
        NSDecimalNumber *num = [[data objectAtIndex:row] objectForKey:[NSNumber numberWithInt:1]];
        result.stringValue = [NSString stringWithFormat:@"%.3lf", [num doubleValue]];
    }
    
    if ([tableColumn.identifier isEqualToString:@"Temp"]) {
        NSDecimalNumber *num = [[data objectAtIndex:row] objectForKey:[NSNumber numberWithInt:2]];
        result.stringValue = [NSString stringWithFormat:@"%.3lf", [num doubleValue]];
    }
    
    if ([tableColumn.identifier isEqualToString:@"Accel"]) {
        NSDecimalNumber *num = [[data objectAtIndex:row] objectForKey:[NSNumber numberWithInt:3]];
        result.stringValue = [NSString stringWithFormat:@"%.3lf", [num doubleValue]];
    }
    
    
    return result;
}

@end
