//
//  AnnotationManager.m
//  BEDA
//
//  Created by Sehoon Ha on 6/18/13.
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
             initWithName:@"Pick Up an Item" inCategory:@"Good" withColor:[NSColor blueColor] withKey:@"P"];
    [self addBehavior:annot ];
    [[annot times] addObject:[NSNumber numberWithFloat:10.0f]];
    [[annot times] addObject:[NSNumber numberWithFloat:20.0f]];

    annot = [[AnnotationBehavior alloc]
             initWithName:@"Put blocks" inCategory:@"Good" withColor:[NSColor magentaColor] withKey:@"B"];
    [self addBehavior: annot];
    [[annot times] addObject:[NSNumber numberWithFloat:15.0f]];

    annot = [[AnnotationBehavior alloc]
             initWithName:@"Screaming" inCategory:@"Bad" withColor:[NSColor redColor] withKey:@"S"];
    [self addBehavior:annot];
    
    annot = [[AnnotationBehavior alloc]
             initWithName:@"Body Slam" inCategory:@"Bad" withColor:[NSColor yellowColor] withKey:@"Y"];
    [self addBehavior:annot];
    
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
