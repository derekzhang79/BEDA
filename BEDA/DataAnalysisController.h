//
//  DataAnalysisController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/25/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAnalysisController : NSObject<NSTableViewDelegate, NSTableViewDataSource>  {
    IBOutlet NSTableView* tableview;
    IBOutlet NSComboBox* comboBoxScriptSelection;
}

@property (retain) NSMutableArray* channels;
@property (retain) NSMutableDictionary* results;

-(IBAction)doAnalysis:(id)sender;
-(IBAction)addScript:(id)sender;


@end
