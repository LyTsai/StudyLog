//
//  ASymbol_Fish.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Fish.h"

@implementation ASymbol_Fish

@synthesize fillColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.843 green: 0.824 blue: 0.447 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.71 green: 0.694 blue: 0.282 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.608 green: 0.616 blue: 0.216 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor5 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    fillColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];}

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
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100.1, 99.9)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(50.03, 49.95), 0,
                                        CGPointMake(50.03, 49.95), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.25, 3.5, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.38, -42.7),
                                        CGPointMake(50.38, 49.52),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(35.35, 39.05)];
        [bezierPath addLineToPoint: CGPointMake(43.75, 31.95)];
        [bezierPath addCurveToPoint: CGPointMake(52.65, 36.45) controlPoint1: CGPointMake(43.75, 31.95) controlPoint2: CGPointMake(48.95, 35.25)];
        [bezierPath addCurveToPoint: CGPointMake(61.75, 40.25) controlPoint1: CGPointMake(56.35, 37.75) controlPoint2: CGPointMake(59.25, 38.75)];
        [bezierPath addCurveToPoint: CGPointMake(64.25, 41.75) controlPoint1: CGPointMake(64.25, 41.75) controlPoint2: CGPointMake(64.25, 41.75)];
        [bezierPath addLineToPoint: CGPointMake(62.35, 43.75)];
        [bezierPath addCurveToPoint: CGPointMake(53.95, 39.95) controlPoint1: CGPointMake(62.35, 43.75) controlPoint2: CGPointMake(59.85, 41.35)];
        [bezierPath addCurveToPoint: CGPointMake(40.35, 38.75) controlPoint1: CGPointMake(48.05, 38.45) controlPoint2: CGPointMake(44.05, 38.65)];
        [bezierPath addCurveToPoint: CGPointMake(35.35, 39.05) controlPoint1: CGPointMake(36.55, 38.85) controlPoint2: CGPointMake(35.35, 39.05)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezierPath fill];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(42.25, 65.25)];
        [bezier2Path addCurveToPoint: CGPointMake(48.25, 64.65) controlPoint1: CGPointMake(42.25, 65.25) controlPoint2: CGPointMake(45.45, 64.85)];
        [bezier2Path addCurveToPoint: CGPointMake(52.75, 63.85) controlPoint1: CGPointMake(51.05, 64.45) controlPoint2: CGPointMake(52.75, 63.85)];
        [bezier2Path addLineToPoint: CGPointMake(57.15, 67.95)];
        [bezier2Path addCurveToPoint: CGPointMake(51.15, 66.75) controlPoint1: CGPointMake(57.15, 67.95) controlPoint2: CGPointMake(55.15, 67.55)];
        [bezier2Path addCurveToPoint: CGPointMake(42.25, 65.25) controlPoint1: CGPointMake(47.25, 65.95) controlPoint2: CGPointMake(42.25, 65.25)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier2Path fill];
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(60.65, 61.55)];
        [bezier3Path addCurveToPoint: CGPointMake(63.75, 60.25) controlPoint1: CGPointMake(60.65, 61.55) controlPoint2: CGPointMake(62.35, 61.15)];
        [bezier3Path addCurveToPoint: CGPointMake(65.85, 58.85) controlPoint1: CGPointMake(65.15, 59.35) controlPoint2: CGPointMake(65.85, 58.85)];
        [bezier3Path addCurveToPoint: CGPointMake(68.05, 60.65) controlPoint1: CGPointMake(65.85, 58.85) controlPoint2: CGPointMake(66.75, 60.05)];
        [bezier3Path addCurveToPoint: CGPointMake(70.15, 62.25) controlPoint1: CGPointMake(69.35, 61.25) controlPoint2: CGPointMake(70.15, 62.25)];
        [bezier3Path addCurveToPoint: CGPointMake(65.55, 61.75) controlPoint1: CGPointMake(70.15, 62.25) controlPoint2: CGPointMake(67.65, 61.85)];
        [bezier3Path addCurveToPoint: CGPointMake(60.65, 61.55) controlPoint1: CGPointMake(63.45, 61.65) controlPoint2: CGPointMake(60.65, 61.55)];
        [bezier3Path closePath];
        bezier3Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier3Path fill];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(84.05, 59.75)];
        [bezier4Path addCurveToPoint: CGPointMake(82.05, 56.75) controlPoint1: CGPointMake(83.35, 58.85) controlPoint2: CGPointMake(82.05, 56.75)];
        [bezier4Path addLineToPoint: CGPointMake(77.65, 56.55)];
        [bezier4Path addLineToPoint: CGPointMake(81.95, 55.65)];
        [bezier4Path addLineToPoint: CGPointMake(80.95, 52.45)];
        [bezier4Path addLineToPoint: CGPointMake(72.75, 51.75)];
        [bezier4Path addLineToPoint: CGPointMake(80.85, 51.05)];
        [bezier4Path addLineToPoint: CGPointMake(81.05, 47.95)];
        [bezier4Path addLineToPoint: CGPointMake(76.95, 47.15)];
        [bezier4Path addLineToPoint: CGPointMake(81.55, 46.55)];
        [bezier4Path addCurveToPoint: CGPointMake(82.35, 44.35) controlPoint1: CGPointMake(81.55, 46.55) controlPoint2: CGPointMake(81.85, 45.45)];
        [bezier4Path addCurveToPoint: CGPointMake(84.85, 41.25) controlPoint1: CGPointMake(82.85, 43.25) controlPoint2: CGPointMake(84.85, 41.25)];
        [bezier4Path addCurveToPoint: CGPointMake(78.45, 43.75) controlPoint1: CGPointMake(84.85, 41.25) controlPoint2: CGPointMake(82.35, 41.65)];
        [bezier4Path addCurveToPoint: CGPointMake(70.45, 49.75) controlPoint1: CGPointMake(74.55, 45.85) controlPoint2: CGPointMake(70.45, 49.75)];
        [bezier4Path addCurveToPoint: CGPointMake(42.95, 40.45) controlPoint1: CGPointMake(70.45, 49.75) controlPoint2: CGPointMake(60.25, 40.45)];
        [bezier4Path addCurveToPoint: CGPointMake(15.25, 49.95) controlPoint1: CGPointMake(27.05, 40.45) controlPoint2: CGPointMake(16.85, 48.65)];
        [bezier4Path addCurveToPoint: CGPointMake(15.05, 50.15) controlPoint1: CGPointMake(15.15, 50.05) controlPoint2: CGPointMake(15.05, 50.15)];
        [bezier4Path addLineToPoint: CGPointMake(18.15, 52.55)];
        [bezier4Path addLineToPoint: CGPointMake(16.15, 54.45)];
        [bezier4Path addCurveToPoint: CGPointMake(21.55, 58.05) controlPoint1: CGPointMake(16.15, 54.45) controlPoint2: CGPointMake(17.95, 56.05)];
        [bezier4Path addCurveToPoint: CGPointMake(29.75, 61.75) controlPoint1: CGPointMake(25.15, 60.05) controlPoint2: CGPointMake(29.75, 61.75)];
        [bezier4Path addCurveToPoint: CGPointMake(33.55, 56.45) controlPoint1: CGPointMake(29.75, 61.75) controlPoint2: CGPointMake(32.15, 59.15)];
        [bezier4Path addCurveToPoint: CGPointMake(32.75, 47.15) controlPoint1: CGPointMake(35.15, 53.65) controlPoint2: CGPointMake(32.75, 47.15)];
        [bezier4Path addCurveToPoint: CGPointMake(35.05, 55.05) controlPoint1: CGPointMake(32.75, 47.15) controlPoint2: CGPointMake(34.95, 50.75)];
        [bezier4Path addCurveToPoint: CGPointMake(31.95, 62.15) controlPoint1: CGPointMake(35.15, 59.35) controlPoint2: CGPointMake(31.95, 62.15)];
        [bezier4Path addCurveToPoint: CGPointMake(50.35, 62.85) controlPoint1: CGPointMake(31.95, 62.15) controlPoint2: CGPointMake(40.45, 64.05)];
        [bezier4Path addCurveToPoint: CGPointMake(70.25, 53.85) controlPoint1: CGPointMake(60.35, 61.65) controlPoint2: CGPointMake(70.25, 53.85)];
        [bezier4Path addCurveToPoint: CGPointMake(77.85, 59.15) controlPoint1: CGPointMake(70.25, 53.85) controlPoint2: CGPointMake(74.05, 56.75)];
        [bezier4Path addCurveToPoint: CGPointMake(85.95, 61.25) controlPoint1: CGPointMake(81.65, 61.55) controlPoint2: CGPointMake(85.95, 61.25)];
        [bezier4Path addCurveToPoint: CGPointMake(84.05, 59.75) controlPoint1: CGPointMake(85.95, 61.25) controlPoint2: CGPointMake(84.75, 60.55)];
        [bezier4Path closePath];
        [bezier4Path moveToPoint: CGPointMake(25.65, 52.55)];
        [bezier4Path addCurveToPoint: CGPointMake(22.45, 49.35) controlPoint1: CGPointMake(23.85, 52.55) controlPoint2: CGPointMake(22.45, 51.15)];
        [bezier4Path addCurveToPoint: CGPointMake(25.65, 46.15) controlPoint1: CGPointMake(22.45, 47.55) controlPoint2: CGPointMake(23.85, 46.15)];
        [bezier4Path addCurveToPoint: CGPointMake(28.85, 49.35) controlPoint1: CGPointMake(27.45, 46.15) controlPoint2: CGPointMake(28.85, 47.55)];
        [bezier4Path addCurveToPoint: CGPointMake(25.65, 52.55) controlPoint1: CGPointMake(28.85, 51.05) controlPoint2: CGPointMake(27.45, 52.55)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier4Path fill];
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(23.45, 47.15, 3.8, 3.8)];
        [fillColor1 setFill];
        [oval3Path fill];
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
