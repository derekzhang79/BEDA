//
//  ViewRangeController.m
//  BEDA
//
//  Created by Sehoon Ha on 7/10/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ViewRangeController.h"
#import "BedaController.h"

@implementation ViewRangeController


@synthesize graph;
@synthesize selectedIndex;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self initGraph];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSourceAdded:)
                                                 name:BEDA_NOTI_SOURCE_ADDED object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onViewUpdated:)
                                                 name:BEDA_NOTI_VIEW_UPDATE object:Nil];
}

-(BedaController*)beda {
    return [BedaController getInstance];
}

-(void)reloadGraph{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [graph reloadData];
    
}

- (void)initGraph{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super awakeFromNib];
    
    NSDate *refDate       = [NSDate dateWithNaturalLanguageString:@"00:00:00"];
    // If you make sure your dates are calculated at noon, you shouldn't have to
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSTimeInterval aProject = 1;
    
    // Create graph from theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    graph.plotAreaFrame.paddingTop = 5.0f;
    graph.plotAreaFrame.paddingRight = 5.0f;
    graph.plotAreaFrame.paddingLeft = 5.0f;
    graph.plotAreaFrame.paddingBottom = 20.0f;
    
    graph.paddingRight = 3.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    
    // Setup scatter plot space
    plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = NO;
    plotSpace.delegate = self;
    
    int min = 0;
    int max = 50;
    double len = max - min;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(300)];
//    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(aProject * 5000.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(len)];
//    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(len)];
    
    CPTMutableTextStyle *axisTextStyle = [CPTTextStyle textStyle];
    axisTextStyle.fontSize = 10.0;
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.15];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    NSNumberFormatter *labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    labelFormatter.maximumFractionDigits = 0;
    
    CPTMutableTextStyle *titleText = [CPTMutableTextStyle textStyle];
    titleText.color = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    titleText.fontSize = 12;
    titleText.fontName = @"Helvetica";
    
    NSTimeInterval oneSec = 1;

    // Setting X-Axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;

    x.labelingPolicy     =  CPTAxisLabelingPolicyAutomatic;
    x.preferredNumberOfMajorTicks = 10;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
    x.axisLineStyle = majorGridLineStyle;
    x.labelFormatter     = labelFormatter;
    x.labelTextStyle = titleText;
    x.majorIntervalLength         = CPTDecimalFromFloat(oneSec * 60);
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    if ([[self beda] duration] > 3600) {
        [dateFormatter setDateFormat: @"h:mm:ss"];
    } else {
        [dateFormatter setDateFormat: @"mm:ss"];
    }
    
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter            = timeFormatter;
    
    
    // Setting up y-axis
	CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;

    y.majorIntervalLength = CPTDecimalFromInt(12);
    y.minorTicksPerInterval = 0;
    y.majorTickLineStyle = nil;
    y.minorGridLineStyle = nil;
    
    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
    
    
    // Create header plot
    plot = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    plot.dataSource = self;
    plot.delegate = self;
    CPTFill *areaFill = [CPTFill fillWithColor:[[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.15]];
    plot.areaFill      = areaFill;
    plot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    [self deselect];
    [graph addPlot:plot];
    
    graphview.hostedGraph = graph;
}

- (void) onSourceAdded:(NSNotification *) notification {
    double d = [[self beda] duration];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(d)];
    [graph reloadData];
}

- (void) onViewUpdated:(NSNotification *) notification {
    [graph reloadData];
}


- (CPTColor*) toCPT:(NSColor*)nc {
    CGFloat r = [nc redComponent];
    CGFloat g = [nc greenComponent];
    CGFloat b = [nc blueComponent];
    CGFloat a = [nc alphaComponent];
    return [CPTColor colorWithComponentRed:r green:g blue:b alpha:a];
}

- (void)select : (int)index{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CPTColor *selectedPlotColor = [CPTColor redColor];
    
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = selectedPlotColor;
    
    CPTPlotSymbol *plotSymbol = nil;
    plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:selectedPlotColor];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(15.0f, 15.0f);
    
    plot.plotSymbol = plotSymbol;
    
    CPTMutableLineStyle *selectedLineStyle = [CPTMutableLineStyle lineStyle];
    selectedLineStyle.lineColor = [CPTColor yellowColor];
    selectedLineStyle.lineWidth = 5.0f;
    
    plot.dataLineStyle = selectedLineStyle;
    [self setSelectedIndex:index];

}

- (void)deselect {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Set the style
    // 1. SavingPlotLine style
    CPTColor *headerPlotColor = [CPTColor orangeColor];
    CPTMutableLineStyle *savingsPlotLineStyle = [CPTMutableLineStyle lineStyle];
    savingsPlotLineStyle.lineColor = headerPlotColor;
    
    // 2. Symbol style
    CPTPlotSymbol *headerPlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    headerPlotSymbol.fill = [CPTFill fillWithColor:headerPlotColor];
    headerPlotSymbol.lineStyle = savingsPlotLineStyle;
    headerPlotSymbol.size = CGSizeMake(15.0f, 15.0f);
    plot.plotSymbol = headerPlotSymbol;
    
    // 3. DataLineStyle
    CPTMutableLineStyle *headerLineStyle = [CPTMutableLineStyle lineStyle];
    headerLineStyle.lineColor = [CPTColor orangeColor];
    headerLineStyle.lineWidth = 2.0f;
    plot.dataLineStyle = headerLineStyle;
    [self setSelectedIndex:-1];
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Delegation functions
- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event
          atPoint:(CGPoint)point
{
    
    point.x -= graph.plotAreaFrame.paddingLeft;
    
    // Convert the touch point to plot area frame location
    CGPoint pointInPlotArea = [graph convertPoint:point toLayer:graph.plotAreaFrame];
    
    NSDecimal pt[2];
    [space plotPoint:pt forPlotAreaViewPoint:pointInPlotArea];
    
    
    double x = [[NSDecimalNumber decimalNumberWithDecimal:pt[0]] doubleValue];
    double l = [[self beda] gtViewLeft];
    double r = [[self beda] gtViewRight];
    if (l <= x && x <= r) {
        [[NSCursor openHandCursor] set];
        [self setXToLeft:l - x];
        [self setXToRight:r - x];
        NSLog(@"%s: to left/right = {%lf %lf}", __PRETTY_FUNCTION__, [self xToLeft], [self xToRight]);

        [self select:BEDA_CONST_VIEW_RANGE_ALL_SELECTED];

    }
    
    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Restore the vertical line plot to its initial color.
    
    [self deselect];
    [[NSCursor arrowCursor] set];
    return YES;
}

- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    [self select:index];
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point
{
    if ([self selectedIndex] >= 0) {
        point.x -= graph.plotAreaFrame.paddingLeft;
        
        // Convert the touch point to plot area frame location
        CGPoint pointInPlotArea = [graph convertPoint:point toLayer:graph.plotAreaFrame];
        
        NSDecimal pt[2];
        [space plotPoint:pt forPlotAreaViewPoint:pointInPlotArea];
        
        
        double x = [[NSDecimalNumber decimalNumberWithDecimal:pt[0]] doubleValue];
        if( x < 0 ){
            x = 0;
        }
        double y = [[NSDecimalNumber decimalNumberWithDecimal:pt[1]] doubleValue];
        NSLog(@"%s: %lf, %lf", __PRETTY_FUNCTION__, x, y);
        
        switch ([self selectedIndex]) {
            case 0:
            case 1:
                [[self beda] setGtViewLeft:x];
                break;
            case 2:
            case 3:
                [[self beda] setGtViewRight:x];
                break;
            case BEDA_CONST_VIEW_RANGE_ALL_SELECTED:
                [[self beda] setGtViewLeft:x + [self xToLeft]];
                [[self beda] setGtViewRight:x + [self xToRight]];
            default:
                break;
        }
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BEDA_NOTI_VIEW_UPDATE
         object:self];
    }
    
    return YES;
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([[[self beda] sources] count] > 0) {
        return 4;
    } else {
        return 0;
    }

}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
//    NSMutableArray* data = [[self plotYData] objectForKey:plot.identifier];

    double l = [[self beda] gtViewLeft];
    double r = [[self beda] gtViewRight];
    double d = 0.0;
    double u = 100.0;
    
    double px[6] = {l, l, r, r, 0.0, 0.0};
    double py[6] = {d, u, u, d, 0.2, 0.0};
    
//    NSLog(@"%s, {%lf, %lf}, {%lf, %lf}", __PRETTY_FUNCTION__, l, r, d, u);

//    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (fieldEnum == CPTScatterPlotFieldX) {
        // Returns X values
        return [NSNumber numberWithDouble: (px[index]) ];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        // Returns Y values
        return [NSNumber numberWithDouble: (py[index]) ];
    } else {
        return nil;
    }
}

@end
