//
//  DSArrow.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/28/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "DSArrow.h"

@interface DSArrow (PrivateMethods)
// add arrow path
-(void)addArrowPath:(CGContextRef)ctx;
@end

@implementation DSArrow

// methods
-(id)init
{
    self = [super init];
    
    _d = 2.0;
    _e = 4.0;
    _l = 6.0;
    _h = 6.0;
    
    _showArrow = TRUE;
    _shadow = FALSE;
    _faceColor = [UIColor colorWithRed:0.0 green:.3 blue:.9 alpha:.8];
    
    return self;
}

-(int)width
{
    return 1.5 * (_l + _h);
}

-(int)height
{
    return 4 * MAX(_d, _e);
}

// add path onto given context
-(void)addArrowPath:(CGContextRef)ctx
{
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    
    [aPath moveToPoint:CGPointMake(0.0, -_d)];
    [aPath addLineToPoint:CGPointMake(_l, -_d)];
    [aPath addLineToPoint:CGPointMake(_l, -_d - _e)];
    [aPath addLineToPoint:CGPointMake(_l + _h, .0)];
    [aPath addLineToPoint:CGPointMake(_l, _d + _e)];
    [aPath addLineToPoint:CGPointMake(_l, _d)];
    [aPath addLineToPoint:CGPointMake(.0, _d)];
    
    [aPath closePath];
    
    CGContextAddPath(ctx, aPath.CGPath);
    
    return;
}

// paint the arrow
-(void)paint:(CGContextRef)ctx
{
    if (_showArrow != TRUE)
    {
        return;
    }
    
    [self addArrowPath:ctx];
    
    CGContextSaveGState(ctx);
    
    if (_shadow == TRUE)
    {
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 2.0), 3.0, [UIColor grayColor].CGColor);
    }
    
    // fill first
    CGContextSetFillColorWithColor(ctx, _faceColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    
    CGContextRestoreGState(ctx);
}

@end
