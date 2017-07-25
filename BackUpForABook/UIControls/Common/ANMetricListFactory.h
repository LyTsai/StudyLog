//
//  ANMetricListFactory.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/12/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricList.h"
#import "ANClassifier.h"
#import "metrics.h"

@interface ANMetricListFactory : NSObject
  
// create default supported metric list
+(ANMetricList*)createDefaultMetricsList;

// load all supported metrics onto given metric list
+(void)loadAllSuopportedMetrics_Annielyticx:(ANMetricList*)metricList;

/////////////////////////////////////////////////////////////////////////////////////////////////////
// add metric into given metric collection
+(void)addMetricOntoList:(ANMetricList*)metricList
                     key:(NSString*)key
                    name:(NSString *)name
                    unit:(NSString *)unitSymbol
                unitType:(int)unitType
             value_class:(MetricClass)value_class;

/////////////////////////////////////////////////////////////////////////////////////////////////////
// create ANMetric object.  will be called to for converting supported metrics from core data
// after creating ANMetric object you may call the methods of ANMetric to add ranges: addNormalRange, addValidRange
// key, name, info - from metric entity attributes
// unitType, unitSymbol - from metric relationships "withUnit"
// value_class - from metric relationship "withType"
+ (ANMetric*) createMetric:(NSString *)key
                      name:(NSString *)name
                      info:(NSString *)info
                      unit:(NSString *)unitSymbol
                  unitType:(int)unitType
               value_class:(MetricClass)value_class;

/////////////////////////////////////////////////////////////////////////////////////////////////////
// create ANMetricView object.  the same use as ANMetric object
// key - metric key the one from metric entity
// name - metric name this view is created for
// classifier - provides the function of "mapping" given metric value to classification (view)
+(ANMetricView*) createMetricView:(NSString *)key
                             name:(NSString *)name
                       classifier:(ANClassifier*)classifier;

@end
