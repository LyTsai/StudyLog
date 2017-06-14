//
//  ASymbol_CheckMark_Yes_1.m
//  AProgressBars
//
//  Created by hui wang on 8/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_CheckMark_Yes_1.h"

@interface ASymbol_CheckMark_Yes_1 (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbol_CheckMark_Yes_1

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(14, 14);
    
    _lineColor = [UIColor colorWithRed: 0.42 green: 0.745 blue: 0.275 alpha: 1];
    _lineWidth = 2;
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_CheckMark_Yes_1* draw = [[ASymbol_CheckMark_Yes_1 alloc] init];
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
    [bezierPath moveToPoint: CGPointMake(0.32, 8.49)];
    [bezierPath addCurveToPoint: CGPointMake(3.76, 13.59) controlPoint1: CGPointMake(1.47, 10.19) controlPoint2: CGPointMake(2.62, 11.89)];
    [bezierPath addCurveToPoint: CGPointMake(5.74, 13.59) controlPoint1: CGPointMake(4.2, 14.24) controlPoint2: CGPointMake(5.3, 14.2)];
    [bezierPath addCurveToPoint: CGPointMake(13.52, 2.83) controlPoint1: CGPointMake(8.34, 10) controlPoint2: CGPointMake(10.93, 6.41)];
    [bezierPath addCurveToPoint: CGPointMake(11.55, 0.54) controlPoint1: CGPointMake(14.67, 1.24) controlPoint2: CGPointMake(12.7, -1.06)];
    [bezierPath addCurveToPoint: CGPointMake(3.76, 11.31) controlPoint1: CGPointMake(8.95, 4.13) controlPoint2: CGPointMake(6.36, 7.72)];
    [bezierPath addCurveToPoint: CGPointMake(5.74, 11.31) controlPoint1: CGPointMake(4.42, 11.31) controlPoint2: CGPointMake(5.08, 11.31)];
    [bezierPath addCurveToPoint: CGPointMake(2.3, 6.2) controlPoint1: CGPointMake(4.59, 9.61) controlPoint2: CGPointMake(3.45, 7.9)];
    [bezierPath addCurveToPoint: CGPointMake(0.32, 8.49) controlPoint1: CGPointMake(1.19, 4.56) controlPoint2: CGPointMake(-0.77, 6.86)];
    [bezierPath addLineToPoint: CGPointMake(0.32, 8.49)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [_lineColor setFill];
    [bezierPath fill];
}

@end
