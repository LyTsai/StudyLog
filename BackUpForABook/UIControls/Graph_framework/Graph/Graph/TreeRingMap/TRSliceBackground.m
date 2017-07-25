//
//  TRSliceBackground.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/20/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRSliceBackground.h"

@interface TRSliceBackground (PrivateMethods)

// functions
-(void)addPath:(CGContextRef)ctx
        layout:(Slice)size
        center:(CGPoint)origin;
;

// drawing color filled slice
-(void)drawColorFilled:(CGContextRef)ctx
                layout:(Slice)size
                center:(CGPoint)origin;

// draw gradient color
-(void)drawGradientFilled:(CGContextRef)ctx
                   layout:(Slice)size
                   center:(CGPoint)origin;

// draw as filled highlight
-(void)drawHighlightFilled:(CGContextRef)ctx
                    layout:(Slice)size
                    center:(CGPoint)origin;

// draw as gradient highlight
-(void)drawHighlightGradient:(CGContextRef)ctx
                      layout:(Slice)size
                      center:(CGPoint)origin;
@end

@implementation TRSliceBackground

// methods
-(id)init
{
    self = [super init];
    
    _highlight = FALSE;
    _highlightStyle = HighLightStyle_Fill;
    _style = BackgroudStyle_Color_Fill;
    _bkgColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.4]; //[UIColor lightGrayColor];
    _edgeColor = [UIColor darkTextColor];
    
    return self;
}

-(void)paint:(CGContextRef)ctx
      layout:(Slice)size
      center:(CGPoint)origin
{
    // highlight state?
    if (_highlight == TRUE)
    {
        if (_highlightStyle == HighLightStyle_Fill)
        {
            [self drawHighlightFilled:ctx layout:size center:origin];
        }else if (_highlightStyle == HighLightStyle_Gradient)
        {
            [self drawHighlightGradient:ctx layout:size center:origin];
        }
        return ;
    }
    
    // normal state
    if (_style == BackgroudStyle_Color_Fill)
    {
        [self drawColorFilled:ctx layout:size center:origin];
    }else if (_style == BackgroudStyle_Color_Gradient)
    {
        [self drawGradientFilled:ctx layout:size center:origin];
    }
}

// drawing methods
-(void)addPath:(CGContextRef)ctx
        layout:(Slice)size
        center:(CGPoint)origin;

{
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    
    // get path
    CGPoint minRadiusStart = CGPointMake(origin.x + size.bottom * cosf(DEGREES_TO_RADIANS(size.right)), origin.y - size.bottom * sinf(DEGREES_TO_RADIANS(size.right)));
    CGPoint maxRadiusEnd = CGPointMake(origin.x + size.top * cosf(DEGREES_TO_RADIANS(size.left)), origin.y - size.top * sinf(DEGREES_TO_RADIANS(size.left)));
    
    [aPath moveToPoint:minRadiusStart];
    [aPath addArcWithCenter:origin radius:size.bottom startAngle:-DEGREES_TO_RADIANS(size.right) endAngle:-DEGREES_TO_RADIANS(size.left) clockwise:FALSE];
    [aPath addLineToPoint:maxRadiusEnd];
    [aPath addArcWithCenter:origin radius:size.top startAngle:-DEGREES_TO_RADIANS(size.left) endAngle:-DEGREES_TO_RADIANS(size.right) clockwise:TRUE];
    
    [aPath closePath];
    
    CGContextAddPath(ctx, aPath.CGPath);
    
}

-(void)drawColorFilled:(CGContextRef)ctx
                layout:(Slice)size
                center:(CGPoint)origin
{
    CGContextSaveGState(ctx);
    
    CGContextSetFillColorWithColor(ctx, _bkgColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, _edgeColor.CGColor);
    CGContextSetLineWidth(ctx, .5);
    
    CGContextBeginPath(ctx);
    
    [self addPath:ctx layout:size center:origin];
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}

// test draw gradient color
-(void)drawGradientFilled:(CGContextRef)ctx
                   layout:(Slice)size
                   center:(CGPoint)origin
{
    // gradient color
    size_t num_locations = 3;
    CGFloat locations[] = {.0, .5, 1.0};
    
    // gradient color
    CGFloat gradientColors[12] = {.0, .0, 1.0, .7, 1.0, 1.0, 1.0, .8, .0, .0, 1.0, .7};
    
    // edge
    CGColorRef colorref = [_edgeColor CGColor];
    int numComponents = CGColorGetNumberOfComponents(colorref);
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(colorref);
        CGFloat red     = components[0];
        CGFloat green = components[1];
        CGFloat blue   = components[2];
        CGFloat alpha = components[3];
        
        gradientColors[0] = red;
        gradientColors[1] = green;
        gradientColors[2] = blue;
        gradientColors[3] = alpha;
        
        gradientColors[8] = red;
        gradientColors[9] = green;
        gradientColors[10] = blue;
        gradientColors[11] = alpha;
    }
    // middle
    colorref = [_bkgColor CGColor];
    numComponents = CGColorGetNumberOfComponents(colorref);
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(colorref);
        CGFloat red     = components[0];
        CGFloat green = components[1];
        CGFloat blue   = components[2];
        CGFloat alpha = components[3];
        
        gradientColors[4] = red;
        gradientColors[5] = green;
        gradientColors[6] = blue;
        gradientColors[7] = alpha;
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, gradientColors, locations, num_locations);
    
    CGContextSaveGState(ctx);
    
    CGContextBeginPath(ctx);
    [self addPath:ctx layout:size center:origin];
    
    CGContextClip(ctx);
    
    CGFloat startRadius = size.bottom;
    CGFloat endRadius = size.top;
    
    CGContextDrawRadialGradient(ctx, gradient, origin, startRadius, origin, endRadius, kCGGradientDrawsBeforeStartLocation);
    
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}

// draw as highlight
-(void)drawHighlightFilled:(CGContextRef)ctx
                    layout:(Slice)size
                    center:(CGPoint)origin
{
    CGContextSaveGState(ctx);
    
    CGContextSetFillColorWithColor(ctx, _bkgColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, _edgeColor.CGColor);
    CGContextSetLineWidth(ctx, .5);
    
    CGContextBeginPath(ctx);
    
    [self addPath:ctx layout:size center:origin];
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}

// draw as gradient highlight
-(void)drawHighlightGradient:(CGContextRef)ctx
                      layout:(Slice)size
                      center:(CGPoint)origin
{
    // gradient color
    size_t num_locations = 3;
    CGFloat locations[] = {.0, .5, 1.0};
    
    // gradient color
    CGFloat gradientColors[12] = {.0, .0, 1.0, .7, 1.0, 1.0, 1.0, .8, .0, .0, 1.0, .7};
    
    // edge
    CGColorRef colorref = [_edgeColor CGColor];
    int numComponents = CGColorGetNumberOfComponents(colorref);
    if (numComponents >= 3) {
        const CGFloat *components = CGColorGetComponents(colorref);
        CGFloat red     = components[0];
        CGFloat green = components[1];
        CGFloat blue   = components[2];
        
        gradientColors[0] = red;
        gradientColors[1] = green;
        gradientColors[2] = blue;
        gradientColors[3] = .6;
        
        gradientColors[8] = red;
        gradientColors[9] = green;
        gradientColors[10] = blue;
        gradientColors[11] = .6;
    }
    // middle
    colorref = [_bkgColor CGColor];
    numComponents = CGColorGetNumberOfComponents(colorref);
    if (numComponents >= 3) {
        const CGFloat *components = CGColorGetComponents(colorref);
        CGFloat red     = components[0];
        CGFloat green = components[1];
        CGFloat blue   = components[2];
        
        gradientColors[4] = red;
        gradientColors[5] = green;
        gradientColors[6] = blue;
        gradientColors[7] = .2;
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, gradientColors, locations, num_locations);
    
    CGContextSaveGState(ctx);
    
    CGContextBeginPath(ctx);
    [self addPath:ctx layout:size center:origin];
    
    CGContextClip(ctx);
    
    CGFloat startRadius = size.bottom;
    CGFloat endRadius = size.top;
    
    CGContextDrawRadialGradient(ctx, gradient, origin, startRadius, origin, endRadius, kCGGradientDrawsBeforeStartLocation);
    
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}

@end
