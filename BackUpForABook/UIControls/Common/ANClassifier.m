//
//  ANClassifier.m
//  ANBookPad
//
//  Created by hui wang on 8/28/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import "ANClassifier.h"

@implementation ANClassifier
{
    // _metricFilters
    NSMutableArray* _metricFilters;
}

-(instancetype) init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    _metricFilters = [[NSMutableArray alloc] init];
    
    return self;
}

// get array of filters
-(NSArray*) metricFilters
{
    return _metricFilters;
}

// add one metric filter
-(void) addMetricFilter:(ANMetricFilter*) filter
{
    if (_metricFilters == nil)
    {
        _metricFilters = [[NSMutableArray alloc] init];
    }
    
    [_metricFilters addObject:filter];
}

@end