//
//  ChannelAnnotationManager.m
//  BEDA
//
//  Created by Jennifer Kim on 7/15/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelAnnotationManager.h"
#import "BedaController.h"
#import "ChannelTimeData.h"

@implementation ChannelAnnotationManager

@synthesize channel;
@synthesize plot;
@synthesize annots = _annots;

- (id) initWithChannel:(ChannelTimeData*) ch {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setChannel:ch];        
        [self initPlot];
        _annots = [[NSMutableArray alloc] init];        
//        [self addSingleAt:45 as:@"Single Annot"];
//        [self addDoubleAt:60 during:25 as:@"Double Annot"];

    }
    return self;
}

- (void) initPlot {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Create header plot
    CPTScatterPlot* p = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    [self setPlot:p];
    p.identifier = BEDA_INDENTIFIER_CHANNEL_ANNOT_PLOT;
    p.dataSource = self;
    p.delegate = self;
    
    // Set the style
    // 1. SavingPlotLine style
    CPTColor *color = [[self channel] toCPT:[NSColor redColor]];
    CPTMutableLineStyle *annotationLineStyle = [CPTMutableLineStyle lineStyle];
    annotationLineStyle.lineWidth = 0.0f;

    // 2. Symbol style
    CPTPlotSymbol *symbol = [CPTPlotSymbol diamondPlotSymbol];
    symbol.fill = [CPTFill fillWithColor:color];
    symbol.lineStyle = annotationLineStyle;
    
    symbol.size = CGSizeMake(10.0f, 10.0f);
    p.plotSymbol = symbol;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 3.0f;
    lineStyle.lineColor = color;
    
    p.dataLineStyle = lineStyle;


    // Add the plot to the graph
    [[[self channel] getGraph] addPlot:p];
}

- (ChannelAnnotation*) addSingleAt:(double)t as:(NSString*)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    ChannelAnnotation* ca = [[ChannelAnnotation alloc] initAtTime:t withText:text];

//    [[self annots] addObject:ca];
//    [[self plot] reloadData];
    return ca;
}

- (ChannelAnnotation*) addDoubleAt:(double)t during:(double)dur as:(NSString*)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    ChannelAnnotation* ca = [[ChannelAnnotation alloc] initAtTime:t during:dur withText:text];

//    [[self annots] addObject:ca];
//    [[self plot] reloadData];
    return ca;
}

- (void) makeVisible:(ChannelAnnotation*)annot {
    for (Source* s in [[BedaController getInstance] sources]) {
        if ([s isKindOfClass:[SourceTimeData class]] == NO) {
            continue;
        }
        SourceTimeData* std = (SourceTimeData*)s;
        for (ChannelTimeData* ctd in [std channels]) {
            ChannelAnnotationManager* cam = [ctd channelAnnotationManager];
            for (ChannelAnnotation* a in [cam annots]) {
                [a setIsTextVisible:NO];
            }
            if (cam != self) {
                [[cam plot] reloadData];
            }
        }
    }

    [annot setIsTextVisible:YES];
    [[self plot] reloadData];
}


- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index {
    int annotIndex = (int)(index / 3);

    ChannelAnnotation* ca = [[self annots] objectAtIndex:annotIndex];
    NSUInteger flags = [[NSApp currentEvent] modifierFlags];
    if ( (flags & NSCommandKeyMask) ) {
        NSLog(@"%s: Annotation is selected for REMOVAL", __PRETTY_FUNCTION__);
        [[self annots] removeObjectAtIndex:annotIndex];
        [[self plot] reloadData];

    } else {
        NSLog(@"%s: Annotation is selected for relocating the header", __PRETTY_FUNCTION__);
        double x = [ca t];
        [[self channel ] setHeaderTime:x];
        [[[self channel] getPlotHeader] reloadData];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BEDA_NOTI_CHANNEL_HEAD_MOVED
         object:[self channel]];
        
        NSLog(@"%s: Also Annotation is selected for showing text", __PRETTY_FUNCTION__);
        [self makeVisible:ca];
    }
    double minvalue = [[self channel] minValue];
    double maxvalue = [[self channel] maxValue];
    double averagevalue = (minvalue + maxvalue) * 0.5;
    double pt[2];
    pt[0] = [ca t];
    pt[1] = averagevalue;
    CGPoint viewPoint = [[[self channel] getPlotSpace] plotAreaViewPointForDoublePrecisionPlotPoint:pt];
    NSPoint nspt = NSPointFromCGPoint(viewPoint);
    NSPoint nspt2 = [[[self channel] view] convertPoint:nspt toView:Nil];
    NSLog(@"viewPoint = %lf, %lf: nspt2 = %lf, %lf", viewPoint.x, viewPoint.y, nspt2.x, nspt2.y);
    
    float gap = [[self channel] getGraph].plotAreaFrame.paddingLeft;
    BedaController* beda = [[self channel ] beda ];
    NSView* view = [[ [beda getSplitView] subviews] objectAtIndex:0];
    NSRect rect = NSMakeRect(viewPoint.x + gap, viewPoint.y + 20, 2, 2);
    [[beda popover] showRelativeToRect:rect ofView:view preferredEdge:NSMaxYEdge];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CPTPlotDataSource functions
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 3 * [[self annots] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    int annotIndex = (int)(index / 3);
    ChannelAnnotation* ann = [[self annots] objectAtIndex:annotIndex];

    // Do not display the second point of Single annotation
    if ([ann isSingle] && (index % 3) == 1) {
        return nil;
    }
    
    // Two annotions should not be connected
    if (index % 3 == 2) {
        return nil;
    }
    
    if (fieldEnum == CPTScatterPlotFieldX) {
        // Returns X values
        if (index % 2 == 0) { // First point
            return [NSNumber numberWithDouble: [ann t]];

        } else { // Second point
            return [NSNumber numberWithDouble: [ann t] + [ann duration]];
        }
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        // Returns Y values
//        return [NSNumber numberWithDouble: 1.0 ];
        double minvalue = [[self channel] minValue];
        double maxvalue = [[self channel] maxValue];
        double averagevalue = (minvalue + maxvalue) * 0.5;
        return [NSNumber numberWithDouble: averagevalue ];

    } else {
        // Invalid fieldEnum: Should not be reached, probably
        return nil;
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    int annotIndex = (int)(index / 3);
    ChannelAnnotation* ann = [[self annots] objectAtIndex:annotIndex];
    if ([ann isTextVisible] == NO) {
        return Nil;
    }

    CPTTextLayer *textLayer = [CPTTextLayer layer];
    textLayer.text = [ann text];
    CPTMutableTextStyle *labelTextStyle = [CPTMutableTextStyle textStyle];
    labelTextStyle.fontSize = 13;
    labelTextStyle.color = [CPTColor grayColor];
    textLayer.textStyle = labelTextStyle;
    textLayer.paddingTop = 80.0;
//    textLayer.paddingBottom = 10.0;
    return textLayer;
}

@end
