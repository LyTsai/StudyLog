//
//  TRLegend.m
//  ATreeRingMap
//
//  Created by hui wang on 12/30/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRLegend.h"
#import <CoreText/CoreText.h>

@implementation TRLegend

-(id)init
{
    self = [super init];
    
    _metricViews = [[NSMutableDictionary alloc] init];
    _metricLabels = [[NSMutableDictionary alloc] init];
    _keys = [[NSMutableArray alloc] initWithCapacity:10];
    
    return self;
}

// add one label field
-(void)addEntry:(NSString*)key
           view:(ANMetricView*)view
          label:(ANText*)label
{
    if (key == nil || label == nil || view == nil)
    {
        return ;
    }
    
    // do we have lable and view collectors?
    if (_metricLabels == nil)
    {
        _metricLabels = [[NSMutableDictionary alloc] init];
    }
    
    if (_metricViews == nil)
    {
        _metricViews = [[NSMutableDictionary alloc] init];
    }
    
    if ([_metricLabels objectForKey:key] != nil &&
        [_metricViews objectForKey:key] != nil)
    {
        // already have one key in both lable and view
        return ;
    }
    
    // add key-label object pair
    [_metricLabels setObject:label forKey:key];
    
    // add key-view object pair
    [_metricViews setObject:view forKey:key];
    
    // make a note of this key
    [_keys addObject:key];
    
    return ;
}

// get view object for the given key
-(ANMetricView*)getView:(NSString*)key
{
    if (_metricViews != nil &&
        [[_metricViews objectForKey:key] isKindOfClass:[ANMetricView class]] != TRUE)
    {
        return nil;
    }
    
    return [_metricViews objectForKey:key];
}

// get label object for the given key
-(ANText*)getLabel:(NSString*)key
{
    if (_metricLabels != nil &&
        [[_metricLabels objectForKey:key] isKindOfClass:[ANText class]] != TRUE)
    {
        return nil;
    }
    
    return [_metricLabels objectForKey:key];
}

// get view object for the given key

// get all keys
-(NSArray*)keys
{
    return _keys;
}

// paint selected labels in the order of keys specified in the array
// ctx - CGContextRef
// orderByKeys - oder to draw legend element
// alignment - way to align the element
// lineSpace - distance between lines
// position - left - top position
// return end position
-(CGPoint)paint:(CGContextRef)ctx
    orderByKeys:(NSArray*)orderByKeys
      alignment:(TRLegendAlignment) alignment
      lineSpace:(float) lineSpace
       position:(CGPoint)position
{
    NSMutableArray* keys = nil;
    
    if (orderByKeys == nil)
    {
        keys = [[NSMutableArray alloc] initWithArray:_keys];
    }else
    {
        keys = [[NSMutableArray alloc] initWithArray:orderByKeys];
    }
    
    if (keys == nil || keys.count <= 0)
    {
        return position;
    }
    
    // alignment
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    if (alignment == TRLegendAlignment_LT || alignment == TRLegendAlignment_LB)
    {
        paragraphStyle.alignment = NSTextAlignmentLeft;
    }else
    {
        paragraphStyle.alignment = NSTextAlignmentRight;
    }
    
    CGContextSaveGState(ctx);
    
    float yOffset = position.y, radius = 12.0;
    
    id key;
    for (key in keys)
    {
        // is key string?
        if ([key isKindOfClass:[NSString class]] != TRUE)
        {
            continue;
        }
        
        // check if we have legend element in the collection for given key
        ANMetricView* metricView = [self getView:key];
        ANText* metricLabel = [self getLabel:key];
        
        if (metricView == nil || metricLabel == nil)
        {
            // moving onto next element
            continue;
        }

        // draw one line:
        
        // (1) text information and drawing rect
        
        // attrinbuted string
        NSMutableAttributedString* attString = metricLabel.attributedText;
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
        
        if (alignment == TRLegendAlignment_RT || alignment == TRLegendAlignment_RB)
        {
            rect.origin.x -= txtSize.width;
        }
        
        if (alignment == TRLegendAlignment_LB || alignment == TRLegendAlignment_RB)
        {
            rect.origin.y -= txtSize.height;
        }
        
        // view
        // (2) !!! To Do, get image from metricView.  For now we will just draw a circle
        CGContextSetFillColorWithColor(ctx, metricView.fillcolor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, metricView.edgecolor.CGColor);
        CGContextSetLineWidth(ctx, 2.0);
        
        radius = txtSize.height / 3.0;
        CGContextFillEllipseInRect(ctx, CGRectMake(rect.origin.x, rect.origin.y - radius, 2 * radius, 2 * radius));
        CGContextStrokeEllipseInRect(ctx, CGRectMake(rect.origin.x, rect.origin.y - radius, 2 * radius, 2 * radius));
        
        rect.origin.x += 4 * radius;

        // (3) draw text inside rect
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rect);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
        
        CGContextSaveGState(ctx);
        
        if (metricLabel.blurRadius > .0 && metricLabel.shadow)
        {
            CGContextSetShadowWithColor(ctx, metricLabel.blurSize, metricLabel.blurRadius, metricLabel.blurColor.CGColor);
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
        if (alignment == TRLegendAlignment_LT || alignment == TRLegendAlignment_RT)
        {
            yOffset += txtSize.height;
        }else
        {
            yOffset -= txtSize.height;
        }
    }
    
    CGContextRestoreGState(ctx);
    
    return CGPointMake(position.x, yOffset);
}

@end
