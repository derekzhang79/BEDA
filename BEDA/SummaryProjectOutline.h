//
//  SummaryProjectOutline.h
//  BEDA
//
//  Created by Sehoon Ha on 8/14/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPGroup : NSObject

@property (copy) NSString* name;
@property (retain) NSMutableArray* datafiles;

@end

@interface SPDataFile : NSObject

@property (copy) NSString* filename;
@property (retain) SPGroup* parent;

@end

@interface SummaryProjectOutline : NSObject<NSOutlineViewDataSource, NSOutlineViewDelegate> {
    
}

@property (assign) IBOutlet NSOutlineView *outlineview;
@property (retain) NSMutableArray* groups;
- (IBAction)onNewGroup:(id)sender;

- (NSString*)addNewDataFile:(NSString*)filename;

@end
