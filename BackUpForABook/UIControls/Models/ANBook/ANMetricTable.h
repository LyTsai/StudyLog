//
//  ANMetricTable.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANVLMetric.h"

@interface ANMetricTable : NSObject

// table title
@property(strong, nonatomic) NSString* title;

-(id)init;

// array of ANVLMetric objects
@property(strong, nonatomic)NSArray* metricList;
// add one metric
-(void)addMetric:(NSString*)metricKey
           value:(double)value;

// access to table content
-(NSUInteger)numberOfRows;
-(ANVLMetric*)getRow:(NSUInteger)nRow;

// test methods
// create test data set
-(void)createTestTable;

@end
