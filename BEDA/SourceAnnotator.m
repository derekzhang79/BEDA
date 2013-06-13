//
//  SourceAnnotator.m
//  BEDA
//
//  Created by Jennifer Kim on 6/13/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "SourceAnnotator.h"
#import "Source.h"

@implementation SourceAnnotator

@synthesize source;
@synthesize annots = _annots;


-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _annots = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addAnnotation {
    [self addAnnotation:@"TEST"];
}

- (void)addAnnotation:(NSString*)text {
    double t = [[[self source] beda] getGlobalTime];
    [self addAnnotation:text at:t];
}

- (void)addAnnotation:(NSString*)text at:(double)time {
    NSDictionary* annot = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSDecimalNumber numberWithDouble:time],
                           [NSNumber numberWithInt:0],
                           text,
                           [NSNumber numberWithInt:1],
                           nil
                           ];
    [[self annots] addObject:annot];
    
}

- (int) size {
    return (int)[[self annots] count];
}

- (double) time : (int)index {
    NSDecimalNumber* ret = [[ [self annots] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:0]];
    return [ret doubleValue];

}

- (NSString*) text : (int)index {
    return [[ [self annots] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:1]];
}

- (void)printLog {
    NSLog(@"# annotations = %d", [self size]);
    for (int i = 0; i < [self size]; i++) {
        NSLog(@"Annot %d at %lf : text = %@", i, [self time:i], [self text:i]);
    }
}

@end
