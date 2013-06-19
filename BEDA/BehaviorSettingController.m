//
//  BehaviorSettingController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/19/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "BehaviorSettingController.h"

@implementation BehaviorSettingController

- (NSInteger)tableView:(NSTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

}

- (NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView{
    return 1;
}


- (IBAction)changeModeFromSegmentedControl:(id)sender {
    NSInteger mymode = [modeSelector selectedSegment];
    NSLog(@"%s : %ld", __PRETTY_FUNCTION__, (long)mymode);
    if (mymode == 0) {
        NSLog(@"add annotation");
        
    } else {
        NSLog(@"Remove annotation");
    }
    
}

@end
