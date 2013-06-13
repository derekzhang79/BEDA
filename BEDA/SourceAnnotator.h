//
//  SourceAnnotator.h
//  BEDA
//
//  Created by Jennifer Kim on 6/13/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Source.h"

//@class Source;

@interface SourceAnnotator : NSObject {
    
}

@property (assign) Source* source;

- (void)addAnnotation;
- (void)addAnnotation:(NSString*)text;
- (void)addAnnotation:(NSString*)text at:(double)time;

- (int) size;
- (double) time : (int)index;
- (NSString*) text : (int)index;

- (void)printLog;

@end
