//
//  AnnotationManager.m
//  BEDA
//
//  Created by Jennifer Kim on 6/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "AnnotationManager.h"

@implementation AnnotationManager


@synthesize behaviors = _behaviors;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _behaviors = [[NSMutableArray alloc] init];
    }
    return self;
    
}

- (void)createDefaultBehaviors {
    AnnotationBehavior* annot = Nil;
    annot = [[AnnotationBehavior alloc]
             initWithName:@"Engaged & Ontask Behaviors" withColor:[NSColor blueColor] withKey:@"e"];
    [self addBehavior:annot ];
    [[annot times] addObject:[NSNumber numberWithFloat:10.0f]];
    [[annot times] addObject:[NSNumber numberWithFloat:20.0f]];

    annot = [[AnnotationBehavior alloc]
             initWithName:@"Undesired Behaviors" withColor:[NSColor redColor] withKey:@"u"];
    [self addBehavior: annot];
    [[annot times] addObject:[NSNumber numberWithFloat:15.0f]];

    NSLog(@"%s: # Behaviors = %d", __PRETTY_FUNCTION__, [self countDefinedBehaviors]);

}

- (void) addBehavior:(AnnotationBehavior*)behavior {
    [[self behaviors] addObject:behavior];
}

- (AnnotationBehavior*) behaviorByIndex : (int)index {
    if (index < 0 || index >= [[self behaviors] count]) {
        return Nil;
    }
    return [[self behaviors] objectAtIndex:index];
}

- (AnnotationBehavior*) behaviorByName  : (NSString*)name {
    for (AnnotationBehavior* b in [self behaviors]) {
        if ([[b name] isEqualToString:name]) {
            return b;
        }
    }
    return Nil;
}

- (int) countDefinedBehaviors {
    return (int)[[self behaviors] count];
}

- (int) countUsedBehaviors {
    int count = 0;
    for (AnnotationBehavior* b in [self behaviors]) {
        if ([b isUsed]) {
            count++;
        }
    }
    return count;
}

- (void) updateUsedIndexes {
    int count = 0;
    for (AnnotationBehavior* b in [self behaviors]) {
        if ([b isUsed]) {
            [b setUsedIndex:count];
            count++;
        }
    }
    
}

@end
