//
//  ASymbol_Mediate.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Mediate.h"

@implementation ASymbol_Mediate

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
    //// Group 3
    {
        //// Group 4
        {
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 99.9)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(50.02, 50), 0,
                                        CGPointMake(50.02, 50), 50,
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
                                        CGPointMake(50.37, -42.65),
                                        CGPointMake(50.37, 49.57),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(41.5, 23.95, 14.2, 14.2)];
        [fillColor1 setFill];
        [oval3Path fill];
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(71.3, 56.65)];
        [bezierPath addLineToPoint: CGPointMake(63.1, 53.95)];
        [bezierPath addLineToPoint: CGPointMake(54.9, 41.25)];
        [bezierPath addCurveToPoint: CGPointMake(54, 42.25) controlPoint1: CGPointMake(54.7, 40.95) controlPoint2: CGPointMake(54.3, 42.45)];
        [bezierPath addCurveToPoint: CGPointMake(48.5, 40.15) controlPoint1: CGPointMake(52.5, 40.95) controlPoint2: CGPointMake(50.6, 40.15)];
        [bezierPath addCurveToPoint: CGPointMake(42.9, 42.35) controlPoint1: CGPointMake(46.3, 40.15) controlPoint2: CGPointMake(44.4, 40.95)];
        [bezierPath addCurveToPoint: CGPointMake(43, 42.05) controlPoint1: CGPointMake(42.7, 42.45) controlPoint2: CGPointMake(43.2, 41.85)];
        [bezierPath addLineToPoint: CGPointMake(42.7, 42.35)];
        [bezierPath addCurveToPoint: CGPointMake(42.6, 41.05) controlPoint1: CGPointMake(42.6, 42.55) controlPoint2: CGPointMake(42.7, 40.85)];
        [bezierPath addLineToPoint: CGPointMake(34, 53.95)];
        [bezierPath addLineToPoint: CGPointMake(25.9, 56.65)];
        [bezierPath addCurveToPoint: CGPointMake(24.5, 60.15) controlPoint1: CGPointMake(24.6, 57.05) controlPoint2: CGPointMake(24, 58.65)];
        [bezierPath addCurveToPoint: CGPointMake(27.8, 61.95) controlPoint1: CGPointMake(25, 61.65) controlPoint2: CGPointMake(26.5, 62.45)];
        [bezierPath addLineToPoint: CGPointMake(37.2, 58.85)];
        [bezierPath addCurveToPoint: CGPointMake(38.6, 57.35) controlPoint1: CGPointMake(37.9, 58.65) controlPoint2: CGPointMake(38.4, 58.05)];
        [bezierPath addLineToPoint: CGPointMake(40.4, 54.95)];
        [bezierPath addLineToPoint: CGPointMake(41.6, 62.45)];
        [bezierPath addLineToPoint: CGPointMake(32.1, 70.75)];
        [bezierPath addCurveToPoint: CGPointMake(30.3, 75.05) controlPoint1: CGPointMake(32.1, 70.75) controlPoint2: CGPointMake(29.8, 72.95)];
        [bezierPath addCurveToPoint: CGPointMake(33.7, 78.45) controlPoint1: CGPointMake(30.8, 77.15) controlPoint2: CGPointMake(33.7, 78.45)];
        [bezierPath addLineToPoint: CGPointMake(40.1, 78.45)];
        [bezierPath addCurveToPoint: CGPointMake(39, 74.65) controlPoint1: CGPointMake(40.1, 78.45) controlPoint2: CGPointMake(38.7, 76.95)];
        [bezierPath addCurveToPoint: CGPointMake(41.3, 71.55) controlPoint1: CGPointMake(39.3, 72.35) controlPoint2: CGPointMake(40.7, 71.75)];
        [bezierPath addCurveToPoint: CGPointMake(43.2, 71.25) controlPoint1: CGPointMake(42.1, 71.25) controlPoint2: CGPointMake(43.2, 71.25)];
        [bezierPath addLineToPoint: CGPointMake(57.4, 71.25)];
        [bezierPath addCurveToPoint: CGPointMake(58.2, 72.15) controlPoint1: CGPointMake(57.4, 71.25) controlPoint2: CGPointMake(58.2, 71.25)];
        [bezierPath addCurveToPoint: CGPointMake(57.5, 72.75) controlPoint1: CGPointMake(58.2, 72.85) controlPoint2: CGPointMake(57.5, 72.75)];
        [bezierPath addLineToPoint: CGPointMake(43.6, 72.75)];
        [bezierPath addCurveToPoint: CGPointMake(41.1, 75.55) controlPoint1: CGPointMake(42.2, 72.75) controlPoint2: CGPointMake(41.1, 74.05)];
        [bezierPath addCurveToPoint: CGPointMake(43.6, 78.35) controlPoint1: CGPointMake(41.1, 77.05) controlPoint2: CGPointMake(42.2, 78.35)];
        [bezierPath addLineToPoint: CGPointMake(65.1, 78.35)];
        [bezierPath addCurveToPoint: CGPointMake(65.5, 78.35) controlPoint1: CGPointMake(65.2, 78.35) controlPoint2: CGPointMake(65.4, 78.35)];
        [bezierPath addCurveToPoint: CGPointMake(66.5, 78.05) controlPoint1: CGPointMake(65.9, 78.35) controlPoint2: CGPointMake(66.2, 78.25)];
        [bezierPath addCurveToPoint: CGPointMake(67.3, 77.45) controlPoint1: CGPointMake(66.8, 77.95) controlPoint2: CGPointMake(67, 77.75)];
        [bezierPath addCurveToPoint: CGPointMake(67.5, 73.75) controlPoint1: CGPointMake(68.4, 76.35) controlPoint2: CGPointMake(68.5, 74.65)];
        [bezierPath addLineToPoint: CGPointMake(55.8, 62.25)];
        [bezierPath addLineToPoint: CGPointMake(56.7, 54.85)];
        [bezierPath addLineToPoint: CGPointMake(58.6, 57.35)];
        [bezierPath addCurveToPoint: CGPointMake(60, 58.85) controlPoint1: CGPointMake(58.8, 58.05) controlPoint2: CGPointMake(59.3, 58.55)];
        [bezierPath addLineToPoint: CGPointMake(69.4, 61.95)];
        [bezierPath addCurveToPoint: CGPointMake(72.7, 60.15) controlPoint1: CGPointMake(70.7, 62.35) controlPoint2: CGPointMake(72.2, 61.55)];
        [bezierPath addCurveToPoint: CGPointMake(71.3, 56.65) controlPoint1: CGPointMake(73.2, 58.65) controlPoint2: CGPointMake(72.6, 57.05)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezierPath fill];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(55.2, 42.05)];
        [bezier2Path addCurveToPoint: CGPointMake(48.6, 39.95) controlPoint1: CGPointMake(55.2, 40.55) controlPoint2: CGPointMake(52.1, 40.05)];
        [bezier2Path addCurveToPoint: CGPointMake(42.2, 42.05) controlPoint1: CGPointMake(45.2, 39.85) controlPoint2: CGPointMake(42.2, 40.55)];
        [bezier2Path addLineToPoint: CGPointMake(42.2, 58.25)];
        [bezier2Path addCurveToPoint: CGPointMake(44.9, 60.95) controlPoint1: CGPointMake(42.2, 59.75) controlPoint2: CGPointMake(43.4, 60.95)];
        [bezier2Path addLineToPoint: CGPointMake(52.5, 60.95)];
        [bezier2Path addCurveToPoint: CGPointMake(55.2, 58.25) controlPoint1: CGPointMake(54, 60.95) controlPoint2: CGPointMake(55.2, 59.75)];
        [bezier2Path addLineToPoint: CGPointMake(55.2, 42.05)];
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
