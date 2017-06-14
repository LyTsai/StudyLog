//
//  ASymbol_SleepWell.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_SleepWell.h"

@implementation ASymbol_SleepWell

@synthesize fillColor1, strokeColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5, textForeground;

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
    textForeground = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    strokeColor1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];}

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
                                        CGPointMake(50.03, 50), 0,
                                        CGPointMake(50.03, 50), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 5
    {
        //// Group 6
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.3, 3.6, 92.2, 92.1)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.38, -42.66),
                                        CGPointMake(50.38, 49.57),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 7
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(39.5, 52.4)];
        [bezierPath addLineToPoint: CGPointMake(39.5, 60.5)];
        [bezierPath addLineToPoint: CGPointMake(74.4, 60.5)];
        [bezierPath addCurveToPoint: CGPointMake(68.4, 54) controlPoint1: CGPointMake(74.4, 60.5) controlPoint2: CGPointMake(74.3, 56.4)];
        [bezierPath addCurveToPoint: CGPointMake(39.5, 52.4) controlPoint1: CGPointMake(62.5, 51.6) controlPoint2: CGPointMake(39.5, 52.4)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezierPath fill];
        
        
        //// Label Drawing
        CGRect labelRect = CGRectMake(42.54, 34.68, 4.29, 12);
        NSMutableParagraphStyle* labelStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        labelStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary* labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 8.58], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: labelStyle};
        
        [@"z" drawInRect: labelRect withAttributes: labelFontAttributes];
        
        
        //// Label 2 Drawing
        CGRect label2Rect = CGRectMake(51.7, 23.65, 7.98, 20);
        NSMutableParagraphStyle* label2Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        label2Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* label2FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 15.97], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: label2Style};
        
        [@"z" drawInRect: label2Rect withAttributes: label2FontAttributes];
        
        
        //// Label 3 Drawing
        CGRect label3Rect = CGRectMake(63.61, 6.67, 14.38, 36);
        NSMutableParagraphStyle* label3Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        label3Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* label3FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 28.76], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: label3Style};
        
        [@"z" drawInRect: label3Rect withAttributes: label3FontAttributes];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(21.3, 39.1)];
        [bezier2Path addLineToPoint: CGPointMake(21.3, 73.2)];
        [strokeColor1 setStroke];
        bezier2Path.lineWidth = 1;
        [bezier2Path stroke];
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(79, 50.3)];
        [bezier3Path addLineToPoint: CGPointMake(79, 73.2)];
        [strokeColor1 setStroke];
        bezier3Path.lineWidth = 1;
        [bezier3Path stroke];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(21.7, 65.2)];
        [bezier4Path addLineToPoint: CGPointMake(78.9, 65.2)];
        [strokeColor1 setStroke];
        bezier4Path.lineWidth = 1;
        [bezier4Path stroke];
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(24.4, 47.3, 13.6, 13.6)];
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
