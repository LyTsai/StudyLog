//
//  ANMeasurement.h
//  ANBookPad
//
//  Created by hui wang on 9/1/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANClassification.h"

@interface ANMeasurement : NSObject

@property(strong, nonatomic)NSString* metricKey;
@property double value;
@property(strong, nonatomic)NSString* note;
@property(strong, nonatomic)NSString* info;
@property(strong, nonatomic)NSDate* date;
@property(strong, nonatomic)ANClassification* classification;
// array of ANClassification
@property(strong, nonatomic)NSMutableArray* assessments;


@end
