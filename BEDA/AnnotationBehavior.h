//
//  AnnotationBehavior.h
//  BEDA
//
//  Created by Sehoon Ha on 6/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnotationBehavior : NSObject {
    
}

@property (copy) NSString* name;
@property (copy) NSString* category;
@property (copy) NSColor* color;
@property (copy) NSString* key;
@property (assign) int usedIndex;

@property (retain) NSMutableArray* times;

- (id) initWithName:(NSString*)n inCategory:(NSString*)c withColor:(NSColor*)cl withKey:(NSString*)k;
- (bool) isUsed;

@end
