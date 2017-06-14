//
//  ASymbol_Smoking.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Smoking.h"

@implementation ASymbol_Smoking

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
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 99.9)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(50, 49.96), 0,
                                        CGPointMake(50, 49.96), 50,
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
                                        CGPointMake(50.35, -42.69),
                                        CGPointMake(50.35, 49.53),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(85.25, 67.95)];
        [bezierPath addCurveToPoint: CGPointMake(85.15, 69.25) controlPoint1: CGPointMake(85.25, 68.65) controlPoint2: CGPointMake(85.25, 69.25)];
        [bezierPath addLineToPoint: CGPointMake(82.25, 69.25)];
        [bezierPath addCurveToPoint: CGPointMake(82.15, 67.95) controlPoint1: CGPointMake(82.25, 69.25) controlPoint2: CGPointMake(82.15, 68.65)];
        [bezierPath addLineToPoint: CGPointMake(82.15, 58.35)];
        [bezierPath addCurveToPoint: CGPointMake(82.25, 57.05) controlPoint1: CGPointMake(82.15, 57.65) controlPoint2: CGPointMake(82.15, 57.05)];
        [bezierPath addLineToPoint: CGPointMake(85.15, 57.05)];
        [bezierPath addCurveToPoint: CGPointMake(85.25, 58.35) controlPoint1: CGPointMake(85.15, 57.05) controlPoint2: CGPointMake(85.25, 57.65)];
        [bezierPath addLineToPoint: CGPointMake(85.25, 67.95)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezierPath fill];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(80.45, 67.95)];
        [bezier2Path addCurveToPoint: CGPointMake(80.35, 69.25) controlPoint1: CGPointMake(80.45, 68.65) controlPoint2: CGPointMake(80.45, 69.25)];
        [bezier2Path addLineToPoint: CGPointMake(77.45, 69.25)];
        [bezier2Path addCurveToPoint: CGPointMake(77.35, 67.95) controlPoint1: CGPointMake(77.45, 69.25) controlPoint2: CGPointMake(77.35, 68.65)];
        [bezier2Path addLineToPoint: CGPointMake(77.35, 58.35)];
        [bezier2Path addCurveToPoint: CGPointMake(77.45, 57.05) controlPoint1: CGPointMake(77.35, 57.65) controlPoint2: CGPointMake(77.35, 57.05)];
        [bezier2Path addLineToPoint: CGPointMake(80.35, 57.05)];
        [bezier2Path addCurveToPoint: CGPointMake(80.45, 58.35) controlPoint1: CGPointMake(80.35, 57.05) controlPoint2: CGPointMake(80.45, 57.65)];
        [bezier2Path addLineToPoint: CGPointMake(80.45, 67.95)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier2Path fill];
        
        
        //// Group 8
        {
            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
            [bezier3Path moveToPoint: CGPointMake(58.05, 19.25)];
            [bezier3Path addCurveToPoint: CGPointMake(52.15, 27.75) controlPoint1: CGPointMake(58.05, 19.25) controlPoint2: CGPointMake(51.85, 23.55)];
            [bezier3Path addCurveToPoint: CGPointMake(66.65, 37.25) controlPoint1: CGPointMake(52.45, 31.95) controlPoint2: CGPointMake(56.05, 36.75)];
            [bezier3Path addCurveToPoint: CGPointMake(83.85, 42.25) controlPoint1: CGPointMake(77.15, 37.75) controlPoint2: CGPointMake(82.75, 37.95)];
            [bezier3Path addCurveToPoint: CGPointMake(84.25, 51.45) controlPoint1: CGPointMake(84.95, 46.55) controlPoint2: CGPointMake(84.25, 51.45)];
            [bezier3Path addCurveToPoint: CGPointMake(80.45, 43.95) controlPoint1: CGPointMake(84.25, 51.45) controlPoint2: CGPointMake(84.35, 45.65)];
            [bezier3Path addCurveToPoint: CGPointMake(57.35, 42.65) controlPoint1: CGPointMake(76.55, 42.25) controlPoint2: CGPointMake(65.35, 45.75)];
            [bezier3Path addCurveToPoint: CGPointMake(48.25, 27.65) controlPoint1: CGPointMake(49.35, 39.45) controlPoint2: CGPointMake(47.25, 32.65)];
            [bezier3Path addCurveToPoint: CGPointMake(58.05, 19.25) controlPoint1: CGPointMake(49.25, 22.55) controlPoint2: CGPointMake(58.05, 19.25)];
            [bezier3Path closePath];
            bezier3Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier3Path fill];
        }
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(73.45, 66.45)];
        [bezier4Path addCurveToPoint: CGPointMake(72.15, 67.75) controlPoint1: CGPointMake(73.45, 67.15) controlPoint2: CGPointMake(72.85, 67.75)];
        [bezier4Path addLineToPoint: CGPointMake(16.75, 67.75)];
        [bezier4Path addCurveToPoint: CGPointMake(15.45, 66.45) controlPoint1: CGPointMake(16.05, 67.75) controlPoint2: CGPointMake(15.45, 67.15)];
        [bezier4Path addLineToPoint: CGPointMake(15.45, 59.85)];
        [bezier4Path addCurveToPoint: CGPointMake(16.75, 58.55) controlPoint1: CGPointMake(15.45, 59.15) controlPoint2: CGPointMake(16.05, 58.55)];
        [bezier4Path addLineToPoint: CGPointMake(72.05, 58.55)];
        [bezier4Path addCurveToPoint: CGPointMake(73.35, 59.85) controlPoint1: CGPointMake(72.75, 58.55) controlPoint2: CGPointMake(73.35, 59.15)];
        [bezier4Path addLineToPoint: CGPointMake(73.35, 66.45)];
        [bezier4Path addLineToPoint: CGPointMake(73.45, 66.45)];
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
