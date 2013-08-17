//
//  SummaryProjectOutline.m
//  BEDA
//
//  Created by Sehoon Ha on 8/14/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import "SummaryProjectOutline.h"

@implementation SPGroup

@synthesize name;
@synthesize datafiles = _datafiles;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setName:@"New Group"];
        _datafiles = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)registerToFlattenList:(NSMutableArray*) flattenList {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [flattenList addObject:self];
//    NSLog(@"%s: flatten list length = %ld", __PRETTY_FUNCTION__, (unsigned long)[flattenList count]);

    for (SPDataFile* df in [self datafiles]) {
        [df registerToFlattenList:flattenList];
    }
}

@end


@implementation SPDataFile

@synthesize filename;
@synthesize parent;
@synthesize properties = _properties;

-(id) initWithParent:(SPGroup*)ppp {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self setFilename:@""];
        [self setParent:ppp];
        _properties = [[NSMutableDictionary alloc] init];

    }
    return self;
}


- (void)setProperty:(NSString*)name as:(double)value {
    [[self properties] setObject:[NSNumber numberWithDouble:value] forKey:name];
}

- (BOOL)hasProperty:(NSString*)name {
    return ([[self properties] objectForKey:name] != Nil);
}

- (double)getProperty:(NSString*)name {
    NSNumber* num = [[self properties] objectForKey:name];
    if (num) {
        return [num doubleValue];
    } else {
        return 0.0;
    }
}

- (void)registerToFlattenList:(NSMutableArray*) flattenList {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [flattenList addObject:self];
//    NSLog(@"%s: flatten list length = %ld", __PRETTY_FUNCTION__, (unsigned long)[flattenList count]);

}

@end

@implementation SummaryProjectOutline

@synthesize groups = _groups;
@synthesize flattenList = _flattenList;

-(id) init {
    self = [super init];
    
    if (self) {
        // Initialization code here
        NSLog(@"%s", __PRETTY_FUNCTION__);
        _groups = [[NSMutableArray alloc] init];
        _flattenList = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.outlineview setDataSource:self];
    [self.outlineview setDelegate:self];
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if ([item isKindOfClass:[SPGroup class]] && [[(SPGroup*)item datafiles] count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [[self groups] count];
    }
    
    if ([item isKindOfClass:[SPGroup class]]) {
        return [[(SPGroup*)item datafiles] count];
    }
    
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [[self groups] objectAtIndex:index];
    }
    
    if ([item isKindOfClass:[SPGroup class]]) {
        return [[(SPGroup*)item datafiles] objectAtIndex:index];
    }
    return nil;
//    return @"HELLO";
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)theColumn byItem:(id)item
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    
    if ([[theColumn identifier] isEqualToString:@"group"]) {
        if ([item isKindOfClass:[SPGroup class]]) {
            SPGroup* group = item;
            return [group name];
        }

    } else {
        if ([item isKindOfClass:[SPDataFile class]]) {
            SPDataFile* df = item;
            return [df filename];
        }
    }

    return nil;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)theColumn byItem:(id)item
{
    if ([[theColumn identifier] isEqualToString:@"group"]) {
        if ([item isKindOfClass:[SPGroup class]]) {
            SPGroup* group = item;
            [group setName:object];
        }
    }
}

- (IBAction)onNewGroup:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[self groups] addObject:[[SPGroup alloc] init]];
    [self.outlineview reloadData];
}

- (SPDataFile*)addNewDataFile:(NSString*)filename {
    id item = [self.outlineview itemAtRow:[self.outlineview selectedRow]];
    SPGroup* group = nil;
    if ([item isKindOfClass:[SPDataFile class]]) {
        group = [(SPDataFile*)item parent];
    } else if ([item isKindOfClass:[SPGroup class]]) {
        group = item;
    }
    if (group == Nil) {
        return Nil;
    }
    NSLog(@"%s: group = %@", __PRETTY_FUNCTION__, [group name]);
    SPDataFile* df = [[SPDataFile alloc] initWithParent:group];
    [df setFilename:filename];
    [[group datafiles] addObject:df];
    [self updateFlattenList];
    [self.outlineview reloadData];
    return df;
//    return [group name];
}

- (void)updateFlattenList {
    [[self flattenList] removeAllObjects];
//    NSLog(@"%s: # groups = %d", __PRETTY_FUNCTION__, (int)[[self groups] count]);

    for (SPGroup* group in [self groups]) {
        [group registerToFlattenList:[self flattenList]];
    }
    NSLog(@"%s: flatten list length = %ld", __PRETTY_FUNCTION__, (unsigned long)[[self flattenList] count]);

}


@end
