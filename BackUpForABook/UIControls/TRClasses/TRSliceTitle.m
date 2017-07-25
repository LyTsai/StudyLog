//
//  TRSliceTitle.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/16/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRSliceTitle.h"
#import <CoreText/CoreText.h>

@interface TRSliceTitle (PrivateMethods)

// paint slice title
-(void)paintSliceTitle:(CGContextRef)ctx
                 title:(NSMutableString*)title
                radius:(float)radius
                  left:(float)left
                 right:(float)right
                center:(CGPoint)origin
           frameHeight:(int)height;

@end

@implementation TRSliceTitle

// private data

// init
-(id)init
{
    self = [super init];
    
    textPainter = [[ANCircleText alloc] init];
    
    _title = nil;
    
    _size = 18;
    _textAttributes = [NSMutableDictionary dictionary];
    _style = RingTextStyle_Ori_Left2Right | RingTextStyle_AlignMiddle;
    
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 10.0, NULL);
    
    _textAttributes[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);

    // text area color (fill area)
    _textAttributes[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:.0 green:.0 blue: .0 alpha:.4] CGColor];

    // text edge color (stroking area)
    _textAttributes[NSStrokeColorAttributeName] = (id)[[UIColor colorWithRed:.0 green:.8 blue:.0 alpha:0.4] CGColor];

    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _textAttributes[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
    // end of attributed string properties

    // run time data
    _pointsPerFontSize = 1.0;
    
    return self;
}

// method to setup string attributes
-(void)setStringAttributes:(NSString*)font
                      size:(float)size
           foregroundColor:(UIColor*)foregroundColor
               strokeColor:(UIColor*)strokeColor
               strokeWidth:(float)strokeWidth
{
    // font
    CTFontRef lbFont = CTFontCreateWithName((CFStringRef)font, size, NULL);
    
    _textAttributes[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    // text area color (fill area)
    _textAttributes[NSForegroundColorAttributeName] = (id)[foregroundColor CGColor];
    
    // text edge color (stroking area)
    _textAttributes[NSStrokeColorAttributeName] = (id)[strokeColor CGColor];
    
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _textAttributes[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:strokeWidth];
    // end of attributed string properties
}

-(void)paint:(CGContextRef)ctx
      radius:(float)radius
        left:(float)left
       right:(float)right
      center:(CGPoint)origin
 frameHeight:(int)height
{
    if (_title != nil)
    {
        // draw title string in the center of given range
        [self paintSliceTitle:ctx title:_title radius:radius left:left right:right center:origin frameHeight:height];
    }
}

// paint title at given position
-(void)paintSliceTitle:(CGContextRef)ctx
                 title:(NSMutableString*)title
                radius:(float)radius
                  left:(float)left
                 right:(float)right
                center:(CGPoint)origin
           frameHeight:(int)height
{
    // make attributed string for the title first
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:title attributes:_textAttributes];
    
    [textPainter paintCircleText:ctx text:attString style:_style radius:radius width: _size * _pointsPerFontSize left:left right:right center:origin];
    
    return ;
}

// hit test.  Potential hit objects: slider, begin arrow and end arrow
-(HitObj)HitTest:(CGPoint)atPoint
          radius:(float)radius
          center:(CGPoint)origin
{
    HitObj hitObj;
    
    hitObj.hitObject = TRObjs_None;
    
    return hitObj;
}

@end
