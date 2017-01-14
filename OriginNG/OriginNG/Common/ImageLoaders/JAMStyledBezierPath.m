//
//  JAMStyledBezierPath.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "JAMStyledBezierPath.h"
#import "JAMSVGGradientParts.h"

@interface JAMStyledBezierPath ()
@property (nonatomic) UIBezierPath *path;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) JAMSVGGradient *gradient;
@property (nonatomic) NSValue *transform;
@property (nonatomic) NSNumber *opacity;
@property (nonatomic) NSNumber *fillOpacity;
@property (nonatomic) NSNumber *strokeOpacity;

@property (nonatomic) NSString *dataString;         // Base64
@end

@implementation JAMStyledBezierPath


- (void)drawStyledPath:(CGContextRef)context;
{
    CGContextSaveGState(context);
    
    if (self.transform) {
        CGContextConcatCTM(context, self.transform.CGAffineTransformValue);
    }
    
    // fill related context settings
    if (self.fillColor && self.fillOpacity) {
        CGContextSetFillColorWithColor(context, [self.fillColor colorWithAlphaComponent:self.fillOpacity.floatValue].CGColor);
    }else if (self.fillColor)
    {
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    }
    
    // stroke related context settings
    if (self.strokeColor && self.strokeOpacity) {
        CGContextSetStrokeColorWithColor(context, [self.strokeColor colorWithAlphaComponent:self.strokeOpacity.floatValue].CGColor);
    }else if (self.strokeColor)
    {
        CGContextSetFillColorWithColor(context, self.strokeColor.CGColor);
    }
    if (self.path.lineWidth > 0.f)
    {
        CGContextSetLineWidth(context, self.path.lineWidth);
    }
    // end of stroke related context settings
    
    // draw it
    if (self.fillColor && self.strokeColor && self.path.lineWidth > 0.f)
    {
        // fill and sktroke
        CGContextBeginPath(context);
        CGContextAddPath(context, self.path.CGPath);
        CGContextDrawPath(context, kCGPathFillStroke);
    }else if (self.fillColor)
    {
        // fill only
        CGContextBeginPath(context);
        CGContextAddPath(context, self.path.CGPath);
        CGContextDrawPath(context, kCGPathFill);
    }else if (self.strokeColor && self.path.lineWidth > 0.f)
    {
        // stroke only
        CGContextBeginPath(context);
        CGContextAddPath(context, self.path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
    }
    // end of drawing
     
    // gradient fill
    if (self.gradient) {
        [self fillWithGradient:context];
    }

    CGContextRestoreGState(context);
}

-(id)init
{
    self = [super init];
    
    self.path = nil;
    self.fillColor = nil;
    self.strokeColor = nil;
    self.gradient = nil;
    self.transform = nil;
    self.fillColor = nil;
    self.fillOpacity = nil;
    self.strokeOpacity = nil;
    self.dataString = nil;
    
    return self;
}

- (void)fillWithGradient:(CGContextRef)context;
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colors = NSMutableArray.new;
    for (JAMSVGGradientColorStop *stop in self.gradient.colorStops) {
        [colors addObject:(id)stop.color.CGColor];
    }
    CGFloat locations[self.gradient.colorStops.count];
    for (int i = 0; i < self.gradient.colorStops.count; i++) {
        locations[i] = ((JAMSVGGradientColorStop *)self.gradient.colorStops[i]).position;
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFMutableArrayRef)colors, locations);
    
    CGContextAddPath(context, self.path.CGPath);
    CGContextClip(context);
    
    if (self.gradient.gradientTransform) {
        CGContextConcatCTM(context, self.gradient.gradientTransform.CGAffineTransformValue);
    }
    
    if ([self.gradient isKindOfClass:JAMSVGRadialGradient.class]) {
        JAMSVGRadialGradient *radialGradient = (JAMSVGRadialGradient *)self.gradient;
        CGContextDrawRadialGradient(context, gradient, radialGradient.position, 0.f, radialGradient.position, radialGradient.radius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    } else if ([self.gradient isKindOfClass:JAMSVGLinearGradient.class]) {
        JAMSVGLinearGradient *linearGradient = (JAMSVGLinearGradient *)self.gradient;
        CGContextDrawLinearGradient(context, gradient, linearGradient.startPosition, linearGradient.endPosition, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    }
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

-(void)fillTest:(CGContextRef)context;
{
    // circle background
    CGContextAddPath(context, self.path.CGPath);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:1.0].CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color1=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.0].CGColor;
    CGColorRef color2=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    
    CGGradientRef gradient;
    CGFloat locations[2] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)color1, (__bridge id)color2, nil];
    
    gradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, locations);
    
    CGContextAddPath(context, self.path.CGPath);
    CGContextClip(context);
    
    if (self.gradient.gradientTransform) {
        CGContextConcatCTM(context, self.gradient.gradientTransform.CGAffineTransformValue);
    }
 
    if ([self.gradient isKindOfClass:JAMSVGRadialGradient.class]) {
        JAMSVGRadialGradient *radialGradient = (JAMSVGRadialGradient *)self.gradient;
        CGContextDrawRadialGradient(context, gradient, radialGradient.position, 0.f, radialGradient.position, radialGradient.radius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    } else if ([self.gradient isKindOfClass:JAMSVGLinearGradient.class]) {
        JAMSVGLinearGradient *linearGradient = (JAMSVGLinearGradient *)self.gradient;
        CGContextDrawLinearGradient(context, gradient, linearGradient.startPosition, linearGradient.endPosition, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    }

    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"path: %@, fill: %@, stroke: %@, gradient: %@", self.path, self.fillColor, self.strokeColor, self.gradient];
}

@end