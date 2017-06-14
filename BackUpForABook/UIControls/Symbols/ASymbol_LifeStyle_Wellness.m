//
//  ASymbol_LifeStyle_Wellness.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_LifeStyle_Wellness.h"

@implementation ASymbol_LifeStyle_Wellness


@synthesize fillColor1, fillColor2, fillColor3;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    fillColor1 = [UIColor colorWithRed: 0.231 green: 0.275 blue: 0.325 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    fillColor3 = [UIColor colorWithRed: 0.608 green: 0.796 blue: 0.235 alpha: 1];}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)context
{
    // (3) - (4)
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    // begin drawing
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(85.85, 72.5)];
    [bezierPath addLineToPoint: CGPointMake(81.02, 79.07)];
    [bezierPath addLineToPoint: CGPointMake(78.52, 74.14)];
    [bezierPath addLineToPoint: CGPointMake(75.69, 79.07)];
    [bezierPath addLineToPoint: CGPointMake(71.36, 72.5)];
    [bezierPath addCurveToPoint: CGPointMake(58.05, 87.61) controlPoint1: CGPointMake(63.54, 74.63) controlPoint2: CGPointMake(58.05, 80.55)];
    [bezierPath addLineToPoint: CGPointMake(58.05, 92.55)];
    [bezierPath addLineToPoint: CGPointMake(99.17, 92.55)];
    [bezierPath addLineToPoint: CGPointMake(99.17, 87.61)];
    [bezierPath addCurveToPoint: CGPointMake(85.85, 72.5) controlPoint1: CGPointMake(99.17, 80.55) controlPoint2: CGPointMake(93.67, 74.63)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [fillColor1 setFill];
    [bezierPath fill];
    
    
    //// Group 3
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(6.87, 47.91, 23.6, 18.8)];
        [fillColor1 setFill];
        [ovalPath fill];
    }
    
    
    //// Group 4
    {
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(65.77, 51.11, 24.6, 19.8)];
        [fillColor1 setFill];
        [oval2Path fill];
    }
    
    
    //// Group 5
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(35.47, 82.08)];
        [bezier2Path addCurveToPoint: CGPointMake(18.57, 68.81) controlPoint1: CGPointMake(35.47, 74.8) controlPoint2: CGPointMake(27.94, 68.81)];
        [bezier2Path addLineToPoint: CGPointMake(17.56, 68.81)];
        [bezier2Path addCurveToPoint: CGPointMake(0.67, 82.08) controlPoint1: CGPointMake(8.19, 68.81) controlPoint2: CGPointMake(0.67, 74.8)];
        [bezier2Path addLineToPoint: CGPointMake(0.67, 97.61)];
        [bezier2Path addLineToPoint: CGPointMake(35.47, 97.61)];
        [bezier2Path addLineToPoint: CGPointMake(35.47, 82.08)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier2Path fill];
    }
    
    
    //// Group 6
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(43.27, 96.41, 56.9, 3.2)];
        [fillColor1 setFill];
        [rectanglePath fill];
    }
    
    
    //// Group 7
    {
        //// Group 8
        {
            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
            [bezier3Path moveToPoint: CGPointMake(57.56, 13.32)];
            [bezier3Path addCurveToPoint: CGPointMake(7.77, 5.11) controlPoint1: CGPointMake(52.56, -3.76) controlPoint2: CGPointMake(18.93, -1.95)];
            [bezier3Path addCurveToPoint: CGPointMake(3.94, 24.64) controlPoint1: CGPointMake(0.44, 9.71) controlPoint2: CGPointMake(-3.39, 18.08)];
            [bezier3Path addCurveToPoint: CGPointMake(18.93, 31.37) controlPoint1: CGPointMake(7.94, 28.26) controlPoint2: CGPointMake(13.6, 30.06)];
            [bezier3Path addCurveToPoint: CGPointMake(24.76, 40.24) controlPoint1: CGPointMake(24.42, 32.69) controlPoint2: CGPointMake(25.75, 32.52)];
            [bezier3Path addCurveToPoint: CGPointMake(25.59, 40.9) controlPoint1: CGPointMake(24.76, 40.73) controlPoint2: CGPointMake(25.25, 41.06)];
            [bezier3Path addCurveToPoint: CGPointMake(34.58, 29.9) controlPoint1: CGPointMake(31.08, 39.09) controlPoint2: CGPointMake(32.75, 34.82)];
            [bezier3Path addCurveToPoint: CGPointMake(33.25, 29.57) controlPoint1: CGPointMake(34.91, 29.08) controlPoint2: CGPointMake(33.58, 28.75)];
            [bezier3Path addCurveToPoint: CGPointMake(30.92, 34.49) controlPoint1: CGPointMake(32.58, 31.21) controlPoint2: CGPointMake(31.92, 32.85)];
            [bezier3Path addCurveToPoint: CGPointMake(26.25, 39.25) controlPoint1: CGPointMake(30.08, 35.64) controlPoint2: CGPointMake(28.42, 39.25)];
            [bezier3Path addCurveToPoint: CGPointMake(26.42, 37.61) controlPoint1: CGPointMake(24.59, 39.25) controlPoint2: CGPointMake(26.59, 39.42)];
            [bezier3Path addCurveToPoint: CGPointMake(24.42, 31.54) controlPoint1: CGPointMake(26.25, 35.31) controlPoint2: CGPointMake(26.75, 33.02)];
            [bezier3Path addCurveToPoint: CGPointMake(18.43, 30.23) controlPoint1: CGPointMake(23.09, 30.55) controlPoint2: CGPointMake(20.09, 30.72)];
            [bezier3Path addCurveToPoint: CGPointMake(1.11, 18.08) controlPoint1: CGPointMake(12.27, 28.58) controlPoint2: CGPointMake(2.11, 25.3)];
            [bezier3Path addCurveToPoint: CGPointMake(56.23, 13.65) controlPoint1: CGPointMake(-1.56, -2.77) controlPoint2: CGPointMake(50.9, -4.9)];
            [bezier3Path addCurveToPoint: CGPointMake(57.56, 13.32) controlPoint1: CGPointMake(56.39, 14.47) controlPoint2: CGPointMake(57.73, 14.14)];
            [bezier3Path addLineToPoint: CGPointMake(57.56, 13.32)];
            [bezier3Path closePath];
            bezier3Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier3Path fill];
        }
    }
    
    
    //// Group 9
    {
        //// Group 10
        {
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(69.94, 84.35)];
            [bezier4Path addCurveToPoint: CGPointMake(69.31, 72.82) controlPoint1: CGPointMake(67.73, 81.26) controlPoint2: CGPointMake(67.73, 76.23)];
            [bezier4Path addCurveToPoint: CGPointMake(68.52, 72.33) controlPoint1: CGPointMake(69.62, 72.17) controlPoint2: CGPointMake(68.68, 71.68)];
            [bezier4Path addCurveToPoint: CGPointMake(69.15, 84.83) controlPoint1: CGPointMake(66.78, 76.07) controlPoint2: CGPointMake(66.78, 81.42)];
            [bezier4Path addCurveToPoint: CGPointMake(69.94, 84.35) controlPoint1: CGPointMake(69.47, 85.32) controlPoint2: CGPointMake(70.26, 84.83)];
            [bezier4Path addLineToPoint: CGPointMake(69.94, 84.35)];
            [bezier4Path closePath];
            bezier4Path.miterLimit = 4;
            
            [fillColor2 setFill];
            [bezier4Path fill];
        }
    }
    
    
    //// Oval 3 Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 70.53, 86.3);
    CGContextRotateCTM(context, 1.35 * M_PI / 180);
    
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-3, -2.3, 5.99, 4.6)];
    [fillColor2 setFill];
    [oval3Path fill];
    
    CGContextRestoreGState(context);
    
    
    //// Group 11
    {
        //// Group 12
        {
            //// Bezier 5 Drawing
            UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
            [bezier5Path moveToPoint: CGPointMake(82.57, 86.95)];
            [bezier5Path addCurveToPoint: CGPointMake(81.78, 82.35) controlPoint1: CGPointMake(79.56, 88.14) controlPoint2: CGPointMake(81.15, 83.37)];
            [bezier5Path addCurveToPoint: CGPointMake(86.7, 77.93) controlPoint1: CGPointMake(82.73, 80.65) controlPoint2: CGPointMake(84.64, 78.1)];
            [bezier5Path addCurveToPoint: CGPointMake(89.56, 84.06) controlPoint1: CGPointMake(89.24, 77.93) controlPoint2: CGPointMake(89.56, 82.18)];
            [bezier5Path addCurveToPoint: CGPointMake(86.7, 87.8) controlPoint1: CGPointMake(89.56, 85.93) controlPoint2: CGPointMake(89.24, 88.65)];
            [bezier5Path addCurveToPoint: CGPointMake(86.39, 88.82) controlPoint1: CGPointMake(86.07, 87.63) controlPoint2: CGPointMake(85.91, 88.65)];
            [bezier5Path addCurveToPoint: CGPointMake(90.36, 84.57) controlPoint1: CGPointMake(89.4, 89.84) controlPoint2: CGPointMake(90.2, 87.29)];
            [bezier5Path addCurveToPoint: CGPointMake(86.54, 76.91) controlPoint1: CGPointMake(90.52, 82.01) controlPoint2: CGPointMake(90.04, 76.91)];
            [bezier5Path addCurveToPoint: CGPointMake(79.87, 83.37) controlPoint1: CGPointMake(83.69, 76.91) controlPoint2: CGPointMake(80.99, 80.82)];
            [bezier5Path addCurveToPoint: CGPointMake(82.57, 87.97) controlPoint1: CGPointMake(79.08, 85.42) controlPoint2: CGPointMake(79.87, 88.99)];
            [bezier5Path addCurveToPoint: CGPointMake(82.57, 86.95) controlPoint1: CGPointMake(83.37, 87.8) controlPoint2: CGPointMake(83.21, 86.78)];
            [bezier5Path addLineToPoint: CGPointMake(82.57, 86.95)];
            [bezier5Path closePath];
            bezier5Path.miterLimit = 4;
            
            [fillColor2 setFill];
            [bezier5Path fill];
        }
    }
    
    
    //// Group 13
    {
        //// Group 14
        {
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(87.57, 72.54)];
            [bezier6Path addCurveToPoint: CGPointMake(87.27, 76.8) controlPoint1: CGPointMake(87.77, 73.8) controlPoint2: CGPointMake(87.57, 75.54)];
            [bezier6Path addCurveToPoint: CGPointMake(87.87, 77.11) controlPoint1: CGPointMake(87.17, 77.43) controlPoint2: CGPointMake(87.77, 77.58)];
            [bezier6Path addCurveToPoint: CGPointMake(88.17, 72.38) controlPoint1: CGPointMake(88.17, 75.69) controlPoint2: CGPointMake(88.47, 73.8)];
            [bezier6Path addCurveToPoint: CGPointMake(87.57, 72.54) controlPoint1: CGPointMake(88.07, 71.59) controlPoint2: CGPointMake(87.47, 71.91)];
            [bezier6Path addLineToPoint: CGPointMake(87.57, 72.54)];
            [bezier6Path closePath];
            bezier6Path.miterLimit = 4;
            
            [fillColor2 setFill];
            [bezier6Path fill];
        }
    }
    
    
    //// Group 15
    {
        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
        [bezier7Path moveToPoint: CGPointMake(59.68, 61.31)];
        [bezier7Path addCurveToPoint: CGPointMake(59.51, 53.72) controlPoint1: CGPointMake(59.68, 61.31) controlPoint2: CGPointMake(58.67, 55.21)];
        [bezier7Path addCurveToPoint: CGPointMake(61.53, 51.41) controlPoint1: CGPointMake(60.35, 52.24) controlPoint2: CGPointMake(61.53, 51.41)];
        [bezier7Path addCurveToPoint: CGPointMake(79.91, 45.97) controlPoint1: CGPointMake(61.53, 51.41) controlPoint2: CGPointMake(74.51, 51.08)];
        [bezier7Path addCurveToPoint: CGPointMake(64.9, 21.06) controlPoint1: CGPointMake(86.65, 39.87) controlPoint2: CGPointMake(89.85, 24.69)];
        [bezier7Path addCurveToPoint: CGPointMake(40.29, 42.84) controlPoint1: CGPointMake(40.12, 17.76) controlPoint2: CGPointMake(34.05, 37.23)];
        [bezier7Path addCurveToPoint: CGPointMake(52.09, 49.93) controlPoint1: CGPointMake(46.53, 48.61) controlPoint2: CGPointMake(52.09, 49.93)];
        [bezier7Path addCurveToPoint: CGPointMake(53.61, 55.87) controlPoint1: CGPointMake(52.09, 49.93) controlPoint2: CGPointMake(51.42, 53.06)];
        [bezier7Path addCurveToPoint: CGPointMake(59.68, 61.31) controlPoint1: CGPointMake(55.8, 58.84) controlPoint2: CGPointMake(59.68, 61.31)];
        [bezier7Path closePath];
        bezier7Path.miterLimit = 4;
        
        [fillColor3 setFill];
        [bezier7Path fill];
    }
    // end of drawing
    
    // (3) - (4)
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
