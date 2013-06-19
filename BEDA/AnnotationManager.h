//
//  AnnotationManager.h
//  BEDA
//
//  Created by Sehoon Ha on 6/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AnnotationBehavior.h"

@interface AnnotationManager : NSObject {
    
}

@property (retain) NSMutableArray* behaviors;

- (void)createDefaultBehaviors;

- (void) addBehavior:(AnnotationBehavior*)behavior;
- (AnnotationBehavior*) behaviorByIndex : (int)index;
- (AnnotationBehavior*) behaviorByName  : (NSString*)name;
- (int) countDefinedBehaviors;
- (int) countUsedBehaviors;
- (void) updateUsedIndexes;

@end
