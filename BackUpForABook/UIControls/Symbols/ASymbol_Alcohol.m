//
//  ASymbol_Alcohol.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Alcohol.h"

@implementation ASymbol_Alcohol
{
    
}

@synthesize fillColor1, strokeColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.839 green: 0.447 blue: 0.451 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.62 green: 0.173 blue: 0.169 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    fillColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    strokeColor1 = [UIColor colorWithRed: 0.584 green: 0.769 blue: 0.239 alpha: 1];
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
    
    //// Group 3
    {
        //// Group 4
        {
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 100)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(49.98, 50), 0,
                                        CGPointMake(49.98, 50), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.15, 3.55, 92.3, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.33, -42.65),
                                        CGPointMake(50.33, 49.57),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(55.5, 31.6)];
        [bezierPath addCurveToPoint: CGPointMake(55.5, 30.5) controlPoint1: CGPointMake(55.5, 31.2) controlPoint2: CGPointMake(55.5, 30.9)];
        [bezierPath addCurveToPoint: CGPointMake(55.5, 20.4) controlPoint1: CGPointMake(55.5, 27.1) controlPoint2: CGPointMake(55.5, 23.8)];
        [bezierPath addCurveToPoint: CGPointMake(55.3, 18.5) controlPoint1: CGPointMake(55.5, 19.8) controlPoint2: CGPointMake(55.4, 19.2)];
        [bezierPath addCurveToPoint: CGPointMake(55.2, 15.8) controlPoint1: CGPointMake(55.2, 17.6) controlPoint2: CGPointMake(55.2, 16.7)];
        [bezierPath addCurveToPoint: CGPointMake(55.3, 15.6) controlPoint1: CGPointMake(55.2, 15.7) controlPoint2: CGPointMake(55.2, 15.6)];
        [bezierPath addCurveToPoint: CGPointMake(57.8, 14.3) controlPoint1: CGPointMake(56.1, 15.1) controlPoint2: CGPointMake(56.5, 14.2)];
        [bezierPath addCurveToPoint: CGPointMake(58.2, 14.3) controlPoint1: CGPointMake(57.9, 14.3) controlPoint2: CGPointMake(58.1, 14.3)];
        [bezierPath addCurveToPoint: CGPointMake(59.9, 14.4) controlPoint1: CGPointMake(58.8, 14.3) controlPoint2: CGPointMake(59.4, 14.3)];
        [bezierPath addCurveToPoint: CGPointMake(61.3, 15.4) controlPoint1: CGPointMake(60.4, 14.6) controlPoint2: CGPointMake(60.9, 15)];
        [bezierPath addCurveToPoint: CGPointMake(61.6, 16) controlPoint1: CGPointMake(61.5, 15.6) controlPoint2: CGPointMake(61.6, 15.8)];
        [bezierPath addCurveToPoint: CGPointMake(61.5, 18.7) controlPoint1: CGPointMake(61.6, 16.9) controlPoint2: CGPointMake(61.7, 17.8)];
        [bezierPath addCurveToPoint: CGPointMake(61.3, 20) controlPoint1: CGPointMake(61.4, 19.1) controlPoint2: CGPointMake(61.3, 19.5)];
        [bezierPath addCurveToPoint: CGPointMake(61.3, 31.2) controlPoint1: CGPointMake(61.3, 23.7) controlPoint2: CGPointMake(61.3, 27.5)];
        [bezierPath addCurveToPoint: CGPointMake(61.4, 31.6) controlPoint1: CGPointMake(61.3, 31.3) controlPoint2: CGPointMake(61.3, 31.4)];
        [bezierPath addCurveToPoint: CGPointMake(62.4, 32.2) controlPoint1: CGPointMake(61.7, 31.8) controlPoint2: CGPointMake(62, 32)];
        [bezierPath addCurveToPoint: CGPointMake(65.5, 34.4) controlPoint1: CGPointMake(63.5, 32.8) controlPoint2: CGPointMake(64.6, 33.6)];
        [bezierPath addCurveToPoint: CGPointMake(68, 39.9) controlPoint1: CGPointMake(67.2, 36) controlPoint2: CGPointMake(68, 37.7)];
        [bezierPath addCurveToPoint: CGPointMake(68, 78.5) controlPoint1: CGPointMake(68, 52.8) controlPoint2: CGPointMake(68, 65.6)];
        [bezierPath addCurveToPoint: CGPointMake(68, 83.8) controlPoint1: CGPointMake(68, 80.3) controlPoint2: CGPointMake(68, 82)];
        [bezierPath addCurveToPoint: CGPointMake(66.7, 85.2) controlPoint1: CGPointMake(68, 84.7) controlPoint2: CGPointMake(67.8, 85)];
        [bezierPath addCurveToPoint: CGPointMake(64.2, 85.6) controlPoint1: CGPointMake(65.9, 85.4) controlPoint2: CGPointMake(65, 85.5)];
        [bezierPath addCurveToPoint: CGPointMake(60.7, 85.7) controlPoint1: CGPointMake(63, 85.7) controlPoint2: CGPointMake(61.8, 85.7)];
        [bezierPath addCurveToPoint: CGPointMake(53.5, 85.7) controlPoint1: CGPointMake(58.3, 85.7) controlPoint2: CGPointMake(55.9, 85.7)];
        [bezierPath addCurveToPoint: CGPointMake(51.1, 85.4) controlPoint1: CGPointMake(52.7, 85.7) controlPoint2: CGPointMake(51.9, 85.6)];
        [bezierPath addCurveToPoint: CGPointMake(49.9, 85) controlPoint1: CGPointMake(50.7, 85.3) controlPoint2: CGPointMake(50.3, 85.2)];
        [bezierPath addCurveToPoint: CGPointMake(49.2, 84.1) controlPoint1: CGPointMake(49.4, 84.8) controlPoint2: CGPointMake(49.2, 84.5)];
        [bezierPath addCurveToPoint: CGPointMake(49.2, 83.4) controlPoint1: CGPointMake(49.2, 83.9) controlPoint2: CGPointMake(49.2, 83.6)];
        [bezierPath addCurveToPoint: CGPointMake(49.2, 39.8) controlPoint1: CGPointMake(49.2, 68.9) controlPoint2: CGPointMake(49.2, 54.4)];
        [bezierPath addCurveToPoint: CGPointMake(51.8, 34.2) controlPoint1: CGPointMake(49.2, 37.6) controlPoint2: CGPointMake(50.1, 35.8)];
        [bezierPath addCurveToPoint: CGPointMake(54.7, 32.1) controlPoint1: CGPointMake(52.7, 33.4) controlPoint2: CGPointMake(53.6, 32.7)];
        [bezierPath addCurveToPoint: CGPointMake(55.5, 31.6) controlPoint1: CGPointMake(54.8, 32) controlPoint2: CGPointMake(55.1, 31.8)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(66.6, 61.5)];
        [bezierPath addCurveToPoint: CGPointMake(66.6, 48.9) controlPoint1: CGPointMake(66.6, 57.3) controlPoint2: CGPointMake(66.6, 53.1)];
        [bezierPath addCurveToPoint: CGPointMake(66.6, 47.7) controlPoint1: CGPointMake(66.6, 48.5) controlPoint2: CGPointMake(66.6, 48.1)];
        [bezierPath addCurveToPoint: CGPointMake(64, 45.5) controlPoint1: CGPointMake(66.4, 46.5) controlPoint2: CGPointMake(65.4, 45.7)];
        [bezierPath addCurveToPoint: CGPointMake(62.9, 45.5) controlPoint1: CGPointMake(63.6, 45.5) controlPoint2: CGPointMake(63.2, 45.5)];
        [bezierPath addCurveToPoint: CGPointMake(53.8, 45.5) controlPoint1: CGPointMake(59.9, 45.5) controlPoint2: CGPointMake(56.9, 45.5)];
        [bezierPath addCurveToPoint: CGPointMake(52.8, 45.5) controlPoint1: CGPointMake(53.5, 45.5) controlPoint2: CGPointMake(53.1, 45.5)];
        [bezierPath addCurveToPoint: CGPointMake(50.1, 47.8) controlPoint1: CGPointMake(51.3, 45.6) controlPoint2: CGPointMake(50.2, 46.5)];
        [bezierPath addCurveToPoint: CGPointMake(50.1, 48.7) controlPoint1: CGPointMake(50.1, 48.1) controlPoint2: CGPointMake(50.1, 48.4)];
        [bezierPath addCurveToPoint: CGPointMake(50.1, 74.1) controlPoint1: CGPointMake(50.1, 57.2) controlPoint2: CGPointMake(50.1, 65.6)];
        [bezierPath addCurveToPoint: CGPointMake(50.1, 75) controlPoint1: CGPointMake(50.1, 74.4) controlPoint2: CGPointMake(50.1, 74.7)];
        [bezierPath addCurveToPoint: CGPointMake(52.8, 77.3) controlPoint1: CGPointMake(50.2, 76.3) controlPoint2: CGPointMake(51.3, 77.2)];
        [bezierPath addCurveToPoint: CGPointMake(53.8, 77.3) controlPoint1: CGPointMake(53.1, 77.3) controlPoint2: CGPointMake(53.5, 77.3)];
        [bezierPath addCurveToPoint: CGPointMake(62.9, 77.3) controlPoint1: CGPointMake(56.8, 77.3) controlPoint2: CGPointMake(59.8, 77.3)];
        [bezierPath addCurveToPoint: CGPointMake(63.9, 77.3) controlPoint1: CGPointMake(63.2, 77.3) controlPoint2: CGPointMake(63.6, 77.3)];
        [bezierPath addCurveToPoint: CGPointMake(66.6, 75) controlPoint1: CGPointMake(65.4, 77.2) controlPoint2: CGPointMake(66.5, 76.3)];
        [bezierPath addCurveToPoint: CGPointMake(66.6, 73.9) controlPoint1: CGPointMake(66.6, 74.6) controlPoint2: CGPointMake(66.6, 74.3)];
        [bezierPath addCurveToPoint: CGPointMake(66.6, 61.5) controlPoint1: CGPointMake(66.6, 69.9) controlPoint2: CGPointMake(66.6, 65.7)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        bezierPath.usesEvenOddFillRule = YES;
        
        [fillColor1 setFill];
        [bezierPath fill];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(33.4, 82.3)];
        [bezier2Path addCurveToPoint: CGPointMake(33.4, 69.8) controlPoint1: CGPointMake(33.6, 81.1) controlPoint2: CGPointMake(33.5, 70.7)];
        [bezier2Path addCurveToPoint: CGPointMake(32.5, 69.6) controlPoint1: CGPointMake(33.1, 69.8) controlPoint2: CGPointMake(32.8, 69.7)];
        [bezier2Path addCurveToPoint: CGPointMake(26.7, 65.8) controlPoint1: CGPointMake(29.8, 69.1) controlPoint2: CGPointMake(27.8, 67.9)];
        [bezier2Path addCurveToPoint: CGPointMake(25.5, 62.2) controlPoint1: CGPointMake(26.1, 64.7) controlPoint2: CGPointMake(25.7, 63.4)];
        [bezier2Path addCurveToPoint: CGPointMake(25.6, 56.5) controlPoint1: CGPointMake(25.2, 60.3) controlPoint2: CGPointMake(25.3, 58.4)];
        [bezier2Path addCurveToPoint: CGPointMake(26.8, 51) controlPoint1: CGPointMake(25.8, 54.7) controlPoint2: CGPointMake(26.3, 52.8)];
        [bezier2Path addCurveToPoint: CGPointMake(27.1, 50.3) controlPoint1: CGPointMake(26.9, 50.8) controlPoint2: CGPointMake(27, 50.6)];
        [bezier2Path addCurveToPoint: CGPointMake(30.9, 50.3) controlPoint1: CGPointMake(28.4, 50.2) controlPoint2: CGPointMake(29.6, 50.3)];
        [bezier2Path addCurveToPoint: CGPointMake(34.7, 50.3) controlPoint1: CGPointMake(32.2, 50.3) controlPoint2: CGPointMake(33.4, 50.3)];
        [bezier2Path addCurveToPoint: CGPointMake(38.4, 50.3) controlPoint1: CGPointMake(35.9, 50.3) controlPoint2: CGPointMake(37.2, 50.3)];
        [bezier2Path addCurveToPoint: CGPointMake(42.2, 50.3) controlPoint1: CGPointMake(39.7, 50.3) controlPoint2: CGPointMake(40.9, 50.3)];
        [bezier2Path addCurveToPoint: CGPointMake(42.5, 51) controlPoint1: CGPointMake(42.3, 50.6) controlPoint2: CGPointMake(42.5, 50.8)];
        [bezier2Path addCurveToPoint: CGPointMake(43.9, 61) controlPoint1: CGPointMake(43.5, 54.3) controlPoint2: CGPointMake(44.1, 57.6)];
        [bezier2Path addCurveToPoint: CGPointMake(43, 64.9) controlPoint1: CGPointMake(43.8, 62.3) controlPoint2: CGPointMake(43.6, 63.6)];
        [bezier2Path addCurveToPoint: CGPointMake(42.1, 66.6) controlPoint1: CGPointMake(42.8, 65.5) controlPoint2: CGPointMake(42.5, 66)];
        [bezier2Path addCurveToPoint: CGPointMake(37.3, 69.5) controlPoint1: CGPointMake(41, 68.1) controlPoint2: CGPointMake(39.4, 69.1)];
        [bezier2Path addCurveToPoint: CGPointMake(35.9, 69.8) controlPoint1: CGPointMake(36.8, 69.6) controlPoint2: CGPointMake(36.4, 69.7)];
        [bezier2Path addCurveToPoint: CGPointMake(35.8, 70.4) controlPoint1: CGPointMake(35.8, 70) controlPoint2: CGPointMake(35.8, 70.2)];
        [bezier2Path addCurveToPoint: CGPointMake(35.8, 81.8) controlPoint1: CGPointMake(35.8, 74.2) controlPoint2: CGPointMake(35.8, 78)];
        [bezier2Path addCurveToPoint: CGPointMake(35.9, 82.3) controlPoint1: CGPointMake(35.8, 81.9) controlPoint2: CGPointMake(35.8, 82.1)];
        [bezier2Path addCurveToPoint: CGPointMake(36.7, 82.4) controlPoint1: CGPointMake(36.2, 82.3) controlPoint2: CGPointMake(36.4, 82.4)];
        [bezier2Path addCurveToPoint: CGPointMake(40.3, 82.8) controlPoint1: CGPointMake(37.9, 82.5) controlPoint2: CGPointMake(39.1, 82.7)];
        [bezier2Path addCurveToPoint: CGPointMake(41.6, 83.3) controlPoint1: CGPointMake(40.7, 82.9) controlPoint2: CGPointMake(41.2, 83.1)];
        [bezier2Path addCurveToPoint: CGPointMake(41.6, 83.9) controlPoint1: CGPointMake(41.8, 83.4) controlPoint2: CGPointMake(41.8, 83.8)];
        [bezier2Path addCurveToPoint: CGPointMake(40.3, 84.4) controlPoint1: CGPointMake(41.2, 84.1) controlPoint2: CGPointMake(40.8, 84.3)];
        [bezier2Path addCurveToPoint: CGPointMake(37.4, 84.8) controlPoint1: CGPointMake(39.3, 84.6) controlPoint2: CGPointMake(38.4, 84.7)];
        [bezier2Path addCurveToPoint: CGPointMake(29.5, 84.5) controlPoint1: CGPointMake(34.8, 85) controlPoint2: CGPointMake(32.1, 85)];
        [bezier2Path addCurveToPoint: CGPointMake(28.2, 84.1) controlPoint1: CGPointMake(29, 84.4) controlPoint2: CGPointMake(28.6, 84.3)];
        [bezier2Path addCurveToPoint: CGPointMake(27.6, 83.7) controlPoint1: CGPointMake(28, 84) controlPoint2: CGPointMake(27.8, 83.8)];
        [bezier2Path addCurveToPoint: CGPointMake(28.4, 83) controlPoint1: CGPointMake(27.7, 83.3) controlPoint2: CGPointMake(28, 83.1)];
        [bezier2Path addCurveToPoint: CGPointMake(30.5, 82.6) controlPoint1: CGPointMake(29.1, 82.8) controlPoint2: CGPointMake(29.8, 82.7)];
        [bezier2Path addCurveToPoint: CGPointMake(33.4, 82.3) controlPoint1: CGPointMake(31.4, 82.5) controlPoint2: CGPointMake(32.4, 82.4)];
        [bezier2Path closePath];
        bezier2Path.usesEvenOddFillRule = YES;
        
        [fillColor1 setFill];
        [bezier2Path fill];
        [strokeColor1 setStroke];
        bezier2Path.lineWidth = 0.5;
        [bezier2Path stroke];
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
