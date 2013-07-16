//
//  ChannelAnnotationManager.m
//  BEDA
//
//  Created by Sehoon Ha on 7/15/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelAnnotationManager.h"
#import "BedaController.h"
#import "ChannelTimeData.h"

@implementation ChannelAnnotion

@synthesize t;
@synthesize duration;
@synthesize text;


- (id) initAtTime:(double) _t withText:(NSString*) _text {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setT:_t];
        [self setDuration:0.0];
        [self setText:_text];
    }
    return self;
}

- (id) initAtTime:(double) _t during:(double)_duration withText:(NSString*) _text {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setT:_t];
        [self setDuration:_duration];
        [self setText:_text];
    }
    return self;
}

- (BOOL) isSingle {
    if ([self duration] < 0.00001) {
        return YES;
    } else {
        return NO;
    }
}

@end

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
    
    // 2. Symbol style
    CPTPlotSymbol *symbol = [CPTPlotSymbol diamondPlotSymbol];
    symbol.fill = [CPTFill fillWithColor:color];
    
    symbol.size = CGSizeMake(15.0f, 15.0f);
    p.plotSymbol = symbol;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth = 5.0f;
    lineStyle.lineColor = color;
    
    p.dataLineStyle = lineStyle;


    // Add the plot to the graph
    [[[self channel] getGraph] addPlot:p];
}

- (void) addSingleAt:(double)t as:(NSString*)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [[self annots] addObject:
     [[ChannelAnnotion alloc] initAtTime:t withText:text]
     ];
    [[self plot] reloadData];
}

- (void) addDoubleAt:(double)t during:(double)dur as:(NSString*)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [[self annots] addObject:
     [[ChannelAnnotion alloc] initAtTime:t during:dur withText:text]
     ];
    [[self plot] reloadData];
}

- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index{
    
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
    ChannelAnnotion* ann = [[self annots] objectAtIndex:annotIndex];

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
        return [NSNumber numberWithDouble: 1.0 ];
    } else {
        // Invalid fieldEnum: Should not be reached, probably
        return nil;
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    int annotIndex = (int)(index / 3);
    ChannelAnnotion* ann = [[self annots] objectAtIndex:annotIndex];

    CPTTextLayer *textLayer = [CPTTextLayer layer];
    textLayer.text = [ann text];
    CPTMutableTextStyle *labelTextStyle = [CPTMutableTextStyle textStyle];
    labelTextStyle.fontSize = 16;
    labelTextStyle.color = [CPTColor purpleColor];
    textLayer.textStyle = labelTextStyle;
    textLayer.paddingBottom = 10.0;
    return textLayer;
}

@end
