//
//  TRSliceRing.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/15/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRSliceRing.h"
#include "Define.h"

@implementation TRSliceRing
{
    @private
    
    //// Color Declarations
    UIColor* gradientColor;
    UIColor* gradientColor2;
    UIColor* gradientColor3;
    UIColor* gradientColor4;
    UIColor* gradientColor5;
    UIColor* gradientColor6;
    UIColor* gradientColor7;
    UIColor* gradientColor8;
    UIColor* gradientColor9;
    UIColor* gradientColor10;
    UIColor* gradientColor11;
    UIColor* gradientColor12;
    UIColor* gradientColor13;
    UIColor* gradientColor14;
    UIColor* gradientColor15;
    UIColor* gradientColor16;
    UIColor* gradientColor17;
    UIColor* gradientColor18;
    UIColor* gradientColor19;
    UIColor* gradientColor20;
    UIColor* gradientColor21;
    UIColor* gradientColor22;
    UIColor* gradientColor23;
    UIColor* gradientColor24;
    UIColor* gradientColor25;
    UIColor* gradientColor26;
    UIColor* gradientColor27;
    UIColor* gradientColor28;
    UIColor* gradientColor29;
    UIColor* gradientColor30;
    UIColor* gradientColor31;
    UIColor* gradientColor32;
    UIColor* gradientColor33;
    UIColor* gradientColor34;
    UIColor* gradientColor35;
    UIColor* gradientColor36;
    UIColor* gradientColor37;
    UIColor* gradientColor38;
    UIColor* gradientColor39;
    UIColor* gradientColor40;
    UIColor* gradientColor41;
    UIColor* fillColor1;
    UIColor* fillColor2;
    UIColor* fillColor3;
    UIColor* fillColor4;
    UIColor* strokeColor3;
}

// methods
-(void)initColors
{
    //// Color Declarations
    gradientColor = [UIColor colorWithRed: 0.004 green: 0.004 blue: 0.004 alpha: 0.5];
    gradientColor2 = [UIColor colorWithRed: 0.004 green: 0.004 blue: 0.004 alpha: 0];
    gradientColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.5];
    gradientColor4 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    gradientColor5 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    gradientColor6 = [UIColor colorWithRed: 0.973 green: 0.973 blue: 0.988 alpha: 1];
    gradientColor7 = [UIColor colorWithRed: 0.788 green: 0.816 blue: 0.918 alpha: 1];
    gradientColor8 = [UIColor colorWithRed: 0.639 green: 0.698 blue: 0.859 alpha: 1];
    gradientColor9 = [UIColor colorWithRed: 0.522 green: 0.608 blue: 0.812 alpha: 1];
    gradientColor10 = [UIColor colorWithRed: 0.435 green: 0.545 blue: 0.78 alpha: 1];
    gradientColor11 = [UIColor colorWithRed: 0.365 green: 0.502 blue: 0.753 alpha: 1];
    gradientColor12 = [UIColor colorWithRed: 0.31 green: 0.471 blue: 0.737 alpha: 1];
    gradientColor13 = [UIColor colorWithRed: 0.275 green: 0.455 blue: 0.729 alpha: 1];
    gradientColor14 = [UIColor colorWithRed: 0.267 green: 0.451 blue: 0.725 alpha: 1];
    gradientColor15 = [UIColor colorWithRed: 0.961 green: 0.961 blue: 0.961 alpha: 0.5];
    gradientColor16 = [UIColor colorWithRed: 0.231 green: 0.231 blue: 0.231 alpha: 0.5];
    gradientColor17 = [UIColor colorWithRed: 0.922 green: 0.922 blue: 0.922 alpha: 0.5];
    gradientColor18 = [UIColor colorWithRed: 0.82 green: 0.82 blue: 0.82 alpha: 0.5];
    gradientColor19 = [UIColor colorWithRed: 0.659 green: 0.659 blue: 0.659 alpha: 0.5];
    gradientColor20 = [UIColor colorWithRed: 0.518 green: 0.518 blue: 0.518 alpha: 0.5];
    gradientColor21 = [UIColor colorWithRed: 0.408 green: 0.408 blue: 0.408 alpha: 0.5];
    gradientColor22 = [UIColor colorWithRed: 0.318 green: 0.318 blue: 0.318 alpha: 0.5];
    gradientColor23 = [UIColor colorWithRed: 0.259 green: 0.259 blue: 0.259 alpha: 0.5];
    gradientColor24 = [UIColor colorWithRed: 0.22 green: 0.22 blue: 0.22 alpha: 0.5];
    gradientColor25 = [UIColor colorWithRed: 0.212 green: 0.212 blue: 0.212 alpha: 0.5];
    gradientColor26 = [UIColor colorWithRed: 0.29 green: 0.29 blue: 0.29 alpha: 0.5];
    gradientColor27 = [UIColor colorWithRed: 0.384 green: 0.384 blue: 0.384 alpha: 0.5];
    gradientColor28 = [UIColor colorWithRed: 0.69 green: 0.69 blue: 0.69 alpha: 0.5];
    gradientColor29 = [UIColor colorWithRed: 0.839 green: 0.839 blue: 0.839 alpha: 0.5];
    gradientColor30 = [UIColor colorWithRed: 0.749 green: 0.749 blue: 0.749 alpha: 0.5];
    gradientColor31 = [UIColor colorWithRed: 0.655 green: 0.655 blue: 0.655 alpha: 0.5];
    gradientColor32 = [UIColor colorWithRed: 0.584 green: 0.584 blue: 0.584 alpha: 0.5];
    gradientColor33 = [UIColor colorWithRed: 0.545 green: 0.545 blue: 0.545 alpha: 0.5];
    gradientColor34 = [UIColor colorWithRed: 0.529 green: 0.529 blue: 0.529 alpha: 0.5];
    gradientColor35 = [UIColor colorWithRed: 0.11 green: 0.11 blue: 0.11 alpha: 0.5];
    gradientColor36 = [UIColor colorWithRed: 0.592 green: 0.592 blue: 0.592 alpha: 1];
    gradientColor37 = [UIColor colorWithRed: 0.694 green: 0.675 blue: 0.675 alpha: 1];
    gradientColor38 = [UIColor colorWithRed: 0.718 green: 0.706 blue: 0.698 alpha: 1];
    gradientColor39 = [UIColor colorWithRed: 0.941 green: 0.941 blue: 0.941 alpha: 1];
    gradientColor40 = [UIColor colorWithRed: 0.702 green: 0.69 blue: 0.686 alpha: 1];
    gradientColor41 = [UIColor colorWithRed: 0.737 green: 0.722 blue: 0.722 alpha: 1];
    fillColor1 = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1];
    fillColor2 = [UIColor colorWithRed: 0.506 green: 0.506 blue: 0.506 alpha: 0.5];
    fillColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    fillColor4 = [UIColor colorWithRed: 0.902 green: 0.902 blue: 0.898 alpha: 1];
    strokeColor3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
}

-(id)init
{
    self = [super init];
    
    [self initColors];
    
    _backgroundShadow = TRUE;
    //_bkgColor = [UIColor colorWithRed:0.663 green:.2 blue:.03 alpha:.3];
    _bkgColor = [UIColor colorWithRed:0.8 green:.8 blue:.8 alpha:.6];
    _borderColor = [UIColor colorWithRed:0.8 green:.8 blue:.8 alpha:.8];
    _lineWidth = 1.5;
    _size = 22;
    
    _showType = TRSLICERINGBKG_METAL;
    
    _outerDecorationRingSize = 8;
    _outerDecorationRingOffset = 4;
    _outerDecorationGradientColorBegin2End = TRUE;
    _outerDecorationRingFocus = TRUE;
    _innerDecorationStyle = INNERDECORATION_WHITE_BLACK;// INNERDECORATION_BLACK_GREY; // INNERDECORATION_WHITE_BLACK
    
    return self;
}

-(void)paint:(CGContextRef)ctx
  startAngle:(float)start
    endAngle:(float)end
      radius:(float)radius
        size:(float)size
      center:(CGPoint)origin
{
    // the ring
    if (_showType == TRSLICERINGBKG_SIMPLE)
    {
        [self paint_simple:ctx
                       startAngle:start
                         endAngle:end
                           radius:radius
                             size:size
                           center:origin];
    }else if (_showType == TRSLICERINGBKG_METAL)
    {
        [self paint_metal:ctx
                      startAngle:start
                        endAngle:end
                          radius:radius
                            size:size
                          center:origin];
    }
    
    // outer decoration
    // position at: radius + size + _outerDecorationRingOffset
    // size: _outerDecorationRingSize
    [self paint_decorationRing_Outer:ctx
                          startAngle:start
                            endAngle:end
                              radius:(radius + size + _outerDecorationRingOffset)
                                size:_outerDecorationRingSize
                              center:origin];
    
    // inner decoration
    // position at: radius
    // size: 12
    [self paint_decorationRing_Inner:ctx
                          startAngle:start
                            endAngle:end
                              radius:radius
                                size:12
                              center:origin];
}

-(void)paint_simple:(CGContextRef)ctx
         startAngle:(float)start
           endAngle:(float)end
             radius:(float)radius
               size:(float)size
             center:(CGPoint)origin
{
    // create path first
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    
    // get path
    CGPoint minRadiusStart = CGPointMake(origin.x + radius * cosf(DEGREES_TO_RADIANS(start)), origin.y - radius * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint maxRadiusEnd = CGPointMake(origin.x + (radius + size) * cosf(DEGREES_TO_RADIANS(end)), origin.y - (radius + size) * sinf(DEGREES_TO_RADIANS(end)));
    
    [aPath moveToPoint:minRadiusStart];
    [aPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(start) endAngle:-DEGREES_TO_RADIANS(end) clockwise:FALSE];
    [aPath addLineToPoint:maxRadiusEnd];
    [aPath addArcWithCenter:origin radius:(radius + size) startAngle:-DEGREES_TO_RADIANS(end) endAngle:-DEGREES_TO_RADIANS(start) clockwise:TRUE];
    
    [aPath closePath];
    
    // save the original context first
    CGContextSaveGState(ctx);
    
    // (1) fill the path:
    // background fill color
    CGContextSetFillColorWithColor(ctx, _bkgColor.CGColor);
    
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, aPath.CGPath);
    
    // fill the path
    CGContextFillPath(ctx);
    
    // (2) inner shadow
    if (_backgroundShadow == TRUE)
    {
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 4.0), 5.0, [UIColor grayColor].CGColor);
    }
    
    CGContextAddPath(ctx, aPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    
    CGContextSetLineWidth(ctx, _lineWidth);
    
    CGContextStrokePath(ctx);
    
    // restore the original contest
    CGContextRestoreGState(ctx);
}

-(void)paint_metal:(CGContextRef)ctx
        startAngle:(float)start
          endAngle:(float)end
            radius:(float)radius
              size:(float)size
            center:(CGPoint)origin
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    //// Gradient Declarations
    CGFloat sVGID_6_Locations[] = {0, 1};
    CGGradientRef sVGID_6_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor.CGColor, (id)gradientColor2.CGColor], sVGID_6_Locations);
    CGFloat sVGID_3_Locations[] = {0, 1};
    CGGradientRef sVGID_3_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor3.CGColor, (id)gradientColor4.CGColor], sVGID_3_Locations);
    CGFloat sVGID_5_Locations[] = {0, 0.01, 0.09, 0.19, 0.29, 0.39, 0.5, 0.63, 0.78, 1};
    CGGradientRef sVGID_5_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor5.CGColor, (id)gradientColor6.CGColor, (id)gradientColor7.CGColor, (id)gradientColor8.CGColor, (id)gradientColor9.CGColor, (id)gradientColor10.CGColor, (id)gradientColor11.CGColor, (id)gradientColor12.CGColor, (id)gradientColor13.CGColor, (id)gradientColor14.CGColor], sVGID_5_Locations);
    CGFloat sVGID_2_Locations[] = {0, 0.19, 0.41, 0.42, 0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.69, 0.72, 0.76, 0.79, 0.81, 0.83, 0.86, 0.89, 0.93, 1};
    CGGradientRef sVGID_2_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor15.CGColor, (id)gradientColor16.CGColor, (id)gradientColor17.CGColor, (id)gradientColor18.CGColor, (id)gradientColor19.CGColor, (id)gradientColor20.CGColor, (id)gradientColor21.CGColor, (id)gradientColor22.CGColor, (id)gradientColor23.CGColor, (id)gradientColor24.CGColor, (id)gradientColor25.CGColor, (id)gradientColor16.CGColor, (id)gradientColor26.CGColor, (id)gradientColor27.CGColor, (id)gradientColor20.CGColor, (id)gradientColor28.CGColor, (id)gradientColor29.CGColor, (id)gradientColor30.CGColor, (id)gradientColor31.CGColor, (id)gradientColor32.CGColor, (id)gradientColor33.CGColor, (id)gradientColor34.CGColor, (id)gradientColor35.CGColor], sVGID_2_Locations);
    CGFloat sVGID_4_Locations[] = {0.11, 0.24, 0.35, 0.54, 0.69, 0.77, 0.85, 1};
    CGGradientRef sVGID_4_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor36.CGColor, (id)gradientColor5.CGColor, (id)gradientColor37.CGColor, (id)gradientColor5.CGColor, (id)gradientColor38.CGColor, (id)gradientColor39.CGColor, (id)gradientColor40.CGColor, (id)gradientColor41.CGColor], sVGID_4_Locations);
    
    CGPoint minRadiusStart = CGPointMake(origin.x + radius * cosf(DEGREES_TO_RADIANS(start)), origin.y - radius * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint minRadiusEnd = CGPointMake(origin.x + radius * cosf(DEGREES_TO_RADIANS(end)), origin.y - radius * sinf(DEGREES_TO_RADIANS(end)));

    CGPoint middleRadiusStart = CGPointMake(origin.x + (radius + size / 2) * cosf(DEGREES_TO_RADIANS(start)), origin.y - (radius + size / 2) * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint middleRadiusEnd = CGPointMake(origin.x + (radius + size / 2) * cosf(DEGREES_TO_RADIANS(end)), origin.y - (radius + size / 2) * sinf(DEGREES_TO_RADIANS(end)));
    
    CGPoint maxRadiusStart = CGPointMake(origin.x + (radius + size) * cosf(DEGREES_TO_RADIANS(start)), origin.y - (radius + size) * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint maxRadiusEnd = CGPointMake(origin.x + (radius + size) * cosf(DEGREES_TO_RADIANS(end)), origin.y - (radius + size) * sinf(DEGREES_TO_RADIANS(end)));

    // bezier for outside edge
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    
    [bezierPath moveToPoint:minRadiusStart];
    [bezierPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(start) endAngle:-DEGREES_TO_RADIANS(end) clockwise:FALSE];
    [bezierPath addLineToPoint:maxRadiusEnd];
    [bezierPath addArcWithCenter:origin radius:(radius + size) startAngle:-DEGREES_TO_RADIANS(end) endAngle:-DEGREES_TO_RADIANS(start) clockwise:TRUE];
    [bezierPath closePath];
    
    bezierPath.miterLimit = 4;
    [fillColor2 setFill];
    [bezierPath fill];

    // bezier for middle edge
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    
    [bezier2Path moveToPoint:middleRadiusStart];
    [bezier2Path addArcWithCenter:origin radius:(radius + size / 2) startAngle:-DEGREES_TO_RADIANS(start) endAngle:-DEGREES_TO_RADIANS(end) clockwise:FALSE];
    [bezier2Path addLineToPoint:minRadiusEnd];
    [bezier2Path addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(end) endAngle:-DEGREES_TO_RADIANS(start) clockwise:TRUE];
    [bezier2Path closePath];

    bezier2Path.miterLimit = 4;
    
    CGContextSaveGState(ctx);
    [bezier2Path addClip];
    CGContextDrawLinearGradient(ctx, sVGID_2_,
                                CGPointMake(middleRadiusEnd.x, radius / 2),             // left
                                CGPointMake(middleRadiusStart.x, radius / 2),           // right
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(ctx);
 
    //// Cleanup
    CGGradientRelease(sVGID_6_);
    CGGradientRelease(sVGID_3_);
    CGGradientRelease(sVGID_5_);
    CGGradientRelease(sVGID_2_);
    CGGradientRelease(sVGID_4_);
    
    CGColorSpaceRelease(colorSpace);
}

///////////////////////////////////////////////////////
// paint decoration rings

// start, end - rang ein angle
// radius - ring position of outer decoration ring
// size - size of the decoration ring
// outer decoration ring
-(void)paint_decorationRing_Outer:(CGContextRef)ctx
                       startAngle:(float)start
                         endAngle:(float)end
                           radius:(float)radius
                             size:(float)size
                           center:(CGPoint)origin
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGPoint minRadiusStart = CGPointMake(origin.x + radius * cosf(DEGREES_TO_RADIANS(start)), origin.y - radius * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint minRadiusEnd = CGPointMake(origin.x + radius * cosf(DEGREES_TO_RADIANS(end)), origin.y - radius * sinf(DEGREES_TO_RADIANS(end)));

    CGPoint maxRadiusStart = CGPointMake(origin.x + (radius + size) * cosf(DEGREES_TO_RADIANS(start)), origin.y - (radius + size) * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint maxRadiusEnd = CGPointMake(origin.x + (radius + size) * cosf(DEGREES_TO_RADIANS(end)), origin.y - (radius + size) * sinf(DEGREES_TO_RADIANS(end)));
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    
    // line path
    [bezierPath moveToPoint:minRadiusStart];
    [bezierPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(start) endAngle:-DEGREES_TO_RADIANS(end) clockwise:FALSE];
    [bezierPath addLineToPoint:maxRadiusEnd];
    [bezierPath addArcWithCenter:origin radius:(radius + size) startAngle:-DEGREES_TO_RADIANS(end) endAngle:-DEGREES_TO_RADIANS(start) clockwise:TRUE];
    [bezierPath closePath];

    if (_outerDecorationRingFocus == TRUE)
    {
        CGFloat sVGID_5_Locations[] = {0, 0.01, 0.09, 0.19, 0.29, 0.39, 0.5, 0.63, 0.78, 1};
        CGGradientRef sVGID_5_ = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)gradientColor5.CGColor, (id)gradientColor6.CGColor, (id)gradientColor7.CGColor, (id)gradientColor8.CGColor, (id)gradientColor9.CGColor, (id)gradientColor10.CGColor, (id)gradientColor11.CGColor, (id)gradientColor12.CGColor, (id)gradientColor13.CGColor, (id)gradientColor14.CGColor], sVGID_5_Locations);
    
        CGContextSaveGState(ctx);
        [bezierPath addClip];
    
        if (_outerDecorationGradientColorBegin2End == TRUE)
        {
            CGContextDrawLinearGradient(ctx, sVGID_5_,
                                CGPointMake(maxRadiusEnd.x, (maxRadiusStart.y + maxRadiusEnd.y) / 2),
                                CGPointMake(maxRadiusStart.x, (maxRadiusStart.y + maxRadiusEnd.y) / 2),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        }else
        {
            CGContextDrawLinearGradient(ctx, sVGID_5_,
                                CGPointMake(maxRadiusStart.x, (maxRadiusStart.y + maxRadiusEnd.y) / 2),
                                CGPointMake(maxRadiusEnd.x, (maxRadiusStart.y + maxRadiusEnd.y) / 2),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        }
        CGContextRestoreGState(ctx);
        
        CGGradientRelease(sVGID_5_);
    }else
    {
        [fillColor4 setFill];
        [bezierPath fill];
    }
    
    CGColorSpaceRelease(colorSpace);
    
    [strokeColor3 setStroke];
    bezierPath.lineWidth = 3;
    [bezierPath stroke];
}

// start, end - rang ein angle
// radius - ring position (end) of inner decoration ring
// size - size of the decoration ring
// inner decoration ring
-(void)paint_decorationRing_Inner:(CGContextRef)ctx
                       startAngle:(float)start
                         endAngle:(float)end
                           radius:(float)radius
                             size:(float)size
                           center:(CGPoint)origin
{
    // bezier for outside edge
    UIBezierPath* bezierLowPath = UIBezierPath.bezierPath;
    UIBezierPath* bezierUpPath = UIBezierPath.bezierPath;
    
    // ring width of narrow  band
    float rw = 3.0;
    
    CGPoint minRadiusStart = CGPointMake(origin.x + (radius - size) * cosf(DEGREES_TO_RADIANS(start)), origin.y - (radius - size) * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint minRadiusEnd = CGPointMake(origin.x + (radius - size) * cosf(DEGREES_TO_RADIANS(end)), origin.y - (radius - size) * sinf(DEGREES_TO_RADIANS(end)));
    
    CGPoint middleRadiusStart = CGPointMake(origin.x + (radius - rw) * cosf(DEGREES_TO_RADIANS(start)), origin.y - (radius - rw) * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint middleRadiusEnd = CGPointMake(origin.x + (radius - rw) * cosf(DEGREES_TO_RADIANS(end)), origin.y - (radius - rw) * sinf(DEGREES_TO_RADIANS(end)));
    
    CGPoint maxRadiusStart = CGPointMake(origin.x + radius * cosf(DEGREES_TO_RADIANS(start)), origin.y - radius * sinf(DEGREES_TO_RADIANS(start)));
    CGPoint maxRadiusEnd = CGPointMake(origin.x + radius * cosf(DEGREES_TO_RADIANS(end)), origin.y - radius * sinf(DEGREES_TO_RADIANS(end)));
    
    // lower rect
    [bezierLowPath moveToPoint:minRadiusStart];
    [bezierLowPath addArcWithCenter:origin radius:(radius - size) startAngle:-DEGREES_TO_RADIANS(start) endAngle:-DEGREES_TO_RADIANS(end) clockwise:FALSE];
    [bezierLowPath addLineToPoint:middleRadiusEnd];
    [bezierLowPath addArcWithCenter:origin radius:(radius - rw) startAngle:-DEGREES_TO_RADIANS(end) endAngle:-DEGREES_TO_RADIANS(start) clockwise:TRUE];
    [bezierLowPath closePath];
    
    // upper rect
    bezierUpPath = UIBezierPath.bezierPath;
    [bezierUpPath moveToPoint:middleRadiusStart];
    [bezierUpPath addArcWithCenter:origin radius:(radius - rw) startAngle:-DEGREES_TO_RADIANS(start) endAngle:-DEGREES_TO_RADIANS(end) clockwise:FALSE];
    [bezierUpPath addLineToPoint:maxRadiusEnd];
    [bezierUpPath addArcWithCenter:origin radius:radius startAngle:-DEGREES_TO_RADIANS(end) endAngle:-DEGREES_TO_RADIANS(start) clockwise:TRUE];
    [bezierUpPath closePath];

    if (_innerDecorationStyle == INNERDECORATION_BLACK_GREY)
    {
        // fill with black color
        [fillColor1 setFill];
        [bezierUpPath fill];
        
        // fill with grey color
        [fillColor2 setFill];
        [bezierLowPath fill];
    }else if (_innerDecorationStyle == INNERDECORATION_WHITE_BLACK)
    {
        // fill with white color
        [fillColor3 setFill];
        [bezierUpPath fill];
        
        // fill with black color
        [fillColor1 setFill];
        [bezierLowPath fill];
    }
}

// end of painting decoration  rings
///////////////////////////////////////////////////////
@end
