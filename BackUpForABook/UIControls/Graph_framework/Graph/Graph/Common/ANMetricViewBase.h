//
//  ANMetricViewBase.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/27/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// minimal metric view information
@interface ANMetricViewBase : NSObject

// properties

// metric range for this view
@property(nonatomic)double min;
@property(nonatomic)double max;
// view properties
// tip message
@property(strong, nonatomic)NSString* tipMsg;
// path fill color
@property(strong, nonatomic)UIColor* fillcolor;
// path stroke color
@property(strong, nonatomic)UIColor* edgecolor;

// init with values
-(id)initWithValue:(NSString*)tipMsg
               min:(float)min
               max:(float)max
         fillColor:(UIColor*)fillColor
         edgeColor:(UIColor*)edgeColor;

@end
