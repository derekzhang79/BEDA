//
//  ProjectManager.h
//  BEDA
//
//  Created by Jennifer Kim on 6/14/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BedaController;

@interface ProjectManager : NSObject {
    
}

- (BedaController*)beda;


- (IBAction)openProject:(id)sender;
- (IBAction)saveProject:(id)sender;

- (void)saveFile:(NSURL*)url;
- (void)loadFile:(NSURL*)url;
- (NSColor*) colorFromString:(NSString*)string;

@end
