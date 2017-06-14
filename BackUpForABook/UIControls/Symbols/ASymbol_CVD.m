//
//  ASymbol_CVD.m
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_CVD.h"

@interface ASymbol_CVD (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbol_CVD

@synthesize fillColor, fillColor2;

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(100, 100);
    
    fillColor = [UIColor colorWithRed: 0.231 green: 0.275 blue: 0.325 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 0.729 green: 0.125 blue: 0.192 alpha: 1];
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_CVD* draw = [[ASymbol_CVD alloc] init];
    [draw initDrawPros];
    
    APathDrawWrap* warp = [[APathDrawWrap alloc] initWith:CGRectMake(0, 0, draw.pathRefSize.x, draw.pathRefSize.y) pathDraw:draw];
    
    return warp;
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    [self drawPath];
    
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
-(void) drawPath
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


@end
