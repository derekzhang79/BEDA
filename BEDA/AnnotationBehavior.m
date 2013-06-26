//
//  AnnotationBehavior.m
//  BEDA
//
//  Created by Sehoon Ha on 6/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "AnnotationBehavior.h"
#import "BedaController.h"

@implementation AnnotationBehavior

@synthesize category;
@synthesize name;
@synthesize color;
@synthesize times = _times;
@synthesize key;
@synthesize usedIndex;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _times = [[NSMutableArray alloc] init];
        [self setName:@""];
        [self setCategory:@""];
        [self setColor:[NSColor greenColor]];
        [self setKey:@""];
    }
    return self;

}

- (id) initWithName:(NSString*)n withColor:(NSColor*)cl withKey:(NSString*)k {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _times = [[NSMutableArray alloc] init];
        [self setName:n];
        [self setColor:cl];
        [self setKey:k];
        [self setCategory:@""];
    }
    return self;
}

- (bool) isUsed {
    if ([[self times] count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (int) numBehaviorIntervals {
    int cnt[BEDA_MAX_INTERVALS];
    int n = [AnnotationBehavior numTotalIntervals];
    for (int i = 0; i < n; i++) {
        cnt[i] = 0;
    }
    double interval = [[BedaController getInstance] interval];
    
    
    for (NSNumber* num in [self times]) {
        double t = [num doubleValue];
        int index = (int)(t / interval);
        cnt[index]++;
    }
    
    int answer = 0;
    for (int i = 0; i < n; i++) {
        if (cnt[i] > 0) {
            answer++;
        }
//        NSLog(@"INTERVAL %d : %d", i, cnt[i]);
    }
    return answer;
}


+ (int) numTotalIntervals {
    BedaController* beda = [BedaController getInstance];
    int n = (int)([beda duration] / [beda interval]);
    return n;
}


- (double) percentBehaviorIntervals {
    double a = [self numBehaviorIntervals];
    double b = [AnnotationBehavior numTotalIntervals];
    return 100.0 * (a / b);
}



@end
