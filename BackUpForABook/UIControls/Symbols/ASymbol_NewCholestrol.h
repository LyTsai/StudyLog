//
//  ASymbol_NewCholestrol.h
//  AProgressBars
//
//  Created by hui wang on 7/13/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "APathDrawWrap.h"

@interface ASymbol_NewCholestrol : APathDraw
{
    
}

// properties

// Color Declarations
@property(strong, nonatomic)UIColor* fillColor;
@property(strong, nonatomic)UIColor* fillColor2;
@property(strong, nonatomic)UIColor* textForeground;

// methods
// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp;

@end
