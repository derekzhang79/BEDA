//
//  AnnotationBehavior.m
//  BEDA
//
//  Created by Sehoon Ha on 6/18/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "AnnotationBehavior.h"

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

- (id) initWithName:(NSString*)n inCategory:(NSString*)c withColor:(NSColor*)cl withKey:(NSString*)k {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _times = [[NSMutableArray alloc] init];
        [self setName:n];
        [self setCategory:c];
        [self setColor:cl];
        [self setKey:k];
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

@end
