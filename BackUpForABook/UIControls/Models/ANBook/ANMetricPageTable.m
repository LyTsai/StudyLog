//
//  ANMetricPageTable.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANMetricPageTable.h"

@implementation ANMetricPageTable
{
    @private
    // array of ANMetricTable
    NSMutableArray* _tables;
}

-(id)init
{
    if (self == nil)
    {
        self = [super init];
    }
    
    if (_tables == nil)
    {
        _tables = [[NSMutableArray alloc] init];
    }
    
    // at default set to date 
    // http://rypress.com/tutorials/objective-c/data-types/dates
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *now = [NSDate date];
    _title = [formatter stringFromDate:now];
    
    return self;
}

// add page table
-(void)addTable:(ANMetricTable*)table
{
    if (_tables == nil)
    {
        _tables = [[NSMutableArray alloc] init];
    }
    
    [_tables addObject:table];
}

-(NSArray*)tables
{
    return _tables;
}

// access to page contents
-(NSUInteger)numberOfTables
{
    return _tables.count;
}

-(ANMetricTable*)getTable:(NSUInteger)tableNumber
{
    if (tableNumber >= _tables.count)
    {
        return nil;
    }
    
    return [_tables objectAtIndex:tableNumber];
}

// create test data set
-(void)createTestPageTable
{
    if (_tables == nil)
    {
        _tables = [[NSMutableArray alloc] init];
    }
    
    // section one
    ANMetricTable* table = [[ANMetricTable alloc] init];
    [table createTestTable];
    table.title = @"Test type one";
    
    [_tables addObject:table];
    
    table = [[ANMetricTable alloc] init];
    [table createTestTable];
    table.title = @"Test type two";
    
    [_tables addObject:table];
    
    table = [[ANMetricTable alloc] init];
    [table createTestTable];
    table.title = @"Test type three";
    
    [_tables addObject:table];
}

@end
