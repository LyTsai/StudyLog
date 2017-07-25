//
//  ANNamedText.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "ANNamedText.h"
#import <CoreText/CoreText.h>

@implementation ANNamedText

-(id)initWithFont:(NSString*)font
             size:(float)size
           shadow:(BOOL)shadow
        underline:(BOOL)underline
{
    self = [super init];

    _nameAttrDictionary = [NSMutableDictionary dictionary];
    _textAttrDictionary = [NSMutableDictionary dictionary];
    
    [self setNameFont:font size:size];
    [self setTextFont:font size:size];
    
    _name = [NSMutableString stringWithString:@""];
    _text = [NSMutableString stringWithString:@""];
    _shadow = shadow;
  
    [self setDefualtFont0:underline];
    
    return self;
}

-(void)setDefualtFont0:(BOOL)underline;
{
    [self setNameFillColor:[UIColor darkTextColor]];
    [self setNameStrokeColor:[UIColor grayColor]];
    [self setNameStrokeWidth:-3.0];
    if (underline)
    {
        [self setNameUnderlineStyle:2];
    }
    
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
    [self setNameFillColor:[UIColor darkTextColor]];
    [self setNameStrokeColor:[UIColor grayColor]];
    [self setNameStrokeWidth:-3.0];
    [self setNameUnderlineStyle:2];
    
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

-(void)setNameFont:(NSString*)font
              size:(float)size
{
    CTFontRef lbFont = CTFontCreateWithName((CFStringRef)font, size, NULL);
    _nameAttrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
}

-(void)setTextFont:(NSString*)font
              size:(float)size
{
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName((CFStringRef)font, size, NULL);
    _textAttrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);

}

// name - fill color
-(void)setNameFillColor:(UIColor *)nameFillColor
{
    _nameAttrDictionary[NSForegroundColorAttributeName] =  (id)[nameFillColor CGColor];
}
// name - stroke color
-(void)setNameStrokeColor:(UIColor *)nameStrokeColor
{
    _nameAttrDictionary[NSStrokeColorAttributeName] = (id)[nameStrokeColor CGColor];
}
// name - stroke width
-(void)setNameStrokeWidth:(float)nameStrokeWidth
{
    _nameAttrDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:nameStrokeWidth];
}
// name - underline style
-(void)setNameUnderlineStyle:(int)nameStyle
{
    _nameAttrDictionary[NSUnderlineStyleAttributeName] = (id)[NSNumber numberWithInt:nameStyle];
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
-(NSMutableAttributedString*)attributedNameAndText
{
    // create attributed string for drawing
    // string of name and text
    NSString* nameText = [_name stringByAppendingString:_text];
    
    // sttributed string with name attributes
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:nameText attributes:_nameAttrDictionary];
    
    // apply text attribute
    [attString addAttributes:_textAttrDictionary range:NSMakeRange(_name.length, [attString length] - _name.length)];
    
    return attString;
}

@end
