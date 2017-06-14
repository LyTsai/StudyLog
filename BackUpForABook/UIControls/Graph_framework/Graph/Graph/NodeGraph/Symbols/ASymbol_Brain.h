//
//  ASymbol_Brain.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "APathDrawWrap.h"

@interface ASymbol_Brain : APathDraw

// colors
@property(strong, nonatomic)UIColor* fillColor;
@property(strong, nonatomic)UIColor* fillColor2;

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp;

@end
