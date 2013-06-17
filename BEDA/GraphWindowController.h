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
    IBOutlet NSColorWell* graphColor;
    IBOutlet NSColorWell* areaColor;
    SourceTimeData* s;
    NSString *graphName;
    NSString *graphStyle;
    
}

@property (retain) TableViewController* tvc;
@property (retain) NSString *graphName;
@property (retain) NSString *graphStyle;

- (IBAction)openFile:(id)sender;
- (IBAction)onAddGraph:(id)sender;
- (IBAction)onApplySettings:(id)sender;
- (IBAction)getGraphColor:(id)sender;
- (IBAction)getAreaColor:(id)sender;
- (BedaController*) beda;

@end
