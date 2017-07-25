//
//  ASymbol_LifeStyle_Diet.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_LifeStyle_Diet.h"

@implementation ASymbol_LifeStyle_Diet

@synthesize fillColor1, fillColor2;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    fillColor1 = [UIColor colorWithRed: 0.349 green: 0.553 blue: 0.243 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];

}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)context
{
    // (3) - (4)
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    // begin drawing
    //// Group 3
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(19.03, 63.22)];
        [bezierPath addCurveToPoint: CGPointMake(32.04, 62.22) controlPoint1: CGPointMake(19.03, 63.22) controlPoint2: CGPointMake(26.37, 58.22)];
        [bezierPath addCurveToPoint: CGPointMake(35.7, 83.21) controlPoint1: CGPointMake(37.87, 66.22) controlPoint2: CGPointMake(38.87, 74.54)];
        [bezierPath addCurveToPoint: CGPointMake(27.7, 95.36) controlPoint1: CGPointMake(32.54, 91.87) controlPoint2: CGPointMake(31.04, 95.36)];
        [bezierPath addCurveToPoint: CGPointMake(18.2, 93.2) controlPoint1: CGPointMake(24.37, 95.36) controlPoint2: CGPointMake(21.7, 92.87)];
        [bezierPath addCurveToPoint: CGPointMake(10.69, 95.7) controlPoint1: CGPointMake(14.86, 93.37) controlPoint2: CGPointMake(13.53, 95.86)];
        [bezierPath addCurveToPoint: CGPointMake(0.02, 75.71) controlPoint1: CGPointMake(7.86, 95.53) controlPoint2: CGPointMake(-0.48, 85.37)];
        [bezierPath addCurveToPoint: CGPointMake(9.03, 60.89) controlPoint1: CGPointMake(0.52, 66.05) controlPoint2: CGPointMake(2.86, 60.39)];
        [bezierPath addCurveToPoint: CGPointMake(19.03, 63.22) controlPoint1: CGPointMake(15.2, 61.22) controlPoint2: CGPointMake(19.03, 63.22)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezierPath fill];
    }
    
    
    //// Group 4
    {
        //// Group 5
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(29.81, 55.54)];
            [bezier2Path addCurveToPoint: CGPointMake(22.75, 55.22) controlPoint1: CGPointMake(27.52, 55.06) controlPoint2: CGPointMake(25.05, 54.57)];
            [bezier2Path addCurveToPoint: CGPointMake(17.83, 61.52) controlPoint1: CGPointMake(19.8, 55.87) controlPoint2: CGPointMake(18.48, 58.94)];
            [bezier2Path addCurveToPoint: CGPointMake(19.8, 62.01) controlPoint1: CGPointMake(17.5, 62.82) controlPoint2: CGPointMake(19.47, 63.3)];
            [bezier2Path addCurveToPoint: CGPointMake(24.23, 56.84) controlPoint1: CGPointMake(20.45, 59.58) controlPoint2: CGPointMake(21.44, 57.16)];
            [bezier2Path addCurveToPoint: CGPointMake(29.16, 57.32) controlPoint1: CGPointMake(25.87, 56.67) controlPoint2: CGPointMake(27.68, 57)];
            [bezier2Path addCurveToPoint: CGPointMake(29.81, 55.54) controlPoint1: CGPointMake(30.64, 57.81) controlPoint2: CGPointMake(31.13, 55.87)];
            [bezier2Path addLineToPoint: CGPointMake(29.81, 55.54)];
            [bezier2Path closePath];
            bezier2Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier2Path fill];
        }
    }
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
    [bezier3Path moveToPoint: CGPointMake(19.17, 59)];
    [bezier3Path addCurveToPoint: CGPointMake(16.84, 54.35) controlPoint1: CGPointMake(19.17, 59) controlPoint2: CGPointMake(18.67, 55.68)];
    [bezier3Path addCurveToPoint: CGPointMake(12.01, 52.85) controlPoint1: CGPointMake(15.01, 53.02) controlPoint2: CGPointMake(12.01, 52.85)];
    [bezier3Path addCurveToPoint: CGPointMake(14.84, 58) controlPoint1: CGPointMake(12.01, 52.85) controlPoint2: CGPointMake(11.35, 56.01)];
    [bezier3Path addCurveToPoint: CGPointMake(19.17, 59) controlPoint1: CGPointMake(18.51, 60.16) controlPoint2: CGPointMake(19.17, 59)];
    [bezier3Path closePath];
    bezier3Path.miterLimit = 4;
    
    [fillColor1 setFill];
    [bezier3Path fill];
    
    
    //// Group 6
    {
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(57.36, -0)];
        [bezier4Path addCurveToPoint: CGPointMake(62.23, 6.53) controlPoint1: CGPointMake(57.36, -0) controlPoint2: CGPointMake(60.72, 5.53)];
        [bezier4Path addCurveToPoint: CGPointMake(56.86, 15.24) controlPoint1: CGPointMake(63.73, 7.54) controlPoint2: CGPointMake(56.86, 12.23)];
        [bezier4Path addCurveToPoint: CGPointMake(54.85, 30.65) controlPoint1: CGPointMake(56.86, 18.25) controlPoint2: CGPointMake(61.89, 21.77)];
        [bezier4Path addCurveToPoint: CGPointMake(21.16, 47.06) controlPoint1: CGPointMake(50.66, 36.01) controlPoint2: CGPointMake(38.76, 48.4)];
        [bezier4Path addCurveToPoint: CGPointMake(0.71, 34.83) controlPoint1: CGPointMake(3.56, 45.72) controlPoint2: CGPointMake(-0.63, 38.85)];
        [bezier4Path addCurveToPoint: CGPointMake(16.63, 34.33) controlPoint1: CGPointMake(2.21, 30.81) controlPoint2: CGPointMake(10.6, 35.17)];
        [bezier4Path addCurveToPoint: CGPointMake(39.26, 24.79) controlPoint1: CGPointMake(22.67, 33.49) controlPoint2: CGPointMake(33.56, 33.66)];
        [bezier4Path addCurveToPoint: CGPointMake(47.31, 13.57) controlPoint1: CGPointMake(45.13, 15.91) controlPoint2: CGPointMake(44.12, 14.74)];
        [bezier4Path addCurveToPoint: CGPointMake(52.34, 12.39) controlPoint1: CGPointMake(50.49, 12.39) controlPoint2: CGPointMake(50.16, 14.57)];
        [bezier4Path addCurveToPoint: CGPointMake(56.02, 6.53) controlPoint1: CGPointMake(54.51, 10.22) controlPoint2: CGPointMake(54.35, 10.89)];
        [bezier4Path addCurveToPoint: CGPointMake(57.36, -0) controlPoint1: CGPointMake(57.53, 3.18) controlPoint2: CGPointMake(57.36, -0)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier4Path fill];
    }
    
    
    //// Group 7
    {
        //// Group 8
        {
            //// Bezier 5 Drawing
            UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
            [bezier5Path moveToPoint: CGPointMake(78.33, 76.51)];
            [bezier5Path addCurveToPoint: CGPointMake(69.39, 86.79) controlPoint1: CGPointMake(75.35, 79.83) controlPoint2: CGPointMake(72.2, 83.14)];
            [bezier5Path addCurveToPoint: CGPointMake(62.74, 99.39) controlPoint1: CGPointMake(66.42, 90.6) controlPoint2: CGPointMake(64.66, 95.08)];
            [bezier5Path addCurveToPoint: CGPointMake(63.79, 98.89) controlPoint1: CGPointMake(63.09, 99.22) controlPoint2: CGPointMake(63.44, 99.06)];
            [bezier5Path addCurveToPoint: CGPointMake(52.05, 94.58) controlPoint1: CGPointMake(59.93, 97.4) controlPoint2: CGPointMake(55.9, 96.07)];
            [bezier5Path addCurveToPoint: CGPointMake(52.57, 95.74) controlPoint1: CGPointMake(52.22, 94.91) controlPoint2: CGPointMake(52.4, 95.41)];
            [bezier5Path addCurveToPoint: CGPointMake(54.32, 80.82) controlPoint1: CGPointMake(55.9, 91.26) controlPoint2: CGPointMake(55.2, 85.79)];
            [bezier5Path addCurveToPoint: CGPointMake(51.17, 65.73) controlPoint1: CGPointMake(53.45, 75.85) controlPoint2: CGPointMake(52.4, 70.71)];
            [bezier5Path addCurveToPoint: CGPointMake(49.42, 66.23) controlPoint1: CGPointMake(51, 64.74) controlPoint2: CGPointMake(49.24, 65.07)];
            [bezier5Path addCurveToPoint: CGPointMake(52.05, 78.5) controlPoint1: CGPointMake(50.29, 70.21) controlPoint2: CGPointMake(51.17, 74.35)];
            [bezier5Path addCurveToPoint: CGPointMake(51, 94.91) controlPoint1: CGPointMake(53.1, 83.8) controlPoint2: CGPointMake(54.68, 90.1)];
            [bezier5Path addCurveToPoint: CGPointMake(51.52, 96.07) controlPoint1: CGPointMake(50.64, 95.41) controlPoint2: CGPointMake(51, 95.91)];
            [bezier5Path addCurveToPoint: CGPointMake(63.26, 100.38) controlPoint1: CGPointMake(55.38, 97.56) controlPoint2: CGPointMake(59.41, 98.89)];
            [bezier5Path addCurveToPoint: CGPointMake(64.31, 99.89) controlPoint1: CGPointMake(63.79, 100.55) controlPoint2: CGPointMake(64.14, 100.22)];
            [bezier5Path addCurveToPoint: CGPointMake(70.8, 87.62) controlPoint1: CGPointMake(66.07, 95.74) controlPoint2: CGPointMake(67.99, 91.26)];
            [bezier5Path addCurveToPoint: CGPointMake(79.38, 77.67) controlPoint1: CGPointMake(73.42, 84.14) controlPoint2: CGPointMake(76.4, 80.82)];
            [bezier5Path addCurveToPoint: CGPointMake(78.33, 76.51) controlPoint1: CGPointMake(80.26, 77.01) controlPoint2: CGPointMake(79.03, 75.85)];
            [bezier5Path addLineToPoint: CGPointMake(78.33, 76.51)];
            [bezier5Path closePath];
            bezier5Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier5Path fill];
        }
    }
    
    
    //// Group 9
    {
        //// Group 10
        {
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(57.94, 76.15)];
            [bezier6Path addCurveToPoint: CGPointMake(59.52, 81.91) controlPoint1: CGPointMake(58.53, 78.13) controlPoint2: CGPointMake(58.93, 79.94)];
            [bezier6Path addCurveToPoint: CGPointMake(61.91, 81.42) controlPoint1: CGPointMake(59.92, 83.23) controlPoint2: CGPointMake(62.11, 82.57)];
            [bezier6Path addCurveToPoint: CGPointMake(60.32, 75.66) controlPoint1: CGPointMake(61.31, 79.44) controlPoint2: CGPointMake(60.91, 77.63)];
            [bezier6Path addCurveToPoint: CGPointMake(57.94, 76.15) controlPoint1: CGPointMake(59.92, 74.51) controlPoint2: CGPointMake(57.54, 75)];
            [bezier6Path addLineToPoint: CGPointMake(57.94, 76.15)];
            [bezier6Path closePath];
            bezier6Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier6Path fill];
        }
    }
    
    
    //// Group 11
    {
        //// Group 12
        {
            //// Bezier 7 Drawing
            UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
            [bezier7Path moveToPoint: CGPointMake(62.62, 86.11)];
            [bezier7Path addCurveToPoint: CGPointMake(60.45, 91.61) controlPoint1: CGPointMake(61.9, 87.94) controlPoint2: CGPointMake(61.18, 89.78)];
            [bezier7Path addCurveToPoint: CGPointMake(62.62, 92.11) controlPoint1: CGPointMake(59.91, 92.77) controlPoint2: CGPointMake(62.08, 93.44)];
            [bezier7Path addCurveToPoint: CGPointMake(64.79, 86.61) controlPoint1: CGPointMake(63.35, 90.27) controlPoint2: CGPointMake(64.07, 88.44)];
            [bezier7Path addCurveToPoint: CGPointMake(62.62, 86.11) controlPoint1: CGPointMake(65.16, 85.28) controlPoint2: CGPointMake(63.17, 84.78)];
            [bezier7Path addLineToPoint: CGPointMake(62.62, 86.11)];
            [bezier7Path closePath];
            bezier7Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier7Path fill];
        }
    }
    
    
    //// Group 13
    {
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(60.1, 71.72)];
        [bezier8Path addCurveToPoint: CGPointMake(67.71, 78.75) controlPoint1: CGPointMake(60.1, 71.72) controlPoint2: CGPointMake(61.76, 76.57)];
        [bezier8Path addCurveToPoint: CGPointMake(75.48, 77.24) controlPoint1: CGPointMake(73.66, 80.93) controlPoint2: CGPointMake(75.48, 77.24)];
        [bezier8Path addCurveToPoint: CGPointMake(87.05, 81.43) controlPoint1: CGPointMake(75.48, 77.24) controlPoint2: CGPointMake(81.26, 84.95)];
        [bezier8Path addCurveToPoint: CGPointMake(91.18, 73.89) controlPoint1: CGPointMake(92.84, 77.91) controlPoint2: CGPointMake(91.18, 73.89)];
        [bezier8Path addCurveToPoint: CGPointMake(100.11, 65.85) controlPoint1: CGPointMake(91.18, 73.89) controlPoint2: CGPointMake(100.11, 73.56)];
        [bezier8Path addCurveToPoint: CGPointMake(91.18, 56.31) controlPoint1: CGPointMake(99.95, 58.15) controlPoint2: CGPointMake(91.18, 56.31)];
        [bezier8Path addCurveToPoint: CGPointMake(85.56, 45.59) controlPoint1: CGPointMake(91.18, 56.31) controlPoint2: CGPointMake(91.52, 49.27)];
        [bezier8Path addCurveToPoint: CGPointMake(71.84, 44.08) controlPoint1: CGPointMake(79.61, 41.91) controlPoint2: CGPointMake(71.84, 44.08)];
        [bezier8Path addCurveToPoint: CGPointMake(53.82, 39.23) controlPoint1: CGPointMake(71.84, 44.08) controlPoint2: CGPointMake(63.57, 33.87)];
        [bezier8Path addCurveToPoint: CGPointMake(46.05, 54.13) controlPoint1: CGPointMake(44.06, 44.59) controlPoint2: CGPointMake(46.05, 54.13)];
        [bezier8Path addCurveToPoint: CGPointMake(46.21, 71.21) controlPoint1: CGPointMake(46.05, 54.13) controlPoint2: CGPointMake(36.62, 64.18)];
        [bezier8Path addCurveToPoint: CGPointMake(60.1, 71.72) controlPoint1: CGPointMake(55.8, 78.25) controlPoint2: CGPointMake(60.1, 71.72)];
        [bezier8Path closePath];
        bezier8Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier8Path fill];
    }
    
    
    //// Bezier 9 Drawing
    UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
    [bezier9Path moveToPoint: CGPointMake(22.01, 80.27)];
    [bezier9Path addCurveToPoint: CGPointMake(22.67, 75.29) controlPoint1: CGPointMake(22.01, 80.27) controlPoint2: CGPointMake(20.67, 76.62)];
    [bezier9Path addCurveToPoint: CGPointMake(25.34, 76.45) controlPoint1: CGPointMake(24.67, 73.96) controlPoint2: CGPointMake(25.17, 75.45)];
    [bezier9Path addCurveToPoint: CGPointMake(22.01, 80.27) controlPoint1: CGPointMake(25.34, 77.28) controlPoint2: CGPointMake(22.01, 80.27)];
    [bezier9Path closePath];
    bezier9Path.miterLimit = 4;
    
    [fillColor2 setFill];
    [bezier9Path fill];
    
    
    //// Bezier 10 Drawing
    UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
    [bezier10Path moveToPoint: CGPointMake(17.34, 80.94)];
    [bezier10Path addCurveToPoint: CGPointMake(16.68, 75.95) controlPoint1: CGPointMake(17.34, 80.94) controlPoint2: CGPointMake(18.67, 77.28)];
    [bezier10Path addCurveToPoint: CGPointMake(14.01, 77.11) controlPoint1: CGPointMake(14.68, 74.62) controlPoint2: CGPointMake(14.18, 76.12)];
    [bezier10Path addCurveToPoint: CGPointMake(17.34, 80.94) controlPoint1: CGPointMake(14.01, 77.95) controlPoint2: CGPointMake(17.34, 80.94)];
    [bezier10Path closePath];
    bezier10Path.miterLimit = 4;
    
    [fillColor2 setFill];
    [bezier10Path fill];
    
    // end of drawing
    
    // (3) - (4)
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
