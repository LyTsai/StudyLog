//
//  ASymbol_LifeStyle_Exercise.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/24/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_LifeStyle_Exercise.h"

@implementation ASymbol_LifeStyle_Exercise

@synthesize fillColor1;

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(100, 100);
    
    fillColor1 = [UIColor colorWithRed: 0.349 green: 0.553 blue: 0.243 alpha: 1];
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)context
{
    // (3) - (4)
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    // begin drawing
    //// Group 3
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = UIBezierPath.bezierPath;
        [bezierPath moveToPoint: CGPointMake(24.67, 0)];
        [bezierPath addLineToPoint: CGPointMake(21.83, 0)];
        [bezierPath addCurveToPoint: CGPointMake(19, 4.67) controlPoint1: CGPointMake(20.17, 0) controlPoint2: CGPointMake(19, 2.17)];
        [bezierPath addLineToPoint: CGPointMake(19, 95.33)];
        [bezierPath addCurveToPoint: CGPointMake(21.83, 100) controlPoint1: CGPointMake(19, 98) controlPoint2: CGPointMake(20.33, 100)];
        [bezierPath addLineToPoint: CGPointMake(24.67, 100)];
        [bezierPath addCurveToPoint: CGPointMake(27.5, 95.33) controlPoint1: CGPointMake(26.33, 100) controlPoint2: CGPointMake(27.5, 97.83)];
        [bezierPath addLineToPoint: CGPointMake(27.5, 4.83)];
        [bezierPath addCurveToPoint: CGPointMake(24.67, 0) controlPoint1: CGPointMake(27.5, 2.17) controlPoint2: CGPointMake(26.33, 0)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(14.5, 10.67)];
        [bezierPath addLineToPoint: CGPointMake(13, 10.67)];
        [bezierPath addCurveToPoint: CGPointMake(10.17, 15.33) controlPoint1: CGPointMake(11.33, 10.67) controlPoint2: CGPointMake(10.17, 12.83)];
        [bezierPath addLineToPoint: CGPointMake(10.17, 84.67)];
        [bezierPath addCurveToPoint: CGPointMake(13, 89.33) controlPoint1: CGPointMake(10.17, 87.33) controlPoint2: CGPointMake(11.5, 89.33)];
        [bezierPath addLineToPoint: CGPointMake(14.5, 89.33)];
        [bezierPath addCurveToPoint: CGPointMake(17.33, 84.67) controlPoint1: CGPointMake(16.17, 89.33) controlPoint2: CGPointMake(17.33, 87.17)];
        [bezierPath addLineToPoint: CGPointMake(17.33, 15.33)];
        [bezierPath addCurveToPoint: CGPointMake(14.5, 10.67) controlPoint1: CGPointMake(17.33, 12.67) controlPoint2: CGPointMake(16.17, 10.67)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(5.83, 18.83)];
        [bezierPath addCurveToPoint: CGPointMake(3, 23.5) controlPoint1: CGPointMake(4.17, 18.83) controlPoint2: CGPointMake(3, 21)];
        [bezierPath addLineToPoint: CGPointMake(3, 76.5)];
        [bezierPath addCurveToPoint: CGPointMake(5.83, 81.17) controlPoint1: CGPointMake(3, 79.17) controlPoint2: CGPointMake(4.33, 81.17)];
        [bezierPath addCurveToPoint: CGPointMake(8.67, 76.5) controlPoint1: CGPointMake(7.5, 81.17) controlPoint2: CGPointMake(8.67, 79)];
        [bezierPath addLineToPoint: CGPointMake(8.67, 23.5)];
        [bezierPath addCurveToPoint: CGPointMake(5.83, 18.83) controlPoint1: CGPointMake(8.67, 21) controlPoint2: CGPointMake(7.5, 18.83)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(78.33, 0)];
        [bezierPath addLineToPoint: CGPointMake(75.5, 0)];
        [bezierPath addCurveToPoint: CGPointMake(72.67, 4.67) controlPoint1: CGPointMake(73.83, 0) controlPoint2: CGPointMake(72.67, 2.17)];
        [bezierPath addLineToPoint: CGPointMake(72.67, 95.33)];
        [bezierPath addCurveToPoint: CGPointMake(75.5, 100) controlPoint1: CGPointMake(72.67, 98) controlPoint2: CGPointMake(74, 100)];
        [bezierPath addLineToPoint: CGPointMake(78.33, 100)];
        [bezierPath addCurveToPoint: CGPointMake(81.17, 95.33) controlPoint1: CGPointMake(80, 100) controlPoint2: CGPointMake(81.17, 97.83)];
        [bezierPath addLineToPoint: CGPointMake(81.17, 4.83)];
        [bezierPath addCurveToPoint: CGPointMake(78.33, 0) controlPoint1: CGPointMake(81.17, 2.17) controlPoint2: CGPointMake(79.83, 0)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(87, 10.67)];
        [bezierPath addLineToPoint: CGPointMake(85.5, 10.67)];
        [bezierPath addCurveToPoint: CGPointMake(82.67, 15.33) controlPoint1: CGPointMake(83.83, 10.67) controlPoint2: CGPointMake(82.67, 12.83)];
        [bezierPath addLineToPoint: CGPointMake(82.67, 84.67)];
        [bezierPath addCurveToPoint: CGPointMake(85.5, 89.33) controlPoint1: CGPointMake(82.67, 87.33) controlPoint2: CGPointMake(84, 89.33)];
        [bezierPath addLineToPoint: CGPointMake(87, 89.33)];
        [bezierPath addCurveToPoint: CGPointMake(89.83, 84.67) controlPoint1: CGPointMake(88.67, 89.33) controlPoint2: CGPointMake(89.83, 87.17)];
        [bezierPath addLineToPoint: CGPointMake(89.83, 15.33)];
        [bezierPath addCurveToPoint: CGPointMake(87, 10.67) controlPoint1: CGPointMake(89.83, 12.67) controlPoint2: CGPointMake(88.5, 10.67)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(94.17, 18.83)];
        [bezierPath addCurveToPoint: CGPointMake(91.33, 23.5) controlPoint1: CGPointMake(92.5, 18.83) controlPoint2: CGPointMake(91.33, 21)];
        [bezierPath addLineToPoint: CGPointMake(91.33, 76.5)];
        [bezierPath addCurveToPoint: CGPointMake(94.17, 81.17) controlPoint1: CGPointMake(91.33, 79.17) controlPoint2: CGPointMake(92.67, 81.17)];
        [bezierPath addCurveToPoint: CGPointMake(97, 76.5) controlPoint1: CGPointMake(95.67, 81.17) controlPoint2: CGPointMake(97, 79)];
        [bezierPath addLineToPoint: CGPointMake(97, 23.5)];
        [bezierPath addCurveToPoint: CGPointMake(94.17, 18.83) controlPoint1: CGPointMake(97.17, 21) controlPoint2: CGPointMake(95.83, 18.83)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(29, 57.67)];
        [bezierPath addLineToPoint: CGPointMake(71, 57.67)];
        [bezierPath addLineToPoint: CGPointMake(71, 42.33)];
        [bezierPath addLineToPoint: CGPointMake(29, 42.33)];
        [bezierPath addLineToPoint: CGPointMake(29, 57.67)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(0, 57.67)];
        [bezierPath addLineToPoint: CGPointMake(2.17, 57.67)];
        [bezierPath addLineToPoint: CGPointMake(2.17, 42.33)];
        [bezierPath addLineToPoint: CGPointMake(0, 42.33)];
        [bezierPath addLineToPoint: CGPointMake(0, 57.67)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(97.83, 42.33)];
        [bezierPath addLineToPoint: CGPointMake(97.83, 57.67)];
        [bezierPath addLineToPoint: CGPointMake(100, 57.67)];
        [bezierPath addLineToPoint: CGPointMake(100, 42.33)];
        [bezierPath addLineToPoint: CGPointMake(97.83, 42.33)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        bezierPath.usesEvenOddFillRule = YES;
        
        [fillColor1 setFill];
        [bezierPath fill];
    }

    // end of drawing
    
    //// Cleanup
    // (3) - (4)
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
