//
//  GraphSettingController.h
//  BEDA
//
//  Created by Jennifer Kim on 6/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphSettingController : NSObject{

    IBOutlet NSColorWell* graphColor;
    IBOutlet NSColorWell* areaColor;
    NSString *graphName;
    NSString *graphType;

}


- (IBAction)getGraphColor:(id)sender;
- (IBAction)getAreaColor:(id)sender;

@end
