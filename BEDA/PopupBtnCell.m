//
//  PopupBtnCell.m
//  BEDA
//
//  Created by Jennifer Kim on 6/25/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "PopupBtnCell.h"

@implementation PopupBtnCell

- (void)drawImageWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    // draw image with modified rect for left-aligning
    [super drawImageWithFrame:cellFrame inView:controlView];
    
    // draw the triangle to the bottom/right of image
    NSRect imageBounds = [self imageRectForBounds:cellFrame];
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path moveToPoint:NSMakePoint(NSMaxX(imageBounds)-1, NSMaxY(imageBounds)-9)];
    [path lineToPoint:NSMakePoint(NSMaxX(imageBounds)+5, NSMaxY(imageBounds)-9)];
    [path lineToPoint:NSMakePoint(NSMaxX(imageBounds)+2, NSMaxY(imageBounds)-5)];
    [path closePath];
    
    [[NSColor colorWithDeviceWhite:20.0/255.0 alpha:0.9] set];
    [path fill];
}

- (NSRect)imageRectForBounds:(NSRect)theRect
{
    NSRect rect = [super imageRectForBounds:theRect];
    
    // make room for 5 pixels at the right
    rect.origin.x -= 5;
    
    return rect;
}

@end
