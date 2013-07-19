//
//  AnnotationManager.h
//  BEDA
//
//  Created by Jennifer Kim on 6/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Behavior.h"

@interface BehaviorManager : NSObject {
    
}

@property (retain) NSMutableArray* behaviors;

- (void)createDefaultBehaviors;

- (void) addBehavior:(Behavior*)behavior;
- (Behavior*) behaviorByIndex : (int)index;
- (Behavior*) behaviorByName  : (NSString*)name;
- (int) countDefinedBehaviors;
- (int) countUsedBehaviors;
- (void) updateUsedIndexes;

@end
