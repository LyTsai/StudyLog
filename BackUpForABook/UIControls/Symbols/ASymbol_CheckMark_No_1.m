//
//  ASymbol_CheckMark_No_1.m
//  AProgressBars
//
//  Created by hui wang on 8/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_CheckMark_No_1.h"

@interface ASymbol_CheckMark_No_1 (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbol_CheckMark_No_1

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(14, 14);
    
    _lineColor = [UIColor colorWithRed: 0.78 green: 0.129 blue: 0.157 alpha: 1];
    _lineWidth = 2;
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_CheckMark_No_1* draw = [[ASymbol_CheckMark_No_1 alloc] init];
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
    //// Group 4
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(0.44, 2.56)];
        [bezierPath addCurveToPoint: CGPointMake(10.44, 12.56) controlPoint1: CGPointMake(3.77, 5.9) controlPoint2: CGPointMake(7.11, 9.23)];
        [bezierPath addCurveToPoint: CGPointMake(12.56, 10.44) controlPoint1: CGPointMake(11.81, 13.93) controlPoint2: CGPointMake(13.93, 11.81)];
        [bezierPath addCurveToPoint: CGPointMake(2.56, 0.44) controlPoint1: CGPointMake(9.23, 7.11) controlPoint2: CGPointMake(5.9, 3.78)];
        [bezierPath addCurveToPoint: CGPointMake(0.44, 2.56) controlPoint1: CGPointMake(1.2, -0.93) controlPoint2: CGPointMake(-0.93, 1.2)];
        [bezierPath addLineToPoint: CGPointMake(0.44, 2.56)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [_lineColor setFill];
        [bezierPath fill];
    }
    
    //// Group 5
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(10.44, 0.44)];
        [bezier2Path addCurveToPoint: CGPointMake(0.44, 10.44) controlPoint1: CGPointMake(7.11, 3.77) controlPoint2: CGPointMake(3.77, 7.11)];
        [bezier2Path addCurveToPoint: CGPointMake(2.56, 12.56) controlPoint1: CGPointMake(-0.93, 11.81) controlPoint2: CGPointMake(1.2, 13.93)];
        [bezier2Path addCurveToPoint: CGPointMake(12.56, 2.56) controlPoint1: CGPointMake(5.9, 9.23) controlPoint2: CGPointMake(9.23, 5.9)];
        [bezier2Path addCurveToPoint: CGPointMake(10.44, 0.44) controlPoint1: CGPointMake(13.93, 1.2) controlPoint2: CGPointMake(11.81, -0.93)];
        [bezier2Path addLineToPoint: CGPointMake(10.44, 0.44)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [_lineColor setFill];
        [bezier2Path fill];
    }
}

@end
