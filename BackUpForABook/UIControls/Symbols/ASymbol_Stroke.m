//
//  ASymbol_Stroke.m
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Stroke.h"

@interface ASymbol_Stroke (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbol_Stroke

@synthesize fillColor, fillColor2;

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(100, 100);
    
    fillColor = [UIColor colorWithRed: 0.224 green: 0.275 blue: 0.322 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 0.729 green: 0.125 blue: 0.192 alpha: 1];
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_Stroke* draw = [[ASymbol_Stroke alloc] init];
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

-(void) drawPath
{
    //// Group 3
    {
        //// Group 4
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(52.85, 97.02)];
            [bezierPath addCurveToPoint: CGPointMake(45.76, 84.28) controlPoint1: CGPointMake(50.49, 92.77) controlPoint2: CGPointMake(48.12, 88.53)];
            [bezierPath addCurveToPoint: CGPointMake(43.33, 83.71) controlPoint1: CGPointMake(45.29, 83.45) controlPoint2: CGPointMake(44.16, 83.37)];
            [bezierPath addCurveToPoint: CGPointMake(37.05, 86.01) controlPoint1: CGPointMake(41.15, 84.61) controlPoint2: CGPointMake(39.46, 85.21)];
            [bezierPath addCurveToPoint: CGPointMake(25.83, 88.53) controlPoint1: CGPointMake(33.48, 87.18) controlPoint2: CGPointMake(29.54, 88.41)];
            [bezierPath addCurveToPoint: CGPointMake(24.72, 88.51) controlPoint1: CGPointMake(25.46, 88.54) controlPoint2: CGPointMake(25.09, 88.53)];
            [bezierPath addCurveToPoint: CGPointMake(24.04, 88.4) controlPoint1: CGPointMake(24.29, 88.48) controlPoint2: CGPointMake(24.55, 88.51)];
            [bezierPath addCurveToPoint: CGPointMake(23.62, 88.28) controlPoint1: CGPointMake(23.9, 88.37) controlPoint2: CGPointMake(23.76, 88.33)];
            [bezierPath addCurveToPoint: CGPointMake(23.54, 88.23) controlPoint1: CGPointMake(24.01, 88.4) controlPoint2: CGPointMake(23.61, 88.26)];
            [bezierPath addCurveToPoint: CGPointMake(23.47, 88.2) controlPoint1: CGPointMake(23.45, 88.18) controlPoint2: CGPointMake(23.13, 87.94)];
            [bezierPath addCurveToPoint: CGPointMake(22.43, 87.27) controlPoint1: CGPointMake(23.1, 87.92) controlPoint2: CGPointMake(22.76, 87.6)];
            [bezierPath addCurveToPoint: CGPointMake(19.43, 81.85) controlPoint1: CGPointMake(20.9, 85.78) controlPoint2: CGPointMake(19.97, 83.8)];
            [bezierPath addCurveToPoint: CGPointMake(19.21, 80.86) controlPoint1: CGPointMake(19.34, 81.52) controlPoint2: CGPointMake(19.26, 81.19)];
            [bezierPath addCurveToPoint: CGPointMake(18, 79.5) controlPoint1: CGPointMake(19.13, 80.32) controlPoint2: CGPointMake(18.41, 79.85)];
            [bezierPath addCurveToPoint: CGPointMake(13.75, 75.93) controlPoint1: CGPointMake(16.59, 78.3) controlPoint2: CGPointMake(15.18, 77.1)];
            [bezierPath addCurveToPoint: CGPointMake(12.49, 74.93) controlPoint1: CGPointMake(13.34, 75.59) controlPoint2: CGPointMake(12.92, 75.25)];
            [bezierPath addCurveToPoint: CGPointMake(12.35, 74.83) controlPoint1: CGPointMake(12.45, 74.89) controlPoint2: CGPointMake(12.4, 74.86)];
            [bezierPath addCurveToPoint: CGPointMake(12.72, 75.65) controlPoint1: CGPointMake(12.48, 75.1) controlPoint2: CGPointMake(12.6, 75.38)];
            [bezierPath addCurveToPoint: CGPointMake(12.72, 75.7) controlPoint1: CGPointMake(12.67, 75.87) controlPoint2: CGPointMake(12.67, 75.89)];
            [bezierPath addCurveToPoint: CGPointMake(12.74, 75.64) controlPoint1: CGPointMake(12.78, 75.54) controlPoint2: CGPointMake(12.79, 75.52)];
            [bezierPath addCurveToPoint: CGPointMake(13.03, 75.15) controlPoint1: CGPointMake(12.82, 75.47) controlPoint2: CGPointMake(12.93, 75.31)];
            [bezierPath addCurveToPoint: CGPointMake(14.29, 73.64) controlPoint1: CGPointMake(13.38, 74.6) controlPoint2: CGPointMake(13.82, 74.11)];
            [bezierPath addCurveToPoint: CGPointMake(15, 73) controlPoint1: CGPointMake(14.51, 73.41) controlPoint2: CGPointMake(14.75, 73.21)];
            [bezierPath addCurveToPoint: CGPointMake(15.08, 72.95) controlPoint1: CGPointMake(15.38, 72.69) controlPoint2: CGPointMake(14.74, 73.15)];
            [bezierPath addCurveToPoint: CGPointMake(14.46, 73.09) controlPoint1: CGPointMake(14.94, 73.04) controlPoint2: CGPointMake(14.56, 73.09)];
            [bezierPath addCurveToPoint: CGPointMake(14.94, 69.97) controlPoint1: CGPointMake(16.54, 72.94) controlPoint2: CGPointMake(16.8, 70.65)];
            [bezierPath addCurveToPoint: CGPointMake(13.44, 69.82) controlPoint1: CGPointMake(14.54, 69.82) controlPoint2: CGPointMake(13.87, 69.86)];
            [bezierPath addCurveToPoint: CGPointMake(11.01, 69.45) controlPoint1: CGPointMake(12.62, 69.74) controlPoint2: CGPointMake(11.88, 69.64)];
            [bezierPath addCurveToPoint: CGPointMake(10.2, 69.2) controlPoint1: CGPointMake(10.64, 69.36) controlPoint2: CGPointMake(10.31, 69.25)];
            [bezierPath addCurveToPoint: CGPointMake(10.34, 69.39) controlPoint1: CGPointMake(9.88, 69.05) controlPoint2: CGPointMake(10.28, 69.3)];
            [bezierPath addCurveToPoint: CGPointMake(10.5, 69.92) controlPoint1: CGPointMake(10.4, 69.57) controlPoint2: CGPointMake(10.45, 69.75)];
            [bezierPath addCurveToPoint: CGPointMake(10.49, 69.95) controlPoint1: CGPointMake(10.51, 69.76) controlPoint2: CGPointMake(10.51, 69.77)];
            [bezierPath addCurveToPoint: CGPointMake(11.55, 67.72) controlPoint1: CGPointMake(10.65, 69.17) controlPoint2: CGPointMake(11.16, 68.43)];
            [bezierPath addCurveToPoint: CGPointMake(12.42, 62.77) controlPoint1: CGPointMake(12.29, 66.39) controlPoint2: CGPointMake(13.95, 64.13)];
            [bezierPath addCurveToPoint: CGPointMake(10.72, 62.02) controlPoint1: CGPointMake(11.97, 62.37) controlPoint2: CGPointMake(11.3, 62.21)];
            [bezierPath addCurveToPoint: CGPointMake(8.36, 61.19) controlPoint1: CGPointMake(9.93, 61.74) controlPoint2: CGPointMake(9.14, 61.47)];
            [bezierPath addCurveToPoint: CGPointMake(5.93, 60.21) controlPoint1: CGPointMake(7.53, 60.89) controlPoint2: CGPointMake(6.73, 60.56)];
            [bezierPath addCurveToPoint: CGPointMake(3.8, 59.08) controlPoint1: CGPointMake(5.22, 59.9) controlPoint2: CGPointMake(4.2, 59.38)];
            [bezierPath addCurveToPoint: CGPointMake(3.46, 58.78) controlPoint1: CGPointMake(3.68, 58.98) controlPoint2: CGPointMake(3.57, 58.88)];
            [bezierPath addCurveToPoint: CGPointMake(3.43, 58.71) controlPoint1: CGPointMake(3.72, 59.03) controlPoint2: CGPointMake(3.48, 58.8)];
            [bezierPath addCurveToPoint: CGPointMake(3.51, 59.37) controlPoint1: CGPointMake(3.57, 58.94) controlPoint2: CGPointMake(3.56, 59.12)];
            [bezierPath addCurveToPoint: CGPointMake(3.5, 59.43) controlPoint1: CGPointMake(3.45, 59.65) controlPoint2: CGPointMake(3.4, 59.59)];
            [bezierPath addCurveToPoint: CGPointMake(4.41, 58.32) controlPoint1: CGPointMake(3.92, 58.82) controlPoint2: CGPointMake(3.98, 58.81)];
            [bezierPath addCurveToPoint: CGPointMake(12.25, 49.03) controlPoint1: CGPointMake(7.09, 55.27) controlPoint2: CGPointMake(9.91, 52.31)];
            [bezierPath addCurveToPoint: CGPointMake(14.63, 44.48) controlPoint1: CGPointMake(13.25, 47.64) controlPoint2: CGPointMake(14.24, 46.11)];
            [bezierPath addCurveToPoint: CGPointMake(14.34, 40.78) controlPoint1: CGPointMake(14.93, 43.24) controlPoint2: CGPointMake(14.62, 42)];
            [bezierPath addCurveToPoint: CGPointMake(12.6, 30.28) controlPoint1: CGPointMake(13.53, 37.3) controlPoint2: CGPointMake(12.69, 33.85)];
            [bezierPath addCurveToPoint: CGPointMake(16.85, 18.1) controlPoint1: CGPointMake(12.5, 25.91) controlPoint2: CGPointMake(13.62, 21.48)];
            [bezierPath addCurveToPoint: CGPointMake(26.1, 11.19) controlPoint1: CGPointMake(19.4, 15.42) controlPoint2: CGPointMake(22.88, 13.18)];
            [bezierPath addCurveToPoint: CGPointMake(52.64, 3.18) controlPoint1: CGPointMake(33.96, 6.33) controlPoint2: CGPointMake(43.03, 3.26)];
            [bezierPath addCurveToPoint: CGPointMake(70.56, 6.27) controlPoint1: CGPointMake(58.79, 3.13) controlPoint2: CGPointMake(64.83, 4.34)];
            [bezierPath addCurveToPoint: CGPointMake(85.75, 14.08) controlPoint1: CGPointMake(75.99, 8.1) controlPoint2: CGPointMake(81.39, 10.6)];
            [bezierPath addCurveToPoint: CGPointMake(95.58, 32.9) controlPoint1: CGPointMake(91.83, 18.94) controlPoint2: CGPointMake(95.11, 25.67)];
            [bezierPath addCurveToPoint: CGPointMake(91.58, 53.48) controlPoint1: CGPointMake(96.04, 39.92) controlPoint2: CGPointMake(94.2, 46.91)];
            [bezierPath addCurveToPoint: CGPointMake(83.37, 68.98) controlPoint1: CGPointMake(89.42, 58.85) controlPoint2: CGPointMake(86.6, 64.03)];
            [bezierPath addCurveToPoint: CGPointMake(80.6, 72.97) controlPoint1: CGPointMake(82.48, 70.33) controlPoint2: CGPointMake(81.57, 71.67)];
            [bezierPath addCurveToPoint: CGPointMake(80.08, 73.66) controlPoint1: CGPointMake(80.43, 73.2) controlPoint2: CGPointMake(80.26, 73.43)];
            [bezierPath addCurveToPoint: CGPointMake(80.14, 75.63) controlPoint1: CGPointMake(79.6, 74.28) controlPoint2: CGPointMake(79.92, 75)];
            [bezierPath addCurveToPoint: CGPointMake(84.82, 87.31) controlPoint1: CGPointMake(81.48, 79.59) controlPoint2: CGPointMake(83.03, 83.49)];
            [bezierPath addCurveToPoint: CGPointMake(88.38, 93.66) controlPoint1: CGPointMake(85.84, 89.49) controlPoint2: CGPointMake(86.97, 91.66)];
            [bezierPath addCurveToPoint: CGPointMake(92.97, 97.66) controlPoint1: CGPointMake(89.54, 95.31) controlPoint2: CGPointMake(90.92, 96.9)];
            [bezierPath addCurveToPoint: CGPointMake(95.15, 96.55) controlPoint1: CGPointMake(93.86, 98) controlPoint2: CGPointMake(94.91, 97.31)];
            [bezierPath addCurveToPoint: CGPointMake(93.9, 94.59) controlPoint1: CGPointMake(95.43, 95.63) controlPoint2: CGPointMake(94.79, 94.92)];
            [bezierPath addCurveToPoint: CGPointMake(93.55, 94.36) controlPoint1: CGPointMake(94.3, 94.74) controlPoint2: CGPointMake(93.38, 94.23)];
            [bezierPath addCurveToPoint: CGPointMake(92.53, 93.43) controlPoint1: CGPointMake(93.17, 94.09) controlPoint2: CGPointMake(92.84, 93.76)];
            [bezierPath addCurveToPoint: CGPointMake(90.65, 90.87) controlPoint1: CGPointMake(91.96, 92.84) controlPoint2: CGPointMake(91.21, 91.75)];
            [bezierPath addCurveToPoint: CGPointMake(87.01, 83.75) controlPoint1: CGPointMake(89.21, 88.6) controlPoint2: CGPointMake(88.07, 86.18)];
            [bezierPath addCurveToPoint: CGPointMake(83.32, 74.06) controlPoint1: CGPointMake(85.62, 80.57) controlPoint2: CGPointMake(84.38, 77.34)];
            [bezierPath addCurveToPoint: CGPointMake(83.14, 75.27) controlPoint1: CGPointMake(83.26, 74.47) controlPoint2: CGPointMake(83.2, 74.87)];
            [bezierPath addCurveToPoint: CGPointMake(87.98, 68.14) controlPoint1: CGPointMake(84.92, 73) controlPoint2: CGPointMake(86.49, 70.57)];
            [bezierPath addCurveToPoint: CGPointMake(96.32, 50.76) controlPoint1: CGPointMake(91.37, 62.62) controlPoint2: CGPointMake(94.25, 56.8)];
            [bezierPath addCurveToPoint: CGPointMake(98.71, 29.34) controlPoint1: CGPointMake(98.69, 43.85) controlPoint2: CGPointMake(99.88, 36.54)];
            [bezierPath addCurveToPoint: CGPointMake(86.08, 10.21) controlPoint1: CGPointMake(97.47, 21.7) controlPoint2: CGPointMake(92.88, 14.91)];
            [bezierPath addCurveToPoint: CGPointMake(69.18, 2.46) controlPoint1: CGPointMake(81.06, 6.74) controlPoint2: CGPointMake(75.15, 4.27)];
            [bezierPath addCurveToPoint: CGPointMake(51.36, 0.02) controlPoint1: CGPointMake(63.46, 0.73) controlPoint2: CGPointMake(57.39, -0.15)];
            [bezierPath addCurveToPoint: CGPointMake(24.3, 8.44) controlPoint1: CGPointMake(41.6, 0.3) controlPoint2: CGPointMake(32.3, 3.54)];
            [bezierPath addCurveToPoint: CGPointMake(14.77, 15.41) controlPoint1: CGPointMake(20.96, 10.49) controlPoint2: CGPointMake(17.56, 12.78)];
            [bezierPath addCurveToPoint: CGPointMake(9.1, 28.2) controlPoint1: CGPointMake(11.09, 18.88) controlPoint2: CGPointMake(9.41, 23.5)];
            [bezierPath addCurveToPoint: CGPointMake(10.51, 39.93) controlPoint1: CGPointMake(8.83, 32.14) controlPoint2: CGPointMake(9.59, 36.09)];
            [bezierPath addCurveToPoint: CGPointMake(10.98, 41.9) controlPoint1: CGPointMake(10.66, 40.59) controlPoint2: CGPointMake(10.83, 41.24)];
            [bezierPath addCurveToPoint: CGPointMake(11.15, 42.72) controlPoint1: CGPointMake(11.04, 42.17) controlPoint2: CGPointMake(11.09, 42.44)];
            [bezierPath addCurveToPoint: CGPointMake(11.21, 43.07) controlPoint1: CGPointMake(11.17, 42.83) controlPoint2: CGPointMake(11.19, 42.95)];
            [bezierPath addCurveToPoint: CGPointMake(11.22, 43.17) controlPoint1: CGPointMake(11.13, 42.6) controlPoint2: CGPointMake(11.21, 43.07)];
            [bezierPath addCurveToPoint: CGPointMake(11.22, 43.51) controlPoint1: CGPointMake(11.23, 43.28) controlPoint2: CGPointMake(11.23, 43.39)];
            [bezierPath addCurveToPoint: CGPointMake(11.21, 43.64) controlPoint1: CGPointMake(11.21, 43.93) controlPoint2: CGPointMake(11.3, 43.19)];
            [bezierPath addCurveToPoint: CGPointMake(10.92, 44.55) controlPoint1: CGPointMake(11.15, 43.95) controlPoint2: CGPointMake(11.03, 44.26)];
            [bezierPath addCurveToPoint: CGPointMake(9.71, 46.66) controlPoint1: CGPointMake(10.68, 45.14) controlPoint2: CGPointMake(10.15, 46)];
            [bezierPath addCurveToPoint: CGPointMake(2.12, 55.81) controlPoint1: CGPointMake(7.56, 49.94) controlPoint2: CGPointMake(4.76, 52.84)];
            [bezierPath addCurveToPoint: CGPointMake(0, 59.12) controlPoint1: CGPointMake(1.28, 56.76) controlPoint2: CGPointMake(0.05, 57.84)];
            [bezierPath addCurveToPoint: CGPointMake(3.34, 62.58) controlPoint1: CGPointMake(-0.06, 60.78) controlPoint2: CGPointMake(1.95, 61.89)];
            [bezierPath addCurveToPoint: CGPointMake(8.81, 64.75) controlPoint1: CGPointMake(5.07, 63.46) controlPoint2: CGPointMake(6.96, 64.11)];
            [bezierPath addCurveToPoint: CGPointMake(9.78, 65.09) controlPoint1: CGPointMake(9.14, 64.87) controlPoint2: CGPointMake(9.46, 64.98)];
            [bezierPath addCurveToPoint: CGPointMake(10.1, 65.19) controlPoint1: CGPointMake(9.93, 65.14) controlPoint2: CGPointMake(10.72, 65.43)];
            [bezierPath addCurveToPoint: CGPointMake(9.53, 64.44) controlPoint1: CGPointMake(10.58, 65.37) controlPoint2: CGPointMake(9.93, 65.33)];
            [bezierPath addCurveToPoint: CGPointMake(9.48, 64.15) controlPoint1: CGPointMake(9.49, 64.35) controlPoint2: CGPointMake(9.57, 63.81)];
            [bezierPath addCurveToPoint: CGPointMake(9.03, 65.13) controlPoint1: CGPointMake(9.37, 64.54) controlPoint2: CGPointMake(9.24, 64.74)];
            [bezierPath addCurveToPoint: CGPointMake(6.96, 70.01) controlPoint1: CGPointMake(8.28, 66.54) controlPoint2: CGPointMake(6.79, 68.36)];
            [bezierPath addCurveToPoint: CGPointMake(11.36, 72.76) controlPoint1: CGPointMake(7.17, 71.96) controlPoint2: CGPointMake(9.55, 72.48)];
            [bezierPath addCurveToPoint: CGPointMake(13.42, 73) controlPoint1: CGPointMake(12.04, 72.86) controlPoint2: CGPointMake(12.73, 72.94)];
            [bezierPath addCurveToPoint: CGPointMake(14.13, 73.06) controlPoint1: CGPointMake(13.65, 73.03) controlPoint2: CGPointMake(13.89, 73.05)];
            [bezierPath addCurveToPoint: CGPointMake(14, 73.04) controlPoint1: CGPointMake(14.48, 73.09) controlPoint2: CGPointMake(14.52, 73.23)];
            [bezierPath addCurveToPoint: CGPointMake(14.49, 69.91) controlPoint1: CGPointMake(14.16, 71.99) controlPoint2: CGPointMake(14.33, 70.95)];
            [bezierPath addCurveToPoint: CGPointMake(10.75, 72.53) controlPoint1: CGPointMake(12.82, 70.03) controlPoint2: CGPointMake(11.69, 71.41)];
            [bezierPath addCurveToPoint: CGPointMake(9.86, 77.09) controlPoint1: CGPointMake(9.72, 73.74) controlPoint2: CGPointMake(8.31, 75.73)];
            [bezierPath addCurveToPoint: CGPointMake(16.24, 82.4) controlPoint1: CGPointMake(11.92, 78.91) controlPoint2: CGPointMake(14.15, 80.6)];
            [bezierPath addCurveToPoint: CGPointMake(15.78, 81.68) controlPoint1: CGPointMake(16.09, 82.16) controlPoint2: CGPointMake(15.93, 81.92)];
            [bezierPath addCurveToPoint: CGPointMake(20.7, 90.24) controlPoint1: CGPointMake(16.26, 84.85) controlPoint2: CGPointMake(18.16, 88.04)];
            [bezierPath addCurveToPoint: CGPointMake(29.48, 91.31) controlPoint1: CGPointMake(23.02, 92.25) controlPoint2: CGPointMake(26.6, 91.8)];
            [bezierPath addCurveToPoint: CGPointMake(45.12, 86.46) controlPoint1: CGPointMake(34.86, 90.4) controlPoint2: CGPointMake(40.16, 88.51)];
            [bezierPath addCurveToPoint: CGPointMake(42.7, 85.89) controlPoint1: CGPointMake(44.31, 86.27) controlPoint2: CGPointMake(43.5, 86.08)];
            [bezierPath addCurveToPoint: CGPointMake(49.79, 98.63) controlPoint1: CGPointMake(45.06, 90.14) controlPoint2: CGPointMake(47.43, 94.39)];
            [bezierPath addCurveToPoint: CGPointMake(52.85, 97.02) controlPoint1: CGPointMake(50.82, 100.47) controlPoint2: CGPointMake(53.87, 98.85)];
            [bezierPath addLineToPoint: CGPointMake(52.85, 97.02)];
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
            [bezier2Path moveToPoint: CGPointMake(71.09, 92.21)];
            [bezier2Path addCurveToPoint: CGPointMake(67.76, 83.49) controlPoint1: CGPointMake(69.35, 89.58) controlPoint2: CGPointMake(68.37, 86.51)];
            [bezier2Path addCurveToPoint: CGPointMake(69.81, 66.58) controlPoint1: CGPointMake(66.62, 77.79) controlPoint2: CGPointMake(68.03, 72.05)];
            [bezier2Path addCurveToPoint: CGPointMake(71.47, 60.76) controlPoint1: CGPointMake(70.43, 64.66) controlPoint2: CGPointMake(71.17, 62.75)];
            [bezier2Path addCurveToPoint: CGPointMake(70.34, 55.94) controlPoint1: CGPointMake(71.73, 59.07) controlPoint2: CGPointMake(71.07, 57.48)];
            [bezier2Path addCurveToPoint: CGPointMake(58.58, 46.08) controlPoint1: CGPointMake(68.18, 51.31) controlPoint2: CGPointMake(64.4, 47.01)];
            [bezier2Path addCurveToPoint: CGPointMake(49.6, 46.49) controlPoint1: CGPointMake(55.56, 45.6) controlPoint2: CGPointMake(52.61, 46.24)];
            [bezier2Path addCurveToPoint: CGPointMake(46.56, 46.39) controlPoint1: CGPointMake(48.59, 46.58) controlPoint2: CGPointMake(47.55, 46.63)];
            [bezier2Path addCurveToPoint: CGPointMake(44.09, 44.64) controlPoint1: CGPointMake(45.54, 46.15) controlPoint2: CGPointMake(44.72, 45.36)];
            [bezier2Path addCurveToPoint: CGPointMake(41.99, 41.2) controlPoint1: CGPointMake(43.2, 43.61) controlPoint2: CGPointMake(42.35, 42.47)];
            [bezier2Path addCurveToPoint: CGPointMake(43.54, 38.51) controlPoint1: CGPointMake(41.66, 40.07) controlPoint2: CGPointMake(42.57, 39.13)];
            [bezier2Path addCurveToPoint: CGPointMake(46.39, 37.91) controlPoint1: CGPointMake(44.43, 37.94) controlPoint2: CGPointMake(45.37, 38.02)];
            [bezier2Path addCurveToPoint: CGPointMake(50.09, 36.09) controlPoint1: CGPointMake(47.92, 37.75) controlPoint2: CGPointMake(49.07, 37.11)];
            [bezier2Path addCurveToPoint: CGPointMake(51.9, 33.76) controlPoint1: CGPointMake(50.8, 35.37) controlPoint2: CGPointMake(51.24, 34.5)];
            [bezier2Path addCurveToPoint: CGPointMake(54.49, 32.81) controlPoint1: CGPointMake(52.47, 33.12) controlPoint2: CGPointMake(53.87, 32.7)];
            [bezier2Path addCurveToPoint: CGPointMake(54.6, 32.86) controlPoint1: CGPointMake(54.96, 32.9) controlPoint2: CGPointMake(54.25, 32.68)];
            [bezier2Path addCurveToPoint: CGPointMake(54.91, 33.02) controlPoint1: CGPointMake(54.7, 32.91) controlPoint2: CGPointMake(54.81, 32.97)];
            [bezier2Path addCurveToPoint: CGPointMake(56.31, 33.33) controlPoint1: CGPointMake(55.36, 33.23) controlPoint2: CGPointMake(55.81, 33.31)];
            [bezier2Path addCurveToPoint: CGPointMake(59.38, 32.1) controlPoint1: CGPointMake(57.46, 33.37) controlPoint2: CGPointMake(58.6, 32.81)];
            [bezier2Path addCurveToPoint: CGPointMake(61.1, 29.9) controlPoint1: CGPointMake(60.08, 31.47) controlPoint2: CGPointMake(60.58, 30.65)];
            [bezier2Path addCurveToPoint: CGPointMake(62.59, 28.33) controlPoint1: CGPointMake(61.47, 29.36) controlPoint2: CGPointMake(62.05, 28.5)];
            [bezier2Path addCurveToPoint: CGPointMake(65.74, 28.54) controlPoint1: CGPointMake(63.38, 28.07) controlPoint2: CGPointMake(64.86, 28.44)];
            [bezier2Path addCurveToPoint: CGPointMake(69.44, 29.03) controlPoint1: CGPointMake(66.98, 28.67) controlPoint2: CGPointMake(68.21, 28.85)];
            [bezier2Path addCurveToPoint: CGPointMake(70.84, 29.24) controlPoint1: CGPointMake(69.91, 29.1) controlPoint2: CGPointMake(70.37, 29.17)];
            [bezier2Path addCurveToPoint: CGPointMake(71.77, 26.19) controlPoint1: CGPointMake(73.07, 29.59) controlPoint2: CGPointMake(74.02, 26.55)];
            [bezier2Path addCurveToPoint: CGPointMake(66.09, 25.41) controlPoint1: CGPointMake(69.89, 25.89) controlPoint2: CGPointMake(67.99, 25.64)];
            [bezier2Path addCurveToPoint: CGPointMake(59.43, 26.58) controlPoint1: CGPointMake(63.61, 25.12) controlPoint2: CGPointMake(61.31, 24.8)];
            [bezier2Path addCurveToPoint: CGPointMake(57.64, 28.88) controlPoint1: CGPointMake(58.72, 27.26) controlPoint2: CGPointMake(58.18, 28.09)];
            [bezier2Path addCurveToPoint: CGPointMake(56.24, 30.18) controlPoint1: CGPointMake(57.19, 29.53) controlPoint2: CGPointMake(56.84, 30.04)];
            [bezier2Path addCurveToPoint: CGPointMake(56.37, 30.12) controlPoint1: CGPointMake(56.45, 30.13) controlPoint2: CGPointMake(56.71, 30.3)];
            [bezier2Path addCurveToPoint: CGPointMake(55.25, 29.73) controlPoint1: CGPointMake(56.03, 29.94) controlPoint2: CGPointMake(55.64, 29.8)];
            [bezier2Path addCurveToPoint: CGPointMake(50.91, 30.45) controlPoint1: CGPointMake(53.79, 29.46) controlPoint2: CGPointMake(52.22, 29.89)];
            [bezier2Path addCurveToPoint: CGPointMake(48.56, 32.55) controlPoint1: CGPointMake(49.89, 30.88) controlPoint2: CGPointMake(49.15, 31.72)];
            [bezier2Path addCurveToPoint: CGPointMake(46.42, 34.72) controlPoint1: CGPointMake(48.03, 33.29) controlPoint2: CGPointMake(47.42, 34.43)];
            [bezier2Path addCurveToPoint: CGPointMake(43.4, 35.09) controlPoint1: CGPointMake(45.48, 35) controlPoint2: CGPointMake(44.38, 34.84)];
            [bezier2Path addCurveToPoint: CGPointMake(39.43, 37.77) controlPoint1: CGPointMake(41.82, 35.49) controlPoint2: CGPointMake(40.35, 36.57)];
            [bezier2Path addCurveToPoint: CGPointMake(40.09, 45.02) controlPoint1: CGPointMake(37.63, 40.13) controlPoint2: CGPointMake(38.52, 42.77)];
            [bezier2Path addCurveToPoint: CGPointMake(46.1, 49.54) controlPoint1: CGPointMake(41.5, 47.04) controlPoint2: CGPointMake(43.38, 49)];
            [bezier2Path addCurveToPoint: CGPointMake(54.06, 49.15) controlPoint1: CGPointMake(48.71, 50.06) controlPoint2: CGPointMake(51.47, 49.41)];
            [bezier2Path addCurveToPoint: CGPointMake(62.41, 51.02) controlPoint1: CGPointMake(57.03, 48.85) controlPoint2: CGPointMake(60.07, 49.24)];
            [bezier2Path addCurveToPoint: CGPointMake(66.83, 56.61) controlPoint1: CGPointMake(64.36, 52.51) controlPoint2: CGPointMake(65.74, 54.55)];
            [bezier2Path addCurveToPoint: CGPointMake(67.83, 59.02) controlPoint1: CGPointMake(67.24, 57.38) controlPoint2: CGPointMake(67.57, 58.2)];
            [bezier2Path addCurveToPoint: CGPointMake(67.96, 60.51) controlPoint1: CGPointMake(68.03, 59.65) controlPoint2: CGPointMake(68.07, 59.89)];
            [bezier2Path addCurveToPoint: CGPointMake(66.21, 66.31) controlPoint1: CGPointMake(67.62, 62.48) controlPoint2: CGPointMake(66.83, 64.4)];
            [bezier2Path addCurveToPoint: CGPointMake(64.19, 74.55) controlPoint1: CGPointMake(65.34, 69.02) controlPoint2: CGPointMake(64.61, 71.76)];
            [bezier2Path addCurveToPoint: CGPointMake(66.27, 90.41) controlPoint1: CGPointMake(63.38, 79.94) controlPoint2: CGPointMake(64.04, 85.34)];
            [bezier2Path addCurveToPoint: CGPointMake(68.04, 93.81) controlPoint1: CGPointMake(66.78, 91.56) controlPoint2: CGPointMake(67.33, 92.74)];
            [bezier2Path addCurveToPoint: CGPointMake(71.09, 92.21) controlPoint1: CGPointMake(69.2, 95.56) controlPoint2: CGPointMake(72.26, 93.96)];
            [bezier2Path addLineToPoint: CGPointMake(71.09, 92.21)];
            [bezier2Path closePath];
            bezier2Path.miterLimit = 4;
            
            [fillColor2 setFill];
            [bezier2Path fill];
        }
    }
    
    
    //// Group 7
    {
        //// Group 8
        {
            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
            [bezier3Path moveToPoint: CGPointMake(38.28, 40.54)];
            [bezier3Path addCurveToPoint: CGPointMake(33.44, 41.07) controlPoint1: CGPointMake(36.7, 40.9) controlPoint2: CGPointMake(35.07, 41.11)];
            [bezier3Path addCurveToPoint: CGPointMake(31.51, 40.34) controlPoint1: CGPointMake(32.67, 41.06) controlPoint2: CGPointMake(31.95, 40.97)];
            [bezier3Path addCurveToPoint: CGPointMake(30.13, 37.62) controlPoint1: CGPointMake(30.93, 39.49) controlPoint2: CGPointMake(30.7, 38.48)];
            [bezier3Path addCurveToPoint: CGPointMake(27.33, 35.8) controlPoint1: CGPointMake(29.48, 36.64) controlPoint2: CGPointMake(28.5, 36.09)];
            [bezier3Path addCurveToPoint: CGPointMake(25.18, 33.38) controlPoint1: CGPointMake(26.26, 35.52) controlPoint2: CGPointMake(25.51, 34.28)];
            [bezier3Path addCurveToPoint: CGPointMake(28.22, 27.13) controlPoint1: CGPointMake(24.24, 30.78) controlPoint2: CGPointMake(26.36, 28.77)];
            [bezier3Path addCurveToPoint: CGPointMake(30.47, 24.66) controlPoint1: CGPointMake(29.07, 26.38) controlPoint2: CGPointMake(29.87, 25.59)];
            [bezier3Path addCurveToPoint: CGPointMake(32.23, 21.34) controlPoint1: CGPointMake(31.14, 23.61) controlPoint2: CGPointMake(31.57, 22.41)];
            [bezier3Path addCurveToPoint: CGPointMake(38.57, 16.25) controlPoint1: CGPointMake(33.54, 19.23) controlPoint2: CGPointMake(35.85, 16.7)];
            [bezier3Path addCurveToPoint: CGPointMake(41.49, 16.13) controlPoint1: CGPointMake(39.49, 16.09) controlPoint2: CGPointMake(40.54, 16.25)];
            [bezier3Path addCurveToPoint: CGPointMake(44.62, 15.2) controlPoint1: CGPointMake(42.59, 15.98) controlPoint2: CGPointMake(43.63, 15.66)];
            [bezier3Path addCurveToPoint: CGPointMake(46.06, 14.38) controlPoint1: CGPointMake(45.12, 14.97) controlPoint2: CGPointMake(45.59, 14.67)];
            [bezier3Path addCurveToPoint: CGPointMake(46.78, 13.97) controlPoint1: CGPointMake(46.3, 14.24) controlPoint2: CGPointMake(46.54, 14.1)];
            [bezier3Path addCurveToPoint: CGPointMake(47.48, 13.65) controlPoint1: CGPointMake(47.14, 13.78) controlPoint2: CGPointMake(47.43, 13.66)];
            [bezier3Path addCurveToPoint: CGPointMake(52.59, 13.11) controlPoint1: CGPointMake(49.1, 13.07) controlPoint2: CGPointMake(50.88, 13.07)];
            [bezier3Path addCurveToPoint: CGPointMake(61.27, 13.99) controlPoint1: CGPointMake(55.49, 13.19) controlPoint2: CGPointMake(58.42, 13.52)];
            [bezier3Path addCurveToPoint: CGPointMake(71.81, 18.3) controlPoint1: CGPointMake(65.18, 14.63) controlPoint2: CGPointMake(68.91, 15.7)];
            [bezier3Path addCurveToPoint: CGPointMake(77.35, 24.01) controlPoint1: CGPointMake(73.79, 20.08) controlPoint2: CGPointMake(75.59, 22.04)];
            [bezier3Path addCurveToPoint: CGPointMake(81.04, 27.9) controlPoint1: CGPointMake(78.54, 25.36) controlPoint2: CGPointMake(79.65, 26.71)];
            [bezier3Path addCurveToPoint: CGPointMake(83.37, 32.11) controlPoint1: CGPointMake(82.44, 29.09) controlPoint2: CGPointMake(83.52, 30.25)];
            [bezier3Path addCurveToPoint: CGPointMake(82.06, 34.54) controlPoint1: CGPointMake(83.29, 33.02) controlPoint2: CGPointMake(82.7, 33.88)];
            [bezier3Path addCurveToPoint: CGPointMake(81.29, 35.23) controlPoint1: CGPointMake(81.82, 34.79) controlPoint2: CGPointMake(81.56, 35.01)];
            [bezier3Path addCurveToPoint: CGPointMake(81.13, 35.33) controlPoint1: CGPointMake(81, 35.46) controlPoint2: CGPointMake(81.5, 35.1)];
            [bezier3Path addCurveToPoint: CGPointMake(82.92, 38.15) controlPoint1: CGPointMake(79.25, 36.5) controlPoint2: CGPointMake(81.02, 39.33)];
            [bezier3Path addCurveToPoint: CGPointMake(86.55, 33.79) controlPoint1: CGPointMake(84.62, 37.1) controlPoint2: CGPointMake(85.86, 35.55)];
            [bezier3Path addCurveToPoint: CGPointMake(84.93, 26.9) controlPoint1: CGPointMake(87.52, 31.34) controlPoint2: CGPointMake(86.62, 28.83)];
            [bezier3Path addCurveToPoint: CGPointMake(82.83, 24.98) controlPoint1: CGPointMake(84.31, 26.2) controlPoint2: CGPointMake(83.55, 25.6)];
            [bezier3Path addCurveToPoint: CGPointMake(80.85, 22.85) controlPoint1: CGPointMake(82.09, 24.34) controlPoint2: CGPointMake(81.48, 23.58)];
            [bezier3Path addCurveToPoint: CGPointMake(74.58, 16.24) controlPoint1: CGPointMake(78.86, 20.56) controlPoint2: CGPointMake(76.81, 18.32)];
            [bezier3Path addCurveToPoint: CGPointMake(61.5, 10.73) controlPoint1: CGPointMake(71, 12.91) controlPoint2: CGPointMake(66.42, 11.5)];
            [bezier3Path addCurveToPoint: CGPointMake(51.55, 9.83) controlPoint1: CGPointMake(58.23, 10.21) controlPoint2: CGPointMake(54.87, 9.84)];
            [bezier3Path addCurveToPoint: CGPointMake(45.53, 10.9) controlPoint1: CGPointMake(49.47, 9.83) controlPoint2: CGPointMake(47.42, 10.08)];
            [bezier3Path addCurveToPoint: CGPointMake(42.41, 12.57) controlPoint1: CGPointMake(44.43, 11.37) controlPoint2: CGPointMake(43.51, 12.11)];
            [bezier3Path addCurveToPoint: CGPointMake(42.22, 12.62) controlPoint1: CGPointMake(42.78, 12.41) controlPoint2: CGPointMake(42.25, 12.61)];
            [bezier3Path addCurveToPoint: CGPointMake(41.18, 12.88) controlPoint1: CGPointMake(41.88, 12.73) controlPoint2: CGPointMake(41.53, 12.81)];
            [bezier3Path addCurveToPoint: CGPointMake(39.75, 12.98) controlPoint1: CGPointMake(40.71, 12.98) controlPoint2: CGPointMake(40.23, 12.97)];
            [bezier3Path addCurveToPoint: CGPointMake(36.36, 13.45) controlPoint1: CGPointMake(38.58, 12.98) controlPoint2: CGPointMake(37.45, 13.03)];
            [bezier3Path addCurveToPoint: CGPointMake(29.35, 19.44) controlPoint1: CGPointMake(33.39, 14.59) controlPoint2: CGPointMake(31.02, 16.96)];
            [bezier3Path addCurveToPoint: CGPointMake(27.65, 22.57) controlPoint1: CGPointMake(28.68, 20.43) controlPoint2: CGPointMake(28.15, 21.5)];
            [bezier3Path addCurveToPoint: CGPointMake(25.5, 25.02) controlPoint1: CGPointMake(27.19, 23.57) controlPoint2: CGPointMake(26.34, 24.28)];
            [bezier3Path addCurveToPoint: CGPointMake(21.43, 31.84) controlPoint1: CGPointMake(23.35, 26.91) controlPoint2: CGPointMake(21.64, 29.01)];
            [bezier3Path addCurveToPoint: CGPointMake(25.49, 38.6) controlPoint1: CGPointMake(21.24, 34.49) controlPoint2: CGPointMake(22.98, 37.35)];
            [bezier3Path addCurveToPoint: CGPointMake(26.92, 39.11) controlPoint1: CGPointMake(25.94, 38.82) controlPoint2: CGPointMake(26.49, 38.89)];
            [bezier3Path addCurveToPoint: CGPointMake(27.43, 39.86) controlPoint1: CGPointMake(27.17, 39.23) controlPoint2: CGPointMake(27.32, 39.64)];
            [bezier3Path addCurveToPoint: CGPointMake(29.03, 42.71) controlPoint1: CGPointMake(27.95, 40.84) controlPoint2: CGPointMake(28.25, 41.86)];
            [bezier3Path addCurveToPoint: CGPointMake(35.68, 44.24) controlPoint1: CGPointMake(30.65, 44.48) controlPoint2: CGPointMake(33.39, 44.47)];
            [bezier3Path addCurveToPoint: CGPointMake(39.2, 43.7) controlPoint1: CGPointMake(36.86, 44.13) controlPoint2: CGPointMake(38.04, 43.96)];
            [bezier3Path addCurveToPoint: CGPointMake(38.28, 40.54) controlPoint1: CGPointMake(41.41, 43.19) controlPoint2: CGPointMake(40.49, 40.04)];
            [bezier3Path addLineToPoint: CGPointMake(38.28, 40.54)];
            [bezier3Path closePath];
            bezier3Path.miterLimit = 4;
            
            [fillColor2 setFill];
            [bezier3Path fill];
        }
    }
    
    
    //// Group 9
    {
        //// Group 10
        {
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(63.36, 42.92)];
            [bezier4Path addCurveToPoint: CGPointMake(63.39, 42.9) controlPoint1: CGPointMake(63.07, 43.53) controlPoint2: CGPointMake(63.3, 43.06)];
            [bezier4Path addCurveToPoint: CGPointMake(63.92, 42.08) controlPoint1: CGPointMake(63.55, 42.62) controlPoint2: CGPointMake(63.73, 42.34)];
            [bezier4Path addCurveToPoint: CGPointMake(66.08, 39.95) controlPoint1: CGPointMake(64.48, 41.28) controlPoint2: CGPointMake(65.21, 40.52)];
            [bezier4Path addCurveToPoint: CGPointMake(69.24, 38.91) controlPoint1: CGPointMake(66.95, 39.39) controlPoint2: CGPointMake(68.12, 38.85)];
            [bezier4Path addCurveToPoint: CGPointMake(69.71, 39.09) controlPoint1: CGPointMake(69.31, 38.92) controlPoint2: CGPointMake(69.46, 38.99)];
            [bezier4Path addCurveToPoint: CGPointMake(71.23, 39.53) controlPoint1: CGPointMake(70.21, 39.28) controlPoint2: CGPointMake(70.7, 39.45)];
            [bezier4Path addCurveToPoint: CGPointMake(78.63, 38.08) controlPoint1: CGPointMake(73.94, 39.92) controlPoint2: CGPointMake(76.01, 38.06)];
            [bezier4Path addCurveToPoint: CGPointMake(81.52, 40) controlPoint1: CGPointMake(79.85, 38.1) controlPoint2: CGPointMake(80.96, 39.18)];
            [bezier4Path addCurveToPoint: CGPointMake(81.38, 42.96) controlPoint1: CGPointMake(82.17, 40.95) controlPoint2: CGPointMake(81.97, 42.04)];
            [bezier4Path addCurveToPoint: CGPointMake(75.32, 46.31) controlPoint1: CGPointMake(80.21, 44.77) controlPoint2: CGPointMake(77.1, 45.04)];
            [bezier4Path addCurveToPoint: CGPointMake(73.74, 48.22) controlPoint1: CGPointMake(74.76, 46.71) controlPoint2: CGPointMake(74.12, 48.1)];
            [bezier4Path addCurveToPoint: CGPointMake(70.32, 49.67) controlPoint1: CGPointMake(72.45, 48.64) controlPoint2: CGPointMake(71.4, 48.89)];
            [bezier4Path addCurveToPoint: CGPointMake(68.03, 54.53) controlPoint1: CGPointMake(68.81, 50.76) controlPoint2: CGPointMake(68.37, 52.98)];
            [bezier4Path addCurveToPoint: CGPointMake(67.41, 58.82) controlPoint1: CGPointMake(67.73, 55.95) controlPoint2: CGPointMake(67.53, 57.39)];
            [bezier4Path addCurveToPoint: CGPointMake(67.41, 58.89) controlPoint1: CGPointMake(67.41, 58.84) controlPoint2: CGPointMake(67.41, 58.87)];
            [bezier4Path addCurveToPoint: CGPointMake(71.03, 58.91) controlPoint1: CGPointMake(67.27, 60.9) controlPoint2: CGPointMake(70.89, 60.9)];
            [bezier4Path addCurveToPoint: CGPointMake(71.48, 55.58) controlPoint1: CGPointMake(71.11, 57.8) controlPoint2: CGPointMake(71.26, 56.68)];
            [bezier4Path addCurveToPoint: CGPointMake(72.2, 52.98) controlPoint1: CGPointMake(71.65, 54.7) controlPoint2: CGPointMake(71.88, 53.83)];
            [bezier4Path addCurveToPoint: CGPointMake(73.59, 51.49) controlPoint1: CGPointMake(72.5, 52.18) controlPoint2: CGPointMake(72.69, 51.88)];
            [bezier4Path addCurveToPoint: CGPointMake(76.24, 50.47) controlPoint1: CGPointMake(74.48, 51.09) controlPoint2: CGPointMake(75.44, 51.11)];
            [bezier4Path addCurveToPoint: CGPointMake(78.39, 48.23) controlPoint1: CGPointMake(77.11, 49.76) controlPoint2: CGPointMake(77.34, 48.76)];
            [bezier4Path addCurveToPoint: CGPointMake(81.54, 46.95) controlPoint1: CGPointMake(79.39, 47.72) controlPoint2: CGPointMake(80.52, 47.42)];
            [bezier4Path addCurveToPoint: CGPointMake(84.68, 44.24) controlPoint1: CGPointMake(82.89, 46.34) controlPoint2: CGPointMake(83.95, 45.38)];
            [bezier4Path addCurveToPoint: CGPointMake(83.59, 37.17) controlPoint1: CGPointMake(86.22, 41.86) controlPoint2: CGPointMake(85.54, 39.18)];
            [bezier4Path addCurveToPoint: CGPointMake(75.27, 35.54) controlPoint1: CGPointMake(81.43, 34.96) controlPoint2: CGPointMake(78.28, 34.58)];
            [bezier4Path addCurveToPoint: CGPointMake(72.19, 36.5) controlPoint1: CGPointMake(74.32, 35.85) controlPoint2: CGPointMake(73.16, 36.46)];
            [bezier4Path addCurveToPoint: CGPointMake(70.12, 35.91) controlPoint1: CGPointMake(71.47, 36.53) controlPoint2: CGPointMake(71.02, 36.13)];
            [bezier4Path addCurveToPoint: CGPointMake(62.69, 38.4) controlPoint1: CGPointMake(67.48, 35.28) controlPoint2: CGPointMake(64.48, 36.88)];
            [bezier4Path addCurveToPoint: CGPointMake(59.86, 42.1) controlPoint1: CGPointMake(61.47, 39.44) controlPoint2: CGPointMake(60.51, 40.74)];
            [bezier4Path addCurveToPoint: CGPointMake(61.13, 44.01) controlPoint1: CGPointMake(59.49, 42.89) controlPoint2: CGPointMake(60.27, 43.81)];
            [bezier4Path addCurveToPoint: CGPointMake(63.36, 42.92) controlPoint1: CGPointMake(62.17, 44.26) controlPoint2: CGPointMake(62.98, 43.71)];
            [bezier4Path addLineToPoint: CGPointMake(63.36, 42.92)];
            [bezier4Path closePath];
            bezier4Path.miterLimit = 4;
            
            [fillColor2 setFill];
            [bezier4Path fill];
        }
    }
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(59.94, 20.5, 15.67, 14.67)];
    [fillColor setFill];
    [ovalPath fill];

}

@end
