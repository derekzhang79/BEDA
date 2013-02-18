//
//  DataAddController.h
//  BEDA
//
//  Created by Jennifer Kim on 2/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

#import "DataManager.h"

@interface DataAddController : NSObject {
    IBOutlet DataManager* dm;
}

- (IBAction)openFile:(id)sender;
- (IBAction)openProject:(id)sender;

- (void)openMovieFile:(NSURL*)url;
- (void)openSensorFile:(NSURL*)url;

@end
