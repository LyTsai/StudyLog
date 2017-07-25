//
//  ANVLMetric.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ANVLMetric.h"

@implementation ANVLMetric

-(id)initWith:(NSString*)key
        value:(double)value
{
    if (self == nil)
    {
        self = [super init];
    }
    
    _metricKey = key;
    _value = value;
    
    return self;
}

@end
