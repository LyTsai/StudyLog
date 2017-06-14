//
//  ANMetricViewProjector.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/9/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricView.h"

// View projector that projects metric into GUI view
@interface ANMetricViewProjector : NSObject

// properties

// metric
@property(strong, nonatomic)ANMetric* metric;
// array of mapped value range to ANMetricView
@property(strong, nonatomic)NSMutableArray* views;

// methods
-(id)initWithMetric:(ANMetric*) metric;

// add one view for metric key
-(void)addMetricView:(NSString*)key
                view:(ANMetricView*)view;

// methods
// map given metric value to the view
// map metric value to ANMetricView.  return nil if no mapping information for the value
-(ANMetricView*)viewOf:(double)value;

@end
