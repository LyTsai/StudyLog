//
//  DSSlider.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/29/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "DSSlider.h"

@interface DSSlider (PrivateMethods)
// paint slider bar
-(void)paintBar:(CGContextRef)ctx;
// paint bullet arrow
-(void)paintArrows:(CGContextRef)ctx;
// test functions
-(void)paintBarTest:(CGContextRef)ctx;
@end

@implementation DSSlider

-(id)init
{
    self = [super init];
    
    _length = 30;
    _height = 8;
    _space = 8;
    
    _faceColor = [UIColor colorWithRed:0.0 green:.45 blue:.94 alpha:.8];
    
    return self;
}

// paint the slider
-(void)paint:(CGContextRef)ctx
{
    [self paintBar:ctx];
    [self paintArrows:ctx];
}

// paint slider bar
-(void)paintBar:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGRect slider = CGRectMake(-_length * .5, -_height * .5, _length, _height);
    
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:slider cornerRadius:_height / 2.0];
    CGContextAddPath(ctx, aPath.CGPath);
    
    // (1) fill the slider area
    CGContextSetFillColorWithColor(ctx, _faceColor.CGColor);
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextFillPath(ctx);
    
    // (2) add a highlight over the bar
    CGRect highlight = CGRectMake(-_length * .5 + _height * .5, 0.0, _length - _height, _height * .5);
    UIBezierPath *aHighlightPath = [UIBezierPath bezierPathWithRoundedRect:highlight cornerRadius:highlight.size.height * 1.0 / 2.0];
    CGContextAddPath(ctx, aHighlightPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:1.0 alpha:.4].CGColor);
    CGContextFillPath(ctx);
    
    // (3) inner shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 2.0), 3.0, [UIColor grayColor].CGColor);
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextStrokePath(ctx);
    
    // (4) outline the slider
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor darkGrayColor].CGColor);
    CGContextSetLineWidth(ctx, .5);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

// paint bullet arrow
-(void)paintArrows:(CGContextRef)ctx
{
    // paint the left and right bullet arrow
    int arrowSize = _height * .5;
    
    CGPoint leftArrowPosition = CGPointMake(0 - _length * .5 - _space, .0);
    CGPoint rightArrowPosition = CGPointMake(0 + _length * .5 + _space, .0);
    
    // left arrow
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(leftArrowPosition.x + arrowSize, leftArrowPosition.y - arrowSize)];
    [arrowPath addLineToPoint:leftArrowPosition];
    [arrowPath addLineToPoint:CGPointMake(leftArrowPosition.x + arrowSize, leftArrowPosition.y + arrowSize)];
    CGContextAddPath(ctx, arrowPath.CGPath);
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 2.0), 3.0, [UIColor grayColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, _faceColor.CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokePath(ctx);
    
    // right arrow
    [arrowPath removeAllPoints];
    
    [arrowPath moveToPoint:CGPointMake(rightArrowPosition.x - arrowSize, rightArrowPosition.y - arrowSize)];
    [arrowPath addLineToPoint:rightArrowPosition];
    [arrowPath addLineToPoint:CGPointMake(rightArrowPosition.x - arrowSize, rightArrowPosition.y + arrowSize)];
    CGContextAddPath(ctx, arrowPath.CGPath);
    
    CGContextStrokePath(ctx);
}

// test functions
-(void)paintBarTest:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGRect slider = CGRectMake(-_length * .5, -_height * .5, _length, _height);
    
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:slider cornerRadius:_height / 2.0];
    CGContextAddPath(ctx, aPath.CGPath);
    
    // (1) fill the slider area
    CGContextSetFillColorWithColor(ctx, _faceColor.CGColor);
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextFillPath(ctx);
    
    // (2) add a highlight over the bar
    CGRect highlight = CGRectMake(-_length * .5 + _height * .5, 0.0, _length - _height, _height * .5);
    UIBezierPath *aHighlightPath = [UIBezierPath bezierPathWithRoundedRect:highlight cornerRadius:highlight.size.height * 1.0 / 2.0];
    CGContextAddPath(ctx, aHighlightPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:1.0 alpha:.4].CGColor);
    CGContextFillPath(ctx);
    
    // (3) inner shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 2.0), 3.0, [UIColor grayColor].CGColor);
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextStrokePath(ctx);
    
    // (4) outline the slider
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor darkGrayColor].CGColor);
    CGContextSetLineWidth(ctx, .5);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

@end
