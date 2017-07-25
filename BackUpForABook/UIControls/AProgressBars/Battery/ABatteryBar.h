//
//  ABatteryBar.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/12/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "APageLayerPath.h"
#import "AProgressIndicator.h"

@interface ABatteryBar : AProgressIndicator  

@property(strong, nonatomic)UIColor* color;
@property(strong, nonatomic)UIColor* indicatorColor;

@property double min;
@property double max;
@property(strong, nonatomic)NSString* unit;
@property(nonatomic) double value;

@end
