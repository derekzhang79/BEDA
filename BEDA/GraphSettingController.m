//
//  GraphSettingController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "GraphSettingController.h"

@implementation GraphSettingController

@synthesize source;
@synthesize channel;
@synthesize columnIndex;
@synthesize isAutomatic;
@synthesize txtMaxValue;
@synthesize txtMinValue;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableString* name =  [[NSMutableString alloc] init];
    [name appendString:[[self source] name]];
    [name appendString:@":"];
    [name appendString:[[self channel] name]];
    
    [[self txtMinValue] setDoubleValue:[channel minValue]];
    [[self txtMaxValue] setDoubleValue:[channel maxValue]];
    [self setGraphTitle:name];
    [self setSelectedColumnTitle:name];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplySettingPressed:)
                                                 name:BEDA_NOTI_APPLY_SETTING_PRESSED object:Nil];
    
}

-(IBAction)radioButton:(id)sender {
    NSMatrix *radioMatrix = sender;
    NSButtonCell *radioButton = [radioMatrix selectedCell];
    NSInteger row;
    NSInteger column;
    [radioMatrix getRow:&row column:&column ofCell:radioButton];
    NSLog(@"radioButton: row=%d column=%d", (int)row, (int)column);
    if( row == 0){ // automatically calculate min max
        isAutomatic = YES;
    } else if (row == 1){// user input min max
        isAutomatic = NO;
    }
}

- (NSColor*)getGraphColor{
    NSColor *color  = [graphColor color];
    NSLog(@"%s, Graph color name %@", __PRETTY_FUNCTION__, color);
    return color;
    
}

- (NSColor*)getAreaColor{
    NSColor *color  = [areaColor color];
    NSLog(@"%s, aREA color name %@", __PRETTY_FUNCTION__, color);
    return color;
}

- (NSString*)getGraphName{
    return [graphName stringValue];
}

- (void)setGraphTitle:(NSString*)name{
    NSLog(@"%s:%@", __PRETTY_FUNCTION__, name);
    [graphName setStringValue:name];
}

- (void)setSelectedColumnTitle:(NSString*)name{
    NSLog(@"%s:%@", __PRETTY_FUNCTION__, name);
    [selectedColumnName setStringValue:name];
}

- (void) onApplySettingPressed:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[self channel] setLineColor:[self getGraphColor]];
    [[self channel] setAreaColor:[self getAreaColor]];
    [[self channel] setGraphName:[self getGraphName]];
    if(isAutomatic == NO){
        [[self channel] setRangeFrom:[[self txtMinValue] doubleValue] to:[[self txtMaxValue] doubleValue]];
    }
}

@end
