//
//  ASymbol_Stress.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Stress.h"

@implementation ASymbol_Stress
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
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 99.9)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(49.99, 49.94), 0,
                                        CGPointMake(49.99, 49.94), 50,
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
                                        CGPointMake(50.35, -42.71),
                                        CGPointMake(50.35, 49.52),
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
            [bezierPath moveToPoint: CGPointMake(67.75, 41.45)];
            [bezierPath addCurveToPoint: CGPointMake(67.45, 40.85) controlPoint1: CGPointMake(67.65, 41.25) controlPoint2: CGPointMake(67.65, 41.05)];
            [bezierPath addLineToPoint: CGPointMake(60.75, 30.55)];
            [bezierPath addCurveToPoint: CGPointMake(58.05, 29.95) controlPoint1: CGPointMake(60.15, 29.55) controlPoint2: CGPointMake(59.05, 29.25)];
            [bezierPath addCurveToPoint: CGPointMake(57.55, 32.85) controlPoint1: CGPointMake(57.05, 30.55) controlPoint2: CGPointMake(56.95, 31.95)];
            [bezierPath addLineToPoint: CGPointMake(62.25, 40.05)];
            [bezierPath addLineToPoint: CGPointMake(41.15, 40.05)];
            [bezierPath addLineToPoint: CGPointMake(45.55, 33.25)];
            [bezierPath addCurveToPoint: CGPointMake(45.35, 30.35) controlPoint1: CGPointMake(46.15, 32.25) controlPoint2: CGPointMake(46.35, 30.95)];
            [bezierPath addCurveToPoint: CGPointMake(42.45, 30.95) controlPoint1: CGPointMake(44.35, 29.75) controlPoint2: CGPointMake(43.05, 29.95)];
            [bezierPath addLineToPoint: CGPointMake(36.25, 40.45)];
            [bezierPath addCurveToPoint: CGPointMake(35.65, 43.55) controlPoint1: CGPointMake(35.65, 41.35) controlPoint2: CGPointMake(34.85, 42.55)];
            [bezierPath addCurveToPoint: CGPointMake(38.25, 44.35) controlPoint1: CGPointMake(35.85, 43.75) controlPoint2: CGPointMake(37.25, 44.45)];
            [bezierPath addLineToPoint: CGPointMake(45.55, 44.35)];
            [bezierPath addLineToPoint: CGPointMake(45.55, 54.35)];
            [bezierPath addLineToPoint: CGPointMake(57.45, 54.35)];
            [bezierPath addLineToPoint: CGPointMake(57.45, 44.35)];
            [bezierPath addLineToPoint: CGPointMake(65.65, 44.35)];
            [bezierPath addCurveToPoint: CGPointMake(67.75, 42.25) controlPoint1: CGPointMake(66.85, 44.35) controlPoint2: CGPointMake(67.75, 43.35)];
            [bezierPath addCurveToPoint: CGPointMake(67.75, 41.45) controlPoint1: CGPointMake(67.85, 41.95) controlPoint2: CGPointMake(67.85, 41.65)];
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
                [bezier2Path moveToPoint: CGPointMake(41.85, 15.45)];
                [bezier2Path addCurveToPoint: CGPointMake(37.85, 20.55) controlPoint1: CGPointMake(39.95, 16.35) controlPoint2: CGPointMake(37.55, 18.15)];
                [bezier2Path addCurveToPoint: CGPointMake(41.25, 23.15) controlPoint1: CGPointMake(38.05, 22.25) controlPoint2: CGPointMake(39.75, 22.95)];
                [bezier2Path addCurveToPoint: CGPointMake(46.15, 22.25) controlPoint1: CGPointMake(42.65, 23.35) controlPoint2: CGPointMake(45.05, 23.45)];
                [bezier2Path addCurveToPoint: CGPointMake(45.65, 20.15) controlPoint1: CGPointMake(46.85, 21.55) controlPoint2: CGPointMake(46.55, 20.55)];
                [bezier2Path addCurveToPoint: CGPointMake(39.75, 24.75) controlPoint1: CGPointMake(43.65, 19.35) controlPoint2: CGPointMake(37.75, 22.35)];
                [bezier2Path addCurveToPoint: CGPointMake(44.55, 26.05) controlPoint1: CGPointMake(40.75, 25.95) controlPoint2: CGPointMake(43.05, 26.25)];
                [bezier2Path addCurveToPoint: CGPointMake(46.25, 23.75) controlPoint1: CGPointMake(45.55, 25.95) controlPoint2: CGPointMake(47.35, 25.05)];
                [bezier2Path addCurveToPoint: CGPointMake(42.65, 25.05) controlPoint1: CGPointMake(45.35, 22.75) controlPoint2: CGPointMake(42.95, 23.95)];
                [bezier2Path addCurveToPoint: CGPointMake(46.45, 27.05) controlPoint1: CGPointMake(41.95, 27.15) controlPoint2: CGPointMake(45.15, 27.15)];
                [bezier2Path addCurveToPoint: CGPointMake(46.45, 26.45) controlPoint1: CGPointMake(46.85, 27.05) controlPoint2: CGPointMake(46.85, 26.45)];
                [bezier2Path addCurveToPoint: CGPointMake(44.45, 26.35) controlPoint1: CGPointMake(45.85, 26.45) controlPoint2: CGPointMake(44.95, 26.65)];
                [bezier2Path addCurveToPoint: CGPointMake(44.85, 24.05) controlPoint1: CGPointMake(43.35, 25.85) controlPoint2: CGPointMake(43.35, 23.75)];
                [bezier2Path addCurveToPoint: CGPointMake(44.75, 25.35) controlPoint1: CGPointMake(47.15, 24.45) controlPoint2: CGPointMake(45.25, 25.25)];
                [bezier2Path addCurveToPoint: CGPointMake(42.45, 25.35) controlPoint1: CGPointMake(44.05, 25.55) controlPoint2: CGPointMake(43.15, 25.45)];
                [bezier2Path addCurveToPoint: CGPointMake(40.35, 22.75) controlPoint1: CGPointMake(41.05, 25.05) controlPoint2: CGPointMake(39.25, 24.35)];
                [bezier2Path addCurveToPoint: CGPointMake(43.45, 20.85) controlPoint1: CGPointMake(40.95, 21.85) controlPoint2: CGPointMake(42.45, 21.15)];
                [bezier2Path addCurveToPoint: CGPointMake(44.95, 20.55) controlPoint1: CGPointMake(43.95, 20.75) controlPoint2: CGPointMake(44.45, 20.45)];
                [bezier2Path addCurveToPoint: CGPointMake(44.65, 22.25) controlPoint1: CGPointMake(46.85, 20.95) controlPoint2: CGPointMake(45.35, 21.95)];
                [bezier2Path addCurveToPoint: CGPointMake(41.25, 22.45) controlPoint1: CGPointMake(43.65, 22.65) controlPoint2: CGPointMake(42.25, 22.55)];
                [bezier2Path addCurveToPoint: CGPointMake(38.55, 19.55) controlPoint1: CGPointMake(39.75, 22.15) controlPoint2: CGPointMake(38.15, 21.45)];
                [bezier2Path addCurveToPoint: CGPointMake(42.25, 15.95) controlPoint1: CGPointMake(38.95, 17.85) controlPoint2: CGPointMake(40.75, 16.65)];
                [bezier2Path addCurveToPoint: CGPointMake(41.85, 15.45) controlPoint1: CGPointMake(42.45, 15.85) controlPoint2: CGPointMake(42.15, 15.35)];
                [bezier2Path addLineToPoint: CGPointMake(41.85, 15.45)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier2Path fill];
            }
        }
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(62.85, 25.45)];
        [bezier3Path addLineToPoint: CGPointMake(61.05, 24.95)];
        [bezier3Path addLineToPoint: CGPointMake(59.45, 27.35)];
        [bezier3Path addLineToPoint: CGPointMake(62.85, 25.45)];
        [bezier3Path closePath];
        bezier3Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier3Path fill];
        
        
        //// Group 11
        {
            //// Group 12
            {
                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
                [bezier4Path moveToPoint: CGPointMake(54.95, 21.55)];
                [bezier4Path addCurveToPoint: CGPointMake(50.15, 23.75) controlPoint1: CGPointMake(54.85, 18.25) controlPoint2: CGPointMake(48.65, 20.45)];
                [bezier4Path addCurveToPoint: CGPointMake(56.95, 22.15) controlPoint1: CGPointMake(51.25, 26.25) controlPoint2: CGPointMake(58.85, 25.55)];
                [bezier4Path addCurveToPoint: CGPointMake(53.05, 21.85) controlPoint1: CGPointMake(56.25, 20.85) controlPoint2: CGPointMake(54.15, 21.05)];
                [bezier4Path addCurveToPoint: CGPointMake(52.75, 25.75) controlPoint1: CGPointMake(51.75, 22.85) controlPoint2: CGPointMake(51.75, 24.55)];
                [bezier4Path addCurveToPoint: CGPointMake(56.95, 26.65) controlPoint1: CGPointMake(53.75, 27.05) controlPoint2: CGPointMake(55.45, 27.35)];
                [bezier4Path addCurveToPoint: CGPointMake(58.45, 23.45) controlPoint1: CGPointMake(58.15, 26.05) controlPoint2: CGPointMake(59.55, 24.75)];
                [bezier4Path addCurveToPoint: CGPointMake(52.15, 21.85) controlPoint1: CGPointMake(57.15, 21.85) controlPoint2: CGPointMake(54.05, 21.55)];
                [bezier4Path addCurveToPoint: CGPointMake(50.05, 24.65) controlPoint1: CGPointMake(50.75, 22.05) controlPoint2: CGPointMake(48.55, 23.05)];
                [bezier4Path addCurveToPoint: CGPointMake(54.75, 26.05) controlPoint1: CGPointMake(51.05, 25.75) controlPoint2: CGPointMake(53.35, 26.75)];
                [bezier4Path addCurveToPoint: CGPointMake(55.05, 23.15) controlPoint1: CGPointMake(55.95, 25.45) controlPoint2: CGPointMake(56.45, 23.85)];
                [bezier4Path addCurveToPoint: CGPointMake(50.45, 27.75) controlPoint1: CGPointMake(52.65, 21.85) controlPoint2: CGPointMake(47.65, 25.45)];
                [bezier4Path addCurveToPoint: CGPointMake(56.85, 27.05) controlPoint1: CGPointMake(51.95, 28.95) controlPoint2: CGPointMake(55.65, 28.65)];
                [bezier4Path addCurveToPoint: CGPointMake(56.15, 24.55) controlPoint1: CGPointMake(57.55, 26.15) controlPoint2: CGPointMake(56.95, 25.15)];
                [bezier4Path addCurveToPoint: CGPointMake(51.85, 25.15) controlPoint1: CGPointMake(54.75, 23.45) controlPoint2: CGPointMake(52.95, 23.85)];
                [bezier4Path addCurveToPoint: CGPointMake(52.35, 28.45) controlPoint1: CGPointMake(50.95, 26.15) controlPoint2: CGPointMake(50.75, 27.95)];
                [bezier4Path addCurveToPoint: CGPointMake(53.75, 28.15) controlPoint1: CGPointMake(53.05, 28.65) controlPoint2: CGPointMake(53.35, 28.55)];
                [bezier4Path addCurveToPoint: CGPointMake(54.95, 25.95) controlPoint1: CGPointMake(54.15, 27.75) controlPoint2: CGPointMake(54.85, 26.65)];
                [bezier4Path addCurveToPoint: CGPointMake(54.75, 25.85) controlPoint1: CGPointMake(54.95, 25.85) controlPoint2: CGPointMake(54.75, 25.75)];
                [bezier4Path addCurveToPoint: CGPointMake(53.85, 27.55) controlPoint1: CGPointMake(54.65, 26.35) controlPoint2: CGPointMake(54.15, 27.15)];
                [bezier4Path addCurveToPoint: CGPointMake(52.25, 27.95) controlPoint1: CGPointMake(53.35, 28.25) controlPoint2: CGPointMake(53.15, 28.35)];
                [bezier4Path addCurveToPoint: CGPointMake(51.85, 25.55) controlPoint1: CGPointMake(51.15, 27.45) controlPoint2: CGPointMake(51.05, 26.55)];
                [bezier4Path addCurveToPoint: CGPointMake(56.95, 25.75) controlPoint1: CGPointMake(53.05, 23.95) controlPoint2: CGPointMake(56.05, 23.45)];
                [bezier4Path addCurveToPoint: CGPointMake(51.05, 27.85) controlPoint1: CGPointMake(57.95, 28.35) controlPoint2: CGPointMake(52.45, 28.55)];
                [bezier4Path addCurveToPoint: CGPointMake(52.95, 23.25) controlPoint1: CGPointMake(48.55, 26.55) controlPoint2: CGPointMake(51.05, 23.65)];
                [bezier4Path addCurveToPoint: CGPointMake(54.25, 23.15) controlPoint1: CGPointMake(53.35, 23.15) controlPoint2: CGPointMake(53.85, 23.05)];
                [bezier4Path addCurveToPoint: CGPointMake(55.65, 24.75) controlPoint1: CGPointMake(54.75, 23.25) controlPoint2: CGPointMake(55.65, 24.15)];
                [bezier4Path addCurveToPoint: CGPointMake(53.85, 26.15) controlPoint1: CGPointMake(55.65, 25.45) controlPoint2: CGPointMake(54.15, 26.05)];
                [bezier4Path addCurveToPoint: CGPointMake(53.15, 26.05) controlPoint1: CGPointMake(53.65, 26.15) controlPoint2: CGPointMake(53.35, 26.15)];
                [bezier4Path addCurveToPoint: CGPointMake(51.25, 25.45) controlPoint1: CGPointMake(52.45, 25.95) controlPoint2: CGPointMake(51.85, 25.75)];
                [bezier4Path addCurveToPoint: CGPointMake(50.65, 25.05) controlPoint1: CGPointMake(51.05, 25.35) controlPoint2: CGPointMake(50.85, 25.15)];
                [bezier4Path addCurveToPoint: CGPointMake(50.15, 24.65) controlPoint1: CGPointMake(50.45, 24.95) controlPoint2: CGPointMake(50.25, 24.75)];
                [bezier4Path addCurveToPoint: CGPointMake(50.55, 22.65) controlPoint1: CGPointMake(50.25, 23.95) controlPoint2: CGPointMake(50.45, 23.35)];
                [bezier4Path addCurveToPoint: CGPointMake(54.95, 22.25) controlPoint1: CGPointMake(51.35, 21.75) controlPoint2: CGPointMake(53.95, 22.05)];
                [bezier4Path addCurveToPoint: CGPointMake(58.35, 25.25) controlPoint1: CGPointMake(56.45, 22.55) controlPoint2: CGPointMake(59.05, 23.25)];
                [bezier4Path addCurveToPoint: CGPointMake(55.15, 26.95) controlPoint1: CGPointMake(57.95, 26.35) controlPoint2: CGPointMake(56.05, 26.95)];
                [bezier4Path addCurveToPoint: CGPointMake(52.25, 24.35) controlPoint1: CGPointMake(53.75, 26.85) controlPoint2: CGPointMake(52.45, 25.65)];
                [bezier4Path addCurveToPoint: CGPointMake(55.35, 21.55) controlPoint1: CGPointMake(52.05, 22.65) controlPoint2: CGPointMake(53.75, 21.15)];
                [bezier4Path addCurveToPoint: CGPointMake(55.65, 21.55) controlPoint1: CGPointMake(55.45, 21.55) controlPoint2: CGPointMake(55.55, 21.55)];
                [bezier4Path addCurveToPoint: CGPointMake(56.65, 23.95) controlPoint1: CGPointMake(55.95, 22.35) controlPoint2: CGPointMake(56.25, 23.15)];
                [bezier4Path addCurveToPoint: CGPointMake(54.95, 24.85) controlPoint1: CGPointMake(56.45, 24.75) controlPoint2: CGPointMake(55.55, 24.75)];
                [bezier4Path addCurveToPoint: CGPointMake(53.35, 24.95) controlPoint1: CGPointMake(54.45, 24.95) controlPoint2: CGPointMake(53.85, 24.95)];
                [bezier4Path addCurveToPoint: CGPointMake(50.25, 21.85) controlPoint1: CGPointMake(51.55, 24.85) controlPoint2: CGPointMake(49.45, 24.25)];
                [bezier4Path addCurveToPoint: CGPointMake(52.05, 20.15) controlPoint1: CGPointMake(50.55, 20.95) controlPoint2: CGPointMake(51.15, 20.35)];
                [bezier4Path addCurveToPoint: CGPointMake(54.55, 21.45) controlPoint1: CGPointMake(53.15, 19.85) controlPoint2: CGPointMake(54.45, 20.05)];
                [bezier4Path addCurveToPoint: CGPointMake(54.95, 21.55) controlPoint1: CGPointMake(54.75, 21.65) controlPoint2: CGPointMake(54.95, 21.65)];
                [bezier4Path addLineToPoint: CGPointMake(54.95, 21.55)];
                [bezier4Path closePath];
                bezier4Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier4Path fill];
            }
        }
        
        
        //// Group 13
        {
            //// Group 14
            {
                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
                [bezier5Path moveToPoint: CGPointMake(54.95, 46.15)];
                [bezier5Path addCurveToPoint: CGPointMake(48.55, 46.15) controlPoint1: CGPointMake(54.45, 43.35) controlPoint2: CGPointMake(49.05, 43.45)];
                [bezier5Path addCurveToPoint: CGPointMake(49.35, 46.35) controlPoint1: CGPointMake(48.45, 46.65) controlPoint2: CGPointMake(49.25, 46.85)];
                [bezier5Path addCurveToPoint: CGPointMake(54.15, 46.35) controlPoint1: CGPointMake(49.65, 44.45) controlPoint2: CGPointMake(53.85, 44.45)];
                [bezier5Path addCurveToPoint: CGPointMake(54.95, 46.15) controlPoint1: CGPointMake(54.25, 46.95) controlPoint2: CGPointMake(55.05, 46.75)];
                [bezier5Path addLineToPoint: CGPointMake(54.95, 46.15)];
                [bezier5Path closePath];
                bezier5Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier5Path fill];
            }
        }
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(46.65, 29.75, 9.6, 9.6)];
        [fillColor1 setFill];
        [oval3Path fill];
        
        
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
        [bezier6Path moveToPoint: CGPointMake(64.05, 64.95)];
        [bezier6Path addCurveToPoint: CGPointMake(63.85, 68.55) controlPoint1: CGPointMake(64.95, 66.05) controlPoint2: CGPointMake(64.85, 67.65)];
        [bezier6Path addLineToPoint: CGPointMake(63.45, 68.85)];
        [bezier6Path addCurveToPoint: CGPointMake(59.95, 68.35) controlPoint1: CGPointMake(62.45, 69.65) controlPoint2: CGPointMake(60.85, 69.45)];
        [bezier6Path addLineToPoint: CGPointMake(51.35, 57.75)];
        [bezier6Path addCurveToPoint: CGPointMake(51.55, 54.15) controlPoint1: CGPointMake(50.45, 56.65) controlPoint2: CGPointMake(50.55, 55.05)];
        [bezier6Path addLineToPoint: CGPointMake(51.95, 53.85)];
        [bezier6Path addCurveToPoint: CGPointMake(55.45, 54.35) controlPoint1: CGPointMake(52.95, 53.05) controlPoint2: CGPointMake(54.55, 53.25)];
        [bezier6Path addLineToPoint: CGPointMake(64.05, 64.95)];
        [bezier6Path closePath];
        bezier6Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier6Path fill];
        
        
        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
        [bezier7Path moveToPoint: CGPointMake(57.45, 77.35)];
        [bezier7Path addCurveToPoint: CGPointMake(54.25, 77.65) controlPoint1: CGPointMake(56.75, 78.35) controlPoint2: CGPointMake(55.25, 78.45)];
        [bezier7Path addLineToPoint: CGPointMake(53.85, 77.35)];
        [bezier7Path addCurveToPoint: CGPointMake(53.15, 74.15) controlPoint1: CGPointMake(52.75, 76.55) controlPoint2: CGPointMake(52.45, 75.15)];
        [bezier7Path addLineToPoint: CGPointMake(59.85, 64.95)];
        [bezier7Path addCurveToPoint: CGPointMake(63.05, 64.65) controlPoint1: CGPointMake(60.55, 63.95) controlPoint2: CGPointMake(62.05, 63.85)];
        [bezier7Path addLineToPoint: CGPointMake(63.45, 64.95)];
        [bezier7Path addCurveToPoint: CGPointMake(64.15, 68.15) controlPoint1: CGPointMake(64.55, 65.75) controlPoint2: CGPointMake(64.85, 67.15)];
        [bezier7Path addLineToPoint: CGPointMake(57.45, 77.35)];
        [bezier7Path closePath];
        bezier7Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier7Path fill];
        
        
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(42.95, 66.85)];
        [bezier8Path addCurveToPoint: CGPointMake(44.65, 69.85) controlPoint1: CGPointMake(42.55, 68.15) controlPoint2: CGPointMake(43.35, 69.45)];
        [bezier8Path addLineToPoint: CGPointMake(45.15, 69.95)];
        [bezier8Path addCurveToPoint: CGPointMake(48.15, 68.25) controlPoint1: CGPointMake(46.45, 70.35) controlPoint2: CGPointMake(47.75, 69.55)];
        [bezier8Path addLineToPoint: CGPointMake(51.55, 56.15)];
        [bezier8Path addCurveToPoint: CGPointMake(49.85, 53.15) controlPoint1: CGPointMake(51.95, 54.85) controlPoint2: CGPointMake(51.15, 53.55)];
        [bezier8Path addLineToPoint: CGPointMake(49.35, 53.05)];
        [bezier8Path addCurveToPoint: CGPointMake(46.35, 54.75) controlPoint1: CGPointMake(48.05, 52.65) controlPoint2: CGPointMake(46.75, 53.45)];
        [bezier8Path addLineToPoint: CGPointMake(42.95, 66.85)];
        [bezier8Path closePath];
        bezier8Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier8Path fill];
        
        
        //// Bezier 9 Drawing
        UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
        [bezier9Path moveToPoint: CGPointMake(45.05, 80.45)];
        [bezier9Path addCurveToPoint: CGPointMake(47.85, 82.45) controlPoint1: CGPointMake(45.25, 81.75) controlPoint2: CGPointMake(46.55, 82.65)];
        [bezier9Path addLineToPoint: CGPointMake(48.35, 82.35)];
        [bezier9Path addCurveToPoint: CGPointMake(50.35, 79.55) controlPoint1: CGPointMake(49.65, 82.15) controlPoint2: CGPointMake(50.55, 80.85)];
        [bezier9Path addLineToPoint: CGPointMake(48.25, 67.15)];
        [bezier9Path addCurveToPoint: CGPointMake(45.45, 65.15) controlPoint1: CGPointMake(48.05, 65.85) controlPoint2: CGPointMake(46.75, 64.95)];
        [bezier9Path addLineToPoint: CGPointMake(44.85, 65.25)];
        [bezier9Path addCurveToPoint: CGPointMake(42.85, 68.05) controlPoint1: CGPointMake(43.55, 65.45) controlPoint2: CGPointMake(42.65, 66.75)];
        [bezier9Path addLineToPoint: CGPointMake(45.05, 80.45)];
        [bezier9Path closePath];
        bezier9Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier9Path fill];
        
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(45.65, 40.15, 12, 19.3) cornerRadius: 2.6];
        [fillColor1 setFill];
        [rectanglePath fill];
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
