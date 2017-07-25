//
//  ASymbolButterfly.m
//  AProgressBars
//
//  Created by hui wang on 8/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbolButterfly.h"

@interface ASymbolButterfly (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbolButterfly

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(18, 14);
    
    self.pathFillColor = [UIColor colorWithRed: 0 green: 0.651 blue: 0.318 alpha: 1];
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbolButterfly* draw = [[ASymbolButterfly alloc] init];
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

-(void) drawPath
{
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    
    [bezierPath moveToPoint: CGPointMake(12.34, 0.83)];
    [bezierPath addCurveToPoint: CGPointMake(11.08, 0.01) controlPoint1: CGPointMake(12.14, 0.12) controlPoint2: CGPointMake(11.57, -0.04)];
    [bezierPath addCurveToPoint: CGPointMake(9.69, 1.28) controlPoint1: CGPointMake(10.46, 0.06) controlPoint2: CGPointMake(9.98, 0.62)];
    [bezierPath addCurveToPoint: CGPointMake(9.12, 4.06) controlPoint1: CGPointMake(9.35, 2.07) controlPoint2: CGPointMake(9.21, 3.18)];
    [bezierPath addCurveToPoint: CGPointMake(8.99, 4.04) controlPoint1: CGPointMake(9.08, 4.05) controlPoint2: CGPointMake(9.04, 4.05)];
    [bezierPath addLineToPoint: CGPointMake(8.99, 4.04)];
    [bezierPath addLineToPoint: CGPointMake(8.99, 4.04)];
    [bezierPath addLineToPoint: CGPointMake(8.99, 4.04)];
    [bezierPath addLineToPoint: CGPointMake(8.99, 4.04)];
    [bezierPath addCurveToPoint: CGPointMake(8.86, 4.06) controlPoint1: CGPointMake(8.94, 4.05) controlPoint2: CGPointMake(8.9, 4.05)];
    [bezierPath addCurveToPoint: CGPointMake(8.29, 1.28) controlPoint1: CGPointMake(8.77, 3.18) controlPoint2: CGPointMake(8.64, 2.07)];
    [bezierPath addCurveToPoint: CGPointMake(6.9, 0.01) controlPoint1: CGPointMake(8, 0.62) controlPoint2: CGPointMake(7.52, 0.06)];
    [bezierPath addCurveToPoint: CGPointMake(5.64, 0.82) controlPoint1: CGPointMake(6.41, -0.04) controlPoint2: CGPointMake(5.84, 0.12)];
    [bezierPath addLineToPoint: CGPointMake(6.81, 0.12)];
    [bezierPath addCurveToPoint: CGPointMake(8.77, 4.1) controlPoint1: CGPointMake(8.39, 0.26) controlPoint2: CGPointMake(8.6, 2.62)];
    [bezierPath addCurveToPoint: CGPointMake(8.65, 4.5) controlPoint1: CGPointMake(8.63, 4.18) controlPoint2: CGPointMake(8.62, 4.35)];
    [bezierPath addCurveToPoint: CGPointMake(0, 1.44) controlPoint1: CGPointMake(7.28, 3.2) controlPoint2: CGPointMake(2.41, -1.07)];
    [bezierPath addCurveToPoint: CGPointMake(3.37, 8.21) controlPoint1: CGPointMake(0, 1.44) controlPoint2: CGPointMake(1.2, 9.3)];
    [bezierPath addCurveToPoint: CGPointMake(2.52, 10.08) controlPoint1: CGPointMake(5.31, 7.23) controlPoint2: CGPointMake(2.7, 8.78)];
    [bezierPath addCurveToPoint: CGPointMake(6.73, 12.96) controlPoint1: CGPointMake(2.34, 11.38) controlPoint2: CGPointMake(6.25, 13.3)];
    [bezierPath addCurveToPoint: CGPointMake(8.51, 8.87) controlPoint1: CGPointMake(7.21, 12.62) controlPoint2: CGPointMake(7.97, 10.69)];
    [bezierPath addCurveToPoint: CGPointMake(8.72, 10.74) controlPoint1: CGPointMake(8.46, 9.16) controlPoint2: CGPointMake(8.42, 10.23)];
    [bezierPath addLineToPoint: CGPointMake(8.98, 10.99)];
    [bezierPath addLineToPoint: CGPointMake(9.26, 10.74)];
    [bezierPath addCurveToPoint: CGPointMake(9.47, 8.87) controlPoint1: CGPointMake(9.56, 10.23) controlPoint2: CGPointMake(9.51, 9.16)];
    [bezierPath addCurveToPoint: CGPointMake(11.24, 12.96) controlPoint1: CGPointMake(10, 10.69) controlPoint2: CGPointMake(10.76, 12.61)];
    [bezierPath addCurveToPoint: CGPointMake(15.45, 10.08) controlPoint1: CGPointMake(11.71, 13.29) controlPoint2: CGPointMake(15.63, 11.38)];
    [bezierPath addCurveToPoint: CGPointMake(14.61, 8.21) controlPoint1: CGPointMake(15.27, 8.78) controlPoint2: CGPointMake(12.67, 7.23)];
    [bezierPath addCurveToPoint: CGPointMake(17.98, 1.44) controlPoint1: CGPointMake(16.77, 9.31) controlPoint2: CGPointMake(17.98, 1.44)];
    [bezierPath addCurveToPoint: CGPointMake(9.32, 4.5) controlPoint1: CGPointMake(15.57, -1.07) controlPoint2: CGPointMake(10.7, 3.2)];
    [bezierPath addCurveToPoint: CGPointMake(9.21, 4.1) controlPoint1: CGPointMake(9.36, 4.35) controlPoint2: CGPointMake(9.35, 4.18)];
    [bezierPath addCurveToPoint: CGPointMake(11.17, 0.12) controlPoint1: CGPointMake(9.38, 2.62) controlPoint2: CGPointMake(9.59, 0.26)];
    [bezierPath addLineToPoint: CGPointMake(12.34, 0.83)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [self.pathFillColor setFill];
    [bezierPath fill];
}

@end
