//
//  DataAnalysisController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/25/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelSelector.h"
@interface DataAnalysisController : NSObject<NSTableViewDelegate, NSTableViewDataSource>  {
    IBOutlet NSTableView* tableview;
    IBOutlet NSComboBox* comboBoxScriptSelection;
    IBOutlet NSButton* doAnalysisBtn;
}

@property (retain) NSMutableArray* channels;
@property (retain) NSMutableDictionary* results;

-(IBAction)doAnalysis:(id)sender;
-(IBAction)addScript:(id)sender;
- (IBAction)editScript:(id)sender;
- (IBAction)popMatlabConnectionWindow:(id)sender;
- (void) updateAnalysisBtnText;

@end
