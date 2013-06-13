//
//  Source.m
//  BEDA
//
//  Created by Jennifer Kim on 6/6/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "Source.h"

@implementation Source

@synthesize beda;
@synthesize channels = _channels;
@synthesize offset;
@synthesize annots = _annots;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _channels = [[NSMutableArray alloc] init];
        _annots = [[NSMutableArray alloc] init];
        
        [self setOffset:0.0];
    }
    
    return self;
}

- (void)loadFile:(NSURL*)url {
    NSLog(@"%s: Do NOTHING", __PRETTY_FUNCTION__);

}



- (void)addAnnotation {
    [self addAnnotation:@"TEST"];
}

- (void)addAnnotation:(NSString*)text {
    double t = [[self beda] getGlobalTime];
    [self addAnnotation:text at:t];
}

- (void)addAnnotation:(NSString*)text at:(double)time {
    [[self annots] addObject:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSDecimalNumber numberWithDouble:time],
      [NSNumber numberWithInt:0],
      text,
      [NSNumber numberWithInt:1],
      nil
      ]
     ];
    NSLog(@"# annotations becomes %d", [self numAnnotations]);

}

- (int) numAnnotations {
    return (int)[[self annots] count];
}

- (double) annotationTime: (int)index {
    NSDecimalNumber* ret = [[ [self annots] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:0]];
    return [ret doubleValue];
    
}

- (NSString*) annotationText: (int)index {
    return [[ [self annots] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:1]];
}

- (void)logAnnotations {
    NSLog(@"# annotations = %d", [self numAnnotations]);
    for (int i = 0; i < [self numAnnotations]; i++) {
        NSLog(@"Annot %d at %lf : text = %@", i, [self annotationTime:i], [self annotationText:i]);
    }
}


@end
