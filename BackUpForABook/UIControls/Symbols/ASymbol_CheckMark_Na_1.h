//
//  ASymbol_CheckMark_Na_1.h
//  AProgressBars
//
//  Created by hui wang on 8/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "APathDrawWrap.h"
@interface ASymbol_CheckMark_Na_1 : APathDraw
{
    
}

// colors
@property(strong, nonatomic)UIColor* lineColor;
@property float lineWidth;

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp;

@end
