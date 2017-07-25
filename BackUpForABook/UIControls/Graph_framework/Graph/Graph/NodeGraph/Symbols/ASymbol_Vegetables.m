//
//  ASymbol_Vegetables.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Vegetables.h"

@implementation ASymbol_Vegetables

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
                                        CGPointMake(49.98, 50.03), 0,
                                        CGPointMake(49.98, 50.03), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.2, 3.55, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.34, -42.63),
                                        CGPointMake(50.34, 49.6),
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
            [bezierPath moveToPoint: CGPointMake(33.8, 54.9)];
            [bezierPath addCurveToPoint: CGPointMake(41.6, 54.3) controlPoint1: CGPointMake(33.8, 54.9) controlPoint2: CGPointMake(38.1, 52)];
            [bezierPath addCurveToPoint: CGPointMake(43.8, 66.6) controlPoint1: CGPointMake(45.1, 56.6) controlPoint2: CGPointMake(45.6, 61.5)];
            [bezierPath addCurveToPoint: CGPointMake(39, 73.7) controlPoint1: CGPointMake(41.9, 71.6) controlPoint2: CGPointMake(41.1, 73.7)];
            [bezierPath addCurveToPoint: CGPointMake(33.4, 72.4) controlPoint1: CGPointMake(37, 73.7) controlPoint2: CGPointMake(35.4, 72.3)];
            [bezierPath addCurveToPoint: CGPointMake(28.9, 73.8) controlPoint1: CGPointMake(31.4, 72.5) controlPoint2: CGPointMake(30.7, 74)];
            [bezierPath addCurveToPoint: CGPointMake(22.6, 62.1) controlPoint1: CGPointMake(27.2, 73.7) controlPoint2: CGPointMake(22.3, 67.7)];
            [bezierPath addCurveToPoint: CGPointMake(27.9, 53.4) controlPoint1: CGPointMake(22.9, 56.5) controlPoint2: CGPointMake(24.3, 53.2)];
            [bezierPath addCurveToPoint: CGPointMake(33.8, 54.9) controlPoint1: CGPointMake(31.5, 53.8) controlPoint2: CGPointMake(33.8, 54.9)];
            [bezierPath closePath];
            bezierPath.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezierPath fill];
        }
        
        
        //// Group 9
        {
            //// Group 10
            {
                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                [bezier2Path moveToPoint: CGPointMake(40.5, 50.2)];
                [bezier2Path addCurveToPoint: CGPointMake(36.2, 50) controlPoint1: CGPointMake(39.1, 49.9) controlPoint2: CGPointMake(37.6, 49.7)];
                [bezier2Path addCurveToPoint: CGPointMake(33.2, 53.8) controlPoint1: CGPointMake(34.5, 50.4) controlPoint2: CGPointMake(33.6, 52.2)];
                [bezier2Path addCurveToPoint: CGPointMake(34.4, 54.1) controlPoint1: CGPointMake(33, 54.6) controlPoint2: CGPointMake(34.2, 54.9)];
                [bezier2Path addCurveToPoint: CGPointMake(37.1, 51) controlPoint1: CGPointMake(34.8, 52.6) controlPoint2: CGPointMake(35.5, 51.1)];
                [bezier2Path addCurveToPoint: CGPointMake(40.1, 51.3) controlPoint1: CGPointMake(38.1, 50.9) controlPoint2: CGPointMake(39.1, 51.1)];
                [bezier2Path addCurveToPoint: CGPointMake(40.5, 50.2) controlPoint1: CGPointMake(40.9, 51.5) controlPoint2: CGPointMake(41.2, 50.3)];
                [bezier2Path addLineToPoint: CGPointMake(40.5, 50.2)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier2Path fill];
            }
        }
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(33.9, 52.3)];
        [bezier3Path addCurveToPoint: CGPointMake(32.5, 49.6) controlPoint1: CGPointMake(33.9, 52.3) controlPoint2: CGPointMake(33.6, 50.4)];
        [bezier3Path addCurveToPoint: CGPointMake(29.6, 48.7) controlPoint1: CGPointMake(31.4, 48.8) controlPoint2: CGPointMake(29.6, 48.7)];
        [bezier3Path addCurveToPoint: CGPointMake(31.3, 51.7) controlPoint1: CGPointMake(29.6, 48.7) controlPoint2: CGPointMake(29.2, 50.5)];
        [bezier3Path addCurveToPoint: CGPointMake(33.9, 52.3) controlPoint1: CGPointMake(33.5, 52.9) controlPoint2: CGPointMake(33.9, 52.3)];
        [bezier3Path closePath];
        bezier3Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier3Path fill];
        
        
        //// Group 11
        {
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(56.7, 17.8)];
            [bezier4Path addCurveToPoint: CGPointMake(59.6, 21.6) controlPoint1: CGPointMake(56.7, 17.8) controlPoint2: CGPointMake(58.7, 21)];
            [bezier4Path addCurveToPoint: CGPointMake(56.4, 26.6) controlPoint1: CGPointMake(60.5, 22.2) controlPoint2: CGPointMake(56.4, 24.9)];
            [bezier4Path addCurveToPoint: CGPointMake(55.2, 35.6) controlPoint1: CGPointMake(56.4, 28.3) controlPoint2: CGPointMake(59.4, 30.3)];
            [bezier4Path addCurveToPoint: CGPointMake(35.2, 45.1) controlPoint1: CGPointMake(52.7, 38.7) controlPoint2: CGPointMake(45.7, 45.9)];
            [bezier4Path addCurveToPoint: CGPointMake(23.1, 38) controlPoint1: CGPointMake(24.7, 44.3) controlPoint2: CGPointMake(22.2, 40.3)];
            [bezier4Path addCurveToPoint: CGPointMake(32.5, 37.7) controlPoint1: CGPointMake(24, 35.7) controlPoint2: CGPointMake(29, 38.2)];
            [bezier4Path addCurveToPoint: CGPointMake(46, 32.1) controlPoint1: CGPointMake(36.1, 37.2) controlPoint2: CGPointMake(42.5, 37.3)];
            [bezier4Path addCurveToPoint: CGPointMake(50.8, 25.6) controlPoint1: CGPointMake(49.5, 26.9) controlPoint2: CGPointMake(48.9, 26.2)];
            [bezier4Path addCurveToPoint: CGPointMake(53.8, 24.9) controlPoint1: CGPointMake(52.7, 24.9) controlPoint2: CGPointMake(52.5, 26.2)];
            [bezier4Path addCurveToPoint: CGPointMake(56, 21.5) controlPoint1: CGPointMake(55.1, 23.6) controlPoint2: CGPointMake(55, 24)];
            [bezier4Path addCurveToPoint: CGPointMake(56.7, 17.8) controlPoint1: CGPointMake(56.8, 19.6) controlPoint2: CGPointMake(56.7, 17.8)];
            [bezier4Path closePath];
            bezier4Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier4Path fill];
        }
        
        
        //// Group 12
        {
            //// Bezier 5 Drawing
            UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
            [bezier5Path moveToPoint: CGPointMake(69.5, 62.9)];
            [bezier5Path addCurveToPoint: CGPointMake(63.8, 69.8) controlPoint1: CGPointMake(69.5, 62.9) controlPoint2: CGPointMake(65.1, 67.9)];
            [bezier5Path addCurveToPoint: CGPointMake(60.8, 76.1) controlPoint1: CGPointMake(62.5, 71.8) controlPoint2: CGPointMake(60.8, 76.1)];
            [bezier5Path addLineToPoint: CGPointMake(54.1, 73.6)];
            [bezier5Path addCurveToPoint: CGPointMake(55.5, 68.5) controlPoint1: CGPointMake(54.1, 73.6) controlPoint2: CGPointMake(55.6, 71.6)];
            [bezier5Path addCurveToPoint: CGPointMake(53.2, 56.4) controlPoint1: CGPointMake(55.3, 65.5) controlPoint2: CGPointMake(53.2, 56.4)];
            bezier5Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier5Path fill];
        }
        
        
        //// Group 13
        {
            //// Group 14
            {
                //// Bezier 6 Drawing
                UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
                [bezier6Path moveToPoint: CGPointMake(57.2, 62.2)];
                [bezier6Path addCurveToPoint: CGPointMake(58, 65.6) controlPoint1: CGPointMake(57.5, 63.3) controlPoint2: CGPointMake(57.7, 64.5)];
                [bezier6Path addCurveToPoint: CGPointMake(59.2, 65.3) controlPoint1: CGPointMake(58.2, 66.4) controlPoint2: CGPointMake(59.3, 66)];
                [bezier6Path addCurveToPoint: CGPointMake(58.4, 61.9) controlPoint1: CGPointMake(58.9, 64.2) controlPoint2: CGPointMake(58.7, 63)];
                [bezier6Path addCurveToPoint: CGPointMake(57.2, 62.2) controlPoint1: CGPointMake(58.1, 61.2) controlPoint2: CGPointMake(57, 61.5)];
                [bezier6Path addLineToPoint: CGPointMake(57.2, 62.2)];
                [bezier6Path closePath];
                bezier6Path.miterLimit = 4;
                
                [fillColor2 setFill];
                [bezier6Path fill];
            }
        }
        
        
        //// Group 15
        {
            //// Group 16
            {
                //// Bezier 7 Drawing
                UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
                [bezier7Path moveToPoint: CGPointMake(59.9, 68.1)];
                [bezier7Path addCurveToPoint: CGPointMake(58.7, 71.4) controlPoint1: CGPointMake(59.5, 69.2) controlPoint2: CGPointMake(59.1, 70.3)];
                [bezier7Path addCurveToPoint: CGPointMake(59.9, 71.7) controlPoint1: CGPointMake(58.4, 72.1) controlPoint2: CGPointMake(59.6, 72.5)];
                [bezier7Path addCurveToPoint: CGPointMake(61.1, 68.4) controlPoint1: CGPointMake(60.3, 70.6) controlPoint2: CGPointMake(60.7, 69.5)];
                [bezier7Path addCurveToPoint: CGPointMake(59.9, 68.1) controlPoint1: CGPointMake(61.3, 67.7) controlPoint2: CGPointMake(60.1, 67.4)];
                [bezier7Path addLineToPoint: CGPointMake(59.9, 68.1)];
                [bezier7Path closePath];
                bezier7Path.miterLimit = 4;
                
                [fillColor2 setFill];
                [bezier7Path fill];
            }
        }
        
        
        //// Group 17
        {
            //// Bezier 8 Drawing
            UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
            [bezier8Path moveToPoint: CGPointMake(58.2, 59.5)];
            [bezier8Path addCurveToPoint: CGPointMake(62.8, 63.6) controlPoint1: CGPointMake(58.2, 59.5) controlPoint2: CGPointMake(59.2, 62.3)];
            [bezier8Path addCurveToPoint: CGPointMake(67.5, 62.7) controlPoint1: CGPointMake(66.4, 64.9) controlPoint2: CGPointMake(67.5, 62.7)];
            [bezier8Path addCurveToPoint: CGPointMake(74.5, 65.2) controlPoint1: CGPointMake(67.5, 62.7) controlPoint2: CGPointMake(70.9, 67.2)];
            [bezier8Path addCurveToPoint: CGPointMake(77, 60.9) controlPoint1: CGPointMake(78, 63.2) controlPoint2: CGPointMake(77, 60.9)];
            [bezier8Path addCurveToPoint: CGPointMake(82.4, 56.2) controlPoint1: CGPointMake(77, 60.9) controlPoint2: CGPointMake(82.4, 60.8)];
            [bezier8Path addCurveToPoint: CGPointMake(77, 50.6) controlPoint1: CGPointMake(82.3, 51.7) controlPoint2: CGPointMake(77, 50.6)];
            [bezier8Path addCurveToPoint: CGPointMake(73.6, 44.4) controlPoint1: CGPointMake(77, 50.6) controlPoint2: CGPointMake(77.2, 46.5)];
            [bezier8Path addCurveToPoint: CGPointMake(65.4, 43.5) controlPoint1: CGPointMake(70, 42.3) controlPoint2: CGPointMake(65.4, 43.5)];
            [bezier8Path addCurveToPoint: CGPointMake(54.6, 40.7) controlPoint1: CGPointMake(65.4, 43.5) controlPoint2: CGPointMake(60.4, 37.5)];
            [bezier8Path addCurveToPoint: CGPointMake(50, 49.3) controlPoint1: CGPointMake(48.7, 43.8) controlPoint2: CGPointMake(50, 49.3)];
            [bezier8Path addCurveToPoint: CGPointMake(50.1, 59.2) controlPoint1: CGPointMake(50, 49.3) controlPoint2: CGPointMake(44.3, 55.1)];
            [bezier8Path addCurveToPoint: CGPointMake(58.2, 59.5) controlPoint1: CGPointMake(55.7, 63.4) controlPoint2: CGPointMake(58.2, 59.5)];
            [bezier8Path closePath];
            bezier8Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier8Path fill];
        }
        
        
        //// Bezier 9 Drawing
        UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
        [bezier9Path moveToPoint: CGPointMake(35.6, 64.7)];
        [bezier9Path addCurveToPoint: CGPointMake(36, 61.8) controlPoint1: CGPointMake(35.6, 64.7) controlPoint2: CGPointMake(34.8, 62.6)];
        [bezier9Path addCurveToPoint: CGPointMake(37.6, 62.4) controlPoint1: CGPointMake(37.2, 61) controlPoint2: CGPointMake(37.5, 61.9)];
        [bezier9Path addCurveToPoint: CGPointMake(35.6, 64.7) controlPoint1: CGPointMake(37.6, 63) controlPoint2: CGPointMake(35.6, 64.7)];
        [bezier9Path closePath];
        bezier9Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier9Path fill];
        
        
        //// Bezier 10 Drawing
        UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
        [bezier10Path moveToPoint: CGPointMake(32.8, 65.1)];
        [bezier10Path addCurveToPoint: CGPointMake(32.4, 62.2) controlPoint1: CGPointMake(32.8, 65.1) controlPoint2: CGPointMake(33.6, 63)];
        [bezier10Path addCurveToPoint: CGPointMake(30.9, 62.9) controlPoint1: CGPointMake(31.3, 61.4) controlPoint2: CGPointMake(31, 62.4)];
        [bezier10Path addCurveToPoint: CGPointMake(32.8, 65.1) controlPoint1: CGPointMake(30.8, 63.4) controlPoint2: CGPointMake(32.8, 65.1)];
        [bezier10Path closePath];
        bezier10Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier10Path fill];
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
