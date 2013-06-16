//
//  DataTableViewController.h
//  BEDA
//
//  Created by Sehoon Ha on 6/15/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "BedaController.h"
#import "SourceTimeData.h"

@interface DataTableViewController : NSObject {
    IBOutlet NSTableView* tableview;
}

@property (retain) SourceTimeData* source;
- (BedaController*) beda;

@end
