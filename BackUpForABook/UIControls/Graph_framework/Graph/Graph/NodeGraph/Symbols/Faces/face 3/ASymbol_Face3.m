//
//  ASymbol_Face3.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 8/30/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Face3.h"

@implementation ASymbol_Face3

@synthesize gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5, strokeColor1, fillColor1;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(526, 552);
    
    gradientColor1 = [UIColor colorWithRed: 1 green: 0.847 blue: 0.29 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.969 green: 0.686 blue: 0.024 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.784 green: 0.455 blue: 0.004 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    gradientColor5 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    fillColor1 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    strokeColor1 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
}

- (void)drawInContext:(CGContextRef)context
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    CGFloat sVGID_1_Locations[] = {0, 0.34, 0.8};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor1.CGColor, (id)gradientColor2.CGColor, (id)gradientColor3.CGColor], sVGID_1_Locations);
    CGFloat sVGID_2_Locations[] = {0.78, 0.93};
    CGGradientRef sVGID_2_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor4.CGColor, (id)gradientColor5.CGColor], sVGID_2_Locations);
    
    //// Image Declarations
    UIImage* image = [UIImage imageNamed: @"image3_1.png"];
    UIImage* image2 = [UIImage imageNamed: @"image3_2.png"];
    UIImage* image3 = [UIImage imageNamed: @"image3_3.png"];
    UIImage* image4 = [UIImage imageNamed: @"image3_4.png"];
    UIImage* image5 = [UIImage imageNamed: @"image3_5.png"];
    UIImage* image6 = [UIImage imageNamed: @"image3_6.png"];
    UIImage* image7 = [UIImage imageNamed: @"image3_7.png"];
    UIImage* image8 = [UIImage imageNamed: @"image3_8.png"];
    UIImage* image9 = [UIImage imageNamed: @"image3_9.png"];

    //// Group 3
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(88.1, 76.31, 400, 400)];
        CGContextSaveGState(context);
        [ovalPath addClip];
        CGContextDrawRadialGradient(context, sVGID_1_,
                                    CGPointMake(345.43, 205.65), 0,
                                    CGPointMake(345.43, 205.65), 290.01,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        
        //// Group 4
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.17);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle Drawing
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(209.43, 59.95, 266, 223)];
            CGContextSaveGState(context);
            [rectanglePath addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(209, -60, image.size.width, image.size.height), image.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 5
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.32);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 2 Drawing
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(96.43, 53.95, 394, 438)];
            CGContextSaveGState(context);
            [rectangle2Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(96, -54, image2.size.width, image2.size.height), image2.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 6
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.66);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 3 Drawing
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(193.43, 54.95, 315, 305)];
            CGContextSaveGState(context);
            [rectangle3Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(193, -55, image3.size.width, image3.size.height), image3.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 7
        {
            //// Rectangle 4 Drawing
            UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(0.43, -0.05, 526, 552)];
            CGContextSaveGState(context);
            [rectangle4Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(0, 0, image4.size.width, image4.size.height), image4.CGImage);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 8
        {
            //// Rectangle 5 Drawing
            UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRect: CGRectMake(59.43, 49.95, 213, 432)];
            CGContextSaveGState(context);
            [rectangle5Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(59, -50, image5.size.width, image5.size.height), image5.CGImage);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 9
        {
            //// Rectangle 6 Drawing
            UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRect: CGRectMake(52.43, 41.95, 272, 464)];
            CGContextSaveGState(context);
            [rectangle6Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(52, -42, image6.size.width, image6.size.height), image6.CGImage);
            CGContextRestoreGState(context);
        }
        
        
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(87.6, 77.31, 400, 400)];
        CGContextSaveGState(context);
        [oval2Path addClip];
        CGContextDrawRadialGradient(context, sVGID_2_,
                                    CGPointMake(287.6, 272.64), 0,
                                    CGPointMake(287.6, 272.64), 226.26,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        
        //// Group 10
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.3);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 7 Drawing
            UIBezierPath* rectangle7Path = [UIBezierPath bezierPathWithRect: CGRectMake(225.43, 57.95, 287, 252)];
            CGContextSaveGState(context);
            [rectangle7Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(225, -58, image7.size.width, image7.size.height), image7.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 11
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.34);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 8 Drawing
            UIBezierPath* rectangle8Path = [UIBezierPath bezierPathWithRect: CGRectMake(247.43, 59.95, 253, 242)];
            CGContextSaveGState(context);
            [rectangle8Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(247, -60, image8.size.width, image8.size.height), image8.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 12
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.67);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 9 Drawing
            UIBezierPath* rectangle9Path = [UIBezierPath bezierPathWithRect: CGRectMake(271.43, 85.95, 183, 177)];
            CGContextSaveGState(context);
            [rectangle9Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(271, -86, image9.size.width, image9.size.height), image9.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Oval 3 Drawing
    
    
    //// Group 13
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(205.39, 267.5)];
        [bezierPath addCurveToPoint: CGPointMake(220.91, 315.3) controlPoint1: CGPointMake(205.39, 293.9) controlPoint2: CGPointMake(212.34, 315.3)];
        [bezierPath addCurveToPoint: CGPointMake(236.43, 267.5) controlPoint1: CGPointMake(229.49, 315.3) controlPoint2: CGPointMake(236.43, 293.9)];
        [bezierPath addCurveToPoint: CGPointMake(235.67, 252.76) controlPoint1: CGPointMake(236.43, 262.36) controlPoint2: CGPointMake(236.17, 257.41)];
        [bezierPath addLineToPoint: CGPointMake(206.15, 252.76)];
        [bezierPath addCurveToPoint: CGPointMake(205.39, 267.5) controlPoint1: CGPointMake(205.66, 257.41) controlPoint2: CGPointMake(205.39, 262.36)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezierPath fill];
        
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(338.24, 267.5)];
        [bezier2Path addCurveToPoint: CGPointMake(353.76, 315.3) controlPoint1: CGPointMake(338.24, 293.9) controlPoint2: CGPointMake(345.19, 315.3)];
        [bezier2Path addCurveToPoint: CGPointMake(369.29, 267.5) controlPoint1: CGPointMake(362.34, 315.3) controlPoint2: CGPointMake(369.29, 293.9)];
        [bezier2Path addCurveToPoint: CGPointMake(368.53, 252.76) controlPoint1: CGPointMake(369.29, 262.36) controlPoint2: CGPointMake(369.01, 257.41)];
        [bezier2Path addLineToPoint: CGPointMake(339, 252.76)];
        [bezier2Path addCurveToPoint: CGPointMake(338.24, 267.5) controlPoint1: CGPointMake(338.51, 257.41) controlPoint2: CGPointMake(338.24, 262.36)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor1 setFill];
        [bezier2Path fill];
    }
    
    
    //// Oval 4 Drawing
    UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(267.15, 388.95, 40.4, 40.4)];
    [strokeColor1 setStroke];
    oval4Path.lineWidth = 10;
    [oval4Path stroke];
    
    //// Cleanup
    CGGradientRelease(sVGID_1_);
    CGGradientRelease(sVGID_2_);
    CGColorSpaceRelease(colorSpace);

    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
