//
//  ASymbol_NewCholestrol.m
//  AProgressBars
//
//  Created by hui wang on 7/13/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_NewCholestrol.h"

@interface ASymbol_NewCholestrol (PrivateMethods)

// path drawing
-(void) drawPath;

@end

@implementation ASymbol_NewCholestrol

@synthesize fillColor, fillColor2, textForeground;

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(100, 100);
    fillColor = [UIColor colorWithRed: 0.729 green: 0.125 blue: 0.192 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 0.231 green: 0.275 blue: 0.325 alpha: 1];
    textForeground = [UIColor colorWithRed: 0.231 green: 0.275 blue: 0.325 alpha: 1];
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_NewCholestrol* draw = [[ASymbol_NewCholestrol alloc] init];
    [draw initDrawPros];
    
    APathDrawWrap* warp = [[APathDrawWrap alloc] initWith:CGRectMake(0, 0, draw.pathRefSize.x, draw.pathRefSize.y) pathDraw:draw];
    
    return warp;
}

// !!! The view area is CGRectMake(0, 0, pathRefSize.x, pathRefSize.y) or CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)ctx
{
    // save context
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
    // done drawing
    CGContextRestoreGState(ctx);
}

// draw heart 1 image
-(void) drawPath
{
    //// Group 3
    {
        //// Group 4
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(29.61, 17.36)];
            [bezierPath addCurveToPoint: CGPointMake(18.05, 1.03) controlPoint1: CGPointMake(25.75, 11.92) controlPoint2: CGPointMake(21.9, 6.47)];
            [bezierPath addCurveToPoint: CGPointMake(14.96, 1.04) controlPoint1: CGPointMake(17.3, -0.02) controlPoint2: CGPointMake(15.7, -0)];
            [bezierPath addCurveToPoint: CGPointMake(5.33, 14.64) controlPoint1: CGPointMake(11.75, 5.58) controlPoint2: CGPointMake(8.54, 10.11)];
            [bezierPath addCurveToPoint: CGPointMake(0.87, 22.09) controlPoint1: CGPointMake(3.64, 17.03) controlPoint2: CGPointMake(1.76, 19.33)];
            [bezierPath addCurveToPoint: CGPointMake(5.03, 36.53) controlPoint1: CGPointMake(-0.79, 27.18) controlPoint2: CGPointMake(0.99, 32.78)];
            [bezierPath addCurveToPoint: CGPointMake(26.25, 37.89) controlPoint1: CGPointMake(10.59, 41.7) controlPoint2: CGPointMake(19.94, 42.22)];
            [bezierPath addCurveToPoint: CGPointMake(29.61, 17.36) controlPoint1: CGPointMake(33.24, 33.08) controlPoint2: CGPointMake(34.82, 23.83)];
            [bezierPath addCurveToPoint: CGPointMake(27.17, 16.78) controlPoint1: CGPointMake(29.04, 16.65) controlPoint2: CGPointMake(28.07, 16.3)];
            [bezierPath addCurveToPoint: CGPointMake(26.53, 19) controlPoint1: CGPointMake(26.39, 17.19) controlPoint2: CGPointMake(25.96, 18.29)];
            [bezierPath addCurveToPoint: CGPointMake(26.5, 33.19) controlPoint1: CGPointMake(29.93, 23.22) controlPoint2: CGPointMake(30.12, 29.02)];
            [bezierPath addCurveToPoint: CGPointMake(12.83, 37.11) controlPoint1: CGPointMake(23.25, 36.93) controlPoint2: CGPointMake(17.84, 38.42)];
            [bezierPath addCurveToPoint: CGPointMake(3.89, 27.29) controlPoint1: CGPointMake(8.01, 35.86) controlPoint2: CGPointMake(4.39, 31.8)];
            [bezierPath addCurveToPoint: CGPointMake(6.27, 19.27) controlPoint1: CGPointMake(3.57, 24.4) controlPoint2: CGPointMake(4.47, 21.63)];
            [bezierPath addCurveToPoint: CGPointMake(7.46, 17.63) controlPoint1: CGPointMake(6.68, 18.73) controlPoint2: CGPointMake(7.07, 18.18)];
            [bezierPath addCurveToPoint: CGPointMake(18.05, 2.66) controlPoint1: CGPointMake(10.99, 12.64) controlPoint2: CGPointMake(14.52, 7.65)];
            [bezierPath addCurveToPoint: CGPointMake(14.97, 2.67) controlPoint1: CGPointMake(17.03, 2.67) controlPoint2: CGPointMake(16, 2.67)];
            [bezierPath addCurveToPoint: CGPointMake(26.53, 19) controlPoint1: CGPointMake(18.82, 8.12) controlPoint2: CGPointMake(22.68, 13.56)];
            [bezierPath addCurveToPoint: CGPointMake(29.61, 17.36) controlPoint1: CGPointMake(27.77, 20.75) controlPoint2: CGPointMake(30.86, 19.12)];
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
            [bezier2Path moveToPoint: CGPointMake(56.65, 80.46)];
            [bezier2Path addCurveToPoint: CGPointMake(77.33, 100) controlPoint1: CGPointMake(56.75, 90.76) controlPoint2: CGPointMake(65.79, 99.24)];
            [bezier2Path addCurveToPoint: CGPointMake(100.58, 82.87) controlPoint1: CGPointMake(88.82, 100.76) controlPoint2: CGPointMake(99.17, 92.91)];
            [bezier2Path addCurveToPoint: CGPointMake(82.86, 61.25) controlPoint1: CGPointMake(101.99, 72.77) controlPoint2: CGPointMake(94.1, 63.16)];
            [bezier2Path addCurveToPoint: CGPointMake(57.33, 75.64) controlPoint1: CGPointMake(71.5, 59.31) controlPoint2: CGPointMake(60.23, 65.75)];
            [bezier2Path addCurveToPoint: CGPointMake(56.65, 80.46) controlPoint1: CGPointMake(56.87, 77.2) controlPoint2: CGPointMake(56.67, 78.84)];
            [bezier2Path addCurveToPoint: CGPointMake(60.3, 80.48) controlPoint1: CGPointMake(56.63, 82.55) controlPoint2: CGPointMake(60.28, 82.57)];
            [bezier2Path addCurveToPoint: CGPointMake(66.62, 68.14) controlPoint1: CGPointMake(60.35, 75.71) controlPoint2: CGPointMake(62.63, 71.32)];
            [bezier2Path addCurveToPoint: CGPointMake(81.24, 64.28) controlPoint1: CGPointMake(70.52, 65.04) controlPoint2: CGPointMake(76.07, 63.63)];
            [bezier2Path addCurveToPoint: CGPointMake(94.03, 71.43) controlPoint1: CGPointMake(86.43, 64.93) controlPoint2: CGPointMake(91.11, 67.56)];
            [bezier2Path addCurveToPoint: CGPointMake(96.38, 85) controlPoint1: CGPointMake(97.04, 75.41) controlPoint2: CGPointMake(97.82, 80.4)];
            [bezier2Path addCurveToPoint: CGPointMake(76.17, 96.66) controlPoint1: CGPointMake(93.97, 92.7) controlPoint2: CGPointMake(85.05, 97.77)];
            [bezier2Path addCurveToPoint: CGPointMake(60.3, 80.48) controlPoint1: CGPointMake(67.13, 95.52) controlPoint2: CGPointMake(60.38, 88.54)];
            [bezier2Path addCurveToPoint: CGPointMake(56.65, 80.46) controlPoint1: CGPointMake(60.28, 78.39) controlPoint2: CGPointMake(56.63, 78.37)];
            [bezier2Path closePath];
            bezier2Path.miterLimit = 4;
            
            [fillColor2 setFill];
            [bezier2Path fill];
        }
    }
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
    [bezier3Path moveToPoint: CGPointMake(78.9, 56.34)];
    [bezier3Path addCurveToPoint: CGPointMake(80.26, 56.37) controlPoint1: CGPointMake(79.36, 56.34) controlPoint2: CGPointMake(79.81, 56.35)];
    [bezier3Path addCurveToPoint: CGPointMake(76.18, 49.83) controlPoint1: CGPointMake(79.23, 54.02) controlPoint2: CGPointMake(77.85, 51.82)];
    [bezier3Path addLineToPoint: CGPointMake(51.49, 15.57)];
    [bezier3Path addLineToPoint: CGPointMake(26.8, 49.83)];
    [bezier3Path addCurveToPoint: CGPointMake(20.61, 66.42) controlPoint1: CGPointMake(22.91, 54.45) controlPoint2: CGPointMake(20.61, 60.19)];
    [bezier3Path addCurveToPoint: CGPointMake(51.49, 94.02) controlPoint1: CGPointMake(20.61, 81.66) controlPoint2: CGPointMake(34.43, 94.02)];
    [bezier3Path addCurveToPoint: CGPointMake(56.64, 93.64) controlPoint1: CGPointMake(53.25, 94.02) controlPoint2: CGPointMake(54.97, 93.89)];
    [bezier3Path addCurveToPoint: CGPointMake(52.1, 80.29) controlPoint1: CGPointMake(53.78, 89.82) controlPoint2: CGPointMake(52.1, 85.23)];
    [bezier3Path addCurveToPoint: CGPointMake(78.9, 56.34) controlPoint1: CGPointMake(52.1, 67.07) controlPoint2: CGPointMake(64.1, 56.34)];
    [bezier3Path closePath];
    bezier3Path.miterLimit = 4;
    
    [fillColor setFill];
    [bezier3Path fill];
    
    
    //// Label Drawing
    CGRect labelRect = CGRectMake(73.15, 69.75, 22.09, 18);
    NSMutableParagraphStyle* labelStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    labelStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary* labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"ArialRoundedMTBold" size: 60], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: labelStyle};
    
    [@"7.5" drawInRect: labelRect withAttributes: labelFontAttributes];
}

@end
