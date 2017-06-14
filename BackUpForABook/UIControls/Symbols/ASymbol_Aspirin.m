//
//  ASymbol_Aspirin.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Aspirin.h"

@implementation ASymbol_Aspirin
{
}

@synthesize fillColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.839 green: 0.447 blue: 0.451 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.62 green: 0.173 blue: 0.169 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    fillColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];

}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)context
{
    // (1)
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// (2) Gradient Declarations
    CGFloat sVGID_1_Locations[] = {0, 0.8, 1};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor1.CGColor, (id)gradientColor2.CGColor, (id)gradientColor2.CGColor], sVGID_1_Locations);
    CGFloat sVGID_2_Locations[] = {0, 1};
    CGGradientRef sVGID_2_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor3.CGColor, (id)gradientColor4.CGColor], sVGID_2_Locations);
    
    
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
                                        CGPointMake(50.08, 49.93), 0,
                                        CGPointMake(50.08, 49.93), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.35, 3.4, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.44, -42.72),
                                        CGPointMake(50.44, 49.5),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(48.55, 35.25)];
        [bezierPath addLineToPoint: CGPointMake(43.45, 43.55)];
        [bezierPath addCurveToPoint: CGPointMake(52.45, 62.15) controlPoint1: CGPointMake(43.45, 43.55) controlPoint2: CGPointMake(42.85, 54.65)];
        [bezierPath addCurveToPoint: CGPointMake(72.15, 67.95) controlPoint1: CGPointMake(62.05, 69.65) controlPoint2: CGPointMake(72.15, 67.95)];
        [bezierPath addLineToPoint: CGPointMake(79.55, 61.45)];
        [bezierPath addCurveToPoint: CGPointMake(59.95, 53.95) controlPoint1: CGPointMake(79.55, 61.45) controlPoint2: CGPointMake(72.25, 63.75)];
        [bezierPath addCurveToPoint: CGPointMake(48.55, 35.25) controlPoint1: CGPointMake(47.65, 44.15) controlPoint2: CGPointMake(48.55, 35.25)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezierPath fill];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(79.15, 40.05)];
        [bezier2Path addCurveToPoint: CGPointMake(70.75, 39.05) controlPoint1: CGPointMake(76.75, 39.35) controlPoint2: CGPointMake(73.25, 38.65)];
        [bezier2Path addCurveToPoint: CGPointMake(61.65, 41.75) controlPoint1: CGPointMake(66.65, 39.75) controlPoint2: CGPointMake(61.65, 41.75)];
        [bezier2Path addCurveToPoint: CGPointMake(71.05, 36.25) controlPoint1: CGPointMake(61.65, 41.75) controlPoint2: CGPointMake(66.25, 36.75)];
        [bezier2Path addCurveToPoint: CGPointMake(75.75, 36.25) controlPoint1: CGPointMake(72.85, 36.05) controlPoint2: CGPointMake(74.45, 36.15)];
        [bezier2Path addCurveToPoint: CGPointMake(74.85, 35.45) controlPoint1: CGPointMake(75.45, 35.95) controlPoint2: CGPointMake(75.15, 35.65)];
        [bezier2Path addCurveToPoint: CGPointMake(52.65, 29.05) controlPoint1: CGPointMake(66.45, 27.75) controlPoint2: CGPointMake(56.45, 24.85)];
        [bezier2Path addCurveToPoint: CGPointMake(61.05, 50.55) controlPoint1: CGPointMake(48.85, 33.25) controlPoint2: CGPointMake(52.55, 42.85)];
        [bezier2Path addCurveToPoint: CGPointMake(83.25, 56.95) controlPoint1: CGPointMake(69.45, 58.25) controlPoint2: CGPointMake(79.45, 61.15)];
        [bezier2Path addCurveToPoint: CGPointMake(79.15, 40.05) controlPoint1: CGPointMake(86.35, 53.65) controlPoint2: CGPointMake(84.45, 46.65)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier2Path fill];
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(15.45, 57.85)];
        [bezier3Path addLineToPoint: CGPointMake(17.35, 66.05)];
        [bezier3Path addCurveToPoint: CGPointMake(34.15, 71.85) controlPoint1: CGPointMake(17.35, 66.05) controlPoint2: CGPointMake(23.75, 73.15)];
        [bezier3Path addCurveToPoint: CGPointMake(49.85, 63.45) controlPoint1: CGPointMake(44.65, 70.65) controlPoint2: CGPointMake(49.85, 63.45)];
        [bezier3Path addLineToPoint: CGPointMake(50.45, 54.95)];
        [bezier3Path addCurveToPoint: CGPointMake(33.85, 62.35) controlPoint1: CGPointMake(50.45, 54.95) controlPoint2: CGPointMake(47.35, 60.75)];
        [bezier3Path addCurveToPoint: CGPointMake(15.45, 57.85) controlPoint1: CGPointMake(20.35, 63.85) controlPoint2: CGPointMake(15.45, 57.85)];
        [bezier3Path closePath];
        bezier3Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier3Path fill];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(37.05, 42.15)];
        [bezier4Path addCurveToPoint: CGPointMake(31.35, 46.65) controlPoint1: CGPointMake(35.25, 43.15) controlPoint2: CGPointMake(32.55, 44.85)];
        [bezier4Path addCurveToPoint: CGPointMake(27.45, 53.85) controlPoint1: CGPointMake(29.25, 49.55) controlPoint2: CGPointMake(27.45, 53.85)];
        [bezier4Path addCurveToPoint: CGPointMake(29.85, 44.85) controlPoint1: CGPointMake(27.45, 53.85) controlPoint2: CGPointMake(27.15, 48.05)];
        [bezier4Path addCurveToPoint: CGPointMake(32.75, 41.95) controlPoint1: CGPointMake(30.85, 43.65) controlPoint2: CGPointMake(31.85, 42.75)];
        [bezier4Path addCurveToPoint: CGPointMake(31.75, 41.95) controlPoint1: CGPointMake(32.45, 41.95) controlPoint2: CGPointMake(32.05, 41.95)];
        [bezier4Path addCurveToPoint: CGPointMake(14.25, 51.55) controlPoint1: CGPointMake(21.85, 42.35) controlPoint2: CGPointMake(14.05, 46.65)];
        [bezier4Path addCurveToPoint: CGPointMake(32.45, 59.55) controlPoint1: CGPointMake(14.45, 56.45) controlPoint2: CGPointMake(22.65, 60.05)];
        [bezier4Path addCurveToPoint: CGPointMake(49.95, 49.95) controlPoint1: CGPointMake(42.35, 59.15) controlPoint2: CGPointMake(50.15, 54.85)];
        [bezier4Path addCurveToPoint: CGPointMake(37.05, 42.15) controlPoint1: CGPointMake(49.65, 46.05) controlPoint2: CGPointMake(44.35, 42.95)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier4Path fill];
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
