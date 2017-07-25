//
//  ANMetricList.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/10/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricView.h"
#import "ANMetricViewProjector.h"

// collection of supported metrics with metric information and GUI mapping for secific value
@interface ANMetricList : NSObject{
    
}

// properties
// collection of metric - view projectors in the form of key - ANMetricProjector.
@property(strong, nonatomic)NSMutableDictionary* metrics;

// methods

// add one metric
-(void)addMetric:(ANMetric*)metric;
// add one metric view 
-(void)addMetricView:(NSString*)key
                view:(ANMetricView*)view;
// access to the entire set of metric view mapping table
-(NSMutableDictionary*) getMetricViewProjectors;
// "project" value of given metric into view space
-(ANMetricView*)metricView:(NSString*)key
                     value:(double)value;
// access to projector for the given key
-(ANMetricViewProjector*) getViewProjector:(NSString*)key;
// access to metric for the given key
-(ANMetric*) getMetric:(NSString*)key;

@end
