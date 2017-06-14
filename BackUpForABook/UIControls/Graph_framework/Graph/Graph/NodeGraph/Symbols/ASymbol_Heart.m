//
//  ASymbol_Heart.m
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Heart.h"

@interface ASymbol_Heart (PrivateMethods)

// draw path 1
-(void) drawPath1;

// draw path 2
-(void) drawPath2;

@end


@implementation ASymbol_Heart

@synthesize fillColor, fillColor2, drawoption;


-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(100, 100);
    
    fillColor = [UIColor colorWithRed: 0.231 green: 0.275 blue: 0.325 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 0.729 green: 0.125 blue: 0.192 alpha: 1];
    drawoption = 1;
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_Heart* draw = [[ASymbol_Heart alloc] init];
    [draw initDrawPros];
    
    APathDrawWrap* warp = [[APathDrawWrap alloc] initWith:CGRectMake(0, 0, draw.pathRefSize.x, draw.pathRefSize.y) pathDraw:draw];
    
    return warp;
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)ctx
{
    // save context
    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    if (drawoption == 1)
    {
        [self drawPath1];
    }else
    {
        [self drawPath2];
    }
    
    /*
    // test drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    CGContextSetLineWidth(ctx, 2.0);
    
    [rectanglePath fill];
    //[rectanglePath stroke];
    */
    
    UIGraphicsPopContext(); 
    CGContextRestoreGState(ctx);
}

// draw heart 1 image
-(void) drawPath1
{
    //// 图层_2
    {
        //// Group 3
        {
            //// Group 4
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = UIBezierPath.bezierPath;
                [bezierPath moveToPoint: CGPointMake(9.34, 34.93)];
                [bezierPath addCurveToPoint: CGPointMake(0.63, 46.36) controlPoint1: CGPointMake(5.59, 38.1) controlPoint2: CGPointMake(1.97, 42.09)];
                [bezierPath addCurveToPoint: CGPointMake(3.22, 54.16) controlPoint1: CGPointMake(-0.14, 48.82) controlPoint2: CGPointMake(0.07, 52.76)];
                [bezierPath addCurveToPoint: CGPointMake(8.74, 53.22) controlPoint1: CGPointMake(5.06, 54.99) controlPoint2: CGPointMake(7.32, 54.28)];
                [bezierPath addCurveToPoint: CGPointMake(6.88, 50.66) controlPoint1: CGPointMake(10.16, 52.16) controlPoint2: CGPointMake(8.68, 50.29)];
                [bezierPath addCurveToPoint: CGPointMake(3.23, 54.13) controlPoint1: CGPointMake(4.93, 51.07) controlPoint2: CGPointMake(3.76, 52.72)];
                [bezierPath addCurveToPoint: CGPointMake(2.94, 59.46) controlPoint1: CGPointMake(2.59, 55.84) controlPoint2: CGPointMake(2.68, 57.71)];
                [bezierPath addCurveToPoint: CGPointMake(5.53, 67.56) controlPoint1: CGPointMake(3.35, 62.23) controlPoint2: CGPointMake(4.23, 64.96)];
                [bezierPath addCurveToPoint: CGPointMake(15.59, 79.58) controlPoint1: CGPointMake(7.8, 72.09) controlPoint2: CGPointMake(11.37, 76.06)];
                [bezierPath addCurveToPoint: CGPointMake(27.19, 88.39) controlPoint1: CGPointMake(19.28, 82.65) controlPoint2: CGPointMake(23.4, 85.4)];
                [bezierPath addCurveToPoint: CGPointMake(42.42, 98.44) controlPoint1: CGPointMake(31.82, 92.03) controlPoint2: CGPointMake(36.53, 96.09)];
                [bezierPath addCurveToPoint: CGPointMake(49.73, 99.71) controlPoint1: CGPointMake(44.69, 99.35) controlPoint2: CGPointMake(47.19, 99.9)];
                [bezierPath addCurveToPoint: CGPointMake(56.08, 98.38) controlPoint1: CGPointMake(51.93, 99.54) controlPoint2: CGPointMake(54.05, 99.04)];
                [bezierPath addCurveToPoint: CGPointMake(69.52, 91.03) controlPoint1: CGPointMake(61.15, 96.73) controlPoint2: CGPointMake(65.77, 94.19)];
                [bezierPath addCurveToPoint: CGPointMake(74.41, 85.53) controlPoint1: CGPointMake(71.46, 89.39) controlPoint2: CGPointMake(73.14, 87.54)];
                [bezierPath addCurveToPoint: CGPointMake(76.81, 78.39) controlPoint1: CGPointMake(75.84, 83.26) controlPoint2: CGPointMake(76.44, 80.9)];
                [bezierPath addCurveToPoint: CGPointMake(75.38, 60.5) controlPoint1: CGPointMake(77.68, 72.55) controlPoint2: CGPointMake(77.25, 66.21)];
                [bezierPath addCurveToPoint: CGPointMake(74.89, 61.97) controlPoint1: CGPointMake(75.22, 60.99) controlPoint2: CGPointMake(75.06, 61.48)];
                [bezierPath addCurveToPoint: CGPointMake(81.46, 53.43) controlPoint1: CGPointMake(78.04, 59.84) controlPoint2: CGPointMake(80.78, 56.69)];
                [bezierPath addCurveToPoint: CGPointMake(80.17, 45.84) controlPoint1: CGPointMake(81.98, 50.93) controlPoint2: CGPointMake(81.21, 48.2)];
                [bezierPath addCurveToPoint: CGPointMake(78.26, 42.62) controlPoint1: CGPointMake(79.69, 44.74) controlPoint2: CGPointMake(79.1, 43.58)];
                [bezierPath addCurveToPoint: CGPointMake(74.95, 44.17) controlPoint1: CGPointMake(76.87, 41.01) controlPoint2: CGPointMake(73.53, 42.54)];
                [bezierPath addCurveToPoint: CGPointMake(76.35, 46.4) controlPoint1: CGPointMake(75.54, 44.85) controlPoint2: CGPointMake(75.98, 45.63)];
                [bezierPath addCurveToPoint: CGPointMake(77.69, 52.89) controlPoint1: CGPointMake(77.29, 48.36) controlPoint2: CGPointMake(78.13, 50.79)];
                [bezierPath addCurveToPoint: CGPointMake(72.16, 59.82) controlPoint1: CGPointMake(77.13, 55.57) controlPoint2: CGPointMake(74.72, 58.08)];
                [bezierPath addCurveToPoint: CGPointMake(71.67, 61.29) controlPoint1: CGPointMake(71.65, 60.16) controlPoint2: CGPointMake(71.51, 60.8)];
                [bezierPath addCurveToPoint: CGPointMake(73.27, 70.68) controlPoint1: CGPointMake(72.67, 64.34) controlPoint2: CGPointMake(73.08, 67.54)];
                [bezierPath addCurveToPoint: CGPointMake(69.78, 85.83) controlPoint1: CGPointMake(73.58, 75.86) controlPoint2: CGPointMake(73.33, 81.32)];
                [bezierPath addCurveToPoint: CGPointMake(57.85, 94.35) controlPoint1: CGPointMake(66.92, 89.46) controlPoint2: CGPointMake(62.52, 92.3)];
                [bezierPath addCurveToPoint: CGPointMake(45.66, 96.24) controlPoint1: CGPointMake(54.08, 96) controlPoint2: CGPointMake(49.82, 97.36)];
                [bezierPath addCurveToPoint: CGPointMake(38.41, 92.59) controlPoint1: CGPointMake(42.97, 95.51) controlPoint2: CGPointMake(40.56, 94.02)];
                [bezierPath addCurveToPoint: CGPointMake(30.8, 86.93) controlPoint1: CGPointMake(35.74, 90.82) controlPoint2: CGPointMake(33.27, 88.87)];
                [bezierPath addCurveToPoint: CGPointMake(18.96, 77.94) controlPoint1: CGPointMake(26.92, 83.87) controlPoint2: CGPointMake(22.8, 81.02)];
                [bezierPath addCurveToPoint: CGPointMake(9.1, 66.47) controlPoint1: CGPointMake(14.84, 74.63) controlPoint2: CGPointMake(11.28, 70.82)];
                [bezierPath addCurveToPoint: CGPointMake(6.68, 58.66) controlPoint1: CGPointMake(7.86, 64) controlPoint2: CGPointMake(6.98, 61.31)];
                [bezierPath addCurveToPoint: CGPointMake(6.67, 55.99) controlPoint1: CGPointMake(6.57, 57.77) controlPoint2: CGPointMake(6.57, 56.88)];
                [bezierPath addCurveToPoint: CGPointMake(6.85, 55.22) controlPoint1: CGPointMake(6.7, 55.78) controlPoint2: CGPointMake(6.76, 55.53)];
                [bezierPath addCurveToPoint: CGPointMake(7.08, 54.57) controlPoint1: CGPointMake(6.89, 55.06) controlPoint2: CGPointMake(7.24, 54.28)];
                [bezierPath addCurveToPoint: CGPointMake(7.33, 54.18) controlPoint1: CGPointMake(7.16, 54.44) controlPoint2: CGPointMake(7.24, 54.3)];
                [bezierPath addCurveToPoint: CGPointMake(7.43, 54.02) controlPoint1: CGPointMake(7.4, 54.07) controlPoint2: CGPointMake(7.81, 53.62)];
                [bezierPath addCurveToPoint: CGPointMake(8, 53.55) controlPoint1: CGPointMake(7.6, 53.84) controlPoint2: CGPointMake(7.79, 53.69)];
                [bezierPath addCurveToPoint: CGPointMake(8.12, 53.53) controlPoint1: CGPointMake(7.45, 53.92) controlPoint2: CGPointMake(7.93, 53.61)];
                [bezierPath addCurveToPoint: CGPointMake(7.87, 53.62) controlPoint1: CGPointMake(8.42, 53.41) controlPoint2: CGPointMake(7.52, 53.69)];
                [bezierPath addCurveToPoint: CGPointMake(6.01, 51.07) controlPoint1: CGPointMake(7.25, 52.77) controlPoint2: CGPointMake(6.63, 51.92)];
                [bezierPath addCurveToPoint: CGPointMake(6.09, 51.03) controlPoint1: CGPointMake(5.89, 51.15) controlPoint2: CGPointMake(5.57, 51.35)];
                [bezierPath addCurveToPoint: CGPointMake(5.42, 51.37) controlPoint1: CGPointMake(5.88, 51.16) controlPoint2: CGPointMake(5.65, 51.27)];
                [bezierPath addCurveToPoint: CGPointMake(5.4, 51.39) controlPoint1: CGPointMake(5.32, 51.42) controlPoint2: CGPointMake(4.9, 51.54)];
                [bezierPath addCurveToPoint: CGPointMake(5.21, 51.46) controlPoint1: CGPointMake(5.28, 51.43) controlPoint2: CGPointMake(4.68, 51.51)];
                [bezierPath addCurveToPoint: CGPointMake(4.98, 51.46) controlPoint1: CGPointMake(4.71, 51.51) controlPoint2: CGPointMake(5.26, 51.52)];
                [bezierPath addCurveToPoint: CGPointMake(4.97, 51.42) controlPoint1: CGPointMake(5.16, 51.5) controlPoint2: CGPointMake(5.11, 51.53)];
                [bezierPath addCurveToPoint: CGPointMake(4.09, 48.77) controlPoint1: CGPointMake(4.34, 50.94) controlPoint2: CGPointMake(4.12, 49.58)];
                [bezierPath addCurveToPoint: CGPointMake(4.97, 45.57) controlPoint1: CGPointMake(4.07, 47.67) controlPoint2: CGPointMake(4.49, 46.59)];
                [bezierPath addCurveToPoint: CGPointMake(12.08, 37.08) controlPoint1: CGPointMake(6.42, 42.45) controlPoint2: CGPointMake(9.21, 39.49)];
                [bezierPath addCurveToPoint: CGPointMake(9.34, 34.93) controlPoint1: CGPointMake(13.77, 35.65) controlPoint2: CGPointMake(11.05, 33.49)];
                [bezierPath addLineToPoint: CGPointMake(9.34, 34.93)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;
                
                [fillColor setFill];
                [bezierPath fill];
            }
        }
        
        
        //// Group 5
        {
            //// Group 6
            {
                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                [bezier2Path moveToPoint: CGPointMake(98.79, 39.2)];
                [bezier2Path addCurveToPoint: CGPointMake(89.43, 36.51) controlPoint1: CGPointMake(95.99, 37.85) controlPoint2: CGPointMake(92.63, 37.03)];
                [bezier2Path addCurveToPoint: CGPointMake(79.68, 36.06) controlPoint1: CGPointMake(86.23, 35.98) controlPoint2: CGPointMake(82.94, 35.83)];
                [bezier2Path addCurveToPoint: CGPointMake(68.41, 37.95) controlPoint1: CGPointMake(75.86, 36.32) controlPoint2: CGPointMake(72.09, 37.15)];
                [bezier2Path addCurveToPoint: CGPointMake(59.88, 40.21) controlPoint1: CGPointMake(65.51, 38.58) controlPoint2: CGPointMake(62.65, 39.3)];
                [bezier2Path addCurveToPoint: CGPointMake(55.03, 42.49) controlPoint1: CGPointMake(58.15, 40.78) controlPoint2: CGPointMake(56.39, 41.46)];
                [bezier2Path addCurveToPoint: CGPointMake(53.45, 45.8) controlPoint1: CGPointMake(53.8, 43.42) controlPoint2: CGPointMake(53.64, 44.55)];
                [bezier2Path addCurveToPoint: CGPointMake(53.2, 51.28) controlPoint1: CGPointMake(53.17, 47.62) controlPoint2: CGPointMake(53.07, 49.46)];
                [bezier2Path addCurveToPoint: CGPointMake(54.09, 54.82) controlPoint1: CGPointMake(53.28, 52.49) controlPoint2: CGPointMake(53.48, 53.7)];
                [bezier2Path addCurveToPoint: CGPointMake(56.81, 56.87) controlPoint1: CGPointMake(54.63, 55.82) controlPoint2: CGPointMake(55.7, 56.29)];
                [bezier2Path addCurveToPoint: CGPointMake(66.49, 61.09) controlPoint1: CGPointMake(59.75, 58.41) controlPoint2: CGPointMake(62.95, 60.47)];
                [bezier2Path addCurveToPoint: CGPointMake(67.4, 58.51) controlPoint1: CGPointMake(68.66, 61.47) controlPoint2: CGPointMake(69.57, 58.89)];
                [bezier2Path addCurveToPoint: CGPointMake(60.63, 55.65) controlPoint1: CGPointMake(64.95, 58.08) controlPoint2: CGPointMake(62.68, 56.72)];
                [bezier2Path addCurveToPoint: CGPointMake(57.68, 54.11) controlPoint1: CGPointMake(59.64, 55.14) controlPoint2: CGPointMake(58.67, 54.62)];
                [bezier2Path addCurveToPoint: CGPointMake(57.43, 53.99) controlPoint1: CGPointMake(57.65, 54.1) controlPoint2: CGPointMake(57.09, 53.76)];
                [bezier2Path addCurveToPoint: CGPointMake(57.31, 53.87) controlPoint1: CGPointMake(57.11, 53.77) controlPoint2: CGPointMake(57.56, 54.18)];
                [bezier2Path addCurveToPoint: CGPointMake(56.93, 52.99) controlPoint1: CGPointMake(57.11, 53.61) controlPoint2: CGPointMake(57.05, 53.37)];
                [bezier2Path addCurveToPoint: CGPointMake(56.7, 47.63) controlPoint1: CGPointMake(56.4, 51.27) controlPoint2: CGPointMake(56.56, 49.38)];
                [bezier2Path addCurveToPoint: CGPointMake(56.98, 45.32) controlPoint1: CGPointMake(56.76, 46.86) controlPoint2: CGPointMake(56.85, 46.09)];
                [bezier2Path addCurveToPoint: CGPointMake(57.11, 44.78) controlPoint1: CGPointMake(56.98, 45.32) controlPoint2: CGPointMake(57.07, 44.92)];
                [bezier2Path addCurveToPoint: CGPointMake(57.1, 44.76) controlPoint1: CGPointMake(57.14, 44.69) controlPoint2: CGPointMake(57.29, 44.46)];
                [bezier2Path addCurveToPoint: CGPointMake(57.19, 44.62) controlPoint1: CGPointMake(57.14, 44.7) controlPoint2: CGPointMake(57.45, 44.36)];
                [bezier2Path addCurveToPoint: CGPointMake(61.37, 42.6) controlPoint1: CGPointMake(58.13, 43.7) controlPoint2: CGPointMake(59.82, 43.13)];
                [bezier2Path addCurveToPoint: CGPointMake(69.72, 40.44) controlPoint1: CGPointMake(64.04, 41.69) controlPoint2: CGPointMake(66.9, 41.05)];
                [bezier2Path addCurveToPoint: CGPointMake(80.94, 38.65) controlPoint1: CGPointMake(73.38, 39.65) controlPoint2: CGPointMake(77.13, 38.83)];
                [bezier2Path addCurveToPoint: CGPointMake(90.13, 39.38) controlPoint1: CGPointMake(84.04, 38.51) controlPoint2: CGPointMake(87.13, 38.79)];
                [bezier2Path addCurveToPoint: CGPointMake(97.06, 41.51) controlPoint1: CGPointMake(92.51, 39.84) controlPoint2: CGPointMake(94.96, 40.5)];
                [bezier2Path addCurveToPoint: CGPointMake(98.79, 39.2) controlPoint1: CGPointMake(98.96, 42.43) controlPoint2: CGPointMake(100.68, 40.11)];
                [bezier2Path addLineToPoint: CGPointMake(98.79, 39.2)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier2Path fill];
            }
        }
        
        
        //// Group 7
        {
            //// Group 8
            {
                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
                [bezier3Path moveToPoint: CGPointMake(58.35, 57.53)];
                [bezier3Path addCurveToPoint: CGPointMake(58.35, 57.52) controlPoint1: CGPointMake(58.44, 57.61) controlPoint2: CGPointMake(58.69, 57.86)];
                [bezier3Path addCurveToPoint: CGPointMake(58.92, 58.18) controlPoint1: CGPointMake(58.56, 57.73) controlPoint2: CGPointMake(58.74, 57.95)];
                [bezier3Path addCurveToPoint: CGPointMake(60.01, 60.43) controlPoint1: CGPointMake(59.47, 58.88) controlPoint2: CGPointMake(59.79, 59.63)];
                [bezier3Path addCurveToPoint: CGPointMake(56.92, 67.97) controlPoint1: CGPointMake(60.75, 63.12) controlPoint2: CGPointMake(59.08, 65.95)];
                [bezier3Path addCurveToPoint: CGPointMake(40.69, 74.51) controlPoint1: CGPointMake(52.86, 71.78) controlPoint2: CGPointMake(46.67, 73.39)];
                [bezier3Path addCurveToPoint: CGPointMake(41.6, 77.14) controlPoint1: CGPointMake(38.49, 74.92) controlPoint2: CGPointMake(39.4, 77.55)];
                [bezier3Path addCurveToPoint: CGPointMake(60.19, 69.12) controlPoint1: CGPointMake(48.63, 75.83) controlPoint2: CGPointMake(55.68, 73.75)];
                [bezier3Path addCurveToPoint: CGPointMake(60.82, 55.6) controlPoint1: CGPointMake(63.87, 65.35) controlPoint2: CGPointMake(65.35, 59.39)];
                [bezier3Path addCurveToPoint: CGPointMake(58.35, 57.53) controlPoint1: CGPointMake(59.28, 54.31) controlPoint2: CGPointMake(56.81, 56.25)];
                [bezier3Path addLineToPoint: CGPointMake(58.35, 57.53)];
                [bezier3Path closePath];
                bezier3Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier3Path fill];
            }
        }
        
        
        //// Group 9
        {
            //// Group 10
            {
                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
                [bezier4Path moveToPoint: CGPointMake(49.74, 87.47)];
                [bezier4Path addCurveToPoint: CGPointMake(56.4, 79.84) controlPoint1: CGPointMake(52.26, 85.08) controlPoint2: CGPointMake(54.55, 82.53)];
                [bezier4Path addCurveToPoint: CGPointMake(61.75, 69.31) controlPoint1: CGPointMake(58.68, 76.51) controlPoint2: CGPointMake(60.06, 72.81)];
                [bezier4Path addCurveToPoint: CGPointMake(57.84, 68.91) controlPoint1: CGPointMake(60.45, 69.18) controlPoint2: CGPointMake(59.14, 69.04)];
                [bezier4Path addCurveToPoint: CGPointMake(58.72, 85.63) controlPoint1: CGPointMake(58.72, 74.44) controlPoint2: CGPointMake(59.65, 80.08)];
                [bezier4Path addCurveToPoint: CGPointMake(60.7, 87.08) controlPoint1: CGPointMake(58.59, 86.41) controlPoint2: CGPointMake(59.71, 87.08)];
                [bezier4Path addCurveToPoint: CGPointMake(62.71, 85.65) controlPoint1: CGPointMake(61.88, 87.09) controlPoint2: CGPointMake(62.58, 86.43)];
                [bezier4Path addCurveToPoint: CGPointMake(61.82, 68.94) controlPoint1: CGPointMake(63.63, 80.1) controlPoint2: CGPointMake(62.71, 74.46)];
                [bezier4Path addCurveToPoint: CGPointMake(57.91, 68.54) controlPoint1: CGPointMake(61.56, 67.33) controlPoint2: CGPointMake(58.69, 66.93)];
                [bezier4Path addCurveToPoint: CGPointMake(53.14, 78.11) controlPoint1: CGPointMake(56.37, 71.72) controlPoint2: CGPointMake(55.11, 75.06)];
                [bezier4Path addCurveToPoint: CGPointMake(49.14, 83.12) controlPoint1: CGPointMake(52.01, 79.86) controlPoint2: CGPointMake(50.6, 81.51)];
                [bezier4Path addCurveToPoint: CGPointMake(47.4, 84.94) controlPoint1: CGPointMake(48.57, 83.74) controlPoint2: CGPointMake(47.99, 84.34)];
                [bezier4Path addCurveToPoint: CGPointMake(46.9, 85.44) controlPoint1: CGPointMake(47.24, 85.1) controlPoint2: CGPointMake(46.23, 86.08)];
                [bezier4Path addCurveToPoint: CGPointMake(46.92, 87.48) controlPoint1: CGPointMake(46.24, 86.06) controlPoint2: CGPointMake(46.07, 86.87)];
                [bezier4Path addCurveToPoint: CGPointMake(49.74, 87.47) controlPoint1: CGPointMake(47.62, 87.98) controlPoint2: CGPointMake(49.07, 88.09)];
                [bezier4Path addLineToPoint: CGPointMake(49.74, 87.47)];
                [bezier4Path closePath];
                bezier4Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier4Path fill];
            }
        }
        
        
        //// Group 11
        {
            //// Group 12
            {
                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
                [bezier5Path moveToPoint: CGPointMake(42.71, 28.97)];
                [bezier5Path addCurveToPoint: CGPointMake(46.7, 30.68) controlPoint1: CGPointMake(44.23, 29.22) controlPoint2: CGPointMake(45.62, 29.84)];
                [bezier5Path addCurveToPoint: CGPointMake(48.68, 33.53) controlPoint1: CGPointMake(47.66, 31.43) controlPoint2: CGPointMake(48.27, 32.54)];
                [bezier5Path addCurveToPoint: CGPointMake(48.98, 34.56) controlPoint1: CGPointMake(48.91, 34.07) controlPoint2: CGPointMake(48.97, 34.3)];
                [bezier5Path addCurveToPoint: CGPointMake(51.74, 35.79) controlPoint1: CGPointMake(49, 35.66) controlPoint2: CGPointMake(50.5, 36.29)];
                [bezier5Path addCurveToPoint: CGPointMake(72.78, 30.16) controlPoint1: CGPointMake(58.29, 33.12) controlPoint2: CGPointMake(65.37, 30.8)];
                [bezier5Path addCurveToPoint: CGPointMake(89.98, 29.94) controlPoint1: CGPointMake(78.48, 29.66) controlPoint2: CGPointMake(84.26, 29.65)];
                [bezier5Path addCurveToPoint: CGPointMake(97.42, 30.56) controlPoint1: CGPointMake(92.56, 30.08) controlPoint2: CGPointMake(95.18, 30.26)];
                [bezier5Path addCurveToPoint: CGPointMake(98.39, 27.85) controlPoint1: CGPointMake(99.73, 30.87) controlPoint2: CGPointMake(100.72, 28.16)];
                [bezier5Path addCurveToPoint: CGPointMake(72.28, 27.39) controlPoint1: CGPointMake(89.84, 26.71) controlPoint2: CGPointMake(80.87, 26.65)];
                [bezier5Path addCurveToPoint: CGPointMake(49.88, 33.36) controlPoint1: CGPointMake(64.39, 28.07) controlPoint2: CGPointMake(56.85, 30.52)];
                [bezier5Path addCurveToPoint: CGPointMake(52.65, 34.58) controlPoint1: CGPointMake(50.81, 33.77) controlPoint2: CGPointMake(51.73, 34.17)];
                [bezier5Path addCurveToPoint: CGPointMake(49.53, 28.89) controlPoint1: CGPointMake(52.61, 32.55) controlPoint2: CGPointMake(51.15, 30.42)];
                [bezier5Path addCurveToPoint: CGPointMake(43.68, 26.26) controlPoint1: CGPointMake(48.15, 27.59) controlPoint2: CGPointMake(45.81, 26.61)];
                [bezier5Path addCurveToPoint: CGPointMake(42.71, 28.97) controlPoint1: CGPointMake(41.37, 25.88) controlPoint2: CGPointMake(40.39, 28.59)];
                [bezier5Path addLineToPoint: CGPointMake(42.71, 28.97)];
                [bezier5Path closePath];
                bezier5Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier5Path fill];
            }
        }
        
        
        //// Group 13
        {
            //// Group 14
            {
                //// Bezier 6 Drawing
                UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
                [bezier6Path moveToPoint: CGPointMake(35.55, 36.5)];
                [bezier6Path addCurveToPoint: CGPointMake(38.88, 40.88) controlPoint1: CGPointMake(36.83, 37.88) controlPoint2: CGPointMake(37.93, 39.37)];
                [bezier6Path addCurveToPoint: CGPointMake(40.2, 48.19) controlPoint1: CGPointMake(40.14, 42.87) controlPoint2: CGPointMake(41.82, 46.09)];
                [bezier6Path addCurveToPoint: CGPointMake(38.25, 49.53) controlPoint1: CGPointMake(39.83, 48.68) controlPoint2: CGPointMake(38.92, 49.12)];
                [bezier6Path addCurveToPoint: CGPointMake(34.72, 50.8) controlPoint1: CGPointMake(37.18, 50.19) controlPoint2: CGPointMake(36.08, 50.55)];
                [bezier6Path addCurveToPoint: CGPointMake(28.28, 51.18) controlPoint1: CGPointMake(32.65, 51.19) controlPoint2: CGPointMake(30.41, 51.27)];
                [bezier6Path addCurveToPoint: CGPointMake(28.26, 53.8) controlPoint1: CGPointMake(25.95, 51.07) controlPoint2: CGPointMake(25.94, 53.69)];
                [bezier6Path addCurveToPoint: CGPointMake(35.96, 53.28) controlPoint1: CGPointMake(30.81, 53.91) controlPoint2: CGPointMake(33.48, 53.74)];
                [bezier6Path addCurveToPoint: CGPointMake(43.33, 49.5) controlPoint1: CGPointMake(38.74, 52.76) controlPoint2: CGPointMake(41.78, 51.3)];
                [bezier6Path addCurveToPoint: CGPointMake(42.78, 40.88) controlPoint1: CGPointMake(45.47, 47.01) controlPoint2: CGPointMake(44.14, 43.38)];
                [bezier6Path addCurveToPoint: CGPointMake(38.67, 35.17) controlPoint1: CGPointMake(41.7, 38.89) controlPoint2: CGPointMake(40.32, 36.95)];
                [bezier6Path addCurveToPoint: CGPointMake(35.55, 36.5) controlPoint1: CGPointMake(37.38, 33.78) controlPoint2: CGPointMake(34.25, 35.09)];
                [bezier6Path addLineToPoint: CGPointMake(35.55, 36.5)];
                [bezier6Path closePath];
                bezier6Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier6Path fill];
            }
        }
        
        
        //// Group 15
        {
            //// Group 16
            {
                //// Bezier 7 Drawing
                UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
                [bezier7Path moveToPoint: CGPointMake(10.67, 15.53)];
                [bezier7Path addCurveToPoint: CGPointMake(21.54, 17.73) controlPoint1: CGPointMake(14.49, 15.55) controlPoint2: CGPointMake(18.1, 16.64)];
                [bezier7Path addCurveToPoint: CGPointMake(24.23, 17.2) controlPoint1: CGPointMake(22.53, 18.04) controlPoint2: CGPointMake(23.65, 17.94)];
                [bezier7Path addCurveToPoint: CGPointMake(23.51, 15.22) controlPoint1: CGPointMake(24.72, 16.58) controlPoint2: CGPointMake(24.5, 15.54)];
                [bezier7Path addCurveToPoint: CGPointMake(10.7, 12.64) controlPoint1: CGPointMake(19.42, 13.93) controlPoint2: CGPointMake(15.23, 12.65)];
                [bezier7Path addCurveToPoint: CGPointMake(10.67, 15.53) controlPoint1: CGPointMake(8.15, 12.63) controlPoint2: CGPointMake(8.13, 15.52)];
                [bezier7Path addLineToPoint: CGPointMake(10.67, 15.53)];
                [bezier7Path closePath];
                bezier7Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier7Path fill];
            }
        }
        
        
        //// Group 17
        {
            //// Group 18
            {
                //// Bezier 8 Drawing
                UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
                [bezier8Path moveToPoint: CGPointMake(6.63, 22.79)];
                [bezier8Path addCurveToPoint: CGPointMake(15.05, 24.33) controlPoint1: CGPointMake(9.23, 22.8) controlPoint2: CGPointMake(13.46, 23.02)];
                [bezier8Path addCurveToPoint: CGPointMake(17.77, 22.36) controlPoint1: CGPointMake(16.69, 25.68) controlPoint2: CGPointMake(19.39, 23.7)];
                [bezier8Path addCurveToPoint: CGPointMake(13.06, 20.6) controlPoint1: CGPointMake(16.62, 21.42) controlPoint2: CGPointMake(14.68, 20.92)];
                [bezier8Path addCurveToPoint: CGPointMake(6.66, 20.02) controlPoint1: CGPointMake(11.02, 20.19) controlPoint2: CGPointMake(8.78, 20.03)];
                [bezier8Path addCurveToPoint: CGPointMake(6.63, 22.79) controlPoint1: CGPointMake(4.17, 20.01) controlPoint2: CGPointMake(4.15, 22.79)];
                [bezier8Path addLineToPoint: CGPointMake(6.63, 22.79)];
                [bezier8Path closePath];
                bezier8Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier8Path fill];
            }
        }
        
        
        //// Bezier 9 Drawing
        UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
        [bezier9Path moveToPoint: CGPointMake(54.82, 27.61)];
        [bezier9Path addLineToPoint: CGPointMake(67.56, 24.07)];
        [bezier9Path addCurveToPoint: CGPointMake(61.32, 17.39) controlPoint1: CGPointMake(67.56, 24.07) controlPoint2: CGPointMake(60.8, 18.76)];
        [bezier9Path addCurveToPoint: CGPointMake(68.34, 11.68) controlPoint1: CGPointMake(61.84, 16.01) controlPoint2: CGPointMake(64.18, 15.22)];
        [bezier9Path addCurveToPoint: CGPointMake(73.29, 3.82) controlPoint1: CGPointMake(72.08, 8.5) controlPoint2: CGPointMake(74.33, 5)];
        [bezier9Path addCurveToPoint: CGPointMake(60.8, 1.85) controlPoint1: CGPointMake(72.25, 2.64) controlPoint2: CGPointMake(62.1, 1.46)];
        [bezier9Path addCurveToPoint: CGPointMake(55.6, 7.55) controlPoint1: CGPointMake(59.5, 2.24) controlPoint2: CGPointMake(58.98, 3.62)];
        [bezier9Path addCurveToPoint: CGPointMake(50.14, 12.67) controlPoint1: CGPointMake(53.89, 9.54) controlPoint2: CGPointMake(50.14, 12.67)];
        [bezier9Path addCurveToPoint: CGPointMake(51.96, 5.78) controlPoint1: CGPointMake(50.14, 12.67) controlPoint2: CGPointMake(51.7, 10.11)];
        [bezier9Path addCurveToPoint: CGPointMake(51.44, 0.28) controlPoint1: CGPointMake(52.12, 3.01) controlPoint2: CGPointMake(51.44, 0.28)];
        [bezier9Path addLineToPoint: CGPointMake(38.95, 0.87)];
        [bezier9Path addCurveToPoint: CGPointMake(38.43, 11.49) controlPoint1: CGPointMake(38.95, 0.87) controlPoint2: CGPointMake(39.99, 9.52)];
        [bezier9Path addCurveToPoint: CGPointMake(22.57, 22.5) controlPoint1: CGPointMake(36.87, 13.45) controlPoint2: CGPointMake(27.77, 15.81)];
        [bezier9Path addCurveToPoint: CGPointMake(17.1, 41.57) controlPoint1: CGPointMake(17.36, 29.18) controlPoint2: CGPointMake(16.32, 37.84)];
        [bezier9Path addCurveToPoint: CGPointMake(26.47, 49.44) controlPoint1: CGPointMake(17.88, 45.31) controlPoint2: CGPointMake(18.08, 50.03)];
        [bezier9Path addCurveToPoint: CGPointMake(32.71, 32.92) controlPoint1: CGPointMake(37.65, 48.65) controlPoint2: CGPointMake(27.77, 40.2)];
        [bezier9Path addCurveToPoint: CGPointMake(45.19, 23.28) controlPoint1: CGPointMake(37.65, 25.64) controlPoint2: CGPointMake(39.47, 24.66)];
        [bezier9Path addCurveToPoint: CGPointMake(54.56, 26.82) controlPoint1: CGPointMake(50.92, 21.91) controlPoint2: CGPointMake(54.56, 26.82)];
        bezier9Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier9Path fill];
    }    
}

// draw heart 1 image
-(void) drawPath2
{
    //// 图层_5
    {
        //// Group 3
        {
            //// Group 4
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = UIBezierPath.bezierPath;
                [bezierPath moveToPoint: CGPointMake(9.34, 35.4)];
                [bezierPath addCurveToPoint: CGPointMake(0.63, 46.66) controlPoint1: CGPointMake(5.58, 38.52) controlPoint2: CGPointMake(1.97, 42.46)];
                [bezierPath addCurveToPoint: CGPointMake(3.21, 54.34) controlPoint1: CGPointMake(-0.15, 49.08) controlPoint2: CGPointMake(0.07, 52.96)];
                [bezierPath addCurveToPoint: CGPointMake(8.74, 53.41) controlPoint1: CGPointMake(5.06, 55.16) controlPoint2: CGPointMake(7.31, 54.46)];
                [bezierPath addCurveToPoint: CGPointMake(6.88, 50.9) controlPoint1: CGPointMake(10.16, 52.37) controlPoint2: CGPointMake(8.68, 50.53)];
                [bezierPath addCurveToPoint: CGPointMake(3.23, 54.31) controlPoint1: CGPointMake(4.93, 51.3) controlPoint2: CGPointMake(3.76, 52.92)];
                [bezierPath addCurveToPoint: CGPointMake(2.93, 59.56) controlPoint1: CGPointMake(2.58, 55.99) controlPoint2: CGPointMake(2.68, 57.84)];
                [bezierPath addCurveToPoint: CGPointMake(5.53, 67.53) controlPoint1: CGPointMake(3.35, 62.29) controlPoint2: CGPointMake(4.23, 64.98)];
                [bezierPath addCurveToPoint: CGPointMake(15.59, 79.37) controlPoint1: CGPointMake(7.8, 72) controlPoint2: CGPointMake(11.37, 75.91)];
                [bezierPath addCurveToPoint: CGPointMake(27.19, 88.04) controlPoint1: CGPointMake(19.28, 82.39) controlPoint2: CGPointMake(23.39, 85.1)];
                [bezierPath addCurveToPoint: CGPointMake(42.42, 97.94) controlPoint1: CGPointMake(31.81, 91.63) controlPoint2: CGPointMake(36.53, 95.62)];
                [bezierPath addCurveToPoint: CGPointMake(49.73, 99.19) controlPoint1: CGPointMake(44.68, 98.84) controlPoint2: CGPointMake(47.18, 99.38)];
                [bezierPath addCurveToPoint: CGPointMake(56.08, 97.88) controlPoint1: CGPointMake(51.93, 99.03) controlPoint2: CGPointMake(54.04, 98.53)];
                [bezierPath addCurveToPoint: CGPointMake(69.52, 90.64) controlPoint1: CGPointMake(61.14, 96.26) controlPoint2: CGPointMake(65.77, 93.76)];
                [bezierPath addCurveToPoint: CGPointMake(74.4, 85.23) controlPoint1: CGPointMake(71.46, 89.04) controlPoint2: CGPointMake(73.14, 87.21)];
                [bezierPath addCurveToPoint: CGPointMake(76.81, 78.2) controlPoint1: CGPointMake(75.84, 82.99) controlPoint2: CGPointMake(76.44, 80.67)];
                [bezierPath addCurveToPoint: CGPointMake(75.38, 60.58) controlPoint1: CGPointMake(77.68, 72.45) controlPoint2: CGPointMake(77.25, 66.21)];
                [bezierPath addCurveToPoint: CGPointMake(74.89, 62.03) controlPoint1: CGPointMake(75.22, 61.06) controlPoint2: CGPointMake(75.06, 61.55)];
                [bezierPath addCurveToPoint: CGPointMake(81.46, 53.62) controlPoint1: CGPointMake(78.04, 59.94) controlPoint2: CGPointMake(80.78, 56.83)];
                [bezierPath addCurveToPoint: CGPointMake(80.17, 46.15) controlPoint1: CGPointMake(81.98, 51.16) controlPoint2: CGPointMake(81.21, 48.47)];
                [bezierPath addCurveToPoint: CGPointMake(78.26, 42.98) controlPoint1: CGPointMake(79.69, 45.07) controlPoint2: CGPointMake(79.1, 43.93)];
                [bezierPath addCurveToPoint: CGPointMake(74.94, 44.5) controlPoint1: CGPointMake(76.86, 41.39) controlPoint2: CGPointMake(73.53, 42.9)];
                [bezierPath addCurveToPoint: CGPointMake(76.35, 46.7) controlPoint1: CGPointMake(75.54, 45.17) controlPoint2: CGPointMake(75.98, 45.94)];
                [bezierPath addCurveToPoint: CGPointMake(77.69, 53.09) controlPoint1: CGPointMake(77.29, 48.63) controlPoint2: CGPointMake(78.13, 51.03)];
                [bezierPath addCurveToPoint: CGPointMake(72.16, 59.91) controlPoint1: CGPointMake(77.13, 55.73) controlPoint2: CGPointMake(74.72, 58.21)];
                [bezierPath addCurveToPoint: CGPointMake(71.67, 61.36) controlPoint1: CGPointMake(71.65, 60.25) controlPoint2: CGPointMake(71.51, 60.88)];
                [bezierPath addCurveToPoint: CGPointMake(73.27, 70.61) controlPoint1: CGPointMake(72.67, 64.36) controlPoint2: CGPointMake(73.08, 67.51)];
                [bezierPath addCurveToPoint: CGPointMake(69.78, 85.53) controlPoint1: CGPointMake(73.57, 75.71) controlPoint2: CGPointMake(73.33, 81.09)];
                [bezierPath addCurveToPoint: CGPointMake(57.84, 93.91) controlPoint1: CGPointMake(66.92, 89.1) controlPoint2: CGPointMake(62.52, 91.9)];
                [bezierPath addCurveToPoint: CGPointMake(45.66, 95.78) controlPoint1: CGPointMake(54.08, 95.54) controlPoint2: CGPointMake(49.82, 96.88)];
                [bezierPath addCurveToPoint: CGPointMake(38.4, 92.18) controlPoint1: CGPointMake(42.97, 95.06) controlPoint2: CGPointMake(40.56, 93.59)];
                [bezierPath addCurveToPoint: CGPointMake(30.8, 86.61) controlPoint1: CGPointMake(35.74, 90.44) controlPoint2: CGPointMake(33.27, 88.52)];
                [bezierPath addCurveToPoint: CGPointMake(18.96, 77.76) controlPoint1: CGPointMake(26.92, 83.6) controlPoint2: CGPointMake(22.79, 80.79)];
                [bezierPath addCurveToPoint: CGPointMake(9.09, 66.46) controlPoint1: CGPointMake(14.83, 74.5) controlPoint2: CGPointMake(11.27, 70.75)];
                [bezierPath addCurveToPoint: CGPointMake(6.67, 58.77) controlPoint1: CGPointMake(7.86, 64.03) controlPoint2: CGPointMake(6.98, 61.39)];
                [bezierPath addCurveToPoint: CGPointMake(6.67, 56.14) controlPoint1: CGPointMake(6.57, 57.9) controlPoint2: CGPointMake(6.56, 57.02)];
                [bezierPath addCurveToPoint: CGPointMake(6.84, 55.39) controlPoint1: CGPointMake(6.69, 55.94) controlPoint2: CGPointMake(6.76, 55.69)];
                [bezierPath addCurveToPoint: CGPointMake(7.08, 54.75) controlPoint1: CGPointMake(6.89, 55.23) controlPoint2: CGPointMake(7.24, 54.46)];
                [bezierPath addCurveToPoint: CGPointMake(7.33, 54.36) controlPoint1: CGPointMake(7.15, 54.61) controlPoint2: CGPointMake(7.24, 54.48)];
                [bezierPath addCurveToPoint: CGPointMake(7.43, 54.2) controlPoint1: CGPointMake(7.4, 54.26) controlPoint2: CGPointMake(7.81, 53.81)];
                [bezierPath addCurveToPoint: CGPointMake(8, 53.74) controlPoint1: CGPointMake(7.59, 54.03) controlPoint2: CGPointMake(7.79, 53.88)];
                [bezierPath addCurveToPoint: CGPointMake(8.12, 53.72) controlPoint1: CGPointMake(7.44, 54.1) controlPoint2: CGPointMake(7.93, 53.8)];
                [bezierPath addCurveToPoint: CGPointMake(7.87, 53.81) controlPoint1: CGPointMake(8.42, 53.61) controlPoint2: CGPointMake(7.52, 53.88)];
                [bezierPath addCurveToPoint: CGPointMake(6.01, 51.3) controlPoint1: CGPointMake(7.25, 52.97) controlPoint2: CGPointMake(6.63, 52.13)];
                [bezierPath addCurveToPoint: CGPointMake(6.09, 51.26) controlPoint1: CGPointMake(5.89, 51.38) controlPoint2: CGPointMake(5.56, 51.58)];
                [bezierPath addCurveToPoint: CGPointMake(5.42, 51.6) controlPoint1: CGPointMake(5.88, 51.39) controlPoint2: CGPointMake(5.65, 51.5)];
                [bezierPath addCurveToPoint: CGPointMake(5.39, 51.62) controlPoint1: CGPointMake(5.32, 51.64) controlPoint2: CGPointMake(4.9, 51.76)];
                [bezierPath addCurveToPoint: CGPointMake(5.21, 51.69) controlPoint1: CGPointMake(5.27, 51.65) controlPoint2: CGPointMake(4.67, 51.73)];
                [bezierPath addCurveToPoint: CGPointMake(4.97, 51.68) controlPoint1: CGPointMake(4.71, 51.73) controlPoint2: CGPointMake(5.25, 51.74)];
                [bezierPath addCurveToPoint: CGPointMake(4.97, 51.64) controlPoint1: CGPointMake(5.16, 51.72) controlPoint2: CGPointMake(5.11, 51.75)];
                [bezierPath addCurveToPoint: CGPointMake(4.09, 49.04) controlPoint1: CGPointMake(4.34, 51.17) controlPoint2: CGPointMake(4.11, 49.83)];
                [bezierPath addCurveToPoint: CGPointMake(4.96, 45.88) controlPoint1: CGPointMake(4.06, 47.95) controlPoint2: CGPointMake(4.49, 46.89)];
                [bezierPath addCurveToPoint: CGPointMake(12.07, 37.52) controlPoint1: CGPointMake(6.42, 42.81) controlPoint2: CGPointMake(9.21, 39.9)];
                [bezierPath addCurveToPoint: CGPointMake(9.34, 35.4) controlPoint1: CGPointMake(13.77, 36.11) controlPoint2: CGPointMake(11.05, 33.99)];
                [bezierPath addLineToPoint: CGPointMake(9.34, 35.4)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;
                
                [fillColor setFill];
                [bezierPath fill];
            }
        }
        
        
        //// Group 5
        {
            //// Group 6
            {
                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                [bezier2Path moveToPoint: CGPointMake(98.75, 38.68)];
                [bezier2Path addCurveToPoint: CGPointMake(88.99, 35.99) controlPoint1: CGPointMake(95.83, 37.33) controlPoint2: CGPointMake(92.33, 36.51)];
                [bezier2Path addCurveToPoint: CGPointMake(78.82, 35.54) controlPoint1: CGPointMake(85.65, 35.47) controlPoint2: CGPointMake(82.22, 35.32)];
                [bezier2Path addCurveToPoint: CGPointMake(67.07, 37.43) controlPoint1: CGPointMake(74.83, 35.8) controlPoint2: CGPointMake(70.91, 36.64)];
                [bezier2Path addCurveToPoint: CGPointMake(58.17, 39.69) controlPoint1: CGPointMake(64.04, 38.06) controlPoint2: CGPointMake(61.06, 38.79)];
                [bezier2Path addCurveToPoint: CGPointMake(53.11, 41.97) controlPoint1: CGPointMake(56.36, 40.26) controlPoint2: CGPointMake(54.53, 40.95)];
                [bezier2Path addCurveToPoint: CGPointMake(51.46, 45.29) controlPoint1: CGPointMake(51.83, 42.9) controlPoint2: CGPointMake(51.66, 44.03)];
                [bezier2Path addCurveToPoint: CGPointMake(51.2, 50.76) controlPoint1: CGPointMake(51.17, 47.1) controlPoint2: CGPointMake(51.06, 48.94)];
                [bezier2Path addCurveToPoint: CGPointMake(52.13, 54.31) controlPoint1: CGPointMake(51.28, 51.97) controlPoint2: CGPointMake(51.49, 53.19)];
                [bezier2Path addCurveToPoint: CGPointMake(54.96, 56.35) controlPoint1: CGPointMake(52.7, 55.31) controlPoint2: CGPointMake(53.81, 55.77)];
                [bezier2Path addCurveToPoint: CGPointMake(65.06, 60.57) controlPoint1: CGPointMake(58.03, 57.89) controlPoint2: CGPointMake(61.37, 59.95)];
                [bezier2Path addCurveToPoint: CGPointMake(66.01, 58) controlPoint1: CGPointMake(67.32, 60.95) controlPoint2: CGPointMake(68.28, 58.38)];
                [bezier2Path addCurveToPoint: CGPointMake(58.95, 55.14) controlPoint1: CGPointMake(63.45, 57.56) controlPoint2: CGPointMake(61.09, 56.2)];
                [bezier2Path addCurveToPoint: CGPointMake(55.87, 53.59) controlPoint1: CGPointMake(57.92, 54.63) controlPoint2: CGPointMake(56.9, 54.1)];
                [bezier2Path addCurveToPoint: CGPointMake(55.61, 53.48) controlPoint1: CGPointMake(55.84, 53.58) controlPoint2: CGPointMake(55.26, 53.25)];
                [bezier2Path addCurveToPoint: CGPointMake(55.49, 53.35) controlPoint1: CGPointMake(55.28, 53.26) controlPoint2: CGPointMake(55.75, 53.66)];
                [bezier2Path addCurveToPoint: CGPointMake(55.1, 52.47) controlPoint1: CGPointMake(55.28, 53.09) controlPoint2: CGPointMake(55.22, 52.85)];
                [bezier2Path addCurveToPoint: CGPointMake(54.85, 47.12) controlPoint1: CGPointMake(54.54, 50.75) controlPoint2: CGPointMake(54.7, 48.86)];
                [bezier2Path addCurveToPoint: CGPointMake(55.15, 44.8) controlPoint1: CGPointMake(54.91, 46.34) controlPoint2: CGPointMake(55.01, 45.57)];
                [bezier2Path addCurveToPoint: CGPointMake(55.28, 44.26) controlPoint1: CGPointMake(55.15, 44.8) controlPoint2: CGPointMake(55.24, 44.41)];
                [bezier2Path addCurveToPoint: CGPointMake(55.27, 44.25) controlPoint1: CGPointMake(55.31, 44.18) controlPoint2: CGPointMake(55.47, 43.94)];
                [bezier2Path addCurveToPoint: CGPointMake(55.37, 44.1) controlPoint1: CGPointMake(55.31, 44.18) controlPoint2: CGPointMake(55.64, 43.85)];
                [bezier2Path addCurveToPoint: CGPointMake(59.72, 42.09) controlPoint1: CGPointMake(56.34, 43.18) controlPoint2: CGPointMake(58.11, 42.62)];
                [bezier2Path addCurveToPoint: CGPointMake(68.43, 39.93) controlPoint1: CGPointMake(62.51, 41.17) controlPoint2: CGPointMake(65.49, 40.53)];
                [bezier2Path addCurveToPoint: CGPointMake(80.14, 38.14) controlPoint1: CGPointMake(72.25, 39.13) controlPoint2: CGPointMake(76.16, 38.31)];
                [bezier2Path addCurveToPoint: CGPointMake(89.72, 38.86) controlPoint1: CGPointMake(83.37, 37.99) controlPoint2: CGPointMake(86.59, 38.27)];
                [bezier2Path addCurveToPoint: CGPointMake(96.95, 41) controlPoint1: CGPointMake(92.2, 39.33) controlPoint2: CGPointMake(94.76, 39.99)];
                [bezier2Path addCurveToPoint: CGPointMake(98.75, 38.68) controlPoint1: CGPointMake(98.93, 41.91) controlPoint2: CGPointMake(100.72, 39.59)];
                [bezier2Path addLineToPoint: CGPointMake(98.75, 38.68)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier2Path fill];
            }
        }
        
        
        //// Group 7
        {
            //// Group 8
            {
                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
                [bezier3Path moveToPoint: CGPointMake(56.78, 57.12)];
                [bezier3Path addCurveToPoint: CGPointMake(56.79, 57.11) controlPoint1: CGPointMake(56.87, 57.2) controlPoint2: CGPointMake(57.1, 57.47)];
                [bezier3Path addCurveToPoint: CGPointMake(57.31, 57.79) controlPoint1: CGPointMake(56.98, 57.33) controlPoint2: CGPointMake(57.15, 57.56)];
                [bezier3Path addCurveToPoint: CGPointMake(58.31, 60.15) controlPoint1: CGPointMake(57.81, 58.53) controlPoint2: CGPointMake(58.11, 59.32)];
                [bezier3Path addCurveToPoint: CGPointMake(55.47, 68.04) controlPoint1: CGPointMake(58.98, 62.96) controlPoint2: CGPointMake(57.45, 65.92)];
                [bezier3Path addCurveToPoint: CGPointMake(40.58, 74.87) controlPoint1: CGPointMake(51.75, 72.01) controlPoint2: CGPointMake(46.07, 73.7)];
                [bezier3Path addCurveToPoint: CGPointMake(41.41, 77.62) controlPoint1: CGPointMake(38.56, 75.3) controlPoint2: CGPointMake(39.4, 78.05)];
                [bezier3Path addCurveToPoint: CGPointMake(58.47, 69.24) controlPoint1: CGPointMake(47.86, 76.25) controlPoint2: CGPointMake(54.34, 74.07)];
                [bezier3Path addCurveToPoint: CGPointMake(59.05, 55.1) controlPoint1: CGPointMake(61.85, 65.29) controlPoint2: CGPointMake(63.2, 59.06)];
                [bezier3Path addCurveToPoint: CGPointMake(56.78, 57.12) controlPoint1: CGPointMake(57.63, 53.75) controlPoint2: CGPointMake(55.37, 55.78)];
                [bezier3Path addLineToPoint: CGPointMake(56.78, 57.12)];
                [bezier3Path closePath];
                bezier3Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier3Path fill];
            }
        }
        
        
        //// Group 9
        {
            //// Group 10
            {
                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
                [bezier4Path moveToPoint: CGPointMake(50.92, 86.97)];
                [bezier4Path addCurveToPoint: CGPointMake(56, 79.72) controlPoint1: CGPointMake(52.84, 84.7) controlPoint2: CGPointMake(54.59, 82.28)];
                [bezier4Path addCurveToPoint: CGPointMake(60.07, 69.7) controlPoint1: CGPointMake(57.73, 76.55) controlPoint2: CGPointMake(58.78, 73.03)];
                [bezier4Path addCurveToPoint: CGPointMake(57.09, 69.33) controlPoint1: CGPointMake(59.08, 69.58) controlPoint2: CGPointMake(58.08, 69.45)];
                [bezier4Path addCurveToPoint: CGPointMake(57.76, 85.22) controlPoint1: CGPointMake(57.76, 74.58) controlPoint2: CGPointMake(58.47, 79.95)];
                [bezier4Path addCurveToPoint: CGPointMake(59.27, 86.6) controlPoint1: CGPointMake(57.66, 85.97) controlPoint2: CGPointMake(58.51, 86.6)];
                [bezier4Path addCurveToPoint: CGPointMake(60.8, 85.24) controlPoint1: CGPointMake(60.17, 86.61) controlPoint2: CGPointMake(60.7, 85.98)];
                [bezier4Path addCurveToPoint: CGPointMake(60.12, 69.35) controlPoint1: CGPointMake(61.5, 79.97) controlPoint2: CGPointMake(60.8, 74.6)];
                [bezier4Path addCurveToPoint: CGPointMake(57.14, 68.98) controlPoint1: CGPointMake(59.93, 67.82) controlPoint2: CGPointMake(57.74, 67.44)];
                [bezier4Path addCurveToPoint: CGPointMake(53.51, 78.08) controlPoint1: CGPointMake(55.98, 72) controlPoint2: CGPointMake(55.01, 75.18)];
                [bezier4Path addCurveToPoint: CGPointMake(50.47, 82.84) controlPoint1: CGPointMake(52.65, 79.74) controlPoint2: CGPointMake(51.58, 81.31)];
                [bezier4Path addCurveToPoint: CGPointMake(49.14, 84.57) controlPoint1: CGPointMake(50.04, 83.42) controlPoint2: CGPointMake(49.6, 84)];
                [bezier4Path addCurveToPoint: CGPointMake(48.77, 85.04) controlPoint1: CGPointMake(49.02, 84.72) controlPoint2: CGPointMake(48.25, 85.65)];
                [bezier4Path addCurveToPoint: CGPointMake(48.78, 86.98) controlPoint1: CGPointMake(48.27, 85.64) controlPoint2: CGPointMake(48.13, 86.41)];
                [bezier4Path addCurveToPoint: CGPointMake(50.92, 86.97) controlPoint1: CGPointMake(49.31, 87.46) controlPoint2: CGPointMake(50.42, 87.57)];
                [bezier4Path addLineToPoint: CGPointMake(50.92, 86.97)];
                [bezier4Path closePath];
                bezier4Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier4Path fill];
            }
        }
        
        
        //// Group 11
        {
            //// Group 12
            {
                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
                [bezier5Path moveToPoint: CGPointMake(45.62, 30.17)];
                [bezier5Path addCurveToPoint: CGPointMake(49.33, 31.71) controlPoint1: CGPointMake(47.03, 30.39) controlPoint2: CGPointMake(48.33, 30.95)];
                [bezier5Path addCurveToPoint: CGPointMake(51.18, 34.26) controlPoint1: CGPointMake(50.23, 32.38) controlPoint2: CGPointMake(50.8, 33.38)];
                [bezier5Path addCurveToPoint: CGPointMake(51.45, 35.19) controlPoint1: CGPointMake(51.39, 34.75) controlPoint2: CGPointMake(51.45, 34.95)];
                [bezier5Path addCurveToPoint: CGPointMake(54.03, 36.29) controlPoint1: CGPointMake(51.47, 36.18) controlPoint2: CGPointMake(52.88, 36.74)];
                [bezier5Path addCurveToPoint: CGPointMake(73.63, 31.24) controlPoint1: CGPointMake(60.12, 33.89) controlPoint2: CGPointMake(66.72, 31.81)];
                [bezier5Path addCurveToPoint: CGPointMake(89.64, 31.05) controlPoint1: CGPointMake(78.94, 30.79) controlPoint2: CGPointMake(84.32, 30.78)];
                [bezier5Path addCurveToPoint: CGPointMake(96.57, 31.6) controlPoint1: CGPointMake(92.05, 31.16) controlPoint2: CGPointMake(94.49, 31.33)];
                [bezier5Path addCurveToPoint: CGPointMake(97.47, 29.16) controlPoint1: CGPointMake(98.73, 31.88) controlPoint2: CGPointMake(99.65, 29.44)];
                [bezier5Path addCurveToPoint: CGPointMake(73.16, 28.75) controlPoint1: CGPointMake(89.52, 28.14) controlPoint2: CGPointMake(81.16, 28.09)];
                [bezier5Path addCurveToPoint: CGPointMake(52.3, 34.11) controlPoint1: CGPointMake(65.81, 29.36) controlPoint2: CGPointMake(58.79, 31.56)];
                [bezier5Path addCurveToPoint: CGPointMake(54.88, 35.21) controlPoint1: CGPointMake(53.16, 34.47) controlPoint2: CGPointMake(54.02, 34.84)];
                [bezier5Path addCurveToPoint: CGPointMake(51.97, 30.1) controlPoint1: CGPointMake(54.84, 33.39) controlPoint2: CGPointMake(53.48, 31.47)];
                [bezier5Path addCurveToPoint: CGPointMake(46.52, 27.74) controlPoint1: CGPointMake(50.69, 28.93) controlPoint2: CGPointMake(48.51, 28.05)];
                [bezier5Path addCurveToPoint: CGPointMake(45.62, 30.17) controlPoint1: CGPointMake(44.37, 27.4) controlPoint2: CGPointMake(43.46, 29.83)];
                [bezier5Path addLineToPoint: CGPointMake(45.62, 30.17)];
                [bezier5Path closePath];
                bezier5Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier5Path fill];
            }
        }
        
        
        //// Group 13
        {
            //// Group 14
            {
                //// Bezier 6 Drawing
                UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
                [bezier6Path moveToPoint: CGPointMake(38.05, 36.98)];
                [bezier6Path addCurveToPoint: CGPointMake(41.19, 41.36) controlPoint1: CGPointMake(39.26, 38.36) controlPoint2: CGPointMake(40.29, 39.85)];
                [bezier6Path addCurveToPoint: CGPointMake(42.43, 48.68) controlPoint1: CGPointMake(42.38, 43.36) controlPoint2: CGPointMake(43.96, 46.57)];
                [bezier6Path addCurveToPoint: CGPointMake(40.6, 50.02) controlPoint1: CGPointMake(42.08, 49.16) controlPoint2: CGPointMake(41.22, 49.61)];
                [bezier6Path addCurveToPoint: CGPointMake(37.26, 51.29) controlPoint1: CGPointMake(39.58, 50.67) controlPoint2: CGPointMake(38.55, 51.03)];
                [bezier6Path addCurveToPoint: CGPointMake(31.18, 51.66) controlPoint1: CGPointMake(35.31, 51.67) controlPoint2: CGPointMake(33.19, 51.76)];
                [bezier6Path addCurveToPoint: CGPointMake(31.16, 54.28) controlPoint1: CGPointMake(28.98, 51.56) controlPoint2: CGPointMake(28.97, 54.18)];
                [bezier6Path addCurveToPoint: CGPointMake(38.44, 53.76) controlPoint1: CGPointMake(33.57, 54.4) controlPoint2: CGPointMake(36.1, 54.22)];
                [bezier6Path addCurveToPoint: CGPointMake(45.39, 49.99) controlPoint1: CGPointMake(41.06, 53.24) controlPoint2: CGPointMake(43.93, 51.79)];
                [bezier6Path addCurveToPoint: CGPointMake(44.87, 41.36) controlPoint1: CGPointMake(47.41, 47.5) controlPoint2: CGPointMake(46.16, 43.87)];
                [bezier6Path addCurveToPoint: CGPointMake(40.99, 35.65) controlPoint1: CGPointMake(43.85, 39.37) controlPoint2: CGPointMake(42.55, 37.43)];
                [bezier6Path addCurveToPoint: CGPointMake(38.05, 36.98) controlPoint1: CGPointMake(39.77, 34.26) controlPoint2: CGPointMake(36.82, 35.57)];
                [bezier6Path addLineToPoint: CGPointMake(38.05, 36.98)];
                [bezier6Path closePath];
                bezier6Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier6Path fill];
            }
        }
        
        
        //// Group 15
        {
            //// Group 16
            {
                //// Bezier 7 Drawing
                UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
                [bezier7Path moveToPoint: CGPointMake(11.67, 16.56)];
                [bezier7Path addCurveToPoint: CGPointMake(22.54, 19.18) controlPoint1: CGPointMake(15.49, 16.58) controlPoint2: CGPointMake(19.1, 17.89)];
                [bezier7Path addCurveToPoint: CGPointMake(25.23, 18.55) controlPoint1: CGPointMake(23.52, 19.55) controlPoint2: CGPointMake(24.65, 19.43)];
                [bezier7Path addCurveToPoint: CGPointMake(24.51, 16.2) controlPoint1: CGPointMake(25.72, 17.81) controlPoint2: CGPointMake(25.5, 16.57)];
                [bezier7Path addCurveToPoint: CGPointMake(11.7, 13.12) controlPoint1: CGPointMake(20.42, 14.66) controlPoint2: CGPointMake(16.23, 13.14)];
                [bezier7Path addCurveToPoint: CGPointMake(11.67, 16.56) controlPoint1: CGPointMake(9.15, 13.11) controlPoint2: CGPointMake(9.13, 16.55)];
                [bezier7Path addLineToPoint: CGPointMake(11.67, 16.56)];
                [bezier7Path closePath];
                bezier7Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier7Path fill];
            }
        }
        
        
        //// Group 17
        {
            //// Group 18
            {
                //// Bezier 8 Drawing
                UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
                [bezier8Path moveToPoint: CGPointMake(6.63, 23.28)];
                [bezier8Path addCurveToPoint: CGPointMake(15.05, 24.82) controlPoint1: CGPointMake(9.23, 23.28) controlPoint2: CGPointMake(13.46, 23.5)];
                [bezier8Path addCurveToPoint: CGPointMake(17.76, 22.84) controlPoint1: CGPointMake(16.69, 26.16) controlPoint2: CGPointMake(19.39, 24.19)];
                [bezier8Path addCurveToPoint: CGPointMake(13.06, 21.08) controlPoint1: CGPointMake(16.62, 21.9) controlPoint2: CGPointMake(14.67, 21.4)];
                [bezier8Path addCurveToPoint: CGPointMake(6.66, 20.5) controlPoint1: CGPointMake(11.02, 20.67) controlPoint2: CGPointMake(8.78, 20.51)];
                [bezier8Path addCurveToPoint: CGPointMake(6.63, 23.28) controlPoint1: CGPointMake(4.17, 20.5) controlPoint2: CGPointMake(4.15, 23.27)];
                [bezier8Path addLineToPoint: CGPointMake(6.63, 23.28)];
                [bezier8Path closePath];
                bezier8Path.miterLimit = 4;
                
                [fillColor setFill];
                [bezier8Path fill];
            }
        }
        
        
        //// Group 19
        {
            //// Group 20
            {
                //// Bezier 9 Drawing
                UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
                [bezier9Path moveToPoint: CGPointMake(55.54, 29.71)];
                [bezier9Path addCurveToPoint: CGPointMake(68.14, 26.28) controlPoint1: CGPointMake(59.74, 28.57) controlPoint2: CGPointMake(63.94, 27.42)];
                [bezier9Path addCurveToPoint: CGPointMake(69, 23.76) controlPoint1: CGPointMake(69.49, 25.91) controlPoint2: CGPointMake(70.1, 24.61)];
                [bezier9Path addCurveToPoint: CGPointMake(66.16, 21.41) controlPoint1: CGPointMake(68.02, 23.01) controlPoint2: CGPointMake(67.08, 22.22)];
                [bezier9Path addCurveToPoint: CGPointMake(64.31, 19.65) controlPoint1: CGPointMake(65.51, 20.85) controlPoint2: CGPointMake(64.89, 20.27)];
                [bezier9Path addCurveToPoint: CGPointMake(63.58, 18.77) controlPoint1: CGPointMake(64.05, 19.37) controlPoint2: CGPointMake(63.81, 19.07)];
                [bezier9Path addCurveToPoint: CGPointMake(63.33, 18.38) controlPoint1: CGPointMake(63.49, 18.65) controlPoint2: CGPointMake(63.41, 18.51)];
                [bezier9Path addCurveToPoint: CGPointMake(63.37, 18.52) controlPoint1: CGPointMake(63.54, 18.75) controlPoint2: CGPointMake(63.34, 17.96)];
                [bezier9Path addCurveToPoint: CGPointMake(63.31, 18.77) controlPoint1: CGPointMake(63.4, 18.95) controlPoint2: CGPointMake(63.47, 18.51)];
                [bezier9Path addCurveToPoint: CGPointMake(63.55, 18.46) controlPoint1: CGPointMake(63.37, 18.66) controlPoint2: CGPointMake(63.46, 18.56)];
                [bezier9Path addCurveToPoint: CGPointMake(63.69, 18.35) controlPoint1: CGPointMake(63.31, 18.74) controlPoint2: CGPointMake(63.65, 18.38)];
                [bezier9Path addCurveToPoint: CGPointMake(64.1, 18.02) controlPoint1: CGPointMake(63.82, 18.24) controlPoint2: CGPointMake(63.96, 18.13)];
                [bezier9Path addCurveToPoint: CGPointMake(66.77, 16.18) controlPoint1: CGPointMake(64.96, 17.38) controlPoint2: CGPointMake(65.89, 16.8)];
                [bezier9Path addCurveToPoint: CGPointMake(73.78, 9.77) controlPoint1: CGPointMake(69.45, 14.3) controlPoint2: CGPointMake(71.92, 12.19)];
                [bezier9Path addCurveToPoint: CGPointMake(74.66, 4.12) controlPoint1: CGPointMake(75, 8.17) controlPoint2: CGPointMake(76.39, 5.8)];
                [bezier9Path addCurveToPoint: CGPointMake(69.66, 2.51) controlPoint1: CGPointMake(73.59, 3.08) controlPoint2: CGPointMake(71.21, 2.78)];
                [bezier9Path addCurveToPoint: CGPointMake(62.86, 1.73) controlPoint1: CGPointMake(67.43, 2.12) controlPoint2: CGPointMake(65.14, 1.85)];
                [bezier9Path addCurveToPoint: CGPointMake(58.69, 2.73) controlPoint1: CGPointMake(61.26, 1.65) controlPoint2: CGPointMake(59.84, 1.78)];
                [bezier9Path addCurveToPoint: CGPointMake(56.88, 4.76) controlPoint1: CGPointMake(57.97, 3.33) controlPoint2: CGPointMake(57.43, 4.07)];
                [bezier9Path addCurveToPoint: CGPointMake(53.81, 8.43) controlPoint1: CGPointMake(55.89, 6) controlPoint2: CGPointMake(54.9, 7.24)];
                [bezier9Path addCurveToPoint: CGPointMake(49.04, 12.71) controlPoint1: CGPointMake(52.4, 9.96) controlPoint2: CGPointMake(50.7, 11.35)];
                [bezier9Path addCurveToPoint: CGPointMake(52.09, 14.52) controlPoint1: CGPointMake(50.06, 13.31) controlPoint2: CGPointMake(51.07, 13.92)];
                [bezier9Path addCurveToPoint: CGPointMake(53.56, 1.36) controlPoint1: CGPointMake(54.51, 10.55) controlPoint2: CGPointMake(54.63, 5.59)];
                [bezier9Path addCurveToPoint: CGPointMake(51.71, 0.25) controlPoint1: CGPointMake(53.41, 0.75) controlPoint2: CGPointMake(52.52, 0.21)];
                [bezier9Path addCurveToPoint: CGPointMake(39.37, 0.82) controlPoint1: CGPointMake(47.6, 0.44) controlPoint2: CGPointMake(43.49, 0.63)];
                [bezier9Path addCurveToPoint: CGPointMake(37.43, 2.31) controlPoint1: CGPointMake(38.41, 0.87) controlPoint2: CGPointMake(37.33, 1.46)];
                [bezier9Path addCurveToPoint: CGPointMake(37.6, 10.59) controlPoint1: CGPointMake(37.76, 5.04) controlPoint2: CGPointMake(37.97, 7.86)];
                [bezier9Path addCurveToPoint: CGPointMake(37.4, 11.39) controlPoint1: CGPointMake(37.56, 10.82) controlPoint2: CGPointMake(37.49, 11.09)];
                [bezier9Path addCurveToPoint: CGPointMake(37.24, 11.8) controlPoint1: CGPointMake(37.36, 11.53) controlPoint2: CGPointMake(37.3, 11.66)];
                [bezier9Path addCurveToPoint: CGPointMake(37.17, 11.87) controlPoint1: CGPointMake(37.37, 11.5) controlPoint2: CGPointMake(37.22, 11.81)];
                [bezier9Path addCurveToPoint: CGPointMake(37.15, 11.89) controlPoint1: CGPointMake(36.96, 12.16) controlPoint2: CGPointMake(37.46, 11.62)];
                [bezier9Path addCurveToPoint: CGPointMake(36.82, 12.14) controlPoint1: CGPointMake(37.05, 11.98) controlPoint2: CGPointMake(36.93, 12.06)];
                [bezier9Path addCurveToPoint: CGPointMake(36.03, 12.61) controlPoint1: CGPointMake(36.56, 12.33) controlPoint2: CGPointMake(36.53, 12.34)];
                [bezier9Path addCurveToPoint: CGPointMake(30.33, 15.52) controlPoint1: CGPointMake(34.17, 13.62) controlPoint2: CGPointMake(32.19, 14.49)];
                [bezier9Path addCurveToPoint: CGPointMake(23.63, 20.24) controlPoint1: CGPointMake(27.86, 16.87) controlPoint2: CGPointMake(25.56, 18.42)];
                [bezier9Path addCurveToPoint: CGPointMake(18.54, 27.27) controlPoint1: CGPointMake(21.4, 22.34) controlPoint2: CGPointMake(19.81, 24.75)];
                [bezier9Path addCurveToPoint: CGPointMake(15.67, 40.76) controlPoint1: CGPointMake(16.42, 31.45) controlPoint2: CGPointMake(15.25, 36.26)];
                [bezier9Path addCurveToPoint: CGPointMake(20.14, 49.81) controlPoint1: CGPointMake(15.97, 43.97) controlPoint2: CGPointMake(16.65, 47.74)];
                [bezier9Path addCurveToPoint: CGPointMake(28.22, 50.82) controlPoint1: CGPointMake(22.35, 51.12) controlPoint2: CGPointMake(25.61, 51.13)];
                [bezier9Path addCurveToPoint: CGPointMake(33.76, 48.15) controlPoint1: CGPointMake(30.46, 50.56) controlPoint2: CGPointMake(32.7, 49.8)];
                [bezier9Path addCurveToPoint: CGPointMake(34.28, 43.38) controlPoint1: CGPointMake(34.71, 46.67) controlPoint2: CGPointMake(34.54, 44.97)];
                [bezier9Path addCurveToPoint: CGPointMake(33.66, 37.72) controlPoint1: CGPointMake(33.98, 41.5) controlPoint2: CGPointMake(33.56, 39.63)];
                [bezier9Path addCurveToPoint: CGPointMake(36.78, 31.49) controlPoint1: CGPointMake(33.78, 35.38) controlPoint2: CGPointMake(35.29, 33.47)];
                [bezier9Path addCurveToPoint: CGPointMake(41.03, 27.24) controlPoint1: CGPointMake(37.96, 29.94) controlPoint2: CGPointMake(39.23, 28.41)];
                [bezier9Path addCurveToPoint: CGPointMake(43.82, 26.08) controlPoint1: CGPointMake(41.68, 26.83) controlPoint2: CGPointMake(43.01, 26.32)];
                [bezier9Path addCurveToPoint: CGPointMake(48.5, 25.41) controlPoint1: CGPointMake(45.3, 25.65) controlPoint2: CGPointMake(46.9, 25.15)];
                [bezier9Path addCurveToPoint: CGPointMake(51.9, 27.05) controlPoint1: CGPointMake(49.85, 25.64) controlPoint2: CGPointMake(50.95, 26.3)];
                [bezier9Path addCurveToPoint: CGPointMake(52.46, 27.54) controlPoint1: CGPointMake(52.09, 27.2) controlPoint2: CGPointMake(52.28, 27.37)];
                [bezier9Path addCurveToPoint: CGPointMake(52.77, 27.84) controlPoint1: CGPointMake(52.83, 27.87) controlPoint2: CGPointMake(52.49, 27.54)];
                [bezier9Path addCurveToPoint: CGPointMake(53.12, 28.26) controlPoint1: CGPointMake(52.89, 27.98) controlPoint2: CGPointMake(53.01, 28.12)];
                [bezier9Path addCurveToPoint: CGPointMake(56.45, 26.74) controlPoint1: CGPointMake(54.39, 29.92) controlPoint2: CGPointMake(57.72, 28.41)];
                [bezier9Path addCurveToPoint: CGPointMake(46.56, 22.39) controlPoint1: CGPointMake(54.45, 24.12) controlPoint2: CGPointMake(50.6, 22)];
                [bezier9Path addCurveToPoint: CGPointMake(35.46, 27.58) controlPoint1: CGPointMake(42.01, 22.83) controlPoint2: CGPointMake(38.15, 24.77)];
                [bezier9Path addCurveToPoint: CGPointMake(30.76, 33.96) controlPoint1: CGPointMake(33.6, 29.51) controlPoint2: CGPointMake(31.94, 31.74)];
                [bezier9Path addCurveToPoint: CGPointMake(29.88, 40.06) controlPoint1: CGPointMake(29.74, 35.87) controlPoint2: CGPointMake(29.66, 38.04)];
                [bezier9Path addCurveToPoint: CGPointMake(30.63, 45.31) controlPoint1: CGPointMake(30.08, 41.81) controlPoint2: CGPointMake(30.58, 43.54)];
                [bezier9Path addCurveToPoint: CGPointMake(28.73, 47.67) controlPoint1: CGPointMake(30.66, 46.61) controlPoint2: CGPointMake(30.36, 47.27)];
                [bezier9Path addCurveToPoint: CGPointMake(22.09, 47.22) controlPoint1: CGPointMake(26.77, 48.16) controlPoint2: CGPointMake(23.71, 48.27)];
                [bezier9Path addCurveToPoint: CGPointMake(20.04, 43.47) controlPoint1: CGPointMake(20.72, 46.33) controlPoint2: CGPointMake(20.37, 44.88)];
                [bezier9Path addCurveToPoint: CGPointMake(20.58, 32.27) controlPoint1: CGPointMake(19.19, 39.8) controlPoint2: CGPointMake(19.43, 36.07)];
                [bezier9Path addCurveToPoint: CGPointMake(30.27, 19.3) controlPoint1: CGPointMake(22.11, 27.21) controlPoint2: CGPointMake(25.13, 22.68)];
                [bezier9Path addCurveToPoint: CGPointMake(36.43, 15.99) controlPoint1: CGPointMake(32.18, 18.05) controlPoint2: CGPointMake(34.32, 17.02)];
                [bezier9Path addCurveToPoint: CGPointMake(40.51, 13.37) controlPoint1: CGPointMake(37.9, 15.26) controlPoint2: CGPointMake(39.52, 14.52)];
                [bezier9Path addCurveToPoint: CGPointMake(41.45, 10.61) controlPoint1: CGPointMake(41.19, 12.59) controlPoint2: CGPointMake(41.31, 11.51)];
                [bezier9Path addCurveToPoint: CGPointMake(41.61, 6.99) controlPoint1: CGPointMake(41.64, 9.41) controlPoint2: CGPointMake(41.64, 8.19)];
                [bezier9Path addCurveToPoint: CGPointMake(41.29, 2.33) controlPoint1: CGPointMake(41.58, 5.44) controlPoint2: CGPointMake(41.47, 3.88)];
                [bezier9Path addCurveToPoint: CGPointMake(39.34, 3.82) controlPoint1: CGPointMake(40.64, 2.83) controlPoint2: CGPointMake(39.99, 3.33)];
                [bezier9Path addCurveToPoint: CGPointMake(51.69, 3.25) controlPoint1: CGPointMake(43.46, 3.63) controlPoint2: CGPointMake(47.57, 3.44)];
                [bezier9Path addCurveToPoint: CGPointMake(49.84, 2.14) controlPoint1: CGPointMake(51.07, 2.88) controlPoint2: CGPointMake(50.45, 2.51)];
                [bezier9Path addCurveToPoint: CGPointMake(50.09, 8.87) controlPoint1: CGPointMake(50.39, 4.35) controlPoint2: CGPointMake(50.42, 6.63)];
                [bezier9Path addCurveToPoint: CGPointMake(49.17, 12.09) controlPoint1: CGPointMake(49.93, 9.96) controlPoint2: CGPointMake(49.59, 11.04)];
                [bezier9Path addCurveToPoint: CGPointMake(48.79, 12.94) controlPoint1: CGPointMake(49.06, 12.38) controlPoint2: CGPointMake(48.93, 12.66)];
                [bezier9Path addCurveToPoint: CGPointMake(48.74, 13.02) controlPoint1: CGPointMake(48.66, 13.2) controlPoint2: CGPointMake(48.96, 12.67)];
                [bezier9Path addCurveToPoint: CGPointMake(51.79, 14.82) controlPoint1: CGPointMake(47.84, 14.49) controlPoint2: CGPointMake(50.2, 16.12)];
                [bezier9Path addCurveToPoint: CGPointMake(55.85, 11.24) controlPoint1: CGPointMake(53.19, 13.67) controlPoint2: CGPointMake(54.56, 12.48)];
                [bezier9Path addCurveToPoint: CGPointMake(60.77, 5.58) controlPoint1: CGPointMake(57.7, 9.47) controlPoint2: CGPointMake(59.2, 7.51)];
                [bezier9Path addCurveToPoint: CGPointMake(61.23, 5.02) controlPoint1: CGPointMake(60.87, 5.46) controlPoint2: CGPointMake(61.44, 4.82)];
                [bezier9Path addCurveToPoint: CGPointMake(61.52, 4.74) controlPoint1: CGPointMake(61.35, 4.91) controlPoint2: CGPointMake(61.99, 4.48)];
                [bezier9Path addCurveToPoint: CGPointMake(61.46, 4.73) controlPoint1: CGPointMake(61.63, 4.68) controlPoint2: CGPointMake(62, 4.55)];
                [bezier9Path addCurveToPoint: CGPointMake(61.31, 4.72) controlPoint1: CGPointMake(61.58, 4.68) controlPoint2: CGPointMake(61.91, 4.67)];
                [bezier9Path addCurveToPoint: CGPointMake(62.42, 4.71) controlPoint1: CGPointMake(61.68, 4.69) controlPoint2: CGPointMake(62.06, 4.7)];
                [bezier9Path addCurveToPoint: CGPointMake(68.64, 5.4) controlPoint1: CGPointMake(64.51, 4.77) controlPoint2: CGPointMake(66.6, 5.05)];
                [bezier9Path addCurveToPoint: CGPointMake(71.43, 6.01) controlPoint1: CGPointMake(69.58, 5.56) controlPoint2: CGPointMake(70.52, 5.75)];
                [bezier9Path addCurveToPoint: CGPointMake(71.64, 6.09) controlPoint1: CGPointMake(72.01, 6.18) controlPoint2: CGPointMake(71.14, 5.9)];
                [bezier9Path addCurveToPoint: CGPointMake(72.02, 6.25) controlPoint1: CGPointMake(71.77, 6.13) controlPoint2: CGPointMake(71.89, 6.19)];
                [bezier9Path addCurveToPoint: CGPointMake(71.72, 6.05) controlPoint1: CGPointMake(71.68, 6.09) controlPoint2: CGPointMake(71.92, 6.31)];
                [bezier9Path addCurveToPoint: CGPointMake(71.61, 6.15) controlPoint1: CGPointMake(71.51, 5.78) controlPoint2: CGPointMake(71.63, 5.83)];
                [bezier9Path addCurveToPoint: CGPointMake(70.24, 8.53) controlPoint1: CGPointMake(71.55, 6.89) controlPoint2: CGPointMake(70.75, 7.86)];
                [bezier9Path addCurveToPoint: CGPointMake(66.7, 12.04) controlPoint1: CGPointMake(69.25, 9.81) controlPoint2: CGPointMake(68.02, 10.95)];
                [bezier9Path addCurveToPoint: CGPointMake(60.95, 16.24) controlPoint1: CGPointMake(64.89, 13.53) controlPoint2: CGPointMake(62.76, 14.76)];
                [bezier9Path addCurveToPoint: CGPointMake(60.16, 20.16) controlPoint1: CGPointMake(59.5, 17.42) controlPoint2: CGPointMake(59.21, 18.7)];
                [bezier9Path addCurveToPoint: CGPointMake(66.29, 25.9) controlPoint1: CGPointMake(61.57, 22.31) controlPoint2: CGPointMake(64.1, 24.21)];
                [bezier9Path addCurveToPoint: CGPointMake(67.14, 23.38) controlPoint1: CGPointMake(66.57, 25.06) controlPoint2: CGPointMake(66.86, 24.22)];
                [bezier9Path addCurveToPoint: CGPointMake(54.54, 26.81) controlPoint1: CGPointMake(62.94, 24.52) controlPoint2: CGPointMake(58.74, 25.67)];
                [bezier9Path addCurveToPoint: CGPointMake(55.54, 29.71) controlPoint1: CGPointMake(52.21, 27.45) controlPoint2: CGPointMake(53.19, 30.35)];
                [bezier9Path addLineToPoint: CGPointMake(55.54, 29.71)];
                [bezier9Path closePath];
                bezier9Path.miterLimit = 4;
                
                [fillColor2 setFill];
                [bezier9Path fill];
            }
        }
    }
}

@end
