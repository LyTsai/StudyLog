//
//  ANMetricsCollection.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricView.h"

// collection of supported metrics and its view information
@interface ANMetricsCollection : NSObject

// create default supported metric list
-(void)createDefaultMetricsList;

// map given metric value to view
-(ANMetricView*)metricView:(NSString*)metricKey
                     value:(double)value;

// get metric information for the given metric key
-(ANMetric*) getMetric:(NSString*)key;

@end
