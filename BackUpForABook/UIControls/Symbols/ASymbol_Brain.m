//
//  ASymbol_Brain.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Brain.h"

@interface ASymbol_Brain (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbol_Brain

@synthesize fillColor, fillColor2;

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(23, 18);
    
    fillColor = [UIColor colorWithRed: 0.6 green: 0.396 blue: 0.376 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 0.965 green: 0.859 blue: 0.773 alpha: 1];
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_Brain* draw = [[ASymbol_Brain alloc] init];
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
    //// Group 2
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(5.82, 2.4)];
        [bezierPath addCurveToPoint: CGPointMake(6.22, 1.6) controlPoint1: CGPointMake(5.82, 2.4) controlPoint2: CGPointMake(5.62, 1.9)];
        [bezierPath addCurveToPoint: CGPointMake(7.82, 1.5) controlPoint1: CGPointMake(6.72, 1.3) controlPoint2: CGPointMake(7.52, 1.5)];
        [bezierPath addCurveToPoint: CGPointMake(9.52, 0.7) controlPoint1: CGPointMake(7.82, 1.5) controlPoint2: CGPointMake(8.32, 0.6)];
        [bezierPath addCurveToPoint: CGPointMake(11.62, 0.7) controlPoint1: CGPointMake(9.52, 0.7) controlPoint2: CGPointMake(10.52, 0.1)];
        [bezierPath addCurveToPoint: CGPointMake(13.22, 0.3) controlPoint1: CGPointMake(11.62, 0.7) controlPoint2: CGPointMake(12.32, 0.2)];
        [bezierPath addCurveToPoint: CGPointMake(15.22, 1) controlPoint1: CGPointMake(14.12, 0.4) controlPoint2: CGPointMake(14.82, 0.7)];
        [bezierPath addCurveToPoint: CGPointMake(17.82, 2.3) controlPoint1: CGPointMake(15.22, 1) controlPoint2: CGPointMake(17.22, 0.4)];
        [bezierPath addCurveToPoint: CGPointMake(18.52, 2.5) controlPoint1: CGPointMake(17.82, 2.3) controlPoint2: CGPointMake(18.22, 2.4)];
        [bezierPath addCurveToPoint: CGPointMake(19.72, 4) controlPoint1: CGPointMake(19.22, 2.7) controlPoint2: CGPointMake(19.92, 2.9)];
        [bezierPath addCurveToPoint: CGPointMake(20.52, 5) controlPoint1: CGPointMake(19.72, 4) controlPoint2: CGPointMake(20.62, 4.1)];
        [bezierPath addCurveToPoint: CGPointMake(22.02, 6.5) controlPoint1: CGPointMake(20.52, 5) controlPoint2: CGPointMake(22.32, 4.8)];
        [bezierPath addCurveToPoint: CGPointMake(22.82, 7.9) controlPoint1: CGPointMake(22.02, 6.5) controlPoint2: CGPointMake(22.82, 6.6)];
        [bezierPath addCurveToPoint: CGPointMake(22.42, 9.4) controlPoint1: CGPointMake(22.82, 9.2) controlPoint2: CGPointMake(22.52, 9.3)];
        [bezierPath addCurveToPoint: CGPointMake(22.52, 11.5) controlPoint1: CGPointMake(22.42, 9.4) controlPoint2: CGPointMake(22.82, 10.7)];
        [bezierPath addCurveToPoint: CGPointMake(20.72, 13.3) controlPoint1: CGPointMake(22.22, 12.3) controlPoint2: CGPointMake(21.62, 12.8)];
        [bezierPath addCurveToPoint: CGPointMake(19.62, 14.7) controlPoint1: CGPointMake(19.82, 13.8) controlPoint2: CGPointMake(20.02, 14.1)];
        [bezierPath addCurveToPoint: CGPointMake(18.82, 15.5) controlPoint1: CGPointMake(19.42, 15) controlPoint2: CGPointMake(19.12, 15.2)];
        [bezierPath addCurveToPoint: CGPointMake(16.72, 16) controlPoint1: CGPointMake(18.42, 15.8) controlPoint2: CGPointMake(17.82, 16.2)];
        [bezierPath addCurveToPoint: CGPointMake(15.62, 15.6) controlPoint1: CGPointMake(16.12, 15.9) controlPoint2: CGPointMake(15.62, 15.6)];
        [bezierPath addCurveToPoint: CGPointMake(12.82, 17.2) controlPoint1: CGPointMake(15.62, 15.6) controlPoint2: CGPointMake(15.52, 17.4)];
        [bezierPath addCurveToPoint: CGPointMake(10.72, 16.5) controlPoint1: CGPointMake(12.32, 17.2) controlPoint2: CGPointMake(11.22, 17.1)];
        [bezierPath addCurveToPoint: CGPointMake(7.92, 15.4) controlPoint1: CGPointMake(10.72, 16.5) controlPoint2: CGPointMake(8.92, 17.1)];
        [bezierPath addCurveToPoint: CGPointMake(4.22, 13.7) controlPoint1: CGPointMake(7.92, 15.4) controlPoint2: CGPointMake(4.72, 16.2)];
        [bezierPath addCurveToPoint: CGPointMake(1.72, 13.2) controlPoint1: CGPointMake(4.22, 13.7) controlPoint2: CGPointMake(2.82, 14.7)];
        [bezierPath addCurveToPoint: CGPointMake(1.42, 11.7) controlPoint1: CGPointMake(1.52, 13) controlPoint2: CGPointMake(1.32, 12.2)];
        [bezierPath addCurveToPoint: CGPointMake(0.32, 9.9) controlPoint1: CGPointMake(1.42, 11.7) controlPoint2: CGPointMake(0.42, 11.2)];
        [bezierPath addCurveToPoint: CGPointMake(1.32, 7.4) controlPoint1: CGPointMake(0.22, 8.6) controlPoint2: CGPointMake(0.92, 8)];
        [bezierPath addCurveToPoint: CGPointMake(1.32, 5.4) controlPoint1: CGPointMake(1.42, 7.2) controlPoint2: CGPointMake(1.02, 6.2)];
        [bezierPath addCurveToPoint: CGPointMake(2.72, 4.3) controlPoint1: CGPointMake(1.62, 4.6) controlPoint2: CGPointMake(2.42, 4.7)];
        [bezierPath addCurveToPoint: CGPointMake(4.02, 2.2) controlPoint1: CGPointMake(3.12, 3.9) controlPoint2: CGPointMake(3.32, 2.8)];
        [bezierPath addCurveToPoint: CGPointMake(5.82, 2.4) controlPoint1: CGPointMake(4.72, 1.8) controlPoint2: CGPointMake(5.72, 2.2)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor setFill];
        [bezierPath fill];
    }
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(1.42, 7.9)];
    [bezier2Path addCurveToPoint: CGPointMake(3.22, 9.3) controlPoint1: CGPointMake(1.42, 7.9) controlPoint2: CGPointMake(1.52, 9.3)];
    [bezier2Path addCurveToPoint: CGPointMake(3.92, 11.2) controlPoint1: CGPointMake(3.22, 9.3) controlPoint2: CGPointMake(4.02, 10.5)];
    [bezier2Path addCurveToPoint: CGPointMake(3.52, 12.3) controlPoint1: CGPointMake(3.82, 11.9) controlPoint2: CGPointMake(3.82, 12)];
    [bezier2Path addCurveToPoint: CGPointMake(4.22, 11.4) controlPoint1: CGPointMake(3.52, 12.3) controlPoint2: CGPointMake(4.22, 12.2)];
    [bezier2Path addCurveToPoint: CGPointMake(3.32, 8.8) controlPoint1: CGPointMake(4.32, 10.6) controlPoint2: CGPointMake(3.52, 9.5)];
    [bezier2Path addCurveToPoint: CGPointMake(4.12, 6.9) controlPoint1: CGPointMake(3.12, 8.1) controlPoint2: CGPointMake(3.12, 7.1)];
    [bezier2Path addCurveToPoint: CGPointMake(4.62, 7.1) controlPoint1: CGPointMake(4.32, 6.9) controlPoint2: CGPointMake(4.62, 6.9)];
    [bezier2Path addCurveToPoint: CGPointMake(4.52, 7.6) controlPoint1: CGPointMake(4.62, 7.2) controlPoint2: CGPointMake(4.82, 7.5)];
    [bezier2Path addCurveToPoint: CGPointMake(3.82, 7.9) controlPoint1: CGPointMake(4.22, 7.6) controlPoint2: CGPointMake(4.02, 7.7)];
    [bezier2Path addCurveToPoint: CGPointMake(4.82, 7.9) controlPoint1: CGPointMake(3.82, 7.9) controlPoint2: CGPointMake(4.62, 7.8)];
    [bezier2Path addCurveToPoint: CGPointMake(4.92, 7.4) controlPoint1: CGPointMake(5.02, 7.9) controlPoint2: CGPointMake(5.02, 7.8)];
    [bezier2Path addCurveToPoint: CGPointMake(5.62, 4.1) controlPoint1: CGPointMake(4.82, 7) controlPoint2: CGPointMake(4.42, 5.1)];
    [bezier2Path addCurveToPoint: CGPointMake(8.12, 4.9) controlPoint1: CGPointMake(6.82, 3.2) controlPoint2: CGPointMake(8.12, 4.5)];
    [bezier2Path addCurveToPoint: CGPointMake(7.62, 7.6) controlPoint1: CGPointMake(8.12, 5.3) controlPoint2: CGPointMake(8.22, 6.7)];
    [bezier2Path addCurveToPoint: CGPointMake(8.12, 7.3) controlPoint1: CGPointMake(7.62, 7.6) controlPoint2: CGPointMake(7.92, 7.8)];
    [bezier2Path addCurveToPoint: CGPointMake(8.42, 4.1) controlPoint1: CGPointMake(8.32, 6.8) controlPoint2: CGPointMake(8.42, 6.2)];
    [bezier2Path addCurveToPoint: CGPointMake(11.12, 2.3) controlPoint1: CGPointMake(8.42, 2) controlPoint2: CGPointMake(10.22, 2.2)];
    [bezier2Path addCurveToPoint: CGPointMake(12.82, 3.8) controlPoint1: CGPointMake(11.92, 2.4) controlPoint2: CGPointMake(13.12, 2.9)];
    [bezier2Path addCurveToPoint: CGPointMake(11.82, 8.5) controlPoint1: CGPointMake(12.62, 4.7) controlPoint2: CGPointMake(11.42, 6.3)];
    [bezier2Path addCurveToPoint: CGPointMake(12.52, 5.4) controlPoint1: CGPointMake(11.82, 8.5) controlPoint2: CGPointMake(11.72, 6.8)];
    [bezier2Path addCurveToPoint: CGPointMake(15.62, 3) controlPoint1: CGPointMake(13.22, 4) controlPoint2: CGPointMake(13.62, 2.4)];
    [bezier2Path addCurveToPoint: CGPointMake(17.02, 5.3) controlPoint1: CGPointMake(17.62, 3.6) controlPoint2: CGPointMake(17.12, 4.6)];
    [bezier2Path addCurveToPoint: CGPointMake(17.02, 7.5) controlPoint1: CGPointMake(16.92, 6.1) controlPoint2: CGPointMake(16.62, 6.4)];
    [bezier2Path addCurveToPoint: CGPointMake(16.92, 8.5) controlPoint1: CGPointMake(17.22, 8.1) controlPoint2: CGPointMake(17.02, 8.4)];
    [bezier2Path addCurveToPoint: CGPointMake(17.32, 7.7) controlPoint1: CGPointMake(16.92, 8.5) controlPoint2: CGPointMake(17.52, 8.4)];
    [bezier2Path addCurveToPoint: CGPointMake(17.32, 5.4) controlPoint1: CGPointMake(17.12, 7) controlPoint2: CGPointMake(17.02, 6.4)];
    [bezier2Path addCurveToPoint: CGPointMake(19.42, 6.4) controlPoint1: CGPointMake(17.32, 5.4) controlPoint2: CGPointMake(18.42, 5.1)];
    [bezier2Path addCurveToPoint: CGPointMake(20.12, 10) controlPoint1: CGPointMake(20.42, 7.7) controlPoint2: CGPointMake(20.22, 9.5)];
    [bezier2Path addCurveToPoint: CGPointMake(20.72, 8.6) controlPoint1: CGPointMake(20.12, 10) controlPoint2: CGPointMake(20.62, 9.1)];
    [bezier2Path addCurveToPoint: CGPointMake(21.62, 8.9) controlPoint1: CGPointMake(20.92, 8.2) controlPoint2: CGPointMake(21.42, 8.3)];
    [bezier2Path addCurveToPoint: CGPointMake(22.12, 11.8) controlPoint1: CGPointMake(21.82, 9.6) controlPoint2: CGPointMake(22.42, 10.9)];
    [bezier2Path addCurveToPoint: CGPointMake(19.92, 13.7) controlPoint1: CGPointMake(21.82, 12.7) controlPoint2: CGPointMake(20.42, 13.2)];
    [bezier2Path addCurveToPoint: CGPointMake(18.32, 15.7) controlPoint1: CGPointMake(19.42, 14.2) controlPoint2: CGPointMake(19.32, 15.2)];
    [bezier2Path addCurveToPoint: CGPointMake(16.92, 16.2) controlPoint1: CGPointMake(18.32, 15.7) controlPoint2: CGPointMake(17.02, 16.6)];
    [bezier2Path addCurveToPoint: CGPointMake(15.62, 15.5) controlPoint1: CGPointMake(16.82, 15.9) controlPoint2: CGPointMake(16.32, 16)];
    [bezier2Path addCurveToPoint: CGPointMake(15.12, 14.9) controlPoint1: CGPointMake(15.42, 15.3) controlPoint2: CGPointMake(15.22, 15.2)];
    [bezier2Path addCurveToPoint: CGPointMake(14.32, 13.6) controlPoint1: CGPointMake(14.92, 14.4) controlPoint2: CGPointMake(14.72, 14)];
    [bezier2Path addCurveToPoint: CGPointMake(14.52, 13.5) controlPoint1: CGPointMake(14.32, 13.6) controlPoint2: CGPointMake(14.42, 13.5)];
    [bezier2Path addCurveToPoint: CGPointMake(14.02, 13.5) controlPoint1: CGPointMake(14.62, 13.5) controlPoint2: CGPointMake(14.32, 13.2)];
    [bezier2Path addCurveToPoint: CGPointMake(14.12, 13.8) controlPoint1: CGPointMake(13.72, 13.8) controlPoint2: CGPointMake(14.02, 13.9)];
    [bezier2Path addCurveToPoint: CGPointMake(14.92, 15.7) controlPoint1: CGPointMake(14.22, 13.8) controlPoint2: CGPointMake(14.92, 15.4)];
    [bezier2Path addCurveToPoint: CGPointMake(13.42, 17) controlPoint1: CGPointMake(14.92, 16.1) controlPoint2: CGPointMake(14.82, 16.8)];
    [bezier2Path addCurveToPoint: CGPointMake(10.42, 16) controlPoint1: CGPointMake(12.02, 17.2) controlPoint2: CGPointMake(10.72, 16.7)];
    [bezier2Path addCurveToPoint: CGPointMake(10.02, 14.4) controlPoint1: CGPointMake(10.12, 15.3) controlPoint2: CGPointMake(9.92, 14.9)];
    [bezier2Path addCurveToPoint: CGPointMake(10.12, 16.4) controlPoint1: CGPointMake(10.02, 14.4) controlPoint2: CGPointMake(9.72, 15.1)];
    [bezier2Path addCurveToPoint: CGPointMake(7.82, 15.3) controlPoint1: CGPointMake(10.12, 16.4) controlPoint2: CGPointMake(8.32, 16.7)];
    [bezier2Path addCurveToPoint: CGPointMake(7.72, 13.7) controlPoint1: CGPointMake(7.32, 13.9) controlPoint2: CGPointMake(7.62, 13.9)];
    [bezier2Path addCurveToPoint: CGPointMake(7.52, 15.2) controlPoint1: CGPointMake(7.72, 13.7) controlPoint2: CGPointMake(7.32, 14.1)];
    [bezier2Path addCurveToPoint: CGPointMake(4.32, 13.6) controlPoint1: CGPointMake(7.52, 15.2) controlPoint2: CGPointMake(5.02, 16.1)];
    [bezier2Path addCurveToPoint: CGPointMake(4.62, 12.7) controlPoint1: CGPointMake(4.32, 13.6) controlPoint2: CGPointMake(4.62, 13.3)];
    [bezier2Path addCurveToPoint: CGPointMake(2.12, 13.6) controlPoint1: CGPointMake(4.62, 12.7) controlPoint2: CGPointMake(3.52, 14.7)];
    [bezier2Path addCurveToPoint: CGPointMake(2.42, 10.9) controlPoint1: CGPointMake(0.82, 12.6) controlPoint2: CGPointMake(1.72, 11.2)];
    [bezier2Path addCurveToPoint: CGPointMake(1.32, 11.4) controlPoint1: CGPointMake(2.42, 10.9) controlPoint2: CGPointMake(1.62, 10.9)];
    [bezier2Path addCurveToPoint: CGPointMake(0.32, 9.9) controlPoint1: CGPointMake(1.32, 11.4) controlPoint2: CGPointMake(0.22, 11)];
    [bezier2Path addCurveToPoint: CGPointMake(1.42, 7.9) controlPoint1: CGPointMake(0.62, 8.8) controlPoint2: CGPointMake(1.22, 8.2)];
    [bezier2Path closePath];
    bezier2Path.miterLimit = 4;
    
    [fillColor2 setFill];
    [bezier2Path fill];
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
    [bezier3Path moveToPoint: CGPointMake(16.92, 16.1)];
    [bezier3Path addCurveToPoint: CGPointMake(16.52, 15.9) controlPoint1: CGPointMake(16.92, 16) controlPoint2: CGPointMake(16.82, 15.9)];
    [bezier3Path addCurveToPoint: CGPointMake(15.62, 15.5) controlPoint1: CGPointMake(16.32, 15.8) controlPoint2: CGPointMake(16.02, 15.7)];
    [bezier3Path addCurveToPoint: CGPointMake(15.12, 14.9) controlPoint1: CGPointMake(15.42, 15.3) controlPoint2: CGPointMake(15.22, 15.1)];
    [bezier3Path addCurveToPoint: CGPointMake(14.32, 13.6) controlPoint1: CGPointMake(14.92, 14.4) controlPoint2: CGPointMake(14.62, 14)];
    [bezier3Path addCurveToPoint: CGPointMake(14.32, 13.5) controlPoint1: CGPointMake(14.32, 13.6) controlPoint2: CGPointMake(14.32, 13.6)];
    [bezier3Path addCurveToPoint: CGPointMake(14.32, 13.4) controlPoint1: CGPointMake(14.32, 13.5) controlPoint2: CGPointMake(14.32, 13.5)];
    [bezier3Path addCurveToPoint: CGPointMake(14.42, 13.3) controlPoint1: CGPointMake(14.32, 13.4) controlPoint2: CGPointMake(14.42, 13.4)];
    [bezier3Path addCurveToPoint: CGPointMake(14.12, 13.4) controlPoint1: CGPointMake(14.32, 13.3) controlPoint2: CGPointMake(14.22, 13.3)];
    [bezier3Path addCurveToPoint: CGPointMake(14.02, 13.6) controlPoint1: CGPointMake(14.02, 13.5) controlPoint2: CGPointMake(14.02, 13.6)];
    [bezier3Path addLineToPoint: CGPointMake(14.02, 13.6)];
    [bezier3Path addLineToPoint: CGPointMake(14.02, 13.6)];
    [bezier3Path addLineToPoint: CGPointMake(14.02, 13.6)];
    [bezier3Path addCurveToPoint: CGPointMake(14.92, 15.6) controlPoint1: CGPointMake(14.32, 13.6) controlPoint2: CGPointMake(14.92, 15.4)];
    [bezier3Path addCurveToPoint: CGPointMake(13.32, 17) controlPoint1: CGPointMake(14.92, 16.1) controlPoint2: CGPointMake(14.72, 16.8)];
    [bezier3Path addCurveToPoint: CGPointMake(12.62, 17.1) controlPoint1: CGPointMake(13.12, 17) controlPoint2: CGPointMake(12.82, 17.1)];
    [bezier3Path addCurveToPoint: CGPointMake(10.22, 16) controlPoint1: CGPointMake(11.52, 17.1) controlPoint2: CGPointMake(10.52, 16.6)];
    [bezier3Path addCurveToPoint: CGPointMake(9.82, 15.1) controlPoint1: CGPointMake(10.02, 15.7) controlPoint2: CGPointMake(9.92, 15.4)];
    [bezier3Path addCurveToPoint: CGPointMake(10.02, 16.3) controlPoint1: CGPointMake(9.82, 15.4) controlPoint2: CGPointMake(9.82, 15.8)];
    [bezier3Path addLineToPoint: CGPointMake(10.02, 16.4)];
    [bezier3Path addCurveToPoint: CGPointMake(9.92, 16.4) controlPoint1: CGPointMake(10.02, 16.4) controlPoint2: CGPointMake(10.02, 16.4)];
    [bezier3Path addCurveToPoint: CGPointMake(9.52, 16.4) controlPoint1: CGPointMake(9.92, 16.4) controlPoint2: CGPointMake(9.72, 16.4)];
    [bezier3Path addCurveToPoint: CGPointMake(7.62, 15.2) controlPoint1: CGPointMake(8.92, 16.4) controlPoint2: CGPointMake(7.92, 16.2)];
    [bezier3Path addCurveToPoint: CGPointMake(7.42, 14.4) controlPoint1: CGPointMake(7.52, 14.9) controlPoint2: CGPointMake(7.42, 14.6)];
    [bezier3Path addCurveToPoint: CGPointMake(7.42, 15.1) controlPoint1: CGPointMake(7.42, 14.6) controlPoint2: CGPointMake(7.42, 14.8)];
    [bezier3Path addCurveToPoint: CGPointMake(7.32, 15.2) controlPoint1: CGPointMake(7.42, 15.1) controlPoint2: CGPointMake(7.42, 15.2)];
    [bezier3Path addCurveToPoint: CGPointMake(4.02, 13.6) controlPoint1: CGPointMake(7.32, 15.2) controlPoint2: CGPointMake(4.72, 16.1)];
    [bezier3Path addLineToPoint: CGPointMake(4.02, 13.5)];
    [bezier3Path addCurveToPoint: CGPointMake(4.22, 13.1) controlPoint1: CGPointMake(4.02, 13.5) controlPoint2: CGPointMake(4.12, 13.4)];
    [bezier3Path addCurveToPoint: CGPointMake(2.82, 14) controlPoint1: CGPointMake(3.92, 13.5) controlPoint2: CGPointMake(3.42, 14)];
    [bezier3Path addCurveToPoint: CGPointMake(1.82, 13.6) controlPoint1: CGPointMake(2.52, 14) controlPoint2: CGPointMake(2.22, 13.9)];
    [bezier3Path addCurveToPoint: CGPointMake(1.12, 12.1) controlPoint1: CGPointMake(1.12, 13.1) controlPoint2: CGPointMake(1.02, 12.5)];
    [bezier3Path addCurveToPoint: CGPointMake(1.72, 11) controlPoint1: CGPointMake(1.22, 11.7) controlPoint2: CGPointMake(1.42, 11.3)];
    [bezier3Path addCurveToPoint: CGPointMake(1.12, 11.4) controlPoint1: CGPointMake(1.52, 11.1) controlPoint2: CGPointMake(1.22, 11.2)];
    [bezier3Path addLineToPoint: CGPointMake(1.02, 11.4)];
    [bezier3Path addCurveToPoint: CGPointMake(0.02, 9.8) controlPoint1: CGPointMake(1.02, 11.4) controlPoint2: CGPointMake(-0.18, 11)];
    [bezier3Path addCurveToPoint: CGPointMake(0.82, 7.8) controlPoint1: CGPointMake(0.12, 8.8) controlPoint2: CGPointMake(0.52, 8.2)];
    [bezier3Path addLineToPoint: CGPointMake(0.92, 7.7)];
    [bezier3Path addLineToPoint: CGPointMake(1.02, 7.7)];
    [bezier3Path addCurveToPoint: CGPointMake(1.12, 7.8) controlPoint1: CGPointMake(1.02, 7.7) controlPoint2: CGPointMake(1.12, 7.7)];
    [bezier3Path addCurveToPoint: CGPointMake(2.72, 9.1) controlPoint1: CGPointMake(1.12, 7.9) controlPoint2: CGPointMake(1.22, 9.1)];
    [bezier3Path addLineToPoint: CGPointMake(2.82, 9.1)];
    [bezier3Path addLineToPoint: CGPointMake(2.92, 9.1)];
    [bezier3Path addCurveToPoint: CGPointMake(3.62, 11.1) controlPoint1: CGPointMake(2.92, 9.2) controlPoint2: CGPointMake(3.72, 10.3)];
    [bezier3Path addCurveToPoint: CGPointMake(3.42, 11.9) controlPoint1: CGPointMake(3.52, 11.5) controlPoint2: CGPointMake(3.52, 11.7)];
    [bezier3Path addCurveToPoint: CGPointMake(3.72, 11.2) controlPoint1: CGPointMake(3.52, 11.8) controlPoint2: CGPointMake(3.72, 11.6)];
    [bezier3Path addCurveToPoint: CGPointMake(3.22, 9.6) controlPoint1: CGPointMake(3.72, 10.7) controlPoint2: CGPointMake(3.52, 10.1)];
    [bezier3Path addCurveToPoint: CGPointMake(2.82, 8.7) controlPoint1: CGPointMake(3.02, 9.3) controlPoint2: CGPointMake(2.92, 8.9)];
    [bezier3Path addCurveToPoint: CGPointMake(3.62, 6.7) controlPoint1: CGPointMake(2.52, 7.6) controlPoint2: CGPointMake(2.82, 6.9)];
    [bezier3Path addCurveToPoint: CGPointMake(3.82, 6.7) controlPoint1: CGPointMake(3.72, 6.7) controlPoint2: CGPointMake(3.72, 6.7)];
    [bezier3Path addCurveToPoint: CGPointMake(4.32, 7) controlPoint1: CGPointMake(4.12, 6.7) controlPoint2: CGPointMake(4.32, 6.8)];
    [bezier3Path addLineToPoint: CGPointMake(4.32, 7.1)];
    [bezier3Path addCurveToPoint: CGPointMake(4.32, 7.4) controlPoint1: CGPointMake(4.32, 7.2) controlPoint2: CGPointMake(4.42, 7.3)];
    [bezier3Path addCurveToPoint: CGPointMake(4.12, 7.5) controlPoint1: CGPointMake(4.32, 7.5) controlPoint2: CGPointMake(4.22, 7.5)];
    [bezier3Path addCurveToPoint: CGPointMake(3.72, 7.6) controlPoint1: CGPointMake(3.92, 7.5) controlPoint2: CGPointMake(3.82, 7.5)];
    [bezier3Path addCurveToPoint: CGPointMake(4.22, 7.6) controlPoint1: CGPointMake(3.82, 7.6) controlPoint2: CGPointMake(4.02, 7.6)];
    [bezier3Path addCurveToPoint: CGPointMake(4.52, 7.6) controlPoint1: CGPointMake(4.32, 7.6) controlPoint2: CGPointMake(4.42, 7.6)];
    [bezier3Path addLineToPoint: CGPointMake(4.62, 7.6)];
    [bezier3Path addCurveToPoint: CGPointMake(4.52, 7.2) controlPoint1: CGPointMake(4.62, 7.6) controlPoint2: CGPointMake(4.62, 7.3)];
    [bezier3Path addCurveToPoint: CGPointMake(5.32, 3.9) controlPoint1: CGPointMake(4.42, 6.8) controlPoint2: CGPointMake(4.02, 4.8)];
    [bezier3Path addCurveToPoint: CGPointMake(6.32, 3.6) controlPoint1: CGPointMake(5.62, 3.7) controlPoint2: CGPointMake(5.92, 3.6)];
    [bezier3Path addCurveToPoint: CGPointMake(8.02, 4.8) controlPoint1: CGPointMake(7.22, 3.6) controlPoint2: CGPointMake(8.02, 4.4)];
    [bezier3Path addCurveToPoint: CGPointMake(7.62, 7.4) controlPoint1: CGPointMake(8.02, 5.1) controlPoint2: CGPointMake(8.22, 6.5)];
    [bezier3Path addCurveToPoint: CGPointMake(7.82, 7.1) controlPoint1: CGPointMake(7.72, 7.4) controlPoint2: CGPointMake(7.82, 7.2)];
    [bezier3Path addCurveToPoint: CGPointMake(8.12, 4) controlPoint1: CGPointMake(8.02, 6.6) controlPoint2: CGPointMake(8.12, 6)];
    [bezier3Path addCurveToPoint: CGPointMake(8.62, 2.6) controlPoint1: CGPointMake(8.12, 3.4) controlPoint2: CGPointMake(8.32, 2.9)];
    [bezier3Path addCurveToPoint: CGPointMake(10.22, 2.1) controlPoint1: CGPointMake(8.92, 2.3) controlPoint2: CGPointMake(9.52, 2.1)];
    [bezier3Path addCurveToPoint: CGPointMake(10.92, 2.1) controlPoint1: CGPointMake(10.52, 2.1) controlPoint2: CGPointMake(10.72, 2.1)];
    [bezier3Path addLineToPoint: CGPointMake(10.92, 2.1)];
    [bezier3Path addCurveToPoint: CGPointMake(12.62, 2.9) controlPoint1: CGPointMake(11.52, 2.2) controlPoint2: CGPointMake(12.22, 2.4)];
    [bezier3Path addCurveToPoint: CGPointMake(12.72, 3.7) controlPoint1: CGPointMake(12.82, 3.1) controlPoint2: CGPointMake(12.82, 3.4)];
    [bezier3Path addCurveToPoint: CGPointMake(12.42, 4.5) controlPoint1: CGPointMake(12.62, 3.9) controlPoint2: CGPointMake(12.52, 4.2)];
    [bezier3Path addCurveToPoint: CGPointMake(11.62, 7.2) controlPoint1: CGPointMake(12.12, 5.2) controlPoint2: CGPointMake(11.72, 6.1)];
    [bezier3Path addCurveToPoint: CGPointMake(12.22, 5.3) controlPoint1: CGPointMake(11.72, 6.6) controlPoint2: CGPointMake(11.92, 5.9)];
    [bezier3Path addCurveToPoint: CGPointMake(12.52, 4.7) controlPoint1: CGPointMake(12.32, 5.1) controlPoint2: CGPointMake(12.42, 4.9)];
    [bezier3Path addCurveToPoint: CGPointMake(14.62, 2.7) controlPoint1: CGPointMake(13.02, 3.7) controlPoint2: CGPointMake(13.42, 2.7)];
    [bezier3Path addCurveToPoint: CGPointMake(15.42, 2.8) controlPoint1: CGPointMake(14.82, 2.7) controlPoint2: CGPointMake(15.12, 2.8)];
    [bezier3Path addCurveToPoint: CGPointMake(16.92, 5) controlPoint1: CGPointMake(17.32, 3.4) controlPoint2: CGPointMake(17.12, 4.3)];
    [bezier3Path addCurveToPoint: CGPointMake(16.92, 5.2) controlPoint1: CGPointMake(16.92, 5.1) controlPoint2: CGPointMake(16.92, 5.1)];
    [bezier3Path addCurveToPoint: CGPointMake(16.82, 5.6) controlPoint1: CGPointMake(16.92, 5.4) controlPoint2: CGPointMake(16.82, 5.5)];
    [bezier3Path addCurveToPoint: CGPointMake(16.92, 7.3) controlPoint1: CGPointMake(16.72, 6.1) controlPoint2: CGPointMake(16.62, 6.4)];
    [bezier3Path addCurveToPoint: CGPointMake(17.02, 8) controlPoint1: CGPointMake(17.02, 7.6) controlPoint2: CGPointMake(17.02, 7.9)];
    [bezier3Path addLineToPoint: CGPointMake(17.02, 8)];
    [bezier3Path addCurveToPoint: CGPointMake(17.02, 7.5) controlPoint1: CGPointMake(17.12, 7.9) controlPoint2: CGPointMake(17.12, 7.7)];
    [bezier3Path addCurveToPoint: CGPointMake(17.02, 5.1) controlPoint1: CGPointMake(16.82, 6.7) controlPoint2: CGPointMake(16.72, 6.1)];
    [bezier3Path addCurveToPoint: CGPointMake(17.12, 5) controlPoint1: CGPointMake(17.02, 5.1) controlPoint2: CGPointMake(17.02, 5)];
    [bezier3Path addCurveToPoint: CGPointMake(19.32, 6) controlPoint1: CGPointMake(17.12, 5) controlPoint2: CGPointMake(18.32, 4.7)];
    [bezier3Path addCurveToPoint: CGPointMake(20.12, 9.2) controlPoint1: CGPointMake(20.12, 7) controlPoint2: CGPointMake(20.12, 8.4)];
    [bezier3Path addCurveToPoint: CGPointMake(20.52, 8.3) controlPoint1: CGPointMake(20.22, 8.9) controlPoint2: CGPointMake(20.42, 8.6)];
    [bezier3Path addCurveToPoint: CGPointMake(20.92, 8) controlPoint1: CGPointMake(20.62, 8.1) controlPoint2: CGPointMake(20.72, 8)];
    [bezier3Path addCurveToPoint: CGPointMake(21.52, 8.6) controlPoint1: CGPointMake(21.12, 8) controlPoint2: CGPointMake(21.42, 8.2)];
    [bezier3Path addCurveToPoint: CGPointMake(21.62, 9) controlPoint1: CGPointMake(21.52, 8.7) controlPoint2: CGPointMake(21.62, 8.9)];
    [bezier3Path addCurveToPoint: CGPointMake(22.02, 11.5) controlPoint1: CGPointMake(21.92, 9.7) controlPoint2: CGPointMake(22.32, 10.8)];
    [bezier3Path addCurveToPoint: CGPointMake(20.52, 12.9) controlPoint1: CGPointMake(21.82, 12.1) controlPoint2: CGPointMake(21.12, 12.5)];
    [bezier3Path addCurveToPoint: CGPointMake(19.72, 13.4) controlPoint1: CGPointMake(20.22, 13.1) controlPoint2: CGPointMake(19.92, 13.3)];
    [bezier3Path addCurveToPoint: CGPointMake(19.32, 14.1) controlPoint1: CGPointMake(19.52, 13.6) controlPoint2: CGPointMake(19.42, 13.8)];
    [bezier3Path addCurveToPoint: CGPointMake(18.22, 15.4) controlPoint1: CGPointMake(19.12, 14.6) controlPoint2: CGPointMake(18.82, 15.1)];
    [bezier3Path addCurveToPoint: CGPointMake(16.92, 16.1) controlPoint1: CGPointMake(18.52, 15.9) controlPoint2: CGPointMake(17.02, 16.5)];
    [bezier3Path closePath];
    [bezier3Path moveToPoint: CGPointMake(14.62, 13.6)];
    [bezier3Path addCurveToPoint: CGPointMake(15.32, 14.9) controlPoint1: CGPointMake(14.92, 14) controlPoint2: CGPointMake(15.12, 14.4)];
    [bezier3Path addCurveToPoint: CGPointMake(15.72, 15.4) controlPoint1: CGPointMake(15.42, 15.1) controlPoint2: CGPointMake(15.52, 15.3)];
    [bezier3Path addCurveToPoint: CGPointMake(16.52, 15.8) controlPoint1: CGPointMake(16.02, 15.6) controlPoint2: CGPointMake(16.32, 15.7)];
    [bezier3Path addCurveToPoint: CGPointMake(17.02, 16.1) controlPoint1: CGPointMake(16.72, 15.9) controlPoint2: CGPointMake(16.92, 15.9)];
    [bezier3Path addCurveToPoint: CGPointMake(18.22, 15.6) controlPoint1: CGPointMake(17.12, 16.5) controlPoint2: CGPointMake(18.22, 15.7)];
    [bezier3Path addLineToPoint: CGPointMake(18.22, 15.5)];
    [bezier3Path addCurveToPoint: CGPointMake(19.32, 14.2) controlPoint1: CGPointMake(18.82, 15.2) controlPoint2: CGPointMake(19.02, 14.7)];
    [bezier3Path addCurveToPoint: CGPointMake(19.82, 13.5) controlPoint1: CGPointMake(19.42, 13.9) controlPoint2: CGPointMake(19.62, 13.7)];
    [bezier3Path addCurveToPoint: CGPointMake(20.62, 12.9) controlPoint1: CGPointMake(20.02, 13.3) controlPoint2: CGPointMake(20.32, 13.1)];
    [bezier3Path addCurveToPoint: CGPointMake(22.02, 11.6) controlPoint1: CGPointMake(21.22, 12.6) controlPoint2: CGPointMake(21.82, 12.2)];
    [bezier3Path addCurveToPoint: CGPointMake(21.62, 9.2) controlPoint1: CGPointMake(22.32, 10.9) controlPoint2: CGPointMake(21.92, 9.9)];
    [bezier3Path addCurveToPoint: CGPointMake(21.42, 8.8) controlPoint1: CGPointMake(21.52, 9) controlPoint2: CGPointMake(21.52, 8.9)];
    [bezier3Path addCurveToPoint: CGPointMake(20.92, 8.3) controlPoint1: CGPointMake(21.32, 8.4) controlPoint2: CGPointMake(21.12, 8.3)];
    [bezier3Path addCurveToPoint: CGPointMake(20.62, 8.5) controlPoint1: CGPointMake(20.82, 8.3) controlPoint2: CGPointMake(20.72, 8.4)];
    [bezier3Path addCurveToPoint: CGPointMake(20.02, 9.9) controlPoint1: CGPointMake(20.42, 8.9) controlPoint2: CGPointMake(20.02, 9.8)];
    [bezier3Path addCurveToPoint: CGPointMake(19.92, 9.9) controlPoint1: CGPointMake(20.02, 9.9) controlPoint2: CGPointMake(19.92, 10)];
    [bezier3Path addLineToPoint: CGPointMake(19.82, 9.8)];
    [bezier3Path addCurveToPoint: CGPointMake(19.12, 6.2) controlPoint1: CGPointMake(19.92, 9.3) controlPoint2: CGPointMake(20.12, 7.5)];
    [bezier3Path addCurveToPoint: CGPointMake(17.12, 5.2) controlPoint1: CGPointMake(18.32, 5.1) controlPoint2: CGPointMake(17.42, 5.2)];
    [bezier3Path addCurveToPoint: CGPointMake(17.12, 7.4) controlPoint1: CGPointMake(16.82, 6.1) controlPoint2: CGPointMake(16.92, 6.7)];
    [bezier3Path addCurveToPoint: CGPointMake(17.02, 8.1) controlPoint1: CGPointMake(17.22, 7.7) controlPoint2: CGPointMake(17.22, 7.9)];
    [bezier3Path addCurveToPoint: CGPointMake(16.62, 8.4) controlPoint1: CGPointMake(16.82, 8.3) controlPoint2: CGPointMake(16.62, 8.4)];
    [bezier3Path addCurveToPoint: CGPointMake(16.52, 8.3) controlPoint1: CGPointMake(16.62, 8.4) controlPoint2: CGPointMake(16.52, 8.4)];
    [bezier3Path addLineToPoint: CGPointMake(16.52, 8.2)];
    [bezier3Path addCurveToPoint: CGPointMake(16.62, 7.3) controlPoint1: CGPointMake(16.62, 8.1) controlPoint2: CGPointMake(16.82, 7.9)];
    [bezier3Path addCurveToPoint: CGPointMake(16.52, 5.4) controlPoint1: CGPointMake(16.22, 6.3) controlPoint2: CGPointMake(16.32, 6)];
    [bezier3Path addCurveToPoint: CGPointMake(16.62, 5) controlPoint1: CGPointMake(16.52, 5.3) controlPoint2: CGPointMake(16.62, 5.1)];
    [bezier3Path addCurveToPoint: CGPointMake(16.62, 4.8) controlPoint1: CGPointMake(16.62, 4.9) controlPoint2: CGPointMake(16.62, 4.8)];
    [bezier3Path addCurveToPoint: CGPointMake(15.22, 2.8) controlPoint1: CGPointMake(16.82, 4.1) controlPoint2: CGPointMake(16.92, 3.3)];
    [bezier3Path addCurveToPoint: CGPointMake(14.42, 2.7) controlPoint1: CGPointMake(14.92, 2.7) controlPoint2: CGPointMake(14.72, 2.7)];
    [bezier3Path addCurveToPoint: CGPointMake(12.52, 4.6) controlPoint1: CGPointMake(13.42, 2.7) controlPoint2: CGPointMake(12.92, 3.6)];
    [bezier3Path addCurveToPoint: CGPointMake(12.22, 5.2) controlPoint1: CGPointMake(12.42, 4.8) controlPoint2: CGPointMake(12.32, 5)];
    [bezier3Path addCurveToPoint: CGPointMake(11.62, 8.2) controlPoint1: CGPointMake(11.52, 6.5) controlPoint2: CGPointMake(11.62, 8.2)];
    [bezier3Path addCurveToPoint: CGPointMake(11.52, 8.3) controlPoint1: CGPointMake(11.62, 8.2) controlPoint2: CGPointMake(11.62, 8.3)];
    [bezier3Path addCurveToPoint: CGPointMake(11.42, 8.2) controlPoint1: CGPointMake(11.42, 8.3) controlPoint2: CGPointMake(11.42, 8.3)];
    [bezier3Path addCurveToPoint: CGPointMake(12.12, 4.2) controlPoint1: CGPointMake(11.12, 6.5) controlPoint2: CGPointMake(11.72, 5.2)];
    [bezier3Path addCurveToPoint: CGPointMake(12.42, 3.4) controlPoint1: CGPointMake(12.22, 3.9) controlPoint2: CGPointMake(12.32, 3.6)];
    [bezier3Path addCurveToPoint: CGPointMake(12.32, 2.8) controlPoint1: CGPointMake(12.52, 3.2) controlPoint2: CGPointMake(12.42, 3)];
    [bezier3Path addCurveToPoint: CGPointMake(10.82, 2.1) controlPoint1: CGPointMake(12.02, 2.4) controlPoint2: CGPointMake(11.32, 2.1)];
    [bezier3Path addLineToPoint: CGPointMake(10.82, 2.1)];
    [bezier3Path addCurveToPoint: CGPointMake(10.12, 2.1) controlPoint1: CGPointMake(10.62, 2.1) controlPoint2: CGPointMake(10.42, 2.1)];
    [bezier3Path addCurveToPoint: CGPointMake(8.72, 2.6) controlPoint1: CGPointMake(9.42, 2.1) controlPoint2: CGPointMake(9.02, 2.3)];
    [bezier3Path addCurveToPoint: CGPointMake(8.32, 3.9) controlPoint1: CGPointMake(8.42, 2.9) controlPoint2: CGPointMake(8.32, 3.3)];
    [bezier3Path addCurveToPoint: CGPointMake(8.02, 7.1) controlPoint1: CGPointMake(8.32, 6) controlPoint2: CGPointMake(8.22, 6.6)];
    [bezier3Path addCurveToPoint: CGPointMake(7.42, 7.5) controlPoint1: CGPointMake(7.82, 7.7) controlPoint2: CGPointMake(7.42, 7.5)];
    [bezier3Path addCurveToPoint: CGPointMake(7.42, 7.4) controlPoint1: CGPointMake(7.42, 7.5) controlPoint2: CGPointMake(7.42, 7.5)];
    [bezier3Path addCurveToPoint: CGPointMake(7.42, 7.3) controlPoint1: CGPointMake(7.42, 7.4) controlPoint2: CGPointMake(7.42, 7.4)];
    [bezier3Path addCurveToPoint: CGPointMake(7.92, 4.7) controlPoint1: CGPointMake(8.02, 6.5) controlPoint2: CGPointMake(7.92, 5)];
    [bezier3Path addCurveToPoint: CGPointMake(6.42, 3.7) controlPoint1: CGPointMake(7.92, 4.5) controlPoint2: CGPointMake(7.22, 3.7)];
    [bezier3Path addCurveToPoint: CGPointMake(5.52, 4) controlPoint1: CGPointMake(6.12, 3.7) controlPoint2: CGPointMake(5.82, 3.8)];
    [bezier3Path addCurveToPoint: CGPointMake(4.82, 7.2) controlPoint1: CGPointMake(4.32, 4.9) controlPoint2: CGPointMake(4.82, 6.9)];
    [bezier3Path addCurveToPoint: CGPointMake(4.82, 7.8) controlPoint1: CGPointMake(4.92, 7.5) controlPoint2: CGPointMake(4.92, 7.7)];
    [bezier3Path addCurveToPoint: CGPointMake(4.62, 7.9) controlPoint1: CGPointMake(4.72, 7.9) controlPoint2: CGPointMake(4.72, 7.9)];
    [bezier3Path addCurveToPoint: CGPointMake(4.42, 7.9) controlPoint1: CGPointMake(4.62, 7.9) controlPoint2: CGPointMake(4.52, 7.9)];
    [bezier3Path addCurveToPoint: CGPointMake(3.72, 7.9) controlPoint1: CGPointMake(4.12, 7.9) controlPoint2: CGPointMake(3.72, 7.9)];
    [bezier3Path addLineToPoint: CGPointMake(3.62, 7.9)];
    [bezier3Path addLineToPoint: CGPointMake(3.62, 7.8)];
    [bezier3Path addCurveToPoint: CGPointMake(4.32, 7.5) controlPoint1: CGPointMake(3.82, 7.6) controlPoint2: CGPointMake(4.02, 7.5)];
    [bezier3Path addCurveToPoint: CGPointMake(4.42, 7.5) controlPoint1: CGPointMake(4.42, 7.5) controlPoint2: CGPointMake(4.42, 7.5)];
    [bezier3Path addCurveToPoint: CGPointMake(4.42, 7.3) controlPoint1: CGPointMake(4.42, 7.5) controlPoint2: CGPointMake(4.42, 7.4)];
    [bezier3Path addCurveToPoint: CGPointMake(4.42, 7.1) controlPoint1: CGPointMake(4.42, 7.2) controlPoint2: CGPointMake(4.42, 7.2)];
    [bezier3Path addCurveToPoint: CGPointMake(4.12, 7) controlPoint1: CGPointMake(4.42, 7.1) controlPoint2: CGPointMake(4.32, 7)];
    [bezier3Path addLineToPoint: CGPointMake(4.02, 7)];
    [bezier3Path addCurveToPoint: CGPointMake(3.32, 8.8) controlPoint1: CGPointMake(3.12, 7.2) controlPoint2: CGPointMake(3.22, 8.1)];
    [bezier3Path addCurveToPoint: CGPointMake(3.72, 9.7) controlPoint1: CGPointMake(3.42, 9.1) controlPoint2: CGPointMake(3.52, 9.4)];
    [bezier3Path addCurveToPoint: CGPointMake(4.22, 11.4) controlPoint1: CGPointMake(4.02, 10.3) controlPoint2: CGPointMake(4.32, 10.9)];
    [bezier3Path addCurveToPoint: CGPointMake(3.42, 12.4) controlPoint1: CGPointMake(4.12, 12.3) controlPoint2: CGPointMake(3.42, 12.4)];
    [bezier3Path addCurveToPoint: CGPointMake(3.32, 12.3) controlPoint1: CGPointMake(3.42, 12.4) controlPoint2: CGPointMake(3.32, 12.4)];
    [bezier3Path addLineToPoint: CGPointMake(3.32, 12.2)];
    [bezier3Path addCurveToPoint: CGPointMake(3.72, 11.2) controlPoint1: CGPointMake(3.62, 11.9) controlPoint2: CGPointMake(3.62, 11.9)];
    [bezier3Path addCurveToPoint: CGPointMake(3.02, 9.4) controlPoint1: CGPointMake(3.82, 10.6) controlPoint2: CGPointMake(3.22, 9.6)];
    [bezier3Path addLineToPoint: CGPointMake(3.02, 9.4)];
    [bezier3Path addCurveToPoint: CGPointMake(1.22, 8.1) controlPoint1: CGPointMake(1.72, 9.4) controlPoint2: CGPointMake(1.42, 8.6)];
    [bezier3Path addCurveToPoint: CGPointMake(0.52, 9.9) controlPoint1: CGPointMake(1.02, 8.4) controlPoint2: CGPointMake(0.62, 9)];
    [bezier3Path addCurveToPoint: CGPointMake(1.32, 11.3) controlPoint1: CGPointMake(0.42, 10.8) controlPoint2: CGPointMake(1.12, 11.2)];
    [bezier3Path addCurveToPoint: CGPointMake(2.52, 10.8) controlPoint1: CGPointMake(1.72, 10.8) controlPoint2: CGPointMake(2.42, 10.8)];
    [bezier3Path addLineToPoint: CGPointMake(2.52, 10.8)];
    [bezier3Path addCurveToPoint: CGPointMake(2.62, 10.9) controlPoint1: CGPointMake(2.52, 10.8) controlPoint2: CGPointMake(2.62, 10.8)];
    [bezier3Path addCurveToPoint: CGPointMake(2.52, 11) controlPoint1: CGPointMake(2.62, 10.9) controlPoint2: CGPointMake(2.62, 11)];
    [bezier3Path addCurveToPoint: CGPointMake(1.62, 12.2) controlPoint1: CGPointMake(2.12, 11.1) controlPoint2: CGPointMake(1.72, 11.6)];
    [bezier3Path addCurveToPoint: CGPointMake(2.22, 13.5) controlPoint1: CGPointMake(1.52, 12.6) controlPoint2: CGPointMake(1.62, 13.1)];
    [bezier3Path addCurveToPoint: CGPointMake(3.12, 13.8) controlPoint1: CGPointMake(2.52, 13.7) controlPoint2: CGPointMake(2.82, 13.8)];
    [bezier3Path addCurveToPoint: CGPointMake(4.72, 12.6) controlPoint1: CGPointMake(4.02, 13.8) controlPoint2: CGPointMake(4.62, 12.7)];
    [bezier3Path addCurveToPoint: CGPointMake(4.82, 12.6) controlPoint1: CGPointMake(4.72, 12.6) controlPoint2: CGPointMake(4.82, 12.5)];
    [bezier3Path addLineToPoint: CGPointMake(4.92, 12.7)];
    [bezier3Path addCurveToPoint: CGPointMake(4.62, 13.6) controlPoint1: CGPointMake(4.82, 13.2) controlPoint2: CGPointMake(4.62, 13.5)];
    [bezier3Path addCurveToPoint: CGPointMake(7.62, 15.1) controlPoint1: CGPointMake(5.22, 15.7) controlPoint2: CGPointMake(7.22, 15.2)];
    [bezier3Path addCurveToPoint: CGPointMake(7.82, 13.6) controlPoint1: CGPointMake(7.42, 14) controlPoint2: CGPointMake(7.82, 13.6)];
    [bezier3Path addLineToPoint: CGPointMake(7.92, 13.6)];
    [bezier3Path addLineToPoint: CGPointMake(8.02, 13.7)];
    [bezier3Path addCurveToPoint: CGPointMake(8.02, 13.8) controlPoint1: CGPointMake(8.02, 13.8) controlPoint2: CGPointMake(8.02, 13.8)];
    [bezier3Path addCurveToPoint: CGPointMake(8.22, 15.2) controlPoint1: CGPointMake(7.92, 13.9) controlPoint2: CGPointMake(7.82, 14.1)];
    [bezier3Path addCurveToPoint: CGPointMake(10.02, 16.3) controlPoint1: CGPointMake(8.52, 16.1) controlPoint2: CGPointMake(9.42, 16.3)];
    [bezier3Path addCurveToPoint: CGPointMake(10.32, 16.3) controlPoint1: CGPointMake(10.12, 16.3) controlPoint2: CGPointMake(10.22, 16.3)];
    [bezier3Path addCurveToPoint: CGPointMake(10.22, 14.3) controlPoint1: CGPointMake(10.02, 15) controlPoint2: CGPointMake(10.22, 14.3)];
    [bezier3Path addLineToPoint: CGPointMake(10.32, 14.2)];
    [bezier3Path addLineToPoint: CGPointMake(10.42, 14.3)];
    [bezier3Path addCurveToPoint: CGPointMake(10.82, 15.9) controlPoint1: CGPointMake(10.42, 14.7) controlPoint2: CGPointMake(10.52, 15.1)];
    [bezier3Path addCurveToPoint: CGPointMake(13.02, 16.9) controlPoint1: CGPointMake(11.12, 16.5) controlPoint2: CGPointMake(12.02, 16.9)];
    [bezier3Path addCurveToPoint: CGPointMake(13.72, 16.8) controlPoint1: CGPointMake(13.22, 16.9) controlPoint2: CGPointMake(13.42, 16.9)];
    [bezier3Path addCurveToPoint: CGPointMake(15.12, 15.6) controlPoint1: CGPointMake(14.72, 16.6) controlPoint2: CGPointMake(15.22, 16.2)];
    [bezier3Path addCurveToPoint: CGPointMake(14.32, 13.8) controlPoint1: CGPointMake(15.12, 15.3) controlPoint2: CGPointMake(14.52, 13.9)];
    [bezier3Path addCurveToPoint: CGPointMake(14.02, 13.7) controlPoint1: CGPointMake(14.22, 13.8) controlPoint2: CGPointMake(14.12, 13.8)];
    [bezier3Path addCurveToPoint: CGPointMake(14.12, 13.3) controlPoint1: CGPointMake(14.02, 13.6) controlPoint2: CGPointMake(14.02, 13.5)];
    [bezier3Path addCurveToPoint: CGPointMake(14.52, 13.1) controlPoint1: CGPointMake(14.22, 13.1) controlPoint2: CGPointMake(14.42, 13.1)];
    [bezier3Path addCurveToPoint: CGPointMake(14.82, 13.3) controlPoint1: CGPointMake(14.62, 13.1) controlPoint2: CGPointMake(14.72, 13.2)];
    [bezier3Path addCurveToPoint: CGPointMake(14.72, 13.4) controlPoint1: CGPointMake(14.82, 13.4) controlPoint2: CGPointMake(14.82, 13.4)];
    [bezier3Path addCurveToPoint: CGPointMake(14.62, 13.6) controlPoint1: CGPointMake(14.72, 13.5) controlPoint2: CGPointMake(14.72, 13.5)];
    [bezier3Path closePath];
    bezier3Path.miterLimit = 4;
    
    [fillColor setFill];
    [bezier3Path fill];
    
    
    //// Group 3
    {
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(4.62, 9.4)];
        [bezier4Path addCurveToPoint: CGPointMake(5.32, 10.7) controlPoint1: CGPointMake(4.62, 9.4) controlPoint2: CGPointMake(5.62, 9.8)];
        [bezier4Path addCurveToPoint: CGPointMake(4.82, 11.1) controlPoint1: CGPointMake(5.32, 10.7) controlPoint2: CGPointMake(5.02, 10.7)];
        [bezier4Path addCurveToPoint: CGPointMake(6.32, 11) controlPoint1: CGPointMake(4.82, 11.1) controlPoint2: CGPointMake(5.52, 10.5)];
        [bezier4Path addCurveToPoint: CGPointMake(6.62, 12.5) controlPoint1: CGPointMake(7.02, 11.4) controlPoint2: CGPointMake(7.02, 12)];
        [bezier4Path addCurveToPoint: CGPointMake(6.22, 13.4) controlPoint1: CGPointMake(6.22, 13) controlPoint2: CGPointMake(6.22, 13.3)];
        [bezier4Path addCurveToPoint: CGPointMake(8.82, 12.6) controlPoint1: CGPointMake(6.22, 13.4) controlPoint2: CGPointMake(6.62, 12)];
        [bezier4Path addCurveToPoint: CGPointMake(9.22, 14.9) controlPoint1: CGPointMake(8.82, 12.6) controlPoint2: CGPointMake(8.52, 14.5)];
        [bezier4Path addCurveToPoint: CGPointMake(9.12, 14) controlPoint1: CGPointMake(9.22, 14.9) controlPoint2: CGPointMake(9.22, 14.5)];
        [bezier4Path addCurveToPoint: CGPointMake(10.52, 11.5) controlPoint1: CGPointMake(9.12, 13.5) controlPoint2: CGPointMake(8.92, 12.1)];
        [bezier4Path addCurveToPoint: CGPointMake(11.92, 11.6) controlPoint1: CGPointMake(10.52, 11.5) controlPoint2: CGPointMake(11.62, 11.7)];
        [bezier4Path addCurveToPoint: CGPointMake(13.32, 14.6) controlPoint1: CGPointMake(11.92, 11.6) controlPoint2: CGPointMake(11.12, 13)];
        [bezier4Path addCurveToPoint: CGPointMake(13.12, 10.9) controlPoint1: CGPointMake(13.32, 14.6) controlPoint2: CGPointMake(10.92, 12.2)];
        [bezier4Path addCurveToPoint: CGPointMake(14.92, 10.6) controlPoint1: CGPointMake(13.72, 10.5) controlPoint2: CGPointMake(14.42, 10.5)];
        [bezier4Path addCurveToPoint: CGPointMake(16.72, 11.9) controlPoint1: CGPointMake(16.12, 10.7) controlPoint2: CGPointMake(16.72, 11.5)];
        [bezier4Path addCurveToPoint: CGPointMake(17.22, 14.4) controlPoint1: CGPointMake(16.72, 12.5) controlPoint2: CGPointMake(16.82, 13.9)];
        [bezier4Path addCurveToPoint: CGPointMake(17.12, 12.4) controlPoint1: CGPointMake(17.22, 14.4) controlPoint2: CGPointMake(17.02, 13)];
        [bezier4Path addCurveToPoint: CGPointMake(16.92, 11.4) controlPoint1: CGPointMake(17.22, 11.8) controlPoint2: CGPointMake(16.92, 11.4)];
        [bezier4Path addCurveToPoint: CGPointMake(19.02, 7.9) controlPoint1: CGPointMake(16.92, 11.4) controlPoint2: CGPointMake(19.12, 11.4)];
        [bezier4Path addCurveToPoint: CGPointMake(16.72, 11) controlPoint1: CGPointMake(19.02, 7.9) controlPoint2: CGPointMake(18.92, 11.1)];
        [bezier4Path addCurveToPoint: CGPointMake(15.02, 10.2) controlPoint1: CGPointMake(16.72, 11) controlPoint2: CGPointMake(16.32, 10.3)];
        [bezier4Path addCurveToPoint: CGPointMake(15.32, 8.4) controlPoint1: CGPointMake(15.02, 10.2) controlPoint2: CGPointMake(15.62, 9.6)];
        [bezier4Path addCurveToPoint: CGPointMake(15.12, 6) controlPoint1: CGPointMake(15.02, 7.2) controlPoint2: CGPointMake(15.02, 6.6)];
        [bezier4Path addCurveToPoint: CGPointMake(15.02, 8.4) controlPoint1: CGPointMake(15.12, 6) controlPoint2: CGPointMake(14.62, 6.6)];
        [bezier4Path addCurveToPoint: CGPointMake(14.42, 10.1) controlPoint1: CGPointMake(15.12, 8.7) controlPoint2: CGPointMake(15.12, 9.7)];
        [bezier4Path addCurveToPoint: CGPointMake(12.12, 11.2) controlPoint1: CGPointMake(14.42, 10.1) controlPoint2: CGPointMake(13.02, 10)];
        [bezier4Path addCurveToPoint: CGPointMake(9.22, 9.3) controlPoint1: CGPointMake(12.12, 11.2) controlPoint2: CGPointMake(9.62, 11.5)];
        [bezier4Path addCurveToPoint: CGPointMake(9.82, 4.4) controlPoint1: CGPointMake(9.12, 8.8) controlPoint2: CGPointMake(9.42, 5.3)];
        [bezier4Path addCurveToPoint: CGPointMake(8.92, 7.7) controlPoint1: CGPointMake(9.82, 4.4) controlPoint2: CGPointMake(9.02, 5)];
        [bezier4Path addCurveToPoint: CGPointMake(10.12, 11.1) controlPoint1: CGPointMake(8.72, 10.4) controlPoint2: CGPointMake(10.12, 11.1)];
        [bezier4Path addCurveToPoint: CGPointMake(9.12, 12.1) controlPoint1: CGPointMake(10.12, 11.1) controlPoint2: CGPointMake(9.52, 11.4)];
        [bezier4Path addCurveToPoint: CGPointMake(7.42, 12.1) controlPoint1: CGPointMake(9.12, 12.1) controlPoint2: CGPointMake(8.02, 11.8)];
        [bezier4Path addCurveToPoint: CGPointMake(5.82, 10.5) controlPoint1: CGPointMake(7.42, 12.1) controlPoint2: CGPointMake(7.92, 10.6)];
        [bezier4Path addCurveToPoint: CGPointMake(5.12, 9.2) controlPoint1: CGPointMake(5.82, 10.5) controlPoint2: CGPointMake(6.22, 10)];
        [bezier4Path addCurveToPoint: CGPointMake(4.62, 9.4) controlPoint1: CGPointMake(4.92, 9.3) controlPoint2: CGPointMake(4.72, 9.1)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [fillColor setFill];
        [bezier4Path fill];
        
        
        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
        [bezier5Path moveToPoint: CGPointMake(9.22, 15)];
        [bezier5Path addLineToPoint: CGPointMake(9.22, 15)];
        [bezier5Path addCurveToPoint: CGPointMake(9.22, 15) controlPoint1: CGPointMake(9.12, 15) controlPoint2: CGPointMake(9.12, 15)];
        [bezier5Path addCurveToPoint: CGPointMake(8.72, 12.7) controlPoint1: CGPointMake(8.52, 14.6) controlPoint2: CGPointMake(8.72, 13)];
        [bezier5Path addCurveToPoint: CGPointMake(7.82, 12.6) controlPoint1: CGPointMake(8.42, 12.6) controlPoint2: CGPointMake(8.12, 12.6)];
        [bezier5Path addCurveToPoint: CGPointMake(6.22, 13.5) controlPoint1: CGPointMake(6.52, 12.6) controlPoint2: CGPointMake(6.32, 13.5)];
        [bezier5Path addLineToPoint: CGPointMake(6.12, 13.6)];
        [bezier5Path addCurveToPoint: CGPointMake(6.02, 13.5) controlPoint1: CGPointMake(6.12, 13.6) controlPoint2: CGPointMake(6.02, 13.6)];
        [bezier5Path addCurveToPoint: CGPointMake(6.42, 12.5) controlPoint1: CGPointMake(6.02, 13.3) controlPoint2: CGPointMake(6.12, 12.9)];
        [bezier5Path addCurveToPoint: CGPointMake(6.62, 11.7) controlPoint1: CGPointMake(6.62, 12.2) controlPoint2: CGPointMake(6.72, 12)];
        [bezier5Path addCurveToPoint: CGPointMake(6.12, 11.1) controlPoint1: CGPointMake(6.62, 11.5) controlPoint2: CGPointMake(6.42, 11.3)];
        [bezier5Path addCurveToPoint: CGPointMake(5.52, 10.9) controlPoint1: CGPointMake(5.92, 11) controlPoint2: CGPointMake(5.72, 10.9)];
        [bezier5Path addCurveToPoint: CGPointMake(4.72, 11.2) controlPoint1: CGPointMake(5.02, 10.9) controlPoint2: CGPointMake(4.72, 11.2)];
        [bezier5Path addLineToPoint: CGPointMake(4.62, 11.2)];
        [bezier5Path addLineToPoint: CGPointMake(4.62, 11.1)];
        [bezier5Path addCurveToPoint: CGPointMake(5.12, 10.6) controlPoint1: CGPointMake(4.72, 10.7) controlPoint2: CGPointMake(5.02, 10.6)];
        [bezier5Path addCurveToPoint: CGPointMake(4.42, 9.5) controlPoint1: CGPointMake(5.32, 9.8) controlPoint2: CGPointMake(4.42, 9.5)];
        [bezier5Path addLineToPoint: CGPointMake(4.42, 9.5)];
        [bezier5Path addCurveToPoint: CGPointMake(4.42, 9.4) controlPoint1: CGPointMake(4.42, 9.5) controlPoint2: CGPointMake(4.42, 9.5)];
        [bezier5Path addCurveToPoint: CGPointMake(4.62, 9.2) controlPoint1: CGPointMake(4.52, 9.3) controlPoint2: CGPointMake(4.52, 9.2)];
        [bezier5Path addCurveToPoint: CGPointMake(4.82, 9.3) controlPoint1: CGPointMake(4.72, 9.2) controlPoint2: CGPointMake(4.82, 9.3)];
        [bezier5Path addCurveToPoint: CGPointMake(5.62, 10.6) controlPoint1: CGPointMake(5.62, 9.9) controlPoint2: CGPointMake(5.62, 10.4)];
        [bezier5Path addCurveToPoint: CGPointMake(7.02, 11.3) controlPoint1: CGPointMake(6.32, 10.7) controlPoint2: CGPointMake(6.82, 10.9)];
        [bezier5Path addCurveToPoint: CGPointMake(7.22, 12.2) controlPoint1: CGPointMake(7.22, 11.6) controlPoint2: CGPointMake(7.22, 12)];
        [bezier5Path addCurveToPoint: CGPointMake(7.82, 12.1) controlPoint1: CGPointMake(7.42, 12.1) controlPoint2: CGPointMake(7.62, 12.1)];
        [bezier5Path addCurveToPoint: CGPointMake(8.82, 12.2) controlPoint1: CGPointMake(8.22, 12.1) controlPoint2: CGPointMake(8.62, 12.2)];
        [bezier5Path addCurveToPoint: CGPointMake(9.72, 11.3) controlPoint1: CGPointMake(9.12, 11.7) controlPoint2: CGPointMake(9.52, 11.4)];
        [bezier5Path addCurveToPoint: CGPointMake(8.62, 7.9) controlPoint1: CGPointMake(9.42, 11) controlPoint2: CGPointMake(8.52, 10.1)];
        [bezier5Path addCurveToPoint: CGPointMake(9.62, 4.5) controlPoint1: CGPointMake(8.82, 5.2) controlPoint2: CGPointMake(9.52, 4.5)];
        [bezier5Path addLineToPoint: CGPointMake(9.72, 4.5)];
        [bezier5Path addLineToPoint: CGPointMake(9.72, 4.6)];
        [bezier5Path addCurveToPoint: CGPointMake(9.12, 9.4) controlPoint1: CGPointMake(9.32, 5.4) controlPoint2: CGPointMake(9.02, 8.9)];
        [bezier5Path addCurveToPoint: CGPointMake(11.52, 11.3) controlPoint1: CGPointMake(9.42, 11) controlPoint2: CGPointMake(10.72, 11.3)];
        [bezier5Path addCurveToPoint: CGPointMake(11.82, 11.3) controlPoint1: CGPointMake(11.62, 11.3) controlPoint2: CGPointMake(11.72, 11.3)];
        [bezier5Path addCurveToPoint: CGPointMake(14.02, 10.2) controlPoint1: CGPointMake(12.62, 10.3) controlPoint2: CGPointMake(13.72, 10.2)];
        [bezier5Path addLineToPoint: CGPointMake(14.12, 10.2)];
        [bezier5Path addCurveToPoint: CGPointMake(14.62, 8.6) controlPoint1: CGPointMake(14.72, 9.8) controlPoint2: CGPointMake(14.72, 8.9)];
        [bezier5Path addCurveToPoint: CGPointMake(14.72, 6.1) controlPoint1: CGPointMake(14.22, 6.7) controlPoint2: CGPointMake(14.72, 6.1)];
        [bezier5Path addLineToPoint: CGPointMake(14.82, 6.1)];
        [bezier5Path addCurveToPoint: CGPointMake(14.82, 6.2) controlPoint1: CGPointMake(14.82, 6.1) controlPoint2: CGPointMake(14.92, 6.2)];
        [bezier5Path addCurveToPoint: CGPointMake(15.02, 8.6) controlPoint1: CGPointMake(14.72, 6.8) controlPoint2: CGPointMake(14.72, 7.4)];
        [bezier5Path addCurveToPoint: CGPointMake(14.72, 10.3) controlPoint1: CGPointMake(15.22, 9.5) controlPoint2: CGPointMake(14.92, 10.1)];
        [bezier5Path addCurveToPoint: CGPointMake(16.32, 11.1) controlPoint1: CGPointMake(15.72, 10.4) controlPoint2: CGPointMake(16.22, 10.9)];
        [bezier5Path addLineToPoint: CGPointMake(16.42, 11.1)];
        [bezier5Path addCurveToPoint: CGPointMake(18.52, 8.1) controlPoint1: CGPointMake(18.32, 11.1) controlPoint2: CGPointMake(18.52, 8.2)];
        [bezier5Path addCurveToPoint: CGPointMake(18.62, 8) controlPoint1: CGPointMake(18.52, 8.1) controlPoint2: CGPointMake(18.52, 8)];
        [bezier5Path addLineToPoint: CGPointMake(18.62, 8)];
        [bezier5Path addCurveToPoint: CGPointMake(18.72, 8.1) controlPoint1: CGPointMake(18.62, 8) controlPoint2: CGPointMake(18.72, 8)];
        [bezier5Path addCurveToPoint: CGPointMake(17.82, 11.1) controlPoint1: CGPointMake(18.72, 9.5) controlPoint2: CGPointMake(18.42, 10.4)];
        [bezier5Path addCurveToPoint: CGPointMake(16.72, 11.7) controlPoint1: CGPointMake(17.42, 11.5) controlPoint2: CGPointMake(16.92, 11.7)];
        [bezier5Path addCurveToPoint: CGPointMake(16.82, 12.6) controlPoint1: CGPointMake(16.82, 11.9) controlPoint2: CGPointMake(16.92, 12.2)];
        [bezier5Path addCurveToPoint: CGPointMake(16.92, 14.6) controlPoint1: CGPointMake(16.72, 13.2) controlPoint2: CGPointMake(16.92, 14.4)];
        [bezier5Path addLineToPoint: CGPointMake(16.92, 14.6)];
        [bezier5Path addCurveToPoint: CGPointMake(16.82, 14.7) controlPoint1: CGPointMake(16.92, 14.6) controlPoint2: CGPointMake(16.92, 14.7)];
        [bezier5Path addLineToPoint: CGPointMake(16.82, 14.7)];
        [bezier5Path addLineToPoint: CGPointMake(16.72, 14.7)];
        [bezier5Path addCurveToPoint: CGPointMake(16.22, 12.2) controlPoint1: CGPointMake(16.32, 14.3) controlPoint2: CGPointMake(16.22, 12.8)];
        [bezier5Path addCurveToPoint: CGPointMake(14.52, 11) controlPoint1: CGPointMake(16.22, 11.8) controlPoint2: CGPointMake(15.62, 11)];
        [bezier5Path addCurveToPoint: CGPointMake(14.12, 11) controlPoint1: CGPointMake(14.42, 11) controlPoint2: CGPointMake(14.32, 11)];
        [bezier5Path addCurveToPoint: CGPointMake(12.72, 11.3) controlPoint1: CGPointMake(13.82, 11) controlPoint2: CGPointMake(13.32, 11)];
        [bezier5Path addCurveToPoint: CGPointMake(11.92, 12.5) controlPoint1: CGPointMake(12.22, 11.6) controlPoint2: CGPointMake(11.92, 12)];
        [bezier5Path addCurveToPoint: CGPointMake(13.02, 14.9) controlPoint1: CGPointMake(11.82, 13.6) controlPoint2: CGPointMake(12.92, 14.8)];
        [bezier5Path addCurveToPoint: CGPointMake(13.02, 15) controlPoint1: CGPointMake(13.02, 14.9) controlPoint2: CGPointMake(13.02, 14.9)];
        [bezier5Path addCurveToPoint: CGPointMake(12.92, 15.1) controlPoint1: CGPointMake(13.02, 15) controlPoint2: CGPointMake(13.02, 15.1)];
        [bezier5Path addLineToPoint: CGPointMake(12.92, 15.1)];
        [bezier5Path addCurveToPoint: CGPointMake(12.82, 15.1) controlPoint1: CGPointMake(12.92, 15.1) controlPoint2: CGPointMake(12.92, 15.1)];
        [bezier5Path addCurveToPoint: CGPointMake(11.32, 12.1) controlPoint1: CGPointMake(11.02, 13.8) controlPoint2: CGPointMake(11.22, 12.6)];
        [bezier5Path addCurveToPoint: CGPointMake(10.12, 12) controlPoint1: CGPointMake(10.92, 12.1) controlPoint2: CGPointMake(10.22, 12)];
        [bezier5Path addCurveToPoint: CGPointMake(8.82, 14.3) controlPoint1: CGPointMake(8.62, 12.5) controlPoint2: CGPointMake(8.72, 13.7)];
        [bezier5Path addLineToPoint: CGPointMake(8.82, 14.4)];
        [bezier5Path addCurveToPoint: CGPointMake(8.92, 15.3) controlPoint1: CGPointMake(8.82, 14.9) controlPoint2: CGPointMake(8.92, 15.2)];
        [bezier5Path addCurveToPoint: CGPointMake(9.22, 15) controlPoint1: CGPointMake(9.22, 14.9) controlPoint2: CGPointMake(9.32, 14.9)];
        [bezier5Path addCurveToPoint: CGPointMake(9.22, 15) controlPoint1: CGPointMake(9.32, 15) controlPoint2: CGPointMake(9.22, 15)];
        [bezier5Path closePath];
        [bezier5Path moveToPoint: CGPointMake(7.82, 12.4)];
        [bezier5Path addCurveToPoint: CGPointMake(8.82, 12.5) controlPoint1: CGPointMake(8.12, 12.4) controlPoint2: CGPointMake(8.42, 12.4)];
        [bezier5Path addLineToPoint: CGPointMake(8.92, 12.6)];
        [bezier5Path addCurveToPoint: CGPointMake(9.12, 14.7) controlPoint1: CGPointMake(8.82, 13.1) controlPoint2: CGPointMake(8.72, 14.2)];
        [bezier5Path addCurveToPoint: CGPointMake(9.02, 14) controlPoint1: CGPointMake(9.12, 14.5) controlPoint2: CGPointMake(9.12, 14.3)];
        [bezier5Path addLineToPoint: CGPointMake(9.02, 13.9)];
        [bezier5Path addCurveToPoint: CGPointMake(10.52, 11.4) controlPoint1: CGPointMake(8.92, 13.3) controlPoint2: CGPointMake(8.82, 12)];
        [bezier5Path addLineToPoint: CGPointMake(10.52, 11.4)];
        [bezier5Path addCurveToPoint: CGPointMake(11.62, 11.6) controlPoint1: CGPointMake(10.52, 11.4) controlPoint2: CGPointMake(11.22, 11.6)];
        [bezier5Path addCurveToPoint: CGPointMake(11.82, 11.6) controlPoint1: CGPointMake(11.72, 11.6) controlPoint2: CGPointMake(11.82, 11.6)];
        [bezier5Path addLineToPoint: CGPointMake(11.92, 11.6)];
        [bezier5Path addLineToPoint: CGPointMake(11.92, 11.7)];
        [bezier5Path addCurveToPoint: CGPointMake(12.62, 14) controlPoint1: CGPointMake(11.92, 11.7) controlPoint2: CGPointMake(11.32, 12.7)];
        [bezier5Path addCurveToPoint: CGPointMake(12.02, 12.2) controlPoint1: CGPointMake(12.32, 13.5) controlPoint2: CGPointMake(11.92, 12.8)];
        [bezier5Path addCurveToPoint: CGPointMake(12.92, 10.9) controlPoint1: CGPointMake(12.12, 11.7) controlPoint2: CGPointMake(12.42, 11.2)];
        [bezier5Path addCurveToPoint: CGPointMake(14.32, 10.5) controlPoint1: CGPointMake(13.42, 10.6) controlPoint2: CGPointMake(14.02, 10.5)];
        [bezier5Path addCurveToPoint: CGPointMake(14.72, 10.5) controlPoint1: CGPointMake(14.42, 10.5) controlPoint2: CGPointMake(14.62, 10.5)];
        [bezier5Path addCurveToPoint: CGPointMake(16.62, 11.9) controlPoint1: CGPointMake(15.92, 10.6) controlPoint2: CGPointMake(16.62, 11.4)];
        [bezier5Path addCurveToPoint: CGPointMake(16.82, 13.8) controlPoint1: CGPointMake(16.62, 12.4) controlPoint2: CGPointMake(16.72, 13.2)];
        [bezier5Path addCurveToPoint: CGPointMake(16.82, 12.4) controlPoint1: CGPointMake(16.82, 13.3) controlPoint2: CGPointMake(16.72, 12.7)];
        [bezier5Path addCurveToPoint: CGPointMake(16.62, 11.5) controlPoint1: CGPointMake(16.92, 11.8) controlPoint2: CGPointMake(16.62, 11.5)];
        [bezier5Path addLineToPoint: CGPointMake(16.62, 11.4)];
        [bezier5Path addCurveToPoint: CGPointMake(16.72, 11.3) controlPoint1: CGPointMake(16.62, 11.4) controlPoint2: CGPointMake(16.62, 11.3)];
        [bezier5Path addLineToPoint: CGPointMake(16.72, 11.3)];
        [bezier5Path addLineToPoint: CGPointMake(16.72, 11.3)];
        [bezier5Path addCurveToPoint: CGPointMake(17.92, 10.8) controlPoint1: CGPointMake(16.82, 11.3) controlPoint2: CGPointMake(17.42, 11.3)];
        [bezier5Path addCurveToPoint: CGPointMake(18.62, 9.5) controlPoint1: CGPointMake(18.22, 10.5) controlPoint2: CGPointMake(18.42, 10.1)];
        [bezier5Path addCurveToPoint: CGPointMake(16.72, 11.1) controlPoint1: CGPointMake(18.32, 10.3) controlPoint2: CGPointMake(17.72, 11.1)];
        [bezier5Path addLineToPoint: CGPointMake(16.72, 11.1)];
        [bezier5Path addLineToPoint: CGPointMake(16.62, 11.1)];
        [bezier5Path addLineToPoint: CGPointMake(16.52, 11.1)];
        [bezier5Path addCurveToPoint: CGPointMake(14.92, 10.4) controlPoint1: CGPointMake(16.52, 11.1) controlPoint2: CGPointMake(16.12, 10.5)];
        [bezier5Path addCurveToPoint: CGPointMake(14.82, 10.3) controlPoint1: CGPointMake(14.92, 10.4) controlPoint2: CGPointMake(14.82, 10.4)];
        [bezier5Path addLineToPoint: CGPointMake(14.82, 10.2)];
        [bezier5Path addCurveToPoint: CGPointMake(15.12, 8.5) controlPoint1: CGPointMake(14.82, 10.2) controlPoint2: CGPointMake(15.42, 9.6)];
        [bezier5Path addCurveToPoint: CGPointMake(14.82, 6.7) controlPoint1: CGPointMake(14.92, 7.7) controlPoint2: CGPointMake(14.82, 7.2)];
        [bezier5Path addCurveToPoint: CGPointMake(14.92, 8.4) controlPoint1: CGPointMake(14.72, 7.1) controlPoint2: CGPointMake(14.82, 7.6)];
        [bezier5Path addCurveToPoint: CGPointMake(14.32, 10.2) controlPoint1: CGPointMake(15.02, 8.7) controlPoint2: CGPointMake(15.02, 9.8)];
        [bezier5Path addCurveToPoint: CGPointMake(14.22, 10.2) controlPoint1: CGPointMake(14.32, 10.2) controlPoint2: CGPointMake(14.32, 10.2)];
        [bezier5Path addCurveToPoint: CGPointMake(14.12, 10.2) controlPoint1: CGPointMake(14.22, 10.2) controlPoint2: CGPointMake(14.22, 10.2)];
        [bezier5Path addCurveToPoint: CGPointMake(12.02, 11.2) controlPoint1: CGPointMake(13.82, 10.2) controlPoint2: CGPointMake(12.72, 10.3)];
        [bezier5Path addCurveToPoint: CGPointMake(11.92, 11.2) controlPoint1: CGPointMake(12.02, 11.2) controlPoint2: CGPointMake(12.02, 11.2)];
        [bezier5Path addCurveToPoint: CGPointMake(11.52, 11.2) controlPoint1: CGPointMake(11.92, 11.2) controlPoint2: CGPointMake(11.82, 11.2)];
        [bezier5Path addCurveToPoint: CGPointMake(8.92, 9.2) controlPoint1: CGPointMake(10.82, 11.2) controlPoint2: CGPointMake(9.22, 11)];
        [bezier5Path addCurveToPoint: CGPointMake(9.32, 4.9) controlPoint1: CGPointMake(8.82, 8.8) controlPoint2: CGPointMake(9.02, 6.2)];
        [bezier5Path addCurveToPoint: CGPointMake(8.72, 7.7) controlPoint1: CGPointMake(9.12, 5.4) controlPoint2: CGPointMake(8.82, 6.2)];
        [bezier5Path addCurveToPoint: CGPointMake(9.82, 11.1) controlPoint1: CGPointMake(8.52, 10.3) controlPoint2: CGPointMake(9.82, 11.1)];
        [bezier5Path addCurveToPoint: CGPointMake(9.82, 11.2) controlPoint1: CGPointMake(9.82, 11.1) controlPoint2: CGPointMake(9.82, 11.1)];
        [bezier5Path addLineToPoint: CGPointMake(9.82, 11.3)];
        [bezier5Path addCurveToPoint: CGPointMake(8.82, 12.3) controlPoint1: CGPointMake(9.82, 11.3) controlPoint2: CGPointMake(9.22, 11.6)];
        [bezier5Path addLineToPoint: CGPointMake(8.72, 12.3)];
        [bezier5Path addCurveToPoint: CGPointMake(7.72, 12.2) controlPoint1: CGPointMake(8.72, 12.3) controlPoint2: CGPointMake(8.22, 12.2)];
        [bezier5Path addCurveToPoint: CGPointMake(7.02, 12.3) controlPoint1: CGPointMake(7.42, 12.2) controlPoint2: CGPointMake(7.22, 12.2)];
        [bezier5Path addLineToPoint: CGPointMake(6.92, 12.3)];
        [bezier5Path addLineToPoint: CGPointMake(6.92, 12.2)];
        [bezier5Path addCurveToPoint: CGPointMake(6.82, 11.3) controlPoint1: CGPointMake(6.92, 12.2) controlPoint2: CGPointMake(7.12, 11.7)];
        [bezier5Path addCurveToPoint: CGPointMake(5.42, 10.7) controlPoint1: CGPointMake(6.62, 11) controlPoint2: CGPointMake(6.12, 10.8)];
        [bezier5Path addLineToPoint: CGPointMake(5.32, 10.7)];
        [bezier5Path addLineToPoint: CGPointMake(5.32, 10.6)];
        [bezier5Path addCurveToPoint: CGPointMake(4.62, 9.4) controlPoint1: CGPointMake(5.32, 10.6) controlPoint2: CGPointMake(5.62, 10.1)];
        [bezier5Path addLineToPoint: CGPointMake(4.62, 9.4)];
        [bezier5Path addCurveToPoint: CGPointMake(4.52, 9.3) controlPoint1: CGPointMake(4.62, 9.4) controlPoint2: CGPointMake(4.62, 9.3)];
        [bezier5Path addLineToPoint: CGPointMake(4.52, 9.3)];
        [bezier5Path addCurveToPoint: CGPointMake(5.22, 10.7) controlPoint1: CGPointMake(4.82, 9.4) controlPoint2: CGPointMake(5.42, 9.9)];
        [bezier5Path addCurveToPoint: CGPointMake(5.12, 10.8) controlPoint1: CGPointMake(5.22, 10.7) controlPoint2: CGPointMake(5.22, 10.8)];
        [bezier5Path addCurveToPoint: CGPointMake(4.92, 10.9) controlPoint1: CGPointMake(5.12, 10.8) controlPoint2: CGPointMake(5.02, 10.8)];
        [bezier5Path addCurveToPoint: CGPointMake(5.52, 10.8) controlPoint1: CGPointMake(5.12, 10.8) controlPoint2: CGPointMake(5.32, 10.8)];
        [bezier5Path addCurveToPoint: CGPointMake(6.12, 11) controlPoint1: CGPointMake(5.72, 10.8) controlPoint2: CGPointMake(5.92, 10.9)];
        [bezier5Path addCurveToPoint: CGPointMake(6.72, 11.7) controlPoint1: CGPointMake(6.52, 11.2) controlPoint2: CGPointMake(6.72, 11.5)];
        [bezier5Path addCurveToPoint: CGPointMake(6.42, 12.6) controlPoint1: CGPointMake(6.82, 12) controlPoint2: CGPointMake(6.72, 12.3)];
        [bezier5Path addCurveToPoint: CGPointMake(6.22, 13) controlPoint1: CGPointMake(6.32, 12.7) controlPoint2: CGPointMake(6.22, 12.9)];
        [bezier5Path addCurveToPoint: CGPointMake(7.82, 12.4) controlPoint1: CGPointMake(6.72, 12.7) controlPoint2: CGPointMake(7.12, 12.4)];
        [bezier5Path closePath];
        bezier5Path.miterLimit = 4;
        
        [fillColor setFill];
        [bezier5Path fill];
    }
    
    
    //// Group 4
    {
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
        [bezier6Path moveToPoint: CGPointMake(6.12, 5.5)];
        [bezier6Path addCurveToPoint: CGPointMake(5.82, 6.7) controlPoint1: CGPointMake(6.12, 5.5) controlPoint2: CGPointMake(6.12, 6.2)];
        [bezier6Path addCurveToPoint: CGPointMake(5.92, 9.1) controlPoint1: CGPointMake(5.62, 7.2) controlPoint2: CGPointMake(5.32, 8.3)];
        [bezier6Path addCurveToPoint: CGPointMake(7.52, 10.4) controlPoint1: CGPointMake(6.52, 9.9) controlPoint2: CGPointMake(7.32, 10.5)];
        [bezier6Path addCurveToPoint: CGPointMake(6.22, 8.9) controlPoint1: CGPointMake(7.72, 10.3) controlPoint2: CGPointMake(6.72, 9.8)];
        [bezier6Path addCurveToPoint: CGPointMake(6.22, 6.3) controlPoint1: CGPointMake(5.72, 8) controlPoint2: CGPointMake(5.92, 7)];
        [bezier6Path addCurveToPoint: CGPointMake(6.12, 5.5) controlPoint1: CGPointMake(6.62, 5.6) controlPoint2: CGPointMake(6.32, 5.6)];
        [bezier6Path closePath];
        bezier6Path.miterLimit = 4;
        
        [fillColor setFill];
        [bezier6Path fill];
    }
    
    
    //// Group 5
    {
        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
        [bezier7Path moveToPoint: CGPointMake(2.22, 6)];
        [bezier7Path addCurveToPoint: CGPointMake(1.82, 8.4) controlPoint1: CGPointMake(2.22, 6) controlPoint2: CGPointMake(1.12, 7.5)];
        [bezier7Path addCurveToPoint: CGPointMake(3.02, 8.9) controlPoint1: CGPointMake(2.32, 8.9) controlPoint2: CGPointMake(3.02, 8.9)];
        [bezier7Path addCurveToPoint: CGPointMake(4.52, 6.5) controlPoint1: CGPointMake(3.02, 8.9) controlPoint2: CGPointMake(2.42, 6.4)];
        [bezier7Path addCurveToPoint: CGPointMake(5.32, 4) controlPoint1: CGPointMake(4.52, 6.5) controlPoint2: CGPointMake(4.22, 5)];
        [bezier7Path addCurveToPoint: CGPointMake(4.52, 3.6) controlPoint1: CGPointMake(5.32, 4) controlPoint2: CGPointMake(4.72, 3.9)];
        [bezier7Path addCurveToPoint: CGPointMake(5.72, 3.7) controlPoint1: CGPointMake(4.52, 3.6) controlPoint2: CGPointMake(5.62, 3.7)];
        [bezier7Path addCurveToPoint: CGPointMake(7.22, 3.5) controlPoint1: CGPointMake(5.82, 3.6) controlPoint2: CGPointMake(6.02, 3.3)];
        [bezier7Path addCurveToPoint: CGPointMake(7.02, 3) controlPoint1: CGPointMake(7.22, 3.5) controlPoint2: CGPointMake(7.42, 3.1)];
        [bezier7Path addCurveToPoint: CGPointMake(5.42, 2.5) controlPoint1: CGPointMake(6.62, 2.9) controlPoint2: CGPointMake(5.82, 2.7)];
        [bezier7Path addCurveToPoint: CGPointMake(3.62, 3.3) controlPoint1: CGPointMake(5.02, 2.3) controlPoint2: CGPointMake(4.12, 2.4)];
        [bezier7Path addCurveToPoint: CGPointMake(2.82, 4.7) controlPoint1: CGPointMake(3.12, 4.1) controlPoint2: CGPointMake(3.32, 4.5)];
        [bezier7Path addCurveToPoint: CGPointMake(1.42, 7.1) controlPoint1: CGPointMake(2.32, 4.9) controlPoint2: CGPointMake(1.02, 5.1)];
        [bezier7Path addCurveToPoint: CGPointMake(2.22, 6) controlPoint1: CGPointMake(1.42, 7.2) controlPoint2: CGPointMake(1.62, 6.2)];
        [bezier7Path closePath];
        bezier7Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier7Path fill];
    }
    
    
    //// Group 6
    {
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(6.22, 2.4)];
        [bezier8Path addCurveToPoint: CGPointMake(6.92, 1.7) controlPoint1: CGPointMake(6.22, 2.4) controlPoint2: CGPointMake(5.82, 1.7)];
        [bezier8Path addCurveToPoint: CGPointMake(8.22, 2.4) controlPoint1: CGPointMake(8.02, 1.7) controlPoint2: CGPointMake(8.22, 2.4)];
        [bezier8Path addCurveToPoint: CGPointMake(8.22, 1.4) controlPoint1: CGPointMake(8.22, 2.4) controlPoint2: CGPointMake(8.62, 1.8)];
        [bezier8Path addCurveToPoint: CGPointMake(9.22, 1) controlPoint1: CGPointMake(8.22, 1.4) controlPoint2: CGPointMake(8.62, 0.8)];
        [bezier8Path addCurveToPoint: CGPointMake(9.32, 1.3) controlPoint1: CGPointMake(9.22, 1) controlPoint2: CGPointMake(9.12, 1.2)];
        [bezier8Path addCurveToPoint: CGPointMake(8.72, 1.6) controlPoint1: CGPointMake(9.32, 1.3) controlPoint2: CGPointMake(8.72, 1.4)];
        [bezier8Path addCurveToPoint: CGPointMake(9.62, 1.6) controlPoint1: CGPointMake(8.72, 1.7) controlPoint2: CGPointMake(9.42, 1.7)];
        [bezier8Path addCurveToPoint: CGPointMake(9.72, 0.9) controlPoint1: CGPointMake(9.82, 1.4) controlPoint2: CGPointMake(9.42, 1.1)];
        [bezier8Path addCurveToPoint: CGPointMake(11.32, 0.8) controlPoint1: CGPointMake(10.02, 0.7) controlPoint2: CGPointMake(10.72, 0.5)];
        [bezier8Path addLineToPoint: CGPointMake(11.32, 1.1)];
        [bezier8Path addCurveToPoint: CGPointMake(10.62, 1.1) controlPoint1: CGPointMake(11.32, 1.1) controlPoint2: CGPointMake(10.72, 0.8)];
        [bezier8Path addCurveToPoint: CGPointMake(11.92, 1.5) controlPoint1: CGPointMake(10.62, 1.3) controlPoint2: CGPointMake(11.32, 1.3)];
        [bezier8Path addCurveToPoint: CGPointMake(12.12, 1.2) controlPoint1: CGPointMake(12.52, 1.7) controlPoint2: CGPointMake(12.12, 1.3)];
        [bezier8Path addCurveToPoint: CGPointMake(11.82, 1.2) controlPoint1: CGPointMake(12.12, 1.1) controlPoint2: CGPointMake(11.92, 1.2)];
        [bezier8Path addCurveToPoint: CGPointMake(12.52, 0.6) controlPoint1: CGPointMake(11.72, 1.2) controlPoint2: CGPointMake(11.72, 0.7)];
        [bezier8Path addCurveToPoint: CGPointMake(15.12, 1.7) controlPoint1: CGPointMake(13.32, 0.5) controlPoint2: CGPointMake(14.82, 0.6)];
        [bezier8Path addCurveToPoint: CGPointMake(14.32, 1.8) controlPoint1: CGPointMake(15.12, 1.7) controlPoint2: CGPointMake(15.02, 1.7)];
        [bezier8Path addCurveToPoint: CGPointMake(13.52, 2.3) controlPoint1: CGPointMake(13.72, 1.9) controlPoint2: CGPointMake(13.72, 2.3)];
        [bezier8Path addCurveToPoint: CGPointMake(13.12, 2.2) controlPoint1: CGPointMake(13.32, 2.3) controlPoint2: CGPointMake(13.22, 2)];
        [bezier8Path addCurveToPoint: CGPointMake(13.62, 2.4) controlPoint1: CGPointMake(13.02, 2.4) controlPoint2: CGPointMake(13.52, 2.6)];
        [bezier8Path addCurveToPoint: CGPointMake(15.12, 2.1) controlPoint1: CGPointMake(13.82, 2.2) controlPoint2: CGPointMake(14.42, 1.9)];
        [bezier8Path addCurveToPoint: CGPointMake(15.92, 2.1) controlPoint1: CGPointMake(15.92, 2.3) controlPoint2: CGPointMake(16.12, 2.3)];
        [bezier8Path addCurveToPoint: CGPointMake(15.32, 1.8) controlPoint1: CGPointMake(15.82, 1.8) controlPoint2: CGPointMake(15.52, 1.8)];
        [bezier8Path addCurveToPoint: CGPointMake(15.32, 1.4) controlPoint1: CGPointMake(15.32, 1.8) controlPoint2: CGPointMake(15.42, 1.6)];
        [bezier8Path addCurveToPoint: CGPointMake(17.32, 2.4) controlPoint1: CGPointMake(15.32, 1.4) controlPoint2: CGPointMake(16.62, 0.9)];
        [bezier8Path addCurveToPoint: CGPointMake(16.82, 2.7) controlPoint1: CGPointMake(17.32, 2.4) controlPoint2: CGPointMake(16.92, 2.7)];
        [bezier8Path addCurveToPoint: CGPointMake(18.32, 3.1) controlPoint1: CGPointMake(16.72, 2.7) controlPoint2: CGPointMake(17.42, 2.8)];
        [bezier8Path addCurveToPoint: CGPointMake(19.42, 4.2) controlPoint1: CGPointMake(19.12, 3.4) controlPoint2: CGPointMake(19.42, 3.7)];
        [bezier8Path addLineToPoint: CGPointMake(18.72, 4)];
        [bezier8Path addCurveToPoint: CGPointMake(18.32, 4) controlPoint1: CGPointMake(18.72, 4) controlPoint2: CGPointMake(18.72, 3.7)];
        [bezier8Path addCurveToPoint: CGPointMake(18.62, 4.6) controlPoint1: CGPointMake(17.92, 4.3) controlPoint2: CGPointMake(18.42, 4.6)];
        [bezier8Path addCurveToPoint: CGPointMake(18.82, 4.4) controlPoint1: CGPointMake(18.82, 4.6) controlPoint2: CGPointMake(18.02, 4.2)];
        [bezier8Path addCurveToPoint: CGPointMake(20.02, 6) controlPoint1: CGPointMake(19.62, 4.6) controlPoint2: CGPointMake(20.52, 4.8)];
        [bezier8Path addCurveToPoint: CGPointMake(20.52, 5.7) controlPoint1: CGPointMake(20.02, 6) controlPoint2: CGPointMake(20.32, 6.1)];
        [bezier8Path addCurveToPoint: CGPointMake(21.72, 6.3) controlPoint1: CGPointMake(20.52, 5.7) controlPoint2: CGPointMake(21.62, 5.5)];
        [bezier8Path addCurveToPoint: CGPointMake(21.42, 7.5) controlPoint1: CGPointMake(21.82, 7.1) controlPoint2: CGPointMake(21.12, 7.3)];
        [bezier8Path addCurveToPoint: CGPointMake(21.92, 7.3) controlPoint1: CGPointMake(21.72, 7.7) controlPoint2: CGPointMake(21.82, 7.4)];
        [bezier8Path addCurveToPoint: CGPointMake(22.32, 9.3) controlPoint1: CGPointMake(21.92, 7.2) controlPoint2: CGPointMake(22.92, 7.7)];
        [bezier8Path addCurveToPoint: CGPointMake(21.22, 8) controlPoint1: CGPointMake(22.32, 9.3) controlPoint2: CGPointMake(22.02, 8)];
        [bezier8Path addCurveToPoint: CGPointMake(20.62, 8.3) controlPoint1: CGPointMake(21.22, 8) controlPoint2: CGPointMake(21.02, 7.9)];
        [bezier8Path addCurveToPoint: CGPointMake(20.42, 7.5) controlPoint1: CGPointMake(20.62, 8.3) controlPoint2: CGPointMake(20.52, 7.6)];
        [bezier8Path addCurveToPoint: CGPointMake(20.72, 7.1) controlPoint1: CGPointMake(20.42, 7.3) controlPoint2: CGPointMake(20.62, 7.2)];
        [bezier8Path addCurveToPoint: CGPointMake(20.42, 6.9) controlPoint1: CGPointMake(20.92, 7) controlPoint2: CGPointMake(20.62, 6.8)];
        [bezier8Path addCurveToPoint: CGPointMake(19.92, 6.6) controlPoint1: CGPointMake(20.22, 7) controlPoint2: CGPointMake(20.22, 7)];
        [bezier8Path addCurveToPoint: CGPointMake(17.42, 5.1) controlPoint1: CGPointMake(19.62, 6.1) controlPoint2: CGPointMake(19.02, 5.1)];
        [bezier8Path addCurveToPoint: CGPointMake(16.42, 3) controlPoint1: CGPointMake(17.42, 5.1) controlPoint2: CGPointMake(18.12, 3.7)];
        [bezier8Path addCurveToPoint: CGPointMake(13.32, 3.6) controlPoint1: CGPointMake(14.72, 2.3) controlPoint2: CGPointMake(14.02, 2.7)];
        [bezier8Path addCurveToPoint: CGPointMake(11.12, 2.1) controlPoint1: CGPointMake(13.32, 3.6) controlPoint2: CGPointMake(13.72, 2.3)];
        [bezier8Path addCurveToPoint: CGPointMake(9.12, 2.3) controlPoint1: CGPointMake(10.22, 2) controlPoint2: CGPointMake(9.52, 2.1)];
        [bezier8Path addCurveToPoint: CGPointMake(8.42, 3.4) controlPoint1: CGPointMake(8.52, 2.7) controlPoint2: CGPointMake(8.42, 3.2)];
        [bezier8Path addCurveToPoint: CGPointMake(8.42, 4.3) controlPoint1: CGPointMake(8.42, 3.7) controlPoint2: CGPointMake(8.42, 4.3)];
        [bezier8Path addCurveToPoint: CGPointMake(7.82, 4) controlPoint1: CGPointMake(8.42, 4.3) controlPoint2: CGPointMake(8.12, 4)];
        [bezier8Path addCurveToPoint: CGPointMake(7.52, 3.1) controlPoint1: CGPointMake(7.82, 4) controlPoint2: CGPointMake(8.22, 3.3)];
        [bezier8Path addCurveToPoint: CGPointMake(6.22, 2.4) controlPoint1: CGPointMake(6.62, 2.6) controlPoint2: CGPointMake(6.22, 2.4)];
        [bezier8Path closePath];
        bezier8Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier8Path fill];
    }
    
    
    //// Group 7
    {
        //// Bezier 9 Drawing
        UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
        [bezier9Path moveToPoint: CGPointMake(21.02, 11)];
        [bezier9Path addCurveToPoint: CGPointMake(19.92, 12.1) controlPoint1: CGPointMake(21.02, 11) controlPoint2: CGPointMake(20.82, 11.8)];
        [bezier9Path addCurveToPoint: CGPointMake(18.32, 12.2) controlPoint1: CGPointMake(19.12, 12.4) controlPoint2: CGPointMake(18.42, 12)];
        [bezier9Path addCurveToPoint: CGPointMake(19.62, 12.5) controlPoint1: CGPointMake(18.22, 12.4) controlPoint2: CGPointMake(18.92, 12.7)];
        [bezier9Path addCurveToPoint: CGPointMake(21.22, 11.2) controlPoint1: CGPointMake(20.22, 12.3) controlPoint2: CGPointMake(21.02, 12.1)];
        [bezier9Path addCurveToPoint: CGPointMake(21.02, 11) controlPoint1: CGPointMake(21.22, 11.3) controlPoint2: CGPointMake(21.22, 10.8)];
        [bezier9Path closePath];
        bezier9Path.miterLimit = 4;
        
        [fillColor setFill];
        [bezier9Path fill];
    }
    
    
    //// Group 8
    {
        //// Bezier 10 Drawing
        UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
        [bezier10Path moveToPoint: CGPointMake(13.02, 0.6)];
        [bezier10Path addCurveToPoint: CGPointMake(13.22, 0.6) controlPoint1: CGPointMake(13.02, 0.6) controlPoint2: CGPointMake(13.12, 0.6)];
        [bezier10Path addCurveToPoint: CGPointMake(14.92, 1.2) controlPoint1: CGPointMake(14.02, 0.7) controlPoint2: CGPointMake(14.62, 0.9)];
        [bezier10Path addLineToPoint: CGPointMake(15.12, 1.4)];
        [bezier10Path addLineToPoint: CGPointMake(15.32, 1.3)];
        [bezier10Path addCurveToPoint: CGPointMake(15.92, 1.2) controlPoint1: CGPointMake(15.32, 1.3) controlPoint2: CGPointMake(15.62, 1.2)];
        [bezier10Path addCurveToPoint: CGPointMake(17.42, 2.3) controlPoint1: CGPointMake(16.72, 1.2) controlPoint2: CGPointMake(17.22, 1.6)];
        [bezier10Path addLineToPoint: CGPointMake(17.52, 2.5)];
        [bezier10Path addLineToPoint: CGPointMake(17.72, 2.6)];
        [bezier10Path addCurveToPoint: CGPointMake(18.42, 2.8) controlPoint1: CGPointMake(17.72, 2.6) controlPoint2: CGPointMake(18.12, 2.7)];
        [bezier10Path addLineToPoint: CGPointMake(18.42, 2.8)];
        [bezier10Path addCurveToPoint: CGPointMake(19.32, 3.9) controlPoint1: CGPointMake(19.12, 3) controlPoint2: CGPointMake(19.42, 3.1)];
        [bezier10Path addLineToPoint: CGPointMake(19.22, 4.3)];
        [bezier10Path addLineToPoint: CGPointMake(19.62, 4.3)];
        [bezier10Path addCurveToPoint: CGPointMake(19.92, 4.4) controlPoint1: CGPointMake(19.62, 4.3) controlPoint2: CGPointMake(19.72, 4.3)];
        [bezier10Path addCurveToPoint: CGPointMake(20.12, 4.9) controlPoint1: CGPointMake(20.02, 4.5) controlPoint2: CGPointMake(20.12, 4.6)];
        [bezier10Path addLineToPoint: CGPointMake(20.12, 5.4)];
        [bezier10Path addLineToPoint: CGPointMake(20.62, 5.3)];
        [bezier10Path addCurveToPoint: CGPointMake(20.82, 5.3) controlPoint1: CGPointMake(20.62, 5.3) controlPoint2: CGPointMake(20.72, 5.3)];
        [bezier10Path addCurveToPoint: CGPointMake(21.62, 5.6) controlPoint1: CGPointMake(21.02, 5.3) controlPoint2: CGPointMake(21.42, 5.3)];
        [bezier10Path addCurveToPoint: CGPointMake(21.72, 6.4) controlPoint1: CGPointMake(21.72, 5.8) controlPoint2: CGPointMake(21.82, 6)];
        [bezier10Path addLineToPoint: CGPointMake(21.62, 6.8)];
        [bezier10Path addLineToPoint: CGPointMake(22.02, 6.8)];
        [bezier10Path addCurveToPoint: CGPointMake(22.42, 7.8) controlPoint1: CGPointMake(22.12, 6.8) controlPoint2: CGPointMake(22.52, 6.9)];
        [bezier10Path addCurveToPoint: CGPointMake(22.32, 8.8) controlPoint1: CGPointMake(22.42, 8.4) controlPoint2: CGPointMake(22.32, 8.7)];
        [bezier10Path addCurveToPoint: CGPointMake(22.22, 9) controlPoint1: CGPointMake(22.32, 8.9) controlPoint2: CGPointMake(22.22, 9)];
        [bezier10Path addCurveToPoint: CGPointMake(22.12, 9) controlPoint1: CGPointMake(22.22, 9) controlPoint2: CGPointMake(22.22, 9)];
        [bezier10Path addLineToPoint: CGPointMake(21.92, 9.2)];
        [bezier10Path addLineToPoint: CGPointMake(22.02, 9.4)];
        [bezier10Path addCurveToPoint: CGPointMake(22.12, 11.3) controlPoint1: CGPointMake(22.12, 9.7) controlPoint2: CGPointMake(22.32, 10.7)];
        [bezier10Path addCurveToPoint: CGPointMake(20.52, 12.9) controlPoint1: CGPointMake(21.82, 12) controlPoint2: CGPointMake(21.32, 12.4)];
        [bezier10Path addCurveToPoint: CGPointMake(19.42, 14) controlPoint1: CGPointMake(19.82, 13.3) controlPoint2: CGPointMake(19.62, 13.6)];
        [bezier10Path addCurveToPoint: CGPointMake(19.22, 14.4) controlPoint1: CGPointMake(19.32, 14.1) controlPoint2: CGPointMake(19.32, 14.3)];
        [bezier10Path addCurveToPoint: CGPointMake(18.52, 15) controlPoint1: CGPointMake(19.12, 14.6) controlPoint2: CGPointMake(18.82, 14.9)];
        [bezier10Path addCurveToPoint: CGPointMake(16.72, 15.4) controlPoint1: CGPointMake(18.22, 15.2) controlPoint2: CGPointMake(17.02, 15.5)];
        [bezier10Path addCurveToPoint: CGPointMake(15.72, 15.1) controlPoint1: CGPointMake(16.12, 15.3) controlPoint2: CGPointMake(15.72, 15.1)];
        [bezier10Path addLineToPoint: CGPointMake(15.62, 15.1)];
        [bezier10Path addLineToPoint: CGPointMake(15.52, 15.1)];
        [bezier10Path addLineToPoint: CGPointMake(15.22, 15.1)];
        [bezier10Path addLineToPoint: CGPointMake(15.22, 15.5)];
        [bezier10Path addCurveToPoint: CGPointMake(14.92, 16.1) controlPoint1: CGPointMake(15.22, 15.5) controlPoint2: CGPointMake(15.22, 15.8)];
        [bezier10Path addCurveToPoint: CGPointMake(13.12, 16.8) controlPoint1: CGPointMake(14.62, 16.5) controlPoint2: CGPointMake(13.92, 16.8)];
        [bezier10Path addCurveToPoint: CGPointMake(12.82, 16.8) controlPoint1: CGPointMake(13.02, 16.8) controlPoint2: CGPointMake(12.92, 16.8)];
        [bezier10Path addLineToPoint: CGPointMake(12.82, 16.8)];
        [bezier10Path addLineToPoint: CGPointMake(12.82, 16.8)];
        [bezier10Path addCurveToPoint: CGPointMake(11.02, 16.3) controlPoint1: CGPointMake(12.12, 16.8) controlPoint2: CGPointMake(11.32, 16.6)];
        [bezier10Path addLineToPoint: CGPointMake(10.82, 16.1)];
        [bezier10Path addLineToPoint: CGPointMake(10.62, 16.2)];
        [bezier10Path addCurveToPoint: CGPointMake(10.02, 16.3) controlPoint1: CGPointMake(10.62, 16.2) controlPoint2: CGPointMake(10.32, 16.3)];
        [bezier10Path addCurveToPoint: CGPointMake(8.22, 15.3) controlPoint1: CGPointMake(9.22, 16.3) controlPoint2: CGPointMake(8.62, 16)];
        [bezier10Path addLineToPoint: CGPointMake(8.12, 15)];
        [bezier10Path addLineToPoint: CGPointMake(7.82, 15.1)];
        [bezier10Path addCurveToPoint: CGPointMake(6.82, 15.2) controlPoint1: CGPointMake(7.82, 15.1) controlPoint2: CGPointMake(7.42, 15.2)];
        [bezier10Path addCurveToPoint: CGPointMake(5.42, 14.9) controlPoint1: CGPointMake(6.32, 15.2) controlPoint2: CGPointMake(5.82, 15.1)];
        [bezier10Path addCurveToPoint: CGPointMake(4.62, 13.7) controlPoint1: CGPointMake(4.92, 14.7) controlPoint2: CGPointMake(4.72, 14.3)];
        [bezier10Path addLineToPoint: CGPointMake(4.52, 13.1)];
        [bezier10Path addLineToPoint: CGPointMake(4.02, 13.4)];
        [bezier10Path addCurveToPoint: CGPointMake(3.22, 13.6) controlPoint1: CGPointMake(4.02, 13.4) controlPoint2: CGPointMake(3.72, 13.6)];
        [bezier10Path addCurveToPoint: CGPointMake(2.02, 12.9) controlPoint1: CGPointMake(2.82, 13.6) controlPoint2: CGPointMake(2.32, 13.4)];
        [bezier10Path addLineToPoint: CGPointMake(2.02, 12.9)];
        [bezier10Path addLineToPoint: CGPointMake(2.02, 12.9)];
        [bezier10Path addCurveToPoint: CGPointMake(1.82, 11.8) controlPoint1: CGPointMake(1.92, 12.8) controlPoint2: CGPointMake(1.72, 12.1)];
        [bezier10Path addLineToPoint: CGPointMake(1.92, 11.5)];
        [bezier10Path addLineToPoint: CGPointMake(1.62, 11.4)];
        [bezier10Path addCurveToPoint: CGPointMake(0.72, 10) controlPoint1: CGPointMake(1.62, 11.4) controlPoint2: CGPointMake(0.82, 11)];
        [bezier10Path addCurveToPoint: CGPointMake(1.32, 8.2) controlPoint1: CGPointMake(0.72, 9.2) controlPoint2: CGPointMake(1.02, 8.7)];
        [bezier10Path addCurveToPoint: CGPointMake(1.62, 7.6) controlPoint1: CGPointMake(1.42, 8) controlPoint2: CGPointMake(1.52, 7.8)];
        [bezier10Path addCurveToPoint: CGPointMake(1.62, 6.9) controlPoint1: CGPointMake(1.72, 7.4) controlPoint2: CGPointMake(1.72, 7.3)];
        [bezier10Path addCurveToPoint: CGPointMake(1.62, 5.5) controlPoint1: CGPointMake(1.52, 6.5) controlPoint2: CGPointMake(1.42, 5.9)];
        [bezier10Path addCurveToPoint: CGPointMake(2.32, 4.9) controlPoint1: CGPointMake(1.72, 5.2) controlPoint2: CGPointMake(2.02, 5.1)];
        [bezier10Path addCurveToPoint: CGPointMake(2.92, 4.5) controlPoint1: CGPointMake(2.52, 4.8) controlPoint2: CGPointMake(2.82, 4.7)];
        [bezier10Path addCurveToPoint: CGPointMake(3.42, 3.7) controlPoint1: CGPointMake(3.12, 4.3) controlPoint2: CGPointMake(3.22, 4)];
        [bezier10Path addCurveToPoint: CGPointMake(4.22, 2.5) controlPoint1: CGPointMake(3.62, 3.3) controlPoint2: CGPointMake(3.82, 2.8)];
        [bezier10Path addCurveToPoint: CGPointMake(5.02, 2.2) controlPoint1: CGPointMake(4.52, 2.3) controlPoint2: CGPointMake(4.82, 2.2)];
        [bezier10Path addCurveToPoint: CGPointMake(5.62, 2.3) controlPoint1: CGPointMake(5.32, 2.2) controlPoint2: CGPointMake(5.52, 2.3)];
        [bezier10Path addCurveToPoint: CGPointMake(5.52, 2.2) controlPoint1: CGPointMake(5.62, 2.3) controlPoint2: CGPointMake(5.62, 2.3)];
        [bezier10Path addLineToPoint: CGPointMake(6.22, 1.9)];
        [bezier10Path addCurveToPoint: CGPointMake(6.22, 1.8) controlPoint1: CGPointMake(6.22, 1.9) controlPoint2: CGPointMake(6.22, 1.9)];
        [bezier10Path addCurveToPoint: CGPointMake(6.42, 1.6) controlPoint1: CGPointMake(6.22, 1.8) controlPoint2: CGPointMake(6.22, 1.7)];
        [bezier10Path addCurveToPoint: CGPointMake(7.02, 1.5) controlPoint1: CGPointMake(6.52, 1.5) controlPoint2: CGPointMake(6.72, 1.5)];
        [bezier10Path addCurveToPoint: CGPointMake(7.72, 1.6) controlPoint1: CGPointMake(7.32, 1.5) controlPoint2: CGPointMake(7.62, 1.6)];
        [bezier10Path addLineToPoint: CGPointMake(7.72, 1.6)];
        [bezier10Path addLineToPoint: CGPointMake(8.02, 1.7)];
        [bezier10Path addLineToPoint: CGPointMake(8.12, 1.4)];
        [bezier10Path addCurveToPoint: CGPointMake(9.22, 0.8) controlPoint1: CGPointMake(8.12, 1.4) controlPoint2: CGPointMake(8.52, 0.8)];
        [bezier10Path addCurveToPoint: CGPointMake(9.42, 0.8) controlPoint1: CGPointMake(9.32, 0.8) controlPoint2: CGPointMake(9.32, 0.8)];
        [bezier10Path addLineToPoint: CGPointMake(9.52, 0.8)];
        [bezier10Path addLineToPoint: CGPointMake(9.62, 0.7)];
        [bezier10Path addCurveToPoint: CGPointMake(10.52, 0.5) controlPoint1: CGPointMake(9.62, 0.7) controlPoint2: CGPointMake(10.02, 0.5)];
        [bezier10Path addCurveToPoint: CGPointMake(11.32, 0.7) controlPoint1: CGPointMake(10.82, 0.5) controlPoint2: CGPointMake(11.12, 0.6)];
        [bezier10Path addLineToPoint: CGPointMake(11.52, 0.8)];
        [bezier10Path addLineToPoint: CGPointMake(11.72, 0.7)];
        [bezier10Path addCurveToPoint: CGPointMake(13.02, 0.6) controlPoint1: CGPointMake(11.82, 1) controlPoint2: CGPointMake(12.32, 0.6)];
        [bezier10Path closePath];
        [bezier10Path moveToPoint: CGPointMake(13.02, 0.1)];
        [bezier10Path addCurveToPoint: CGPointMake(11.62, 0.5) controlPoint1: CGPointMake(12.22, 0.1) controlPoint2: CGPointMake(11.62, 0.5)];
        [bezier10Path addCurveToPoint: CGPointMake(10.62, 0.2) controlPoint1: CGPointMake(11.22, 0.3) controlPoint2: CGPointMake(10.92, 0.2)];
        [bezier10Path addCurveToPoint: CGPointMake(9.52, 0.5) controlPoint1: CGPointMake(9.92, 0.2) controlPoint2: CGPointMake(9.52, 0.5)];
        [bezier10Path addCurveToPoint: CGPointMake(9.32, 0.5) controlPoint1: CGPointMake(9.42, 0.5) controlPoint2: CGPointMake(9.42, 0.5)];
        [bezier10Path addCurveToPoint: CGPointMake(7.82, 1.3) controlPoint1: CGPointMake(8.32, 0.5) controlPoint2: CGPointMake(7.82, 1.3)];
        [bezier10Path addCurveToPoint: CGPointMake(6.92, 1.2) controlPoint1: CGPointMake(7.62, 1.3) controlPoint2: CGPointMake(7.32, 1.2)];
        [bezier10Path addCurveToPoint: CGPointMake(6.12, 1.4) controlPoint1: CGPointMake(6.62, 1.2) controlPoint2: CGPointMake(6.42, 1.2)];
        [bezier10Path addCurveToPoint: CGPointMake(5.72, 2.2) controlPoint1: CGPointMake(5.62, 1.7) controlPoint2: CGPointMake(5.72, 2.2)];
        [bezier10Path addCurveToPoint: CGPointMake(4.82, 1.9) controlPoint1: CGPointMake(5.62, 2.1) controlPoint2: CGPointMake(5.32, 1.9)];
        [bezier10Path addCurveToPoint: CGPointMake(3.82, 2.2) controlPoint1: CGPointMake(4.52, 1.9) controlPoint2: CGPointMake(4.12, 2)];
        [bezier10Path addCurveToPoint: CGPointMake(2.52, 4.3) controlPoint1: CGPointMake(3.02, 2.8) controlPoint2: CGPointMake(2.82, 3.9)];
        [bezier10Path addCurveToPoint: CGPointMake(1.12, 5.4) controlPoint1: CGPointMake(2.12, 4.7) controlPoint2: CGPointMake(1.42, 4.6)];
        [bezier10Path addCurveToPoint: CGPointMake(1.12, 7.5) controlPoint1: CGPointMake(0.82, 6.2) controlPoint2: CGPointMake(1.22, 7.3)];
        [bezier10Path addCurveToPoint: CGPointMake(0.12, 10.1) controlPoint1: CGPointMake(0.82, 8.2) controlPoint2: CGPointMake(0.02, 8.8)];
        [bezier10Path addCurveToPoint: CGPointMake(1.22, 11.9) controlPoint1: CGPointMake(0.22, 11.4) controlPoint2: CGPointMake(1.22, 11.9)];
        [bezier10Path addCurveToPoint: CGPointMake(1.52, 13.4) controlPoint1: CGPointMake(1.12, 12.4) controlPoint2: CGPointMake(1.32, 13.2)];
        [bezier10Path addCurveToPoint: CGPointMake(3.02, 14.3) controlPoint1: CGPointMake(2.02, 14.1) controlPoint2: CGPointMake(2.62, 14.3)];
        [bezier10Path addCurveToPoint: CGPointMake(4.02, 14) controlPoint1: CGPointMake(3.62, 14.3) controlPoint2: CGPointMake(4.02, 14)];
        [bezier10Path addCurveToPoint: CGPointMake(6.62, 15.8) controlPoint1: CGPointMake(4.32, 15.5) controlPoint2: CGPointMake(5.72, 15.8)];
        [bezier10Path addCurveToPoint: CGPointMake(7.72, 15.7) controlPoint1: CGPointMake(7.22, 15.8) controlPoint2: CGPointMake(7.72, 15.7)];
        [bezier10Path addCurveToPoint: CGPointMake(9.82, 16.9) controlPoint1: CGPointMake(8.32, 16.7) controlPoint2: CGPointMake(9.22, 16.9)];
        [bezier10Path addCurveToPoint: CGPointMake(10.62, 16.8) controlPoint1: CGPointMake(10.22, 16.9) controlPoint2: CGPointMake(10.62, 16.8)];
        [bezier10Path addCurveToPoint: CGPointMake(12.82, 17.5) controlPoint1: CGPointMake(11.12, 17.4) controlPoint2: CGPointMake(12.32, 17.5)];
        [bezier10Path addCurveToPoint: CGPointMake(13.12, 17.5) controlPoint1: CGPointMake(12.92, 17.5) controlPoint2: CGPointMake(13.02, 17.5)];
        [bezier10Path addCurveToPoint: CGPointMake(15.62, 15.9) controlPoint1: CGPointMake(15.42, 17.5) controlPoint2: CGPointMake(15.62, 15.9)];
        [bezier10Path addLineToPoint: CGPointMake(15.62, 15.9)];
        [bezier10Path addCurveToPoint: CGPointMake(16.72, 16.3) controlPoint1: CGPointMake(15.62, 15.9) controlPoint2: CGPointMake(16.12, 16.2)];
        [bezier10Path addCurveToPoint: CGPointMake(18.82, 15.8) controlPoint1: CGPointMake(16.92, 16.3) controlPoint2: CGPointMake(17.52, 16.6)];
        [bezier10Path addCurveToPoint: CGPointMake(19.62, 15) controlPoint1: CGPointMake(19.12, 15.6) controlPoint2: CGPointMake(19.42, 15.3)];
        [bezier10Path addCurveToPoint: CGPointMake(20.82, 13.6) controlPoint1: CGPointMake(20.02, 14.4) controlPoint2: CGPointMake(19.82, 14.1)];
        [bezier10Path addCurveToPoint: CGPointMake(22.72, 11.8) controlPoint1: CGPointMake(21.72, 13.1) controlPoint2: CGPointMake(22.32, 12.6)];
        [bezier10Path addCurveToPoint: CGPointMake(22.62, 9.6) controlPoint1: CGPointMake(23.02, 11) controlPoint2: CGPointMake(22.62, 9.6)];
        [bezier10Path addCurveToPoint: CGPointMake(23.02, 8) controlPoint1: CGPointMake(22.72, 9.5) controlPoint2: CGPointMake(23.02, 9.3)];
        [bezier10Path addCurveToPoint: CGPointMake(22.22, 6.6) controlPoint1: CGPointMake(23.02, 6.7) controlPoint2: CGPointMake(22.22, 6.6)];
        [bezier10Path addCurveToPoint: CGPointMake(20.92, 5) controlPoint1: CGPointMake(22.42, 5.2) controlPoint2: CGPointMake(21.32, 5)];
        [bezier10Path addCurveToPoint: CGPointMake(20.72, 5) controlPoint1: CGPointMake(20.82, 5) controlPoint2: CGPointMake(20.72, 5)];
        [bezier10Path addCurveToPoint: CGPointMake(19.92, 4) controlPoint1: CGPointMake(20.72, 4) controlPoint2: CGPointMake(19.92, 4)];
        [bezier10Path addCurveToPoint: CGPointMake(18.72, 2.4) controlPoint1: CGPointMake(20.12, 2.8) controlPoint2: CGPointMake(19.42, 2.6)];
        [bezier10Path addCurveToPoint: CGPointMake(18.02, 2.2) controlPoint1: CGPointMake(18.32, 2.3) controlPoint2: CGPointMake(18.02, 2.2)];
        [bezier10Path addCurveToPoint: CGPointMake(16.12, 0.7) controlPoint1: CGPointMake(17.72, 1) controlPoint2: CGPointMake(16.72, 0.7)];
        [bezier10Path addCurveToPoint: CGPointMake(15.42, 0.8) controlPoint1: CGPointMake(15.72, 0.7) controlPoint2: CGPointMake(15.42, 0.8)];
        [bezier10Path addCurveToPoint: CGPointMake(13.42, 0) controlPoint1: CGPointMake(15.02, 0.4) controlPoint2: CGPointMake(14.32, 0.1)];
        [bezier10Path addCurveToPoint: CGPointMake(13.02, 0.1) controlPoint1: CGPointMake(13.12, 0.1) controlPoint2: CGPointMake(13.12, 0.1)];
        [bezier10Path addLineToPoint: CGPointMake(13.02, 0.1)];
        [bezier10Path closePath];
        bezier10Path.miterLimit = 4;
        
        [fillColor setFill];
        [bezier10Path fill];
    }
}

@end
