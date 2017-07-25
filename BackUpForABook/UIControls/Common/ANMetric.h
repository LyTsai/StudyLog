//
//  ANMetric.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/9/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#include "metrics.h"
#import <Foundation/Foundation.h>
#import "ANRange.h"
#import <JSONModel/JSONModel.h>

// represents annielyticx metric information.
// all metrics would be loaded from annielytics back end object OMMetric table
@interface ANMetric : JSONModel

// properties

//////////////////////////////////////////////////////////
// !!! basic information
//////////////////////////////////////////////////////////
// unique key (defined in metric.h).  ANMETRIC_CVD_RISK for example
@property(strong, nonatomic)NSString* key;
// metric name (or symbol) such as "Total Cholesterol" etc.  The display can be loaded for different languages from backend table of persistent data source
@property(strong, nonatomic)NSString* name;
// unit type. would be loaded from back end table.
// !!! To do unit type supported by the system
@property(nonatomic)UNIT unit_type;
// unit symbol.  can be alos loaded depends on the language or for persistent data sources
@property(strong, nonatomic)NSString* unit_symbol;

// value type (classification or measurement)
@property(nonatomic)MetricClass value_class;

//////////////////////////////////////////////////////////
// !!! additional information for range checking
//////////////////////////////////////////////////////////

// normal ranges: array of ANRange
@property(strong, nonatomic)NSArray* normalRanges;

// methods
-(NSArray*) normalRanges;
-(NSArray*) validRanges;

// add normal range
-(void) addNormalRange:(NSString*)name
                  info:(NSString*)info
                  type:(ANRangeType)type
                   min:(double)min
                   max:(double)max;
// add valid range
-(void) addValidRange:(NSString*)name
                 info:(NSString*)info
                 type:(ANRangeType)type
                  min:(double)min
                  max:(double)max;

-(void) addNormalRange:(ANRange*)range;
-(void) addValidRange:(ANRange*)range;
@end
