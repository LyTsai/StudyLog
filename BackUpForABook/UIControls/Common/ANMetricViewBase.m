//
//  ANMetricViewBase.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/27/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "ANMetricViewBase.h"

@implementation ANMetricViewBase

-(id)init
{
    self = [super init];
    
    _tipMsg = nil;
    _fillcolor = nil;
    _edgecolor = nil;

    return self;
}

// init with values
-(id)initWithValue:(NSString*)tipMsg
               min:(float)min
               max:(float)max
         fillColor:(UIColor*)fillColor
         edgeColor:(UIColor*)edgeColor
{
    self = [super init];
    
    _tipMsg = tipMsg;
    _min = min;
    _max = max;
    _fillcolor = fillColor;
    _edgecolor = edgeColor;
    return self;
}

@end
