//
//  ChannelSelector.m
//  BEDA
//
//  Created by Sehoon Ha on 6/29/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ChannelSelector.h"
#import "ChannelTimeData.h"

@implementation ChannelSelector

@synthesize visible;
@synthesize left;
@synthesize right;
@synthesize channel;
@synthesize selection;

- (id) initWithChannel:(ChannelTimeData*) ch {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setVisible:NO];
        [self setLeft:10.0];
        [self setRight:20.0];
        [self setChannel:ch];
        [self setSelection:NOT_SELECTED];
        
        [self createSelectorPlot];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onToggle:)
                                                     name:BEDA_NOTI_CHANNELSELECTOR_TOGGLE object:Nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdate:)
                                                     name:BEDA_NOTI_CHANNELSELECTOR_UPDATE object:Nil];
    }
    return self;
}

- (void)createSelectorPlot {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    // Create header plot
    CPTScatterPlot* plot = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    [self setPlot:plot];
    plot.identifier = BEDA_INDENTIFIER_SELECT_PLOT;
    plot.dataSource = [self channel];
    plot.delegate = [self channel];
    CPTFill *areaFill = [CPTFill fillWithColor:[[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.15]];
    plot.areaFill      = areaFill;
    plot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    [self deselect];
    
    // Add the plot to the graph
    [[[self channel] getGraph] addPlot:plot];
}


-(NSUInteger)numberOfRecords {
    if ([self visible]) {
        return 4;
    } else {
        return 0;
    }
}

-(NSNumber *)numberForField:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    //    double minY = 0.1;
    //    double maxY = 4.9;
    double minY = [[self channel] minValue] + 0.1;
    double maxY = [[self channel] maxValue] - 0.1;
    
    double px[6] = {0.0, 0.0, 0.5, 0.0, 0.0, 0.0};
    double py[6] = {minY, maxY, maxY, minY, 0.2, 0.0};
    px[0] = [self left];
    px[1] = [self left];
    px[2] = [self right];
    px[3] = [self right];
    if (fieldEnum == CPTScatterPlotFieldX) {
        NSLog(@"%s: x = %lf", __PRETTY_FUNCTION__, px[index]);

        // Returns X values
        return [NSNumber numberWithDouble: (px[index]) ];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        // Returns Y values
        return [NSNumber numberWithDouble: (py[index]) ];
    } else {
        // Invalid fieldEnum: Should not be reached, probably
        return nil;
    }
}

-(void)select:(NSUInteger)index {
    if (index <= 1) {
        NSLog(@"%s: LEFT_SELECTED", __PRETTY_FUNCTION__);
        [self setSelection:LEFT_SELECTED];
    } else {
        NSLog(@"%s: RIGHT_SELECTED", __PRETTY_FUNCTION__);
        [self setSelection:RIGHT_SELECTED];
    }
    CPTScatterPlot* plot = [self plot];
    CPTColor *selectedPlotColor = [CPTColor purpleColor];
    
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = selectedPlotColor;
    
    CPTPlotSymbol *plotSymbol = nil;
    plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:selectedPlotColor];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(15.0f, 15.0f);
    
    plot.plotSymbol = plotSymbol;
    
    CPTMutableLineStyle *selectedLineStyle = [CPTMutableLineStyle lineStyle];
    selectedLineStyle.lineColor = [CPTColor purpleColor];
    selectedLineStyle.lineWidth = 2.0f;
    
    plot.dataLineStyle = selectedLineStyle;
}

-(void)deselect {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setSelection:NOT_SELECTED];
    
    CPTScatterPlot* plot = [self plot];
    CPTColor *selectedPlotColor = [CPTColor magentaColor];
    
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = selectedPlotColor;
    
    CPTPlotSymbol *plotSymbol = nil;
    plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:selectedPlotColor];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(15.0f, 15.0f);
    
    plot.plotSymbol = plotSymbol;
    
    CPTMutableLineStyle *selectedLineStyle = [CPTMutableLineStyle lineStyle];
    selectedLineStyle.lineColor = [CPTColor magentaColor];
    selectedLineStyle.lineWidth = 5.0f;
    
    plot.dataLineStyle = selectedLineStyle;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point {
    if ([self selection] == NOT_SELECTED) {
        return YES;
    }

    CPTXYGraph* graph = [[self channel] getGraph];
    point.x -= graph.plotAreaFrame.paddingLeft;
    
    // Convert the touch point to plot area frame location
    CGPoint pointInPlotArea = [graph convertPoint:point toLayer:graph.plotAreaFrame];
    
    NSDecimal pt[2];
    [space plotPoint:pt forPlotAreaViewPoint:pointInPlotArea];
    
    
    double x = [[NSDecimalNumber decimalNumberWithDecimal:pt[0]] doubleValue];
    NSLog(@"%s: %lf", __PRETTY_FUNCTION__, x);

//    double y = [[NSDecimalNumber decimalNumberWithDecimal:pt[1]] doubleValue];
    if ([self selection] == LEFT_SELECTED) {
        [self setLeft:x];
    } else if ([self selection] == RIGHT_SELECTED) {
        [self setRight:x];
    }
    
    
    [[self plot] reloadData];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_CHANNELSELECTOR_UPDATE
     object:self];
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////
- (void) onToggle:(NSNotification *) notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self setVisible:![self visible]];
    [[self plot] reloadData];

}

- (void) onUpdate:(NSNotification *) notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    ChannelSelector* cs = (ChannelSelector*)[notification object];
    if (self == cs) {
        return;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self setLeft:[cs left]];
    [self setRight:[cs right]];
    
    [[self plot] reloadData];
    
}

///////////////////////////////////////////////////////////////////////////////////////////



@end
