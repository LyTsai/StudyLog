//
//  CDTip.m
//  ChordGraph
//
//  Created by Hui Wang on 7/4/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDTip.h"
#import <CoreText/CoreText.h>

@implementation CDTip

-(id)init
{
    self = [super init];
    
    _showTip = TRUE;
    _tip = [[NSMutableString alloc] initWithString:@"AnnieLyticx Connectivity matrix"];
    
    _attrDictionary = [NSMutableDictionary dictionary];
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica"), 8.0, NULL);
    _attrDictionary[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    _attrDictionary[NSForegroundColorAttributeName] = (id)[[UIColor colorWithRed:.0/255.0 green:0.0/255.0 blue:128.0/255 alpha:0.6] CGColor];
    // text edge color (stroking area)
    _attrDictionary[NSStrokeColorAttributeName] = (id)[[UIColor darkTextColor] CGColor];
    
    // shadow color
    _blurColor = [UIColor colorWithRed:128.0/255.0 green: 128.0/255.0 blue:128.0/255.0 alpha:0.5];
    // shadow direction.  smaller value cause the shadow closer to the text
    _blurSize = CGSizeMake(.0f, 3.0f);
    _blurRadius = 3.0;

    return self;
}

// paint tip message at the center
-(void)paint:(CGContextRef)ctx
      radius:(float)radius
      center:(CGPoint)origin
 frameHeight:(int)height
{
    
    // need to display tip message?
    if (_showTip == FALSE || _tip == nil)
    {
        return ;
    }
    
    // save current context
    CGContextSaveGState(ctx);
    
    // flip y direction to have right contest for drawing the text
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    // (1) make attributed string
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_tip attributes:_attrDictionary];
    
    //(2) alignment
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 1)];
    
    // (3) attString rrect space at the center
    // limit the string within one half space
    // inner most ring
    float labelSpace;
    
    labelSpace = attString.size.width;
    if (labelSpace > radius)
    {
        labelSpace = radius;
    }
    
    CGPoint tipPosition = CGPointMake(origin.x - .5 * labelSpace, origin.y - .5 * attString.size.height);
    CGRect rect = CGRectMake(tipPosition.x, tipPosition.y, labelSpace, attString.size.height + 2);
    
    // (4) draw at labelPosition
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    if (_blurRadius > .0)
    {
        CGContextSetShadowWithColor(ctx, _blurSize, _blurRadius, _blurColor.CGColor);
    }
    
    // paint the label
    CTFrameDraw(frame, ctx);
    
    // release the objects
    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(path);
    
    CGContextRestoreGState(ctx);
}

@end
