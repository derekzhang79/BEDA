//
//  GraphWindowController.m
//  BEDA
//
//  Created by Jennifer Kim on 6/13/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "GraphWindowController.h"
#import "BedaController.h"
#import "Source.h"
#import "SourceTimeData.h"
#import "ChannelTimeData.h"


@implementation SourceTabViewItem

@synthesize tvc;

@end

@implementation GraphWindowController

@synthesize tableViewControllers = _tableViewControllers;
@synthesize settingControllers = _settingControllers;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _tableViewControllers = [[NSMutableArray alloc] init];
        _settingControllers   = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) awakeFromNib {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"%s: # of beda sources = %ld", __PRETTY_FUNCTION__, (unsigned long)[[[self beda] sources] count]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSourceAdded:)
                                                 name:BEDA_NOTI_SOURCE_ADDED object:Nil];
    
    for (int i = 0; i < [[[self beda] sources] count]; i++) {
        [self addTableViewFor:i];
        
        SourceTimeData* source = [[[self beda] sources] objectAtIndex:i];
        if ([source isKindOfClass:[SourceTimeData class]] == YES) {
            for (ChannelTimeData* ch in [source channels]) {
                if ([ch channelIndex] < 0) {
                    [self addGraphForBehaviorChannel:ch];

                } else {
                    [self addGraphForGraphChannel:ch];

                }
            }

        }
    }
    
}


- (void) onSourceAdded:(NSNotification*) noti {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    int n = (int)[[[self beda] sources] count];
    [self addTableViewFor:n - 1];
    
}


- (void)addTableViewFor:(int)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    SourceTimeData* source = [[[self beda] sources] objectAtIndex:index];
    if ([source isKindOfClass:[SourceTimeData class]] == NO) {
        NSLog(@"%s : source is not SourceTimeData", __PRETTY_FUNCTION__);
        return;
    }
    
    NSString* name = [source name];
    NSLog(@"creating a tab for source [%@]", name);
    // Create a tab view item
    SourceTabViewItem *item = [[[SourceTabViewItem alloc]
                            initWithIdentifier:name] autorelease];
    
    [item setLabel:name];
    
    // Create a custum view and assign it to the tab view item
    TableViewController* tvc = [[TableViewController alloc]
                                                initWithNibName:@"TableView" bundle:nil];
    [[self tableViewControllers] addObject:tvc];
    [tvc setSource:source];
    [item setView:[tvc view]];
    [item setTvc:tvc];
    
    // Add a new tab to the tabview
    [tabview addTabViewItem:item];
    [tabview selectTabViewItem:item];

}

- (IBAction) removeTabViewItem:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSTabViewItem* item = [graphControlTabview selectedTabViewItem];
    Channel* ch = [item identifier];
    for (Source* s in [[self beda] sources]) {
        [s deleteChannel:ch];
    }
    [graphControlTabview removeTabViewItem:item];
}

- (IBAction)openFile:(id)sender {
    [[self beda] openFile:nil];

}

- (IBAction)onAddGraph:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    SourceTabViewItem* selectedItem = (SourceTabViewItem*)[tabview selectedTabViewItem];
    if (selectedItem == Nil) {
        NSLog(@"%s: selectedItem is Nil", __PRETTY_FUNCTION__);
        return;
    }
    
    int selectedIndex = (int)[tabview indexOfTabViewItem:selectedItem];
    NSLog(@"%s: selectedIndex = %d", __PRETTY_FUNCTION__, selectedIndex);
    
    TableViewController* tvc = [selectedItem tvc];
    if ([tvc selectedTableColumn] == -1) {
        NSLog(@"%s: there's no selected graph", __PRETTY_FUNCTION__);
    }
    
    SourceTimeData* s = [tvc source];

    BOOL isAnnotation = [[tvc selectedTableColumnName] isEqualToString:@"Annotation"];
    ////// Create a channel
    // Step 1. Create the proper channel
    ChannelTimeData *ch = [[ChannelTimeData alloc] init];
    [ch setSource:s];
    [ch setName:[tvc selectedTableColumnName]];
    
    // Step 2. initialize the graph
    int index;
    double minValue;
    double maxValue;
    
    if (isAnnotation) {
        index = -1;
        minValue = 0;
        maxValue = 4;
    } else {
        index = [tvc selectedTableColumn];
        minValue = [s minValueForColumn:index];
        maxValue = [s maxValueForColumn:index];
    }
    
    [ch initGraph:@"Annotation" atIndex:index range:minValue to:maxValue
    withLineColor: [NSColor blueColor] 
        areaColor:[NSColor magentaColor]
         isBottom:YES hasArea:NO];
    [ch setMyTimeInGlobal:[[self beda] gtAppTime]];
    [[s channels] addObject:ch];

    
    if (isAnnotation) {
        [self addGraphForBehaviorChannel:ch];

    } else {
        [self addGraphForGraphChannel:ch];
    }
}

- (void)addGraphForBehaviorChannel:(ChannelTimeData*)ch {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    SourceTimeData* source = [ch sourceTimeData];
    NSMutableString* name =  [[NSMutableString alloc] init];
    [name appendString:[source name]];
    [name appendString:@":"];
    [name appendString:[ch name]];

    // Create a tab view item
    NSTabViewItem *item = [[[NSTabViewItem alloc]
                            initWithIdentifier:name] autorelease];
    [item setLabel:name];
    [item setIdentifier:ch];
    
    BehaviorSettingController* behaviorSettingController = [[BehaviorSettingController alloc]
                                                            initWithNibName:@"BehaviorSettingView" bundle:nil];
    [behaviorSettingController setSource:source];
    [[self settingControllers] addObject:behaviorSettingController];
    
    [item setView:[behaviorSettingController view]];
    [graphControlTabview addTabViewItem:item];
    [graphControlTabview selectTabViewItem:item];
}

- (void)addGraphForGraphChannel:(ChannelTimeData*)ch  {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    SourceTimeData* source = [ch sourceTimeData];
    NSMutableString* name =  [[NSMutableString alloc] init];
    [name appendString:[source name]];
    [name appendString:@":"];
    [name appendString:[ch name]];
    
    // Create a tab view item
    NSTabViewItem *item = [[[NSTabViewItem alloc]
                            initWithIdentifier:name] autorelease];
    [item setLabel:name];
    [item setIdentifier:ch];

    GraphSettingController* graphSettingController = [[GraphSettingController alloc]
                                                      initWithNibName:@"GraphSettingView" bundle:nil];
    [graphSettingController setSource:source];
    [graphSettingController setChannel:ch];
    int columnIndex = [ch channelIndex];
    [graphSettingController setColumnIndex:columnIndex];
    [[self settingControllers] addObject:graphSettingController];
    
    [item setView:[graphSettingController view]];
    [graphControlTabview addTabViewItem:item];
    [graphControlTabview selectTabViewItem:item];

}


- (IBAction)onApplySettings:(id)sender{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEDA_NOTI_APPLY_SETTING_PRESSED
     object:nil];
    
    [[self beda] createViewsForAllChannels];
}

- (BedaController*) beda {
    return [BedaController getInstance];
}

@end
