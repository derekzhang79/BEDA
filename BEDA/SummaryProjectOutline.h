//
//  SummaryProjectOutline.h
//  BEDA
//
//  Created by Sehoon Ha on 8/14/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SummaryProjectsManager;

@interface SPGroup : NSObject

@property (copy) NSString* name;
@property (retain) NSMutableArray* datafiles;
- (void)registerToFlattenList:(NSMutableArray*) flattenList;

@end

@interface SPDataFile : NSObject

@property (copy) NSString* filename;
@property (retain) SPGroup* parent;
@property (retain) NSMutableDictionary* properties;

- (void)setProperty:(NSString*)name as:(double)value;
- (BOOL)hasProperty:(NSString*)name;
- (double)getProperty:(NSString*)name;
- (void)registerToFlattenList:(NSMutableArray*) flattenList;

@end

@interface SummaryProjectOutline : NSObject<NSOutlineViewDataSource, NSOutlineViewDelegate> {
    
}

@property (assign) IBOutlet NSOutlineView *outlineview;
@property (assign) IBOutlet SummaryProjectsManager *spmanager;
@property (retain) NSMutableArray* groups;
@property (retain) NSMutableArray* flattenList;
@property (assign) SPGroup* savedParent;

- (IBAction)onNewGroup:(id)sender;
- (IBAction)onLoadFolder:(id)sender;

- (SPDataFile*)addNewDataFile:(NSString*)filename;
- (void)updateFlattenList;

@end
