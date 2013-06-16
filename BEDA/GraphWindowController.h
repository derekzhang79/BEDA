//
//  GraphWindowController.h
//  BEDA
//
//  Created by Sehoon Ha on 6/13/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BedaController.h"
#import "TableViewController.h"


@interface GraphWindowController : NSObject {
    IBOutlet NSTabView* tabview;
}

@property (retain) TableViewController* tvc;

- (IBAction)openFile:(id)sender;
- (BedaController*) beda;
@end
