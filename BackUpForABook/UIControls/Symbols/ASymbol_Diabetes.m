//
//  ASymbol_Diabetes.m
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Diabetes.h"

@interface ASymbol_Diabetes (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbol_Diabetes

@synthesize fillColor, fillColor2, strokeColor, lineWidth;

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(100, 100);

    fillColor = [UIColor grayColor];
    fillColor2 = [UIColor colorWithRed: 0.729 green: 0.125 blue: 0.192 alpha: 1];
    strokeColor = [UIColor grayColor];
    lineWidth = 4;
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_Diabetes* draw = [[ASymbol_Diabetes alloc] init];
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
            [bezierPath moveToPoint: CGPointMake(10.18, 49.79)];
            [bezierPath addCurveToPoint: CGPointMake(10.18, 39.22) controlPoint1: CGPointMake(10.18, 46.27) controlPoint2: CGPointMake(10.18, 42.75)];
            [bezierPath addCurveToPoint: CGPointMake(10.18, 34.69) controlPoint1: CGPointMake(10.18, 37.71) controlPoint2: CGPointMake(10.18, 36.2)];
            [bezierPath addCurveToPoint: CGPointMake(10.19, 34.18) controlPoint1: CGPointMake(10.18, 34.52) controlPoint2: CGPointMake(10.19, 34.35)];
            [bezierPath addCurveToPoint: CGPointMake(10.24, 33.41) controlPoint1: CGPointMake(10.21, 33.92) controlPoint2: CGPointMake(10.22, 33.67)];
            [bezierPath addCurveToPoint: CGPointMake(10.28, 32.9) controlPoint1: CGPointMake(10.25, 33.24) controlPoint2: CGPointMake(10.26, 33.07)];
            [bezierPath addCurveToPoint: CGPointMake(10.31, 32.55) controlPoint1: CGPointMake(10.31, 32.52) controlPoint2: CGPointMake(10.24, 33.29)];
            [bezierPath addCurveToPoint: CGPointMake(15.39, 18.82) controlPoint1: CGPointMake(10.87, 27.22) controlPoint2: CGPointMake(12.33, 22.01)];
            [bezierPath addCurveToPoint: CGPointMake(29.14, 10.75) controlPoint1: CGPointMake(19.49, 14.55) controlPoint2: CGPointMake(24.27, 12.21)];
            [bezierPath addCurveToPoint: CGPointMake(47.57, 6.31) controlPoint1: CGPointMake(35.24, 8.92) controlPoint2: CGPointMake(41.4, 7.59)];
            [bezierPath addCurveToPoint: CGPointMake(51.51, 5.5) controlPoint1: CGPointMake(48.88, 6.04) controlPoint2: CGPointMake(50.2, 5.77)];
            [bezierPath addCurveToPoint: CGPointMake(52.49, 5.3) controlPoint1: CGPointMake(51.84, 5.43) controlPoint2: CGPointMake(52.16, 5.37)];
            [bezierPath addCurveToPoint: CGPointMake(52.38, 5.32) controlPoint1: CGPointMake(52.93, 5.21) controlPoint2: CGPointMake(52.47, 5.31)];
            [bezierPath addCurveToPoint: CGPointMake(53.51, 5.23) controlPoint1: CGPointMake(52.75, 5.26) controlPoint2: CGPointMake(53.13, 5.24)];
            [bezierPath addCurveToPoint: CGPointMake(54.34, 5.29) controlPoint1: CGPointMake(53.79, 5.23) controlPoint2: CGPointMake(54.07, 5.26)];
            [bezierPath addCurveToPoint: CGPointMake(54.51, 5.31) controlPoint1: CGPointMake(54.39, 5.29) controlPoint2: CGPointMake(54.89, 5.39)];
            [bezierPath addCurveToPoint: CGPointMake(55.15, 5.49) controlPoint1: CGPointMake(54.72, 5.35) controlPoint2: CGPointMake(54.94, 5.42)];
            [bezierPath addCurveToPoint: CGPointMake(57.59, 8.82) controlPoint1: CGPointMake(56.46, 5.94) controlPoint2: CGPointMake(57.25, 6.78)];
            [bezierPath addCurveToPoint: CGPointMake(57.52, 11.64) controlPoint1: CGPointMake(57.76, 9.79) controlPoint2: CGPointMake(57.68, 11.08)];
            [bezierPath addCurveToPoint: CGPointMake(57.25, 12.39) controlPoint1: CGPointMake(57.45, 11.9) controlPoint2: CGPointMake(57.35, 12.15)];
            [bezierPath addCurveToPoint: CGPointMake(57.1, 12.75) controlPoint1: CGPointMake(57.26, 12.38) controlPoint2: CGPointMake(56.91, 13.1)];
            [bezierPath addCurveToPoint: CGPointMake(56.73, 13.34) controlPoint1: CGPointMake(56.99, 12.96) controlPoint2: CGPointMake(56.86, 13.15)];
            [bezierPath addCurveToPoint: CGPointMake(56.43, 13.77) controlPoint1: CGPointMake(56.69, 13.41) controlPoint2: CGPointMake(56.19, 14.04)];
            [bezierPath addCurveToPoint: CGPointMake(54.75, 15.18) controlPoint1: CGPointMake(55.92, 14.35) controlPoint2: CGPointMake(55.34, 14.8)];
            [bezierPath addCurveToPoint: CGPointMake(54.35, 15.38) controlPoint1: CGPointMake(55.19, 14.9) controlPoint2: CGPointMake(54.48, 15.32)];
            [bezierPath addCurveToPoint: CGPointMake(53.77, 15.64) controlPoint1: CGPointMake(54.16, 15.48) controlPoint2: CGPointMake(53.96, 15.56)];
            [bezierPath addCurveToPoint: CGPointMake(48.66, 16.87) controlPoint1: CGPointMake(52.11, 16.27) controlPoint2: CGPointMake(50.34, 16.47)];
            [bezierPath addCurveToPoint: CGPointMake(33.69, 20.43) controlPoint1: CGPointMake(43.67, 18.06) controlPoint2: CGPointMake(38.68, 19.24)];
            [bezierPath addCurveToPoint: CGPointMake(32.95, 20.6) controlPoint1: CGPointMake(33.45, 20.49) controlPoint2: CGPointMake(33.2, 20.55)];
            [bezierPath addCurveToPoint: CGPointMake(31.69, 22.45) controlPoint1: CGPointMake(32.36, 20.75) controlPoint2: CGPointMake(31.83, 21.63)];
            [bezierPath addCurveToPoint: CGPointMake(28.6, 33.56) controlPoint1: CGPointMake(31.04, 26.29) controlPoint2: CGPointMake(30.14, 30.29)];
            [bezierPath addCurveToPoint: CGPointMake(24.87, 39.83) controlPoint1: CGPointMake(27.57, 35.75) controlPoint2: CGPointMake(26.1, 37.81)];
            [bezierPath addCurveToPoint: CGPointMake(22.58, 43.58) controlPoint1: CGPointMake(24.11, 41.08) controlPoint2: CGPointMake(23.35, 42.33)];
            [bezierPath addCurveToPoint: CGPointMake(25.11, 47.27) controlPoint1: CGPointMake(21.05, 46.08) controlPoint2: CGPointMake(23.56, 49.79)];
            [bezierPath addCurveToPoint: CGPointMake(31.67, 36.19) controlPoint1: CGPointMake(27.33, 43.66) controlPoint2: CGPointMake(29.72, 40.12)];
            [bezierPath addCurveToPoint: CGPointMake(35.12, 23.83) controlPoint1: CGPointMake(33.42, 32.69) controlPoint2: CGPointMake(34.41, 28.02)];
            [bezierPath addCurveToPoint: CGPointMake(33.87, 25.68) controlPoint1: CGPointMake(34.7, 24.45) controlPoint2: CGPointMake(34.29, 25.06)];
            [bezierPath addCurveToPoint: CGPointMake(48.33, 22.24) controlPoint1: CGPointMake(38.69, 24.53) controlPoint2: CGPointMake(43.51, 23.39)];
            [bezierPath addCurveToPoint: CGPointMake(59.39, 16.84) controlPoint1: CGPointMake(52.16, 21.33) controlPoint2: CGPointMake(56.49, 21.22)];
            [bezierPath addCurveToPoint: CGPointMake(58.1, 1.6) controlPoint1: CGPointMake(62.29, 12.46) controlPoint2: CGPointMake(61.65, 4.76)];
            [bezierPath addCurveToPoint: CGPointMake(51.69, 0.21) controlPoint1: CGPointMake(56.2, -0.09) controlPoint2: CGPointMake(53.83, -0.22)];
            [bezierPath addCurveToPoint: CGPointMake(34.59, 3.91) controlPoint1: CGPointMake(45.98, 1.35) controlPoint2: CGPointMake(40.27, 2.47)];
            [bezierPath addCurveToPoint: CGPointMake(25.74, 6.5) controlPoint1: CGPointMake(31.64, 4.66) controlPoint2: CGPointMake(28.65, 5.44)];
            [bezierPath addCurveToPoint: CGPointMake(11.64, 16.57) controlPoint1: CGPointMake(20.77, 8.3) controlPoint2: CGPointMake(15.45, 11.36)];
            [bezierPath addCurveToPoint: CGPointMake(6.84, 31.6) controlPoint1: CGPointMake(8.85, 20.38) controlPoint2: CGPointMake(7.38, 26.15)];
            [bezierPath addCurveToPoint: CGPointMake(6.62, 39.18) controlPoint1: CGPointMake(6.59, 34.14) controlPoint2: CGPointMake(6.62, 36.61)];
            [bezierPath addCurveToPoint: CGPointMake(6.62, 49.76) controlPoint1: CGPointMake(6.62, 42.71) controlPoint2: CGPointMake(6.62, 46.23)];
            [bezierPath addCurveToPoint: CGPointMake(10.18, 49.79) controlPoint1: CGPointMake(6.62, 53.15) controlPoint2: CGPointMake(10.18, 53.18)];
            [bezierPath addLineToPoint: CGPointMake(10.18, 49.79)];
            [bezierPath closePath];
            bezierPath.miterLimit = 4;
            
            [fillColor setFill];
            [bezierPath fill];
        }
    }
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(49.75, 19.36)];
    [bezier2Path addLineToPoint: CGPointMake(86.22, 19.36)];
    [bezier2Path addCurveToPoint: CGPointMake(92.79, 27.9) controlPoint1: CGPointMake(86.22, 19.36) controlPoint2: CGPointMake(92.79, 19.19)];
    [bezier2Path addCurveToPoint: CGPointMake(87.15, 36.5) controlPoint1: CGPointMake(92.79, 36.6) controlPoint2: CGPointMake(87.15, 36.5)];
    [bezier2Path addLineToPoint: CGPointMake(65.86, 36.5)];
    [strokeColor setStroke];
    bezier2Path.lineWidth = lineWidth;
    [bezier2Path stroke];
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
            [bezier3Path moveToPoint: CGPointMake(9.08, 70.82)];
            [bezier3Path addCurveToPoint: CGPointMake(14.78, 80.76) controlPoint1: CGPointMake(9.68, 75.12) controlPoint2: CGPointMake(12.44, 78.6)];
            [bezier3Path addCurveToPoint: CGPointMake(26.35, 85.73) controlPoint1: CGPointMake(18.04, 83.77) controlPoint2: CGPointMake(22.45, 86.1)];
            [bezier3Path addCurveToPoint: CGPointMake(39.13, 84.9) controlPoint1: CGPointMake(30.6, 85.32) controlPoint2: CGPointMake(34.87, 85.17)];
            [bezier3Path addCurveToPoint: CGPointMake(49.42, 84.24) controlPoint1: CGPointMake(42.56, 84.68) controlPoint2: CGPointMake(45.99, 84.46)];
            [bezier3Path addCurveToPoint: CGPointMake(49.44, 78.96) controlPoint1: CGPointMake(51.68, 84.09) controlPoint2: CGPointMake(51.71, 78.82)];
            [bezier3Path addCurveToPoint: CGPointMake(35.66, 79.85) controlPoint1: CGPointMake(44.85, 79.26) controlPoint2: CGPointMake(40.25, 79.55)];
            [bezier3Path addCurveToPoint: CGPointMake(27.89, 80.35) controlPoint1: CGPointMake(33.07, 80.01) controlPoint2: CGPointMake(30.48, 80.18)];
            [bezier3Path addCurveToPoint: CGPointMake(24.07, 80.3) controlPoint1: CGPointMake(26.6, 80.43) controlPoint2: CGPointMake(25.36, 80.54)];
            [bezier3Path addCurveToPoint: CGPointMake(14.82, 74.35) controlPoint1: CGPointMake(21.01, 79.73) controlPoint2: CGPointMake(17.29, 77.51)];
            [bezier3Path addCurveToPoint: CGPointMake(12.8, 70.66) controlPoint1: CGPointMake(13.88, 73.14) controlPoint2: CGPointMake(13.35, 72.18)];
            [bezier3Path addCurveToPoint: CGPointMake(12.58, 70) controlPoint1: CGPointMake(12.72, 70.44) controlPoint2: CGPointMake(12.65, 70.23)];
            [bezier3Path addCurveToPoint: CGPointMake(12.57, 69.91) controlPoint1: CGPointMake(12.82, 70.8) controlPoint2: CGPointMake(12.61, 70.11)];
            [bezier3Path addCurveToPoint: CGPointMake(12.48, 69.46) controlPoint1: CGPointMake(12.53, 69.76) controlPoint2: CGPointMake(12.5, 69.61)];
            [bezier3Path addCurveToPoint: CGPointMake(9.08, 70.82) controlPoint1: CGPointMake(12.02, 66.13) controlPoint2: CGPointMake(8.62, 67.51)];
            [bezier3Path addLineToPoint: CGPointMake(9.08, 70.82)];
            [bezier3Path closePath];
            bezier3Path.miterLimit = 4;
            
            [fillColor setFill];
            [bezier3Path fill];
        }
    }
    
    
    //// Group 7
    {
        //// Group 8
        {
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(1.41, 80)];
            [bezier4Path addCurveToPoint: CGPointMake(15.22, 81.09) controlPoint1: CGPointMake(6.02, 80.36) controlPoint2: CGPointMake(10.62, 80.73)];
            [bezier4Path addCurveToPoint: CGPointMake(15.24, 77.07) controlPoint1: CGPointMake(17.12, 81.25) controlPoint2: CGPointMake(17.13, 77.22)];
            [bezier4Path addCurveToPoint: CGPointMake(1.43, 75.98) controlPoint1: CGPointMake(10.64, 76.71) controlPoint2: CGPointMake(6.04, 76.34)];
            [bezier4Path addCurveToPoint: CGPointMake(1.41, 80) controlPoint1: CGPointMake(-0.47, 75.83) controlPoint2: CGPointMake(-0.48, 79.85)];
            [bezier4Path addLineToPoint: CGPointMake(1.41, 80)];
            [bezier4Path closePath];
            bezier4Path.miterLimit = 4;
            
            [fillColor setFill];
            [bezier4Path fill];
        }
    }
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(43.16, 67.02, 23.1, 14.5) cornerRadius: 7.25];
    [strokeColor setStroke];
    rectanglePath.lineWidth = lineWidth;
    [rectanglePath stroke];
    
    
    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(40.13, 51.52, 31.25, 15.2) cornerRadius: 7.6];
    [strokeColor setStroke];
    rectangle2Path.lineWidth = lineWidth;
    [rectangle2Path stroke];
    
    
    //// Bezier 5 Drawing
    UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
    [bezier5Path moveToPoint: CGPointMake(72.83, 43.96)];
    [bezier5Path addCurveToPoint: CGPointMake(66.45, 51.39) controlPoint1: CGPointMake(72.83, 48.06) controlPoint2: CGPointMake(69.98, 51.39)];
    [bezier5Path addLineToPoint: CGPointMake(46.13, 51.39)];
    [bezier5Path addCurveToPoint: CGPointMake(39.74, 43.96) controlPoint1: CGPointMake(42.6, 51.39) controlPoint2: CGPointMake(39.74, 48.06)];
    [bezier5Path addLineToPoint: CGPointMake(39.74, 43.96)];
    [bezier5Path addCurveToPoint: CGPointMake(46.13, 36.53) controlPoint1: CGPointMake(39.74, 39.85) controlPoint2: CGPointMake(42.6, 36.53)];
    [bezier5Path addLineToPoint: CGPointMake(66.45, 36.53)];
    [bezier5Path addCurveToPoint: CGPointMake(72.83, 43.96) controlPoint1: CGPointMake(69.98, 36.53) controlPoint2: CGPointMake(72.83, 39.85)];
    [bezier5Path addLineToPoint: CGPointMake(72.83, 43.96)];
    [bezier5Path closePath];
    [strokeColor setStroke];
    bezier5Path.lineWidth = lineWidth;
    [bezier5Path stroke];
    
    
    //// Group 9
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(79.35, 70.54, 19.88, 28.88)];
        [fillColor2 setFill];
        [ovalPath fill];
        
        
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
        [bezier6Path moveToPoint: CGPointMake(80.87, 77.58)];
        [bezier6Path addLineToPoint: CGPointMake(89.29, 58.75)];
        [bezier6Path addLineToPoint: CGPointMake(97.72, 77.58)];
        [bezier6Path addLineToPoint: CGPointMake(80.87, 77.58)];
        [bezier6Path closePath];
        bezier6Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier6Path fill];
    }
}

@end
