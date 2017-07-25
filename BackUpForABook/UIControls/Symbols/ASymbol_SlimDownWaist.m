//
//  ASymbol_SlimDownWaist.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_SlimDownWaist.h"

@implementation ASymbol_SlimDownWaist

@synthesize fillColor1, strokeColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.49 green: 0.773 blue: 0.451 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.176 green: 0.616 blue: 0.282 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.176 green: 0.62 blue: 0.282 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor5 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    strokeColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    fillColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)context
{
    // (1)
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// (2) Gradient Declarations
    CGFloat sVGID_1_Locations[] = {0, 0.8, 1};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor1.CGColor, (id)gradientColor2.CGColor, (id)gradientColor3.CGColor], sVGID_1_Locations);
    CGFloat sVGID_2_Locations[] = {0, 1};
    CGGradientRef sVGID_2_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor4.CGColor, (id)gradientColor5.CGColor], sVGID_2_Locations);

    
    
    // (3) - (4)
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    // begin drawing
    //// Group 2
    {
        //// Group 3
        {
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 100)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(49.96, 50), 0,
                                        CGPointMake(49.96, 50), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 4
    {
        //// Group 5
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.2, 3.5, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.31, -42.66),
                                        CGPointMake(50.31, 49.56),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 6
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(70.8, 34.9)];
        [bezierPath addCurveToPoint: CGPointMake(55, 25.8) controlPoint1: CGPointMake(66.8, 29.2) controlPoint2: CGPointMake(61.8, 26.6)];
        [bezierPath addCurveToPoint: CGPointMake(49.7, 25) controlPoint1: CGPointMake(53.3, 25.3) controlPoint2: CGPointMake(51.5, 25)];
        [bezierPath addCurveToPoint: CGPointMake(44, 25.9) controlPoint1: CGPointMake(47.7, 25) controlPoint2: CGPointMake(45.8, 25.3)];
        [bezierPath addCurveToPoint: CGPointMake(28.9, 34.9) controlPoint1: CGPointMake(37.6, 26.9) controlPoint2: CGPointMake(32.8, 29.5)];
        [bezierPath addCurveToPoint: CGPointMake(25.3, 50.1) controlPoint1: CGPointMake(23.9, 41.9) controlPoint2: CGPointMake(22.4, 48.9)];
        [bezierPath addCurveToPoint: CGPointMake(28.5, 50.5) controlPoint1: CGPointMake(25.8, 50.3) controlPoint2: CGPointMake(26.9, 50.4)];
        [bezierPath addCurveToPoint: CGPointMake(49.9, 69.3) controlPoint1: CGPointMake(28.6, 64.5) controlPoint2: CGPointMake(38.2, 69.3)];
        [bezierPath addCurveToPoint: CGPointMake(71, 50.5) controlPoint1: CGPointMake(61.6, 69.3) controlPoint2: CGPointMake(71, 64.5)];
        [bezierPath addCurveToPoint: CGPointMake(74.4, 50.1) controlPoint1: CGPointMake(72.6, 50.4) controlPoint2: CGPointMake(73.8, 50.3)];
        [bezierPath addCurveToPoint: CGPointMake(70.8, 34.9) controlPoint1: CGPointMake(77.1, 48.9) controlPoint2: CGPointMake(75.7, 42)];
        [bezierPath closePath];
        [strokeColor1 setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(40.1, 14.5, 17.6, 17.6)];
        [fillColor1 setFill];
        [oval3Path fill];
        [strokeColor1 setStroke];
        oval3Path.lineWidth = 0.6;
        [oval3Path stroke];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(48.9, 69.3)];
        [bezier2Path addCurveToPoint: CGPointMake(45.1, 78.3) controlPoint1: CGPointMake(48.9, 69.3) controlPoint2: CGPointMake(50.8, 77.6)];
        [bezier2Path addCurveToPoint: CGPointMake(38.6, 67.3) controlPoint1: CGPointMake(39.4, 79) controlPoint2: CGPointMake(38.7, 68)];
        [bezier2Path addCurveToPoint: CGPointMake(48.9, 69.3) controlPoint1: CGPointMake(38.6, 67.3) controlPoint2: CGPointMake(43.9, 69.3)];
        [bezier2Path closePath];
        [strokeColor1 setStroke];
        bezier2Path.lineWidth = 1;
        [bezier2Path stroke];
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(51.1, 69.3)];
        [bezier3Path addCurveToPoint: CGPointMake(54.9, 78.3) controlPoint1: CGPointMake(51.1, 69.3) controlPoint2: CGPointMake(49.2, 77.6)];
        [bezier3Path addCurveToPoint: CGPointMake(61.4, 67.3) controlPoint1: CGPointMake(60.6, 79) controlPoint2: CGPointMake(61.3, 68)];
        [bezier3Path addCurveToPoint: CGPointMake(51.1, 69.3) controlPoint1: CGPointMake(61.5, 67.3) controlPoint2: CGPointMake(56.2, 69.2)];
        [bezier3Path closePath];
        [strokeColor1 setStroke];
        bezier3Path.lineWidth = 1;
        [bezier3Path stroke];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(33.3, 37.7)];
        [bezier4Path addCurveToPoint: CGPointMake(29.5, 49.7) controlPoint1: CGPointMake(33.3, 37.7) controlPoint2: CGPointMake(29.5, 45.1)];
        [bezier4Path addLineToPoint: CGPointMake(27.4, 49.5)];
        [bezier4Path addCurveToPoint: CGPointMake(33.3, 37.7) controlPoint1: CGPointMake(27.4, 49.5) controlPoint2: CGPointMake(27.7, 43.7)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier4Path fill];
        
        
        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
        [bezier5Path moveToPoint: CGPointMake(66.1, 37.7)];
        [bezier5Path addCurveToPoint: CGPointMake(69.9, 49.7) controlPoint1: CGPointMake(66.1, 37.7) controlPoint2: CGPointMake(69.9, 45.1)];
        [bezier5Path addLineToPoint: CGPointMake(72, 49.5)];
        [bezier5Path addCurveToPoint: CGPointMake(66.1, 37.7) controlPoint1: CGPointMake(72, 49.5) controlPoint2: CGPointMake(71.7, 43.8)];
        [bezier5Path closePath];
        bezier5Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier5Path fill];
    }
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
