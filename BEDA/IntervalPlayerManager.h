//
//  IntervalPlayerManager.h
//  BEDA
//
//  Created by Sehoon Ha on 7/9/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntervalPlayerManager : NSObject {
    IBOutlet NSTextField *txtFFInterval;
    IBOutlet NSTextField *txtNormalInterval;
    IBOutlet NSComboBox *cmbFastPlayRate;
    IBOutlet NSButton *chkMute;

}

@property (assign) BOOL isFastMode;
@property (assign) BOOL prevIsFastMode;

@property (assign) int ffInterval;
@property (assign) int normalInterval;
@property (assign) double fastPlayRate;


@end
