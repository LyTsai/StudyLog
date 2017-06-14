//
//  ANVLMetric.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/7/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>

// metrics attached with visual and analytics information
@interface ANVLMetric : NSObject;

// metric value
@property double value; 
// metric key for accessing metric information.  all system defualt metric keys are defined in metrics.h
@property(strong, nonatomic)NSString* metricKey;

-(id)initWith:(NSString*)key
        value:(double)value;

@end
