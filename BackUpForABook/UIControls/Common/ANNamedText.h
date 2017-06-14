//
//  ANNamedText.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// name text that has the form of name, text
@interface ANNamedText : NSObject

// name
@property(strong, nonatomic)NSMutableString* name;
// text
@property(strong, nonatomic)NSMutableString* text;

// name drawing attributes
@property(strong, nonatomic)NSMutableDictionary *nameAttrDictionary;
// name - fill color
@property(strong, nonatomic)UIColor* nameFillColor;
// name - stroke color
@property(strong, nonatomic)UIColor* nameStrokeColor;
// name - stroke width
@property(nonatomic)float nameStrokeWidth;
// name - underline style
@property(nonatomic)int nameUnderlineStyle;

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

// methods for setting the text attributes
-(void)setNameFont:(NSString*)font
              size:(float)size;

-(void)setTextFont:(NSString*)font
              size:(float)size;

// return attributed string of combined name and text
-(NSMutableAttributedString*)attributedNameAndText;

@end
