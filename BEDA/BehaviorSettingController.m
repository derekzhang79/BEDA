//
//  BehaviorSettingController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/19/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "BehaviorSettingController.h"

@implementation BehaviorSettingController

@synthesize source;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    int cnt = [[[self source]annots]countDefinedBehaviors];
    NSLog(@"%s : %d", __PRETTY_FUNCTION__, cnt);
    return cnt;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
     NSLog(@"%s : column = %@", __PRETTY_FUNCTION__, tableColumn.identifier);
   
    // Color
    if ([tableColumn.identifier isEqualToString:@"Color"]) {
        NSColorWell *annotColor =  [tableView makeViewWithIdentifier:@"colorView" owner:self];
        annotColor = [[[NSColorWell alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];
        NSColor* mycolor = [[[[self source]annots] behaviorByIndex:(int)row] color];
        [annotColor setColor:mycolor];
        annotColor.identifier = @"colorView";
        return annotColor;
    } else
    // Hot key
    if ([tableColumn.identifier isEqualToString:@"Hot Key"]) {
        NSTextField *key = [tableView makeViewWithIdentifier:@"keyView" owner:self];
        if (key == nil) {
            key = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 30, 10)] autorelease];
            NSString* myKey = [[[[self source]annots] behaviorByIndex:(int)row] key];
            [key setStringValue:myKey];
            key.identifier = @"keyView";
            [key setBezeled:YES];
            [key setDrawsBackground:NO];
            [key setEditable:YES];
            [key setSelectable:YES];
        }
        return key;
    } else
    // Behavior Category
    if ([tableColumn.identifier isEqualToString:@"Behavior Category"]) {
        NSTextField *category = [tableView makeViewWithIdentifier:@"BehaviorView" owner:self];
        if (category == nil) {
            category = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];
            NSString* myCategory = [[[[self source]annots] behaviorByIndex:(int)row] category];
            [category setStringValue:myCategory];
            category.identifier = @"BehaviorView";
            [category setBezeled:YES];
            [category setDrawsBackground:NO];
            [category setEditable:YES];
            [category setSelectable:YES];
        }
        return category;
    } else
    
    // Behavior Description
    if ([tableColumn.identifier isEqualToString:@"Behavior Description"]) {
        NSTextField *behaviorDesc = [tableView makeViewWithIdentifier:@"descriptionView" owner:self];
        if (behaviorDesc == nil) {
            behaviorDesc = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];
            behaviorDesc.identifier = @"descriptionView";
            NSString* myDesc = [[[[self source]annots] behaviorByIndex:(int)row] name];
            [behaviorDesc setStringValue:myDesc];
            [behaviorDesc setBezeled:YES];
            [behaviorDesc setDrawsBackground:NO];
            [behaviorDesc setEditable:YES];
            [behaviorDesc setSelectable:YES];
        }
        return behaviorDesc;
    }
    
    NSLog(@"%s : UNKNOWN COLUMN:::: %@", __PRETTY_FUNCTION__, tableColumn.identifier);
    return nil;
}



- (IBAction)changeModeFromSegmentedControl:(id)sender {
    NSInteger mymode = [modeSelector selectedSegment];
    NSLog(@"%s : %ld", __PRETTY_FUNCTION__, (long)mymode);
    if (mymode == 0) {
        NSLog(@"add annotation");
        AnnotationBehavior* annot = Nil;
        annot = [[AnnotationBehavior alloc]
                 initWithName:@"Pick Up an Item" inCategory:@"Good" withColor:[NSColor blueColor] withKey:@"P"];
        [[[self source]annots] addBehavior:annot];
        [table reloadData];

        
    } else {
        NSLog(@"Remove annotation");
    }
    
}

@end
