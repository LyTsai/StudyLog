//
//  ASymbol_Sleeps.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Sleeps.h"

@implementation ASymbol_Sleeps
{
    
}

@synthesize fillColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5, textForeground;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    textForeground = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    fillColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor1 = [UIColor colorWithRed: 0.49 green: 0.773 blue: 0.451 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.176 green: 0.616 blue: 0.282 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.176 green: 0.62 blue: 0.282 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor5 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)context
{
    // (1)
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// (2) Gradient Declarations
    //// Gradient Declarations
    CGFloat sVGID_1_Locations[] = {0, 0.8, 1};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor1.CGColor, (id)gradientColor2.CGColor, (id)gradientColor3.CGColor], sVGID_1_Locations);
    CGFloat sVGID_2_Locations[] = {0, 1};
    CGGradientRef sVGID_2_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor4.CGColor, (id)gradientColor5.CGColor], sVGID_2_Locations);

    
    // (3) - (4)
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);

    
    // drawing
    //// Group 3
    {
        //// Group 4
        {
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 99.9)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(50.01, 49.95), 0,
                                        CGPointMake(50.01, 49.95), 50,
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
                                        CGPointMake(50.36, -42.71),
                                        CGPointMake(50.36, 49.52),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Group 8
        {
            //// Oval 3 Drawing
            UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(25.25, 49.95, 12.8, 12.8)];
            [fillColor1 setFill];
            [oval3Path fill];
        }
        
        
        //// Group 9
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(40.95, 55.95)];
            [bezierPath addLineToPoint: CGPointMake(40.95, 63.05)];
            [bezierPath addLineToPoint: CGPointMake(71.45, 63.05)];
            [bezierPath addCurveToPoint: CGPointMake(66.25, 57.35) controlPoint1: CGPointMake(71.45, 63.05) controlPoint2: CGPointMake(71.35, 59.45)];
            [bezierPath addCurveToPoint: CGPointMake(40.95, 55.95) controlPoint1: CGPointMake(61.15, 55.25) controlPoint2: CGPointMake(40.95, 55.95)];
            [bezierPath closePath];
            bezierPath.miterLimit = 4;
            
            [fillColor1 setFill];
            [bezierPath fill];
        }
        
        
        //// Group 10
        {
            //// Group 11
            {
                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                [bezier2Path moveToPoint: CGPointMake(20.25, 44.35)];
                [bezier2Path addCurveToPoint: CGPointMake(20.25, 74.15) controlPoint1: CGPointMake(20.25, 54.25) controlPoint2: CGPointMake(20.25, 64.25)];
                [bezier2Path addCurveToPoint: CGPointMake(21.05, 74.15) controlPoint1: CGPointMake(20.25, 74.65) controlPoint2: CGPointMake(21.05, 74.65)];
                [bezier2Path addCurveToPoint: CGPointMake(21.05, 44.35) controlPoint1: CGPointMake(21.05, 64.25) controlPoint2: CGPointMake(21.05, 54.25)];
                [bezier2Path addCurveToPoint: CGPointMake(20.25, 44.35) controlPoint1: CGPointMake(21.05, 43.85) controlPoint2: CGPointMake(20.25, 43.85)];
                [bezier2Path addLineToPoint: CGPointMake(20.25, 44.35)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier2Path fill];
            }
        }
        
        
        //// Group 12
        {
            //// Group 13
            {
                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
                [bezier3Path moveToPoint: CGPointMake(76.35, 54.15)];
                [bezier3Path addCurveToPoint: CGPointMake(76.35, 74.15) controlPoint1: CGPointMake(76.35, 60.85) controlPoint2: CGPointMake(76.35, 67.45)];
                [bezier3Path addCurveToPoint: CGPointMake(77.15, 74.15) controlPoint1: CGPointMake(76.35, 74.65) controlPoint2: CGPointMake(77.15, 74.65)];
                [bezier3Path addCurveToPoint: CGPointMake(77.15, 54.15) controlPoint1: CGPointMake(77.15, 67.45) controlPoint2: CGPointMake(77.15, 60.85)];
                [bezier3Path addCurveToPoint: CGPointMake(76.35, 54.15) controlPoint1: CGPointMake(77.25, 53.65) controlPoint2: CGPointMake(76.35, 53.65)];
                [bezier3Path addLineToPoint: CGPointMake(76.35, 54.15)];
                [bezier3Path closePath];
                bezier3Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier3Path fill];
            }
        }
        
        
        //// Group 14
        {
            //// Group 15
            {
                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
                [bezier4Path moveToPoint: CGPointMake(21.05, 67.55)];
                [bezier4Path addCurveToPoint: CGPointMake(76.45, 67.55) controlPoint1: CGPointMake(39.55, 67.55) controlPoint2: CGPointMake(57.95, 67.55)];
                [bezier4Path addCurveToPoint: CGPointMake(76.45, 66.75) controlPoint1: CGPointMake(76.95, 67.55) controlPoint2: CGPointMake(76.95, 66.75)];
                [bezier4Path addCurveToPoint: CGPointMake(21.05, 66.75) controlPoint1: CGPointMake(57.95, 66.75) controlPoint2: CGPointMake(39.55, 66.75)];
                [bezier4Path addCurveToPoint: CGPointMake(21.05, 67.55) controlPoint1: CGPointMake(20.45, 66.75) controlPoint2: CGPointMake(20.45, 67.55)];
                [bezier4Path addLineToPoint: CGPointMake(21.05, 67.55)];
                [bezier4Path closePath];
                bezier4Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier4Path fill];
            }
        }
        
        
        //// Group 16
        {
            //// Group 17
            {
                //// Group 18
                {
                    //// Bezier 5 Drawing
                    UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
                    [bezier5Path moveToPoint: CGPointMake(54.65, 25.45)];
                    [bezier5Path addCurveToPoint: CGPointMake(75.85, 33.75) controlPoint1: CGPointMake(58.85, 33.25) controlPoint2: CGPointMake(67.45, 36.45)];
                    [bezier5Path addCurveToPoint: CGPointMake(75.65, 32.95) controlPoint1: CGPointMake(76.35, 33.55) controlPoint2: CGPointMake(76.15, 32.75)];
                    [bezier5Path addCurveToPoint: CGPointMake(55.45, 25.05) controlPoint1: CGPointMake(67.65, 35.55) controlPoint2: CGPointMake(59.35, 32.45)];
                    [bezier5Path addCurveToPoint: CGPointMake(54.65, 25.45) controlPoint1: CGPointMake(55.15, 24.55) controlPoint2: CGPointMake(54.35, 24.95)];
                    [bezier5Path addLineToPoint: CGPointMake(54.65, 25.45)];
                    [bezier5Path closePath];
                    bezier5Path.miterLimit = 4;
                    
                    [fillColor1 setFill];
                    [bezier5Path fill];
                }
            }
            
            
            //// Group 19
            {
                //// Group 20
                {
                    //// Bezier 6 Drawing
                    UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
                    [bezier6Path moveToPoint: CGPointMake(59.45, 22.35)];
                    [bezier6Path addCurveToPoint: CGPointMake(73.45, 27.85) controlPoint1: CGPointMake(62.15, 27.45) controlPoint2: CGPointMake(67.85, 29.65)];
                    [bezier6Path addCurveToPoint: CGPointMake(73.25, 27.05) controlPoint1: CGPointMake(73.95, 27.65) controlPoint2: CGPointMake(73.75, 26.85)];
                    [bezier6Path addCurveToPoint: CGPointMake(60.15, 21.95) controlPoint1: CGPointMake(68.05, 28.75) controlPoint2: CGPointMake(62.75, 26.75)];
                    [bezier6Path addCurveToPoint: CGPointMake(59.45, 22.35) controlPoint1: CGPointMake(59.85, 21.45) controlPoint2: CGPointMake(59.15, 21.95)];
                    [bezier6Path addLineToPoint: CGPointMake(59.45, 22.35)];
                    [bezier6Path closePath];
                    bezier6Path.miterLimit = 4;
                    
                    [fillColor1 setFill];
                    [bezier6Path fill];
                }
            }
            
            
            //// Group 21
            {
                //// Group 22
                {
                    //// Bezier 7 Drawing
                    UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
                    [bezier7Path moveToPoint: CGPointMake(64.15, 19.35)];
                    [bezier7Path addCurveToPoint: CGPointMake(71.05, 22.05) controlPoint1: CGPointMake(65.55, 21.85) controlPoint2: CGPointMake(68.35, 22.95)];
                    [bezier7Path addCurveToPoint: CGPointMake(70.85, 21.25) controlPoint1: CGPointMake(71.55, 21.85) controlPoint2: CGPointMake(71.35, 21.05)];
                    [bezier7Path addCurveToPoint: CGPointMake(64.85, 18.85) controlPoint1: CGPointMake(68.45, 22.05) controlPoint2: CGPointMake(66.05, 21.15)];
                    [bezier7Path addCurveToPoint: CGPointMake(64.15, 19.35) controlPoint1: CGPointMake(64.65, 18.45) controlPoint2: CGPointMake(63.95, 18.85)];
                    [bezier7Path addLineToPoint: CGPointMake(64.15, 19.35)];
                    [bezier7Path closePath];
                    bezier7Path.miterLimit = 4;
                    
                    [fillColor1 setFill];
                    [bezier7Path fill];
                }
            }
        }
        
        
        //// Label Drawing
        CGRect labelRect = CGRectMake(46.59, 17.48, 12.56, 31);
        NSMutableParagraphStyle* labelStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        labelStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary* labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 25.11], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: labelStyle};
        
        [@"z" drawInRect: labelRect withAttributes: labelFontAttributes];
        
        
        //// Label 2 Drawing
        CGRect label2Rect = CGRectMake(37, 39.97, 3.74, 11);
        NSMutableParagraphStyle* label2Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        label2Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* label2FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 7.49], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: label2Style};
        
        [@"z" drawInRect: label2Rect withAttributes: label2FontAttributes];
        
        
        //// Label 3 Drawing
        CGRect label3Rect = CGRectMake(47.21, 27.92, 3.74, 11);
        NSMutableParagraphStyle* label3Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        label3Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* label3FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 7.49], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: label3Style};
        
        [@"z" drawInRect: label3Rect withAttributes: label3FontAttributes];
        
        
        //// Label 4 Drawing
        CGRect label4Rect = CGRectMake(44.75, 24.16, 6.59, 17);
        NSMutableParagraphStyle* label4Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        label4Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* label4FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 13.18], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: label4Style};
        
        [@"z" drawInRect: label4Rect withAttributes: label4FontAttributes];
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
