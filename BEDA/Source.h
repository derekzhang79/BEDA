//
//  Source.h
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BedaController.h"
#import "AnnotationManager.h"

@interface Source : NSObject {
    
}

@property (assign) BedaController* beda;
@property (retain) NSMutableArray* channels;
@property (copy) NSString* name;
@property (copy) NSString* filename;
@property (copy) NSString* projname;

@property (retain) AnnotationManager* annots;


@property double offset;
@property double projoffset;

- (void)loadFile:(NSURL*)url;
- (BOOL)exportSelection;
- (double)duration;
- (BOOL)deleteChannel:(id)ch;

@end
