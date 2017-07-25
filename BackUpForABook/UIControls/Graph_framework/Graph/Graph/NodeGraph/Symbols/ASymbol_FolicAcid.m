//
//  ASymbol_FolicAcid.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_FolicAcid.h"

@implementation ASymbol_FolicAcid

@synthesize fillColor1, fillColor2, strokeColor1, gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5, textForeground;

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
    fillColor2 = [UIColor colorWithRed: 0.102 green: 0.102 blue: 0.102 alpha: 1];
    textForeground = [UIColor colorWithRed: 0.102 green: 0.102 blue: 0.102 alpha: 1];
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
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 100, 100)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(50, 49.97), 0,
                                        CGPointMake(50, 49.97), 50,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 4
    {
        //// Group 5
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.3, 3.5, 92.2, 92.2)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawLinearGradient(context, sVGID_2_,
                                        CGPointMake(50.35, -42.68),
                                        CGPointMake(50.35, 49.54),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Group 6
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(31, 38.2, 38, 40) cornerRadius: 3.2];
        [strokeColor1 setStroke];
        rectanglePath.lineWidth = 0.93;
        [rectanglePath stroke];
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(63.6, 30.8)];
        [bezierPath addCurveToPoint: CGPointMake(61.6, 32.8) controlPoint1: CGPointMake(63.6, 31.9) controlPoint2: CGPointMake(62.7, 32.8)];
        [bezierPath addLineToPoint: CGPointMake(39.2, 32.8)];
        [bezierPath addCurveToPoint: CGPointMake(37.2, 30.8) controlPoint1: CGPointMake(38.1, 32.8) controlPoint2: CGPointMake(37.2, 31.9)];
        [bezierPath addLineToPoint: CGPointMake(37.2, 24.2)];
        [bezierPath addCurveToPoint: CGPointMake(39.2, 22.2) controlPoint1: CGPointMake(37.2, 23.1) controlPoint2: CGPointMake(38.1, 22.2)];
        [bezierPath addLineToPoint: CGPointMake(61.5, 22.2)];
        [bezierPath addCurveToPoint: CGPointMake(63.5, 24.2) controlPoint1: CGPointMake(62.6, 22.2) controlPoint2: CGPointMake(63.5, 23.1)];
        [bezierPath addLineToPoint: CGPointMake(63.5, 30.8)];
        [bezierPath addLineToPoint: CGPointMake(63.6, 30.8)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezierPath fill];
        
        
        //// Group 7
        {
            //// Group 8
            {
                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                [bezier2Path moveToPoint: CGPointMake(37.1, 38.7)];
                [bezier2Path addCurveToPoint: CGPointMake(40.7, 31.9) controlPoint1: CGPointMake(40.6, 38.9) controlPoint2: CGPointMake(40.6, 34.3)];
                [bezier2Path addCurveToPoint: CGPointMake(39.7, 31.9) controlPoint1: CGPointMake(40.7, 31.3) controlPoint2: CGPointMake(39.7, 31.3)];
                [bezier2Path addCurveToPoint: CGPointMake(37.1, 37.7) controlPoint1: CGPointMake(39.7, 33.8) controlPoint2: CGPointMake(39.9, 37.9)];
                [bezier2Path addCurveToPoint: CGPointMake(37.1, 38.7) controlPoint1: CGPointMake(36.5, 37.7) controlPoint2: CGPointMake(36.5, 38.7)];
                [bezier2Path addLineToPoint: CGPointMake(37.1, 38.7)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier2Path fill];
            }
        }
        
        
        //// Group 9
        {
            //// Group 10
            {
                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
                [bezier3Path moveToPoint: CGPointMake(63.7, 37.8)];
                [bezier3Path addCurveToPoint: CGPointMake(61.1, 32) controlPoint1: CGPointMake(60.9, 38) controlPoint2: CGPointMake(61.1, 33.9)];
                [bezier3Path addCurveToPoint: CGPointMake(60.1, 32) controlPoint1: CGPointMake(61.1, 31.4) controlPoint2: CGPointMake(60.1, 31.4)];
                [bezier3Path addCurveToPoint: CGPointMake(63.6, 38.8) controlPoint1: CGPointMake(60.1, 34.4) controlPoint2: CGPointMake(60.1, 39)];
                [bezier3Path addCurveToPoint: CGPointMake(63.7, 37.8) controlPoint1: CGPointMake(64.3, 38.7) controlPoint2: CGPointMake(64.4, 37.7)];
                [bezier3Path addLineToPoint: CGPointMake(63.7, 37.8)];
                [bezier3Path closePath];
                bezier3Path.miterLimit = 4;
                
                [fillColor1 setFill];
                [bezier3Path fill];
            }
        }
        
        
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(33.6, 48.5, 33.2, 18.6)];
        [fillColor1 setFill];
        [rectangle2Path fill];
        
        
        //// Rectangle 3 Drawing
        UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(56.1, 23.1, 1.4, 8.5)];
        [fillColor2 setFill];
        [rectangle3Path fill];
        
        
        //// Rectangle 4 Drawing
        UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(58.5, 23.1, 2.9, 8.5)];
        [fillColor2 setFill];
        [rectangle4Path fill];
        
        
        //// Label Drawing
        CGRect labelRect = CGRectMake(38.86, 44.86, 21.35, 13);
        UIBezierPath* labelPath = [UIBezierPath bezierPathWithRect: labelRect];
        [strokeColor1 setStroke];
        labelPath.lineWidth = 0.07;
        [labelPath stroke];
        NSMutableParagraphStyle* labelStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        labelStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary* labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"ArialMT" size: 8.94], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: labelStyle};
        
        [@"Folic " drawInRect: labelRect withAttributes: labelFontAttributes];
        
        
        //// Label 2 Drawing
        CGRect label2Rect = CGRectMake(38.86, 54.26, 17.39, 13);
        UIBezierPath* label2Path = [UIBezierPath bezierPathWithRect: label2Rect];
        [strokeColor1 setStroke];
        label2Path.lineWidth = 0.07;
        [label2Path stroke];
        NSMutableParagraphStyle* label2Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        label2Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* label2FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"ArialMT" size: 8.94], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: label2Style};
        
        [@"Acid" drawInRect: label2Rect withAttributes: label2FontAttributes];
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
