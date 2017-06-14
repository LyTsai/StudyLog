//
//  TRLabel.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRLabel.h"

@interface TRLabel (PrivateMethods)

// for test purpose
-(void)setDefaultLabelStyle1;

-(void)setDefaultLabelStyle2;

-(void)setDefaultLabelStyle3;

-(void)setDefaultLabelStyle4;

-(void)setDefaultLabelStyle5;

-(void)setDefaultLabelStyle6;

@end

@implementation TRLabel

// methods
-(id)init
{
    self = [super init];
    
    // intial object values
    _attrDictionary = [NSMutableDictionary dictionary];
    _attrRemainderDictionary = [NSMutableDictionary dictionary];
 
    _fontSizeLarge = 10.0;
    _fontSizeSmall = 8.0;
    _fontSize_Remainder = 8.0;
    
    _maxNumberOfFullSizeLetters = 28;
    
    //[self setDefaultLabelStyle1];
    //[self setDefaultLabelStyle2];
    //[self setDefaultLabelStyle3];
    //[self setDefaultLabelStyle4];
    
    //[self setDefaultLabelStyle5];
    
    [self setDefaultLabelStyle6];
    
    return self;
}

-(void)setDefaultLabelStyle1
{
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica"), _fontSizeLarge, NULL);
    _attrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _underLine = FALSE;
    // Attributed string properties
    // text area color (fill area)
    _attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor grayColor] CGColor];
    // text edge color (stroking area)
    _attrDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _attrDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
    // Under line
    _attrDictionary[NSUnderlineStyleAttributeName] = (id)[NSNumber numberWithInt:2];
    // end of attributed string properties
    
    // attrRemainderDictionary
    lbFont = CTFontCreateWithName(CFSTR("Helvetica"), _fontSizeSmall, NULL);
    _attrRemainderDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
 
    _attrRemainderDictionary[NSForegroundColorAttributeName] = (id)[[UIColor grayColor] CGColor];
    // text edge color (stroking area)
    _attrRemainderDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _attrRemainderDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
    // end of _attrRemainderDictionary
    
    // shadow color
    _blurColor = [UIColor colorWithRed:128.0/255.0 green: 128.0/255.0 blue:128.0/255.0 alpha:0.5];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(4.0f, 4.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 3.0f;
    
    //
    _blurSize = CGSizeMake(.0f, 3.0f);
    _blurRadius = 5.0;
}

-(void)setDefaultLabelStyle2
{
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica-Bold"), _fontSizeLarge, NULL);
    _attrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _underLine = FALSE;
    // Attributed string properties
    // text area color (fill area)
    _attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor redColor] CGColor];
    // text edge color (stroking area)
    _attrDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _attrDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
    // Under line
    _attrDictionary[NSUnderlineStyleAttributeName] = (id)[NSNumber numberWithInt:1];
    // end of attributed string properties
    
    // attrRemainderDictionary
    lbFont = CTFontCreateWithName(CFSTR("Helvetica"), _fontSizeSmall, NULL);
    _attrRemainderDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _attrRemainderDictionary[NSForegroundColorAttributeName] = (id)[[UIColor grayColor] CGColor];
    // text edge color (stroking area)
    _attrRemainderDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _attrRemainderDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
    // end of _attrRemainderDictionary
    
    // shadow color
    _blurColor = [UIColor colorWithRed:128.0/255.0 green: 128.0/255.0 blue:128.0/255.0 alpha:0.5];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(4.0f, 4.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 3.0f;
    
    //
    _blurSize = CGSizeMake(.0f, 3.0f);
    _blurRadius = 5.0;

}

-(void)setDefaultLabelStyle3
{
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica"), _fontSizeLarge, NULL);
    _attrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _underLine = TRUE;
    // Attributed string properties
    // text area color (fill area)
    _attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:69.0/255.0 green:254.0/255.0 blue:0 alpha:1] CGColor];

    // text edge color (stroking area)
    _attrDictionary[NSStrokeColorAttributeName] = (id)[[UIColor colorWithRed:22.0/255.0 green:145.0/255.0 blue:0 alpha:0.8] CGColor];

    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _attrDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
  
    // end of attributed string properties
    
    // attrRemainderDictionary
    lbFont = CTFontCreateWithName(CFSTR("Helvetica"), _fontSizeSmall, NULL);
    _attrRemainderDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _attrRemainderDictionary[NSForegroundColorAttributeName] = (id)[[UIColor grayColor] CGColor];
    // text edge color (stroking area)
    _attrRemainderDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _attrRemainderDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
    // end of _attrRemainderDictionary
    
    // shadow color
    _blurColor = [UIColor colorWithRed:104.0/255.0 green: 248.0/255.0 blue:0 alpha:0.7];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(4.0f, 4.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 3.0f;
    
    //
    _blurSize = CGSizeMake(.0f, 3.0f);
    _blurRadius = 5.0;
    
}

-(void)setDefaultLabelStyle4
{
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica-Bold"), _fontSizeLarge, NULL);
    _attrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _underLine = TRUE;
    // Attributed string properties
    // text area color (fill area)
    _attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:.0 green: 255.0/255.0 blue: .0 alpha:1] CGColor];
    
    // text edge color (stroking area)
    _attrDictionary[NSStrokeColorAttributeName] = (id)[[UIColor colorWithRed:255.0/255.0 green: .0 blue: .0 alpha:0.8] CGColor];
    
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _attrDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
    // end of attributed string properties
    
    // attrRemainderDictionary
    lbFont = CTFontCreateWithName(CFSTR("Helvetica"), _fontSizeSmall, NULL);
    _attrRemainderDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _attrRemainderDictionary[NSForegroundColorAttributeName] = (id)[[UIColor grayColor] CGColor];
    // text edge color (stroking area)
    _attrRemainderDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the edges
    _attrRemainderDictionary[NSStrokeWidthAttributeName] = (id)[NSNumber numberWithFloat:-3.0];
    // end of _attrRemainderDictionary
    
    // shadow color
    _blurColor = [UIColor colorWithRed:104.0/255.0 green: 248.0/255.0 blue:0 alpha:0.7];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(4.0f, 4.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 3.0f;
    
    //
    _blurSize = CGSizeMake(.0f, 3.0f);
    _blurRadius = 5.0;
    
}

-(void)setDefaultLabelStyle5
{
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica-Bold"), _fontSizeLarge, NULL);
    _attrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _underLine = TRUE;
    // Attributed string properties
    // text area color (fill area)
    //_attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:250.0/255.0 green:.0/255 blue:128.0/255 alpha:0.8] CGColor];
    //_attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:64.0/255.0 green:.64/255 blue:64.0/255 alpha:0.8] CGColor];
    _attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:0.0/255.0 green:128.0/255 blue:250.0/255 alpha:0.8] CGColor];

    // text edge color (stroking area)
    _attrDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // end of attributed string properties
    
    // attrRemainderDictionary
    lbFont = CTFontCreateWithName(CFSTR("Helvetica"), _fontSizeSmall, NULL);
    _attrRemainderDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _attrRemainderDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:250.0/255.0 green:.0/255 blue:128.0/255 alpha:0.3] CGColor];
    // text edge color (stroking area)
    _attrRemainderDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the
    // end of _attrRemainderDictionary
    
    // shadow color
    _blurColor = [UIColor grayColor];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(.0f, 3.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 3.0f;
}

-(void)setDefaultLabelStyle6
{
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica-Bold"), _fontSizeLarge, NULL);
    _attrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _underLine = TRUE;
    // Attributed string properties
    // text area color (fill area)
    _attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:.0/255.0 green:.0/255 blue:.0/255 alpha:.9] CGColor];
    
    // text edge color (stroking area)
    _attrDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // end of attributed string properties
    
    // attrRemainderDictionary
    lbFont = CTFontCreateWithName(CFSTR("Helvetica"), _fontSizeSmall, NULL);
    _attrRemainderDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _attrRemainderDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:.0/255.0 green:.0/255 blue:.0/255 alpha:0.9] CGColor];
    // text edge color (stroking area)
    _attrRemainderDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkGrayColor] CGColor];
    // nagativr value both stroke and fill the text.  Positive value for "hollow" presentation only stroke the
    // end of _attrRemainderDictionary
    
    // shadow color
    _blurColor = [UIColor lightGrayColor];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(.0f, 1.0f);
    // shadow radius.  smaller value leads to less fuzzy shadow
    _blurRadius = 2.0f;
}

// methods
// call to update attributed string to reflect the current font properties
-(void)updateAttributedString
{
    [self setDefaultLabelStyle6];
}

@end
