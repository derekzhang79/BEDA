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

- (NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView{
    return 1;
}


@end
