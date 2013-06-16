//
//  DataTableViewController.m
//  BEDA
//
//  Created by Sehoon Ha on 6/15/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "DataTableViewController.h"

@implementation DataTableViewController

@synthesize source = _source;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    SourceTimeData* s = [[[self beda] sources] lastObject];
    [self setSource:s];
    NSLog(@"%s: source name = %@", __PRETTY_FUNCTION__, [[self source] name]);


}

- (BedaController*) beda {
    return [BedaController getInstance];
}

@end
