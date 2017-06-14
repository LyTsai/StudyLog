//
//  TRCenterLabel.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/27/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRCenterLabel.h"
#import "Define.h"

// label group used to show messages at the tree ring map center
@implementation TRCenterLabel

-(id)init
{
    self = [super init];
    
    _metricInfo = [[ANText alloc] initWithFont:@"Helvetica" size:12 shadow:FALSE underline:FALSE];
    _metricValue = [[ANText alloc] initWithFont:@"Helvetica" size:20 shadow:TRUE underline:FALSE];
    _title = [[ANText alloc] initWithFont:@"Helvetica-Bold" size:12 shadow:FALSE underline:FALSE];
    
    _bkgColorHi = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.2];
    _bkgColorLo = [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:.1];
    
    return self;
}

// test method
-(void)fillTestData
{
    _metricInfo.text = [NSMutableString stringWithString:@"Your Heart Years: "];
    _metricInfo.textFillColor = [UIColor blackColor];
    _metricInfo.textStrokeColor = [UIColor darkGrayColor];
    
    _metricValue.text = [NSMutableString stringWithString:@"-20"];
    _metricValue.textFillColor = [UIColor redColor];
    _metricValue.textStrokeColor = [UIColor blackColor];
    
    _title.text = [NSMutableString stringWithString:@"Tree Of Life"];
    _title.textFillColor = [UIColor darkGrayColor];
    _title.textStrokeColor = [UIColor grayColor];
}

// paint
-(void)paint:(CGContextRef)ctx
      radius:(float)radius
      origin:(CGPoint)origin
{
    // (1) background
    [self paintGradient2:ctx radius:radius origin:origin];
    
    // (2) title
    CGSize titleSize = [_title.attributedText size];
    CGRect rect = CGRectMake(origin.x - .5 * titleSize.width, (origin.y + titleSize.height), titleSize.width, titleSize.height + 2);
    
    [_title paint:ctx rect:rect attributedText:_title.attributedText];
    
    // (3) metricValue
    CGSize metricValueSize = [_metricValue.attributedText size];
    
    rect = CGRectMake(origin.x - .5 * metricValueSize.width, (origin.y - .5 * metricValueSize.height), metricValueSize.width, metricValueSize.height + 2);
    
    [_metricValue paint:ctx rect:rect attributedText:_metricValue.attributedText];
    
    // (4) metric
    CGSize metricSize = [_metricInfo.attributedText size];
    
    rect = CGRectMake(origin.x - .5 * metricSize.width, (origin.y - metricValueSize.height - .5 * metricSize.height), metricSize.width, metricSize.height + 2);
    
    [_metricInfo paint:ctx rect:rect attributedText:_metricInfo.attributedText];
}


-(void)paintGradient2:(CGContextRef)ctx
              radius:(float)radius
              origin:(CGPoint)origin
{
    // gradient color
    size_t num_locations = 2;
    CGFloat locations[] = {.0, 1.0};
    
    // gradient color
    CGFloat gradientColors[8] = {.0, .0, 1.0, .7, 1.0, 1.0, 1.0, .8};
    
    // edge
    CGColorRef colorref = [_bkgColorLo CGColor];
    int numComponents = CGColorGetNumberOfComponents(colorref);
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
    // center
    colorref = [_bkgColorHi CGColor];
    numComponents = CGColorGetNumberOfComponents(colorref);
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
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, gradientColors, locations, num_locations);
    
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    [aPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(0.0) endAngle:-DEGREES_TO_RADIANS(180.0) clockwise:FALSE];
    [aPath closePath];
    
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    
    CGContextAddPath(ctx, aPath.CGPath);
    
    CGContextClip(ctx);
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 3.0), 3.0, [UIColor grayColor].CGColor);
    
    CGContextDrawRadialGradient(ctx, gradient, origin, 0.0, origin, radius, kCGGradientDrawsBeforeStartLocation);
    
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}

-(void)paintGradient3:(CGContextRef)ctx
              radius:(float)radius
              origin:(CGPoint)origin
{
    // gradient color
    size_t num_locations = 3;
    CGFloat locations[] = {.0, .5, 1.0};
    
    // gradient color
    CGFloat gradientColors[12] = {.0, .0, 1.0, .7, 1.0, 1.0, 1.0, .8, .0, .0, 1.0, .7};
    
    // edge
    CGColorRef colorref = [_bkgColorHi CGColor];
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
    colorref = [_bkgColorLo CGColor];
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
    
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    [aPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(0.0) endAngle:-DEGREES_TO_RADIANS(180.0) clockwise:FALSE];
    [aPath closePath];
    
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    
    CGContextAddPath(ctx, aPath.CGPath);
    
    CGContextClip(ctx);
    
    CGContextDrawRadialGradient(ctx, gradient, origin, 0.0, origin, radius, kCGGradientDrawsBeforeStartLocation);
 
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}

@end
