//
//  SummaryProjectsManager.h
//  BEDA
//
//  Created by Jennifer Kim on 6/28/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SummaryProjectsController.h"

@interface SummaryProjectsManager : NSObject {
    SummaryProjectsController *spc;
}
- (IBAction)loadProject:(id)sender;
@end
