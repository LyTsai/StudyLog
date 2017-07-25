//
//  ANMetricFilter.h
//  ANBookPad
//
//  Created by hui wang on 8/28/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANRange.h"

// !!! not needed anymore.  remove later
// class for define a filter of metric
@interface ANMetricFilter : NSObject

// metric name of this filter
@property(strong, nonatomic)NSString* metricName;

// name, info as in core data entitiy
@property(strong, nonatomic)NSString* name;
@property(strong, nonatomic)NSString* info;
@property(strong, nonatomic)NSString* key;

// range for attached metric
@property(strong, nonatomic)ANRange* range;

// method

@end
