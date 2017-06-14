//
//  ASymbol_Exercise.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Exercise.h"

@implementation ASymbol_Exercise

@synthesize fillColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5;

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
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 100)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(50.01, 49.99), 0,
                                        CGPointMake(50.01, 49.99), 50,
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
                                        CGPointMake(50.36, -42.66),
                                        CGPointMake(50.36, 49.56),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Group 8
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(48.7, 80.2)];
            [bezierPath addLineToPoint: CGPointMake(78.2, 80.1)];
            [bezierPath addCurveToPoint: CGPointMake(75.1, 77.7) controlPoint1: CGPointMake(78.2, 80.1) controlPoint2: CGPointMake(76.4, 78.9)];
            [bezierPath addCurveToPoint: CGPointMake(72.2, 74.9) controlPoint1: CGPointMake(73.8, 76.5) controlPoint2: CGPointMake(72.2, 74.9)];
            [bezierPath addCurveToPoint: CGPointMake(70.4, 76.5) controlPoint1: CGPointMake(72.2, 74.9) controlPoint2: CGPointMake(71.4, 76.5)];
            [bezierPath addCurveToPoint: CGPointMake(67.1, 73.4) controlPoint1: CGPointMake(69.4, 76.5) controlPoint2: CGPointMake(68.2, 73)];
            [bezierPath addCurveToPoint: CGPointMake(64.3, 76.3) controlPoint1: CGPointMake(66, 73.8) controlPoint2: CGPointMake(65, 76.2)];
            [bezierPath addCurveToPoint: CGPointMake(61.1, 73.1) controlPoint1: CGPointMake(63.5, 76.4) controlPoint2: CGPointMake(62.1, 72.9)];
            [bezierPath addCurveToPoint: CGPointMake(57.9, 76.1) controlPoint1: CGPointMake(60.2, 73.3) controlPoint2: CGPointMake(59.1, 76)];
            [bezierPath addCurveToPoint: CGPointMake(54.7, 73.1) controlPoint1: CGPointMake(56.7, 76.2) controlPoint2: CGPointMake(55.8, 72.9)];
            [bezierPath addCurveToPoint: CGPointMake(51.7, 75.9) controlPoint1: CGPointMake(53.7, 73.3) controlPoint2: CGPointMake(52.7, 75.9)];
            bezierPath.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezierPath fill];
        }
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(36.9, 20.3, 11.2, 11.2)];
        [fillColor1 setFill];
        [oval3Path fill];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(32.7, 42.3)];
        [bezier2Path addCurveToPoint: CGPointMake(29.7, 40.9) controlPoint1: CGPointMake(31.5, 42.7) controlPoint2: CGPointMake(30.1, 42.1)];
        [bezier2Path addLineToPoint: CGPointMake(29.7, 40.9)];
        [bezier2Path addCurveToPoint: CGPointMake(31.2, 37.9) controlPoint1: CGPointMake(29.3, 39.7) controlPoint2: CGPointMake(29.9, 38.3)];
        [bezier2Path addLineToPoint: CGPointMake(40.9, 34.3)];
        [bezier2Path addCurveToPoint: CGPointMake(45.8, 35.3) controlPoint1: CGPointMake(42.1, 33.9) controlPoint2: CGPointMake(45.3, 34.1)];
        [bezier2Path addLineToPoint: CGPointMake(45.8, 35.3)];
        [bezier2Path addCurveToPoint: CGPointMake(44.3, 38.3) controlPoint1: CGPointMake(46.2, 36.5) controlPoint2: CGPointMake(45.6, 37.9)];
        [bezier2Path addLineToPoint: CGPointMake(32.7, 42.3)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier2Path fill];
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(36.5, 47.1)];
        [bezier3Path addCurveToPoint: CGPointMake(35, 50.1) controlPoint1: CGPointMake(36.9, 48.3) controlPoint2: CGPointMake(36.2, 49.7)];
        [bezier3Path addLineToPoint: CGPointMake(35, 50.1)];
        [bezier3Path addCurveToPoint: CGPointMake(32, 48.6) controlPoint1: CGPointMake(33.8, 50.5) controlPoint2: CGPointMake(32.4, 49.8)];
        [bezier3Path addLineToPoint: CGPointMake(29.6, 40.9)];
        [bezier3Path addCurveToPoint: CGPointMake(31.1, 37.9) controlPoint1: CGPointMake(29.2, 39.7) controlPoint2: CGPointMake(29.9, 38.3)];
        [bezier3Path addLineToPoint: CGPointMake(31.1, 37.9)];
        [bezier3Path addCurveToPoint: CGPointMake(34.1, 39.4) controlPoint1: CGPointMake(32.3, 37.5) controlPoint2: CGPointMake(33.7, 38.2)];
        [bezier3Path addLineToPoint: CGPointMake(36.5, 47.1)];
        [bezier3Path closePath];
        bezier3Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier3Path fill];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(57.2, 39)];
        [bezier4Path addCurveToPoint: CGPointMake(58.3, 42.2) controlPoint1: CGPointMake(58.4, 39.6) controlPoint2: CGPointMake(58.9, 41)];
        [bezier4Path addLineToPoint: CGPointMake(58.3, 42.2)];
        [bezier4Path addCurveToPoint: CGPointMake(55.1, 43.4) controlPoint1: CGPointMake(57.7, 43.4) controlPoint2: CGPointMake(56.3, 43.9)];
        [bezier4Path addLineToPoint: CGPointMake(44.1, 38.3)];
        [bezier4Path addCurveToPoint: CGPointMake(43, 35.1) controlPoint1: CGPointMake(42.9, 37.7) controlPoint2: CGPointMake(42.4, 36.3)];
        [bezier4Path addLineToPoint: CGPointMake(43, 35.1)];
        [bezier4Path addCurveToPoint: CGPointMake(46.2, 33.9) controlPoint1: CGPointMake(43.6, 33.9) controlPoint2: CGPointMake(45, 33.4)];
        [bezier4Path addLineToPoint: CGPointMake(57.2, 39)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier4Path fill];
        
        
        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
        [bezier5Path moveToPoint: CGPointMake(53.7, 33.7)];
        [bezier5Path addCurveToPoint: CGPointMake(55.7, 31) controlPoint1: CGPointMake(53.5, 32.4) controlPoint2: CGPointMake(54.4, 31.2)];
        [bezier5Path addLineToPoint: CGPointMake(55.7, 31)];
        [bezier5Path addCurveToPoint: CGPointMake(58.4, 33) controlPoint1: CGPointMake(57, 30.8) controlPoint2: CGPointMake(58.2, 31.7)];
        [bezier5Path addLineToPoint: CGPointMake(59.3, 41)];
        [bezier5Path addCurveToPoint: CGPointMake(57.3, 43.7) controlPoint1: CGPointMake(59.5, 42.3) controlPoint2: CGPointMake(58.6, 43.5)];
        [bezier5Path addLineToPoint: CGPointMake(57.3, 43.7)];
        [bezier5Path addCurveToPoint: CGPointMake(54.6, 41.7) controlPoint1: CGPointMake(56, 43.9) controlPoint2: CGPointMake(54.8, 43)];
        [bezier5Path addLineToPoint: CGPointMake(53.7, 33.7)];
        [bezier5Path closePath];
        bezier5Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier5Path fill];
        
        
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
        [bezier6Path moveToPoint: CGPointMake(44.1, 33.6)];
        [bezier6Path addCurveToPoint: CGPointMake(49.3, 39.4) controlPoint1: CGPointMake(47.8, 33.5) controlPoint2: CGPointMake(49.3, 36.3)];
        [bezier6Path addLineToPoint: CGPointMake(48.9, 51.2)];
        [bezier6Path addCurveToPoint: CGPointMake(43.9, 56.3) controlPoint1: CGPointMake(48.9, 53.9) controlPoint2: CGPointMake(46.3, 56.3)];
        [bezier6Path addLineToPoint: CGPointMake(43.9, 56.3)];
        [bezier6Path addCurveToPoint: CGPointMake(38.6, 53.2) controlPoint1: CGPointMake(41.5, 56.3) controlPoint2: CGPointMake(38.9, 58.2)];
        [bezier6Path addLineToPoint: CGPointMake(38.2, 39)];
        [bezier6Path addCurveToPoint: CGPointMake(39, 35.2) controlPoint1: CGPointMake(38.2, 36) controlPoint2: CGPointMake(36.3, 37.8)];
        [bezier6Path addCurveToPoint: CGPointMake(44.1, 33.6) controlPoint1: CGPointMake(39, 35.1) controlPoint2: CGPointMake(40.8, 33.7)];
        [bezier6Path closePath];
        bezier6Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier6Path fill];
        
        
        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
        [bezier7Path moveToPoint: CGPointMake(33.8, 75.8)];
        [bezier7Path addCurveToPoint: CGPointMake(31.8, 77.7) controlPoint1: CGPointMake(32.7, 75.8) controlPoint2: CGPointMake(31.8, 76.6)];
        [bezier7Path addLineToPoint: CGPointMake(31.8, 77.7)];
        [bezier7Path addCurveToPoint: CGPointMake(33.7, 79.7) controlPoint1: CGPointMake(31.8, 78.8) controlPoint2: CGPointMake(32.6, 79.7)];
        [bezier7Path addLineToPoint: CGPointMake(40.2, 79.7)];
        [bezier7Path addCurveToPoint: CGPointMake(42.2, 77.8) controlPoint1: CGPointMake(41.3, 79.7) controlPoint2: CGPointMake(42.2, 78.9)];
        [bezier7Path addLineToPoint: CGPointMake(42.2, 77.8)];
        [bezier7Path addCurveToPoint: CGPointMake(40.3, 75.8) controlPoint1: CGPointMake(42.2, 76.7) controlPoint2: CGPointMake(41.4, 75.8)];
        [bezier7Path addLineToPoint: CGPointMake(33.8, 75.8)];
        [bezier7Path closePath];
        bezier7Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier7Path fill];
        
        
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(38.5, 49.3)];
        [bezier8Path addCurveToPoint: CGPointMake(38.1, 54.3) controlPoint1: CGPointMake(38.5, 50.9) controlPoint2: CGPointMake(37.7, 52.4)];
        [bezier8Path addCurveToPoint: CGPointMake(40, 57.4) controlPoint1: CGPointMake(38.5, 55.7) controlPoint2: CGPointMake(39.6, 57.1)];
        [bezier8Path addLineToPoint: CGPointMake(30.5, 75.4)];
        [bezier8Path addCurveToPoint: CGPointMake(32.4, 79.3) controlPoint1: CGPointMake(29.9, 76.8) controlPoint2: CGPointMake(30.8, 78.6)];
        [bezier8Path addCurveToPoint: CGPointMake(36.5, 78) controlPoint1: CGPointMake(34.1, 80) controlPoint2: CGPointMake(35.9, 79.4)];
        [bezier8Path addLineToPoint: CGPointMake(44.3, 63.5)];
        [bezier8Path addLineToPoint: CGPointMake(54.7, 78.3)];
        [bezier8Path addCurveToPoint: CGPointMake(57.2, 79.4) controlPoint1: CGPointMake(55.2, 79.2) controlPoint2: CGPointMake(56.1, 79.6)];
        [bezier8Path addCurveToPoint: CGPointMake(58.8, 78.8) controlPoint1: CGPointMake(57.8, 79.5) controlPoint2: CGPointMake(58.4, 79.3)];
        [bezier8Path addLineToPoint: CGPointMake(59, 78.6)];
        [bezier8Path addCurveToPoint: CGPointMake(59.7, 77.9) controlPoint1: CGPointMake(59.3, 78.4) controlPoint2: CGPointMake(59.5, 78.1)];
        [bezier8Path addLineToPoint: CGPointMake(63.3, 74.1)];
        [bezier8Path addCurveToPoint: CGPointMake(63.3, 71.4) controlPoint1: CGPointMake(64.1, 73.3) controlPoint2: CGPointMake(64, 72.1)];
        [bezier8Path addCurveToPoint: CGPointMake(60.6, 71.4) controlPoint1: CGPointMake(62.5, 70.6) controlPoint2: CGPointMake(61.3, 70.7)];
        [bezier8Path addLineToPoint: CGPointMake(59.1, 73)];
        [bezier8Path addLineToPoint: CGPointMake(47.6, 56.8)];
        [bezier8Path addLineToPoint: CGPointMake(48.2, 54.7)];
        [bezier8Path addCurveToPoint: CGPointMake(48.7, 52.3) controlPoint1: CGPointMake(48.5, 53.7) controlPoint2: CGPointMake(48.6, 53.2)];
        [bezier8Path addLineToPoint: CGPointMake(48.7, 52.3)];
        bezier8Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier8Path fill];
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
