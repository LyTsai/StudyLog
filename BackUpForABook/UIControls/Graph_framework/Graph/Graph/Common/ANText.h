//
//  ANText.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/27/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// attributed text with shadow
@interface ANText : NSObject

// show or hide
@property(nonatomic)bool show;

// text
@property(strong, nonatomic)NSMutableString* text;
// text drawing attributes
@property(strong, nonatomic)NSMutableDictionary *textAttrDictionary;
// text - fill color
@property(strong, nonatomic)UIColor* textFillColor;
// text - stroke color
@property(strong, nonatomic)UIColor* textStrokeColor;
// text - stroke width
@property(nonatomic)float textStrokeWidth;
// text - underline style
@property(nonatomic)int textUnderlineStyle;

// text shadow
@property(nonatomic)BOOL shadow;
// shadow color
@property(strong, nonatomic)UIColor *blurColor;
// shadow style
@property(nonatomic)CGSize blurSize;
@property(nonatomic)float blurRadius;

// init
-(id)initWithFont:(NSString*)font
             size:(float)size
           shadow:(BOOL)shadow
        underline:(BOOL)underline;

-(void)setTextFont:(NSString*)font
              size:(float)size;

// return attributed string of text
-(NSMutableAttributedString*)attributedText;

// paint
-(void)paint:(CGContextRef)ctx
        rect:(CGRect)rect
attributedText:(NSMutableAttributedString*)attributedText;

-(void)paint:(CGContextRef)ctx
        rect:(CGRect)rect;

@end
