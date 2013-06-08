//
//  SourceMovie.h
//  BEDA
//
//  Created by Jennifer Kim on 6/7/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Source.h"
#import <QTKit/QTKit.h>

@interface SourceMovie : Source {
    
}

- (void)loadFile:(NSURL*)url;

@end
