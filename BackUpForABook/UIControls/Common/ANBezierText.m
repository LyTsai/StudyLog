//
//  ANBezierText.m
//  ChordGraph
//
//  Created by Hui Wang on 7/5/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "ANBezierText.h" 
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface ANBezierText (PrivateMethods)

// private method
-(void)createTestAttributedString;

@end

@implementation ANBezierText

// private data
BezierType _type;
CGPoint _p0;
CGPoint _p1;
CGPoint _p2;
CGPoint _p3;

// test data
NSAttributedString *_textString;

-(id)init
{
    self = [super init];
    _type = BezierType_Quad;
    _alignment = CurveTextAlignment_Center;
    
    // test string
    [self createTestAttributedString];
    
    return self;
}

-(void)createTestAttributedString
{
    // test
    CTFontRef baseFont, boldFont, bigFont;
    
    CFStringRef string = CFSTR
    (
     "a liberal education is an education to free the mind from "
     "ligatures, bold, color, and big text."
     );
    
    // Create the mutable attributed string
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(NULL, 0);
    CFAttributedStringReplaceString(attrString,
                                    CFRangeMake(0, 0),
                                    string);
    
    // Set the base font
    baseFont = CTFontCreateUIFontForLanguage(kCTFontUserFontType,
                                             10.0,
                                             NULL);
    CFIndex length = CFStringGetLength(string);
    CFAttributedStringSetAttribute(attrString,
                                   CFRangeMake(0, length),
                                   kCTFontAttributeName,
                                   baseFont);
    
    // Apply bold by finding the bold version of the current font.
    boldFont = CTFontCreateCopyWithSymbolicTraits(baseFont,
                                                  0,
                                                  NULL,
                                                  kCTFontBoldTrait,
                                                  kCTFontBoldTrait);
    CFAttributedStringSetAttribute(attrString,
                                   CFStringFind(string,
                                                CFSTR("bold"),
                                                0),
                                   kCTFontAttributeName,
                                   boldFont);
    
    // Apply color
    CGColorRef color = [[UIColor redColor] CGColor];
    CFAttributedStringSetAttribute(attrString,
                                   CFStringFind(string,
                                                CFSTR("color"),
                                                0),
                                   kCTForegroundColorAttributeName,
                                   color);
    
    // Apply big text
    bigFont = CTFontCreateUIFontForLanguage(kCTFontUserFontType,
                                            36.0,
                                            NULL);
    CFAttributedStringSetAttribute(attrString,
                                   CFStringFind(string,
                                                CFSTR("big text"),
                                                0),
                                   kCTFontAttributeName,
                                   bigFont);
    
    _textString = (__bridge_transfer id)attrString;
    
    CFRelease(baseFont);
    CFRelease(boldFont);
    CFRelease(bigFont);
    
    return ;
}

// private functions
static double CubicBezier(double t, double p0, double p1, double p2,
                     double p3)
{
    return
    pow(1-t, 3) *     p0
    + 3 *         pow(1-t, 2) * t * p1
    + 3 * (1-t) * pow(t,   2) *     p2
    +             pow(t,   3) *     p3;
}

static double CubicBezierPrime(double t, double p0, double p1,
                               double p2, double p3)
{
    return
    -  3 * pow(1-t, 2) * p0
    + (3 * pow(1-t, 2) * p1) - (6 * t * (1-t) * p1)
    - (3 * pow(t,   2) * p2) + (6 * t * (1-t) * p2)
    +  3 * pow(t,   2) * p3;
}

- (CGPoint)CubicBezierPointForOffset:(double)t
{
    double x = CubicBezier(t, _p0.x, _p1.x, _p2.x, _p3.x);
    double y = CubicBezier(t, _p0.y, _p1.y, _p2.y, _p3.y);
    return CGPointMake(x, y);
}

- (double)CubicBezierAngleForOffset:(double)t
{
    double dx = CubicBezierPrime(t, _p0.x, _p1.x, _p2.x, _p3.x);
    double dy = CubicBezierPrime(t, _p0.y, _p1.y, _p2.y, _p3.y);
    return atan2(dy, dx);
}

// quadratic curve: P(t) = (1−t)2P0 +2t(1−t)P1 +t2P2
static double QuadBezier(double t, double p0, double p1, double p2)
{
    return
    pow(1-t, 2) *     p0
    + 2 * t * (1 - t) * p1
    + pow(t, 2) * p2;
}

static double QuadBezierPrime(double t, double p0, double p1, double p2)
{
    return
    - 2 * (1.0 - t) * p0
    + (2.0 - 4.0 * t) * p1
    + 2.0 * t * p2;
}

- (CGPoint)QuadBezierPointForOffset:(double)t
{
    double x = QuadBezier(t, _p0.x, _p1.x, _p2.x);
    double y = QuadBezier(t, _p0.y, _p1.y, _p2.y);
    return CGPointMake(x, y);
}

- (double)QuadAngleForOffset:(double)t
{
    double dx = QuadBezierPrime(t, _p0.x, _p1.x, _p2.x);
    double dy = QuadBezierPrime(t, _p0.y, _p1.y, _p2.y);
    return atan2(dy, dx);
}

- (CGPoint)pointForOffset:(double)t
{
    if (_type == BezierType_Quad)
    {
        return [self QuadBezierPointForOffset:t];
    }else
    {
        return [self CubicBezierPointForOffset:t];
    }
}

- (double)angleForOffset:(double)t
{
    if (_type == BezierType_Quad)
    {
        return [self QuadAngleForOffset:t];
    }else
    {
        return [self CubicBezierAngleForOffset:t];
    }
}

static double Distance(CGPoint a, CGPoint b)
{
    CGFloat dx = a.x - b.x;
    CGFloat dy = a.y - b.y;
    return hypot(dx, dy);
}

// Simplistic routine to find the offset along Bezier that is
// aDistance away from aPoint. anOffset is the offset used to
// generate aPoint, and saves us the trouble of recalculating it
// This routine just walks forward until it finds a point at least
// aDistance away. Good optimizations here would reduce the number
// of guesses, but this is tricky since if we go too far out, the
// curve might loop back on leading to incorrect results. Tuning
// kStep is good start.
- (double)offsetAtDistance:(double)aDistance
                 fromPoint:(CGPoint)aPoint
                    offset:(double)anOffset
{
    const double kStep = 0.001; // 0.0001 - 0.001 work well
    double newDistance = 0;
    double newOffset = anOffset + kStep;
    while (newDistance <= aDistance && newOffset < 1.0) {
        newOffset += kStep;
        newDistance = Distance(aPoint,
                               [self pointForOffset:newOffset]);
    }
    return newOffset;
}

- (void)prepareContext:(CGContextRef)context
                forRun:(CTRunRef)run
{
    CFDictionaryRef attributes = CTRunGetAttributes(run);
    
    // Set font
    CTFontRef runFont = CFDictionaryGetValue(attributes,
                                             kCTFontAttributeName);
    CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
    CGContextSetFont(context, cgFont);
    CGContextSetFontSize(context, CTFontGetSize(runFont));
    CFRelease(cgFont);
    
    // Set color
    CGColorRef color = (CGColorRef)CFDictionaryGetValue(attributes,
                                                        kCTForegroundColorAttributeName);
    CGContextSetFillColorWithColor(context, color);
}

- (NSMutableData *)glyphDataForRun:(CTRunRef)run
{
    NSMutableData *data;
    CFIndex glyphsCount = CTRunGetGlyphCount(run);
    const CGGlyph *glyphs = CTRunGetGlyphsPtr(run);
    size_t dataLength = glyphsCount * sizeof(*glyphs);
    if (glyphs) {
        data = [NSMutableData dataWithBytesNoCopy:(void*)glyphs
                                           length:dataLength freeWhenDone:NO];
    }
    else {
        data = [NSMutableData dataWithLength:dataLength];
        CTRunGetGlyphs(run, CFRangeMake(0, 0), data.mutableBytes);
    }
    return data;
}

- (NSMutableData *)advanceDataForRun:(CTRunRef)run
{
    NSMutableData *data;
    CFIndex glyphsCount = CTRunGetGlyphCount(run);
    const CGSize *advances = CTRunGetAdvancesPtr(run);
    size_t dataLength = glyphsCount * sizeof(*advances);
    if (advances) {
        data = [NSMutableData dataWithBytesNoCopy:(void*)advances
                                           length:dataLength
                                     freeWhenDone:NO];
    }
    else {
        data = [NSMutableData dataWithLength:dataLength];
        CTRunGetAdvances(run, CFRangeMake(0, 0), data.mutableBytes);
    }
    return data;
}

- (void)drawText:(CGContextRef)ctx
attributedString:(NSAttributedString*)attributedString
{
    if ([attributedString length] == 0)
    {
        return;
    }
    
    // Initialize the text matrix (transform). This isn't reset
    // automatically, so it might be in any state.
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
 
    // Create a typeset line object
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)attributedString);
    
    // The offset is where you are in the curve, from [0, 1]
    double offset = 0.;
    if (_alignment == CurveTextAlignment_Left)
    {
        offset = .0;
    }else if (_alignment == CurveTextAlignment_Right)
    {
        offset = 1.0 - [self offsetAtDistance:attributedString.size.width
                              fromPoint:[self pointForOffset:offset] offset:offset];
        
    }else if (_alignment == CurveTextAlignment_Center)
    {
        offset = .5 - .5 * [self offsetAtDistance:attributedString.size.width
                          fromPoint:[self pointForOffset:offset] offset:offset];
    }
    
    // Fetch the runs and process one at a time
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runs);
    
    for (CFIndex runIndex = 0; runIndex < runCount; ++runIndex)
    {
        CTRunRef run = CFArrayGetValueAtIndex(runs, runIndex);
        
        // Apply the attributes from the run to the current context
        [self prepareContext:ctx forRun:run];
        
        // Fetch the glyphs as a CGGlyph* array
        NSMutableData *glyphsData = [self glyphDataForRun:run];
        CGGlyph *glyphs = [glyphsData mutableBytes];
        
        // Fetch the advances as a CGSize* array. An advance is the
        // distance from one glyph to another.
        NSMutableData *advancesData = [self advanceDataForRun:run];
        CGSize *advances = [advancesData mutableBytes];
        
        // Loop through the glyphs and display them
        CFIndex glyphCount = CTRunGetGlyphCount(run);
        for (CFIndex glyphIndex = 0;
             glyphIndex < glyphCount && offset < 1.0;
             ++glyphIndex)
        {
            
            // You're going to modify the transform, so save the state
            CGContextSaveGState(ctx);
            
            // Calculate the location and angle. This could be any
            // function, but here you use a Bezier curve for specified Bezier type
            CGPoint glyphPoint = [self pointForOffset:offset];
            double angle = [self angleForOffset:offset];
            
            // Rotate the context
            CGContextRotateCTM(ctx, angle);
            
            // Translate the context after accounting for rotation
            CGPoint translatedPoint = CGPointApplyAffineTransform(glyphPoint,
                                                          CGAffineTransformMakeRotation(-angle));
            CGContextTranslateCTM(ctx,
                                  translatedPoint.x,
                                  translatedPoint.y);
            
            // Draw the glyph
            CGPoint pt0 = CGPointMake(.0, .0);
            CGContextShowGlyphsAtPositions(ctx, &glyphs[glyphIndex], &pt0, 1);

            // Move along the curve in proportion to the advance.
            offset = [self offsetAtDistance:advances[glyphIndex].width
                                  fromPoint:glyphPoint offset:offset];
            
            CGContextRestoreGState(ctx);
        }
    }
    
    CFRelease(line);
}

// public functions
-(void)paintTextOnCubicBezier:(CGContextRef)ctx
                         text:(NSAttributedString*)text
                           p0:(CGPoint)p0
                           p1:(CGPoint)p1
                           p2:(CGPoint)p2
                           p3:(CGPoint)p3
                  frameHeight:(int)height
{
    // save current context
    CGContextSaveGState(ctx);
    
    // flip y direction to have right contest for drawing the text
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
 
    _type = BezierType_Cubic;
    _p0 = p0;
    _p1 = p1;
    _p2 = p2;
    _p3 = p3;
    
    [self drawText:ctx attributedString:text];
  
    // restore the original contest
    CGContextRestoreGState(ctx);
    return ;
}

// text along quadratic bezie curve
-(void)paintTextOnQuadBezier:(CGContextRef)ctx
                        text:(NSAttributedString*)text
                          p0:(CGPoint)p0
                          p1:(CGPoint)p1
                          p2:(CGPoint)p2
                 frameHeight:(int)height
{
    // save current context
    CGContextSaveGState(ctx);
    
    // flip y direction to have right contest for drawing the text
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    _type = BezierType_Quad;
    _p0 = p0;
    _p1 = p1;
    _p2 = p2;
    
    [self drawText:ctx attributedString:text];
    
    // restore the original contest
    CGContextRestoreGState(ctx);
    return ;
}

@end
