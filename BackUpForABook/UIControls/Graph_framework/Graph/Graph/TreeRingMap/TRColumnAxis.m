//
//  TRColumnAxis.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRColumnAxis.h"

@interface TRColumnAxis (PrivateMethods)

// paint background
-(void)paintBackground:(CGContextRef)ctx
            startAngle:(float)start
              endAngle:(float)end
                radius:(float)radius
               barSize:(float)size
                center:(CGPoint)origin;

// paint title
-(void)paintTitle:(CGContextRef)ctx
           radius:(float)radius
             left:(float)left
            right:(float)right
           center:(CGPoint)origin
      frameHeight:(int)height;

// paint angle resize bar
-(void)paintAngleResizeBar:(CGContextRef)ctx
                startAngle:(float)start
                  endAngle:(float)end
                    radius:(float)radius
                   barSize:(float)size
                    center:(CGPoint)origin;

// paint anglew resize circel bar
-(void)paintAngleResizeCircleBar:(CGContextRef)ctx
                      startAngle:(float)start
                        endAngle:(float)end
                          radius:(float)radius
                         barSize:(float)size
                          center:(CGPoint)origin;

// paint middle slider bar
-(void)paintMiddleSliderBar:(CGContextRef)ctx
                 startAngle:(float)start
                  endAngle:(float)end
                    radius:(float)radius
                   barSize:(float)size
                    center:(CGPoint)origin;

// paint middle slider bar
-(void)paintMiddleBar:(CGContextRef)ctx
                angle:(float)angle
             position:(CGPoint)position;

// paint begin arrow
-(void)paintBeginArrow:(CGContextRef)ctx
                 angle:(float)angle
              position:(CGPoint)position;

// paint end arrow
-(void)paintEndArrow:(CGContextRef)ctx
               angle:(float)angle
            position:(CGPoint)position;

// paint axis tick lables in horizantal direction
-(void)paintTickLabels_0:(CGContextRef)ctx
              startAngle:(float)start
                endAngle:(float)end
                  radius:(float)radius
                 barSize:(float)size
                  center:(CGPoint)origin
             frameHeight:(int)height;

// paint given text label at given rect position
-(void)paintLabel_0:(CGContextRef)ctx
              label:(TRLabel *)label
             string:(NSMutableAttributedString *)attString
        containRect:(CGRect) rect;

// paint axis tick label along radius direction
-(void)paintTickLabels_radius:(CGContextRef)ctx
                   startAngle:(float)start
                     endAngle:(float)end
                       radius:(float)radius
                      barSize:(float)size
                       center:(CGPoint)origin
                  frameHeight:(int)height;
@end

@implementation TRColumnAxis

// dynamic properties.
// average char width and height
int _averageCharWidth;
int _averageCharHeight;

-(id)init
{
    self = [super init];
    
    // axis ring background
    _ring = [[TRSliceRing alloc] init];
    
    // axis title
    _title = [[TRSliceTitle alloc] init];
    
    _ring.size = 26;
    
    self.spaceBetweenAxisAndLable = 12;
    
    // resize arrows
    _beginArrow = [[DSArrow alloc] init];
    _endArrow = [[DSArrow alloc] init];
    
    // resize circle bar
    _circleBar = [[DSCircle alloc] init];
    
    // slider bar
    _showBar = TRUE;
    _slider = [[DSSlider alloc] init];
    // axis lable
    _showTickLabels = TRUE;
    
    // data set for fishy eye effect
    super.eyeRadius = 25;
    super.eyeTicks = 5;
    super.eyePosition = (lastTickValue + firstTickValue) * .5;
    super.fishyEye = TRUE;

    return self;
}

// paint column axis
-(void)paint:(CGContextRef)ctx
  startAngle:(float)start
    endAngle:(float)end
      radius:(float)radius
     barSize:(float)size
      center:(CGPoint)origin
 frameHeight:(int)height
circleBarOnRight:(BOOL)circleBarOnRight
{
    // (1) paint bar background (_ring)
    [self paintBackground:ctx startAngle:start endAngle:end radius:radius barSize:size center:origin];
    
    // (2) paint title
    [self paintTitle:ctx radius:(radius) left:end right:start center:origin frameHeight:height];
    
    // (3) paint resize arrows on the edges
    //float position = radius;
    float position = radius + _ring.outerDecorationRingOffset + _ring.outerDecorationRingSize / 2;
    
    [self paintAngleResizeBar:ctx startAngle:start endAngle:end radius:position barSize:size center:origin];
    
    // (4) paint resize circle on the edge
    if (circleBarOnRight)
    {
        [self paintAngleResizeCircleBarWithHandle:ctx startAngle:start handle_pos:radius radius:position barSize:size center:origin];
    }
    
    // (5) paint middle slider bar
    if (_showBar == TRUE && self.fishEyeNeeded)
    {
        [self paintMiddleSliderBar:ctx startAngle:start endAngle:end radius:radius barSize:size center:origin];
    }
    
    // (6) paint column tick lables
    if (_showTickLabels == TRUE)
    {
        if (self.tickLableDirection == TickLableOrientation_0)
        {
            [self paintTickLabels_0:ctx startAngle:start endAngle:end radius:radius barSize:size center:origin frameHeight:height];
        }else if (self.tickLableDirection == TickLableOrientation_Radius)
        {
            [self paintTickLabels_radius:ctx startAngle:start endAngle:end radius:radius barSize:size center:origin frameHeight:height];
        }
    }
}

-(void)paintBackground:(CGContextRef)ctx
            startAngle:(float)start
              endAngle:(float)end
                radius:(float)radius
               barSize:(float)size
                center:(CGPoint)origin
{
    [_ring paint:ctx startAngle:start endAngle:end radius:radius size:size center:origin];    
    return ;
}

-(void)paintTitle:(CGContextRef)ctx
           radius:(float)radius
             left:(float)left
            right:(float)right
           center:(CGPoint)origin
      frameHeight:(int)height
{
    [_title paint:ctx radius:radius left:left right:right center:origin frameHeight:height];
    return ;
}

// paint angle resize bar
-(void)paintAngleResizeBar:(CGContextRef)ctx
                startAngle:(float)start
                  endAngle:(float)end
                    radius:(float)radius
                   barSize:(float)size
                    center:(CGPoint)origin
{
    float rPosition;
    // edge position: (radius + size), inside: radius, middle: radius + size * .5
    rPosition = radius + size;
    
    CGPoint minEdgeStart = CGPointMake(origin.x + rPosition * cosf(DEGREES_TO_RADIANS(start)), origin.y - rPosition * sinf(DEGREES_TO_RADIANS(start)));
    
    CGPoint maxEdgeEnd = CGPointMake(origin.x + rPosition * cosf(DEGREES_TO_RADIANS(end)), origin.y - rPosition * sinf(DEGREES_TO_RADIANS(end)));
    
    if (_beginArrow.showArrow == TRUE)
    {
        [self paintBeginArrow:ctx angle:start position:minEdgeStart];
    }
    
    if (_endArrow.showArrow == TRUE)
    {
        [self paintEndArrow:ctx angle:end position:maxEdgeEnd];
    }
}

// paint anglew resize circel bar
// radius - circle centaer postion
// size - size of circle
-(void)paintAngleResizeCircleBar:(CGContextRef)ctx
                      startAngle:(float)start
                        endAngle:(float)end
                          radius:(float)radius
                         barSize:(float)size
                          center:(CGPoint)origin
{
    float rPosition = radius + size;
    CGPoint circlePosition = CGPointMake(origin.x + rPosition * cosf(DEGREES_TO_RADIANS(start)), origin.y - rPosition * sinf(DEGREES_TO_RADIANS(start)));
    
    if (_circleBar && _circleBar.show)
    {
        [_circleBar paint:ctx origin:circlePosition];
    }
}

// paint anglew resize circel bar with handle
// radius - circle centaer postion
// size - size of circle
-(void)paintAngleResizeCircleBarWithHandle:(CGContextRef)ctx
                                startAngle:(float)start
                                handle_pos:(float)handle_pos
                                    radius:(float)radius
                                   barSize:(float)size
                                    center:(CGPoint)origin
{
    // circle center
    float rPosition = radius + size;
    // handle starting position
    float rHandlePosition = handle_pos;
    
    CGPoint circlePosition = CGPointMake(origin.x + rPosition * cosf(DEGREES_TO_RADIANS(start)), origin.y - rPosition * sinf(DEGREES_TO_RADIANS(start)));
    
    CGPoint handlePosition = CGPointMake(origin.x + rHandlePosition * cosf(DEGREES_TO_RADIANS(start)), origin.y - rHandlePosition * sinf(DEGREES_TO_RADIANS(start)));
    
    if (_circleBar && _circleBar.show)
    {
        [_circleBar paint:ctx origin:circlePosition handle_pos:handlePosition];
        //[_circleBar paint:ctx origin:circlePosition];
    }
}

// paint middle slider bar
-(void)paintMiddleSliderBar:(CGContextRef)ctx
                 startAngle:(float)start
                   endAngle:(float)end
                     radius:(float)radius
                    barSize:(float)size
                     center:(CGPoint)origin
{
    float rPosition;
    // edge position: (radius + size), inside: radius, middle: radius + size * .5
    rPosition = radius + size;
    
    CGPoint edgeStartPosition = CGPointMake(origin.x + rPosition * cosf(DEGREES_TO_RADIANS(super.eyePosition)), origin.y - rPosition * sinf(DEGREES_TO_RADIANS(super.eyePosition)));
    
    [self paintMiddleBar:ctx angle:super.eyePosition position:edgeStartPosition];
}

// paint middle slider bar
-(void)paintMiddleBar:(CGContextRef)ctx
                angle:(float)angle
             position:(CGPoint)position
{
    float arrowPointDirection = (angle + 90.0);
    
    // save current context
    CGContextSaveGState(ctx);
    
    CGContextTranslateCTM(ctx, position.x, position.y);
    CGContextRotateCTM(ctx, DEGREES_TO_RADIANS(-arrowPointDirection));
    
    // draw the arrow
    [_slider paint:ctx];
    
    // restore the context
    CGContextRestoreGState(ctx);
}

// paint begin arrow
-(void)paintBeginArrow:(CGContextRef)ctx
                 angle:(float)angle
              position:(CGPoint)position
{
    float arrowPointDirection = (angle + 90.0);
    
    // save current context
    CGContextSaveGState(ctx);
    
    CGContextTranslateCTM(ctx, position.x, position.y);
    CGContextRotateCTM(ctx, DEGREES_TO_RADIANS(-arrowPointDirection));
    
    // draw the arrow
    [_beginArrow paint:ctx];
    
    // restore the context
    CGContextRestoreGState(ctx);
}

// paint end arrow
-(void)paintEndArrow:(CGContextRef)ctx
               angle:(float)angle
            position:(CGPoint)position
{
    float arrowPointDirection = (angle - 90.0);
    
    // save current context
    CGContextSaveGState(ctx);
    
    CGContextTranslateCTM(ctx, position.x, position.y);
    CGContextRotateCTM(ctx, DEGREES_TO_RADIANS(-arrowPointDirection));
    
    [_endArrow paint:ctx];
    
    // restore the context
    CGContextRestoreGState(ctx);
}

// paint axis tick lables
-(void)paintTickLabels_0:(CGContextRef)ctx
              startAngle:(float)start
                endAngle:(float)end
                  radius:(float)radius
                 barSize:(float)size
                  center:(CGPoint)origin
             frameHeight:(int)height
{
    int i;
    float rPosition = radius + size;
    float aPosition = start;
    CGPoint labelPosition;
    float labelHeight, lableWidth;
    float deltaAngle = .0, deltaRadius = .0, midlableAngle = .0;
    float labelSpace = .0;
    
    // alignment
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    // save current context
    CGContextSaveGState(ctx);
  
    labelHeight = 40.0;
    lableWidth = 100.0;
    
    // going over all axis tick text
    for (i = 0; i < numberOfTicks; i++)
    {
        // ith TRAxisTick object
        TRAxisTick *tick = [self tick:i];
        
        if (tick == nil)
        {
            continue;
        }
        
        // draw this tick lable at aPosition angle position.
        aPosition = tick.viewOffset;
        
        // create attributed string for drawing
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tick.label.shortString attributes:tick.label.attrDictionary];
        
        // check to see if we have enough space for displaying the label
        // get string label size
        CGRect txtSize = [attString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];
        
        lableWidth = txtSize.size.width;
        labelHeight = txtSize.size.height;
        
        // adjust the label length based on what we have at this position
        labelSpace =  lableWidth;
        
        // average char dispaly size
        if (attString.length > 0)
        {
            _averageCharWidth = txtSize.size.width / attString.length;
        }
        _averageCharHeight = txtSize.size.height;
     
        // done adjusting
        
        // shift the head position by half charactor height
        deltaAngle = 180.0 * labelHeight * cosf(DEGREES_TO_RADIANS(aPosition)) / (2 * 3.14 * rPosition);
        
        // adjust to the mid string position
        midlableAngle = 180 * atan((rPosition * sinf(DEGREES_TO_RADIANS(aPosition))) / (rPosition * cosf(DEGREES_TO_RADIANS(aPosition)) + labelSpace * .5)) / 3.14;
        
        // we need to move the lable along radius direction for the second half (180 - 360 degree) of the cricle
        deltaRadius = tick.viewSpace;
        if (-aPosition > 180.0 || -aPosition < 0.0)
        {
            deltaRadius += labelHeight * sin(DEGREES_TO_RADIANS(aPosition));
        }
        
        // labe head poition
        labelPosition.x = origin.x + (rPosition + deltaRadius) * cosf(DEGREES_TO_RADIANS(aPosition + deltaAngle));
        labelPosition.y = origin.y - (rPosition + deltaRadius)* sinf(DEGREES_TO_RADIANS(aPosition + deltaAngle));
        
        //labelPosition.x += labelSpace * sinf(DEGREES_TO_RADIANS(aPosition));
        
        // if the label is on the left side of the circle we need to align it to the right side
        // shift the label starting postion to the left for the rings on the left side
        if (fabs(aPosition) > 90 && fabs(aPosition) < 270)
        {
            labelPosition.x -= labelSpace;
            paragraphStyle.alignment = NSTextAlignmentRight;
        }else
        {
            paragraphStyle.alignment = NSTextAlignmentLeft;
        }
        
        [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 1)];
        
        CGRect rect = CGRectMake(labelPosition.x, labelPosition.y, labelSpace, labelHeight + 2);
        
        [self paintLabel_0:ctx label:tick.label string:attString containRect:rect];
    }
    
    // restore the context
    CGContextRestoreGState(ctx);
}

// paint given text label at given rect position
// labe - label object that has string and visual drawing information
// rect - the rect area for string drawing
-(void)paintLabel_0:(CGContextRef)ctx
              label:(TRLabel *)label
             string:(NSMutableAttributedString *)attString
        containRect:(CGRect) rect
{
    // (1) Under line for the first letter?
    if (label.underLine == TRUE)
    {
        [attString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:2] range:NSMakeRange(0, 1)];
    }
    // (2) exceeds the maximum number of letters?
    if ([attString length] >= label.maxNumberOfFullSizeLetters && label.attrRemainderDictionary != nil)
    {
        [attString addAttributes:label.attrRemainderDictionary range:NSMakeRange(label.maxNumberOfFullSizeLetters, [attString length] - label.maxNumberOfFullSizeLetters)];
    }
    // (3) draw at labelPosition
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    if (label.blurRadius > .0)
    {
        CGContextSetShadowWithColor(ctx, label.blurSize, label.blurRadius, label.blurColor.CGColor);
    }
    
    // paint the label
    
    // save current context
    CGContextSaveGState(ctx);
    CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0f, -1.0f));
    
    CTFrameDraw(frame, ctx);
    
    // restore the context
    CGContextRestoreGState(ctx);

    // release the objects
    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(path);
}

// paint axis tick label along radius direction
-(void)paintTickLabels_radius:(CGContextRef)ctx
                   startAngle:(float)start
                     endAngle:(float)end
                       radius:(float)radius
                      barSize:(float)size
                       center:(CGPoint)origin
                  frameHeight:(int)height
{
    int i;
    float rPosition = radius + size;
    float aPosition = start;
    CGPoint labelPosition;
    float labelHeight, lableWidth;
    float labelSpace = .0;
    float deltaRadius = .0;
    
    // alignment
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    // save current context
    CGContextSaveGState(ctx);
    
    // flip y direction to have right contest for drawing the text
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    labelHeight = 40.0;
    lableWidth = 100.0;
    
    // going over all axis tick text
    for (i = 0; i < numberOfTicks; i++)
    {
        // ith TRAxisTick object
        TRAxisTick *tick = [self tick:i];
        
        if (tick == nil)
        {
            continue;
        }
        
        // draw this tick lable at aPosition angle position.  since the view is flipped along the y
        // direction we need to use -tick.viewOffset for position calculation
        aPosition = -tick.viewOffset;
        
        // create attributed string for drawing
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tick.label.shortString attributes:tick.label.attrDictionary];
        
        // check to see if we have enough space for displaying the label
        // get string label size
        CGRect txtSize = [attString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];
        
        lableWidth = txtSize.size.width;
        labelHeight = txtSize.size.height;
        
        // adjust the label length based on what we have at this position
        labelSpace =  lableWidth;
        /* No need to make adjustment here.  let caller make decision on string length
        if (labelSpace > self.labelMargin * self.pointsPerFontSize)
        {
            labelSpace = self.labelMargin * self.pointsPerFontSize;
        }
         */
        
        // average char dispaly size
        if (attString.length > 0)
        {
            _averageCharWidth = txtSize.size.width / attString.length;
        }
        _averageCharHeight = txtSize.size.height;
        
        // angle difference by the half height of string
        deltaRadius = tick.viewSpace;
        
        // labe head poition
        labelPosition.x = origin.x + (rPosition + deltaRadius) * cosf(DEGREES_TO_RADIANS(aPosition));
        labelPosition.y = origin.y - (rPosition + deltaRadius)* sinf(DEGREES_TO_RADIANS(aPosition));
        
        // draw this label
        [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 1)];
        
        CGRect rect = CGRectMake(.0, -labelHeight * .5, labelSpace, labelHeight + 2);
        
        // draw label at position point labelPosition with angle degree of (aPosition + deltaAngle)
        CGContextTranslateCTM(ctx, labelPosition.x, labelPosition.y);
        CGContextRotateCTM(ctx, -DEGREES_TO_RADIANS(aPosition));
        
        [self paintLabel_0:ctx label:tick.label string:attString containRect:rect];
        
        CGContextRotateCTM(ctx, DEGREES_TO_RADIANS(aPosition));
        CGContextTranslateCTM(ctx, -labelPosition.x, -labelPosition.y);
    }
    
    // restore the context
    CGContextRestoreGState(ctx);
}

// hit test.  Potential hit objects: slider, begin arrow, end arrow and axis lable
-(HitObj)HitTest:(CGPoint)atPoint
          radius:(float)radius
         barSize:(float)size
          center:(CGPoint)origin
{
    HitObj hit;
    
    hit.hitObject = TRObjs_None;
    
    // convert atPoint to position in (angle, radius) coordinate position first
    CGFloat r = hypotf(atPoint.x - origin.x, atPoint.y - origin.y);
    float a = 180.0 * atan(-(atPoint.y - origin.y) / (atPoint.x - origin.x)) / 3.14;
    
    if ((atPoint.x - origin.x) < 0)
    {
        a += 180;
    }
    
    // in case of drawing slider bars on outer decroation ring:
    float barRingOffset = _ring.outerDecorationRingOffset + _ring.outerDecorationRingSize * .5;
    
    // (1) hit slider bar?
    bool visibleBar = (_showBar == TRUE && self.fishEyeNeeded);
    float barHalfWidthAngle = 180.0 * _slider.length / (3.14 * (radius + size + barRingOffset));
    if (visibleBar &&
        (fabs(a - super.eyePosition) <= barHalfWidthAngle || fabs(a - super.eyePosition - 360.0) <= barHalfWidthAngle) &&
        fabsf(radius + size + barRingOffset - r) <= _slider.height * .5)
    {
        hit.hitObject = TRObjs_ColumnBar;
        return hit;
    }
    
    // (2) hit begin arrow ?
    float arrowHalfWidthAngle = 180.0 * _beginArrow.width / (3.14 * (radius + size + barRingOffset));
    float arrowPointDirection = min;
    
    if (_beginArrow.showArrow == TRUE &&
        (fabs(a - arrowPointDirection) <= arrowHalfWidthAngle || fabs(a - arrowPointDirection - 360.0) <= arrowHalfWidthAngle) &&
        fabsf(radius + size + barRingOffset - r) <= _beginArrow.height * .5
        )
    {
        hit.hitObject = TRObjs_Arrows_Begin;
        return hit;
    }
    
    // (3) hit end arrow ?
    arrowHalfWidthAngle = 180.0 * _endArrow.width / (3.14 * (radius + size + barRingOffset));
    arrowPointDirection = max;
    if (_endArrow.showArrow == TRUE &&
        (fabs(a - arrowPointDirection) <= arrowHalfWidthAngle || fabs(a - arrowPointDirection - 360.0) <= arrowHalfWidthAngle) &&
        fabsf(radius + size + barRingOffset - r) <= _endArrow.height * .5
        )
    {
        hit.hitObject = TRObjs_Arrows_End;
        return hit;
    }
    
    // (4) hit outside bar ring ?
    if (a >= super.firstTickValue && a <= super.lastTickValue && r > radius && r < (radius + size))
    {
        hit.hitObject = TRObjs_Column_Axis;
        return hit;
    }
    
    // (5) hit label text?
    int i;
    float length, height;
    float labelHalfWidthAngle, labelHeight;
    float lableAnglePosition;
    float lableCenter;

    height = _averageCharHeight;
    
    for (i = 0; i < numberOfTicks; i++)
    {
        // ith TRAxisTick object
        TRAxisTick *tick = [self tick:i];
        
        if (tick == nil)
        {
            continue;
        }
        
        lableAnglePosition = tick.viewOffset;
        
        length = tick.label.shortString.length * _averageCharWidth;
        if (length > self.labelMargin * self.pointsPerFontSize)
        {
            length = self.labelMargin * self.pointsPerFontSize;
        }
        
        lableCenter = radius + size + tick.viewSpace;
        if (self.tickLableDirection == TickLableOrientation_0)
        {
            // horizantal direction
            labelHalfWidthAngle = 180.0 * length / (3.14 * (radius + size));
            labelHeight = _averageCharHeight;
        }else if (self.tickLableDirection == TickLableOrientation_Radius)
        {
            // radius direction
            labelHalfWidthAngle = 180.0 * height / (3.14 * (radius + size));
            labelHeight = length;
        }else
        {
            labelHalfWidthAngle = 0.0;
            labelHeight = .0;
        }
        
        lableCenter += labelHeight * .5;
        if ((fabs(a - lableAnglePosition) <= barHalfWidthAngle || fabs(a - lableAnglePosition - 360.0) <= labelHalfWidthAngle) &&
            fabsf(lableCenter- r) <= labelHeight * .5)
        {
            hit.hitObject = TRObjs_Column_Axis_Label;
            hit.col = i;
            return hit;
        }
    }
    
    return hit;
}

@end
