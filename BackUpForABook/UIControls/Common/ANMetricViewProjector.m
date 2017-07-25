//
//  ANMetricViewProjector.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/9/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "ANMetricViewProjector.h"

@implementation ANMetricViewProjector


-(id)initWithMetric:(ANMetric*) metric
{
    self = [super init];
    
    _metric = metric;
    _views = [[NSMutableArray alloc] init];
    
    return self;
}

// add one view
-(void)addMetricView:(NSString*)key
                view:(ANMetricView*)view
{
    if (view == nil || key == nil)
    {
        return ;
    }
    
    // make sure the metric key matchs with metric
    if ([key compare:_metric.key] != NSOrderedSame)
    {
        // not the right metric
        return ;
    }
    
    if (_views == nil)
    {
        _views = [[NSMutableArray alloc] init];
    }
    
    [_views addObject:view];
    
    return ;
}

// methods
// map given metric value to the view
// map metric value to ANMetricView.  return nil if no mapping information for the value
-(ANMetricView*)viewOf:(double)value
{
    if (_metric == nil || _views == nil)
    {
        return nil;
    }
    
    id obj;
    
    for (obj in _views)
    {
        if ([obj isKindOfClass:[ANMetricView class]] != TRUE)
        {
            continue;
        }
        
        ANMetricView *oneView = obj;
        if (value >= oneView.min && value <= oneView.max)
        {
            return oneView;
        }
    }
    
    return nil;
}


@end
