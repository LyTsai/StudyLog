//
//  ASymbol_10_Year Survival.m
//  AProgressBars
//
//  Created by hui wang on 7/11/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_10_Year Survival.h"

@interface ASymbol_10_Year_Survival (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbol_10_Year_Survival

@synthesize fillColor31, fillColor6, fillColor32;

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(100, 100);
    
    fillColor31 = [UIColor colorWithRed: 0.843 green: 0.149 blue: 0.11 alpha: 1];
    fillColor6 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    fillColor32 = [UIColor colorWithRed: 0.216 green: 0.267 blue: 0.318 alpha: 1];
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_10_Year_Survival* draw = [[ASymbol_10_Year_Survival alloc] init];
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

// draw path
-(void) drawPath
{
    //// Group 359
    {
        //// Group 360
        {
            //// Group 361
            {
                //// Oval 49 Drawing
                UIBezierPath* oval49Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(17.26, 0, 27.62, 18.62)];
                [fillColor32 setFill];
                [oval49Path fill];
            }
            
            
            //// Group 362
            {
                //// Group 363
                {
                    //// Bezier 426 Drawing
                    UIBezierPath* bezier426Path = UIBezierPath.bezierPath;
                    [bezier426Path moveToPoint: CGPointMake(29.88, 94.96)];
                    [bezier426Path addCurveToPoint: CGPointMake(22.58, 99.65) controlPoint1: CGPointMake(29.88, 97.56) controlPoint2: CGPointMake(26.62, 99.65)];
                    [bezier426Path addLineToPoint: CGPointMake(21.16, 99.65)];
                    [bezier426Path addCurveToPoint: CGPointMake(13.87, 94.96) controlPoint1: CGPointMake(17.13, 99.65) controlPoint2: CGPointMake(13.87, 97.56)];
                    [bezier426Path addLineToPoint: CGPointMake(13.87, 47.12)];
                    [bezier426Path addCurveToPoint: CGPointMake(21.16, 42.45) controlPoint1: CGPointMake(13.87, 44.53) controlPoint2: CGPointMake(17.13, 42.45)];
                    [bezier426Path addLineToPoint: CGPointMake(22.58, 42.45)];
                    [bezier426Path addCurveToPoint: CGPointMake(29.88, 47.12) controlPoint1: CGPointMake(26.62, 42.45) controlPoint2: CGPointMake(29.88, 44.54)];
                    [bezier426Path addLineToPoint: CGPointMake(29.88, 94.96)];
                    [bezier426Path closePath];
                    bezier426Path.miterLimit = 4;
                    
                    [fillColor32 setFill];
                    [bezier426Path fill];
                }
                
                
                //// Group 364
                {
                    //// Bezier 427 Drawing
                    UIBezierPath* bezier427Path = UIBezierPath.bezierPath;
                    [bezier427Path moveToPoint: CGPointMake(48.29, 94.96)];
                    [bezier427Path addCurveToPoint: CGPointMake(40.99, 99.65) controlPoint1: CGPointMake(48.29, 97.56) controlPoint2: CGPointMake(45.02, 99.65)];
                    [bezier427Path addLineToPoint: CGPointMake(39.57, 99.65)];
                    [bezier427Path addCurveToPoint: CGPointMake(32.28, 94.96) controlPoint1: CGPointMake(35.54, 99.65) controlPoint2: CGPointMake(32.28, 97.56)];
                    [bezier427Path addLineToPoint: CGPointMake(32.28, 47.12)];
                    [bezier427Path addCurveToPoint: CGPointMake(39.57, 42.45) controlPoint1: CGPointMake(32.28, 44.53) controlPoint2: CGPointMake(35.54, 42.45)];
                    [bezier427Path addLineToPoint: CGPointMake(40.99, 42.45)];
                    [bezier427Path addCurveToPoint: CGPointMake(48.29, 47.12) controlPoint1: CGPointMake(45.02, 42.45) controlPoint2: CGPointMake(48.29, 44.54)];
                    [bezier427Path addLineToPoint: CGPointMake(48.29, 94.96)];
                    [bezier427Path closePath];
                    bezier427Path.miterLimit = 4;
                    
                    [fillColor32 setFill];
                    [bezier427Path fill];
                }
                
                
                //// Group 365
                {
                    //// Bezier 428 Drawing
                    UIBezierPath* bezier428Path = UIBezierPath.bezierPath;
                    [bezier428Path moveToPoint: CGPointMake(48.29, 24.6)];
                    [bezier428Path addCurveToPoint: CGPointMake(41.14, 19.92) controlPoint1: CGPointMake(48.29, 22.01) controlPoint2: CGPointMake(45.09, 19.92)];
                    [bezier428Path addLineToPoint: CGPointMake(21, 19.92)];
                    [bezier428Path addCurveToPoint: CGPointMake(13.87, 24.6) controlPoint1: CGPointMake(17.06, 19.92) controlPoint2: CGPointMake(13.87, 22.01)];
                    [bezier428Path addLineToPoint: CGPointMake(13.87, 51.28)];
                    [bezier428Path addCurveToPoint: CGPointMake(21, 55.96) controlPoint1: CGPointMake(13.87, 53.86) controlPoint2: CGPointMake(17.06, 55.96)];
                    [bezier428Path addLineToPoint: CGPointMake(41.14, 55.96)];
                    [bezier428Path addCurveToPoint: CGPointMake(48.29, 51.28) controlPoint1: CGPointMake(45.09, 55.96) controlPoint2: CGPointMake(48.29, 53.86)];
                    [bezier428Path addLineToPoint: CGPointMake(48.29, 24.6)];
                    [bezier428Path closePath];
                    bezier428Path.miterLimit = 4;
                    
                    [fillColor32 setFill];
                    [bezier428Path fill];
                }
                
                
                //// Group 366
                {
                    //// Group 367
                    {
                        //// Bezier 429 Drawing
                        UIBezierPath* bezier429Path = UIBezierPath.bezierPath;
                        [bezier429Path moveToPoint: CGPointMake(9.3, 38.22)];
                        [bezier429Path addCurveToPoint: CGPointMake(4.65, 34.92) controlPoint1: CGPointMake(9.3, 36.38) controlPoint2: CGPointMake(7.22, 34.92)];
                        [bezier429Path addLineToPoint: CGPointMake(4.65, 34.92)];
                        [bezier429Path addCurveToPoint: CGPointMake(0, 38.22) controlPoint1: CGPointMake(2.09, 34.92) controlPoint2: CGPointMake(0, 36.39)];
                        [bezier429Path addLineToPoint: CGPointMake(0, 57.73)];
                        [bezier429Path addCurveToPoint: CGPointMake(4.65, 61.04) controlPoint1: CGPointMake(0, 59.56) controlPoint2: CGPointMake(2.09, 61.04)];
                        [bezier429Path addLineToPoint: CGPointMake(4.65, 61.04)];
                        [bezier429Path addCurveToPoint: CGPointMake(9.3, 57.73) controlPoint1: CGPointMake(7.22, 61.04) controlPoint2: CGPointMake(9.3, 59.56)];
                        [bezier429Path addLineToPoint: CGPointMake(9.3, 38.22)];
                        [bezier429Path closePath];
                        bezier429Path.miterLimit = 4;
                        
                        [fillColor32 setFill];
                        [bezier429Path fill];
                    }
                    
                    
                    //// Group 368
                    {
                        //// Bezier 430 Drawing
                        UIBezierPath* bezier430Path = UIBezierPath.bezierPath;
                        [bezier430Path moveToPoint: CGPointMake(18.47, 19.97)];
                        [bezier430Path addCurveToPoint: CGPointMake(5.53, 26.85) controlPoint1: CGPointMake(18.47, 19.97) controlPoint2: CGPointMake(10.55, 21.78)];
                        [bezier430Path addCurveToPoint: CGPointMake(0.03, 40.37) controlPoint1: CGPointMake(-0.77, 33.23) controlPoint2: CGPointMake(0.03, 40.37)];
                        [bezier430Path addLineToPoint: CGPointMake(9.69, 43.53)];
                        [bezier430Path addCurveToPoint: CGPointMake(12.24, 32.7) controlPoint1: CGPointMake(9.69, 43.53) controlPoint2: CGPointMake(9.16, 36.22)];
                        [bezier430Path addCurveToPoint: CGPointMake(16.54, 30.19) controlPoint1: CGPointMake(13.89, 30.84) controlPoint2: CGPointMake(16.54, 30.19)];
                        [bezier430Path addLineToPoint: CGPointMake(18.47, 19.97)];
                        [bezier430Path closePath];
                        bezier430Path.miterLimit = 4;
                        
                        [fillColor32 setFill];
                        [bezier430Path fill];
                    }
                }
                
                
                //// Group 369
                {
                    //// Group 370
                    {
                        //// Bezier 431 Drawing
                        UIBezierPath* bezier431Path = UIBezierPath.bezierPath;
                        [bezier431Path moveToPoint: CGPointMake(52.83, 38.22)];
                        [bezier431Path addCurveToPoint: CGPointMake(57.48, 34.92) controlPoint1: CGPointMake(52.83, 36.38) controlPoint2: CGPointMake(54.91, 34.92)];
                        [bezier431Path addLineToPoint: CGPointMake(57.48, 34.92)];
                        [bezier431Path addCurveToPoint: CGPointMake(62.12, 38.22) controlPoint1: CGPointMake(60.05, 34.92) controlPoint2: CGPointMake(62.12, 36.39)];
                        [bezier431Path addLineToPoint: CGPointMake(62.12, 57.73)];
                        [bezier431Path addCurveToPoint: CGPointMake(57.48, 61.04) controlPoint1: CGPointMake(62.12, 59.56) controlPoint2: CGPointMake(60.05, 61.04)];
                        [bezier431Path addLineToPoint: CGPointMake(57.48, 61.04)];
                        [bezier431Path addCurveToPoint: CGPointMake(52.83, 57.73) controlPoint1: CGPointMake(54.92, 61.04) controlPoint2: CGPointMake(52.83, 59.56)];
                        [bezier431Path addLineToPoint: CGPointMake(52.83, 38.22)];
                        [bezier431Path closePath];
                        bezier431Path.miterLimit = 4;
                        
                        [fillColor32 setFill];
                        [bezier431Path fill];
                    }
                    
                    
                    //// Group 371
                    {
                        //// Bezier 432 Drawing
                        UIBezierPath* bezier432Path = UIBezierPath.bezierPath;
                        [bezier432Path moveToPoint: CGPointMake(43.66, 19.97)];
                        [bezier432Path addCurveToPoint: CGPointMake(56.6, 26.85) controlPoint1: CGPointMake(43.66, 19.97) controlPoint2: CGPointMake(51.6, 21.78)];
                        [bezier432Path addCurveToPoint: CGPointMake(62.09, 40.37) controlPoint1: CGPointMake(62.91, 33.23) controlPoint2: CGPointMake(62.09, 40.37)];
                        [bezier432Path addLineToPoint: CGPointMake(52.45, 43.53)];
                        [bezier432Path addCurveToPoint: CGPointMake(49.9, 32.7) controlPoint1: CGPointMake(52.45, 43.53) controlPoint2: CGPointMake(52.98, 36.22)];
                        [bezier432Path addCurveToPoint: CGPointMake(45.61, 30.19) controlPoint1: CGPointMake(48.27, 30.84) controlPoint2: CGPointMake(45.61, 30.19)];
                        [bezier432Path addLineToPoint: CGPointMake(43.66, 19.97)];
                        [bezier432Path closePath];
                        bezier432Path.miterLimit = 4;
                        
                        [fillColor32 setFill];
                        [bezier432Path fill];
                    }
                }
            }
            
            
            //// Group 372
            {
                //// Group 373
                {
                    //// Bezier 433 Drawing
                    UIBezierPath* bezier433Path = UIBezierPath.bezierPath;
                    [bezier433Path moveToPoint: CGPointMake(22.07, 9.8)];
                    [bezier433Path addLineToPoint: CGPointMake(22.07, 8.23)];
                    [bezier433Path addCurveToPoint: CGPointMake(20.99, 8.56) controlPoint1: CGPointMake(21.54, 8.45) controlPoint2: CGPointMake(21.16, 8.56)];
                    [bezier433Path addCurveToPoint: CGPointMake(20.75, 8.51) controlPoint1: CGPointMake(20.9, 8.56) controlPoint2: CGPointMake(20.81, 8.55)];
                    [bezier433Path addCurveToPoint: CGPointMake(20.63, 8.36) controlPoint1: CGPointMake(20.68, 8.46) controlPoint2: CGPointMake(20.63, 8.42)];
                    [bezier433Path addCurveToPoint: CGPointMake(20.75, 8.24) controlPoint1: CGPointMake(20.63, 8.31) controlPoint2: CGPointMake(20.68, 8.27)];
                    [bezier433Path addCurveToPoint: CGPointMake(21.12, 8.13) controlPoint1: CGPointMake(20.82, 8.21) controlPoint2: CGPointMake(20.93, 8.18)];
                    [bezier433Path addCurveToPoint: CGPointMake(21.72, 7.93) controlPoint1: CGPointMake(21.36, 8.07) controlPoint2: CGPointMake(21.58, 8.01)];
                    [bezier433Path addCurveToPoint: CGPointMake(22.14, 7.68) controlPoint1: CGPointMake(21.85, 7.86) controlPoint2: CGPointMake(22, 7.78)];
                    [bezier433Path addCurveToPoint: CGPointMake(22.31, 7.54) controlPoint1: CGPointMake(22.24, 7.6) controlPoint2: CGPointMake(22.31, 7.54)];
                    [bezier433Path addCurveToPoint: CGPointMake(22.55, 7.49) controlPoint1: CGPointMake(22.31, 7.54) controlPoint2: CGPointMake(22.46, 7.49)];
                    [bezier433Path addCurveToPoint: CGPointMake(22.81, 7.56) controlPoint1: CGPointMake(22.66, 7.49) controlPoint2: CGPointMake(22.75, 7.51)];
                    [bezier433Path addCurveToPoint: CGPointMake(22.92, 7.75) controlPoint1: CGPointMake(22.88, 7.6) controlPoint2: CGPointMake(22.92, 7.67)];
                    [bezier433Path addLineToPoint: CGPointMake(22.92, 9.74)];
                    [bezier433Path addCurveToPoint: CGPointMake(22.49, 10.08) controlPoint1: CGPointMake(22.92, 9.98) controlPoint2: CGPointMake(22.79, 10.08)];
                    [bezier433Path addCurveToPoint: CGPointMake(22.18, 10.02) controlPoint1: CGPointMake(22.36, 10.08) controlPoint2: CGPointMake(22.27, 10.06)];
                    [bezier433Path addCurveToPoint: CGPointMake(22.07, 9.8) controlPoint1: CGPointMake(22.12, 9.96) controlPoint2: CGPointMake(22.07, 9.89)];
                    [bezier433Path closePath];
                    bezier433Path.miterLimit = 4;
                    
                    [fillColor6 setFill];
                    [bezier433Path fill];
                }
                
                
                //// Group 374
                {
                    //// Bezier 434 Drawing
                    UIBezierPath* bezier434Path = UIBezierPath.bezierPath;
                    [bezier434Path moveToPoint: CGPointMake(27.55, 8.79)];
                    [bezier434Path addCurveToPoint: CGPointMake(27.49, 9.28) controlPoint1: CGPointMake(27.55, 8.98) controlPoint2: CGPointMake(27.51, 9.15)];
                    [bezier434Path addCurveToPoint: CGPointMake(27.23, 9.65) controlPoint1: CGPointMake(27.44, 9.42) controlPoint2: CGPointMake(27.34, 9.54)];
                    [bezier434Path addCurveToPoint: CGPointMake(26.66, 9.98) controlPoint1: CGPointMake(27.09, 9.79) controlPoint2: CGPointMake(26.89, 9.9)];
                    [bezier434Path addCurveToPoint: CGPointMake(25.85, 10.08) controlPoint1: CGPointMake(26.41, 10.04) controlPoint2: CGPointMake(26.14, 10.08)];
                    [bezier434Path addCurveToPoint: CGPointMake(24.94, 9.94) controlPoint1: CGPointMake(25.5, 10.08) controlPoint2: CGPointMake(25.21, 10.04)];
                    [bezier434Path addCurveToPoint: CGPointMake(24.33, 9.52) controlPoint1: CGPointMake(24.69, 9.83) controlPoint2: CGPointMake(24.47, 9.7)];
                    [bezier434Path addCurveToPoint: CGPointMake(24.2, 9.2) controlPoint1: CGPointMake(24.26, 9.42) controlPoint2: CGPointMake(24.21, 9.32)];
                    [bezier434Path addCurveToPoint: CGPointMake(24.15, 8.82) controlPoint1: CGPointMake(24.15, 9.09) controlPoint2: CGPointMake(24.15, 8.95)];
                    [bezier434Path addCurveToPoint: CGPointMake(24.2, 8.36) controlPoint1: CGPointMake(24.15, 8.65) controlPoint2: CGPointMake(24.15, 8.49)];
                    [bezier434Path addCurveToPoint: CGPointMake(24.36, 8) controlPoint1: CGPointMake(24.22, 8.22) controlPoint2: CGPointMake(24.3, 8.09)];
                    [bezier434Path addCurveToPoint: CGPointMake(24.92, 7.62) controlPoint1: CGPointMake(24.48, 7.83) controlPoint2: CGPointMake(24.69, 7.7)];
                    [bezier434Path addCurveToPoint: CGPointMake(25.82, 7.49) controlPoint1: CGPointMake(25.17, 7.53) controlPoint2: CGPointMake(25.49, 7.49)];
                    [bezier434Path addCurveToPoint: CGPointMake(26.44, 7.54) controlPoint1: CGPointMake(26.05, 7.49) controlPoint2: CGPointMake(26.26, 7.5)];
                    [bezier434Path addCurveToPoint: CGPointMake(26.95, 7.72) controlPoint1: CGPointMake(26.62, 7.58) controlPoint2: CGPointMake(26.79, 7.64)];
                    [bezier434Path addCurveToPoint: CGPointMake(27.32, 7.98) controlPoint1: CGPointMake(27.08, 7.79) controlPoint2: CGPointMake(27.2, 7.88)];
                    [bezier434Path addCurveToPoint: CGPointMake(27.55, 8.79) controlPoint1: CGPointMake(27.47, 8.17) controlPoint2: CGPointMake(27.55, 8.44)];
                    [bezier434Path closePath];
                    [bezier434Path moveToPoint: CGPointMake(26.62, 8.76)];
                    [bezier434Path addCurveToPoint: CGPointMake(26.57, 8.24) controlPoint1: CGPointMake(26.62, 8.55) controlPoint2: CGPointMake(26.61, 8.37)];
                    [bezier434Path addCurveToPoint: CGPointMake(26.32, 7.94) controlPoint1: CGPointMake(26.5, 8.11) controlPoint2: CGPointMake(26.43, 8.01)];
                    [bezier434Path addCurveToPoint: CGPointMake(25.83, 7.83) controlPoint1: CGPointMake(26.2, 7.86) controlPoint2: CGPointMake(26.05, 7.83)];
                    [bezier434Path addCurveToPoint: CGPointMake(25.22, 8.06) controlPoint1: CGPointMake(25.53, 7.83) controlPoint2: CGPointMake(25.33, 7.91)];
                    [bezier434Path addCurveToPoint: CGPointMake(25.07, 8.77) controlPoint1: CGPointMake(25.11, 8.21) controlPoint2: CGPointMake(25.07, 8.45)];
                    [bezier434Path addCurveToPoint: CGPointMake(25.12, 9.31) controlPoint1: CGPointMake(25.07, 8.98) controlPoint2: CGPointMake(25.07, 9.17)];
                    [bezier434Path addCurveToPoint: CGPointMake(25.36, 9.62) controlPoint1: CGPointMake(25.17, 9.45) controlPoint2: CGPointMake(25.25, 9.55)];
                    [bezier434Path addCurveToPoint: CGPointMake(25.83, 9.72) controlPoint1: CGPointMake(25.49, 9.69) controlPoint2: CGPointMake(25.63, 9.72)];
                    [bezier434Path addCurveToPoint: CGPointMake(26.33, 9.62) controlPoint1: CGPointMake(26.04, 9.72) controlPoint2: CGPointMake(26.2, 9.69)];
                    [bezier434Path addCurveToPoint: CGPointMake(26.57, 9.29) controlPoint1: CGPointMake(26.44, 9.54) controlPoint2: CGPointMake(26.51, 9.42)];
                    [bezier434Path addCurveToPoint: CGPointMake(26.62, 8.76) controlPoint1: CGPointMake(26.61, 9.17) controlPoint2: CGPointMake(26.62, 8.98)];
                    [bezier434Path closePath];
                    bezier434Path.miterLimit = 4;
                    
                    [fillColor6 setFill];
                    [bezier434Path fill];
                }
                
                
                //// Group 375
                {
                    //// Bezier 435 Drawing
                    UIBezierPath* bezier435Path = UIBezierPath.bezierPath;
                    [bezier435Path moveToPoint: CGPointMake(29.52, 10.6)];
                    [bezier435Path addLineToPoint: CGPointMake(29.57, 10.5)];
                    [bezier435Path addLineToPoint: CGPointMake(28.77, 9.04)];
                    [bezier435Path addCurveToPoint: CGPointMake(28.7, 8.86) controlPoint1: CGPointMake(28.73, 8.97) controlPoint2: CGPointMake(28.7, 8.9)];
                    [bezier435Path addCurveToPoint: CGPointMake(28.75, 8.76) controlPoint1: CGPointMake(28.7, 8.82) controlPoint2: CGPointMake(28.73, 8.79)];
                    [bezier435Path addCurveToPoint: CGPointMake(28.87, 8.68) controlPoint1: CGPointMake(28.77, 8.72) controlPoint2: CGPointMake(28.83, 8.69)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.02, 8.64) controlPoint1: CGPointMake(28.92, 8.66) controlPoint2: CGPointMake(28.97, 8.64)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.23, 8.71) controlPoint1: CGPointMake(29.12, 8.64) controlPoint2: CGPointMake(29.18, 8.66)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.35, 8.89) controlPoint1: CGPointMake(29.28, 8.76) controlPoint2: CGPointMake(29.32, 8.81)];
                    [bezier435Path addLineToPoint: CGPointMake(29.89, 10.04)];
                    [bezier435Path addLineToPoint: CGPointMake(30.41, 8.98)];
                    [bezier435Path addCurveToPoint: CGPointMake(30.52, 8.78) controlPoint1: CGPointMake(30.44, 8.89) controlPoint2: CGPointMake(30.48, 8.82)];
                    [bezier435Path addCurveToPoint: CGPointMake(30.61, 8.67) controlPoint1: CGPointMake(30.55, 8.72) controlPoint2: CGPointMake(30.58, 8.69)];
                    [bezier435Path addCurveToPoint: CGPointMake(30.77, 8.64) controlPoint1: CGPointMake(30.61, 8.67) controlPoint2: CGPointMake(30.71, 8.64)];
                    [bezier435Path addCurveToPoint: CGPointMake(30.92, 8.67) controlPoint1: CGPointMake(30.82, 8.64) controlPoint2: CGPointMake(30.88, 8.66)];
                    [bezier435Path addCurveToPoint: CGPointMake(31.01, 8.76) controlPoint1: CGPointMake(30.95, 8.69) controlPoint2: CGPointMake(31, 8.72)];
                    [bezier435Path addCurveToPoint: CGPointMake(31.05, 8.85) controlPoint1: CGPointMake(31.01, 8.76) controlPoint2: CGPointMake(31.05, 8.81)];
                    [bezier435Path addCurveToPoint: CGPointMake(31.02, 8.95) controlPoint1: CGPointMake(31.05, 8.85) controlPoint2: CGPointMake(31.03, 8.91)];
                    [bezier435Path addCurveToPoint: CGPointMake(30.96, 9.07) controlPoint1: CGPointMake(31.01, 8.98) controlPoint2: CGPointMake(31, 9.03)];
                    [bezier435Path addLineToPoint: CGPointMake(30.14, 10.66)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.92, 11) controlPoint1: CGPointMake(30.05, 10.8) controlPoint2: CGPointMake(29.99, 10.91)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.65, 11.18) controlPoint1: CGPointMake(29.86, 11.08) controlPoint2: CGPointMake(29.76, 11.14)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.2, 11.24) controlPoint1: CGPointMake(29.53, 11.23) controlPoint2: CGPointMake(29.39, 11.24)];
                    [bezier435Path addCurveToPoint: CGPointMake(28.77, 11.19) controlPoint1: CGPointMake(29.01, 11.24) controlPoint2: CGPointMake(28.86, 11.23)];
                    [bezier435Path addCurveToPoint: CGPointMake(28.64, 11.03) controlPoint1: CGPointMake(28.68, 11.17) controlPoint2: CGPointMake(28.64, 11.11)];
                    [bezier435Path addCurveToPoint: CGPointMake(28.71, 10.91) controlPoint1: CGPointMake(28.64, 10.98) controlPoint2: CGPointMake(28.66, 10.94)];
                    [bezier435Path addCurveToPoint: CGPointMake(28.91, 10.87) controlPoint1: CGPointMake(28.76, 10.88) controlPoint2: CGPointMake(28.82, 10.87)];
                    [bezier435Path addLineToPoint: CGPointMake(28.97, 10.88)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.12, 10.88) controlPoint1: CGPointMake(29.04, 10.88) controlPoint2: CGPointMake(29.08, 10.88)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.23, 10.88) controlPoint1: CGPointMake(29.19, 10.88) controlPoint2: CGPointMake(29.23, 10.88)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.39, 10.79) controlPoint1: CGPointMake(29.32, 10.85) controlPoint2: CGPointMake(29.36, 10.82)];
                    [bezier435Path addCurveToPoint: CGPointMake(29.52, 10.6) controlPoint1: CGPointMake(29.43, 10.74) controlPoint2: CGPointMake(29.47, 10.68)];
                    [bezier435Path closePath];
                    bezier435Path.miterLimit = 4;
                    
                    [fillColor6 setFill];
                    [bezier435Path fill];
                }
                
                
                //// Group 376
                {
                    //// Bezier 436 Drawing
                    UIBezierPath* bezier436Path = UIBezierPath.bezierPath;
                    [bezier436Path moveToPoint: CGPointMake(34.82, 9.45)];
                    [bezier436Path addLineToPoint: CGPointMake(33.05, 9.45)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.19, 9.67) controlPoint1: CGPointMake(33.05, 9.53) controlPoint2: CGPointMake(33.13, 9.61)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.51, 9.8) controlPoint1: CGPointMake(33.27, 9.73) controlPoint2: CGPointMake(33.37, 9.78)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.95, 9.85) controlPoint1: CGPointMake(33.66, 9.84) controlPoint2: CGPointMake(33.77, 9.85)];
                    [bezier436Path addCurveToPoint: CGPointMake(34.22, 9.84) controlPoint1: CGPointMake(34.06, 9.85) controlPoint2: CGPointMake(34.16, 9.84)];
                    [bezier436Path addCurveToPoint: CGPointMake(34.5, 9.79) controlPoint1: CGPointMake(34.34, 9.83) controlPoint2: CGPointMake(34.41, 9.81)];
                    [bezier436Path addCurveToPoint: CGPointMake(34.73, 9.73) controlPoint1: CGPointMake(34.6, 9.77) controlPoint2: CGPointMake(34.66, 9.74)];
                    [bezier436Path addCurveToPoint: CGPointMake(35, 9.62) controlPoint1: CGPointMake(34.8, 9.69) controlPoint2: CGPointMake(34.89, 9.66)];
                    [bezier436Path addCurveToPoint: CGPointMake(35.2, 9.59) controlPoint1: CGPointMake(35.05, 9.6) controlPoint2: CGPointMake(35.1, 9.59)];
                    [bezier436Path addCurveToPoint: CGPointMake(35.36, 9.61) controlPoint1: CGPointMake(35.29, 9.59) controlPoint2: CGPointMake(35.36, 9.61)];
                    [bezier436Path addCurveToPoint: CGPointMake(35.51, 9.71) controlPoint1: CGPointMake(35.47, 9.65) controlPoint2: CGPointMake(35.51, 9.67)];
                    [bezier436Path addCurveToPoint: CGPointMake(35.42, 9.82) controlPoint1: CGPointMake(35.51, 9.74) controlPoint2: CGPointMake(35.47, 9.78)];
                    [bezier436Path addCurveToPoint: CGPointMake(35.13, 9.94) controlPoint1: CGPointMake(35.35, 9.87) controlPoint2: CGPointMake(35.25, 9.91)];
                    [bezier436Path addCurveToPoint: CGPointMake(34.64, 10.04) controlPoint1: CGPointMake(35, 9.98) controlPoint2: CGPointMake(34.83, 10.01)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.97, 10.08) controlPoint1: CGPointMake(34.44, 10.07) controlPoint2: CGPointMake(34.21, 10.08)];
                    [bezier436Path addCurveToPoint: CGPointMake(32.63, 9.88) controlPoint1: CGPointMake(33.38, 10.08) controlPoint2: CGPointMake(32.94, 10.01)];
                    [bezier436Path addCurveToPoint: CGPointMake(32.14, 9.36) controlPoint1: CGPointMake(32.3, 9.76) controlPoint2: CGPointMake(32.14, 9.58)];
                    [bezier436Path addCurveToPoint: CGPointMake(32.27, 9.07) controlPoint1: CGPointMake(32.14, 9.25) controlPoint2: CGPointMake(32.19, 9.16)];
                    [bezier436Path addCurveToPoint: CGPointMake(32.61, 8.84) controlPoint1: CGPointMake(32.33, 8.98) controlPoint2: CGPointMake(32.44, 8.9)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.15, 8.69) controlPoint1: CGPointMake(32.75, 8.77) controlPoint2: CGPointMake(32.94, 8.72)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.9, 8.64) controlPoint1: CGPointMake(33.37, 8.65) controlPoint2: CGPointMake(33.65, 8.64)];
                    [bezier436Path addCurveToPoint: CGPointMake(34.79, 8.72) controlPoint1: CGPointMake(34.26, 8.64) controlPoint2: CGPointMake(34.56, 8.67)];
                    [bezier436Path addCurveToPoint: CGPointMake(35.37, 8.96) controlPoint1: CGPointMake(35.04, 8.78) controlPoint2: CGPointMake(35.24, 8.86)];
                    [bezier436Path addCurveToPoint: CGPointMake(35.55, 9.23) controlPoint1: CGPointMake(35.48, 9.04) controlPoint2: CGPointMake(35.55, 9.14)];
                    [bezier436Path addCurveToPoint: CGPointMake(35.35, 9.4) controlPoint1: CGPointMake(35.55, 9.33) controlPoint2: CGPointMake(35.47, 9.37)];
                    [bezier436Path addCurveToPoint: CGPointMake(34.82, 9.45) controlPoint1: CGPointMake(35.23, 9.44) controlPoint2: CGPointMake(35.05, 9.45)];
                    [bezier436Path closePath];
                    [bezier436Path moveToPoint: CGPointMake(33.05, 9.26)];
                    [bezier436Path addLineToPoint: CGPointMake(34.7, 9.26)];
                    [bezier436Path addCurveToPoint: CGPointMake(34.44, 8.98) controlPoint1: CGPointMake(34.67, 9.13) controlPoint2: CGPointMake(34.59, 9.04)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.89, 8.89) controlPoint1: CGPointMake(34.31, 8.92) controlPoint2: CGPointMake(34.11, 8.89)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.33, 8.98) controlPoint1: CGPointMake(33.67, 8.89) controlPoint2: CGPointMake(33.48, 8.92)];
                    [bezier436Path addCurveToPoint: CGPointMake(33.05, 9.26) controlPoint1: CGPointMake(33.16, 9.05) controlPoint2: CGPointMake(33.1, 9.13)];
                    [bezier436Path closePath];
                    bezier436Path.miterLimit = 4;
                    
                    [fillColor6 setFill];
                    [bezier436Path fill];
                }
                
                
                //// Group 377
                {
                    //// Bezier 437 Drawing
                    UIBezierPath* bezier437Path = UIBezierPath.bezierPath;
                    [bezier437Path moveToPoint: CGPointMake(38.12, 9.88)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.47, 10.03) controlPoint1: CGPointMake(37.89, 9.95) controlPoint2: CGPointMake(37.69, 10)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.8, 10.08) controlPoint1: CGPointMake(37.29, 10.06) controlPoint2: CGPointMake(37.05, 10.08)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.2, 10.03) controlPoint1: CGPointMake(36.59, 10.08) controlPoint2: CGPointMake(36.37, 10.06)];
                    [bezier437Path addCurveToPoint: CGPointMake(35.8, 9.88) controlPoint1: CGPointMake(36.02, 9.99) controlPoint2: CGPointMake(35.89, 9.94)];
                    [bezier437Path addCurveToPoint: CGPointMake(35.66, 9.68) controlPoint1: CGPointMake(35.7, 9.82) controlPoint2: CGPointMake(35.66, 9.75)];
                    [bezier437Path addCurveToPoint: CGPointMake(35.89, 9.43) controlPoint1: CGPointMake(35.66, 9.58) controlPoint2: CGPointMake(35.75, 9.5)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.53, 9.29) controlPoint1: CGPointMake(36.05, 9.36) controlPoint2: CGPointMake(36.26, 9.32)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.95, 9.26) controlPoint1: CGPointMake(36.59, 9.29) controlPoint2: CGPointMake(36.72, 9.28)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.53, 9.21) controlPoint1: CGPointMake(37.19, 9.24) controlPoint2: CGPointMake(37.36, 9.23)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.04, 9.16) controlPoint1: CGPointMake(37.69, 9.19) controlPoint2: CGPointMake(37.85, 9.18)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.91, 8.95) controlPoint1: CGPointMake(38.02, 9.07) controlPoint2: CGPointMake(37.98, 9)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.38, 8.89) controlPoint1: CGPointMake(37.8, 8.91) controlPoint2: CGPointMake(37.63, 8.89)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.87, 8.92) controlPoint1: CGPointMake(37.14, 8.89) controlPoint2: CGPointMake(36.97, 8.89)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.58, 9.03) controlPoint1: CGPointMake(36.74, 8.95) controlPoint2: CGPointMake(36.67, 8.99)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.45, 9.12) controlPoint1: CGPointMake(36.5, 9.09) controlPoint2: CGPointMake(36.45, 9.12)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.18, 9.16) controlPoint1: CGPointMake(36.45, 9.12) controlPoint2: CGPointMake(36.3, 9.16)];
                    [bezier437Path addCurveToPoint: CGPointMake(35.93, 9.12) controlPoint1: CGPointMake(36.07, 9.16) controlPoint2: CGPointMake(36.01, 9.15)];
                    [bezier437Path addCurveToPoint: CGPointMake(35.81, 9.02) controlPoint1: CGPointMake(35.85, 9.1) controlPoint2: CGPointMake(35.81, 9.07)];
                    [bezier437Path addCurveToPoint: CGPointMake(35.99, 8.84) controlPoint1: CGPointMake(35.81, 8.96) controlPoint2: CGPointMake(35.88, 8.91)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.5, 8.7) controlPoint1: CGPointMake(36.09, 8.79) controlPoint2: CGPointMake(36.27, 8.74)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.38, 8.64) controlPoint1: CGPointMake(36.73, 8.66) controlPoint2: CGPointMake(37.01, 8.64)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.3, 8.69) controlPoint1: CGPointMake(37.75, 8.64) controlPoint2: CGPointMake(38.08, 8.65)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.78, 8.87) controlPoint1: CGPointMake(38.51, 8.73) controlPoint2: CGPointMake(38.68, 8.79)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.93, 9.19) controlPoint1: CGPointMake(38.86, 8.95) controlPoint2: CGPointMake(38.93, 9.05)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.93, 9.4) controlPoint1: CGPointMake(38.93, 9.27) controlPoint2: CGPointMake(38.93, 9.34)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.93, 9.59) controlPoint1: CGPointMake(38.93, 9.45) controlPoint2: CGPointMake(38.93, 9.52)];
                    [bezier437Path addCurveToPoint: CGPointMake(39, 9.8) controlPoint1: CGPointMake(38.93, 9.66) controlPoint2: CGPointMake(38.93, 9.73)];
                    [bezier437Path addCurveToPoint: CGPointMake(39.07, 9.92) controlPoint1: CGPointMake(39.05, 9.87) controlPoint2: CGPointMake(39.07, 9.92)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.95, 10.04) controlPoint1: CGPointMake(39.07, 9.98) controlPoint2: CGPointMake(39.04, 10.01)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.66, 10.08) controlPoint1: CGPointMake(38.85, 10.07) controlPoint2: CGPointMake(38.77, 10.08)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.38, 10.03) controlPoint1: CGPointMake(38.57, 10.08) controlPoint2: CGPointMake(38.48, 10.07)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.12, 9.88) controlPoint1: CGPointMake(38.31, 10) controlPoint2: CGPointMake(38.21, 9.95)];
                    [bezier437Path closePath];
                    [bezier437Path moveToPoint: CGPointMake(38.06, 9.37)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.48, 9.43) controlPoint1: CGPointMake(37.93, 9.39) controlPoint2: CGPointMake(37.73, 9.41)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.97, 9.48) controlPoint1: CGPointMake(37.24, 9.45) controlPoint2: CGPointMake(37.06, 9.47)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.69, 9.53) controlPoint1: CGPointMake(36.87, 9.49) controlPoint2: CGPointMake(36.78, 9.5)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.55, 9.66) controlPoint1: CGPointMake(36.61, 9.56) controlPoint2: CGPointMake(36.55, 9.61)];
                    [bezier437Path addCurveToPoint: CGPointMake(36.73, 9.79) controlPoint1: CGPointMake(36.55, 9.71) controlPoint2: CGPointMake(36.61, 9.75)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.13, 9.85) controlPoint1: CGPointMake(36.82, 9.83) controlPoint2: CGPointMake(36.96, 9.85)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.61, 9.81) controlPoint1: CGPointMake(37.3, 9.85) controlPoint2: CGPointMake(37.45, 9.84)];
                    [bezier437Path addCurveToPoint: CGPointMake(37.95, 9.68) controlPoint1: CGPointMake(37.75, 9.77) controlPoint2: CGPointMake(37.87, 9.74)];
                    [bezier437Path addCurveToPoint: CGPointMake(38.07, 9.42) controlPoint1: CGPointMake(38.03, 9.63) controlPoint2: CGPointMake(38.07, 9.54)];
                    [bezier437Path addLineToPoint: CGPointMake(38.06, 9.37)];
                    [bezier437Path closePath];
                    bezier437Path.miterLimit = 4;
                    
                    [fillColor6 setFill];
                    [bezier437Path fill];
                }
                
                
                //// Group 378
                {
                    //// Bezier 438 Drawing
                    UIBezierPath* bezier438Path = UIBezierPath.bezierPath;
                    [bezier438Path moveToPoint: CGPointMake(41.04, 9.57)];
                    [bezier438Path addLineToPoint: CGPointMake(41.04, 9.87)];
                    [bezier438Path addCurveToPoint: CGPointMake(40.93, 10.03) controlPoint1: CGPointMake(41.04, 9.94) controlPoint2: CGPointMake(41.01, 9.99)];
                    [bezier438Path addCurveToPoint: CGPointMake(40.63, 10.08) controlPoint1: CGPointMake(40.84, 10.06) controlPoint2: CGPointMake(40.74, 10.08)];
                    [bezier438Path addCurveToPoint: CGPointMake(40.33, 10.03) controlPoint1: CGPointMake(40.51, 10.08) controlPoint2: CGPointMake(40.4, 10.06)];
                    [bezier438Path addCurveToPoint: CGPointMake(40.2, 9.87) controlPoint1: CGPointMake(40.26, 9.99) controlPoint2: CGPointMake(40.2, 9.94)];
                    [bezier438Path addLineToPoint: CGPointMake(40.2, 8.88)];
                    [bezier438Path addCurveToPoint: CGPointMake(40.61, 8.64) controlPoint1: CGPointMake(40.2, 8.72) controlPoint2: CGPointMake(40.35, 8.64)];
                    [bezier438Path addCurveToPoint: CGPointMake(40.91, 8.7) controlPoint1: CGPointMake(40.77, 8.64) controlPoint2: CGPointMake(40.84, 8.66)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.02, 8.86) controlPoint1: CGPointMake(40.98, 8.74) controlPoint2: CGPointMake(41.01, 8.79)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.33, 8.7) controlPoint1: CGPointMake(41.13, 8.79) controlPoint2: CGPointMake(41.22, 8.74)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.74, 8.64) controlPoint1: CGPointMake(41.44, 8.66) controlPoint2: CGPointMake(41.56, 8.64)];
                    [bezier438Path addCurveToPoint: CGPointMake(42.23, 8.7) controlPoint1: CGPointMake(41.92, 8.64) controlPoint2: CGPointMake(42.08, 8.66)];
                    [bezier438Path addCurveToPoint: CGPointMake(42.5, 8.85) controlPoint1: CGPointMake(42.42, 8.74) controlPoint2: CGPointMake(42.5, 8.79)];
                    [bezier438Path addCurveToPoint: CGPointMake(42.38, 8.96) controlPoint1: CGPointMake(42.5, 8.89) controlPoint2: CGPointMake(42.48, 8.92)];
                    [bezier438Path addCurveToPoint: CGPointMake(42.16, 9) controlPoint1: CGPointMake(42.31, 8.98) controlPoint2: CGPointMake(42.23, 9)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.96, 8.98) controlPoint1: CGPointMake(42.16, 9) controlPoint2: CGPointMake(42.06, 8.99)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.63, 8.95) controlPoint1: CGPointMake(41.83, 8.97) controlPoint2: CGPointMake(41.73, 8.95)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.34, 8.99) controlPoint1: CGPointMake(41.51, 8.95) controlPoint2: CGPointMake(41.41, 8.96)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.16, 9.11) controlPoint1: CGPointMake(41.27, 9.02) controlPoint2: CGPointMake(41.2, 9.05)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.07, 9.3) controlPoint1: CGPointMake(41.13, 9.16) controlPoint2: CGPointMake(41.09, 9.23)];
                    [bezier438Path addCurveToPoint: CGPointMake(41.04, 9.57) controlPoint1: CGPointMake(41.04, 9.37) controlPoint2: CGPointMake(41.04, 9.46)];
                    [bezier438Path closePath];
                    bezier438Path.miterLimit = 4;
                    
                    [fillColor6 setFill];
                    [bezier438Path fill];
                }
            }
        }
        
        
        //// Group 379
        {
            //// Bezier 439 Drawing
            UIBezierPath* bezier439Path = UIBezierPath.bezierPath;
            [bezier439Path moveToPoint: CGPointMake(97.62, 27.42)];
            [bezier439Path addCurveToPoint: CGPointMake(77.79, 30.08) controlPoint1: CGPointMake(97.62, 27.42) controlPoint2: CGPointMake(88.78, 31.1)];
            [bezier439Path addCurveToPoint: CGPointMake(62.79, 22.83) controlPoint1: CGPointMake(68.3, 29.19) controlPoint2: CGPointMake(63.82, 24.18)];
            [bezier439Path addLineToPoint: CGPointMake(62.79, 22.51)];
            [bezier439Path addCurveToPoint: CGPointMake(62.65, 22.67) controlPoint1: CGPointMake(62.79, 22.51) controlPoint2: CGPointMake(62.75, 22.56)];
            [bezier439Path addCurveToPoint: CGPointMake(62.56, 22.51) controlPoint1: CGPointMake(62.59, 22.56) controlPoint2: CGPointMake(62.56, 22.51)];
            [bezier439Path addLineToPoint: CGPointMake(62.56, 22.83)];
            [bezier439Path addCurveToPoint: CGPointMake(47.53, 30.08) controlPoint1: CGPointMake(61.51, 24.17) controlPoint2: CGPointMake(57.04, 29.19)];
            [bezier439Path addCurveToPoint: CGPointMake(27.73, 27.42) controlPoint1: CGPointMake(36.56, 31.1) controlPoint2: CGPointMake(27.73, 27.42)];
            [bezier439Path addLineToPoint: CGPointMake(25.28, 34.79)];
            [bezier439Path addCurveToPoint: CGPointMake(29.25, 41.54) controlPoint1: CGPointMake(25.28, 34.79) controlPoint2: CGPointMake(28.63, 35.61)];
            [bezier439Path addCurveToPoint: CGPointMake(33.83, 70.21) controlPoint1: CGPointMake(29.84, 47.49) controlPoint2: CGPointMake(28.34, 60.99)];
            [bezier439Path addCurveToPoint: CGPointMake(55.47, 89.03) controlPoint1: CGPointMake(39.31, 79.42) controlPoint2: CGPointMake(44.2, 84.33)];
            [bezier439Path addCurveToPoint: CGPointMake(62.56, 91.99) controlPoint1: CGPointMake(59.45, 90.7) controlPoint2: CGPointMake(61.52, 91.56)];
            [bezier439Path addLineToPoint: CGPointMake(62.59, 92.04)];
            [bezier439Path addCurveToPoint: CGPointMake(62.66, 92.04) controlPoint1: CGPointMake(62.59, 92.04) controlPoint2: CGPointMake(62.65, 92.08)];
            [bezier439Path addCurveToPoint: CGPointMake(62.59, 92) controlPoint1: CGPointMake(62.66, 92.04) controlPoint2: CGPointMake(62.54, 91.99)];
            [bezier439Path addLineToPoint: CGPointMake(62.79, 91.99)];
            [bezier439Path addCurveToPoint: CGPointMake(69.86, 89.03) controlPoint1: CGPointMake(63.82, 91.56) controlPoint2: CGPointMake(65.89, 90.7)];
            [bezier439Path addCurveToPoint: CGPointMake(91.52, 70.21) controlPoint1: CGPointMake(81.15, 84.33) controlPoint2: CGPointMake(86.03, 79.42)];
            [bezier439Path addCurveToPoint: CGPointMake(96.09, 41.54) controlPoint1: CGPointMake(97, 60.99) controlPoint2: CGPointMake(95.48, 47.49)];
            [bezier439Path addCurveToPoint: CGPointMake(100.06, 34.79) controlPoint1: CGPointMake(96.69, 35.61) controlPoint2: CGPointMake(100.06, 34.79)];
            [bezier439Path addLineToPoint: CGPointMake(97.62, 27.42)];
            [bezier439Path closePath];
            bezier439Path.miterLimit = 4;
            
            [fillColor31 setFill];
            [bezier439Path fill];
        }
        
        
        //// Group 380
        {
            //// Bezier 440 Drawing
            UIBezierPath* bezier440Path = UIBezierPath.bezierPath;
            [bezier440Path moveToPoint: CGPointMake(86.21, 53.74)];
            [bezier440Path addLineToPoint: CGPointMake(68.21, 53.74)];
            [bezier440Path addLineToPoint: CGPointMake(68.21, 42.24)];
            [bezier440Path addLineToPoint: CGPointMake(57.13, 42.24)];
            [bezier440Path addLineToPoint: CGPointMake(57.13, 53.74)];
            [bezier440Path addLineToPoint: CGPointMake(39.12, 53.74)];
            [bezier440Path addLineToPoint: CGPointMake(39.12, 60.83)];
            [bezier440Path addLineToPoint: CGPointMake(57.13, 60.83)];
            [bezier440Path addLineToPoint: CGPointMake(57.13, 72.33)];
            [bezier440Path addLineToPoint: CGPointMake(68.21, 72.33)];
            [bezier440Path addLineToPoint: CGPointMake(68.21, 60.83)];
            [bezier440Path addLineToPoint: CGPointMake(86.21, 60.83)];
            [bezier440Path addLineToPoint: CGPointMake(86.21, 53.74)];
            [bezier440Path closePath];
            bezier440Path.miterLimit = 4;
            
            [fillColor6 setFill];
            [bezier440Path fill];
        }
    }
}

@end
