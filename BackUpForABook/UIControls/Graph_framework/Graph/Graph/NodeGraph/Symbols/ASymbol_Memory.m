//
//  ASymbol_Memory.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Memory.h"

@implementation ASymbol_Memory

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
    //// Group 3
    {
        //// Group 4
        {
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 99.8)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(50.05, 49.96), 0,
                                        CGPointMake(50.05, 49.96), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.3, 3.5, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.41, -42.7),
                                        CGPointMake(50.41, 49.53),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(48.9, 74)];
        [bezierPath addLineToPoint: CGPointMake(45.3, 66.6)];
        [bezierPath addCurveToPoint: CGPointMake(33.9, 68.9) controlPoint1: CGPointMake(45.3, 66.6) controlPoint2: CGPointMake(35.9, 70.8)];
        [bezierPath addCurveToPoint: CGPointMake(31.5, 64.2) controlPoint1: CGPointMake(31.8, 67) controlPoint2: CGPointMake(31.5, 64.2)];
        [bezierPath addCurveToPoint: CGPointMake(28.2, 61.1) controlPoint1: CGPointMake(31.5, 64.2) controlPoint2: CGPointMake(28.7, 61.5)];
        [bezierPath addCurveToPoint: CGPointMake(30, 58.6) controlPoint1: CGPointMake(27.7, 60.7) controlPoint2: CGPointMake(29.6, 58.5)];
        [bezierPath addCurveToPoint: CGPointMake(27.1, 57.7) controlPoint1: CGPointMake(30.4, 58.6) controlPoint2: CGPointMake(27.2, 58.4)];
        [bezierPath addCurveToPoint: CGPointMake(28.4, 54.2) controlPoint1: CGPointMake(27, 57) controlPoint2: CGPointMake(28.9, 54.4)];
        [bezierPath addCurveToPoint: CGPointMake(23.7, 51.2) controlPoint1: CGPointMake(27.9, 53.9) controlPoint2: CGPointMake(23, 52.3)];
        [bezierPath addCurveToPoint: CGPointMake(29.6, 42.3) controlPoint1: CGPointMake(24.3, 50.1) controlPoint2: CGPointMake(29.7, 44.5)];
        [bezierPath addCurveToPoint: CGPointMake(32, 26.3) controlPoint1: CGPointMake(29.5, 40.1) controlPoint2: CGPointMake(26.2, 31.3)];
        [bezierPath addCurveToPoint: CGPointMake(64.3, 22.6) controlPoint1: CGPointMake(37.9, 21.2) controlPoint2: CGPointMake(48.8, 13.9)];
        [bezierPath addCurveToPoint: CGPointMake(64.8, 60.9) controlPoint1: CGPointMake(84.4, 33.9) controlPoint2: CGPointMake(64.8, 60.9)];
        [bezierPath addCurveToPoint: CGPointMake(70.7, 73.3) controlPoint1: CGPointMake(64.8, 60.9) controlPoint2: CGPointMake(67.9, 72.2)];
        [strokeColor1 setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(70, 37)];
        [bezier2Path addCurveToPoint: CGPointMake(68.9, 35.2) controlPoint1: CGPointMake(69.9, 36.3) controlPoint2: CGPointMake(69.5, 35.7)];
        [bezier2Path addCurveToPoint: CGPointMake(68.4, 31.5) controlPoint1: CGPointMake(68.9, 34.8) controlPoint2: CGPointMake(69, 33.5)];
        [bezier2Path addCurveToPoint: CGPointMake(64.4, 28.2) controlPoint1: CGPointMake(67.8, 29.5) controlPoint2: CGPointMake(65.1, 28.5)];
        [bezier2Path addLineToPoint: CGPointMake(63.6, 27.4)];
        [bezier2Path addCurveToPoint: CGPointMake(63.1, 26.4) controlPoint1: CGPointMake(63.5, 27) controlPoint2: CGPointMake(63.3, 26.7)];
        [bezier2Path addCurveToPoint: CGPointMake(57.1, 23.6) controlPoint1: CGPointMake(62.3, 25.3) controlPoint2: CGPointMake(60.4, 24.1)];
        [bezier2Path addCurveToPoint: CGPointMake(54.8, 23.7) controlPoint1: CGPointMake(56.2, 23.5) controlPoint2: CGPointMake(55.5, 23.5)];
        [bezier2Path addLineToPoint: CGPointMake(54.5, 23.6)];
        [bezier2Path addCurveToPoint: CGPointMake(53.1, 22.7) controlPoint1: CGPointMake(54.3, 23.4) controlPoint2: CGPointMake(53.8, 22.9)];
        [bezier2Path addCurveToPoint: CGPointMake(47.5, 22.2) controlPoint1: CGPointMake(52.2, 22.4) controlPoint2: CGPointMake(51.5, 21.8)];
        [bezier2Path addCurveToPoint: CGPointMake(43.8, 23.9) controlPoint1: CGPointMake(45.4, 22.4) controlPoint2: CGPointMake(44.3, 23.2)];
        [bezier2Path addLineToPoint: CGPointMake(43.6, 23.9)];
        [bezier2Path addCurveToPoint: CGPointMake(40.4, 24.3) controlPoint1: CGPointMake(43.3, 23.9) controlPoint2: CGPointMake(41.9, 24)];
        [bezier2Path addCurveToPoint: CGPointMake(34.4, 30.1) controlPoint1: CGPointMake(38.8, 24.7) controlPoint2: CGPointMake(35.7, 26.6)];
        [bezier2Path addCurveToPoint: CGPointMake(36.5, 36.1) controlPoint1: CGPointMake(32.7, 34.8) controlPoint2: CGPointMake(36.8, 36.3)];
        [bezier2Path addLineToPoint: CGPointMake(36.5, 36.1)];
        [bezier2Path addCurveToPoint: CGPointMake(37.6, 38.1) controlPoint1: CGPointMake(36.7, 36.6) controlPoint2: CGPointMake(37, 37.3)];
        [bezier2Path addCurveToPoint: CGPointMake(42.1, 39.5) controlPoint1: CGPointMake(38.7, 39.6) controlPoint2: CGPointMake(40.6, 39.8)];
        [bezier2Path addLineToPoint: CGPointMake(42.9, 39.9)];
        [bezier2Path addLineToPoint: CGPointMake(42.5, 39.8)];
        [bezier2Path addCurveToPoint: CGPointMake(46.5, 42.4) controlPoint1: CGPointMake(42.5, 39.8) controlPoint2: CGPointMake(43.6, 40.9)];
        [bezier2Path addCurveToPoint: CGPointMake(51.6, 43.1) controlPoint1: CGPointMake(48.6, 43.5) controlPoint2: CGPointMake(50.7, 43.3)];
        [bezier2Path addLineToPoint: CGPointMake(52, 43.3)];
        [bezier2Path addCurveToPoint: CGPointMake(59.4, 46.4) controlPoint1: CGPointMake(52.5, 43.8) controlPoint2: CGPointMake(54.9, 45.9)];
        [bezier2Path addCurveToPoint: CGPointMake(69.6, 42.1) controlPoint1: CGPointMake(62.8, 46.7) controlPoint2: CGPointMake(66.5, 48.7)];
        [bezier2Path addCurveToPoint: CGPointMake(70, 37) controlPoint1: CGPointMake(70.4, 40.7) controlPoint2: CGPointMake(70.4, 39.2)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier2Path fill];
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
