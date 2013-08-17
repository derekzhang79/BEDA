//
//  SummaryProjectsManager.h
//  BEDA
//
//  Created by Jennifer Kim on 6/28/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SummaryProjectsController.h"
#import "SummaryProjectOutline.h"

@interface SummaryProjectsManager : NSObject {
    IBOutlet SummaryProjectsController *spc;
}
@property (assign) IBOutlet SummaryProjectOutline *spoutline;
- (IBAction)loadProject:(id)sender;
- (void)loadFile:(NSURL*)url;

@end
