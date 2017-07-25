//
//  ALittleFace_1.m
//  AProgressBars
//
//  Created by hui wang on 8/16/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ALittleFace_1.h"

@interface ALittleFace_1 (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ALittleFace_1

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(100, 100);
    
    //fillColor = [UIColor colorWithRed: 0.231 green: 0.275 blue: 0.325 alpha: 1];
    //fillColor2 = [UIColor colorWithRed: 0.729 green: 0.125 blue: 0.192 alpha: 1];
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ALittleFace_1* draw = [[ALittleFace_1 alloc] init];
    [draw initDrawPros];
    
    APathDrawWrap* warp = [[APathDrawWrap alloc] initWith:CGRectMake(0, 0, draw.pathRefSize.x, draw.pathRefSize.y) pathDraw:draw];
    
    return warp;
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    [self drawPath];
    
    /*
     // test drawing
     UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
     CGContextSetLineWidth(ctx, 2.0);
     
     [rectanglePath fill];
     //[rectanglePath stroke];
     */
    
    UIGraphicsPopContext();
    CGContextRestoreGState(ctx);
}

// draw heart 1 image
-(void) drawPath
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* gradientColor = [UIColor colorWithRed: 0.616 green: 0.796 blue: 0.235 alpha: 1];
    UIColor* gradientColor2 = [UIColor colorWithRed: 0.447 green: 0.749 blue: 0.267 alpha: 1];
    UIColor* gradientColor3 = [UIColor colorWithRed: 0.314 green: 0.627 blue: 0.271 alpha: 1];
    UIColor* gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    UIColor* gradientColor5 = [UIColor colorWithRed: 0.004 green: 0.004 blue: 0.004 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.004 green: 0.004 blue: 0.004 alpha: 1];
    UIColor* fillColor = [UIColor colorWithRed: 0.004 green: 0.004 blue: 0.004 alpha: 1];
    
    //// Gradient Declarations
    CGFloat sVGID_1_Locations[] = {0, 0.52, 1};
    CGGradientRef sVGID_1_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor.CGColor, (id)gradientColor2.CGColor, (id)gradientColor3.CGColor], sVGID_1_Locations);
    CGFloat sVGID_2_Locations[] = {0.78, 0.93};
    CGGradientRef sVGID_2_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor4.CGColor, (id)gradientColor5.CGColor], sVGID_2_Locations);
    
    //// face-1.svg Group
    {
        //// Group 2
        {
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(8.6, 9.01, 90, 83)];
            CGContextSaveGState(context);
            [ovalPath addClip];
            CGContextDrawRadialGradient(context, sVGID_1_,
                                        CGPointMake(66.01, 35.22), 0,
                                        CGPointMake(66.01, 35.22), 62.77,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
            
            
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(8.6, 9.04, 90, 83)];
            CGContextSaveGState(context);
            [oval2Path addClip];
            CGContextDrawRadialGradient(context, sVGID_2_,
                                        CGPointMake(53.6, 49.53), 0,
                                        CGPointMake(53.6, 49.53), 48.97,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
        
        
        //// Group 9
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(31.1, 64.77)];
            [bezierPath addCurveToPoint: CGPointMake(54.1, 79.38) controlPoint1: CGPointMake(31.1, 64.77) controlPoint2: CGPointMake(35.61, 79.38)];
            [bezierPath addCurveToPoint: CGPointMake(77.1, 64.97) controlPoint1: CGPointMake(72.59, 79.38) controlPoint2: CGPointMake(77.1, 64.97)];
            bezierPath.miterLimit = 4;
            
            [strokeColor setStroke];
            bezierPath.lineWidth = 4;
            [bezierPath stroke];
            
            
            //// Group 10
            {
                //// Oval 3 Drawing
                UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(33.77, 34.05, 7.67, 19.33)];
                [fillColor setFill];
                [oval3Path fill];
                
                
                //// Oval 4 Drawing
                UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(66.77, 34.05, 7.67, 19.33)];
                [fillColor setFill];
                [oval4Path fill];
            }
        }
    }
    
    //// Cleanup
    CGGradientRelease(sVGID_1_);
    CGGradientRelease(sVGID_2_);
    CGColorSpaceRelease(colorSpace);
}

@end
