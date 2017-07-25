//
//  ASymbol_Heart1.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "APathDrawWrap.h"

@interface ASymbol_Heart1 : APathDraw

// colors
@property(strong, nonatomic)UIColor* fillColor;
@property(strong, nonatomic)UIColor* fillColor2;
@property(strong, nonatomic)UIColor* fillColor3;
@property(strong, nonatomic)UIColor* fillColor4;
@property(strong, nonatomic)UIColor* fillColor5;
@property(strong, nonatomic)UIColor* fillColor6;
@property(strong, nonatomic)UIColor* fillColor7;

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp;

@end
