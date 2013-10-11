//
//  ExtraVisualizationController.m
//  BEDA
//
//  Created by Sehoon Ha on 9/1/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "ExtraVisualizationController.h"

@implementation ExtraVisualizationController

@synthesize xlabels = _xlabels;
@synthesize ypeaks = _ypeaks;
@synthesize yauc = _yauc;

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    _xlabels =  [[NSMutableArray alloc] initWithObjects:@"", @"02_27.session", @"03_01.session", @"03_06.session", @"03_27.session",
                 @"", @"04_09.session", @"04_10.session", @"04_11.session",
                 @"", @"04_18.session", @"04_30.session", @"05_02.session", @"05_03.session",
                 @"", @"05_07.session", @"05_09.session", @"05_10.session",
                 nil];
    _yauc =  [[NSMutableArray alloc] initWithObjects:@"0", @"3.114292577", @"5.185298535", @"3.623843235", @"4.11317037",
                                                     @"0", @"8.15014977",  @"5.910163732", @"7.665497886",
                                                     @"0", @"4.699031394", @"3.489960873", @"6.579609001", @"4.516224149",
                                                     @"0", @"2.179248277", @"4.627932952", @"3.481698746", nil];
    _ypeaks =  [[NSMutableArray alloc] initWithObjects:@"0", @"0.000181678", @"0.000307652", @"0.000304125", @"0.000238802",
                                                    @"0", @"0.000374443",  @"0.000379543", @"0.000227857",
                                                    @"0", @"0.000395557", @"0.000319846", @"0.000403646", @"0.00036145",
                                                    @"0", @"0.000412252", @"0.00022929", @"0.000255715", nil];

    
    for (NSUInteger i = 0; i < [[self yauc] count]; i++) {
        double value = [(NSString*)[[self yauc] objectAtIndex:i] doubleValue];
        [[self yauc] replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:value]];
    }

    for (NSUInteger i = 0; i < [[self ypeaks] count]; i++) {
        double value = [(NSString*)[[self ypeaks] objectAtIndex:i] doubleValue];
        value = value * 20000;
        [[self ypeaks] replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:value]];
    }
    
    [self initGraph];

}

- (void)initGraph{
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    graph.plotAreaFrame.paddingRight = 0.0f;
    graph.plotAreaFrame.paddingLeft = 70.0f;
    graph.plotAreaFrame.paddingBottom = 120.0f;
    
    graph.paddingRight = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    
    graph.plotAreaFrame.borderLineStyle = nil;    // don't draw a border
    
    // Setup scatter plot space
    plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    
    int min = 0;
    int max = 10;
    double len = max - min;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(20)];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(aProject * 5000.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(len)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(len)];
    
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
    
    // Setting X-Axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    //    x.title = @"Project Name";
    x.titleOffset = 30.0f;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.labelExclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(6) length:CPTDecimalFromInt(1)], nil];
    
    // Use custom x-axis label so it will display product A, B, C... instead of 1, 2, 3, 4
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:[_xlabels count]];
    int idx = 0;
    for (NSString *product in _xlabels)
    {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:product textStyle:x.labelTextStyle];
        label.tickLocation = CPTDecimalFromInt(idx);
        label.offset = 5.0f;
        label.rotation = -M_PI / 4;
        [labels addObject:label];
        [label release];
        idx++;
    }
    x.axisLabels = [NSMutableSet setWithArray:labels];
    
    [labels release];
    
    
    // Setting up y-axis
	CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromInt(1);
    y.orthogonalCoordinateDecimal = CPTDecimalFromInt(0);
    y.minorTicksPerInterval = 0;
    y.minorGridLineStyle = nil;
    y.labelExclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(0)], nil];
    y.title = @"Normalized EDA Analysis results";
    y.titleOffset = 45;
    
    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
    
    
    // Add Bar Plot
    // Create a bar line style
    CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
    barLineStyle.lineWidth = 1.0;
    barLineStyle.lineColor = [CPTColor whiteColor];
    
    {
        // Create first bar plot
        CPTBarPlot *barPlot = [[[CPTBarPlot alloc] init] autorelease];
        barPlot.lineStyle       = barLineStyle;
        barPlot.fill            = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0f green:0.0f blue:0.5f alpha:0.5f]];
        barPlot.barBasesVary    = YES;
        barPlot.barWidth        = CPTDecimalFromFloat(0.4f); // bar is 50% of the available space
        barPlot.barCornerRadius = 10.0f;
#if HORIZONTAL
        barPlot.barsAreHorizontal = YES;
#else
        barPlot.barsAreHorizontal = NO;
#endif
        
        //    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
        //    whiteTextStyle.color   = [CPTColor whiteColor];
        //    barPlot.labelTextStyle = whiteTextStyle;
        
        barPlot.delegate   = self;
        barPlot.dataSource = self;
        barPlot.identifier = @"peaks";
        plotpeaks = barPlot;
        
        [graph addPlot:barPlot toPlotSpace:plotSpace];
    }
    
    
    {
        // Create first bar plot
        CPTBarPlot *barPlot = [[[CPTBarPlot alloc] init] autorelease];
        barPlot.lineStyle       = barLineStyle;
        barPlot.fill            = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.0f green:1.0f blue:0.0f alpha:0.5f]];
        barPlot.barBasesVary    = YES;
        barPlot.barWidth        = CPTDecimalFromFloat(0.4f); // bar is 50% of the available space
        barPlot.barCornerRadius = 10.0f;
    #if HORIZONTAL
        barPlot.barsAreHorizontal = YES;
    #else
        barPlot.barsAreHorizontal = NO;
    #endif
        
        //    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
        //    whiteTextStyle.color   = [CPTColor whiteColor];
        //    barPlot.labelTextStyle = whiteTextStyle;
        
        barPlot.delegate   = self;
        barPlot.dataSource = self;
        barPlot.identifier = @"auc";
        plotauc = barPlot;

        [graph addPlot:barPlot toPlotSpace:plotSpace];
    }
    
    // Add legend
    graph.legend                 = [CPTLegend legendWithPlots:[NSArray arrayWithObjects:plotauc, plotpeaks, nil]];
    graph.legend.textStyle       = x.titleTextStyle;
    graph.legend.borderLineStyle = x.axisLineStyle;
    graph.legend.cornerRadius    = 5.0;
    graph.legend.numberOfRows    = 1;
    graph.legend.swatchSize      = CGSizeMake(25.0, 25.0);
    graph.legendAnchor           = CPTRectAnchorBottom;
    graph.legendDisplacement     = CGPointMake(0.0, 0.0);
    
    // set as hosted graph
    graphview.hostedGraph = graph;
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [[self xlabels] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString* label = [[self xlabels] objectAtIndex:index];
    if ([label isEqualToString:@""]) {
        return nil;
    }
    
    NSNumber *num = nil;
    if (fieldEnum == CPTBarPlotFieldBarBase) {
        num = [NSDecimalNumber numberWithInt:0];
    } else if (fieldEnum == CPTBarPlotFieldBarTip){
        if ( [plot.identifier isEqual:@"auc"] ) {
            num = [[self yauc] objectAtIndex:index];
        } else {
            num = [[self ypeaks] objectAtIndex:index];
        }
    } else if (fieldEnum == CPTBarPlotFieldBarLocation){
        if ( [plot.identifier isEqual:@"auc"] ) {
            num = [NSDecimalNumber numberWithDouble:(double)index - 0.21];
        } else {
            num = [NSDecimalNumber numberWithDouble:(double)index + 0.21];
        }    }
    
    return num;
}

@end
