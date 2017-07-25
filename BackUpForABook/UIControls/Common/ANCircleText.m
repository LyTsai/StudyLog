//
//  ANCircleText.m
//  ChordGraph
//
//  Created by Hui Wang on 7/1/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "Define.h"
#import "ANCircleText.h"

@interface ANCircleText (PrivateMethods)

// paint circle text
-(void)drawCircleText:(CGContextRef)ctx
                 text:(NSMutableAttributedString*)text
               radius:(float)radius
                width:(float)width
                 left:(float)left
                right:(float)right
               center:(CGPoint)origin
            clockWise:(BOOL) clockWise;
@end

@implementation ANCircleText

-(id)init
{
    self = [super init];
    _space = 1;
    return self;
}

// method
// radius - position of inner ring edge
// width - size of ring.  radius + size produce the outer ring edge
// left - left angle (in degree)
// right - right angle (in degree)
// origin - ring center
-(void)paintCircleText:(CGContextRef)ctx
                  text:(NSMutableAttributedString*)text
                 style:(RingTextStyle)style
                radius:(float)radius
                 width:(float)width
                  left:(float)left
                 right:(float)right
                center:(CGPoint)origin
{
    // (1) make adjustment on radius depends on style
    if (style & RingTextStyle_AlignBottom)
    {
        radius += ([text size].height - width * .5);
    }else if (style & RingTextStyle_AlignMiddle)
    {
        radius += width * .5;
    }else if (style & RingTextStyle_AlignTop)
    {
        radius += width;
    }
    
    // (2) paint with different RingTextStyle_Ori
    if (style & RingTextStyle_Ori_Left2Right)
    {
        // first half clockwise
        [self drawCircleText:ctx text:text radius:radius width:width left:left right:right center:origin clockWise:((left + right) * .5 < 180.0)];
    }else
    {
        // second half
        [self drawCircleText:ctx text:text radius:radius width:width left:left right:right center:origin clockWise:true];
    }
}
/*
-(void)drawCircleText:(CGContextRef)ctx
                 text:(NSMutableAttributedString*)text
               radius:(float)radius
                width:(float)width
                 left:(float)left
                right:(float)right
               center:(CGPoint)origin
            clockWise:(BOOL) clockWise
{
    // paint the string at center of defined space
    
    // allowed title range in begin and end radians
    float rL = DEGREES_TO_RADIANS(left);
    float rR = DEGREES_TO_RADIANS(right);
    
    
    // (1) setup drawing mode
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    // (2) total size of title string
    CGSize size = [text size];
    CGRect rect;
    
    if (clockWise == TRUE)
    {
        // paint the label in the middel ring position
        radius += size.height *.5;
        
        // (3) go over each letters and draw string letters centered within (left, right)
        // circumference
        
        float circumference = 2 * radius * M_PI;
        // total title length in radian unit
        float rTitleLen = M_PI * 2 / circumference * size.width;
        
        // paint the string one charactor at a time starting from the "left" most position
        float aChar = (rL + rR) * .5 + rTitleLen * .5;
        
        for (NSInteger charIdx = 0; charIdx < text.length; charIdx++)
        {
            // one charactor at a time
            NSRange range = NSMakeRange(charIdx, 1);
            NSAttributedString *oneCharString = [text attributedSubstringFromRange:range];
            
            // calculate character drawing point. center of charactor
            CGPoint charPoint = CGPointMake(radius * cos(-aChar) + origin.x, origin.y + radius * sin(-aChar));
            
            // save the current context and do the character rotation magic.
            CGContextSaveGState(ctx);
            
            CGContextTranslateCTM(ctx, charPoint.x, charPoint.y);
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(M_PI_2 - aChar);
            CGContextConcatCTM(ctx, textTransform);
            CGContextTranslateCTM(ctx, -charPoint.x, -charPoint.y);
            
            // draw the character
            [oneCharString drawAtPoint:charPoint];
            
            // restore context to make sure the rotation is only applied to this character.
            CGContextRestoreGState(ctx);
            
            // starting angle for next charactor
            aChar -= M_PI * 2 / circumference * (oneCharString.size.width + _space);
        }
    }else
    {
        // paint the label in the middel ring position
        radius -= size.height *.5;
        
        // (3) go over each letters and draw string letters centered within (left, right)
        // circumference
        
        float circumference = 2 * radius * M_PI;
        // total title length in radian unit
        float rTitleLen = M_PI * 2 / circumference * size.width;
        
        // paint the string one charactor at a time starting from the "right" most position
        float aChar = (rL + rR) * .5 - rTitleLen * .5;
        
        for (NSInteger charIdx = 0; charIdx < text.length; charIdx++)
        {
            // one charactor at a time
            NSRange range = NSMakeRange(charIdx, 1);
            NSAttributedString *oneCharString = [text attributedSubstringFromRange:range];
            
            // calculate character drawing point. center of charactor
            CGPoint charPoint = CGPointMake(radius * cos(-aChar) + origin.x, origin.y + radius * sin(-aChar));
            
            // save the current context and do the character rotation magic.
            CGContextSaveGState(ctx);
            
            CGContextTranslateCTM(ctx, charPoint.x, charPoint.y);
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(-M_PI_2 - aChar);
            CGContextConcatCTM(ctx, textTransform);
            CGContextTranslateCTM(ctx, -charPoint.x, -charPoint.y);
            // draw the character
            [oneCharString drawAtPoint:charPoint];
            
            // restore context to make sure the rotation is only applied to this character.
            CGContextRestoreGState(ctx);
            
            // starting angle for next charactor
            aChar += M_PI * 2 / circumference * (oneCharString.size.width + _space);
        }
    }

    return ;
}
*/
-(void)drawCircleText:(CGContextRef)ctx
                 text:(NSMutableAttributedString*)text
               radius:(float)radius
                width:(float)width
                 left:(float)left
                right:(float)right
               center:(CGPoint)origin
            clockWise:(BOOL) clockWise
{
    // paint the string at center of defined space
    
    // allowed title range in begin and end radians
    float rL = DEGREES_TO_RADIANS(left);
    float rR = DEGREES_TO_RADIANS(right);
    
    
    // (1) setup drawing mode
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    // (2) total size of title string
    CGSize size = [text size];
    CGRect rect;
    
    if (clockWise == TRUE)
    {
        // paint the label in the middel ring position
        radius += size.height *.5;
        
        // (3) go over each letters and draw string letters centered within (left, right)
        // circumference
        
        float circumference = 2 * radius * M_PI;
        // total title length in radian unit
        float rTitleLen = M_PI * 2 / circumference * size.width;
        
        // paint the string one charactor at a time starting from the "left" most position
        float aChar = (rL + rR) * .5 + rTitleLen * .5;
        
        for (NSInteger charIdx = 0; charIdx < text.length; charIdx++)
        {
            // one charactor at a time
            NSRange range = NSMakeRange(charIdx, 1);
            NSAttributedString *oneCharString = [text attributedSubstringFromRange:range];
            
            // calculate character drawing point. center of charactor
            CGPoint charPoint = CGPointMake(radius * cos(-aChar) + origin.x, origin.y + radius * sin(-aChar));
            
            // save the current context and do the character rotation magic.
            CGContextSaveGState(ctx);
   
            CGContextTranslateCTM(ctx, charPoint.x, charPoint.y);
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(M_PI_2 - aChar);
            CGContextConcatCTM(ctx, textTransform);
            CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0f, -1.0f));
            CGContextTranslateCTM(ctx, -charPoint.x, -charPoint.y);
  
            rect.origin = charPoint;
            rect.origin.y += .5 * size.height;
            rect.size.height = size.height + 2;
            rect.size.width = size.width;
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, rect);
            
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)oneCharString);
            CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [oneCharString length]), path, NULL);
            
            // paint the label
            CTFrameDraw(frame, ctx);
            
            // release the objects
            CFRelease(frame);
            CFRelease(framesetter);
            CFRelease(path);
            
            // restore context to make sure the rotation is only applied to this character.
            CGContextRestoreGState(ctx);
            
            // starting angle for next charactor
            aChar -= M_PI * 2 / circumference * (oneCharString.size.width + _space);
        }
    }else
    {
        // paint the label in the middel ring position
        radius -= size.height *.5;
        
        // (3) go over each letters and draw string letters centered within (left, right)
        // circumference
        
        float circumference = 2 * radius * M_PI;
        // total title length in radian unit
        float rTitleLen = M_PI * 2 / circumference * size.width;
        
        // paint the string one charactor at a time starting from the "right" most position
        float aChar = (rL + rR) * .5 - rTitleLen * .5;
        
        for (NSInteger charIdx = 0; charIdx < text.length; charIdx++)
        {
            // one charactor at a time
            NSRange range = NSMakeRange(charIdx, 1);
            NSAttributedString *oneCharString = [text attributedSubstringFromRange:range];
            
            // calculate character drawing point. center of charactor
            CGPoint charPoint = CGPointMake(radius * cos(-aChar) + origin.x, origin.y + radius * sin(-aChar));
            
            // save the current context and do the character rotation magic.
            CGContextSaveGState(ctx);
            
            CGContextTranslateCTM(ctx, charPoint.x, charPoint.y);
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(-M_PI_2 - aChar);
            CGContextConcatCTM(ctx, textTransform);
            CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0f, -1.0f));
            CGContextTranslateCTM(ctx, -charPoint.x, -charPoint.y);
   
            rect.origin = charPoint;
            rect.origin.y += .5 * size.height;
            rect.size.height = size.height + 2;
            rect.size.width = size.width;
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, rect);
            
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)oneCharString);
            CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [oneCharString length]), path, NULL);
            
            // paint the label
            CTFrameDraw(frame, ctx);
            
            // release the objects
            CFRelease(frame);
            CFRelease(framesetter);
            CFRelease(path);

            // restore context to make sure the rotation is only applied to this character.
            CGContextRestoreGState(ctx);
            
            // starting angle for next charactor
            aChar += M_PI * 2 / circumference * (oneCharString.size.width + _space);
        }
    }
    
    return ;
}


@end
