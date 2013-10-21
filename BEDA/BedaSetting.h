//
//  BedaSetting.h
//  BEDA
//
//  Created by Sehoon Ha on 10/21/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BedaSetting : NSObject {
    
}

@property (retain) NSMutableArray* scriptnames;

- (void)loadDefaultFile;
- (void)loadFile:(NSURL*)url;
- (void)saveDefaultFile;
- (void)saveFile:(NSURL*)url;

@end
