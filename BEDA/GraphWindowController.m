//
//  GraphWindowController.m
//  BEDA
//
//  Created by Sehoon Ha on 6/13/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "GraphWindowController.h"
#import "BedaController.h"
#import "Source.h"

@implementation GraphWindowController

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"%s: # of beda sources = %ld", __PRETTY_FUNCTION__, (unsigned long)[[[self beda] sources] count]);

    
    for (Source* s in [[self beda] sources]) {
        NSString* name = [s name];
        NSLog(@"creating a tab for source [%@]", name);
        NSTabViewItem *item = [[[NSTabViewItem alloc]
                                initWithIdentifier:name] autorelease];
        [item setLabel:name];
        [tabview addTabViewItem:item];
    }
    

}

- (BedaController*) beda {
    return [BedaController getInstance];
}

@end
