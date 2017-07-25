//
//  ASymbol_Berries.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Berries.h"

@implementation ASymbol_Berries

@synthesize fillColor1, fillColor2, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.49 green: 0.773 blue: 0.451 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.176 green: 0.616 blue: 0.282 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.176 green: 0.62 blue: 0.282 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor5 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    fillColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 0.102 green: 0.102 blue: 0.102 alpha: 1];

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
                                        CGPointMake(49.99, 49.98), 0,
                                        CGPointMake(49.99, 49.98), 50,
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
                                        CGPointMake(50.35, -42.68),
                                        CGPointMake(50.35, 49.54),
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
            [bezierPath moveToPoint: CGPointMake(60.3, 62.4)];
            [bezierPath addCurveToPoint: CGPointMake(53.8, 59.9) controlPoint1: CGPointMake(58.6, 60.9) controlPoint2: CGPointMake(56.3, 59.9)];
            [bezierPath addCurveToPoint: CGPointMake(47.8, 62) controlPoint1: CGPointMake(51.5, 59.9) controlPoint2: CGPointMake(49.5, 60.7)];
            [bezierPath addCurveToPoint: CGPointMake(50.2, 68) controlPoint1: CGPointMake(49.2, 63.6) controlPoint2: CGPointMake(50.1, 65.7)];
            [bezierPath addCurveToPoint: CGPointMake(50.2, 68.5) controlPoint1: CGPointMake(50.2, 68.2) controlPoint2: CGPointMake(50.2, 68.3)];
            [bezierPath addCurveToPoint: CGPointMake(46.5, 76.2) controlPoint1: CGPointMake(50.2, 71.6) controlPoint2: CGPointMake(48.7, 74.4)];
            [bezierPath addCurveToPoint: CGPointMake(53.8, 79.5) controlPoint1: CGPointMake(48.3, 78.2) controlPoint2: CGPointMake(50.9, 79.5)];
            [bezierPath addCurveToPoint: CGPointMake(63.5, 69.8) controlPoint1: CGPointMake(59.2, 79.5) controlPoint2: CGPointMake(63.5, 75.1)];
            [bezierPath addCurveToPoint: CGPointMake(60.3, 62.4) controlPoint1: CGPointMake(63.6, 66.8) controlPoint2: CGPointMake(62.3, 64.2)];
            [bezierPath closePath];
            bezierPath.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezierPath fill];
            
            
            //// Group 9
            {
                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                [bezier2Path moveToPoint: CGPointMake(53.3, 58.7)];
                [bezier2Path addCurveToPoint: CGPointMake(59.8, 61.2) controlPoint1: CGPointMake(55.8, 58.7) controlPoint2: CGPointMake(58.1, 59.6)];
                [bezier2Path addCurveToPoint: CGPointMake(60.7, 57.1) controlPoint1: CGPointMake(60.4, 60) controlPoint2: CGPointMake(60.7, 58.6)];
                [bezier2Path addCurveToPoint: CGPointMake(58.3, 50.6) controlPoint1: CGPointMake(60.7, 54.6) controlPoint2: CGPointMake(59.8, 52.4)];
                [bezier2Path addCurveToPoint: CGPointMake(51, 47.3) controlPoint1: CGPointMake(56.5, 48.6) controlPoint2: CGPointMake(53.9, 47.3)];
                [bezier2Path addCurveToPoint: CGPointMake(41.3, 57) controlPoint1: CGPointMake(45.6, 47.3) controlPoint2: CGPointMake(41.3, 51.7)];
                [bezier2Path addCurveToPoint: CGPointMake(41.3, 57.5) controlPoint1: CGPointMake(41.3, 57.2) controlPoint2: CGPointMake(41.3, 57.3)];
                [bezier2Path addCurveToPoint: CGPointMake(46.3, 60.5) controlPoint1: CGPointMake(43.3, 58) controlPoint2: CGPointMake(46.3, 60.5)];
                [bezier2Path addLineToPoint: CGPointMake(47.3, 60.7)];
                [bezier2Path addCurveToPoint: CGPointMake(53.3, 58.7) controlPoint1: CGPointMake(47.3, 60.8) controlPoint2: CGPointMake(51.1, 58.7)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier2Path fill];
                
                
                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
                [bezier3Path moveToPoint: CGPointMake(48.8, 68.2)];
                [bezier3Path addCurveToPoint: CGPointMake(46.4, 62.2) controlPoint1: CGPointMake(48.7, 65.9) controlPoint2: CGPointMake(47.8, 63.8)];
                [bezier3Path addCurveToPoint: CGPointMake(41.4, 59.2) controlPoint1: CGPointMake(45.1, 60.7) controlPoint2: CGPointMake(43.3, 59.6)];
                [bezier3Path addCurveToPoint: CGPointMake(39.2, 58.9) controlPoint1: CGPointMake(40.7, 59) controlPoint2: CGPointMake(39.9, 58.9)];
                [bezier3Path addCurveToPoint: CGPointMake(29.5, 68.6) controlPoint1: CGPointMake(33.8, 58.9) controlPoint2: CGPointMake(29.5, 63.3)];
                [bezier3Path addCurveToPoint: CGPointMake(39.2, 78.3) controlPoint1: CGPointMake(29.5, 74) controlPoint2: CGPointMake(33.9, 78.3)];
                [bezier3Path addCurveToPoint: CGPointMake(45.2, 76.2) controlPoint1: CGPointMake(41.5, 78.3) controlPoint2: CGPointMake(43.5, 77.5)];
                [bezier3Path addCurveToPoint: CGPointMake(48.9, 68.5) controlPoint1: CGPointMake(47.5, 74.4) controlPoint2: CGPointMake(48.9, 71.6)];
                [bezier3Path addCurveToPoint: CGPointMake(48.8, 68.2) controlPoint1: CGPointMake(48.9, 68.5) controlPoint2: CGPointMake(48.9, 68.3)];
                [bezier3Path closePath];
                bezier3Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier3Path fill];
                
                
                //// Group 10
                {
                    //// Rectangle Drawing
                    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(36.2, 65.7, 5.6, 2.2) cornerRadius: 1];
                    [fillColor2 setFill];
                    [rectanglePath fill];
                    
                    
                    //// Bezier 4 Drawing
                    UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
                    [bezier4Path moveToPoint: CGPointMake(39, 64.1)];
                    [bezier4Path addCurveToPoint: CGPointMake(40.1, 65.2) controlPoint1: CGPointMake(39.6, 64.1) controlPoint2: CGPointMake(40.1, 64.6)];
                    [bezier4Path addLineToPoint: CGPointMake(40.1, 68.6)];
                    [bezier4Path addCurveToPoint: CGPointMake(39, 69.7) controlPoint1: CGPointMake(40.1, 69.2) controlPoint2: CGPointMake(39.6, 69.7)];
                    [bezier4Path addLineToPoint: CGPointMake(39, 69.7)];
                    [bezier4Path addCurveToPoint: CGPointMake(37.9, 68.6) controlPoint1: CGPointMake(38.4, 69.7) controlPoint2: CGPointMake(37.9, 69.2)];
                    [bezier4Path addLineToPoint: CGPointMake(37.9, 65.2)];
                    [bezier4Path addCurveToPoint: CGPointMake(39, 64.1) controlPoint1: CGPointMake(37.9, 64.5) controlPoint2: CGPointMake(38.4, 64.1)];
                    [bezier4Path addLineToPoint: CGPointMake(39, 64.1)];
                    [bezier4Path closePath];
                    bezier4Path.miterLimit = 4;
                    
                    [fillColor2 setFill];
                    [bezier4Path fill];
                }
                
                
                //// Group 11
                {
                    //// Bezier 5 Drawing
                    UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
                    [bezier5Path moveToPoint: CGPointMake(55.8, 65.4)];
                    [bezier5Path addCurveToPoint: CGPointMake(54.2, 65.9) controlPoint1: CGPointMake(55.4, 65.8) controlPoint2: CGPointMake(54.7, 66)];
                    [bezier5Path addLineToPoint: CGPointMake(51.3, 65.4)];
                    [bezier5Path addCurveToPoint: CGPointMake(51, 64.6) controlPoint1: CGPointMake(50.8, 65.3) controlPoint2: CGPointMake(50.7, 64.9)];
                    [bezier5Path addLineToPoint: CGPointMake(51, 64.6)];
                    [bezier5Path addCurveToPoint: CGPointMake(52.6, 64.1) controlPoint1: CGPointMake(51.4, 64.2) controlPoint2: CGPointMake(52.1, 64)];
                    [bezier5Path addLineToPoint: CGPointMake(55.5, 64.6)];
                    [bezier5Path addCurveToPoint: CGPointMake(55.8, 65.4) controlPoint1: CGPointMake(56, 64.7) controlPoint2: CGPointMake(56.2, 65)];
                    [bezier5Path addLineToPoint: CGPointMake(55.8, 65.4)];
                    [bezier5Path closePath];
                    bezier5Path.miterLimit = 4;
                    
                    [fillColor2 setFill];
                    [bezier5Path fill];
                    
                    
                    //// Bezier 6 Drawing
                    UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
                    [bezier6Path moveToPoint: CGPointMake(55, 63.3)];
                    [bezier6Path addCurveToPoint: CGPointMake(55.3, 64.1) controlPoint1: CGPointMake(55.5, 63.4) controlPoint2: CGPointMake(55.6, 63.8)];
                    [bezier6Path addLineToPoint: CGPointMake(53.3, 66.2)];
                    [bezier6Path addCurveToPoint: CGPointMake(51.7, 66.7) controlPoint1: CGPointMake(52.9, 66.6) controlPoint2: CGPointMake(52.2, 66.8)];
                    [bezier6Path addLineToPoint: CGPointMake(51.7, 66.7)];
                    [bezier6Path addCurveToPoint: CGPointMake(51.4, 65.9) controlPoint1: CGPointMake(51.2, 66.6) controlPoint2: CGPointMake(51.1, 66.2)];
                    [bezier6Path addLineToPoint: CGPointMake(53.4, 63.8)];
                    [bezier6Path addCurveToPoint: CGPointMake(55, 63.3) controlPoint1: CGPointMake(53.8, 63.5) controlPoint2: CGPointMake(54.5, 63.3)];
                    [bezier6Path addLineToPoint: CGPointMake(55, 63.3)];
                    [bezier6Path closePath];
                    bezier6Path.miterLimit = 4;
                    
                    [fillColor2 setFill];
                    [bezier6Path fill];
                }
                
                
                //// Group 12
                {
                    //// Bezier 7 Drawing
                    UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
                    [bezier7Path moveToPoint: CGPointMake(49.1, 49.7)];
                    [bezier7Path addCurveToPoint: CGPointMake(48, 50.1) controlPoint1: CGPointMake(48.8, 50) controlPoint2: CGPointMake(48.3, 50.1)];
                    [bezier7Path addLineToPoint: CGPointMake(45.9, 49.7)];
                    [bezier7Path addCurveToPoint: CGPointMake(45.7, 49.1) controlPoint1: CGPointMake(45.5, 49.6) controlPoint2: CGPointMake(45.4, 49.4)];
                    [bezier7Path addLineToPoint: CGPointMake(45.7, 49.1)];
                    [bezier7Path addCurveToPoint: CGPointMake(46.8, 48.7) controlPoint1: CGPointMake(46, 48.8) controlPoint2: CGPointMake(46.5, 48.7)];
                    [bezier7Path addLineToPoint: CGPointMake(48.9, 49.1)];
                    [bezier7Path addCurveToPoint: CGPointMake(49.1, 49.7) controlPoint1: CGPointMake(49.2, 49.2) controlPoint2: CGPointMake(49.3, 49.5)];
                    [bezier7Path addLineToPoint: CGPointMake(49.1, 49.7)];
                    [bezier7Path closePath];
                    bezier7Path.miterLimit = 4;
                    
                    [fillColor2 setFill];
                    [bezier7Path fill];
                    
                    
                    //// Bezier 8 Drawing
                    UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
                    [bezier8Path moveToPoint: CGPointMake(48.5, 48.2)];
                    [bezier8Path addCurveToPoint: CGPointMake(48.7, 48.8) controlPoint1: CGPointMake(48.9, 48.3) controlPoint2: CGPointMake(49, 48.5)];
                    [bezier8Path addLineToPoint: CGPointMake(47.2, 50.3)];
                    [bezier8Path addCurveToPoint: CGPointMake(46.1, 50.7) controlPoint1: CGPointMake(46.9, 50.6) controlPoint2: CGPointMake(46.4, 50.7)];
                    [bezier8Path addLineToPoint: CGPointMake(46.1, 50.7)];
                    [bezier8Path addCurveToPoint: CGPointMake(45.9, 50.1) controlPoint1: CGPointMake(45.7, 50.6) controlPoint2: CGPointMake(45.6, 50.4)];
                    [bezier8Path addLineToPoint: CGPointMake(47.4, 48.6)];
                    [bezier8Path addCurveToPoint: CGPointMake(48.5, 48.2) controlPoint1: CGPointMake(47.6, 48.3) controlPoint2: CGPointMake(48.1, 48.2)];
                    [bezier8Path addLineToPoint: CGPointMake(48.5, 48.2)];
                    [bezier8Path closePath];
                    bezier8Path.miterLimit = 4;
                    
                    [fillColor2 setFill];
                    [bezier8Path fill];
                }
                
                
                //// Bezier 9 Drawing
                UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
                [bezier9Path moveToPoint: CGPointMake(62.1, 54)];
                [bezier9Path addCurveToPoint: CGPointMake(61.8, 58.7) controlPoint1: CGPointMake(62.1, 54) controlPoint2: CGPointMake(62.6, 56.7)];
                [bezier9Path addCurveToPoint: CGPointMake(61.4, 61.1) controlPoint1: CGPointMake(61, 60.6) controlPoint2: CGPointMake(61.4, 61.1)];
                [bezier9Path addCurveToPoint: CGPointMake(62.7, 62.5) controlPoint1: CGPointMake(61.4, 61.1) controlPoint2: CGPointMake(62.4, 61.5)];
                [bezier9Path addCurveToPoint: CGPointMake(63.6, 64.3) controlPoint1: CGPointMake(63, 63.5) controlPoint2: CGPointMake(63.6, 64.3)];
                [bezier9Path addCurveToPoint: CGPointMake(72.8, 57) controlPoint1: CGPointMake(63.6, 64.3) controlPoint2: CGPointMake(70.4, 62.3)];
                [bezier9Path addCurveToPoint: CGPointMake(74.4, 51.2) controlPoint1: CGPointMake(75.2, 51.7) controlPoint2: CGPointMake(74.4, 51.2)];
                [bezier9Path addCurveToPoint: CGPointMake(66.3, 51.9) controlPoint1: CGPointMake(74.4, 51.2) controlPoint2: CGPointMake(69.2, 50.6)];
                [bezier9Path addCurveToPoint: CGPointMake(62.1, 54) controlPoint1: CGPointMake(63.5, 53.3) controlPoint2: CGPointMake(62.1, 54)];
                [bezier9Path closePath];
                bezier9Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier9Path fill];
                
                
                //// Bezier 10 Drawing
                UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
                [bezier10Path moveToPoint: CGPointMake(39.3, 57.2)];
                [bezier10Path addCurveToPoint: CGPointMake(35.8, 57.2) controlPoint1: CGPointMake(39.3, 57.2) controlPoint2: CGPointMake(38.2, 56.6)];
                [bezier10Path addCurveToPoint: CGPointMake(33.6, 58.8) controlPoint1: CGPointMake(33.5, 57.8) controlPoint2: CGPointMake(33.6, 58.8)];
                [bezier10Path addCurveToPoint: CGPointMake(24, 50.7) controlPoint1: CGPointMake(33.6, 58.8) controlPoint2: CGPointMake(25.9, 56.6)];
                [bezier10Path addCurveToPoint: CGPointMake(22.6, 39.4) controlPoint1: CGPointMake(22.1, 44.8) controlPoint2: CGPointMake(22.6, 39.4)];
                [bezier10Path addCurveToPoint: CGPointMake(34.8, 45.7) controlPoint1: CGPointMake(22.6, 39.4) controlPoint2: CGPointMake(31.9, 40.5)];
                [bezier10Path addCurveToPoint: CGPointMake(39.3, 57.2) controlPoint1: CGPointMake(37.6, 50.9) controlPoint2: CGPointMake(39.3, 57.2)];
                [bezier10Path closePath];
                bezier10Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier10Path fill];
                
                
                //// Bezier 11 Drawing
                UIBezierPath* bezier11Path = UIBezierPath.bezierPath;
                [bezier11Path moveToPoint: CGPointMake(36.3, 44.4)];
                [bezier11Path addCurveToPoint: CGPointMake(38.2, 40.4) controlPoint1: CGPointMake(36.3, 44.4) controlPoint2: CGPointMake(37.3, 42)];
                [bezier11Path addCurveToPoint: CGPointMake(41.3, 37) controlPoint1: CGPointMake(39.1, 38.9) controlPoint2: CGPointMake(41.3, 37)];
                [bezier11Path addCurveToPoint: CGPointMake(44.4, 42.5) controlPoint1: CGPointMake(41.3, 37) controlPoint2: CGPointMake(43.5, 40.3)];
                [bezier11Path addCurveToPoint: CGPointMake(45.6, 47) controlPoint1: CGPointMake(45.3, 44.6) controlPoint2: CGPointMake(45.6, 47)];
                [bezier11Path addCurveToPoint: CGPointMake(41.2, 50.1) controlPoint1: CGPointMake(45.6, 47) controlPoint2: CGPointMake(42.3, 48)];
                [bezier11Path addCurveToPoint: CGPointMake(39.9, 54.3) controlPoint1: CGPointMake(40.2, 52.2) controlPoint2: CGPointMake(39.9, 54.3)];
                [bezier11Path addCurveToPoint: CGPointMake(38.4, 48.8) controlPoint1: CGPointMake(39.9, 54.3) controlPoint2: CGPointMake(39.7, 52)];
                [bezier11Path addCurveToPoint: CGPointMake(36.3, 44.4) controlPoint1: CGPointMake(37.2, 45.6) controlPoint2: CGPointMake(36.3, 44.4)];
                [bezier11Path closePath];
                bezier11Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier11Path fill];
            }
        }
        
        
        //// Group 13
        {
            //// Bezier 12 Drawing
            UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
            [bezier12Path moveToPoint: CGPointMake(43.4, 28.9)];
            [bezier12Path addCurveToPoint: CGPointMake(49.6, 31.8) controlPoint1: CGPointMake(43.4, 28.9) controlPoint2: CGPointMake(47, 31.6)];
            [bezier12Path addCurveToPoint: CGPointMake(55.1, 29.9) controlPoint1: CGPointMake(52.2, 32) controlPoint2: CGPointMake(53.1, 30.8)];
            [bezier12Path addCurveToPoint: CGPointMake(60.3, 24.8) controlPoint1: CGPointMake(57.1, 29) controlPoint2: CGPointMake(59.7, 27)];
            [bezier12Path addCurveToPoint: CGPointMake(59.2, 21.8) controlPoint1: CGPointMake(60.9, 22.6) controlPoint2: CGPointMake(59.2, 21.8)];
            [bezier12Path addCurveToPoint: CGPointMake(58.3, 23.2) controlPoint1: CGPointMake(59.2, 21.8) controlPoint2: CGPointMake(58.9, 22.2)];
            [bezier12Path addCurveToPoint: CGPointMake(57.1, 25.1) controlPoint1: CGPointMake(57.7, 24.3) controlPoint2: CGPointMake(57.5, 23.9)];
            [bezier12Path addCurveToPoint: CGPointMake(56.7, 26.3) controlPoint1: CGPointMake(56.7, 26.3) controlPoint2: CGPointMake(56.7, 26.3)];
            [bezier12Path addCurveToPoint: CGPointMake(55.7, 23.4) controlPoint1: CGPointMake(56.7, 26.3) controlPoint2: CGPointMake(56.6, 24.5)];
            [bezier12Path addCurveToPoint: CGPointMake(53.5, 21.8) controlPoint1: CGPointMake(54.8, 22.3) controlPoint2: CGPointMake(53.5, 21.8)];
            [bezier12Path addCurveToPoint: CGPointMake(53, 25.4) controlPoint1: CGPointMake(53.5, 21.8) controlPoint2: CGPointMake(53, 23.8)];
            [bezier12Path addCurveToPoint: CGPointMake(53.2, 27.5) controlPoint1: CGPointMake(53, 27) controlPoint2: CGPointMake(53.2, 27.5)];
            [bezier12Path addCurveToPoint: CGPointMake(51.1, 24.7) controlPoint1: CGPointMake(53.2, 27.5) controlPoint2: CGPointMake(52.5, 25.4)];
            [bezier12Path addCurveToPoint: CGPointMake(47.5, 23.8) controlPoint1: CGPointMake(49.7, 24) controlPoint2: CGPointMake(47.5, 23.8)];
            [bezier12Path addCurveToPoint: CGPointMake(48.5, 27.2) controlPoint1: CGPointMake(47.5, 23.8) controlPoint2: CGPointMake(47.5, 26)];
            [bezier12Path addCurveToPoint: CGPointMake(50.7, 29) controlPoint1: CGPointMake(49.6, 28.4) controlPoint2: CGPointMake(50.7, 29)];
            [bezier12Path addCurveToPoint: CGPointMake(48.7, 28.7) controlPoint1: CGPointMake(50.7, 29) controlPoint2: CGPointMake(50.4, 29.4)];
            [bezier12Path addCurveToPoint: CGPointMake(45.5, 28.3) controlPoint1: CGPointMake(47, 28) controlPoint2: CGPointMake(46.9, 28.1)];
            [bezier12Path addCurveToPoint: CGPointMake(43.4, 28.9) controlPoint1: CGPointMake(44.2, 28.5) controlPoint2: CGPointMake(43.4, 28.9)];
            [bezier12Path closePath];
            bezier12Path.miterLimit = 4;
            
            bezier12Path.usesEvenOddFillRule = YES;
            
            [fillColor1 setFill];
            [bezier12Path fill];
            
            
            //// Bezier 13 Drawing
            UIBezierPath* bezier13Path = UIBezierPath.bezierPath;
            [bezier13Path moveToPoint: CGPointMake(66.2, 28.3)];
            [bezier13Path addCurveToPoint: CGPointMake(53.8, 29.9) controlPoint1: CGPointMake(61.1, 24.9) controlPoint2: CGPointMake(58.9, 27.4)];
            [bezier13Path addCurveToPoint: CGPointMake(48.5, 33.4) controlPoint1: CGPointMake(51.5, 31) controlPoint2: CGPointMake(49.7, 32.2)];
            [bezier13Path addCurveToPoint: CGPointMake(47.1, 39.2) controlPoint1: CGPointMake(47, 35) controlPoint2: CGPointMake(46.4, 36.9)];
            [bezier13Path addCurveToPoint: CGPointMake(53.3, 44.9) controlPoint1: CGPointMake(48.3, 43.4) controlPoint2: CGPointMake(52.2, 44.6)];
            [bezier13Path addCurveToPoint: CGPointMake(64, 49.2) controlPoint1: CGPointMake(57.2, 45.7) controlPoint2: CGPointMake(60.9, 50.9)];
            [bezier13Path addCurveToPoint: CGPointMake(67.1, 41.7) controlPoint1: CGPointMake(67.1, 47.5) controlPoint2: CGPointMake(66.8, 45.3)];
            [bezier13Path addCurveToPoint: CGPointMake(66.2, 28.3) controlPoint1: CGPointMake(67.5, 38.1) controlPoint2: CGPointMake(71.3, 31.6)];
            [bezier13Path closePath];
            bezier13Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier13Path fill];
            
            
            //// Oval 3 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 62.5, 31.15);
            CGContextRotateCTM(context, -31.65 * M_PI / 180);
            
            UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-0.9, -1.8, 1.8, 3.6)];
            [fillColor2 setFill];
            [oval3Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Oval 4 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 60.9, 35.7);
            CGContextRotateCTM(context, -31.65 * M_PI / 180);
            
            UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-0.9, -1.8, 1.8, 3.6)];
            [fillColor2 setFill];
            [oval4Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Oval 5 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 55.8, 33.5);
            CGContextRotateCTM(context, -31.7 * M_PI / 180);
            
            UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-0.9, -1.8, 1.8, 3.6)];
            [fillColor2 setFill];
            [oval5Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Bezier 14 Drawing
            UIBezierPath* bezier14Path = UIBezierPath.bezierPath;
            [bezier14Path moveToPoint: CGPointMake(59.6, 40)];
            [bezier14Path addCurveToPoint: CGPointMake(59.8, 42) controlPoint1: CGPointMake(60.1, 40.9) controlPoint2: CGPointMake(60.2, 41.8)];
            [bezier14Path addCurveToPoint: CGPointMake(58.1, 40.9) controlPoint1: CGPointMake(59.4, 42.3) controlPoint2: CGPointMake(58.6, 41.8)];
            [bezier14Path addCurveToPoint: CGPointMake(57.9, 38.9) controlPoint1: CGPointMake(57.6, 40) controlPoint2: CGPointMake(57.5, 39.1)];
            [bezier14Path addCurveToPoint: CGPointMake(59.6, 40) controlPoint1: CGPointMake(58.3, 38.7) controlPoint2: CGPointMake(59.1, 39.1)];
            [bezier14Path closePath];
            bezier14Path.miterLimit = 4;
            
            [fillColor2 setFill];
            [bezier14Path fill];
            
            
            //// Oval 6 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 53.5, 38.5);
            CGContextRotateCTM(context, -31.7 * M_PI / 180);
            
            UIBezierPath* oval6Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-0.9, -1.8, 1.8, 3.6)];
            [fillColor2 setFill];
            [oval6Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Oval 7 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 64.2, 40.6);
            CGContextRotateCTM(context, -31.65 * M_PI / 180);
            
            UIBezierPath* oval7Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-0.9, -1.8, 1.8, 3.6)];
            [fillColor2 setFill];
            [oval7Path fill];
            
            CGContextRestoreGState(context);
        }
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
