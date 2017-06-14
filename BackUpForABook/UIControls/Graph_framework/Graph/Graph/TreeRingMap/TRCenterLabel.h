//
//  TRCenterLabel.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/27/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANText.h"

@interface TRCenterLabel : NSObject

// properties
@property(strong, nonatomic)ANText* metricInfo;
@property(strong, nonatomic)ANText* metricValue;
@property(strong, nonatomic)ANText* title;
@property(strong, nonatomic)UIColor* bkgColorHi;
@property(strong, nonatomic)UIColor* bkgColorLo;

// test method
-(void)fillTestData;

// paint
-(void)paint:(CGContextRef)ctx
      radius:(float)radius
      origin:(CGPoint)origin;

@end
