//
//  ASymbol_FishOil.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_FishOil.h"

@implementation ASymbol_FishOil

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
                                        CGPointMake(50.38, -42.71),
                                        CGPointMake(50.38, 49.52),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Group 8
        {
            //// Oval 3 Drawing
            UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(38.55, 49.35, 39.8, 21.4)];
            [fillColor1 setFill];
            [oval3Path fill];
            
            
            //// Group 9
            {
                //// Group 10
                {
                    //// Bezier Drawing
                    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
                    [bezierPath moveToPoint: CGPointMake(45.75, 57.75)];
                    [bezierPath addCurveToPoint: CGPointMake(72.75, 58.15) controlPoint1: CGPointMake(53.75, 51.85) controlPoint2: CGPointMake(64.85, 52.05)];
                    [bezierPath addCurveToPoint: CGPointMake(73.35, 57.55) controlPoint1: CGPointMake(73.25, 58.55) controlPoint2: CGPointMake(73.85, 57.85)];
                    [bezierPath addCurveToPoint: CGPointMake(45.35, 57.05) controlPoint1: CGPointMake(65.25, 51.15) controlPoint2: CGPointMake(53.65, 50.85)];
                    [bezierPath addCurveToPoint: CGPointMake(45.75, 57.75) controlPoint1: CGPointMake(44.75, 57.35) controlPoint2: CGPointMake(45.25, 58.05)];
                    [bezierPath addLineToPoint: CGPointMake(45.75, 57.75)];
                    [bezierPath closePath];
                    bezierPath.miterLimit = 4;
                    
                    [fillColor2 setFill];
                    [bezierPath fill];
                }
            }
        }
        
        
        //// Group 11
        {
            //// Oval 4 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 27.85, 53.6);
            CGContextRotateCTM(context, -23.15 * M_PI / 180);
            
            UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-14.45, -7.75, 28.9, 15.5)];
            [fillColor1 setFill];
            [oval4Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Group 12
            {
                //// Group 13
                {
                    //// Bezier 2 Drawing
                    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                    [bezier2Path moveToPoint: CGPointMake(18.85, 55.75)];
                    [bezier2Path addCurveToPoint: CGPointMake(36.85, 48.45) controlPoint1: CGPointMake(22.45, 49.55) controlPoint2: CGPointMake(29.95, 46.65)];
                    [bezier2Path addCurveToPoint: CGPointMake(37.05, 47.55) controlPoint1: CGPointMake(37.45, 48.55) controlPoint2: CGPointMake(37.65, 47.75)];
                    [bezier2Path addCurveToPoint: CGPointMake(18.05, 55.25) controlPoint1: CGPointMake(29.75, 45.65) controlPoint2: CGPointMake(21.95, 48.75)];
                    [bezier2Path addCurveToPoint: CGPointMake(18.85, 55.75) controlPoint1: CGPointMake(17.75, 55.85) controlPoint2: CGPointMake(18.55, 56.25)];
                    [bezier2Path addLineToPoint: CGPointMake(18.85, 55.75)];
                    [bezier2Path closePath];
                    bezier2Path.miterLimit = 4;
                    
                    [fillColor2 setFill];
                    [bezier2Path fill];
                }
            }
        }
        
        
        //// Group 14
        {
            //// Oval 5 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 54.65, 33.15);
            CGContextRotateCTM(context, 15.65 * M_PI / 180);
            
            UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-11.9, -6.4, 23.8, 12.8)];
            [fillColor1 setFill];
            [oval5Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Group 15
            {
                //// Group 16
                {
                    //// Bezier 3 Drawing
                    UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
                    [bezier3Path moveToPoint: CGPointMake(47.75, 29.95)];
                    [bezier3Path addCurveToPoint: CGPointMake(62.95, 34.45) controlPoint1: CGPointMake(53.25, 27.85) controlPoint2: CGPointMake(59.55, 29.75)];
                    [bezier3Path addCurveToPoint: CGPointMake(63.75, 33.95) controlPoint1: CGPointMake(63.25, 34.95) controlPoint2: CGPointMake(64.05, 34.45)];
                    [bezier3Path addCurveToPoint: CGPointMake(47.55, 29.05) controlPoint1: CGPointMake(60.05, 28.85) controlPoint2: CGPointMake(53.45, 26.85)];
                    [bezier3Path addCurveToPoint: CGPointMake(47.75, 29.95) controlPoint1: CGPointMake(46.95, 29.35) controlPoint2: CGPointMake(47.25, 30.25)];
                    [bezier3Path addLineToPoint: CGPointMake(47.75, 29.95)];
                    [bezier3Path closePath];
                    bezier3Path.miterLimit = 4;
                    
                    [fillColor2 setFill];
                    [bezier3Path fill];
                }
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
