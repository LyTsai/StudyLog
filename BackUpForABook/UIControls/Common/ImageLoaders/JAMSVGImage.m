//
//  JAMSVGImage.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "JAMSVGImage.h"
#import "JAMSVGParser.h"
#import "JAMStyledBezierPath.h"

@interface JAMSVGImage ()
@property (nonatomic) NSArray *styledPaths;
@property (nonatomic, readwrite) CGSize size;
@end

@implementation JAMSVGImage

+ (JAMSVGImage *)imageNamed:(NSString *)name;
{
    return [JAMSVGImage imageWithContentsOfFile:[NSBundle.mainBundle pathForResource:name ofType:@"svg"]];
}

+ (JAMSVGImage *)imageWithContentsOfFile:(NSString *)path;
{
    JAMSVGImage *image = JAMSVGImage.new;
    JAMSVGParser *parser = [JAMSVGParser.alloc initWithSVGDocument:path];
    if (!parser) return nil;
    
    [parser parseSVGDocument];
    image.styledPaths = parser.paths;
    image.size = parser.viewBox.size;
    image.scale = 1;
    return image;
}

+ (JAMSVGImage *)imageWithSVGData:(NSData *)svgData;
{
    JAMSVGImage *image = JAMSVGImage.new;
    JAMSVGParser *parser = [JAMSVGParser.alloc initWithSVGData:svgData];
    if (!parser) return nil;
    
    [parser parseSVGDocument];
    image.styledPaths = parser.paths;
    image.size = parser.viewBox.size;
    image.scale = 1;
    return image;
}

- (UIImage *)image;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width * self.scale,
                                                      self.size.height * self.scale), NO, 0.f);
    [self drawInCurrentContext];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGImageRef)CGImage;
{
    return self.image.CGImage;
}

- (void)drawInCurrentContext;
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawInContext:context];
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextScaleCTM(context, self.scale, self.scale);
    for (JAMStyledBezierPath *styledPath in self.styledPaths) {
        [styledPath drawStyledPath:context];
    }
    CGContextRestoreGState(context);
}

- (void)drawInRect:(CGContextRef)context
             rect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextScaleCTM(context, rect.size.width / self.size.width, rect.size.height / self.size.height);
    
    [self drawInContext:context];
    CGContextRestoreGState(context);
}

- (void)drawAtPoint:(CGContextRef)context
              point:(CGPoint)point
{
    [self drawInRect:context rect:CGRectMake(point.x, point.y, self.size.width, self.size.height)];
}

- (void)drawAtPoint:(CGPoint)point
{
    [self drawInRect:CGRectMake(point.x, point.y, self.size.width, self.size.height)];
}

- (void)drawInRect:(CGRect)rect;
{
    [self drawInRect:UIGraphicsGetCurrentContext() rect:rect];
}

@end
