//
//  ASymbol_ManageWeights.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_ManageWeights.h"

@implementation ASymbol_ManageWeights

@synthesize fillColor1, strokeColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    gradientColor1 = [UIColor colorWithRed: 0.49 green: 0.773 blue: 0.451 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.176 green: 0.616 blue: 0.282 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.176 green: 0.62 blue: 0.282 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor5 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    strokeColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
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
    //// Group 2
    {
        //// Group 3
        {
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 99.9)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(49.98, 49.99), 0,
                                        CGPointMake(49.98, 49.99), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 4
    {
        //// Group 5
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.2, 3.5, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.34, -42.67),
                                        CGPointMake(50.34, 49.56),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 6
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(75.1, 29.55)];
        [bezierPath addLineToPoint: CGPointMake(67.2, 29.55)];
        [bezierPath addCurveToPoint: CGPointMake(67.2, 30.75) controlPoint1: CGPointMake(67.2, 29.95) controlPoint2: CGPointMake(67.2, 30.35)];
        [bezierPath addCurveToPoint: CGPointMake(51.2, 46.75) controlPoint1: CGPointMake(67.2, 39.65) controlPoint2: CGPointMake(60, 46.75)];
        [bezierPath addCurveToPoint: CGPointMake(35.2, 30.75) controlPoint1: CGPointMake(42.3, 46.75) controlPoint2: CGPointMake(35.2, 39.55)];
        [bezierPath addCurveToPoint: CGPointMake(35.2, 29.55) controlPoint1: CGPointMake(35.2, 30.35) controlPoint2: CGPointMake(35.2, 29.95)];
        [bezierPath addLineToPoint: CGPointMake(27.1, 29.55)];
        [bezierPath addCurveToPoint: CGPointMake(24.8, 31.95) controlPoint1: CGPointMake(25.8, 29.55) controlPoint2: CGPointMake(24.8, 30.65)];
        [bezierPath addLineToPoint: CGPointMake(24.8, 76.85)];
        [bezierPath addCurveToPoint: CGPointMake(27.1, 79.25) controlPoint1: CGPointMake(24.8, 78.15) controlPoint2: CGPointMake(25.8, 79.25)];
        [bezierPath addLineToPoint: CGPointMake(75.2, 79.25)];
        [bezierPath addCurveToPoint: CGPointMake(77.5, 76.85) controlPoint1: CGPointMake(76.5, 79.25) controlPoint2: CGPointMake(77.5, 78.15)];
        [bezierPath addLineToPoint: CGPointMake(77.5, 31.95)];
        [bezierPath addCurveToPoint: CGPointMake(75.1, 29.55) controlPoint1: CGPointMake(77.4, 30.65) controlPoint2: CGPointMake(76.4, 29.55)];
        [bezierPath closePath];
        [strokeColor1 setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(49.1, 29.75, 4.2, 4.2)];
        [fillColor1 setFill];
        [oval3Path fill];
        
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(50.3, 24.55, 1.8, 7.1) cornerRadius: 0.9];
        [fillColor1 setFill];
        [rectanglePath fill];
        
        
        //// Group 7
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(59.6, 61.75)];
            [bezier2Path addCurveToPoint: CGPointMake(59.7, 51.55) controlPoint1: CGPointMake(59.6, 61.75) controlPoint2: CGPointMake(56.9, 53.35)];
            [bezier2Path addCurveToPoint: CGPointMake(68.4, 54.25) controlPoint1: CGPointMake(62.5, 49.75) controlPoint2: CGPointMake(66.5, 51.35)];
            [bezier2Path addCurveToPoint: CGPointMake(68.4, 62.15) controlPoint1: CGPointMake(70.3, 57.15) controlPoint2: CGPointMake(70.7, 58.65)];
            [bezier2Path addCurveToPoint: CGPointMake(63.7, 71.85) controlPoint1: CGPointMake(66.1, 65.55) controlPoint2: CGPointMake(64.6, 70.05)];
            [bezier2Path addCurveToPoint: CGPointMake(57.7, 75.05) controlPoint1: CGPointMake(62.8, 73.65) controlPoint2: CGPointMake(60.3, 76.65)];
            [bezier2Path addCurveToPoint: CGPointMake(56.7, 67.95) controlPoint1: CGPointMake(55.2, 73.45) controlPoint2: CGPointMake(55.6, 69.85)];
            [bezier2Path addCurveToPoint: CGPointMake(59.6, 61.75) controlPoint1: CGPointMake(57.9, 65.85) controlPoint2: CGPointMake(59.6, 64.45)];
            [bezier2Path closePath];
            bezier2Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier2Path fill];
            
            
            //// Oval 4 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 62.2, 47.55);
            CGContextRotateCTM(context, 13 * M_PI / 180);
            
            UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-1.7, -2.3, 3.4, 4.6)];
            [fillColor1 setFill];
            [oval4Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
            [bezier3Path moveToPoint: CGPointMake(66.9, 49.15)];
            [bezier3Path addCurveToPoint: CGPointMake(66.4, 47.15) controlPoint1: CGPointMake(67.2, 48.35) controlPoint2: CGPointMake(67, 47.45)];
            [bezier3Path addCurveToPoint: CGPointMake(64.6, 48.25) controlPoint1: CGPointMake(65.8, 46.85) controlPoint2: CGPointMake(65, 47.35)];
            [bezier3Path addCurveToPoint: CGPointMake(65.1, 50.25) controlPoint1: CGPointMake(64.3, 49.15) controlPoint2: CGPointMake(64.5, 49.95)];
            [bezier3Path addCurveToPoint: CGPointMake(66.9, 49.15) controlPoint1: CGPointMake(65.8, 50.45) controlPoint2: CGPointMake(66.5, 50.05)];
            [bezier3Path closePath];
            bezier3Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier3Path fill];
            
            
            //// Oval 5 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 68, 50.45);
            CGContextRotateCTM(context, 27.55 * M_PI / 180);
            
            UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-1, -1.4, 2, 2.8)];
            [fillColor1 setFill];
            [oval5Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Oval 6 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 69.85, 52.45);
            CGContextRotateCTM(context, 38 * M_PI / 180);
            
            UIBezierPath* oval6Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-0.8, -1.1, 1.6, 2.2)];
            [fillColor1 setFill];
            [oval6Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(71.5, 55.15)];
            [bezier4Path addCurveToPoint: CGPointMake(71.8, 54.05) controlPoint1: CGPointMake(71.9, 54.85) controlPoint2: CGPointMake(72, 54.35)];
            [bezier4Path addCurveToPoint: CGPointMake(70.6, 54.05) controlPoint1: CGPointMake(71.6, 53.75) controlPoint2: CGPointMake(71, 53.75)];
            [bezier4Path addCurveToPoint: CGPointMake(70.3, 55.15) controlPoint1: CGPointMake(70.2, 54.35) controlPoint2: CGPointMake(70.1, 54.85)];
            [bezier4Path addCurveToPoint: CGPointMake(71.5, 55.15) controlPoint1: CGPointMake(70.6, 55.45) controlPoint2: CGPointMake(71.1, 55.45)];
            [bezier4Path closePath];
            bezier4Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier4Path fill];
        }
        
        
        //// Group 8
        {
            //// Bezier 5 Drawing
            UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
            [bezier5Path moveToPoint: CGPointMake(42, 61.75)];
            [bezier5Path addCurveToPoint: CGPointMake(41.9, 51.55) controlPoint1: CGPointMake(42, 61.75) controlPoint2: CGPointMake(44.7, 53.35)];
            [bezier5Path addCurveToPoint: CGPointMake(33.2, 54.25) controlPoint1: CGPointMake(39.1, 49.75) controlPoint2: CGPointMake(35.1, 51.35)];
            [bezier5Path addCurveToPoint: CGPointMake(33.2, 62.15) controlPoint1: CGPointMake(31.3, 57.15) controlPoint2: CGPointMake(30.9, 58.65)];
            [bezier5Path addCurveToPoint: CGPointMake(37.9, 71.85) controlPoint1: CGPointMake(35.5, 65.55) controlPoint2: CGPointMake(37, 70.05)];
            [bezier5Path addCurveToPoint: CGPointMake(43.9, 75.05) controlPoint1: CGPointMake(38.8, 73.65) controlPoint2: CGPointMake(41.3, 76.65)];
            [bezier5Path addCurveToPoint: CGPointMake(44.9, 67.95) controlPoint1: CGPointMake(46.4, 73.45) controlPoint2: CGPointMake(46, 69.85)];
            [bezier5Path addCurveToPoint: CGPointMake(42, 61.75) controlPoint1: CGPointMake(43.7, 65.85) controlPoint2: CGPointMake(42, 64.45)];
            [bezier5Path closePath];
            bezier5Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier5Path fill];
            
            
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(37.8, 47.85)];
            [bezier6Path addCurveToPoint: CGPointMake(38.9, 45.25) controlPoint1: CGPointMake(37.5, 46.65) controlPoint2: CGPointMake(38, 45.45)];
            [bezier6Path addCurveToPoint: CGPointMake(41.1, 47.05) controlPoint1: CGPointMake(39.8, 45.05) controlPoint2: CGPointMake(40.8, 45.85)];
            [bezier6Path addCurveToPoint: CGPointMake(40, 49.65) controlPoint1: CGPointMake(41.4, 48.25) controlPoint2: CGPointMake(40.9, 49.45)];
            [bezier6Path addCurveToPoint: CGPointMake(37.8, 47.85) controlPoint1: CGPointMake(39, 49.95) controlPoint2: CGPointMake(38.1, 49.15)];
            [bezier6Path closePath];
            bezier6Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier6Path fill];
            
            
            //// Bezier 7 Drawing
            UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
            [bezier7Path moveToPoint: CGPointMake(34.7, 49.15)];
            [bezier7Path addCurveToPoint: CGPointMake(35.2, 47.15) controlPoint1: CGPointMake(34.4, 48.35) controlPoint2: CGPointMake(34.6, 47.45)];
            [bezier7Path addCurveToPoint: CGPointMake(37, 48.25) controlPoint1: CGPointMake(35.8, 46.85) controlPoint2: CGPointMake(36.6, 47.35)];
            [bezier7Path addCurveToPoint: CGPointMake(36.5, 50.25) controlPoint1: CGPointMake(37.3, 49.05) controlPoint2: CGPointMake(37.1, 49.95)];
            [bezier7Path addCurveToPoint: CGPointMake(34.7, 49.15) controlPoint1: CGPointMake(35.8, 50.45) controlPoint2: CGPointMake(35, 49.95)];
            [bezier7Path closePath];
            bezier7Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier7Path fill];
            
            
            //// Oval 7 Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 33.6, 50.35);
            CGContextRotateCTM(context, -27.45 * M_PI / 180);
            
            UIBezierPath* oval7Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-1, -1.4, 2, 2.8)];
            [fillColor1 setFill];
            [oval7Path fill];
            
            CGContextRestoreGState(context);
            
            
            //// Bezier 8 Drawing
            UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
            [bezier8Path moveToPoint: CGPointMake(31.1, 52.85)];
            [bezier8Path addCurveToPoint: CGPointMake(31.1, 51.45) controlPoint1: CGPointMake(30.7, 52.35) controlPoint2: CGPointMake(30.7, 51.75)];
            [bezier8Path addCurveToPoint: CGPointMake(32.4, 51.85) controlPoint1: CGPointMake(31.5, 51.15) controlPoint2: CGPointMake(32, 51.35)];
            [bezier8Path addCurveToPoint: CGPointMake(32.4, 53.25) controlPoint1: CGPointMake(32.8, 52.35) controlPoint2: CGPointMake(32.8, 52.95)];
            [bezier8Path addCurveToPoint: CGPointMake(31.1, 52.85) controlPoint1: CGPointMake(32, 53.45) controlPoint2: CGPointMake(31.4, 53.35)];
            [bezier8Path closePath];
            bezier8Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier8Path fill];
            
            
            //// Bezier 9 Drawing
            UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
            [bezier9Path moveToPoint: CGPointMake(30, 55.05)];
            [bezier9Path addCurveToPoint: CGPointMake(29.7, 53.95) controlPoint1: CGPointMake(29.6, 54.75) controlPoint2: CGPointMake(29.5, 54.25)];
            [bezier9Path addCurveToPoint: CGPointMake(30.9, 53.95) controlPoint1: CGPointMake(29.9, 53.65) controlPoint2: CGPointMake(30.5, 53.65)];
            [bezier9Path addCurveToPoint: CGPointMake(31.2, 55.05) controlPoint1: CGPointMake(31.3, 54.25) controlPoint2: CGPointMake(31.4, 54.75)];
            [bezier9Path addCurveToPoint: CGPointMake(30, 55.05) controlPoint1: CGPointMake(31, 55.45) controlPoint2: CGPointMake(30.4, 55.45)];
            [bezier9Path closePath];
            bezier9Path.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezier9Path fill];
        }
        
        
        //// Group 9
        {
            //// Group 10
            {
                //// Bezier 10 Drawing
                UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
                [bezier10Path moveToPoint: CGPointMake(57, 23.85)];
                [bezier10Path addCurveToPoint: CGPointMake(45.4, 23.65) controlPoint1: CGPointMake(53.6, 20.75) controlPoint2: CGPointMake(48.9, 20.65)];
                [bezier10Path addCurveToPoint: CGPointMake(46.3, 24.55) controlPoint1: CGPointMake(44.8, 24.25) controlPoint2: CGPointMake(45.7, 25.15)];
                [bezier10Path addCurveToPoint: CGPointMake(56, 24.75) controlPoint1: CGPointMake(49.2, 22.05) controlPoint2: CGPointMake(53.2, 22.15)];
                [bezier10Path addCurveToPoint: CGPointMake(57, 23.85) controlPoint1: CGPointMake(56.7, 25.35) controlPoint2: CGPointMake(57.6, 24.45)];
                [bezier10Path addLineToPoint: CGPointMake(57, 23.85)];
                [bezier10Path closePath];
                bezier10Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier10Path fill];
            }
        }
        
        
        //// Oval 8 Drawing
        UIBezierPath* oval8Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(40.5, 19.95, 21.4, 21.4)];
        [strokeColor1 setStroke];
        oval8Path.lineWidth = 1;
        [oval8Path stroke];
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
