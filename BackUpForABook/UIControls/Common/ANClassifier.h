//
//  ANClassifier.h
//  ANBookPad
//
//  Created by hui wang on 8/28/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricFilter.h"
#import "ANClassification.h"

// !!! not needed anymore.  remove later
// define class for metric classifier.  can be used to store metric classifier read from core data
// key, name, info, score, filters and classification
@interface ANClassifier : NSObject

@property(strong, nonatomic)NSString* key;
@property(strong, nonatomic)NSString* name;
@property(strong, nonatomic)NSString* info;
@property(strong, nonatomic)ANClassification* classification;
@property float score;

// methods:

// get array of filters
-(NSArray*) metricFilters;

// add one metric filter
-(void) addMetricFilter:(ANMetricFilter*) filter;

@end
