//
//  ANMetricTable.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANMetricTable.h"
#import "metrics.h"

@implementation ANMetricTable
{
    @private
    
    // array of ANVLMetric objects
    NSMutableArray* _rows;
}

-(id)init
{
    if (self == nil)
    {
        self = [super init];
    }
    
    if (_rows == nil)
    {
        _rows = [[NSMutableArray alloc] init];
    }
    
    _title = @"test type";
    
    return self;
}

-(void)addMetric:(NSString*)metricKey
           value:(double)value
{
    if (_rows == nil)
    {
        _rows = [[NSMutableArray alloc] init];
    }
    
    [_rows addObject:[[ANVLMetric alloc] initWith:metricKey value:value]];
    
    return ;
}

-(NSArray*)metricList
{
    return _rows;
}

-(NSUInteger)numberOfRows
{
    if (_rows == nil)
    {
        return 0;
    }
    
    return _rows.count;
}

-(ANVLMetric*)getRow:(NSUInteger)nRow
{
    if (nRow >= _rows.count)
    {
        return nil;
    }
    
    return [_rows objectAtIndex:nRow];
}

// create test data set
-(void)createTestTable
{
    [self addMetric:ANMETRIC_SKIN_YEARS value:-3.0];
    [self addMetric:ANMETRIC_HEART_YEARS value:3.0];
    [self addMetric:ANMETRIC_BRAIN_YEARS value:-3.0];
    [self addMetric:ANMETRIC_NEWCHOLESTEROL value:36.0];
    [self addMetric:ANMETRIC_DIABETES_RISK value:36.0];
    [self addMetric:ANMETRIC_CVD_RISK value:13.0];
    [self addMetric:ANMETRIC_10YEARSURVIVAL value:38.0];
    [self addMetric:ANMETRIC_STROKE_RISK value:53.0];
}

@end
