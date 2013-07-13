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
#import "GraphSettingController.h"
#import "BehaviorSettingController.h"

@interface SourceTabViewItem : NSTabViewItem {
    
}

@property (assign) TableViewController* tvc;

@end

@interface GraphWindowController : NSObject {
    IBOutlet NSTabView* tabview;
    IBOutlet NSTabView* graphControlTabview;
}

@property (retain) NSMutableArray* tableViewControllers;
@property (retain) NSMutableArray* settingControllers;

- (void)addTableViewFor:(int)index;

- (IBAction)openFile:(id)sender;
- (IBAction)onAddGraph:(id)sender;
- (IBAction)onApplySettings:(id)sender;
- (IBAction) removeTabViewItem:(id)sender;

- (BedaController*) beda;


@end
