//
//  CDTitleRing.m
//  ChordGraph
//
//  Created by Hui Wang on 6/28/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "Define.h"
#import "CDTitleRing.h"
#import <CoreText/CoreText.h>

@interface CDTitleRing (PrivateMethods)

// paint slice title
-(void)paintSliceTitle:(CGContextRef)ctx
                 title:(NSMutableString*)title
                radius:(float)radius
                  left:(float)left
                 right:(float)right
                center:(CGPoint)origin
           frameHeight:(int)height;

@end

@implementation CDTitleRing

// private data
float _runtimeSize_title;

// init
-(id)init
{
    self = [super init];
    
    textPainter = [[ANCircleText alloc] init];
    
    _size = 18;
    _textAttributes = [NSMutableDictionary dictionary];
    _style = RingTextStyle_Ori_Left2Right | RingTextStyle_AlignMiddle;
    
    // set inital attributes
    CTFontRef lbFont = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 12.0, NULL);
    _textAttributes[NSFontAttributeName] = (__bridge id)lbFont;
    CFRelease(lbFont);
    
    // run time data
    _runtimeSize_title = 1;
    
    return self;
}

// here is your chance to compute the run time size
-(void)translateChildernFontSize:(float)pointsPerFontSize
{
    _runtimeSize_title = _size * pointsPerFontSize;
}

// get run time size
-(float)runtimeSize
{
    return _runtimeSize_title;
}

-(void)paint:(CGContextRef)ctx
  archorRing:(CDRing*)archor
      radius:(float)radius
      center:(CGPoint)origin
 frameHeight:(int)height
{
    // go over all slices and paint the title labels
    int i;
    for (i = 0; i < [archor numberOfSlices]; i++)
    {
        CDRingSlice *oneSlice = [archor getSlice:i];
        
        if (oneSlice == nil)
        {
            return ;
        }
        
        // draw title string in the center of given range
        [self paintSliceTitle:ctx title:oneSlice.label radius:radius left:oneSlice.left right:oneSlice.right center:origin frameHeight:height];
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
    if (title == nil)
    {
        // no title to print for
        return ;
    }
    
    // make attributed string for the title first
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:title attributes:_textAttributes];
    
    [textPainter paintCircleText:ctx text:attString style:_style radius:radius width:[self runtimeSize] left:left right:right center:origin];
    
    return ;
}

// hit test
-(HitCDObj)hitTest:(CGPoint)atPoint
        archorRing:(CDRing*)archor
            radius:(float)radius
            center:(CGPoint)origin
{
    HitCDObj hitObj;
    
    hitObj.hitObject = CDObjs_None;
    float width = [self runtimeSize];
    float left, right, r1, r2, alen;
    
    // convert atPoint to position in (angle, radius) coordinate position first
    CGFloat r = hypotf(atPoint.x - origin.x, atPoint.y - origin.y);
    float a = 180.0 * atan(-(atPoint.y - origin.y) / (atPoint.x - origin.x)) / 3.14;
    
    if ((atPoint.x - origin.x) < 0)
    {
        a += 180;
    }
    
    if (a < .0)
    {
        a += 360.0;
    }

    // go over all slices and paint the title labels
    int i;
    bool within = false;
    for (i = 0; i < [archor numberOfSlices]; i++)
    {
        CDRingSlice *oneSlice = [archor getSlice:i];
        
        if (oneSlice == nil)
        {
            return hitObj;
        }
        
        // hit test on this one
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:oneSlice.label attributes:_textAttributes];
        
        // label range: radius, aLeft and aRight
        if (_style & RingTextStyle_AlignBottom)
        {
            r1 = radius + ([text size].height - width * .5);
        }else if (_style & RingTextStyle_AlignMiddle)
        {
            r1 = radius + width * .5;
        }else if (_style & RingTextStyle_AlignTop)
        {
            r1 = radius + width;
        }else
        {
            r1 = radius;
        }
        
        r2 = r1;
        
        r1 -= [text size].height * .5;
        r2 += [text size].height * .5;
        
        // left and right angle range
        alen = [text size].width * 180.0 / (M_PI * radius);
        
        left = (oneSlice.left + oneSlice.right) * .5 + alen * .5;
        right = left - alen;
        
        within = (a >= right && a <= left) || ((a + 360) >= right && (a + 360) <= left);
        if (r >= r1 && r <= r2 && within)
        {
            hitObj.hitObject = CDObjs_Title;
            hitObj.sliceIndex = i;
            return hitObj;
        }
    }
    
    return hitObj;
}

@end
