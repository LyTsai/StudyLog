//
//  ANMetricView.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/9/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "ANMetricView.h"
#import "ANImage.h"
#import "JAMSVGImage.h"

@implementation ANMetricView

-(id)init
{
    self = [super init];
    
    _image = nil;
    _gradient = FALSE;
    _shadow = FALSE;
    _shape = Shape_Circle;
    _size = 2;
    
    _symbolImage = ASSESSMENT_SYMBOL_IMAGE_NA;
    _str64EncodedImage = nil;
    
    return self;
}

// convert visual options into in memory image
-(void)imageProjection
{
    // are we already assigned with an image?
    if (_image != nil)
    {
        return ;
    }
    
    // (1) try loading image file fro assesst first
    if (_symbolImage != ASSESSMENT_SYMBOL_IMAGE_NA && [self imageFileNameOf:_symbolImage] != nil)
    {
        _image = [UIImage imageNamed:[self imageFileNameOf:_symbolImage]];
        return ;
    }

    // (2) try cloud image
    if (_str64EncodedImage)
    {
        ANImage *str64Decoder = [[ANImage alloc] initWithDataString:_str64EncodedImage];
        _image = str64Decoder.image;
        return ;
    }
 
    return ;
}

// return image name for the given image file name
-(NSString*)imageFileNameOf:(ASSESSMENT_SYMBOL_IMAGE)symbolImage
{
    if (symbolImage == ASSESSMENT_SYMBOL_IMAGE_FACE_GREEN)
    {
        return @"face1.png";
    }else if (symbolImage == ASSESSMENT_SYMBOL_IMAGE_FACE_YELLOW)
    {
        return @"face2.png";
    }else if (symbolImage == ASSESSMENT_SYMBOL_IMAGE_FACE_GOLD)
    {
        return @"face3.png";
    }else if (symbolImage == ASSESSMENT_SYMBOL_IMAGE_FACE_ORANGE)
    {
        return @"face4.png";
    }else if (symbolImage == ASSESSMENT_SYMBOL_IMAGE_FACE_RED)
    {
        return @"face5.png";
    }else
    {
        return nil;
    }
    
    return nil;
}

// return image for given svg image file type
-(UIImage*)svgImage:(SVGView) svgImageName
{
    if (svgImageName == SVGView_Bubble_Red)
    {
        return [JAMSVGImage imageNamed:@"red"].image;
    }else if (svgImageName == SVGView_Bubble_Yellow)
    {
        return [JAMSVGImage imageNamed:@"yellow"].image;
    }else if (svgImageName == SVGView_Bubble_Green)
    {
        return [JAMSVGImage imageNamed:@"green"].image;
    }else if (svgImageName == SVGView_Bubble_Blue)
    {
        return [JAMSVGImage imageNamed:@"blue"].image;
    }else if (svgImageName == SVGView_Bubble_Orange)
    {
        return [JAMSVGImage imageNamed:@"Orange"].image;
    }else if (svgImageName == SVGView_Bubble_Purple)
    {
        return [JAMSVGImage imageNamed:@"Purple"].image;
    }
    
    return nil;
}

// create filled image
+(void)createDynamicImageView_fill:(CGContextRef)ctx
                              view:(ANMetricView*)view
                     fontPointSize:(float)fontPointSize
{
    CGContextSaveGState(ctx);
    
    // (1) fill with subtle shadow
    if (view.shadow == TRUE)
    {
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0, [UIColor grayColor].CGColor);
    }
    
    // fill color
    CGContextSetFillColorWithColor(ctx, view.fillcolor.CGColor);
    // stroke color
    CGContextSetStrokeColorWithColor(ctx, view.edgecolor.CGColor);
    CGContextSetLineWidth(ctx, .5);
    
    // path for drawing
    float radius = .5 * view.size * fontPointSize;
    
    UIBezierPath *cellPath = [self getShapePath:view.shape
                                         radius:radius
                                       position:CGPointMake(radius, radius)];
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, cellPath.CGPath);
    
    // draw it
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    view.image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(ctx);
    
    return ;
}

+(void)createDynamicImageView_gradient:(CGContextRef)ctx
                                  view:(ANMetricView*)view
                         fontPointSize:(float)fontPointSize
{
    size_t num_locations = 2;
    CGFloat locations[] = {.0, 1.0};
    
    CGFloat gradientColors[8] = {1.0, 1.0, 1.0, .8, .0, .0, 1.0, 1.0};
    
    CGColorRef colorref = [view.fillcolor CGColor];
    int numComponents = CGColorGetNumberOfComponents(colorref);
    if (numComponents >= 3)
    {
        const CGFloat *components = CGColorGetComponents(colorref);
        CGFloat red     = components[0];
        CGFloat green = components[1];
        CGFloat blue   = components[2];
        
        gradientColors[4] = red;
        gradientColors[5] = green;
        gradientColors[6] = blue;
        gradientColors[7] = 1.0;
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, gradientColors, locations, num_locations);
    
    CGContextSaveGState(ctx);
    
    // path for drawing
    float radius = .5 * view.size * fontPointSize;
    CGPoint origin = CGPointMake(radius, radius);
    
    UIBezierPath *cellPath = [self getShapePath:view.shape
                                         radius:radius
                                       position:origin];
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, cellPath.CGPath);
    CGContextClip(ctx);
    
    CGPoint startPoint, endPoint;
    CGFloat startRadius, endRadius;
    
    endPoint = origin;
    
    startPoint = origin;
    startPoint.x -= .25 * radius;
    startPoint.y -= .25 * radius;
    
    startRadius = .0;
    endRadius = radius;
    
    CGContextDrawRadialGradient (ctx, gradient,
                                 startPoint, startRadius,
                                 endPoint, endRadius,
                                 0);
    
    // thin edge around it
    // stroke color
    CGContextSetStrokeColorWithColor(ctx, view.edgecolor.CGColor);
    CGContextSetLineWidth(ctx, .5);
    
    CGContextAddPath(ctx, cellPath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    // done
    
    view.image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}

+(void)createDynamicImageView_gradient1:(CGContextRef)ctx
                                   view:(ANMetricView*)view
                          fontPointSize:(float)fontPointSize
{
    size_t num_locations = 3;
    CGFloat locations[] = {.0, .8, 1.0};
    
    CGFloat gradientColors[12] = {1.0, 1.0, 1.0, .8, .0, .0, 1.0, 1.0, .3, .3, .3, .8};
    
    // fill color
    CGColorRef colorref = [view.fillcolor CGColor];
    int numComponents = CGColorGetNumberOfComponents(colorref);
    if (numComponents >= 3)
    {
        const CGFloat *components = CGColorGetComponents(colorref);
        CGFloat red     = components[0];
        CGFloat green = components[1];
        CGFloat blue   = components[2];
        
        gradientColors[4] = red;
        gradientColors[5] = green;
        gradientColors[6] = blue;
        gradientColors[7] = .9;
    }
    
    // edge color
    colorref = [view.edgecolor CGColor];
    numComponents = CGColorGetNumberOfComponents(colorref);
    if (numComponents >= 3)
    {
        const CGFloat *components = CGColorGetComponents(colorref);
        CGFloat red     = components[0];
        CGFloat green = components[1];
        CGFloat blue   = components[2];
        
        gradientColors[8] = red;
        gradientColors[9] = green;
        gradientColors[10] = blue;
        gradientColors[11] = .8;
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, gradientColors, locations, num_locations);
    
    CGContextSaveGState(ctx);
    
    // path for drawing
    float radius = .5 * view.size * fontPointSize;
    CGPoint origin = CGPointMake(radius, radius);
    
    UIBezierPath *cellPath = [self getShapePath:view.shape
                                         radius:radius
                                       position:origin];
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, cellPath.CGPath);
    CGContextClip(ctx);
    
    CGPoint startPoint, endPoint;
    CGFloat startRadius, endRadius;
    
    endPoint = origin;
    
    startPoint = origin;
    startPoint.x -= .25 * radius;
    startPoint.y -= .25 * radius;
    
    startRadius = .0;
    endRadius = radius;
    
    CGContextDrawRadialGradient (ctx, gradient,
                                 startPoint, startRadius,
                                 endPoint, endRadius,
                                 0);
    
    view.image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}

// get view shape path
+(UIBezierPath *)getShapePath:(Shape)shape
                       radius:(float)radius
                     position:(CGPoint)position
{
    if (shape == Shape_Circle || shape == Shape_Dot)
    {
        CGRect frame = CGRectMake(position.x - radius, position.y - radius, 2 * radius, 2 * radius);
        UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:frame
                                                          cornerRadius:frame.size.height * 1.0 / 2.0];
        
        return circle;
    }
    
    return nil;
}


@end
