//
//  ASymbol_Face2.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 8/30/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Face2.h"

@implementation ASymbol_Face2

@synthesize gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5, strokeColor1, fillColor1;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(455, 465);
    
    gradientColor1 = [UIColor colorWithRed: 0.957 green: 0.855 blue: 0.22 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.871 green: 0.757 blue: 0.137 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.71 green: 0.58 blue: 0 alpha: 1];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    gradientColor5 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    strokeColor1 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    fillColor1 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
}

- (void)drawInContext:(CGContextRef)context
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    //// Gradient Declarations
    CGFloat sVGID_1_Locations[] = {0, 0.43, 0.91};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor1.CGColor, (id)gradientColor2.CGColor, (id)gradientColor3.CGColor], sVGID_1_Locations);
    CGFloat sVGID_3_Locations[] = {0.78, 0.93};
    CGGradientRef sVGID_3_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor4.CGColor, (id)gradientColor5.CGColor], sVGID_3_Locations);
    
    //// Image Declarations
    UIImage* image = [UIImage imageNamed: @"image2_1.png"];
    UIImage* image2 = [UIImage imageNamed: @"image2_2.png"];
    UIImage* image3 = [UIImage imageNamed: @"image2_3.png"];
    UIImage* image4 = [UIImage imageNamed: @"image2_4.png"];
    UIImage* image5 = [UIImage imageNamed: @"image2_5.png"];
    UIImage* image6 = [UIImage imageNamed: @"image2_6.png"];
    UIImage* image7 = [UIImage imageNamed: @"image2_7.png"];
    UIImage* image8 = [UIImage imageNamed: @"image2_8.png"];

    //// Group 3
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(36.97, 35.81, 400, 400)];
        CGContextSaveGState(context);
        [ovalPath addClip];
        CGContextDrawRadialGradient(context, sVGID_1_,
                                    CGPointMake(294.31, 165.15), 0,
                                    CGPointMake(294.31, 165.15), 290.01,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        
        //// Group 4
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.8);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Group 5
            {
                //// Group 6
                {
                    CGContextSaveGState(context);
                    CGContextBeginTransparencyLayer(context, NULL);
                    
                    //// Clip Bezier
                    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
                    [bezierPath moveToPoint: CGPointMake(378.4, 94.39)];
                    [bezierPath addCurveToPoint: CGPointMake(378.4, 377.23) controlPoint1: CGPointMake(456.5, 172.5) controlPoint2: CGPointMake(456.5, 299.13)];
                    [bezierPath addCurveToPoint: CGPointMake(95.55, 377.23) controlPoint1: CGPointMake(300.29, 455.34) controlPoint2: CGPointMake(173.66, 455.34)];
                    [bezierPath addCurveToPoint: CGPointMake(95.55, 94.39) controlPoint1: CGPointMake(17.45, 299.13) controlPoint2: CGPointMake(17.45, 172.5)];
                    [bezierPath addCurveToPoint: CGPointMake(378.4, 94.39) controlPoint1: CGPointMake(173.66, 16.29) controlPoint2: CGPointMake(300.29, 16.29)];
                    [bezierPath closePath];
                    bezierPath.miterLimit = 0;
                    
                    [bezierPath addClip];
                    
                    
                    //// Rectangle Drawing
                    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(-4.57, -4.05, 294, 480)];
                    CGContextSaveGState(context);
                    [rectanglePath addClip];
                    CGContextScaleCTM(context, 1.0, -1.0);
                    CGContextDrawTiledImage(context, CGRectMake(-5, 4, image.size.width, image.size.height), image.CGImage);
                    CGContextRestoreGState(context);
                    
                    
                    CGContextEndTransparencyLayer(context);
                    CGContextRestoreGState(context);
                }
            }
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 7
        {
            //// Rectangle 2 Drawing
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(9.43, 8.95, 213, 430)];
            CGContextSaveGState(context);
            [rectangle2Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(9, -9, image2.size.width, image2.size.height), image2.CGImage);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 8
        {
            //// Rectangle 3 Drawing
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(0.43, -0.05, 271, 465)];
            CGContextSaveGState(context);
            [rectangle3Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(0, 0, image3.size.width, image3.size.height), image3.CGImage);
            CGContextRestoreGState(context);
        }
        
        
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(35.47, 35.81, 400, 400)];
        CGContextSaveGState(context);
        [oval2Path addClip];
        CGContextDrawRadialGradient(context, sVGID_3_,
                                    CGPointMake(235.47, 231.15), 0,
                                    CGPointMake(235.47, 231.15), 226.26,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        
        //// Group 9
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.16);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 4 Drawing
            UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(58.43, 5.95, 349, 328)];
            CGContextSaveGState(context);
            [rectangle4Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(58, -6, image4.size.width, image4.size.height), image4.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 10
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.17);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 5 Drawing
            UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRect: CGRectMake(176.43, 37.95, 266, 223)];
            CGContextSaveGState(context);
            [rectangle5Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(176, -38, image5.size.width, image5.size.height), image5.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 11
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.81);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 6 Drawing
            UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRect: CGRectMake(169.43, 12.95, 286, 253)];
            CGContextSaveGState(context);
            [rectangle6Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(169, -13, image6.size.width, image6.size.height), image6.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 12
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.3);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 7 Drawing
            UIBezierPath* rectangle7Path = [UIBezierPath bezierPathWithRect: CGRectMake(197.43, 33.95, 241, 232)];
            CGContextSaveGState(context);
            [rectangle7Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(197, -34, image7.size.width, image7.size.height), image7.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 13
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.47);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 8 Drawing
            UIBezierPath* rectangle8Path = [UIBezierPath bezierPathWithRect: CGRectMake(230.43, 53.95, 178, 172)];
            CGContextSaveGState(context);
            [rectangle8Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(230, -54, image8.size.width, image8.size.height), image8.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Oval 3 Drawing
    
    
    //// Group 14
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(189.74, 356.69)];
        [bezier2Path addLineToPoint: CGPointMake(279.73, 356.69)];
        bezier2Path.miterLimit = 4;
        
        [strokeColor1 setStroke];
        bezier2Path.lineWidth = 10;
        [bezier2Path stroke];
        
        
        //// Group 15
        {
            //// Oval 4 Drawing
            UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(147, 153.4, 32.67, 93.33)];
            [fillColor1 setFill];
            [oval4Path fill];
            
            
            //// Oval 5 Drawing
            UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(291, 153.4, 32.67, 93.33)];
            [fillColor1 setFill];
            [oval5Path fill];
        }
    }

    /// Cleanup
    CGGradientRelease(sVGID_1_);
    CGGradientRelease(sVGID_3_);
    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
