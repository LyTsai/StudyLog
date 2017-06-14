//
//  ANMetricList.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/10/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "ANMetricList.h"

@interface ANMetricList (PrivateMethods)

@end

@implementation ANMetricList

// methods
-(id)init
{
    self = [super init];
    
    // collection of ANMetricViewProjector
    _metrics = [[NSMutableDictionary alloc] init];
    
    return self;
}

// add one metric
-(void)addMetric:(ANMetric*) metric
{
    // do we already have it in our list?
    if (_metrics == nil)
    {
        _metrics = [[NSMutableDictionary alloc] init];
    }
    
    if ([_metrics objectForKey:metric.key] != nil)
    {
        // already have one key
        return ;
    }
    
    // create projector for the given metric
    [_metrics setObject:[[ANMetricViewProjector alloc] initWithMetric:metric] forKey:metric.key];
}

// add one metric view
-(void)addMetricView:(NSString*)key
                view:(ANMetricView*)view
{
    // do we have such metric key?
    if (key == nil || _metrics == nil || [_metrics objectForKey:key] == nil)
    {
        // no such metric in the list
        return ;
    }
    
    if ([[_metrics objectForKey:key] isKindOfClass:[ANMetricViewProjector class]] != TRUE)
    {
        return ;
    }
    
    ANMetricViewProjector* metricViews = [_metrics objectForKey:key];
    
    [metricViews addMetricView:key view:view];
}

// access to the entire set of metric view mapping table
-(NSMutableDictionary*) getMetricViewProjectors
{
    return _metrics;
}

// "project" value of given metric into view space
-(ANMetricView*)metricView:(NSString*)key
                     value:(double)value
{
    // do we have view projector for the given metric key?
    if (key == nil || _metrics == nil || [_metrics objectForKey:key] == nil)
    {
        // no such metric in the list
        return nil;
    }

    if ([[_metrics objectForKey:key] isKindOfClass:[ANMetricViewProjector class]] != TRUE)
    {
        return nil;
    }
    
    return [[_metrics objectForKey:key] viewOf:value];
}

// access to projector for the given key
-(ANMetricViewProjector*) getViewProjector:(NSString*)key
{
    if (key == nil || _metrics == nil || [_metrics objectForKey:key] == nil)
    {
        // no such metric in the list
        return nil;
    }
    
    if ([[_metrics objectForKey:key] isKindOfClass:[ANMetricViewProjector class]] != TRUE)
    {
        return nil;
    }
    
    return [_metrics objectForKey:key];
}

// access to metric for the given key
-(ANMetric*) getMetric:(NSString*)key
{
    if ([self getViewProjector:key] == nil)
    {
        return nil;
    }
    
    return [self getViewProjector:key].metric;
}

@end
