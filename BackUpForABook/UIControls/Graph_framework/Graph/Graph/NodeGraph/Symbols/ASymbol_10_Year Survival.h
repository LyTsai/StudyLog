//
//  ASymbol_10_Year Survival.h
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "APathDrawWrap.h"

@interface ASymbol_10_Year_Survival : APathDraw
{
    
}

// colors
@property(strong, nonatomic)UIColor* fillColor31;
@property(strong, nonatomic)UIColor* fillColor6;
@property(strong, nonatomic)UIColor* fillColor32;

// methods

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp;

@end
