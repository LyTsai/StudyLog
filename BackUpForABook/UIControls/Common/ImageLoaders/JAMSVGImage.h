//
//  JAMSVGImage.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JAMSVGImage : NSObject

/** Size of the SVG image, in points. This reflects the size of the 'viewBox' element of the SVG document. */
@property (nonatomic, readonly) CGSize size;

/** Scale at which the SVG image will be drawn. Default is 1.0. */
@property (nonatomic) CGFloat scale;

/** Returns a CGImageRef or UIImage of the SVG image at the current scale. */
@property (nonatomic, readonly) CGImageRef CGImage;
@property (nonatomic, readonly) UIImage *image;

//* Initializes a new SVG image from a file or data source. */
+ (JAMSVGImage *)imageNamed:(NSString *)name;
+ (JAMSVGImage *)imageWithContentsOfFile:(NSString *)path;
+ (JAMSVGImage *)imageWithSVGData:(NSData *)svgData;

//* Draws the SVG image either in the given context, or at a specific point, or in a specific rect. */
- (void)drawInCurrentContext;
- (void)drawInContext:(CGContextRef)context;
- (void)drawInRect:(CGContextRef)context
             rect:(CGRect)rect;
- (void)drawAtPoint:(CGContextRef)context
              point:(CGPoint)point;

//* Draws the SVG image either in the current context, or at a specific point, or in a specific rect. */
- (void)drawAtPoint:(CGPoint)point;
- (void)drawInRect:(CGRect)rect;

@end
