//
//  TRMLabels.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRMLabels.h"
#import <CoreText/CoreText.h>

@implementation TRMLabels

-(id)init
{
    self = [super init];
    
    _labels = [[NSMutableDictionary alloc] init];
    _keys = [[NSMutableArray alloc] initWithCapacity:10];
    
    return self;
}

// add one label field
-(void)addLabel:(NSString*)key
          label:(ANNamedText*)label
{
    if (key == nil || label == nil)
    {
        return ;
    }
    
    // do we have collector?
    if (_labels == nil)
    {
        _labels = [[NSMutableDictionary alloc] init];
    }
    
    if ([_labels objectForKey:key] != nil)
    {
        // already have one key
        return ;
    }
    
    // add key-label object pair
    [_labels setObject:label forKey:key];
    
    // make a note of this key
    [_keys addObject:key];
    
    return ;
}

// get label object
-(ANNamedText*)getLabel:(NSString*)key
{
    if ([[_labels objectForKey:key] isKindOfClass:[ANNamedText class]] != TRUE)
    {
        return nil;
    }

    return [_labels objectForKey:key];
}

// get all keys
-(NSArray*)keys
{
    return _keys;
}

// paint selected labels in the order of keys specified in the array
// return end position
-(CGPoint)paint:(CGContextRef)ctx
    orderByKeys:(NSArray*)orderByKeys
      alignment:(TRMTextAlignment) alignment
      lineSpace:(float) lineSpace
       position:(CGPoint)position
{
    if (_labels == nil)
    {
        position ;
    }
    
    // alignment
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    if (alignment == TRMTextAlignment_LT || alignment == TRMTextAlignment_LB)
    {
        paragraphStyle.alignment = NSTextAlignmentLeft;
    }else
    {
        paragraphStyle.alignment = NSTextAlignmentRight;
    }
    
    float yOffset = position.y;
    
    id key;
    for (key in orderByKeys)
    {
        // is key string?
        if ([key isKindOfClass:[NSString class]] != TRUE)
        {
            continue;
        }
        
        // get line
        ANNamedText* oneLine = [self getLabel:key];
        if (oneLine == nil)
        {
            continue;
        }
        
        // draw line:
        
        // attrinbuted string
        NSMutableAttributedString* attString = oneLine.attributedNameAndText;
        if (attString == nil)
        {
            continue;
        }
        
        // alignment
        [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attString.length)];
        
        // rect area for drawing text
        CGSize txtSize = [attString size];
        
        // draw the string at rectOrigin position
        CGRect rect = CGRectMake(position.x, yOffset, txtSize.width, txtSize.height + 2);
        
        if (alignment == TRMTextAlignment_RT || alignment == TRMTextAlignment_RB)
        {
            rect.origin.x -= txtSize.width;
        }
        
        if (alignment == TRMTextAlignment_LB || alignment == TRMTextAlignment_RB)
        {
            rect.origin.y -= txtSize.height;
        }
        
        // draw text inside rect
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rect);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
        
        CGContextSaveGState(ctx);

        if (oneLine.blurRadius > .0 && oneLine.shadow)
        {
            CGContextSetShadowWithColor(ctx, oneLine.blurSize, oneLine.blurRadius, oneLine.blurColor.CGColor);
        }
        
        // paint the label
        CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0f, -1.0f));
        
        CTFrameDraw(frame, ctx);
        
        CGContextRestoreGState(ctx);
        
        // release the objects
        CFRelease(frame);
        CFRelease(framesetter);
        CFRelease(path);
        
        // done.  update rectOrigin
        if (alignment == TRMTextAlignment_LT || alignment == TRMTextAlignment_RT)
        {
            yOffset += txtSize.height;
        }else
        {
            yOffset -= txtSize.height;
        }
    }
    
    return CGPointMake(position.x, yOffset);
}

@end
