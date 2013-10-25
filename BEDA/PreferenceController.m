//
//  Preference.m
//  BEDA
//
//  Created by Sehoon Ha on 10/24/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "PreferenceController.h"
#import "BedaController.h"
#import "BedaSetting.h"

@implementation PreferenceController

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[self txtMatlab] setStringValue:[[[self beda] setting] execMatlab]];
    [[self txtR] setStringValue:[[[self beda] setting] execR]];

}

- (BedaController*) beda {
 return [BedaController getInstance];
}

- (IBAction)findMatlab:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Show the OpenPanel
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"app", nil]];
    long tvarInt = [panel runModal];
    
    // If user cancels it, do NOT proceed
    if (tvarInt != NSOKButton) {
        NSLog(@"User cancel the open command");
        return;
    }
    
    // Get URL and extract the URL
    NSURL *url = [panel URL];
    NSMutableString* path = [[NSMutableString alloc] initWithString:[url path]];
    NSString *ext = [[url path] pathExtension];
    if ([ext isEqualToString:@"app"]) {
        [path appendString:@"/bin/matlab"];
    }
    NSLog(@"path = %@ [ext = %@]", path, ext);
    [[self txtMatlab] setStringValue:path];


}

- (IBAction)findR:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Show the OpenPanel
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"R", nil]];
    long tvarInt = [panel runModal];
    
    // If user cancels it, do NOT proceed
    if (tvarInt != NSOKButton) {
        NSLog(@"User cancel the open command");
        return;
    }
    
    // Get URL and extract the URL
    NSURL *url = [panel URL];
    NSMutableString* path = [[NSMutableString alloc] initWithString:[url path]];
    NSLog(@"path = %@", path);
    [[self txtR] setStringValue:path];

}

- (IBAction)onOK:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[[self beda] setting] setExecMatlab:[[self txtMatlab] stringValue]];
    [[[self beda] setting] setExecR:[[self txtR] stringValue]];

    [[[self beda] setting] saveDefaultFile];
    [self close];
}

- (IBAction)onCancel:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self close];
}
@end
