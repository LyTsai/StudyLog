//
//  ASymbol_Face1.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 8/30/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Face1.h"

@implementation ASymbol_Face1

@synthesize gradientColor1, gradientColor2, gradientColor3, gradientColor4, gradientColor5, strokeColor1, fillColor1;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(437, 465);
    
    gradientColor1 = [UIColor colorWithRed: 0.545 green: 0.973 blue: 0.278 alpha: 1];
    gradientColor2 = [UIColor colorWithRed: 0.424 green: 0.792 blue: 0.133 alpha: 1];
    gradientColor3 = [UIColor colorWithRed: 0.31 green: 0.624 blue: 0 alpha: 1];
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
    CGFloat sVGID_1_Locations[] = {0, 0.52, 1};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor1.CGColor, (id)gradientColor2.CGColor, (id)gradientColor3.CGColor], sVGID_1_Locations);
    CGFloat sVGID_4_Locations[] = {0.78, 0.93};
    CGGradientRef sVGID_4_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor4.CGColor, (id)gradientColor5.CGColor], sVGID_4_Locations);
    
    //// Image Declarations
    UIImage* image = [UIImage imageNamed: @"image1_1.png"];
    UIImage* image2 = [UIImage imageNamed: @"image1_2.png"];
    UIImage* image3 = [UIImage imageNamed: @"image1_3.png"];
    UIImage* image4 = [UIImage imageNamed: @"image1_4.png"];
    UIImage* image5 = [UIImage imageNamed: @"image1_5.png"];
    UIImage* image6 = [UIImage imageNamed: @"image1_6.png"];

    //// Group 3
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(37.34, 36.63, 400, 400)];
        CGContextSaveGState(context);
        [ovalPath addClip];
        CGContextDrawRadialGradient(context, sVGID_1_,
                                    CGPointMake(294.67, 165.97), 0,
                                    CGPointMake(294.67, 165.97), 290.01,
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
                    
                    //// Clip Oval 2
                    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(37.35, 36.65, 400, 400)];
                    [oval2Path addClip];
                    
                    
                    //// Rectangle Drawing
                    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(-3.57, -4.05, 293, 481)];
                    CGContextSaveGState(context);
                    [rectanglePath addClip];
                    CGContextScaleCTM(context, 1.0, -1.0);
                    CGContextDrawTiledImage(context, CGRectMake(-4, 4, image.size.width, image.size.height), image.CGImage);
                    CGContextRestoreGState(context);
                    
                    
                    CGContextEndTransparencyLayer(context);
                    CGContextRestoreGState(context);
                }
            }
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(37.34, 36.63, 400, 400)];
        CGContextSaveGState(context);
        [oval3Path addClip];
        CGContextDrawRadialGradient(context, sVGID_4_,
                                    CGPointMake(237.34, 231.97), 0,
                                    CGPointMake(237.34, 231.97), 226.26,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        
        //// Group 7
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.16);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 2 Drawing
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(68.43, 27.95, 349, 437)];
            CGContextSaveGState(context);
            [rectangle2Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(68, -28, image2.size.width, image2.size.height), image2.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 8
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.17);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 3 Drawing
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(129.43, 9.95, 266, 223)];
            CGContextSaveGState(context);
            [rectangle3Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(129, -10, image3.size.width, image3.size.height), image3.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 9
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.74);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 4 Drawing
            UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(233.43, 49.95, 193, 186)];
            CGContextSaveGState(context);
            [rectangle4Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(233, -50, image4.size.width, image4.size.height), image4.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 10
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.43);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 5 Drawing
            UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRect: CGRectMake(12.43, 11.95, 214, 430)];
            CGContextSaveGState(context);
            [rectangle5Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(12, -12, image5.size.width, image5.size.height), image5.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 11
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.79);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// Rectangle 6 Drawing
            UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRect: CGRectMake(0.43, -0.05, 272, 465)];
            CGContextSaveGState(context);
            [rectangle6Path addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(0, 0, image6.size.width, image6.size.height), image6.CGImage);
            CGContextRestoreGState(context);
            
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }
    }
    
    
    //// Oval 4 Drawing
    
    
    //// Group 12
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(135.34, 304.71)];
        [bezierPath addCurveToPoint: CGPointMake(237.34, 376.71) controlPoint1: CGPointMake(135.34, 304.71) controlPoint2: CGPointMake(155.34, 376.71)];
        [bezierPath addCurveToPoint: CGPointMake(339.34, 305.71) controlPoint1: CGPointMake(319.34, 376.71) controlPoint2: CGPointMake(339.34, 305.71)];
        bezierPath.miterLimit = 4;
        
        [strokeColor1 setStroke];
        bezierPath.lineWidth = 10;
        [bezierPath stroke];
        
        
        //// Group 13
        {
            //// Oval 5 Drawing
            UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(149, 153.38, 32.67, 93.33)];
            [fillColor1 setFill];
            [oval5Path fill];
            
            
            //// Oval 6 Drawing
            UIBezierPath* oval6Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(293, 153.38, 32.67, 93.33)];
            [fillColor1 setFill];
            [oval6Path fill];
        }
    }
    
    //// Cleanup
    CGGradientRelease(sVGID_1_);
    CGGradientRelease(sVGID_4_);
    CGColorSpaceRelease(colorSpace);

    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
