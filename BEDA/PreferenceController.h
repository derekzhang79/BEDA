//
//  Preference.h
//  BEDA
//
//  Created by Jennifer Kim on 10/24/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferenceController : NSWindowController {
    
}
@property (assign) IBOutlet NSTextField *txtMatlab;
@property (assign) IBOutlet NSTextField *txtR;

- (IBAction)findMatlab:(id)sender;
- (IBAction)findR:(id)sender;
- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;

@end
