//
//  AppDelegate.m
//  BEDA
//
//  Created by Jennifer Kim on 2/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
// The selectors should be recognized by class_addMethod().
@interface NSObject (SliderCellBugFix)

- (NSSliderType)sliderType;
- (NSInteger)numberOfTickMarks;

@end

// Add C implementations of missing methods that we’ll add
// to the StdMovieUISliderCell class later.
static NSSliderType SliderType(id self, SEL _cmd)
{
    return NSLinearSlider;
}

static NSInteger NumberOfTickMarks(id self, SEL _cmd)
{
    return 0;
}

// rot13, just to be extra safe.
static NSString *ResolveName(NSString *aName)
{
    const char *_string = [aName cStringUsingEncoding:NSASCIIStringEncoding];
    NSUInteger stringLength = [aName length];
    char newString[stringLength+1];
    
    NSUInteger x;
    for(x = 0; x < stringLength; x++)
    {
        unsigned int aCharacter = _string[x];
        
        if( 0x40 < aCharacter && aCharacter < 0x5B ) // A - Z
            newString[x] = (((aCharacter - 0x41) + 0x0D) % 0x1A) + 0x41;
        else if( 0x60 < aCharacter && aCharacter < 0x7B ) // a-z
            newString[x] = (((aCharacter - 0x61) + 0x0D) % 0x1A) + 0x61;
        else  // Not an alpha character
            newString[x] = aCharacter;
    }
    newString[x] = '\0';
    
    return [NSString stringWithCString:newString encoding:NSASCIIStringEncoding];
}

@implementation AppDelegate
// Add both methods if they aren’t already there. This should makes this
// code safe, even if Apple decides to implement the methods later on.
+ (void)load
{
    Class MovieSliderCell = NSClassFromString(ResolveName(@"FgqZbivrHVFyvqrePryy"));
    
    if (!class_getInstanceMethod(MovieSliderCell, @selector(sliderType)))
    {
        const char *types = [[NSString stringWithFormat:@"%s%s%s",
                              @encode(NSSliderType), @encode(id), @encode(SEL)] UTF8String];
        class_addMethod(MovieSliderCell, @selector(sliderType),
                        (IMP)SliderType, types);
    }
    if (!class_getInstanceMethod(MovieSliderCell, @selector(numberOfTickMarks)))
    {
        const char *types = [[NSString stringWithFormat: @"%s%s%s",
                              @encode(NSInteger), @encode(id), @encode(SEL)] UTF8String];
        class_addMethod(MovieSliderCell, @selector(numberOfTickMarks),
                        (IMP)NumberOfTickMarks, types);
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

@end
