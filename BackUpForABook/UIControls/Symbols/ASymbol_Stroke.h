//
//  ASymbol_Stroke.h
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "APathDrawWrap.h"

@interface ASymbol_Stroke : APathDraw
{
    
}

// colors
@property(strong, nonatomic)UIColor* fillColor;
@property(strong, nonatomic)UIColor* fillColor2;

// methods

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp;

@end
