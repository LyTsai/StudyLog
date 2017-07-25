//
//  DSCircle.m
//  ATreeRingMap
//
//  Created by hui wang on 11/29/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "DSCircle.h"

@implementation DSCircle
{
    @private
    
    // circel edge
    float _width;
}

-(id)init
{
    self = [super init];
    
    _size = 24;
    _show = TRUE;
    _width = 5.4;
    
    _colorLo = [UIColor colorWithRed: 0.004 green: 0.004 blue: 0.004 alpha: 0.5];
    _colorHi = [UIColor colorWithRed: 0.004 green: 0.004 blue: 0.004 alpha: 0];
    
    _outsideColor = [UIColor colorWithRed: 0.902 green: 0.902 blue: 0.898 alpha: 1];
    _insideColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    _handle_width = 4;
    _handle_Color = [UIColor colorWithRed: 0.945 green: 0.361 blue: 0.153 alpha: 1];
    
    return self;
}

// paint the circle at given location
-(void)paint:(CGContextRef)ctx
      origin:(CGPoint)origin
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat sVGID_Locations[] = {0, 1};
    CGGradientRef sVGID = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)_colorHi.CGColor, (id)_colorLo.CGColor], sVGID_Locations);

    CGRect circleRect = CGRectMake(origin.x - _size / 2, origin.y - _size / 2, _size, _size);
    
    CGRect circleInner = CGRectMake(origin.x - (_size - _width) / 2, origin.y - (_size - _width) / 2, _size - _width, _size - _width);
    
    // Oval fill
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: circleRect];
    [_insideColor setFill];
    [oval2Path fill];
    
    // Oval stroke
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: circleRect];
    [_outsideColor setStroke];
    oval3Path.lineWidth = 1.16;
    [oval3Path stroke];

    UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: circleInner];
    
    CGContextSaveGState(ctx);
    [oval4Path addClip];
    CGContextDrawLinearGradient(ctx, sVGID,
                                CGPointMake(origin.x, origin.y),
                                CGPointMake(origin.x, origin.y - (_size - _width) / 2),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(ctx);
    
    CGGradientRelease(sVGID);
    CGColorSpaceRelease(colorSpace);
}

// paint the circle woth handle bar
-(void)paint:(CGContextRef)ctx
      origin:(CGPoint)origin
  handle_pos:(CGPoint)handle_pos
{
    // paint the handle first
    
    // outer path
    UIBezierPath* bezierOuterPath = UIBezierPath.bezierPath;
    [bezierOuterPath moveToPoint: handle_pos];
    [bezierOuterPath addLineToPoint: origin];
    
    [[UIColor whiteColor] setStroke];
    bezierOuterPath.lineWidth = _handle_width + 2.0;
    [bezierOuterPath stroke];
    
    // inner path
    UIBezierPath* bezierInnerPath = UIBezierPath.bezierPath;
    [bezierInnerPath moveToPoint: handle_pos];
    [bezierInnerPath addLineToPoint: origin];
    
    [_handle_Color setStroke];
    bezierInnerPath.lineWidth = _handle_width;
    [bezierInnerPath stroke];

    // then the circle
    [self paint:ctx origin:origin];
}

@end
