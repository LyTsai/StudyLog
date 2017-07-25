//
//  ANMetricsCollection.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANMetricsCollection.h"
#import "ANMetricListFactory.h"

@implementation ANMetricsCollection
{
    @private
    
    // system defualt metrics list
    ANMetricList* _defaultMetricList;
    
    // metric list from external sources <key, ANMetricList*>
    NSMutableDictionary* _key2MetricList;
}

// methods
-(id)init
{
    self = [super init];
    
    _defaultMetricList = [[ANMetricList alloc] init];
    
    _key2MetricList = [[NSMutableDictionary alloc] init];
    
    return self;
}

// create default supported metric list
-(void)createDefaultMetricsList
{
    _defaultMetricList = [ANMetricListFactory createDefaultMetricsList];
}

// map givem metric value to view
-(ANMetricView*)metricView:(NSString*)metricKey
                     value:(double)value
{
    ANMetricView* vw = nil;
    
    // try _defaultMetricList
    if (_defaultMetricList != nil)
    {
        vw = [_defaultMetricList metricView:metricKey value:value];
    }
    
    if (vw != nil)
    {
        return vw;
    }
    
    // !!! To Do try _key2MetricList
    
    return vw;
}

// get metric information for the given metric key
-(ANMetric*) getMetric:(NSString*)key
{
    ANMetric* metric = nil;
    
    // try _defaultMetricList
    if (_defaultMetricList != nil)
    {
        metric = [_defaultMetricList getMetric:key];
    }
    
    if (metric != nil)
    {
        return metric;
    }
    
    // !!! To Do. try _key2MetricList
    
    return metric;
}

@end
