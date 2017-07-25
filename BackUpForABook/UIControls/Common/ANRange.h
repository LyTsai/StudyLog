//
//  ANRange.h
//  ANBookPad
//
//  Created by hui wang on 8/28/16.
//  Copyright © 2016 MH.dingf. All rights reserved.
//

#include "metrics.h"
#import <Foundation/Foundation.h>

// !!! not needed anymore.  remove later
// define class for use of metric ranges.  range objects are used for definning normal, valid ranges of metric
@interface ANRange : NSObject

// properties:

// name, info as in core data entitiy
@property(strong, nonatomic)NSString* name;
@property(strong, nonatomic)NSString* info;

// min, max, type as in core data entity

// valid range (if valid_type != RangeType_NA)

@property(nonatomic)ANRangeType valid_type;
@property(nonatomic)double valid_min;
@property(nonatomic)double valid_max;

@end
