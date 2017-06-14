//
//  ANCardsBarClipStyle1.m
//  ABook_iPhone
//
//  Created by hui wang on 5/2/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "ANCardsBarClipStyle1.h"
#import "ANText.h"

@implementation ANCardsBarClipStyle1
{
    
}

@synthesize gradientColor1, gradientColor2, gradientColor3, gradientColor4, fillColor1, fillColor2, textForeground, label;

-(float)edgeOffset
{
    return 11.35;
}

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(102, 102);
    
    gradientColor1 = [UIColor colorWithRed: 0.975 green: 0.927 blue: 0.115 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.946 green: 0.458 blue: 0.099 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    
    fillColor1 = [UIColor colorWithRed: 0.005 green: 0.005 blue: 0.005 alpha: 1];
    textForeground = [UIColor colorWithRed: 0.005 green: 0.005 blue: 0.005 alpha: 1];
    
    label = @"";
}

- (void)drawInContext:(CGContextRef)context
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// Gradient Declarations
    CGFloat sVGID_1_Locations[] = {0, 0.97};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor1.CGColor, (id)gradientColor2.CGColor], sVGID_1_Locations);
    CGFloat sVGID_2_Locations[] = {0, 1};
    CGGradientRef sVGID_2_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor3.CGColor, (id)gradientColor4.CGColor], sVGID_2_Locations);
    
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);

    //// Bezier 4 Drawing
    UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint: CGPointMake(14.94, 0.05)];
    [bezier4Path addCurveToPoint: CGPointMake(0, 9.85) controlPoint1: CGPointMake(14.94, 0.05) controlPoint2: CGPointMake(1.94, -0.25)];
    [bezier4Path addCurveToPoint: CGPointMake(0.19, 7.95) controlPoint1: CGPointMake(0, 9.95) controlPoint2: CGPointMake(0.19, 7.85)];
    [bezier4Path addCurveToPoint: CGPointMake(0.19, 8.05) controlPoint1: CGPointMake(0.19, 7.95) controlPoint2: CGPointMake(0.19, 7.95)];
    [bezier4Path addLineToPoint: CGPointMake(0.19, 8.05)];
    [bezier4Path addCurveToPoint: CGPointMake(0, 9.05) controlPoint1: CGPointMake(0.1, 8.35) controlPoint2: CGPointMake(0, 10.25)];
    [bezier4Path addCurveToPoint: CGPointMake(0, 78.55) controlPoint1: CGPointMake(0, -14.15) controlPoint2: CGPointMake(0, 55.35)];
    [bezier4Path addCurveToPoint: CGPointMake(1.26, 81.05) controlPoint1: CGPointMake(0, 79.45) controlPoint2: CGPointMake(0.48, 80.55)];
    [bezier4Path addCurveToPoint: CGPointMake(21.53, 92.25) controlPoint1: CGPointMake(8.92, 85.85) controlPoint2: CGPointMake(14.65, 88.75)];
    [bezier4Path addCurveToPoint: CGPointMake(42, 100.15) controlPoint1: CGPointMake(26.77, 94.85) controlPoint2: CGPointMake(36.08, 100.15)];
    [bezier4Path addCurveToPoint: CGPointMake(60.72, 92.75) controlPoint1: CGPointMake(47.43, 100.15) controlPoint2: CGPointMake(56.07, 95.15)];
    [bezier4Path addCurveToPoint: CGPointMake(82.64, 81.05) controlPoint1: CGPointMake(68.19, 88.95) controlPoint2: CGPointMake(75.17, 84.75)];
    [bezier4Path addCurveToPoint: CGPointMake(83.9, 78.55) controlPoint1: CGPointMake(83.42, 80.65) controlPoint2: CGPointMake(83.9, 79.45)];
    [bezier4Path addCurveToPoint: CGPointMake(83.9, 10.55) controlPoint1: CGPointMake(83.9, 55.85) controlPoint2: CGPointMake(83.9, 33.25)];
    [bezier4Path addCurveToPoint: CGPointMake(90.31, 0.15) controlPoint1: CGPointMake(83.9, 3.65) controlPoint2: CGPointMake(90.31, 0.15)];
    [bezier4Path addLineToPoint: CGPointMake(14.94, 0.15)];
    [bezier4Path addLineToPoint: CGPointMake(14.94, 0.05)];
    [bezier4Path closePath];
    bezier4Path.miterLimit = 4;
    
    CGContextSaveGState(context);
    [bezier4Path addClip];
    CGContextDrawLinearGradient(context, sVGID_1_,
                                CGPointMake(46.53, -56.96),
                                CGPointMake(43.17, 88.4),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Group 6
    {
        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
        [bezier5Path moveToPoint: CGPointMake(42.9, 92.45)];
        [bezier5Path addCurveToPoint: CGPointMake(27.53, 86.75) controlPoint1: CGPointMake(38.42, 92.45) controlPoint2: CGPointMake(32.1, 89.15)];
        [bezier5Path addCurveToPoint: CGPointMake(25.58, 85.75) controlPoint1: CGPointMake(26.85, 86.35) controlPoint2: CGPointMake(26.16, 86.05)];
        [bezier5Path addCurveToPoint: CGPointMake(8.75, 76.45) controlPoint1: CGPointMake(19.84, 82.85) controlPoint2: CGPointMake(15.07, 80.45)];
        [bezier5Path addCurveToPoint: CGPointMake(7.09, 73.35) controlPoint1: CGPointMake(7.78, 75.85) controlPoint2: CGPointMake(7.09, 74.55)];
        [bezier5Path addLineToPoint: CGPointMake(7.09, 16.55)];
        [bezier5Path addLineToPoint: CGPointMake(6.9, 16.55)];
        [bezier5Path addLineToPoint: CGPointMake(7.39, 14.85)];
        [bezier5Path addLineToPoint: CGPointMake(8.36, 15.25)];
        [bezier5Path addLineToPoint: CGPointMake(8.36, 14.25)];
        [bezier5Path addLineToPoint: CGPointMake(9.92, 14.25)];
        [bezier5Path addLineToPoint: CGPointMake(9.43, 15.75)];
        [bezier5Path addCurveToPoint: CGPointMake(9.33, 16.15) controlPoint1: CGPointMake(9.33, 15.95) controlPoint2: CGPointMake(9.33, 16.05)];
        [bezier5Path addLineToPoint: CGPointMake(9.33, 73.45)];
        [bezier5Path addCurveToPoint: CGPointMake(9.92, 74.55) controlPoint1: CGPointMake(9.33, 73.85) controlPoint2: CGPointMake(9.62, 74.35)];
        [bezier5Path addCurveToPoint: CGPointMake(26.46, 83.65) controlPoint1: CGPointMake(16.14, 78.45) controlPoint2: CGPointMake(20.91, 80.85)];
        [bezier5Path addCurveToPoint: CGPointMake(28.6, 84.75) controlPoint1: CGPointMake(27.23, 84.05) controlPoint2: CGPointMake(27.82, 84.35)];
        [bezier5Path addCurveToPoint: CGPointMake(43.09, 90.15) controlPoint1: CGPointMake(32.78, 86.95) controlPoint2: CGPointMake(39.1, 90.15)];
        [bezier5Path addCurveToPoint: CGPointMake(56.23, 85.15) controlPoint1: CGPointMake(46.69, 90.15) controlPoint2: CGPointMake(52.43, 87.15)];
        [bezier5Path addCurveToPoint: CGPointMake(58.08, 84.15) controlPoint1: CGPointMake(56.91, 84.75) controlPoint2: CGPointMake(57.59, 84.45)];
        [bezier5Path addCurveToPoint: CGPointMake(67.12, 79.35) controlPoint1: CGPointMake(61.19, 82.55) controlPoint2: CGPointMake(64.21, 80.95)];
        [bezier5Path addCurveToPoint: CGPointMake(76.17, 74.45) controlPoint1: CGPointMake(70.04, 77.75) controlPoint2: CGPointMake(73.06, 76.05)];
        [bezier5Path addCurveToPoint: CGPointMake(76.66, 73.45) controlPoint1: CGPointMake(76.37, 74.35) controlPoint2: CGPointMake(76.66, 73.85)];
        [bezier5Path addLineToPoint: CGPointMake(76.66, 17.35)];
        [bezier5Path addLineToPoint: CGPointMake(78.8, 17.35)];
        [bezier5Path addLineToPoint: CGPointMake(78.8, 73.45)];
        [bezier5Path addCurveToPoint: CGPointMake(77.15, 76.55) controlPoint1: CGPointMake(78.8, 74.55) controlPoint2: CGPointMake(78.31, 75.95)];
        [bezier5Path addCurveToPoint: CGPointMake(68.1, 81.35) controlPoint1: CGPointMake(74.03, 78.05) controlPoint2: CGPointMake(71.02, 79.75)];
        [bezier5Path addCurveToPoint: CGPointMake(58.95, 86.25) controlPoint1: CGPointMake(65.18, 82.95) controlPoint2: CGPointMake(62.16, 84.65)];
        [bezier5Path addCurveToPoint: CGPointMake(57.1, 87.25) controlPoint1: CGPointMake(58.37, 86.55) controlPoint2: CGPointMake(57.78, 86.85)];
        [bezier5Path addCurveToPoint: CGPointMake(42.9, 92.45) controlPoint1: CGPointMake(52.73, 89.45) controlPoint2: CGPointMake(46.89, 92.45)];
        [bezier5Path closePath];
        bezier5Path.miterLimit = 4;
        
        CGContextSaveGState(context);
        [bezier5Path addClip];
        CGContextDrawLinearGradient(context, sVGID_2_,
                                    CGPointMake(43.46, 97.31),
                                    CGPointMake(42.71, 32.67),
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
    }
    
    
    //// Group 7
    {
        //// Label 2 Drawing
        CGRect label2Rect = CGRectMake(25.04, 9.96, 30, 80);
        NSMutableParagraphStyle* label2Style = [NSMutableParagraphStyle new];
        label2Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* label2FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Arial-BoldMT" size: 60], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: label2Style};
        
        [label drawInRect: label2Rect withAttributes: label2FontAttributes];
    }
    
    
    //// Bezier 6 Drawing
    UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
    [bezier6Path moveToPoint: CGPointMake(96.81, 11.35)];
    [bezier6Path addCurveToPoint: CGPointMake(88.85, 0.15) controlPoint1: CGPointMake(97.97, 7.45) controlPoint2: CGPointMake(93.6, -1.25)];
    [bezier6Path addCurveToPoint: CGPointMake(83.71, 11.35) controlPoint1: CGPointMake(88.85, 0.15) controlPoint2: CGPointMake(83.52, 3.65)];
    [bezier6Path addLineToPoint: CGPointMake(96.81, 11.35)];
    [bezier6Path closePath];
    bezier6Path.miterLimit = 4;
    
    [fillColor1 setFill];
    [bezier6Path fill];
    
    //// Cleanup
    CGGradientRelease(sVGID_1_);
    CGGradientRelease(sVGID_2_);
    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
