//
//  AnnotViewController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/21/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "AnnotViewController.h"

@implementation AnnotViewController

@synthesize graph;
@synthesize source;


- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    graphview.hostedGraph = [self graph];
}

- (void) viewDidLoad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (CPTGraphHostingView*) getGraphView {
    return graphview;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    int cnt = [[[self source]annots]countDefinedBehaviors];
    NSLog(@"%s : %d", __PRETTY_FUNCTION__, cnt);
    return cnt;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    Behavior* beh = [[[self source]annots] behaviorByIndex:(int)row] ;
    // Behavior Name
    if ([tableColumn.identifier isEqualToString:@"Behavior Name"]) {
        NSTextField *behaviorName = [tableView makeViewWithIdentifier:@"behaviorNameView" owner:self];
        if (behaviorName == nil) {
            behaviorName = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 30, 10)] autorelease];
            NSString* myName = [beh name];
            [behaviorName setStringValue:myName];
            behaviorName.identifier = @"behaviorNameView";
            [behaviorName setBezeled:NO];
            [behaviorName setDrawsBackground:NO];
            [behaviorName setEditable:NO];
            [behaviorName setSelectable:NO];
        }
        return behaviorName;
        
    } else if ([tableColumn.identifier isEqualToString:@"Behavior Color"]) {  // # of Behavior Intervals
        NSTextField *behaviorColor = [tableView makeViewWithIdentifier:@"behaviorColorTextField" owner:self];
        if (behaviorColor == nil) {
            behaviorColor = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 10, 10)] autorelease];
            
            behaviorColor.identifier = @"behaviorColorTextField";
            [behaviorColor setBackgroundColor:[beh color]];
            [behaviorColor setBezeled:NO];
            [behaviorColor setEditable:NO];
            [behaviorColor setSelectable:NO];
        }
        
        return behaviorColor;
        
    } else if ([tableColumn.identifier isEqualToString:@"Behavior Intervals"]) {  // # of Behavior Intervals
            NSTextField *behaviorIntervals = [tableView makeViewWithIdentifier:@"behaviorIntervalsTextField" owner:self];
            if (behaviorIntervals == nil) {
                behaviorIntervals = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];

                behaviorIntervals.identifier = @"behaviorIntervalsTextField";
                [behaviorIntervals setBezeled:NO];
                [behaviorIntervals setDrawsBackground:NO];
                [behaviorIntervals setEditable:NO];
                [behaviorIntervals setSelectable:NO];
            }
            int numOfbehaviorIntervals = [beh numBehaviorIntervals];
            [behaviorIntervals setIntValue:numOfbehaviorIntervals];
            return behaviorIntervals;
        
        } else if ([tableColumn.identifier isEqualToString:@"Total Intervals"]) { // # of total Intervals
                NSTextField *totalIntervals = [tableView makeViewWithIdentifier:@"totalIntervalsTextField" owner:self];
                if (totalIntervals == nil) {
                    totalIntervals = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];

                    totalIntervals.identifier = @"totalIntervalsTextField";
                    [totalIntervals setBezeled:NO];
                    [totalIntervals setDrawsBackground:NO];
                    [totalIntervals setEditable:NO];
                    [totalIntervals setSelectable:NO];
                }
                int totalNumOfIntervals = [Behavior numTotalIntervals];
                [totalIntervals setIntValue:totalNumOfIntervals];
                return totalIntervals;
            } else if ([tableColumn.identifier isEqualToString:@"Percentage Behavior"]) { // percetnage of behaviors
                    NSTextField *percentageBehavior = [tableView makeViewWithIdentifier:@"percentageBehaviorTextField" owner:self];
                    if (percentageBehavior == nil) {
                        percentageBehavior = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 50, 10)] autorelease];

                        percentageBehavior.identifier = @"percentageBehaviorTextField";
                        [percentageBehavior setBezeled:NO];
                        [percentageBehavior setDrawsBackground:NO];
                        [percentageBehavior setEditable:NO];
                        [percentageBehavior setSelectable:NO];
                    }
                    double p = [beh percentBehaviorIntervals];
                    NSString *percentageOfIntervals = [NSString stringWithFormat:@"%.2lf%%", p];
                    [percentageBehavior setStringValue:percentageOfIntervals];
                    return percentageBehavior;
                }
    
    NSLog(@"%s : UNKNOWN COLUMN:::: %@", __PRETTY_FUNCTION__, tableColumn.identifier);
    return nil;
}

- (void)reloadTableView {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [tableview reloadData];
}

@end
