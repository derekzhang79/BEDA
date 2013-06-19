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
@property (retain) AnnotationManager* annots;


@property double offset;
- (void)loadFile:(NSURL*)url;

//// Annotations
//@property (retain) NSMutableArray* annots;
//
//- (void)addAnnotation;
//- (void)addAnnotation:(NSString*)text;
//- (void)addAnnotation:(NSString*)text at:(double)time;
//
//- (int) numAnnotations;
//- (double) annotationTime : (int)index;
//- (NSString*) annotationText : (int)index;
//
//- (void)logAnnotations;
@end
