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
@synthesize channel;
@synthesize controls = _controls;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _controls = [[NSMutableDictionary alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplySettingPressed:)
                                                 name:BEDA_NOTI_APPLY_SETTING_PRESSED object:Nil];
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    int cnt = [[[self source]annots]countDefinedBehaviors];
    NSLog(@"%s : %d", __PRETTY_FUNCTION__, cnt);
    return cnt;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
     NSLog(@"%s : column = %@, row = %d", __PRETTY_FUNCTION__, tableColumn.identifier, (int)row);
   
    if ([[self controls] objectForKey:tableColumn.identifier] == Nil) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [[self controls] setObject:array forKey:tableColumn.identifier];
    }
    NSMutableArray* controlArray = [[self controls] objectForKey:tableColumn.identifier];
    while ((int)[controlArray count] <= (int)row) {
        [controlArray addObject:[NSNull null]];
    }
    
    // Color
    if ([tableColumn.identifier isEqualToString:@"Color"]) {
        // Create a view
        NSColorWell *annotColor = annotColor = [[[NSColorWell alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];
        // Set data
        NSColor* mycolor = [[[[self source] annots] behaviorByIndex:(int)row] color];
        [annotColor setColor:mycolor];
        // Insert to controlArray
        [controlArray insertObject:annotColor atIndex:row];
        
        [annotColor addObserver:self forKeyPath:@"color" options:0 context:NULL];
        return annotColor;
    }
    else if ([tableColumn.identifier isEqualToString:@"Hot Key"]) {
//       NSTextField *key = [tableView makeViewWithIdentifier:@"keyView" owner:self];
        NSTextField *key = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 30, 10)] autorelease];
        NSString* myKey = [[[[self source]annots] behaviorByIndex:(int)row] key];
        [key setStringValue:myKey];
        key.identifier = @"keyView";
        [key setBezeled:YES];
        [key setDrawsBackground:NO];
        [key setEditable:YES];
        [key setSelectable:YES];
        
        [controlArray insertObject:key atIndex:row ];
        return key;
    } else if ([tableColumn.identifier isEqualToString:@"Behavior Category"]) {
        NSTextField *category = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];
        NSString* myCategory = [[[[self source]annots] behaviorByIndex:(int)row] category];
        [category setStringValue:myCategory];
        category.identifier = @"BehaviorView";
        [category setBezeled:YES];
        [category setDrawsBackground:NO];
        [category setEditable:YES];
        [category setSelectable:YES];
        
        [controlArray insertObject:category atIndex:row];

        return category;
    } else
    
    // Behavior Description
    if ([tableColumn.identifier isEqualToString:@"Behavior Description"]) {
//        NSTextField *behaviorDesc = [tableView makeViewWithIdentifier:@"descriptionView" owner:self];
        NSTextField *behaviorDesc = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];
            behaviorDesc.identifier = @"descriptionView";
            NSString* myDesc = [[[[self source]annots] behaviorByIndex:(int)row] name];
            [behaviorDesc setStringValue:myDesc];
            [behaviorDesc setBezeled:YES];
            [behaviorDesc setDrawsBackground:NO];
            [behaviorDesc setEditable:YES];
            [behaviorDesc setSelectable:YES];
        
        [controlArray insertObject:behaviorDesc atIndex:row ];

        return behaviorDesc;
    }
    
    NSLog(@"%s : UNKNOWN COLUMN:::: %@", __PRETTY_FUNCTION__, tableColumn.identifier);
    return nil;
}



- (IBAction)changeModeFromSegmentedControl:(id)sender {
    NSInteger mymode = [modeSelector selectedSegment];
    NSLog(@"%s : %ld", __PRETTY_FUNCTION__, (long)mymode);
    if (mymode == 0) {
        [self onApplySettingPressed:nil];
        
        NSLog(@"add annotation");
        AnnotationBehavior* annot = Nil;
        annot = [[AnnotationBehavior alloc]
                 initWithName:@"hi" inCategory:@"hello" withColor:[NSColor blueColor] withKey:@"k"];
        [[[self source] annots] addBehavior:annot];
        NSUInteger n = [[[self source] annots] countDefinedBehaviors];
        //[table reloadData];
        NSLog(@"add annotation. n = %d", (int)n);
        [table reloadData];
        
        
    } else {
        NSLog(@"Remove annotation");
    }
    
}

- (void) onApplySettingPressed:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    for (int i = 0; i < [[[self source] annots] countDefinedBehaviors]; i++) {
        AnnotationBehavior* ab = [[[self source] annots] behaviorByIndex:i];
        
        {
            NSMutableArray* array = [[self controls] objectForKey:@"Color"];
            NSColorWell *v = [array objectAtIndex:i];
            [ab setColor:[v color]];
        }
        {
            NSMutableArray* array = [[self controls] objectForKey:@"Hot Key"];
            NSTextField *v = [array objectAtIndex:i];
            [ab setKey:[v stringValue]];
        }
        {
            NSMutableArray* array = [[self controls] objectForKey:@"Behavior Category"];
            NSTextField *v = [array objectAtIndex:i];
            [ab setCategory:[v stringValue]];
        }
        {
            NSMutableArray* array = [[self controls] objectForKey:@"Behavior Description"];
            NSTextField *v = [array objectAtIndex:i];
            [ab setName:[v stringValue]];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_ANNOTATION_CHANGED
     object:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

@end
