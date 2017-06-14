//
//  ANMetricView.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/9/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMetricViewBase.h"

// represents mapped "view" of annielytics metric.
// this object represents UI view of metric value.  For each metric type there will be
// a "projector" table that is an array of ANMetricView for mapping the value into graphical view 
// each metric value can be projected into visual presentation form with:
// size, shape, fill color, edge color and image, tip message plus option of shadow and gradient mode etc
typedef enum
{
    Shape_None      = 1,    // only returns color for given metric value.  no drawing info
    Shape_Circle,
    Shape_Rect,
    Shape_Triangle,
    Shape_Dot,
    Shape_Diamond
}Shape;

// assessment symbol image file names
typedef enum
{
    ASSESSMENT_SYMBOL_IMAGE_NA,
    ASSESSMENT_SYMBOL_IMAGE_FACE_GREEN,
    ASSESSMENT_SYMBOL_IMAGE_FACE_YELLOW,
    ASSESSMENT_SYMBOL_IMAGE_FACE_GOLD,
    ASSESSMENT_SYMBOL_IMAGE_FACE_ORANGE,
    ASSESSMENT_SYMBOL_IMAGE_FACE_RED
}ASSESSMENT_SYMBOL_IMAGE;

// default SVG images
typedef enum
{
    SVGView_None            = 0,
    SVGView_Bubble_Red,
    SVGView_Bubble_Yellow,
    SVGView_Bubble_Green,
    SVGView_Bubble_Blue,
    SVGView_Bubble_Orange,
    SVGView_Bubble_Purple
}SVGView;

@interface ANMetricView : ANMetricViewBase

// method to project visula options into in memory image
-(void)imageProjection;

// properties
// in font unit
@property(nonatomic)int size;
// drawing shap (clip within this shape path)
@property(nonatomic)Shape shape;

// background style
// gradient from fill color to white
@property(nonatomic)BOOL gradient;
// shadow on edge
@property(nonatomic)BOOL shadow;

// image in memory ready to use.  option of viewing metric should be projected into in memory image for efficiency
@property(strong, nonatomic)UIImage* image;

// different ways of loading visual presentation that can be converted (or loaded) into memory for displaying metric:

// (1) symbol name of image in assest
@property ASSESSMENT_SYMBOL_IMAGE symbolImage;
// (2) cloud base64 image string data.
@property(strong,  nonatomic)NSString* str64EncodedImage;

// utilities in case you need them

// create image view of the ANMetricView
+(void)createDynamicImageView:(CGContextRef)ctx
                         view:(ANMetricView*)view
                fontPointSize:(float)fontPointSize;

// create filled image
+(void)createDynamicImageView_fill:(CGContextRef)ctx
                              view:(ANMetricView*)view
                     fontPointSize:(float)fontPointSize;

// create gradient color image
+(void)createDynamicImageView_gradient:(CGContextRef)ctx
                                  view:(ANMetricView*)view
                         fontPointSize:(float)fontPointSize;

// another variation
+(void)createDynamicImageView_gradient1:(CGContextRef)ctx
                                   view:(ANMetricView*)view
                          fontPointSize:(float)fontPointSize;

// get view shape path
+(UIBezierPath *)getShapePath:(Shape)shape
                       radius:(float)radius
                     position:(CGPoint)position;

@end
