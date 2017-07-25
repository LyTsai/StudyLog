//
//  ASymbol_Support.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Support.h"

@implementation ASymbol_Support

@synthesize fillColor1, strokeColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.843 green: 0.824 blue: 0.447 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.71 green: 0.694 blue: 0.282 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.608 green: 0.616 blue: 0.216 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor5 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    strokeColor1 = [UIColor colorWithRed: 0.584 green: 0.769 blue: 0.239 alpha: 1];
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
                                        CGPointMake(49.97, 49.96), 0,
                                        CGPointMake(49.97, 49.96), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.2, 3.45, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.33, -42.69),
                                        CGPointMake(50.33, 49.53),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Group 8
        {
            //// Oval 3 Drawing
            UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(65.5, 40, 7.2, 7.2)];
            [fillColor1 setFill];
            [oval3Path fill];
            [strokeColor1 setStroke];
            oval3Path.lineWidth = 0.5;
            [oval3Path stroke];
            
            
            //// Bezier Drawing
            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(73.5, 77.5)];
            [bezierPath addCurveToPoint: CGPointMake(71.7, 79.3) controlPoint1: CGPointMake(73.5, 78.5) controlPoint2: CGPointMake(72.7, 79.3)];
            [bezierPath addLineToPoint: CGPointMake(71.3, 79.3)];
            [bezierPath addCurveToPoint: CGPointMake(69.5, 77.5) controlPoint1: CGPointMake(70.3, 79.3) controlPoint2: CGPointMake(69.5, 78.5)];
            [bezierPath addLineToPoint: CGPointMake(69.4, 59)];
            [bezierPath addCurveToPoint: CGPointMake(71.2, 57.2) controlPoint1: CGPointMake(69.4, 58) controlPoint2: CGPointMake(70.2, 57.2)];
            [bezierPath addLineToPoint: CGPointMake(71.7, 57.2)];
            [bezierPath addCurveToPoint: CGPointMake(73.5, 59) controlPoint1: CGPointMake(72.7, 57.2) controlPoint2: CGPointMake(73.5, 58)];
            [bezierPath addLineToPoint: CGPointMake(73.5, 77.5)];
            [bezierPath closePath];
            [fillColor1 setFill];
            [bezierPath fill];
            [strokeColor1 setStroke];
            bezierPath.lineWidth = 0.5;
            [bezierPath stroke];
            
            
            //// Rectangle Drawing
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(64.7, 57.2, 4, 22.1) cornerRadius: 1.8];
            [fillColor1 setFill];
            [rectanglePath fill];
            [strokeColor1 setStroke];
            rectanglePath.lineWidth = 0.5;
            [rectanglePath stroke];
            
            
            //// Rectangle 2 Drawing
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(64.8, 47.7, 8.7, 13.9) cornerRadius: 1.8];
            [fillColor1 setFill];
            [rectangle2Path fill];
            [strokeColor1 setStroke];
            rectangle2Path.lineWidth = 0.5;
            [rectangle2Path stroke];
            
            
            //// Group 9
            {
                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                [bezier2Path moveToPoint: CGPointMake(75.7, 45.3)];
                [bezier2Path addCurveToPoint: CGPointMake(76.5, 46.9) controlPoint1: CGPointMake(75.5, 46) controlPoint2: CGPointMake(75.8, 46.7)];
                [bezier2Path addLineToPoint: CGPointMake(76.5, 46.9)];
                [bezier2Path addCurveToPoint: CGPointMake(78.1, 46.1) controlPoint1: CGPointMake(77.2, 47.1) controlPoint2: CGPointMake(77.9, 46.8)];
                [bezier2Path addLineToPoint: CGPointMake(80.6, 39)];
                [bezier2Path addCurveToPoint: CGPointMake(79.8, 37.4) controlPoint1: CGPointMake(80.8, 38.3) controlPoint2: CGPointMake(80.5, 37.6)];
                [bezier2Path addLineToPoint: CGPointMake(79.8, 37.4)];
                [bezier2Path addCurveToPoint: CGPointMake(78.2, 38.2) controlPoint1: CGPointMake(79.1, 37.2) controlPoint2: CGPointMake(78.4, 37.5)];
                [bezier2Path addLineToPoint: CGPointMake(75.7, 45.3)];
                [bezier2Path closePath];
                [fillColor1 setFill];
                [bezier2Path fill];
                [strokeColor1 setStroke];
                bezier2Path.lineWidth = 0.5;
                [bezier2Path stroke];
                
                
                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
                [bezier3Path moveToPoint: CGPointMake(71.2, 51.3)];
                [bezier3Path addCurveToPoint: CGPointMake(75.3, 49.9) controlPoint1: CGPointMake(71.2, 51.3) controlPoint2: CGPointMake(73.4, 51.3)];
                [bezier3Path addCurveToPoint: CGPointMake(78.4, 45.5) controlPoint1: CGPointMake(77.7, 48.1) controlPoint2: CGPointMake(78.4, 45.5)];
                [bezier3Path addLineToPoint: CGPointMake(76.4, 43.5)];
                [bezier3Path addCurveToPoint: CGPointMake(74.4, 47.2) controlPoint1: CGPointMake(76.4, 43.5) controlPoint2: CGPointMake(75.6, 46.2)];
                [bezier3Path addCurveToPoint: CGPointMake(71.9, 47.8) controlPoint1: CGPointMake(73.8, 47.7) controlPoint2: CGPointMake(71.9, 47.8)];
                [bezier3Path addLineToPoint: CGPointMake(71.2, 51.3)];
                [bezier3Path closePath];
                [fillColor1 setFill];
                [bezier3Path fill];
                [strokeColor1 setStroke];
                bezier3Path.lineWidth = 0.5;
                [bezier3Path stroke];
            }
            
            
            //// Group 10
            {
                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
                [bezier4Path moveToPoint: CGPointMake(62.7, 45.3)];
                [bezier4Path addCurveToPoint: CGPointMake(61.9, 46.9) controlPoint1: CGPointMake(62.9, 46) controlPoint2: CGPointMake(62.6, 46.7)];
                [bezier4Path addLineToPoint: CGPointMake(61.9, 46.9)];
                [bezier4Path addCurveToPoint: CGPointMake(60.3, 46.1) controlPoint1: CGPointMake(61.2, 47.1) controlPoint2: CGPointMake(60.5, 46.8)];
                [bezier4Path addLineToPoint: CGPointMake(57.8, 39)];
                [bezier4Path addCurveToPoint: CGPointMake(58.6, 37.4) controlPoint1: CGPointMake(57.6, 38.3) controlPoint2: CGPointMake(57.9, 37.6)];
                [bezier4Path addLineToPoint: CGPointMake(58.6, 37.4)];
                [bezier4Path addCurveToPoint: CGPointMake(60.2, 38.2) controlPoint1: CGPointMake(59.3, 37.2) controlPoint2: CGPointMake(60, 37.5)];
                [bezier4Path addLineToPoint: CGPointMake(62.7, 45.3)];
                [bezier4Path closePath];
                [fillColor1 setFill];
                [bezier4Path fill];
                [strokeColor1 setStroke];
                bezier4Path.lineWidth = 0.5;
                [bezier4Path stroke];
                
                
                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
                [bezier5Path moveToPoint: CGPointMake(67.2, 51.3)];
                [bezier5Path addCurveToPoint: CGPointMake(63.1, 49.9) controlPoint1: CGPointMake(67.2, 51.3) controlPoint2: CGPointMake(65, 51.3)];
                [bezier5Path addCurveToPoint: CGPointMake(60, 45.5) controlPoint1: CGPointMake(60.7, 48.1) controlPoint2: CGPointMake(60, 45.5)];
                [bezier5Path addLineToPoint: CGPointMake(62, 43.5)];
                [bezier5Path addCurveToPoint: CGPointMake(64, 47.2) controlPoint1: CGPointMake(62, 43.5) controlPoint2: CGPointMake(62.8, 46.2)];
                [bezier5Path addCurveToPoint: CGPointMake(66.5, 47.8) controlPoint1: CGPointMake(64.6, 47.7) controlPoint2: CGPointMake(66.5, 47.8)];
                [bezier5Path addLineToPoint: CGPointMake(67.2, 51.3)];
                [bezier5Path closePath];
                [fillColor1 setFill];
                [bezier5Path fill];
                [strokeColor1 setStroke];
                bezier5Path.lineWidth = 0.5;
                [bezier5Path stroke];
            }
        }
        
        
        //// Group 11
        {
            //// Oval 4 Drawing
            UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(28.4, 40, 7.2, 7.2)];
            [fillColor1 setFill];
            [oval4Path fill];
            [strokeColor1 setStroke];
            oval4Path.lineWidth = 0.5;
            [oval4Path stroke];
            
            
            //// Rectangle 3 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 34.35, 68.25);
            CGContextRotateCTM(context, -0.3 * M_PI / 180);
            
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(-2, -11.05, 4, 22.1) cornerRadius: 1.8];
            [fillColor1 setFill];
            [rectangle3Path fill];
            [strokeColor1 setStroke];
            rectangle3Path.lineWidth = 0.5;
            [rectangle3Path stroke];
            
            CGContextRestoreGState(context);
            
            
            //// Rectangle 4 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 29.55, 68.25);
            CGContextRotateCTM(context, -0.3 * M_PI / 180);
            
            UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(-2, -11.05, 4, 22.1) cornerRadius: 1.8];
            [fillColor1 setFill];
            [rectangle4Path fill];
            [strokeColor1 setStroke];
            rectangle4Path.lineWidth = 0.5;
            [rectangle4Path stroke];
            
            CGContextRestoreGState(context);
            
            
            //// Rectangle 5 Drawing
            UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(27.7, 47.7, 8.7, 13.9) cornerRadius: 1.8];
            [fillColor1 setFill];
            [rectangle5Path fill];
            [strokeColor1 setStroke];
            rectangle5Path.lineWidth = 0.5;
            [rectangle5Path stroke];
            
            
            //// Group 12
            {
                //// Bezier 6 Drawing
                UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
                [bezier6Path moveToPoint: CGPointMake(38.6, 45.3)];
                [bezier6Path addCurveToPoint: CGPointMake(39.4, 46.9) controlPoint1: CGPointMake(38.4, 46) controlPoint2: CGPointMake(38.7, 46.7)];
                [bezier6Path addLineToPoint: CGPointMake(39.4, 46.9)];
                [bezier6Path addCurveToPoint: CGPointMake(41, 46.1) controlPoint1: CGPointMake(40.1, 47.1) controlPoint2: CGPointMake(40.8, 46.8)];
                [bezier6Path addLineToPoint: CGPointMake(43.5, 39)];
                [bezier6Path addCurveToPoint: CGPointMake(42.7, 37.4) controlPoint1: CGPointMake(43.7, 38.3) controlPoint2: CGPointMake(43.4, 37.6)];
                [bezier6Path addLineToPoint: CGPointMake(42.7, 37.4)];
                [bezier6Path addCurveToPoint: CGPointMake(41.1, 38.2) controlPoint1: CGPointMake(42, 37.2) controlPoint2: CGPointMake(41.3, 37.5)];
                [bezier6Path addLineToPoint: CGPointMake(38.6, 45.3)];
                [bezier6Path closePath];
                [fillColor1 setFill];
                [bezier6Path fill];
                [strokeColor1 setStroke];
                bezier6Path.lineWidth = 0.5;
                [bezier6Path stroke];
                
                
                //// Bezier 7 Drawing
                UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
                [bezier7Path moveToPoint: CGPointMake(34.1, 51.3)];
                [bezier7Path addCurveToPoint: CGPointMake(38.2, 49.9) controlPoint1: CGPointMake(34.1, 51.3) controlPoint2: CGPointMake(36.3, 51.3)];
                [bezier7Path addCurveToPoint: CGPointMake(41.3, 45.5) controlPoint1: CGPointMake(40.6, 48.1) controlPoint2: CGPointMake(41.3, 45.5)];
                [bezier7Path addLineToPoint: CGPointMake(39.3, 43.5)];
                [bezier7Path addCurveToPoint: CGPointMake(37.3, 47.2) controlPoint1: CGPointMake(39.3, 43.5) controlPoint2: CGPointMake(38.5, 46.2)];
                [bezier7Path addCurveToPoint: CGPointMake(34.8, 47.8) controlPoint1: CGPointMake(36.7, 47.7) controlPoint2: CGPointMake(34.8, 47.8)];
                [bezier7Path addLineToPoint: CGPointMake(34.1, 51.3)];
                [bezier7Path closePath];
                [fillColor1 setFill];
                [bezier7Path fill];
                [strokeColor1 setStroke];
                bezier7Path.lineWidth = 0.5;
                [bezier7Path stroke];
            }
            
            
            //// Group 13
            {
                //// Bezier 8 Drawing
                UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
                [bezier8Path moveToPoint: CGPointMake(25.6, 45.3)];
                [bezier8Path addCurveToPoint: CGPointMake(24.8, 46.9) controlPoint1: CGPointMake(25.8, 46) controlPoint2: CGPointMake(25.5, 46.7)];
                [bezier8Path addLineToPoint: CGPointMake(24.8, 46.9)];
                [bezier8Path addCurveToPoint: CGPointMake(23.2, 46.1) controlPoint1: CGPointMake(24.1, 47.1) controlPoint2: CGPointMake(23.4, 46.8)];
                [bezier8Path addLineToPoint: CGPointMake(20.7, 39)];
                [bezier8Path addCurveToPoint: CGPointMake(21.5, 37.4) controlPoint1: CGPointMake(20.5, 38.3) controlPoint2: CGPointMake(20.8, 37.6)];
                [bezier8Path addLineToPoint: CGPointMake(21.5, 37.4)];
                [bezier8Path addCurveToPoint: CGPointMake(23.1, 38.2) controlPoint1: CGPointMake(22.2, 37.2) controlPoint2: CGPointMake(22.9, 37.5)];
                [bezier8Path addLineToPoint: CGPointMake(25.6, 45.3)];
                [bezier8Path closePath];
                [fillColor1 setFill];
                [bezier8Path fill];
                [strokeColor1 setStroke];
                bezier8Path.lineWidth = 0.5;
                [bezier8Path stroke];
                
                
                //// Bezier 9 Drawing
                UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
                [bezier9Path moveToPoint: CGPointMake(30.1, 51.3)];
                [bezier9Path addCurveToPoint: CGPointMake(26, 49.9) controlPoint1: CGPointMake(30.1, 51.3) controlPoint2: CGPointMake(27.9, 51.3)];
                [bezier9Path addCurveToPoint: CGPointMake(22.9, 45.5) controlPoint1: CGPointMake(23.6, 48.1) controlPoint2: CGPointMake(22.9, 45.5)];
                [bezier9Path addLineToPoint: CGPointMake(24.9, 43.5)];
                [bezier9Path addCurveToPoint: CGPointMake(26.9, 47.2) controlPoint1: CGPointMake(24.9, 43.5) controlPoint2: CGPointMake(25.7, 46.2)];
                [bezier9Path addCurveToPoint: CGPointMake(29.4, 47.8) controlPoint1: CGPointMake(27.5, 47.7) controlPoint2: CGPointMake(29.4, 47.8)];
                [bezier9Path addLineToPoint: CGPointMake(30.1, 51.3)];
                [bezier9Path closePath];
                [fillColor1 setFill];
                [bezier9Path fill];
                [strokeColor1 setStroke];
                bezier9Path.lineWidth = 0.5;
                [bezier9Path stroke];
            }
        }
        
        
        //// Group 14
        {
            //// Oval 5 Drawing
            UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(45.5, 26.7, 10.6, 10.6)];
            [fillColor1 setFill];
            [oval5Path fill];
            
            
            //// Rectangle 6 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 54.4, 68.75);
            CGContextRotateCTM(context, -0.2 * M_PI / 180);
            
            UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(-2.95, -16.45, 5.9, 32.9) cornerRadius: 2.8];
            [fillColor1 setFill];
            [rectangle6Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Rectangle 7 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 47.3, 68.75);
            CGContextRotateCTM(context, -0.2 * M_PI / 180);
            
            UIBezierPath* rectangle7Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(-2.95, -16.45, 5.9, 32.9) cornerRadius: 2.8];
            [fillColor1 setFill];
            [rectangle7Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Rectangle 8 Drawing
            UIBezierPath* rectangle8Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(44.3, 38.2, 13, 20.7) cornerRadius: 2.8];
            [fillColor1 setFill];
            [rectangle8Path fill];
            
            
            //// Group 15
            {
                //// Bezier 10 Drawing
                UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
                [bezier10Path moveToPoint: CGPointMake(60.6, 34.6)];
                [bezier10Path addCurveToPoint: CGPointMake(61.8, 37) controlPoint1: CGPointMake(60.3, 35.6) controlPoint2: CGPointMake(60.8, 36.7)];
                [bezier10Path addLineToPoint: CGPointMake(61.8, 37)];
                [bezier10Path addCurveToPoint: CGPointMake(64.2, 35.8) controlPoint1: CGPointMake(62.8, 37.3) controlPoint2: CGPointMake(63.9, 36.8)];
                [bezier10Path addLineToPoint: CGPointMake(67.9, 25.2)];
                [bezier10Path addCurveToPoint: CGPointMake(66.7, 22.8) controlPoint1: CGPointMake(68.2, 24.2) controlPoint2: CGPointMake(67.7, 23.1)];
                [bezier10Path addLineToPoint: CGPointMake(66.7, 22.8)];
                [bezier10Path addCurveToPoint: CGPointMake(64.3, 24) controlPoint1: CGPointMake(65.7, 22.5) controlPoint2: CGPointMake(64.6, 23)];
                [bezier10Path addLineToPoint: CGPointMake(60.6, 34.6)];
                [bezier10Path closePath];
                bezier10Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier10Path fill];
                
                
                //// Bezier 11 Drawing
                UIBezierPath* bezier11Path = UIBezierPath.bezierPath;
                [bezier11Path moveToPoint: CGPointMake(53.9, 43.5)];
                [bezier11Path addCurveToPoint: CGPointMake(60, 41.5) controlPoint1: CGPointMake(53.9, 43.5) controlPoint2: CGPointMake(57.2, 43.6)];
                [bezier11Path addCurveToPoint: CGPointMake(64.6, 34.9) controlPoint1: CGPointMake(63.5, 38.9) controlPoint2: CGPointMake(64.6, 34.9)];
                [bezier11Path addLineToPoint: CGPointMake(61.6, 32)];
                [bezier11Path addCurveToPoint: CGPointMake(58.6, 37.5) controlPoint1: CGPointMake(61.6, 32) controlPoint2: CGPointMake(60.4, 36)];
                [bezier11Path addCurveToPoint: CGPointMake(54.9, 38.3) controlPoint1: CGPointMake(57.7, 38.3) controlPoint2: CGPointMake(54.9, 38.3)];
                [bezier11Path addLineToPoint: CGPointMake(53.9, 43.5)];
                [bezier11Path closePath];
                bezier11Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier11Path fill];
            }
            
            
            //// Group 16
            {
                //// Bezier 12 Drawing
                UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
                [bezier12Path moveToPoint: CGPointMake(41.3, 34.6)];
                [bezier12Path addCurveToPoint: CGPointMake(40.1, 37) controlPoint1: CGPointMake(41.6, 35.6) controlPoint2: CGPointMake(41.1, 36.7)];
                [bezier12Path addLineToPoint: CGPointMake(40.1, 37)];
                [bezier12Path addCurveToPoint: CGPointMake(37.7, 35.8) controlPoint1: CGPointMake(39.1, 37.3) controlPoint2: CGPointMake(38, 36.8)];
                [bezier12Path addLineToPoint: CGPointMake(34, 25.2)];
                [bezier12Path addCurveToPoint: CGPointMake(35.2, 22.8) controlPoint1: CGPointMake(33.7, 24.2) controlPoint2: CGPointMake(34.2, 23.1)];
                [bezier12Path addLineToPoint: CGPointMake(35.2, 22.8)];
                [bezier12Path addCurveToPoint: CGPointMake(37.6, 24) controlPoint1: CGPointMake(36.2, 22.5) controlPoint2: CGPointMake(37.3, 23)];
                [bezier12Path addLineToPoint: CGPointMake(41.3, 34.6)];
                [bezier12Path closePath];
                bezier12Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier12Path fill];
                
                
                //// Bezier 13 Drawing
                UIBezierPath* bezier13Path = UIBezierPath.bezierPath;
                [bezier13Path moveToPoint: CGPointMake(48, 43.5)];
                [bezier13Path addCurveToPoint: CGPointMake(41.9, 41.5) controlPoint1: CGPointMake(48, 43.5) controlPoint2: CGPointMake(44.7, 43.6)];
                [bezier13Path addCurveToPoint: CGPointMake(37.3, 34.9) controlPoint1: CGPointMake(38.4, 38.9) controlPoint2: CGPointMake(37.3, 34.9)];
                [bezier13Path addLineToPoint: CGPointMake(40.3, 32)];
                [bezier13Path addCurveToPoint: CGPointMake(43.3, 37.5) controlPoint1: CGPointMake(40.3, 32) controlPoint2: CGPointMake(41.5, 36)];
                [bezier13Path addCurveToPoint: CGPointMake(47, 38.3) controlPoint1: CGPointMake(44.2, 38.3) controlPoint2: CGPointMake(47, 38.3)];
                [bezier13Path addLineToPoint: CGPointMake(48, 43.5)];
                [bezier13Path closePath];
                bezier13Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier13Path fill];
            }
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
