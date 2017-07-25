//
//  APageLayerPath_Template.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "APageLayerPath_Template.h"

@implementation APageLayerPath_Template
{
    
}

@synthesize fillColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.839 green: 0.447 blue: 0.451 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.62 green: 0.173 blue: 0.169 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    fillColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)context
{
    // (1)
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// (2) Gradient Declarations
    CGFloat sVGID_1_Locations[] = {0, 0.8, 1};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor1.CGColor, (id)gradientColor2.CGColor, (id)gradientColor2.CGColor], sVGID_1_Locations);
    CGFloat sVGID_2_Locations[] = {0, 1};
    CGGradientRef sVGID_2_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor3.CGColor, (id)gradientColor4.CGColor], sVGID_2_Locations);
    
    
    // (3) - (4)
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    // begin drawing
    
    // end of drawing
    
    //// Cleanup
    // (2)
    CGGradientRelease(sVGID_1_);
    CGGradientRelease(sVGID_2_);
    
    // (1)
    CGColorSpaceRelease(colorSpace);
    
    // (3) - (4)
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
