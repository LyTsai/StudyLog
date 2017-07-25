//
//  ASymbol_Heart1.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_Heart1.h"

@implementation ASymbol_Heart1

@synthesize fillColor, fillColor2, fillColor3, fillColor4, fillColor5, fillColor6, fillColor7;

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(23, 18);
    
    fillColor = [UIColor colorWithRed: 0.604 green: 0.145 blue: 0.141 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 0.518 green: 0.114 blue: 0.133 alpha: 1];
    fillColor3 = [UIColor colorWithRed: 0.631 green: 0.141 blue: 0.145 alpha: 1];
    fillColor4 = [UIColor colorWithRed: 0.655 green: 0.196 blue: 0.141 alpha: 1];
    fillColor5 = [UIColor colorWithRed: 0.78 green: 0.318 blue: 0.196 alpha: 1];
    fillColor6 = [UIColor colorWithRed: 0.753 green: 0.137 blue: 0.149 alpha: 1];
    fillColor7 = [UIColor colorWithRed: 0.816 green: 0.314 blue: 0.173 alpha: 1];
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_Heart1* draw = [[ASymbol_Heart1 alloc] init];
    [draw initDrawPros];
    
    APathDrawWrap* warp = [[APathDrawWrap alloc] initWith:CGRectMake(0, 0, draw.pathRefSize.x, draw.pathRefSize.y) pathDraw:draw];
    
    return warp;
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    //// Group 4
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(4.97, 3.34)];
        [bezierPath addCurveToPoint: CGPointMake(3.17, 2.94) controlPoint1: CGPointMake(4.97, 3.34) controlPoint2: CGPointMake(3.67, 2.74)];
        [bezierPath addCurveToPoint: CGPointMake(1.87, 3.64) controlPoint1: CGPointMake(2.57, 3.14) controlPoint2: CGPointMake(1.87, 3.54)];
        [bezierPath addCurveToPoint: CGPointMake(1.87, 9.54) controlPoint1: CGPointMake(1.87, 3.74) controlPoint2: CGPointMake(1.87, 9.54)];
        [bezierPath addCurveToPoint: CGPointMake(3.77, 9.34) controlPoint1: CGPointMake(1.87, 9.54) controlPoint2: CGPointMake(3.77, 9.44)];
        [bezierPath addCurveToPoint: CGPointMake(4.87, 3.54) controlPoint1: CGPointMake(3.87, 9.14) controlPoint2: CGPointMake(4.87, 3.54)];
        [bezierPath addCurveToPoint: CGPointMake(4.97, 3.34) controlPoint1: CGPointMake(4.87, 3.44) controlPoint2: CGPointMake(4.97, 3.34)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor setFill];
        [bezierPath fill];
    }
    
    
    //// Group 5
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(2.07, 9.44)];
        [bezier2Path addLineToPoint: CGPointMake(1.67, 9.44)];
        [bezier2Path addLineToPoint: CGPointMake(1.67, 3.64)];
        [bezier2Path addCurveToPoint: CGPointMake(2.77, 2.94) controlPoint1: CGPointMake(1.67, 3.44) controlPoint2: CGPointMake(1.77, 3.24)];
        [bezier2Path addCurveToPoint: CGPointMake(4.67, 3.14) controlPoint1: CGPointMake(3.87, 2.64) controlPoint2: CGPointMake(4.67, 3.14)];
        [bezier2Path addLineToPoint: CGPointMake(4.47, 3.44)];
        [bezier2Path addLineToPoint: CGPointMake(4.57, 3.34)];
        [bezier2Path addLineToPoint: CGPointMake(4.47, 3.44)];
        [bezier2Path addCurveToPoint: CGPointMake(2.87, 3.24) controlPoint1: CGPointMake(4.47, 3.44) controlPoint2: CGPointMake(3.77, 3.04)];
        [bezier2Path addCurveToPoint: CGPointMake(2.07, 3.64) controlPoint1: CGPointMake(2.17, 3.44) controlPoint2: CGPointMake(2.07, 3.64)];
        [bezier2Path addLineToPoint: CGPointMake(2.07, 9.44)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier2Path fill];
    }
    
    
    //// Group 6
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0.47, 4.74, 3.3, 1.6)];
        [fillColor3 setFill];
        [rectanglePath fill];
    }
    
    
    //// Group 7
    {
        //// Oval Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0.52, 5.54);
        CGContextRotateCTM(context, 1.25 * M_PI / 180);
        
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-0.5, -0.9, 1, 1.8)];
        [fillColor4 setFill];
        [ovalPath fill];
        
        CGContextRestoreGState(context);
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(0.57, 6.54)];
        [bezier3Path addLineToPoint: CGPointMake(0.57, 6.54)];
        [bezier3Path addLineToPoint: CGPointMake(0.57, 6.54)];
        [bezier3Path addCurveToPoint: CGPointMake(0.07, 5.54) controlPoint1: CGPointMake(0.27, 6.54) controlPoint2: CGPointMake(0.07, 6.14)];
        [bezier3Path addCurveToPoint: CGPointMake(0.57, 4.54) controlPoint1: CGPointMake(0.07, 5.04) controlPoint2: CGPointMake(0.27, 4.54)];
        [bezier3Path addLineToPoint: CGPointMake(0.57, 4.54)];
        [bezier3Path addCurveToPoint: CGPointMake(1.07, 5.54) controlPoint1: CGPointMake(0.87, 4.54) controlPoint2: CGPointMake(1.07, 4.94)];
        [bezier3Path addCurveToPoint: CGPointMake(0.57, 6.54) controlPoint1: CGPointMake(1.07, 6.14) controlPoint2: CGPointMake(0.87, 6.54)];
        [bezier3Path closePath];
        [bezier3Path moveToPoint: CGPointMake(0.57, 4.74)];
        [bezier3Path addCurveToPoint: CGPointMake(0.27, 5.54) controlPoint1: CGPointMake(0.47, 4.74) controlPoint2: CGPointMake(0.27, 5.04)];
        [bezier3Path addCurveToPoint: CGPointMake(0.57, 6.34) controlPoint1: CGPointMake(0.27, 6.04) controlPoint2: CGPointMake(0.47, 6.34)];
        [bezier3Path addLineToPoint: CGPointMake(0.57, 6.34)];
        [bezier3Path addCurveToPoint: CGPointMake(0.87, 5.54) controlPoint1: CGPointMake(0.67, 6.34) controlPoint2: CGPointMake(0.87, 6.04)];
        [bezier3Path addCurveToPoint: CGPointMake(0.57, 4.74) controlPoint1: CGPointMake(0.87, 5.04) controlPoint2: CGPointMake(0.67, 4.74)];
        [bezier3Path closePath];
        bezier3Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier3Path fill];
    }
    
    
    //// Group 8
    {
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(0.62, 4.14, 3.1, 1)];
        [fillColor2 setFill];
        [rectangle2Path fill];
    }
    
    
    //// Group 9
    {
        //// Rectangle 3 Drawing
        UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(0.57, 6.24, 2.4, 1)];
        [fillColor2 setFill];
        [rectangle3Path fill];
    }
    
    
    //// Group 10
    {
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(8.77, 7.24)];
        [bezier4Path addLineToPoint: CGPointMake(8.87, 7.04)];
        [bezier4Path addCurveToPoint: CGPointMake(9.57, 7.14) controlPoint1: CGPointMake(8.97, 7.04) controlPoint2: CGPointMake(9.17, 7.14)];
        [bezier4Path addCurveToPoint: CGPointMake(11.67, 7.84) controlPoint1: CGPointMake(10.27, 7.14) controlPoint2: CGPointMake(10.97, 7.34)];
        [bezier4Path addCurveToPoint: CGPointMake(12.87, 9.64) controlPoint1: CGPointMake(12.27, 8.24) controlPoint2: CGPointMake(12.47, 9.04)];
        [bezier4Path addCurveToPoint: CGPointMake(14.07, 11.44) controlPoint1: CGPointMake(13.17, 10.14) controlPoint2: CGPointMake(13.57, 10.74)];
        [bezier4Path addCurveToPoint: CGPointMake(15.37, 14.94) controlPoint1: CGPointMake(14.67, 12.14) controlPoint2: CGPointMake(15.17, 13.74)];
        [bezier4Path addCurveToPoint: CGPointMake(15.07, 19.74) controlPoint1: CGPointMake(15.57, 16.14) controlPoint2: CGPointMake(15.87, 18.24)];
        [bezier4Path addCurveToPoint: CGPointMake(9.57, 20.74) controlPoint1: CGPointMake(14.17, 21.24) controlPoint2: CGPointMake(11.67, 20.94)];
        [bezier4Path addCurveToPoint: CGPointMake(3.57, 18.34) controlPoint1: CGPointMake(7.47, 20.54) controlPoint2: CGPointMake(4.87, 19.24)];
        [bezier4Path addCurveToPoint: CGPointMake(0.37, 13.94) controlPoint1: CGPointMake(2.17, 17.44) controlPoint2: CGPointMake(0.87, 16.14)];
        [bezier4Path addCurveToPoint: CGPointMake(1.57, 9.94) controlPoint1: CGPointMake(-0.13, 11.84) controlPoint2: CGPointMake(1.27, 10.44)];
        [bezier4Path addCurveToPoint: CGPointMake(2.87, 8.74) controlPoint1: CGPointMake(1.87, 9.44) controlPoint2: CGPointMake(2.87, 8.74)];
        [bezier4Path addLineToPoint: CGPointMake(8.77, 7.24)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [fillColor5 setFill];
        [bezier4Path fill];
        
        
        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = UIBezierPath.bezierPath;
        [bezier5Path moveToPoint: CGPointMake(12.07, 21.04)];
        [bezier5Path addCurveToPoint: CGPointMake(9.57, 20.84) controlPoint1: CGPointMake(11.27, 21.04) controlPoint2: CGPointMake(10.37, 20.94)];
        [bezier5Path addCurveToPoint: CGPointMake(3.47, 18.44) controlPoint1: CGPointMake(7.57, 20.64) controlPoint2: CGPointMake(5.07, 19.44)];
        [bezier5Path addCurveToPoint: CGPointMake(0.17, 13.94) controlPoint1: CGPointMake(1.77, 17.34) controlPoint2: CGPointMake(0.67, 15.84)];
        [bezier5Path addCurveToPoint: CGPointMake(1.17, 10.04) controlPoint1: CGPointMake(-0.33, 12.04) controlPoint2: CGPointMake(0.67, 10.64)];
        [bezier5Path addCurveToPoint: CGPointMake(1.37, 9.74) controlPoint1: CGPointMake(1.27, 9.94) controlPoint2: CGPointMake(1.27, 9.84)];
        [bezier5Path addCurveToPoint: CGPointMake(2.77, 8.44) controlPoint1: CGPointMake(1.67, 9.24) controlPoint2: CGPointMake(2.67, 8.44)];
        [bezier5Path addLineToPoint: CGPointMake(2.77, 8.44)];
        [bezier5Path addLineToPoint: CGPointMake(8.67, 7.04)];
        [bezier5Path addCurveToPoint: CGPointMake(8.87, 6.84) controlPoint1: CGPointMake(8.67, 6.94) controlPoint2: CGPointMake(8.77, 6.84)];
        [bezier5Path addLineToPoint: CGPointMake(8.97, 6.84)];
        [bezier5Path addCurveToPoint: CGPointMake(9.17, 6.84) controlPoint1: CGPointMake(9.07, 6.84) controlPoint2: CGPointMake(9.07, 6.84)];
        [bezier5Path addCurveToPoint: CGPointMake(9.67, 6.94) controlPoint1: CGPointMake(9.27, 6.84) controlPoint2: CGPointMake(9.47, 6.94)];
        [bezier5Path addLineToPoint: CGPointMake(9.77, 6.94)];
        [bezier5Path addCurveToPoint: CGPointMake(11.87, 7.64) controlPoint1: CGPointMake(10.47, 6.94) controlPoint2: CGPointMake(11.17, 7.24)];
        [bezier5Path addCurveToPoint: CGPointMake(12.77, 8.94) controlPoint1: CGPointMake(12.37, 7.94) controlPoint2: CGPointMake(12.57, 8.44)];
        [bezier5Path addCurveToPoint: CGPointMake(13.07, 9.44) controlPoint1: CGPointMake(12.87, 9.14) controlPoint2: CGPointMake(12.97, 9.34)];
        [bezier5Path addCurveToPoint: CGPointMake(13.37, 9.84) controlPoint1: CGPointMake(13.17, 9.54) controlPoint2: CGPointMake(13.27, 9.74)];
        [bezier5Path addCurveToPoint: CGPointMake(14.37, 11.24) controlPoint1: CGPointMake(13.67, 10.24) controlPoint2: CGPointMake(13.87, 10.74)];
        [bezier5Path addCurveToPoint: CGPointMake(15.67, 14.74) controlPoint1: CGPointMake(14.97, 11.94) controlPoint2: CGPointMake(15.47, 13.54)];
        [bezier5Path addCurveToPoint: CGPointMake(15.27, 19.74) controlPoint1: CGPointMake(15.97, 16.24) controlPoint2: CGPointMake(16.17, 18.24)];
        [bezier5Path addCurveToPoint: CGPointMake(12.07, 21.04) controlPoint1: CGPointMake(14.67, 20.64) controlPoint2: CGPointMake(13.67, 21.04)];
        [bezier5Path closePath];
        [bezier5Path moveToPoint: CGPointMake(2.87, 8.84)];
        [bezier5Path addCurveToPoint: CGPointMake(1.67, 10.04) controlPoint1: CGPointMake(2.67, 8.94) controlPoint2: CGPointMake(1.87, 9.64)];
        [bezier5Path addCurveToPoint: CGPointMake(1.47, 10.34) controlPoint1: CGPointMake(1.67, 10.14) controlPoint2: CGPointMake(1.57, 10.24)];
        [bezier5Path addCurveToPoint: CGPointMake(0.47, 13.94) controlPoint1: CGPointMake(0.97, 11.04) controlPoint2: CGPointMake(0.07, 12.24)];
        [bezier5Path addCurveToPoint: CGPointMake(3.57, 18.24) controlPoint1: CGPointMake(0.87, 15.74) controlPoint2: CGPointMake(1.97, 17.14)];
        [bezier5Path addCurveToPoint: CGPointMake(9.57, 20.54) controlPoint1: CGPointMake(5.17, 19.24) controlPoint2: CGPointMake(7.57, 20.34)];
        [bezier5Path addCurveToPoint: CGPointMake(12.07, 20.74) controlPoint1: CGPointMake(10.37, 20.64) controlPoint2: CGPointMake(11.17, 20.74)];
        [bezier5Path addCurveToPoint: CGPointMake(14.97, 19.64) controlPoint1: CGPointMake(13.57, 20.74) controlPoint2: CGPointMake(14.47, 20.44)];
        [bezier5Path addCurveToPoint: CGPointMake(15.27, 14.94) controlPoint1: CGPointMake(15.77, 18.24) controlPoint2: CGPointMake(15.57, 16.04)];
        [bezier5Path addCurveToPoint: CGPointMake(13.97, 11.54) controlPoint1: CGPointMake(14.97, 13.74) controlPoint2: CGPointMake(14.47, 12.14)];
        [bezier5Path addCurveToPoint: CGPointMake(12.97, 10.14) controlPoint1: CGPointMake(13.57, 11.04) controlPoint2: CGPointMake(13.27, 10.54)];
        [bezier5Path addCurveToPoint: CGPointMake(12.67, 9.74) controlPoint1: CGPointMake(12.87, 10.04) controlPoint2: CGPointMake(12.77, 9.84)];
        [bezier5Path addCurveToPoint: CGPointMake(12.37, 9.14) controlPoint1: CGPointMake(12.57, 9.54) controlPoint2: CGPointMake(12.47, 9.34)];
        [bezier5Path addCurveToPoint: CGPointMake(11.57, 8.04) controlPoint1: CGPointMake(12.17, 8.74) controlPoint2: CGPointMake(11.97, 8.24)];
        [bezier5Path addCurveToPoint: CGPointMake(9.77, 7.44) controlPoint1: CGPointMake(10.97, 7.64) controlPoint2: CGPointMake(10.37, 7.44)];
        [bezier5Path addLineToPoint: CGPointMake(9.67, 7.44)];
        [bezier5Path addCurveToPoint: CGPointMake(9.07, 7.34) controlPoint1: CGPointMake(9.37, 7.44) controlPoint2: CGPointMake(9.27, 7.44)];
        [bezier5Path addLineToPoint: CGPointMake(8.97, 7.34)];
        [bezier5Path addCurveToPoint: CGPointMake(8.97, 7.44) controlPoint1: CGPointMake(8.97, 7.34) controlPoint2: CGPointMake(8.97, 7.34)];
        [bezier5Path addLineToPoint: CGPointMake(8.97, 7.54)];
        [bezier5Path addLineToPoint: CGPointMake(8.87, 7.54)];
        [bezier5Path addLineToPoint: CGPointMake(2.87, 8.84)];
        [bezier5Path closePath];
        bezier5Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier5Path fill];
    }
    
    
    //// Group 11
    {
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
        [bezier6Path moveToPoint: CGPointMake(6.07, 7.94)];
        [bezier6Path addCurveToPoint: CGPointMake(4.27, 9.04) controlPoint1: CGPointMake(6.07, 7.94) controlPoint2: CGPointMake(5.47, 9.04)];
        [bezier6Path addCurveToPoint: CGPointMake(2.77, 8.84) controlPoint1: CGPointMake(3.07, 9.04) controlPoint2: CGPointMake(2.77, 8.84)];
        [bezier6Path addCurveToPoint: CGPointMake(3.17, 5.54) controlPoint1: CGPointMake(2.77, 8.84) controlPoint2: CGPointMake(2.47, 6.74)];
        [bezier6Path addCurveToPoint: CGPointMake(4.57, 3.14) controlPoint1: CGPointMake(3.87, 4.24) controlPoint2: CGPointMake(4.77, 3.84)];
        [bezier6Path addCurveToPoint: CGPointMake(3.97, 1.54) controlPoint1: CGPointMake(4.37, 2.44) controlPoint2: CGPointMake(3.97, 1.54)];
        [bezier6Path addLineToPoint: CGPointMake(5.17, 0.84)];
        [bezier6Path addCurveToPoint: CGPointMake(6.47, 2.84) controlPoint1: CGPointMake(5.17, 0.84) controlPoint2: CGPointMake(5.97, 3.04)];
        [bezier6Path addCurveToPoint: CGPointMake(6.77, 0.54) controlPoint1: CGPointMake(6.97, 2.74) controlPoint2: CGPointMake(6.77, 0.54)];
        [bezier6Path addLineToPoint: CGPointMake(8.17, 0.54)];
        [bezier6Path addCurveToPoint: CGPointMake(7.97, 2.64) controlPoint1: CGPointMake(8.17, 0.54) controlPoint2: CGPointMake(7.77, 2.64)];
        [bezier6Path addCurveToPoint: CGPointMake(9.37, 0.54) controlPoint1: CGPointMake(8.17, 2.64) controlPoint2: CGPointMake(9.37, 0.54)];
        [bezier6Path addLineToPoint: CGPointMake(10.57, 1.64)];
        [bezier6Path addCurveToPoint: CGPointMake(9.77, 3.14) controlPoint1: CGPointMake(10.57, 1.64) controlPoint2: CGPointMake(9.57, 2.64)];
        [bezier6Path addCurveToPoint: CGPointMake(10.37, 4.34) controlPoint1: CGPointMake(9.87, 3.54) controlPoint2: CGPointMake(10.37, 4.34)];
        [bezier6Path addCurveToPoint: CGPointMake(10.97, 6.34) controlPoint1: CGPointMake(10.37, 4.34) controlPoint2: CGPointMake(10.87, 5.64)];
        [bezier6Path addCurveToPoint: CGPointMake(11.07, 7.44) controlPoint1: CGPointMake(11.07, 7.04) controlPoint2: CGPointMake(11.07, 7.44)];
        [bezier6Path addCurveToPoint: CGPointMake(8.67, 7.14) controlPoint1: CGPointMake(11.07, 7.44) controlPoint2: CGPointMake(9.57, 7.04)];
        [bezier6Path addCurveToPoint: CGPointMake(6.07, 7.94) controlPoint1: CGPointMake(7.87, 7.14) controlPoint2: CGPointMake(6.17, 7.74)];
        [bezier6Path closePath];
        bezier6Path.miterLimit = 4;
        
        [fillColor6 setFill];
        [bezier6Path fill];
        
        
        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
        [bezier7Path moveToPoint: CGPointMake(4.27, 9.04)];
        [bezier7Path addLineToPoint: CGPointMake(4.27, 9.04)];
        [bezier7Path addCurveToPoint: CGPointMake(2.77, 8.84) controlPoint1: CGPointMake(3.07, 9.04) controlPoint2: CGPointMake(2.77, 8.84)];
        [bezier7Path addLineToPoint: CGPointMake(2.77, 8.84)];
        [bezier7Path addLineToPoint: CGPointMake(2.77, 8.84)];
        [bezier7Path addCurveToPoint: CGPointMake(3.17, 5.54) controlPoint1: CGPointMake(2.77, 8.84) controlPoint2: CGPointMake(2.47, 6.74)];
        [bezier7Path addCurveToPoint: CGPointMake(4.07, 4.34) controlPoint1: CGPointMake(3.47, 5.04) controlPoint2: CGPointMake(3.77, 4.64)];
        [bezier7Path addCurveToPoint: CGPointMake(4.57, 3.24) controlPoint1: CGPointMake(4.47, 3.94) controlPoint2: CGPointMake(4.67, 3.64)];
        [bezier7Path addCurveToPoint: CGPointMake(3.97, 1.64) controlPoint1: CGPointMake(4.37, 2.54) controlPoint2: CGPointMake(3.97, 1.64)];
        [bezier7Path addLineToPoint: CGPointMake(3.97, 1.64)];
        [bezier7Path addLineToPoint: CGPointMake(5.17, 0.84)];
        [bezier7Path addLineToPoint: CGPointMake(5.17, 0.84)];
        [bezier7Path addCurveToPoint: CGPointMake(6.37, 2.84) controlPoint1: CGPointMake(5.17, 0.84) controlPoint2: CGPointMake(5.87, 2.84)];
        [bezier7Path addLineToPoint: CGPointMake(6.37, 2.84)];
        [bezier7Path addCurveToPoint: CGPointMake(6.67, 0.54) controlPoint1: CGPointMake(6.87, 2.74) controlPoint2: CGPointMake(6.67, 0.54)];
        [bezier7Path addLineToPoint: CGPointMake(6.67, 0.54)];
        [bezier7Path addLineToPoint: CGPointMake(8.07, 0.54)];
        [bezier7Path addLineToPoint: CGPointMake(8.07, 0.54)];
        [bezier7Path addCurveToPoint: CGPointMake(7.87, 2.64) controlPoint1: CGPointMake(7.97, 1.24) controlPoint2: CGPointMake(7.67, 2.44)];
        [bezier7Path addLineToPoint: CGPointMake(7.87, 2.64)];
        [bezier7Path addCurveToPoint: CGPointMake(9.27, 0.54) controlPoint1: CGPointMake(8.07, 2.64) controlPoint2: CGPointMake(8.87, 1.14)];
        [bezier7Path addLineToPoint: CGPointMake(9.27, 0.54)];
        [bezier7Path addLineToPoint: CGPointMake(10.47, 1.64)];
        [bezier7Path addLineToPoint: CGPointMake(10.47, 1.64)];
        [bezier7Path addCurveToPoint: CGPointMake(9.67, 3.04) controlPoint1: CGPointMake(10.47, 1.64) controlPoint2: CGPointMake(9.47, 2.64)];
        [bezier7Path addCurveToPoint: CGPointMake(10.27, 4.24) controlPoint1: CGPointMake(9.77, 3.44) controlPoint2: CGPointMake(10.27, 4.24)];
        [bezier7Path addCurveToPoint: CGPointMake(10.87, 6.24) controlPoint1: CGPointMake(10.27, 4.24) controlPoint2: CGPointMake(10.77, 5.54)];
        [bezier7Path addCurveToPoint: CGPointMake(10.97, 7.34) controlPoint1: CGPointMake(10.97, 6.94) controlPoint2: CGPointMake(10.97, 7.34)];
        [bezier7Path addLineToPoint: CGPointMake(10.97, 7.34)];
        [bezier7Path addLineToPoint: CGPointMake(10.97, 7.34)];
        [bezier7Path addCurveToPoint: CGPointMake(8.77, 7.04) controlPoint1: CGPointMake(10.97, 7.34) controlPoint2: CGPointMake(9.67, 7.04)];
        [bezier7Path addCurveToPoint: CGPointMake(8.57, 7.04) controlPoint1: CGPointMake(8.67, 7.04) controlPoint2: CGPointMake(8.67, 7.04)];
        [bezier7Path addCurveToPoint: CGPointMake(5.97, 7.94) controlPoint1: CGPointMake(7.77, 7.14) controlPoint2: CGPointMake(6.07, 7.74)];
        [bezier7Path addCurveToPoint: CGPointMake(4.27, 9.04) controlPoint1: CGPointMake(6.07, 7.94) controlPoint2: CGPointMake(5.47, 9.04)];
        [bezier7Path closePath];
        [bezier7Path moveToPoint: CGPointMake(2.87, 8.84)];
        [bezier7Path addCurveToPoint: CGPointMake(4.27, 9.04) controlPoint1: CGPointMake(2.87, 8.84) controlPoint2: CGPointMake(3.27, 9.04)];
        [bezier7Path addCurveToPoint: CGPointMake(6.07, 7.94) controlPoint1: CGPointMake(5.47, 9.04) controlPoint2: CGPointMake(6.07, 7.94)];
        [bezier7Path addCurveToPoint: CGPointMake(8.67, 7.04) controlPoint1: CGPointMake(6.17, 7.74) controlPoint2: CGPointMake(7.87, 7.14)];
        [bezier7Path addCurveToPoint: CGPointMake(8.87, 7.04) controlPoint1: CGPointMake(8.77, 7.04) controlPoint2: CGPointMake(8.77, 7.04)];
        [bezier7Path addCurveToPoint: CGPointMake(10.87, 7.34) controlPoint1: CGPointMake(9.67, 7.04) controlPoint2: CGPointMake(10.77, 7.34)];
        [bezier7Path addCurveToPoint: CGPointMake(10.87, 6.24) controlPoint1: CGPointMake(10.87, 7.24) controlPoint2: CGPointMake(10.97, 6.84)];
        [bezier7Path addCurveToPoint: CGPointMake(10.37, 4.34) controlPoint1: CGPointMake(10.77, 5.54) controlPoint2: CGPointMake(10.37, 4.34)];
        [bezier7Path addCurveToPoint: CGPointMake(9.77, 3.14) controlPoint1: CGPointMake(10.37, 4.34) controlPoint2: CGPointMake(9.87, 3.54)];
        [bezier7Path addCurveToPoint: CGPointMake(10.57, 1.64) controlPoint1: CGPointMake(9.67, 2.74) controlPoint2: CGPointMake(10.47, 1.84)];
        [bezier7Path addLineToPoint: CGPointMake(9.37, 0.54)];
        [bezier7Path addCurveToPoint: CGPointMake(7.97, 2.64) controlPoint1: CGPointMake(9.27, 0.74) controlPoint2: CGPointMake(8.27, 2.54)];
        [bezier7Path addLineToPoint: CGPointMake(7.97, 2.64)];
        [bezier7Path addLineToPoint: CGPointMake(7.97, 2.64)];
        [bezier7Path addCurveToPoint: CGPointMake(8.17, 0.54) controlPoint1: CGPointMake(7.77, 2.44) controlPoint2: CGPointMake(8.17, 0.74)];
        [bezier7Path addLineToPoint: CGPointMake(6.87, 0.54)];
        [bezier7Path addCurveToPoint: CGPointMake(6.47, 2.84) controlPoint1: CGPointMake(6.87, 0.74) controlPoint2: CGPointMake(7.07, 2.64)];
        [bezier7Path addCurveToPoint: CGPointMake(6.37, 2.84) controlPoint1: CGPointMake(6.47, 2.84) controlPoint2: CGPointMake(6.47, 2.84)];
        [bezier7Path addCurveToPoint: CGPointMake(5.07, 0.84) controlPoint1: CGPointMake(5.87, 2.84) controlPoint2: CGPointMake(5.17, 1.04)];
        [bezier7Path addLineToPoint: CGPointMake(3.87, 1.54)];
        [bezier7Path addCurveToPoint: CGPointMake(4.47, 3.14) controlPoint1: CGPointMake(3.97, 1.64) controlPoint2: CGPointMake(4.27, 2.54)];
        [bezier7Path addCurveToPoint: CGPointMake(3.97, 4.34) controlPoint1: CGPointMake(4.57, 3.54) controlPoint2: CGPointMake(4.37, 3.84)];
        [bezier7Path addCurveToPoint: CGPointMake(3.07, 5.54) controlPoint1: CGPointMake(3.67, 4.64) controlPoint2: CGPointMake(3.37, 5.04)];
        [bezier7Path addCurveToPoint: CGPointMake(2.87, 8.84) controlPoint1: CGPointMake(2.47, 6.74) controlPoint2: CGPointMake(2.77, 8.64)];
        [bezier7Path closePath];
        bezier7Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier7Path fill];
    }
    
    
    //// Group 12
    {
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(5.27, 0.64)];
        [bezier8Path addCurveToPoint: CGPointMake(4.37, 0.74) controlPoint1: CGPointMake(5.17, 0.44) controlPoint2: CGPointMake(4.77, 0.54)];
        [bezier8Path addCurveToPoint: CGPointMake(3.77, 1.44) controlPoint1: CGPointMake(3.97, 0.94) controlPoint2: CGPointMake(3.67, 1.24)];
        [bezier8Path addCurveToPoint: CGPointMake(4.67, 1.34) controlPoint1: CGPointMake(3.87, 1.64) controlPoint2: CGPointMake(4.27, 1.54)];
        [bezier8Path addCurveToPoint: CGPointMake(5.27, 0.64) controlPoint1: CGPointMake(5.17, 1.14) controlPoint2: CGPointMake(5.37, 0.84)];
        [bezier8Path closePath];
        bezier8Path.miterLimit = 4;
        
        [fillColor4 setFill];
        [bezier8Path fill];
        
        
        //// Bezier 9 Drawing
        UIBezierPath* bezier9Path = UIBezierPath.bezierPath;
        [bezier9Path moveToPoint: CGPointMake(4.17, 1.64)];
        [bezier9Path addLineToPoint: CGPointMake(4.17, 1.64)];
        [bezier9Path addCurveToPoint: CGPointMake(3.77, 1.44) controlPoint1: CGPointMake(3.97, 1.64) controlPoint2: CGPointMake(3.87, 1.54)];
        [bezier9Path addCurveToPoint: CGPointMake(4.37, 0.64) controlPoint1: CGPointMake(3.67, 1.14) controlPoint2: CGPointMake(3.97, 0.84)];
        [bezier9Path addCurveToPoint: CGPointMake(5.07, 0.44) controlPoint1: CGPointMake(4.57, 0.54) controlPoint2: CGPointMake(4.87, 0.44)];
        [bezier9Path addCurveToPoint: CGPointMake(5.47, 0.64) controlPoint1: CGPointMake(5.27, 0.44) controlPoint2: CGPointMake(5.37, 0.54)];
        [bezier9Path addCurveToPoint: CGPointMake(4.87, 1.44) controlPoint1: CGPointMake(5.57, 0.94) controlPoint2: CGPointMake(5.27, 1.24)];
        [bezier9Path addCurveToPoint: CGPointMake(4.17, 1.64) controlPoint1: CGPointMake(4.57, 1.54) controlPoint2: CGPointMake(4.37, 1.64)];
        [bezier9Path closePath];
        [bezier9Path moveToPoint: CGPointMake(5.07, 0.74)];
        [bezier9Path addCurveToPoint: CGPointMake(4.47, 0.94) controlPoint1: CGPointMake(4.87, 0.74) controlPoint2: CGPointMake(4.67, 0.84)];
        [bezier9Path addCurveToPoint: CGPointMake(3.97, 1.44) controlPoint1: CGPointMake(4.07, 1.14) controlPoint2: CGPointMake(3.97, 1.34)];
        [bezier9Path addLineToPoint: CGPointMake(4.07, 1.44)];
        [bezier9Path addCurveToPoint: CGPointMake(4.67, 1.24) controlPoint1: CGPointMake(4.27, 1.44) controlPoint2: CGPointMake(4.47, 1.34)];
        [bezier9Path addCurveToPoint: CGPointMake(5.17, 0.74) controlPoint1: CGPointMake(5.07, 1.04) controlPoint2: CGPointMake(5.17, 0.84)];
        [bezier9Path addCurveToPoint: CGPointMake(5.07, 0.74) controlPoint1: CGPointMake(5.17, 0.74) controlPoint2: CGPointMake(5.17, 0.74)];
        [bezier9Path closePath];
        bezier9Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier9Path fill];
    }
    
    
    //// Bezier 10 Drawing
    UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
    [bezier10Path moveToPoint: CGPointMake(8.37, 0.54)];
    [bezier10Path addCurveToPoint: CGPointMake(7.67, 0.04) controlPoint1: CGPointMake(8.37, 0.34) controlPoint2: CGPointMake(8.07, 0.14)];
    [bezier10Path addCurveToPoint: CGPointMake(6.87, 0.24) controlPoint1: CGPointMake(7.27, -0.06) controlPoint2: CGPointMake(6.87, 0.04)];
    [bezier10Path addCurveToPoint: CGPointMake(7.57, 0.74) controlPoint1: CGPointMake(6.87, 0.44) controlPoint2: CGPointMake(7.17, 0.64)];
    [bezier10Path addCurveToPoint: CGPointMake(8.37, 0.54) controlPoint1: CGPointMake(7.97, 0.84) controlPoint2: CGPointMake(8.27, 0.74)];
    [bezier10Path closePath];
    bezier10Path.miterLimit = 4;
    
    [fillColor4 setFill];
    [bezier10Path fill];
    
    
    //// Bezier 11 Drawing
    UIBezierPath* bezier11Path = UIBezierPath.bezierPath;
    [bezier11Path moveToPoint: CGPointMake(7.77, 0.94)];
    [bezier11Path addLineToPoint: CGPointMake(7.77, 0.94)];
    [bezier11Path addCurveToPoint: CGPointMake(7.47, 0.94) controlPoint1: CGPointMake(7.67, 0.94) controlPoint2: CGPointMake(7.57, 0.94)];
    [bezier11Path addCurveToPoint: CGPointMake(6.67, 0.34) controlPoint1: CGPointMake(7.07, 0.84) controlPoint2: CGPointMake(6.57, 0.64)];
    [bezier11Path addCurveToPoint: CGPointMake(7.27, 0.04) controlPoint1: CGPointMake(6.67, 0.14) controlPoint2: CGPointMake(6.97, 0.04)];
    [bezier11Path addCurveToPoint: CGPointMake(7.57, 0.04) controlPoint1: CGPointMake(7.37, 0.04) controlPoint2: CGPointMake(7.47, 0.04)];
    [bezier11Path addCurveToPoint: CGPointMake(8.37, 0.64) controlPoint1: CGPointMake(7.97, 0.14) controlPoint2: CGPointMake(8.47, 0.34)];
    [bezier11Path addCurveToPoint: CGPointMake(7.77, 0.94) controlPoint1: CGPointMake(8.37, 0.84) controlPoint2: CGPointMake(8.07, 0.94)];
    [bezier11Path closePath];
    [bezier11Path moveToPoint: CGPointMake(7.27, 0.24)];
    [bezier11Path addCurveToPoint: CGPointMake(6.87, 0.34) controlPoint1: CGPointMake(6.97, 0.24) controlPoint2: CGPointMake(6.87, 0.34)];
    [bezier11Path addCurveToPoint: CGPointMake(7.47, 0.64) controlPoint1: CGPointMake(6.87, 0.44) controlPoint2: CGPointMake(7.07, 0.54)];
    [bezier11Path addCurveToPoint: CGPointMake(7.77, 0.64) controlPoint1: CGPointMake(7.57, 0.64) controlPoint2: CGPointMake(7.67, 0.64)];
    [bezier11Path addCurveToPoint: CGPointMake(8.17, 0.54) controlPoint1: CGPointMake(8.07, 0.64) controlPoint2: CGPointMake(8.17, 0.54)];
    [bezier11Path addCurveToPoint: CGPointMake(7.57, 0.24) controlPoint1: CGPointMake(8.17, 0.44) controlPoint2: CGPointMake(7.97, 0.34)];
    [bezier11Path addCurveToPoint: CGPointMake(7.27, 0.24) controlPoint1: CGPointMake(7.47, 0.24) controlPoint2: CGPointMake(7.37, 0.24)];
    [bezier11Path closePath];
    bezier11Path.miterLimit = 4;
    
    [fillColor2 setFill];
    [bezier11Path fill];
    
    
    //// Group 13
    {
        //// Bezier 12 Drawing
        UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
        [bezier12Path moveToPoint: CGPointMake(10.67, 1.44)];
        [bezier12Path addCurveToPoint: CGPointMake(10.27, 0.74) controlPoint1: CGPointMake(10.77, 1.34) controlPoint2: CGPointMake(10.57, 0.94)];
        [bezier12Path addCurveToPoint: CGPointMake(9.47, 0.54) controlPoint1: CGPointMake(9.97, 0.54) controlPoint2: CGPointMake(9.57, 0.44)];
        [bezier12Path addCurveToPoint: CGPointMake(9.87, 1.24) controlPoint1: CGPointMake(9.37, 0.64) controlPoint2: CGPointMake(9.57, 1.04)];
        [bezier12Path addCurveToPoint: CGPointMake(10.67, 1.44) controlPoint1: CGPointMake(10.27, 1.54) controlPoint2: CGPointMake(10.57, 1.64)];
        [bezier12Path closePath];
        bezier12Path.miterLimit = 4;
        
        [fillColor4 setFill];
        [bezier12Path fill];
        
        
        //// Bezier 13 Drawing
        UIBezierPath* bezier13Path = UIBezierPath.bezierPath;
        [bezier13Path moveToPoint: CGPointMake(10.57, 1.64)];
        [bezier13Path addCurveToPoint: CGPointMake(9.87, 1.34) controlPoint1: CGPointMake(10.37, 1.64) controlPoint2: CGPointMake(10.07, 1.54)];
        [bezier13Path addCurveToPoint: CGPointMake(9.37, 0.44) controlPoint1: CGPointMake(9.47, 1.14) controlPoint2: CGPointMake(9.27, 0.74)];
        [bezier13Path addCurveToPoint: CGPointMake(9.67, 0.34) controlPoint1: CGPointMake(9.37, 0.34) controlPoint2: CGPointMake(9.47, 0.34)];
        [bezier13Path addCurveToPoint: CGPointMake(10.37, 0.64) controlPoint1: CGPointMake(9.87, 0.34) controlPoint2: CGPointMake(10.17, 0.44)];
        [bezier13Path addCurveToPoint: CGPointMake(10.87, 1.54) controlPoint1: CGPointMake(10.77, 0.94) controlPoint2: CGPointMake(10.97, 1.24)];
        [bezier13Path addCurveToPoint: CGPointMake(10.57, 1.64) controlPoint1: CGPointMake(10.77, 1.54) controlPoint2: CGPointMake(10.67, 1.64)];
        [bezier13Path closePath];
        [bezier13Path moveToPoint: CGPointMake(9.67, 0.64)];
        [bezier13Path addCurveToPoint: CGPointMake(9.67, 0.64) controlPoint1: CGPointMake(9.57, 0.64) controlPoint2: CGPointMake(9.57, 0.64)];
        [bezier13Path addCurveToPoint: CGPointMake(9.97, 1.14) controlPoint1: CGPointMake(9.57, 0.74) controlPoint2: CGPointMake(9.67, 0.94)];
        [bezier13Path addCurveToPoint: CGPointMake(10.57, 1.34) controlPoint1: CGPointMake(10.17, 1.34) controlPoint2: CGPointMake(10.37, 1.34)];
        [bezier13Path addCurveToPoint: CGPointMake(10.67, 1.34) controlPoint1: CGPointMake(10.67, 1.34) controlPoint2: CGPointMake(10.67, 1.34)];
        [bezier13Path addCurveToPoint: CGPointMake(10.27, 0.84) controlPoint1: CGPointMake(10.67, 1.34) controlPoint2: CGPointMake(10.57, 1.04)];
        [bezier13Path addCurveToPoint: CGPointMake(9.67, 0.64) controlPoint1: CGPointMake(9.97, 0.64) controlPoint2: CGPointMake(9.77, 0.64)];
        [bezier13Path closePath];
        bezier13Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier13Path fill];
    }
    
    
    //// Group 14
    {
        //// Bezier 14 Drawing
        UIBezierPath* bezier14Path = UIBezierPath.bezierPath;
        [bezier14Path moveToPoint: CGPointMake(10.27, 4.44)];
        [bezier14Path addCurveToPoint: CGPointMake(10.07, 4.04) controlPoint1: CGPointMake(10.27, 4.44) controlPoint2: CGPointMake(10.17, 4.24)];
        [bezier14Path addCurveToPoint: CGPointMake(9.87, 3.84) controlPoint1: CGPointMake(10.07, 4.04) controlPoint2: CGPointMake(9.97, 3.94)];
        [bezier14Path addCurveToPoint: CGPointMake(9.57, 3.34) controlPoint1: CGPointMake(9.77, 3.74) controlPoint2: CGPointMake(9.67, 3.54)];
        [bezier14Path addCurveToPoint: CGPointMake(9.67, 2.34) controlPoint1: CGPointMake(9.37, 2.94) controlPoint2: CGPointMake(9.47, 2.64)];
        [bezier14Path addCurveToPoint: CGPointMake(9.67, 2.24) controlPoint1: CGPointMake(9.67, 2.34) controlPoint2: CGPointMake(9.67, 2.34)];
        [bezier14Path addCurveToPoint: CGPointMake(10.37, 1.34) controlPoint1: CGPointMake(9.87, 1.94) controlPoint2: CGPointMake(10.37, 1.34)];
        [bezier14Path addLineToPoint: CGPointMake(10.67, 1.54)];
        [bezier14Path addCurveToPoint: CGPointMake(10.07, 2.34) controlPoint1: CGPointMake(10.57, 1.64) controlPoint2: CGPointMake(10.17, 2.14)];
        [bezier14Path addCurveToPoint: CGPointMake(10.07, 2.44) controlPoint1: CGPointMake(10.07, 2.34) controlPoint2: CGPointMake(10.07, 2.34)];
        [bezier14Path addCurveToPoint: CGPointMake(9.97, 3.14) controlPoint1: CGPointMake(9.97, 2.74) controlPoint2: CGPointMake(9.87, 2.84)];
        [bezier14Path addCurveToPoint: CGPointMake(10.27, 3.64) controlPoint1: CGPointMake(10.07, 3.34) controlPoint2: CGPointMake(10.17, 3.54)];
        [bezier14Path addCurveToPoint: CGPointMake(10.47, 3.94) controlPoint1: CGPointMake(10.37, 3.74) controlPoint2: CGPointMake(10.47, 3.84)];
        [bezier14Path addCurveToPoint: CGPointMake(10.67, 4.24) controlPoint1: CGPointMake(10.47, 4.04) controlPoint2: CGPointMake(10.57, 4.14)];
        [bezier14Path addLineToPoint: CGPointMake(10.27, 4.44)];
        [bezier14Path closePath];
        bezier14Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier14Path fill];
    }
    
    
    //// Group 15
    {
        //// Bezier 15 Drawing
        UIBezierPath* bezier15Path = UIBezierPath.bezierPath;
        [bezier15Path moveToPoint: CGPointMake(10.97, 7.44)];
        [bezier15Path addLineToPoint: CGPointMake(10.87, 7.44)];
        [bezier15Path addLineToPoint: CGPointMake(10.67, 6.24)];
        [bezier15Path addLineToPoint: CGPointMake(10.97, 6.24)];
        [bezier15Path addLineToPoint: CGPointMake(10.97, 7.44)];
        [bezier15Path closePath];
        bezier15Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier15Path fill];
    }
    
    
    //// Group 16
    {
        //// Bezier 16 Drawing
        UIBezierPath* bezier16Path = UIBezierPath.bezierPath;
        [bezier16Path moveToPoint: CGPointMake(2.47, 9.04)];
        [bezier16Path addCurveToPoint: CGPointMake(2.97, 9.84) controlPoint1: CGPointMake(2.47, 9.04) controlPoint2: CGPointMake(2.27, 9.74)];
        [bezier16Path addCurveToPoint: CGPointMake(4.67, 9.74) controlPoint1: CGPointMake(3.57, 9.94) controlPoint2: CGPointMake(4.27, 9.84)];
        [bezier16Path addCurveToPoint: CGPointMake(5.57, 9.34) controlPoint1: CGPointMake(5.07, 9.54) controlPoint2: CGPointMake(5.57, 9.34)];
        [bezier16Path addCurveToPoint: CGPointMake(3.67, 10.14) controlPoint1: CGPointMake(5.57, 9.34) controlPoint2: CGPointMake(4.67, 10.04)];
        [bezier16Path addCurveToPoint: CGPointMake(2.27, 9.94) controlPoint1: CGPointMake(2.67, 10.24) controlPoint2: CGPointMake(2.47, 10.04)];
        [bezier16Path addCurveToPoint: CGPointMake(2.47, 9.04) controlPoint1: CGPointMake(1.97, 9.54) controlPoint2: CGPointMake(2.47, 9.04)];
        [bezier16Path closePath];
        bezier16Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier16Path fill];
    }
    
    
    //// Group 17
    {
        //// Bezier 17 Drawing
        UIBezierPath* bezier17Path = UIBezierPath.bezierPath;
        [bezier17Path moveToPoint: CGPointMake(6.37, 8.84)];
        [bezier17Path addCurveToPoint: CGPointMake(7.57, 9.04) controlPoint1: CGPointMake(6.37, 8.84) controlPoint2: CGPointMake(6.87, 9.24)];
        [bezier17Path addCurveToPoint: CGPointMake(8.87, 8.44) controlPoint1: CGPointMake(8.27, 8.84) controlPoint2: CGPointMake(8.87, 8.44)];
        [bezier17Path addCurveToPoint: CGPointMake(7.57, 9.44) controlPoint1: CGPointMake(8.87, 8.44) controlPoint2: CGPointMake(8.37, 9.44)];
        [bezier17Path addCurveToPoint: CGPointMake(6.37, 8.84) controlPoint1: CGPointMake(6.77, 9.34) controlPoint2: CGPointMake(6.37, 8.84)];
        [bezier17Path closePath];
        bezier17Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier17Path fill];
    }
    
    
    //// Group 18
    {
        //// Bezier 18 Drawing
        UIBezierPath* bezier18Path = UIBezierPath.bezierPath;
        [bezier18Path moveToPoint: CGPointMake(6.17, 8.14)];
        [bezier18Path addCurveToPoint: CGPointMake(6.27, 9.24) controlPoint1: CGPointMake(6.17, 8.14) controlPoint2: CGPointMake(6.37, 8.64)];
        [bezier18Path addCurveToPoint: CGPointMake(5.77, 10.44) controlPoint1: CGPointMake(6.17, 9.84) controlPoint2: CGPointMake(6.07, 10.04)];
        [bezier18Path addCurveToPoint: CGPointMake(5.17, 11.24) controlPoint1: CGPointMake(5.47, 10.84) controlPoint2: CGPointMake(5.27, 11.14)];
        [bezier18Path addCurveToPoint: CGPointMake(4.97, 11.74) controlPoint1: CGPointMake(5.07, 11.44) controlPoint2: CGPointMake(4.87, 11.54)];
        [bezier18Path addCurveToPoint: CGPointMake(5.47, 12.34) controlPoint1: CGPointMake(5.07, 11.84) controlPoint2: CGPointMake(5.17, 12.04)];
        [bezier18Path addCurveToPoint: CGPointMake(6.07, 13.64) controlPoint1: CGPointMake(5.67, 12.64) controlPoint2: CGPointMake(6.07, 13.24)];
        [bezier18Path addCurveToPoint: CGPointMake(6.17, 14.64) controlPoint1: CGPointMake(6.07, 14.04) controlPoint2: CGPointMake(6.17, 14.64)];
        [bezier18Path addLineToPoint: CGPointMake(7.57, 15.64)];
        [bezier18Path addLineToPoint: CGPointMake(6.27, 14.84)];
        [bezier18Path addCurveToPoint: CGPointMake(6.27, 15.24) controlPoint1: CGPointMake(6.27, 14.84) controlPoint2: CGPointMake(6.27, 15.04)];
        [bezier18Path addCurveToPoint: CGPointMake(6.67, 15.74) controlPoint1: CGPointMake(6.37, 15.44) controlPoint2: CGPointMake(6.67, 15.74)];
        [bezier18Path addCurveToPoint: CGPointMake(6.07, 15.04) controlPoint1: CGPointMake(6.67, 15.74) controlPoint2: CGPointMake(6.07, 15.44)];
        [bezier18Path addCurveToPoint: CGPointMake(5.97, 13.84) controlPoint1: CGPointMake(6.07, 14.74) controlPoint2: CGPointMake(5.97, 14.24)];
        [bezier18Path addCurveToPoint: CGPointMake(5.47, 12.44) controlPoint1: CGPointMake(5.97, 13.54) controlPoint2: CGPointMake(5.67, 12.84)];
        [bezier18Path addCurveToPoint: CGPointMake(5.07, 11.94) controlPoint1: CGPointMake(5.17, 12.04) controlPoint2: CGPointMake(5.07, 11.94)];
        [bezier18Path addCurveToPoint: CGPointMake(5.27, 13.24) controlPoint1: CGPointMake(5.07, 11.94) controlPoint2: CGPointMake(5.27, 12.74)];
        [bezier18Path addCurveToPoint: CGPointMake(5.07, 14.04) controlPoint1: CGPointMake(5.27, 13.74) controlPoint2: CGPointMake(5.27, 13.84)];
        [bezier18Path addCurveToPoint: CGPointMake(4.67, 14.34) controlPoint1: CGPointMake(4.87, 14.24) controlPoint2: CGPointMake(4.67, 14.34)];
        [bezier18Path addCurveToPoint: CGPointMake(5.07, 13.04) controlPoint1: CGPointMake(4.67, 14.34) controlPoint2: CGPointMake(5.17, 14.24)];
        [bezier18Path addCurveToPoint: CGPointMake(4.87, 11.34) controlPoint1: CGPointMake(4.97, 11.94) controlPoint2: CGPointMake(4.77, 11.64)];
        [bezier18Path addCurveToPoint: CGPointMake(5.37, 10.54) controlPoint1: CGPointMake(5.07, 11.04) controlPoint2: CGPointMake(5.37, 10.54)];
        [bezier18Path addCurveToPoint: CGPointMake(4.67, 11.04) controlPoint1: CGPointMake(5.37, 10.54) controlPoint2: CGPointMake(4.77, 10.84)];
        [bezier18Path addCurveToPoint: CGPointMake(4.47, 11.74) controlPoint1: CGPointMake(4.57, 11.24) controlPoint2: CGPointMake(4.47, 11.34)];
        [bezier18Path addCurveToPoint: CGPointMake(4.47, 12.84) controlPoint1: CGPointMake(4.47, 12.14) controlPoint2: CGPointMake(4.67, 12.64)];
        [bezier18Path addCurveToPoint: CGPointMake(3.57, 13.24) controlPoint1: CGPointMake(4.27, 13.04) controlPoint2: CGPointMake(4.07, 13.14)];
        [bezier18Path addCurveToPoint: CGPointMake(2.77, 13.34) controlPoint1: CGPointMake(3.07, 13.34) controlPoint2: CGPointMake(2.77, 13.34)];
        [bezier18Path addCurveToPoint: CGPointMake(4.37, 12.54) controlPoint1: CGPointMake(2.77, 13.34) controlPoint2: CGPointMake(4.27, 13.04)];
        [bezier18Path addCurveToPoint: CGPointMake(4.47, 10.94) controlPoint1: CGPointMake(4.37, 12.04) controlPoint2: CGPointMake(4.07, 11.34)];
        [bezier18Path addCurveToPoint: CGPointMake(5.67, 10.04) controlPoint1: CGPointMake(4.87, 10.54) controlPoint2: CGPointMake(5.37, 10.34)];
        [bezier18Path addCurveToPoint: CGPointMake(6.27, 8.94) controlPoint1: CGPointMake(5.97, 9.74) controlPoint2: CGPointMake(6.27, 9.44)];
        [bezier18Path addCurveToPoint: CGPointMake(6.27, 7.74) controlPoint1: CGPointMake(6.27, 8.44) controlPoint2: CGPointMake(6.27, 7.74)];
        [bezier18Path addLineToPoint: CGPointMake(6.17, 8.14)];
        [bezier18Path closePath];
        bezier18Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier18Path fill];
    }
    
    
    //// Group 19
    {
        //// Bezier 19 Drawing
        UIBezierPath* bezier19Path = UIBezierPath.bezierPath;
        [bezier19Path moveToPoint: CGPointMake(8.87, 7.74)];
        [bezier19Path addLineToPoint: CGPointMake(8.87, 8.04)];
        [bezier19Path addCurveToPoint: CGPointMake(10.07, 8.04) controlPoint1: CGPointMake(8.87, 8.04) controlPoint2: CGPointMake(9.57, 7.94)];
        [bezier19Path addCurveToPoint: CGPointMake(10.77, 8.24) controlPoint1: CGPointMake(10.57, 8.14) controlPoint2: CGPointMake(10.77, 8.24)];
        [bezier19Path addCurveToPoint: CGPointMake(10.77, 9.04) controlPoint1: CGPointMake(10.77, 8.24) controlPoint2: CGPointMake(10.87, 8.74)];
        [bezier19Path addCurveToPoint: CGPointMake(10.37, 10.44) controlPoint1: CGPointMake(10.67, 9.44) controlPoint2: CGPointMake(10.37, 9.94)];
        [bezier19Path addCurveToPoint: CGPointMake(10.77, 12.04) controlPoint1: CGPointMake(10.37, 10.94) controlPoint2: CGPointMake(10.57, 11.64)];
        [bezier19Path addCurveToPoint: CGPointMake(11.37, 12.84) controlPoint1: CGPointMake(10.97, 12.44) controlPoint2: CGPointMake(11.37, 12.84)];
        [bezier19Path addCurveToPoint: CGPointMake(10.77, 11.44) controlPoint1: CGPointMake(11.37, 12.84) controlPoint2: CGPointMake(10.97, 12.14)];
        [bezier19Path addCurveToPoint: CGPointMake(10.67, 10.24) controlPoint1: CGPointMake(10.57, 10.74) controlPoint2: CGPointMake(10.57, 10.54)];
        [bezier19Path addCurveToPoint: CGPointMake(10.97, 9.34) controlPoint1: CGPointMake(10.77, 9.84) controlPoint2: CGPointMake(10.87, 9.64)];
        [bezier19Path addCurveToPoint: CGPointMake(11.17, 8.44) controlPoint1: CGPointMake(11.07, 9.04) controlPoint2: CGPointMake(11.17, 8.44)];
        [bezier19Path addCurveToPoint: CGPointMake(11.67, 9.14) controlPoint1: CGPointMake(11.17, 8.44) controlPoint2: CGPointMake(11.57, 8.74)];
        [bezier19Path addCurveToPoint: CGPointMake(12.07, 10.14) controlPoint1: CGPointMake(11.77, 9.54) controlPoint2: CGPointMake(11.87, 9.94)];
        [bezier19Path addCurveToPoint: CGPointMake(12.37, 10.54) controlPoint1: CGPointMake(12.17, 10.34) controlPoint2: CGPointMake(12.37, 10.54)];
        [bezier19Path addCurveToPoint: CGPointMake(12.47, 12.14) controlPoint1: CGPointMake(12.37, 10.54) controlPoint2: CGPointMake(12.17, 11.54)];
        [bezier19Path addCurveToPoint: CGPointMake(12.97, 14.04) controlPoint1: CGPointMake(12.67, 12.84) controlPoint2: CGPointMake(12.97, 13.44)];
        [bezier19Path addCurveToPoint: CGPointMake(12.57, 15.74) controlPoint1: CGPointMake(12.87, 14.64) controlPoint2: CGPointMake(12.77, 15.24)];
        [bezier19Path addCurveToPoint: CGPointMake(12.37, 17.14) controlPoint1: CGPointMake(12.37, 16.24) controlPoint2: CGPointMake(12.27, 17.04)];
        [bezier19Path addCurveToPoint: CGPointMake(12.67, 16.24) controlPoint1: CGPointMake(12.47, 17.24) controlPoint2: CGPointMake(12.57, 16.74)];
        [bezier19Path addCurveToPoint: CGPointMake(13.07, 14.54) controlPoint1: CGPointMake(12.87, 15.74) controlPoint2: CGPointMake(13.07, 14.54)];
        [bezier19Path addCurveToPoint: CGPointMake(13.37, 15.54) controlPoint1: CGPointMake(13.07, 14.54) controlPoint2: CGPointMake(13.17, 15.04)];
        [bezier19Path addCurveToPoint: CGPointMake(13.87, 16.74) controlPoint1: CGPointMake(13.57, 16.14) controlPoint2: CGPointMake(13.87, 16.94)];
        [bezier19Path addCurveToPoint: CGPointMake(13.47, 14.94) controlPoint1: CGPointMake(13.97, 16.54) controlPoint2: CGPointMake(13.67, 15.64)];
        [bezier19Path addCurveToPoint: CGPointMake(13.17, 13.64) controlPoint1: CGPointMake(13.27, 14.24) controlPoint2: CGPointMake(13.17, 14.04)];
        [bezier19Path addCurveToPoint: CGPointMake(12.97, 12.14) controlPoint1: CGPointMake(13.17, 13.24) controlPoint2: CGPointMake(13.17, 12.54)];
        [bezier19Path addCurveToPoint: CGPointMake(12.67, 11.24) controlPoint1: CGPointMake(12.77, 11.74) controlPoint2: CGPointMake(12.67, 11.54)];
        [bezier19Path addCurveToPoint: CGPointMake(12.67, 10.74) controlPoint1: CGPointMake(12.67, 10.94) controlPoint2: CGPointMake(12.67, 10.74)];
        [bezier19Path addCurveToPoint: CGPointMake(13.37, 11.44) controlPoint1: CGPointMake(12.67, 10.74) controlPoint2: CGPointMake(13.17, 11.14)];
        [bezier19Path addCurveToPoint: CGPointMake(13.97, 12.44) controlPoint1: CGPointMake(13.57, 11.64) controlPoint2: CGPointMake(13.77, 12.04)];
        [bezier19Path addCurveToPoint: CGPointMake(14.67, 13.94) controlPoint1: CGPointMake(14.17, 12.94) controlPoint2: CGPointMake(14.57, 14.04)];
        [bezier19Path addCurveToPoint: CGPointMake(14.37, 13.04) controlPoint1: CGPointMake(14.67, 13.84) controlPoint2: CGPointMake(14.47, 13.24)];
        [bezier19Path addCurveToPoint: CGPointMake(14.17, 12.34) controlPoint1: CGPointMake(14.27, 12.84) controlPoint2: CGPointMake(14.07, 12.24)];
        [bezier19Path addCurveToPoint: CGPointMake(14.87, 13.24) controlPoint1: CGPointMake(14.27, 12.44) controlPoint2: CGPointMake(14.97, 13.34)];
        [bezier19Path addCurveToPoint: CGPointMake(13.97, 11.94) controlPoint1: CGPointMake(14.87, 13.04) controlPoint2: CGPointMake(14.27, 12.24)];
        [bezier19Path addCurveToPoint: CGPointMake(12.77, 10.64) controlPoint1: CGPointMake(13.77, 11.64) controlPoint2: CGPointMake(12.97, 10.84)];
        [bezier19Path addCurveToPoint: CGPointMake(12.17, 9.64) controlPoint1: CGPointMake(12.57, 10.34) controlPoint2: CGPointMake(12.37, 10.14)];
        [bezier19Path addCurveToPoint: CGPointMake(10.87, 7.94) controlPoint1: CGPointMake(11.97, 9.14) controlPoint2: CGPointMake(11.77, 8.24)];
        [bezier19Path addCurveToPoint: CGPointMake(9.47, 7.74) controlPoint1: CGPointMake(9.97, 7.64) controlPoint2: CGPointMake(9.67, 7.74)];
        [bezier19Path addCurveToPoint: CGPointMake(8.87, 7.74) controlPoint1: CGPointMake(9.07, 7.74) controlPoint2: CGPointMake(8.87, 7.74)];
        [bezier19Path closePath];
        bezier19Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier19Path fill];
    }
    
    
    //// Group 20
    {
        //// Bezier 20 Drawing
        UIBezierPath* bezier20Path = UIBezierPath.bezierPath;
        [bezier20Path moveToPoint: CGPointMake(13.97, 4.34)];
        [bezier20Path addCurveToPoint: CGPointMake(10.27, 4.44) controlPoint1: CGPointMake(13.97, 4.34) controlPoint2: CGPointMake(11.57, 4.04)];
        [bezier20Path addCurveToPoint: CGPointMake(7.57, 5.34) controlPoint1: CGPointMake(8.97, 4.84) controlPoint2: CGPointMake(7.57, 5.34)];
        [bezier20Path addCurveToPoint: CGPointMake(6.47, 5.64) controlPoint1: CGPointMake(7.57, 5.34) controlPoint2: CGPointMake(7.07, 4.54)];
        [bezier20Path addCurveToPoint: CGPointMake(6.77, 8.34) controlPoint1: CGPointMake(5.87, 6.84) controlPoint2: CGPointMake(5.87, 8.14)];
        [bezier20Path addCurveToPoint: CGPointMake(8.47, 8.04) controlPoint1: CGPointMake(7.67, 8.54) controlPoint2: CGPointMake(8.47, 8.04)];
        [bezier20Path addCurveToPoint: CGPointMake(9.77, 6.44) controlPoint1: CGPointMake(8.47, 8.04) controlPoint2: CGPointMake(8.17, 6.94)];
        [bezier20Path addCurveToPoint: CGPointMake(12.47, 6.04) controlPoint1: CGPointMake(11.37, 5.94) controlPoint2: CGPointMake(12.47, 6.04)];
        [bezier20Path addCurveToPoint: CGPointMake(13.77, 6.04) controlPoint1: CGPointMake(12.47, 6.04) controlPoint2: CGPointMake(13.77, 6.24)];
        [bezier20Path addCurveToPoint: CGPointMake(13.97, 4.34) controlPoint1: CGPointMake(13.77, 5.94) controlPoint2: CGPointMake(13.97, 4.34)];
        [bezier20Path closePath];
        bezier20Path.miterLimit = 4;
        
        [fillColor7 setFill];
        [bezier20Path fill];
    }
    
    
    //// Group 21
    {
        //// Bezier 21 Drawing
        UIBezierPath* bezier21Path = UIBezierPath.bezierPath;
        [bezier21Path moveToPoint: CGPointMake(13.87, 6.14)];
        [bezier21Path addCurveToPoint: CGPointMake(14.27, 5.24) controlPoint1: CGPointMake(14.07, 6.14) controlPoint2: CGPointMake(14.27, 5.74)];
        [bezier21Path addCurveToPoint: CGPointMake(13.87, 4.34) controlPoint1: CGPointMake(14.27, 4.74) controlPoint2: CGPointMake(14.07, 4.34)];
        [bezier21Path addCurveToPoint: CGPointMake(13.47, 5.24) controlPoint1: CGPointMake(13.67, 4.34) controlPoint2: CGPointMake(13.47, 4.74)];
        [bezier21Path addCurveToPoint: CGPointMake(13.87, 6.14) controlPoint1: CGPointMake(13.47, 5.64) controlPoint2: CGPointMake(13.57, 6.14)];
        [bezier21Path closePath];
        bezier21Path.miterLimit = 4;
        
        [fillColor4 setFill];
        [bezier21Path fill];
        
        
        //// Bezier 22 Drawing
        UIBezierPath* bezier22Path = UIBezierPath.bezierPath;
        [bezier22Path moveToPoint: CGPointMake(13.87, 6.24)];
        [bezier22Path addLineToPoint: CGPointMake(13.87, 6.24)];
        [bezier22Path addLineToPoint: CGPointMake(13.87, 6.24)];
        [bezier22Path addCurveToPoint: CGPointMake(13.37, 5.14) controlPoint1: CGPointMake(13.47, 6.24) controlPoint2: CGPointMake(13.37, 5.74)];
        [bezier22Path addCurveToPoint: CGPointMake(13.97, 4.14) controlPoint1: CGPointMake(13.37, 4.64) controlPoint2: CGPointMake(13.57, 4.14)];
        [bezier22Path addLineToPoint: CGPointMake(13.97, 4.14)];
        [bezier22Path addCurveToPoint: CGPointMake(14.47, 5.24) controlPoint1: CGPointMake(14.37, 4.14) controlPoint2: CGPointMake(14.47, 4.64)];
        [bezier22Path addCurveToPoint: CGPointMake(13.87, 6.24) controlPoint1: CGPointMake(14.37, 5.74) controlPoint2: CGPointMake(14.17, 6.24)];
        [bezier22Path closePath];
        [bezier22Path moveToPoint: CGPointMake(13.87, 4.34)];
        [bezier22Path addCurveToPoint: CGPointMake(13.57, 5.14) controlPoint1: CGPointMake(13.77, 4.34) controlPoint2: CGPointMake(13.57, 4.64)];
        [bezier22Path addCurveToPoint: CGPointMake(13.87, 5.94) controlPoint1: CGPointMake(13.57, 5.64) controlPoint2: CGPointMake(13.77, 5.94)];
        [bezier22Path addLineToPoint: CGPointMake(13.87, 5.94)];
        [bezier22Path addCurveToPoint: CGPointMake(14.17, 5.14) controlPoint1: CGPointMake(13.97, 5.94) controlPoint2: CGPointMake(14.17, 5.64)];
        [bezier22Path addCurveToPoint: CGPointMake(13.87, 4.34) controlPoint1: CGPointMake(14.17, 4.64) controlPoint2: CGPointMake(13.97, 4.34)];
        [bezier22Path closePath];
        bezier22Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier22Path fill];
    }
    
    
    //// Group 22
    {
        //// Bezier 23 Drawing
        UIBezierPath* bezier23Path = UIBezierPath.bezierPath;
        [bezier23Path moveToPoint: CGPointMake(5.77, 2.34)];
        [bezier23Path addCurveToPoint: CGPointMake(6.37, 3.04) controlPoint1: CGPointMake(5.97, 2.64) controlPoint2: CGPointMake(6.07, 2.94)];
        [bezier23Path addLineToPoint: CGPointMake(6.47, 3.04)];
        [bezier23Path addCurveToPoint: CGPointMake(6.67, 3.04) controlPoint1: CGPointMake(6.57, 3.04) controlPoint2: CGPointMake(6.57, 3.04)];
        [bezier23Path addCurveToPoint: CGPointMake(7.07, 1.74) controlPoint1: CGPointMake(6.97, 2.84) controlPoint2: CGPointMake(7.07, 2.34)];
        [bezier23Path addCurveToPoint: CGPointMake(6.97, 0.44) controlPoint1: CGPointMake(7.07, 1.34) controlPoint2: CGPointMake(6.97, 0.54)];
        [bezier23Path addLineToPoint: CGPointMake(6.57, 0.44)];
        [bezier23Path addCurveToPoint: CGPointMake(6.67, 1.74) controlPoint1: CGPointMake(6.57, 0.44) controlPoint2: CGPointMake(6.67, 1.24)];
        [bezier23Path addCurveToPoint: CGPointMake(6.67, 2.44) controlPoint1: CGPointMake(6.67, 1.94) controlPoint2: CGPointMake(6.67, 2.24)];
        [bezier23Path addCurveToPoint: CGPointMake(6.57, 2.74) controlPoint1: CGPointMake(6.67, 2.74) controlPoint2: CGPointMake(6.57, 2.74)];
        [bezier23Path addLineToPoint: CGPointMake(6.57, 2.74)];
        [bezier23Path addCurveToPoint: CGPointMake(6.27, 2.24) controlPoint1: CGPointMake(6.47, 2.74) controlPoint2: CGPointMake(6.27, 2.44)];
        [bezier23Path addCurveToPoint: CGPointMake(6.17, 2.04) controlPoint1: CGPointMake(6.27, 2.14) controlPoint2: CGPointMake(6.17, 2.14)];
        [bezier23Path addCurveToPoint: CGPointMake(5.57, 0.74) controlPoint1: CGPointMake(5.97, 1.64) controlPoint2: CGPointMake(5.57, 0.74)];
        [bezier23Path addLineToPoint: CGPointMake(5.27, 0.84)];
        [bezier23Path addCurveToPoint: CGPointMake(5.97, 2.14) controlPoint1: CGPointMake(5.27, 0.84) controlPoint2: CGPointMake(5.67, 1.74)];
        [bezier23Path addCurveToPoint: CGPointMake(5.77, 2.34) controlPoint1: CGPointMake(5.77, 2.24) controlPoint2: CGPointMake(5.77, 2.24)];
        [bezier23Path closePath];
        bezier23Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier23Path fill];
        
        
        //// Bezier 24 Drawing
        UIBezierPath* bezier24Path = UIBezierPath.bezierPath;
        [bezier24Path moveToPoint: CGPointMake(8.07, 2.84)];
        [bezier24Path addCurveToPoint: CGPointMake(8.07, 2.84) controlPoint1: CGPointMake(8.07, 2.84) controlPoint2: CGPointMake(8.17, 2.84)];
        [bezier24Path addCurveToPoint: CGPointMake(9.07, 1.64) controlPoint1: CGPointMake(8.47, 2.74) controlPoint2: CGPointMake(8.77, 2.24)];
        [bezier24Path addLineToPoint: CGPointMake(9.07, 1.54)];
        [bezier24Path addCurveToPoint: CGPointMake(9.57, 0.74) controlPoint1: CGPointMake(9.27, 1.14) controlPoint2: CGPointMake(9.57, 0.74)];
        [bezier24Path addLineToPoint: CGPointMake(9.27, 0.54)];
        [bezier24Path addCurveToPoint: CGPointMake(8.77, 1.44) controlPoint1: CGPointMake(9.27, 0.54) controlPoint2: CGPointMake(8.97, 0.94)];
        [bezier24Path addLineToPoint: CGPointMake(8.77, 1.54)];
        [bezier24Path addCurveToPoint: CGPointMake(8.37, 2.24) controlPoint1: CGPointMake(8.67, 1.74) controlPoint2: CGPointMake(8.57, 2.04)];
        [bezier24Path addCurveToPoint: CGPointMake(8.17, 2.54) controlPoint1: CGPointMake(8.27, 2.44) controlPoint2: CGPointMake(8.17, 2.54)];
        [bezier24Path addCurveToPoint: CGPointMake(8.27, 2.04) controlPoint1: CGPointMake(8.17, 2.44) controlPoint2: CGPointMake(8.17, 2.14)];
        [bezier24Path addCurveToPoint: CGPointMake(8.27, 1.84) controlPoint1: CGPointMake(8.27, 1.94) controlPoint2: CGPointMake(8.27, 1.94)];
        [bezier24Path addCurveToPoint: CGPointMake(8.47, 0.74) controlPoint1: CGPointMake(8.37, 1.34) controlPoint2: CGPointMake(8.47, 0.74)];
        [bezier24Path addLineToPoint: CGPointMake(8.07, 0.64)];
        [bezier24Path addCurveToPoint: CGPointMake(7.87, 1.84) controlPoint1: CGPointMake(8.07, 0.64) controlPoint2: CGPointMake(7.87, 1.34)];
        [bezier24Path addCurveToPoint: CGPointMake(7.87, 2.04) controlPoint1: CGPointMake(7.87, 1.94) controlPoint2: CGPointMake(7.87, 1.94)];
        [bezier24Path addCurveToPoint: CGPointMake(7.97, 2.94) controlPoint1: CGPointMake(7.77, 2.44) controlPoint2: CGPointMake(7.77, 2.74)];
        [bezier24Path addCurveToPoint: CGPointMake(8.07, 2.84) controlPoint1: CGPointMake(7.97, 2.74) controlPoint2: CGPointMake(7.97, 2.84)];
        [bezier24Path closePath];
        bezier24Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier24Path fill];
        
        
        //// Bezier 25 Drawing
        UIBezierPath* bezier25Path = UIBezierPath.bezierPath;
        [bezier25Path moveToPoint: CGPointMake(12.17, 5.84)];
        [bezier25Path addCurveToPoint: CGPointMake(8.87, 6.74) controlPoint1: CGPointMake(11.47, 5.84) controlPoint2: CGPointMake(9.47, 6.24)];
        [bezier25Path addCurveToPoint: CGPointMake(8.27, 8.04) controlPoint1: CGPointMake(8.37, 7.14) controlPoint2: CGPointMake(8.27, 7.74)];
        [bezier25Path addCurveToPoint: CGPointMake(8.07, 8.14) controlPoint1: CGPointMake(8.27, 8.04) controlPoint2: CGPointMake(8.17, 8.14)];
        [bezier25Path addCurveToPoint: CGPointMake(6.57, 8.04) controlPoint1: CGPointMake(7.87, 8.24) controlPoint2: CGPointMake(6.97, 8.34)];
        [bezier25Path addCurveToPoint: CGPointMake(6.37, 6.64) controlPoint1: CGPointMake(6.17, 7.74) controlPoint2: CGPointMake(6.27, 7.04)];
        [bezier25Path addCurveToPoint: CGPointMake(7.07, 5.44) controlPoint1: CGPointMake(6.47, 6.24) controlPoint2: CGPointMake(6.67, 5.74)];
        [bezier25Path addCurveToPoint: CGPointMake(7.47, 5.44) controlPoint1: CGPointMake(7.27, 5.24) controlPoint2: CGPointMake(7.47, 5.44)];
        [bezier25Path addLineToPoint: CGPointMake(7.57, 5.54)];
        [bezier25Path addLineToPoint: CGPointMake(7.77, 5.44)];
        [bezier25Path addCurveToPoint: CGPointMake(8.67, 4.94) controlPoint1: CGPointMake(7.77, 5.44) controlPoint2: CGPointMake(8.17, 5.24)];
        [bezier25Path addCurveToPoint: CGPointMake(11.27, 4.44) controlPoint1: CGPointMake(9.07, 4.74) controlPoint2: CGPointMake(10.57, 4.44)];
        [bezier25Path addCurveToPoint: CGPointMake(13.87, 4.44) controlPoint1: CGPointMake(12.07, 4.44) controlPoint2: CGPointMake(13.87, 4.44)];
        [bezier25Path addLineToPoint: CGPointMake(13.87, 4.04)];
        [bezier25Path addCurveToPoint: CGPointMake(11.27, 4.04) controlPoint1: CGPointMake(13.77, 4.04) controlPoint2: CGPointMake(12.07, 4.04)];
        [bezier25Path addCurveToPoint: CGPointMake(8.47, 4.64) controlPoint1: CGPointMake(10.47, 4.04) controlPoint2: CGPointMake(8.97, 4.34)];
        [bezier25Path addCurveToPoint: CGPointMake(7.67, 5.04) controlPoint1: CGPointMake(8.17, 4.74) controlPoint2: CGPointMake(7.87, 4.94)];
        [bezier25Path addCurveToPoint: CGPointMake(7.37, 4.94) controlPoint1: CGPointMake(7.57, 4.94) controlPoint2: CGPointMake(7.47, 4.94)];
        [bezier25Path addCurveToPoint: CGPointMake(6.87, 5.04) controlPoint1: CGPointMake(7.17, 4.94) controlPoint2: CGPointMake(6.97, 4.94)];
        [bezier25Path addCurveToPoint: CGPointMake(5.97, 6.44) controlPoint1: CGPointMake(6.37, 5.34) controlPoint2: CGPointMake(6.07, 6.04)];
        [bezier25Path addCurveToPoint: CGPointMake(6.07, 7.84) controlPoint1: CGPointMake(5.87, 7.04) controlPoint2: CGPointMake(5.87, 7.54)];
        [bezier25Path addCurveToPoint: CGPointMake(4.57, 8.74) controlPoint1: CGPointMake(5.97, 7.94) controlPoint2: CGPointMake(5.47, 8.54)];
        [bezier25Path addCurveToPoint: CGPointMake(2.97, 8.64) controlPoint1: CGPointMake(3.77, 8.94) controlPoint2: CGPointMake(3.27, 8.74)];
        [bezier25Path addCurveToPoint: CGPointMake(3.17, 6.24) controlPoint1: CGPointMake(2.97, 8.24) controlPoint2: CGPointMake(2.97, 6.94)];
        [bezier25Path addCurveToPoint: CGPointMake(4.37, 4.14) controlPoint1: CGPointMake(3.27, 5.54) controlPoint2: CGPointMake(4.07, 4.64)];
        [bezier25Path addCurveToPoint: CGPointMake(4.57, 3.94) controlPoint1: CGPointMake(4.47, 4.04) controlPoint2: CGPointMake(4.47, 3.94)];
        [bezier25Path addCurveToPoint: CGPointMake(4.77, 2.84) controlPoint1: CGPointMake(4.77, 3.54) controlPoint2: CGPointMake(4.77, 3.34)];
        [bezier25Path addLineToPoint: CGPointMake(4.77, 2.74)];
        [bezier25Path addCurveToPoint: CGPointMake(4.07, 1.24) controlPoint1: CGPointMake(4.77, 2.14) controlPoint2: CGPointMake(4.17, 1.24)];
        [bezier25Path addLineToPoint: CGPointMake(3.77, 1.44)];
        [bezier25Path addCurveToPoint: CGPointMake(4.37, 2.74) controlPoint1: CGPointMake(3.97, 1.64) controlPoint2: CGPointMake(4.37, 2.34)];
        [bezier25Path addLineToPoint: CGPointMake(4.37, 2.84)];
        [bezier25Path addCurveToPoint: CGPointMake(4.27, 3.64) controlPoint1: CGPointMake(4.37, 3.34) controlPoint2: CGPointMake(4.37, 3.44)];
        [bezier25Path addCurveToPoint: CGPointMake(4.07, 3.84) controlPoint1: CGPointMake(4.27, 3.74) controlPoint2: CGPointMake(4.17, 3.74)];
        [bezier25Path addCurveToPoint: CGPointMake(2.77, 6.04) controlPoint1: CGPointMake(3.67, 4.34) controlPoint2: CGPointMake(2.87, 5.34)];
        [bezier25Path addCurveToPoint: CGPointMake(2.57, 8.54) controlPoint1: CGPointMake(2.57, 6.84) controlPoint2: CGPointMake(2.57, 8.54)];
        [bezier25Path addLineToPoint: CGPointMake(2.57, 8.64)];
        [bezier25Path addLineToPoint: CGPointMake(2.67, 8.74)];
        [bezier25Path addCurveToPoint: CGPointMake(3.87, 8.94) controlPoint1: CGPointMake(2.67, 8.74) controlPoint2: CGPointMake(3.17, 8.94)];
        [bezier25Path addCurveToPoint: CGPointMake(4.57, 8.84) controlPoint1: CGPointMake(4.07, 8.94) controlPoint2: CGPointMake(4.37, 8.94)];
        [bezier25Path addCurveToPoint: CGPointMake(6.27, 7.94) controlPoint1: CGPointMake(5.47, 8.64) controlPoint2: CGPointMake(6.07, 8.14)];
        [bezier25Path addLineToPoint: CGPointMake(6.37, 8.04)];
        [bezier25Path addCurveToPoint: CGPointMake(7.57, 8.34) controlPoint1: CGPointMake(6.67, 8.24) controlPoint2: CGPointMake(7.17, 8.34)];
        [bezier25Path addCurveToPoint: CGPointMake(8.37, 8.24) controlPoint1: CGPointMake(7.87, 8.34) controlPoint2: CGPointMake(8.17, 8.34)];
        [bezier25Path addCurveToPoint: CGPointMake(8.77, 7.94) controlPoint1: CGPointMake(8.57, 8.14) controlPoint2: CGPointMake(8.77, 8.04)];
        [bezier25Path addLineToPoint: CGPointMake(8.77, 7.94)];
        [bezier25Path addLineToPoint: CGPointMake(8.77, 7.94)];
        [bezier25Path addCurveToPoint: CGPointMake(9.17, 6.94) controlPoint1: CGPointMake(8.77, 7.94) controlPoint2: CGPointMake(8.67, 7.34)];
        [bezier25Path addCurveToPoint: CGPointMake(12.27, 6.14) controlPoint1: CGPointMake(9.67, 6.54) controlPoint2: CGPointMake(11.57, 6.14)];
        [bezier25Path addCurveToPoint: CGPointMake(13.97, 6.14) controlPoint1: CGPointMake(12.97, 6.14) controlPoint2: CGPointMake(13.97, 6.14)];
        [bezier25Path addLineToPoint: CGPointMake(13.97, 5.74)];
        [bezier25Path addCurveToPoint: CGPointMake(12.17, 5.84) controlPoint1: CGPointMake(13.87, 5.94) controlPoint2: CGPointMake(12.87, 5.84)];
        [bezier25Path closePath];
        bezier25Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier25Path fill];
    }
    
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
