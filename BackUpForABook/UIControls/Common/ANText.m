//
//  ANText.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/27/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "ANText.h"
#import <CoreText/CoreText.h>

@implementation ANText

-(id)initWithFont:(NSString*)font
             size:(float)size
           shadow:(BOOL)shadow
        underline:(BOOL)underline
{
    self = [super init];
    
    _show = TRUE;
    _textAttrDictionary = [NSMutableDictionary dictionary];
    [self setTextFont:font size:size];
    _text = [NSMutableString stringWithString:@""];
    _shadow = shadow;
    
    [self setDefualtFont0:underline];
    
    return self;
}

-(void)setDefualtFont0:(BOOL)underline;
{
    [self setTextFillColor:[UIColor darkTextColor]];
    [self setTextStrokeColor:[UIColor grayColor]];
    [self setTextStrokeWidth:-3.0];
    if (underline)
    {
        [self setTextUnderlineStyle:2];
    }
    
    _blurColor = [UIColor grayColor];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(.0f, 3.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 3.0f;
}

-(void)setDefualtFont1:(BOOL)underline;
{
    [self setTextFillColor:[UIColor darkTextColor]];
    [self setTextStrokeColor:[UIColor grayColor]];
    [self setTextStrokeWidth:-3.0];
    [self setTextUnderlineStyle:2];
    
    _blurColor = [UIColor grayColor];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(.0f, 3.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 3.0f;
}

-(void)setDefualtFont2:(BOOL)underline;
{
    [self setTextFillColor:[UIColor darkTextColor]];
    [self setTextStrokeColor:[UIColor darkTextColor]];
    [self setTextStrokeWidth:-2.0];
    if (underline)
    {
        [self setTextUnderlineStyle:2];
    }
    
    _blurColor = [UIColor grayColor];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(.0f, 3.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 3.0f;
}

-(void)setTextFont:(NSString*)font
              size:(float)size
{
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName((CFStringRef)font, size, NULL);
    _textAttrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
}

// text - fill color
-(void)setTextFillColor:(UIColor *)textFillColor
{
    _textAttrDictionary[NSForegroundColorAttributeName] =  (id)[textFillColor CGColor];
}
// name - stroke color
-(void)setTextStrokeColor:(UIColor *)textStrokeColor
{
    _textAttrDictionary[NSStrokeColorAttributeName] = (id)[textStrokeColor CGColor];
}
// name - stroke width
-(void)setTextStrokeWidth:(float)textStrokeWidth
{
    _textAttrDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:textStrokeWidth];
}
// name - underline style
-(void)setTextUnderlineStyle:(int)textStyle
{
    _textAttrDictionary[NSUnderlineStyleAttributeName] = (id)[NSNumber numberWithInt:textStyle];
}

// return attributed string of combined name and text
-(NSMutableAttributedString*)attributedText
{
    // sttributed string with name attributes
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_text attributes:_textAttrDictionary];
    
    return attString;
}

// paint
-(void)paint:(CGContextRef)ctx
        rect:(CGRect)rect
attributedText:(NSMutableAttributedString*)attributedText
{
    if (_show == false || _text == nil || _text.length <= 0)
    {
        return ;
    }
    
    // draw text inside rect
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedText);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attributedText length]), path, NULL);
    
    CGContextSaveGState(ctx);
    
    if (_blurRadius > .0 && _shadow)
    {
        CGContextSetShadowWithColor(ctx, _blurSize, _blurRadius, _blurColor.CGColor);
    }
    
    // paint the label
    CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0f, -1.0f));
    
    CTFrameDraw(frame, ctx);
    
    CGContextRestoreGState(ctx);
    
    // release the objects
    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(path);
}

-(void)paint:(CGContextRef)ctx
        rect:(CGRect)rect
{
    [self paint:ctx rect:rect attributedText:[self attributedText]];
}

@end
