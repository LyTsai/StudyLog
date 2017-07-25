//
//  ASymbol_Alzheimers.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Alzheimers.h"

@implementation ASymbol_Alzheimers
{
    
}

@synthesize fillColor1,strokeColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.839 green: 0.447 blue: 0.451 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.62 green: 0.173 blue: 0.169 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    fillColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    strokeColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];

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
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 99.9)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(50, 49.91), 0,
                                        CGPointMake(50, 49.91), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.25, 3.45, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.36, -42.74),
                                        CGPointMake(50.36, 49.48),
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
            [bezierPath moveToPoint: CGPointMake(54.65, 46.15)];
            [bezierPath addLineToPoint: CGPointMake(50.35, 46.15)];
            [bezierPath addLineToPoint: CGPointMake(50.35, 44.55)];
            [bezierPath addCurveToPoint: CGPointMake(50.45, 41.65) controlPoint1: CGPointMake(50.35, 43.35) controlPoint2: CGPointMake(50.35, 42.45)];
            [bezierPath addCurveToPoint: CGPointMake(50.75, 39.65) controlPoint1: CGPointMake(50.55, 40.95) controlPoint2: CGPointMake(50.65, 40.25)];
            [bezierPath addCurveToPoint: CGPointMake(51.85, 37.85) controlPoint1: CGPointMake(50.95, 39.05) controlPoint2: CGPointMake(51.25, 38.45)];
            [bezierPath addCurveToPoint: CGPointMake(53.75, 36.25) controlPoint1: CGPointMake(52.35, 37.25) controlPoint2: CGPointMake(53.05, 36.65)];
            [bezierPath addCurveToPoint: CGPointMake(55.35, 34.95) controlPoint1: CGPointMake(54.45, 35.75) controlPoint2: CGPointMake(55.05, 35.35)];
            [bezierPath addCurveToPoint: CGPointMake(55.85, 33.25) controlPoint1: CGPointMake(55.65, 34.55) controlPoint2: CGPointMake(55.85, 33.95)];
            [bezierPath addCurveToPoint: CGPointMake(55.15, 31.35) controlPoint1: CGPointMake(55.85, 32.45) controlPoint2: CGPointMake(55.65, 31.85)];
            [bezierPath addCurveToPoint: CGPointMake(53.65, 30.45) controlPoint1: CGPointMake(54.75, 30.95) controlPoint2: CGPointMake(54.25, 30.65)];
            [bezierPath addCurveToPoint: CGPointMake(52.15, 30.15) controlPoint1: CGPointMake(53.15, 30.25) controlPoint2: CGPointMake(52.55, 30.15)];
            [bezierPath addCurveToPoint: CGPointMake(50.45, 30.35) controlPoint1: CGPointMake(51.45, 30.15) controlPoint2: CGPointMake(50.95, 30.25)];
            [bezierPath addCurveToPoint: CGPointMake(49.15, 31.15) controlPoint1: CGPointMake(49.95, 30.55) controlPoint2: CGPointMake(49.55, 30.75)];
            [bezierPath addCurveToPoint: CGPointMake(48.45, 32.35) controlPoint1: CGPointMake(48.75, 31.45) controlPoint2: CGPointMake(48.55, 31.85)];
            [bezierPath addCurveToPoint: CGPointMake(48.35, 33.85) controlPoint1: CGPointMake(48.35, 32.85) controlPoint2: CGPointMake(48.35, 33.35)];
            [bezierPath addLineToPoint: CGPointMake(48.35, 35.25)];
            [bezierPath addLineToPoint: CGPointMake(43.65, 35.25)];
            [bezierPath addCurveToPoint: CGPointMake(43.75, 33.15) controlPoint1: CGPointMake(43.65, 34.45) controlPoint2: CGPointMake(43.65, 33.75)];
            [bezierPath addCurveToPoint: CGPointMake(44.25, 30.95) controlPoint1: CGPointMake(43.75, 32.55) controlPoint2: CGPointMake(43.95, 31.75)];
            [bezierPath addCurveToPoint: CGPointMake(45.75, 28.65) controlPoint1: CGPointMake(44.55, 30.15) controlPoint2: CGPointMake(44.95, 29.35)];
            [bezierPath addCurveToPoint: CGPointMake(48.65, 26.85) controlPoint1: CGPointMake(46.45, 27.95) controlPoint2: CGPointMake(47.45, 27.35)];
            [bezierPath addCurveToPoint: CGPointMake(52.55, 26.15) controlPoint1: CGPointMake(49.85, 26.35) controlPoint2: CGPointMake(51.15, 26.15)];
            [bezierPath addCurveToPoint: CGPointMake(57.65, 27.55) controlPoint1: CGPointMake(54.65, 26.15) controlPoint2: CGPointMake(56.35, 26.65)];
            [bezierPath addCurveToPoint: CGPointMake(60.25, 30.45) controlPoint1: CGPointMake(58.95, 28.45) controlPoint2: CGPointMake(59.85, 29.45)];
            [bezierPath addCurveToPoint: CGPointMake(60.85, 33.35) controlPoint1: CGPointMake(60.65, 31.45) controlPoint2: CGPointMake(60.85, 32.45)];
            [bezierPath addCurveToPoint: CGPointMake(60.55, 35.25) controlPoint1: CGPointMake(60.85, 33.95) controlPoint2: CGPointMake(60.75, 34.55)];
            [bezierPath addCurveToPoint: CGPointMake(59.75, 37.05) controlPoint1: CGPointMake(60.35, 35.95) controlPoint2: CGPointMake(60.05, 36.55)];
            [bezierPath addCurveToPoint: CGPointMake(58.45, 38.25) controlPoint1: CGPointMake(59.35, 37.55) controlPoint2: CGPointMake(58.95, 37.95)];
            [bezierPath addCurveToPoint: CGPointMake(56.95, 39.25) controlPoint1: CGPointMake(57.95, 38.55) controlPoint2: CGPointMake(57.55, 38.95)];
            [bezierPath addCurveToPoint: CGPointMake(55.65, 40.25) controlPoint1: CGPointMake(56.45, 39.55) controlPoint2: CGPointMake(55.95, 39.95)];
            [bezierPath addCurveToPoint: CGPointMake(54.95, 41.35) controlPoint1: CGPointMake(55.35, 40.55) controlPoint2: CGPointMake(55.15, 40.95)];
            [bezierPath addCurveToPoint: CGPointMake(54.75, 42.45) controlPoint1: CGPointMake(54.85, 41.75) controlPoint2: CGPointMake(54.75, 42.15)];
            [bezierPath addCurveToPoint: CGPointMake(54.75, 44.25) controlPoint1: CGPointMake(54.75, 42.75) controlPoint2: CGPointMake(54.75, 43.35)];
            [bezierPath addLineToPoint: CGPointMake(54.65, 46.15)];
            [bezierPath closePath];
            [bezierPath moveToPoint: CGPointMake(50.15, 50.35)];
            [bezierPath addLineToPoint: CGPointMake(54.75, 50.35)];
            [bezierPath addLineToPoint: CGPointMake(54.75, 54.85)];
            [bezierPath addLineToPoint: CGPointMake(50.15, 54.85)];
            [bezierPath addLineToPoint: CGPointMake(50.15, 50.35)];
            [bezierPath closePath];
            bezierPath.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezierPath fill];
        }
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(49.75, 78.65)];
        [bezier2Path addLineToPoint: CGPointMake(45.95, 70.75)];
        [bezier2Path addCurveToPoint: CGPointMake(33.65, 73.25) controlPoint1: CGPointMake(45.95, 70.75) controlPoint2: CGPointMake(35.85, 75.25)];
        [bezier2Path addCurveToPoint: CGPointMake(31.05, 68.25) controlPoint1: CGPointMake(31.45, 71.25) controlPoint2: CGPointMake(31.05, 68.25)];
        [bezier2Path addCurveToPoint: CGPointMake(27.55, 64.95) controlPoint1: CGPointMake(31.05, 68.25) controlPoint2: CGPointMake(28.05, 65.35)];
        [bezier2Path addCurveToPoint: CGPointMake(29.45, 62.25) controlPoint1: CGPointMake(27.05, 64.55) controlPoint2: CGPointMake(29.05, 62.25)];
        [bezier2Path addCurveToPoint: CGPointMake(26.35, 61.25) controlPoint1: CGPointMake(29.85, 62.25) controlPoint2: CGPointMake(26.45, 62.05)];
        [bezier2Path addCurveToPoint: CGPointMake(27.75, 57.45) controlPoint1: CGPointMake(26.25, 60.45) controlPoint2: CGPointMake(28.25, 57.75)];
        [bezier2Path addCurveToPoint: CGPointMake(22.65, 54.25) controlPoint1: CGPointMake(27.25, 57.15) controlPoint2: CGPointMake(21.95, 55.35)];
        [bezier2Path addCurveToPoint: CGPointMake(28.95, 44.75) controlPoint1: CGPointMake(23.35, 53.05) controlPoint2: CGPointMake(29.05, 47.15)];
        [bezier2Path addCurveToPoint: CGPointMake(31.55, 27.55) controlPoint1: CGPointMake(28.85, 42.35) controlPoint2: CGPointMake(25.35, 32.95)];
        [bezier2Path addCurveToPoint: CGPointMake(66.25, 23.55) controlPoint1: CGPointMake(37.85, 22.15) controlPoint2: CGPointMake(49.55, 14.25)];
        [bezier2Path addCurveToPoint: CGPointMake(66.75, 64.35) controlPoint1: CGPointMake(87.75, 35.45) controlPoint2: CGPointMake(66.75, 64.35)];
        [bezier2Path addCurveToPoint: CGPointMake(73.15, 77.85) controlPoint1: CGPointMake(66.75, 64.35) controlPoint2: CGPointMake(70.15, 76.65)];
        [strokeColor1 setStroke];
        bezier2Path.lineWidth = 1;
        [bezier2Path stroke];
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
