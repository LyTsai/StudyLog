//
//  Utils.h
//  ATreeLifeStyle
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#ifndef ATreeLifeStyle_Utils_h
#define ATreeLifeStyle_Utils_h

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "metrics.h"

#define DEGREES_TO_RADIANS(degree)  ((M_PI * degree) / 180)
#define _RGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// compute transform from fitting layer size (srcRect) into given rect size
// rect - target rect size
// srcRect - original size the graphics draws based on
CGAffineTransform getFitTransform(CGRect rect, CGRect srcRect);

// extended version
// rect - new rect area
// srcRect - orginal rect area
// bShiftToLeftTop - false for centered at center.  true for moving to left or top edge
CGAffineTransform getFitTransformEx(CGRect rect, CGRect srcRect, bool bShiftToLeftTop);

@interface Utils : NSObject

// convert int value to MetricClass enum
+(MetricClass) MetricClassOfNumber:(int) number;

// convert int value to RangeType enum
+(ANRangeType) RangeTypeOfNumber: (int) number;

// convert in value to UNIT enum
+(UNIT) UnitOfNumber: (int) number;


@end

#endif
