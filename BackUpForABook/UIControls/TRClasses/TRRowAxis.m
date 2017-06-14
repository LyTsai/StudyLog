//
//  TRRowAxis.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRRowAxis.h"

@interface TRRowAxis (PrivateMethods)

// paint middle slider bar
// start, end - defines the moving range for the slider
// angle - defines the line on which the slider is moving
-(void)paintMiddleSliderBar:(CGContextRef)ctx
                startRadius:(float)start
                  endRadius:(float)end
                      angle:(float)angle
                     center:(CGPoint)origin;

// paint the slider bar
-(void)paintMiddleBar:(CGContextRef)ctx
                angle:(float)angle
             position:(CGPoint)position;

// paint the labels on the left and right edges
// start, end - start and end of visual space
// angle - angle of the line where lables are drawn onto
// origin - the center of tree ring map
-(void)paintTickLabels_Angle:(CGContextRef)ctx
               startPosition:(float)start
                 endPosition:(float)end
                       angle:(float)angle
                      center:(CGPoint)origin
                 frameHeight:(int)height;

// paint labels on the left and right edges with 0 degree or shift labels up and down
-(void)paintTickLabels_Level:(CGContextRef)ctx
               startPosition:(float)start
                 endPosition:(float)end
                       angle:(float)angle
                      center:(CGPoint)origin
                 frameHeight:(int)height;

// paint label zero degree
-(void)paintLabel_0:(CGContextRef)ctx
              label:(TRLabel *)label
             string:(NSMutableAttributedString *)attString
        containRect:(CGRect) rect;

// paint ticks
-(void)paintTicks:(CGContextRef)ctx
           offset:(float)offset
             angle:(float)angle
           center:(CGPoint)origin;

@end

@implementation TRRowAxis

-(id)init
{
    self = [super init];
    
    // !!! self.tickLableDirection has two possible values: TickLableOrientation_0 and TickLableOrientation_angle
    self.tickLableDirection = TickLableOrientation_Angle;
    
    // show label
    self.showLable = TRUE;
    self.showTicks = TRUE;
    
    // slider bar
    _showBar = TRUE;
    _slider = [[DSSlider alloc] init];
    
    // data set for fishy eye effect
    super.eyeRadius = 50;
    super.eyeTicks = 3;
    super.eyePosition = (lastTickValue + firstTickValue) * .5;
    super.fishyEye = TRUE;
    
    return self;
}

// paint axis
// paint axis
// start, end - range of visual space
// angle - axis direction
// tickoffset - tick offset away form the axis 0 ground
// origin - center point of ring
-(void)paint:(CGContextRef)ctx
startPosition:(float)start
 endPosition:(float)end
       angle:(float)angle
      offset:(float)offset
      center:(CGPoint)origin
 frameHeight:(int)height
{
    if (self.showLable == TRUE)
    {
        // paint the label
        // !!! self.tickLableDirection has two possible values: TickLableOrientation_0 and TickLableOrientation_Angle
        if (self.tickLableDirection == TickLableOrientation_Angle)
        {
            // automatic angle orientation
            [self paintTickLabels_Angle:ctx startPosition:start endPosition:end angle:angle center:origin frameHeight:height];
        }else
        {
            // 0 degree or shifting up and down
            [self paintTickLabels_Level:ctx startPosition:start endPosition:end angle:angle center:origin frameHeight:height];
        }
    }
    
    if (self.showLable == TRUE && self.showTicks)
    {
        [self paintTicks:ctx offset:offset angle:angle center:origin];
    }
    
    return ;
}

// show the slider bar
-(void)paintSliderBar:(CGContextRef)ctx
        startPosition:(float)start
          endPosition:(float)end
                angle:(float)angle
               center:(CGPoint)origin
{
    if (_showBar == TRUE && self.fishEyeNeeded)
    {
        [self paintMiddleSliderBar:ctx startRadius:start endRadius:end angle:angle center:origin];
    }
}

// paint middle slider bar
// start, end - defines the moving range for the slider
// angle - defines the line on which the slider is moving
-(void)paintMiddleSliderBar:(CGContextRef)ctx
                startRadius:(float)start
                  endRadius:(float)end
                      angle:(float)angle
                     center:(CGPoint)origin
{
    // make sure barPostion is within half bar size range
    float halfBarSize = _slider.length * .5 + 8;
    
    if (super.eyePosition < (start + halfBarSize))
    {
        super.eyePosition = start + halfBarSize;
    }
    
    if (super.eyePosition > (end - halfBarSize))
    {
        super.eyePosition = end - halfBarSize;
    }
    
    CGPoint centerPosition = CGPointMake(origin.x + super.eyePosition * cosf(DEGREES_TO_RADIANS(angle)), origin.y - super.eyePosition * sinf(DEGREES_TO_RADIANS(angle)));
    
    [self paintMiddleBar:ctx angle:angle position:centerPosition];
}

// paint middle slider bar
-(void)paintMiddleBar:(CGContextRef)ctx
                angle:(float)angle
             position:(CGPoint)position
{
    // save current context
    CGContextSaveGState(ctx);
    
    CGContextTranslateCTM(ctx, position.x, position.y);
    CGContextRotateCTM(ctx, DEGREES_TO_RADIANS(-angle));
    
    // draw the arrow
    [_slider paint:ctx];
    
    // restore the context
    CGContextRestoreGState(ctx);
}

// paint the labels on the left and right edges
// start, end - start and end of visual space
// angle - angle of the line where lables are drawn onto
// isLeft - true if the left side axis
// origin - the center of tree ring map
-(void)paintTickLabels_Angle:(CGContextRef)ctx
               startPosition:(float)start
                 endPosition:(float)end
                       angle:(float)angle
                      center:(CGPoint)origin
                 frameHeight:(int)height
{
    int i;
    float rPosition;
    CGPoint labelPosition;
    float labelHeight, lableWidth;
    float labelSpace = .0;
    float labelAngle = .0;  // computed based on the avalible space
    CGRect txtSize;
    
    if (numberOfTicks == 0)
    {
        return;
    }
    
    // alignment
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    // save current context
    CGContextSaveGState(ctx);
 
    // inital values.  will be reassigned dynamicly
    labelHeight = 40.0;
    lableWidth = 100.0;
    
    NSMutableAttributedString *sampleString = [[NSMutableAttributedString alloc] initWithString:[self tick:0].label.shortString attributes:[self tick:0].label.attrDictionary];
    txtSize = [sampleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];

    // labelAngle based on visual between lables
    if (numberOfTicks == 1)
    {
        labelAngle = .0;
    }else
    {
        labelAngle = 180 * atan(txtSize.size.height / ([[self tick:1] viewOffset] - [[self tick:0] viewOffset])) / 3.14;
    }
    
    // going over all axis tick text
    for (i = 0; i < numberOfTicks; i++)
    {
        // ith TRAxisTick object
        TRAxisTick *tick = [self tick:i];
        
        if (tick == nil)
        {
            continue;
        }
        
        // radius position of this lable
        rPosition = tick.viewOffset;
        
        // create attributed string for drawing
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tick.label.shortString attributes:tick.label.attrDictionary];
        
        // check to see if we have enough space for displaying the label
        // get string label size
        txtSize = [attString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];
        
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
        
        // labe head poition
        labelPosition.x = origin.x + rPosition * cosf(DEGREES_TO_RADIANS(angle));
        labelPosition.y = origin.y - rPosition * sinf(DEGREES_TO_RADIANS(angle)) + tick.viewSpace;
        
        // draw this label
        CGRect rect = CGRectMake(.0, labelHeight, labelSpace, labelHeight + 2);
        
        CGContextTranslateCTM(ctx, labelPosition.x, labelPosition.y);
        CGContextRotateCTM(ctx, -DEGREES_TO_RADIANS(labelAngle));
        
        [self paintLabel_0:ctx label:tick.label string:attString containRect:rect];
        
        CGContextRotateCTM(ctx, DEGREES_TO_RADIANS(labelAngle));
        CGContextTranslateCTM(ctx, -labelPosition.x, -labelPosition.y);
    }
    
    // restore the context
    CGContextRestoreGState(ctx);
}

// paint labels on the left and right edges with 0 degree or shift labels up and down
-(void)paintTickLabels_Level:(CGContextRef)ctx
               startPosition:(float)start
                 endPosition:(float)end
                       angle:(float)angle
                      center:(CGPoint)origin
                 frameHeight:(int)height
{
    int i;
    float rPosition;
    CGPoint labelPosition;
    float labelHeight, lableWidth;
    float labelSpace = .0;
    float labelShift = .0;
    CGRect txtSize;
    
    if (numberOfTicks == 0)
    {
        return;
    }
    
    // alignment
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    // save current context
    CGContextSaveGState(ctx);
    
    // inital values.  will be reassigned dynamicly
    labelHeight = 40.0;
    lableWidth = 100.0;
    
    NSMutableAttributedString *sampleString = [[NSMutableAttributedString alloc] initWithString:[self tick:0].label.shortString attributes:[self tick:0].label.attrDictionary];
    txtSize = [sampleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];
    
    // labelAngle based on visual between lables
    if (numberOfTicks == 1)
    {
        labelShift = .0;
    }else
    {
        labelShift = txtSize.size.height + 2;
    }
    
    // going over all axis tick text
    for (i = 0; i < numberOfTicks; i++)
    {
        // ith TRAxisTick object
        TRAxisTick *tick = [self tick:i];
        
        if (tick == nil)
        {
            continue;
        }
        
        // radius position of this lable
        rPosition = tick.viewOffset;
        
        // create attributed string for drawing
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tick.label.shortString attributes:tick.label.attrDictionary];
        
        // check to see if we have enough space for displaying the label
        // get string label size
        txtSize = [attString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];
        
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
        
        // labe head poition
        labelPosition.x = origin.x + rPosition * cosf(DEGREES_TO_RADIANS(angle));
        labelPosition.y = origin.y - rPosition * sinf(DEGREES_TO_RADIANS(angle)) + tick.viewSpace;
        
        // make adjustment along x direction
        labelPosition.x -= .5 * lableWidth;
        
        // make adjustment along y direction
        if (i % 2 != 0)
        {
            labelPosition.y += labelShift;
        }
        
        // draw this label
        CGRect rect = CGRectMake(.0, labelHeight, labelSpace, labelHeight + 2);
        
        CGContextTranslateCTM(ctx, labelPosition.x, labelPosition.y);
        
        [self paintLabel_0:ctx label:tick.label string:attString containRect:rect];
        
        CGContextTranslateCTM(ctx, -labelPosition.x, -labelPosition.y);
    }
    
    // restore the context
    CGContextRestoreGState(ctx);
    return ;
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

// paint ticks
-(void)paintTicks:(CGContextRef)ctx
           offset:(float)offset
            angle:(float)angle
           center:(CGPoint)origin
{
    int i;
    float rPosition;
    CGPoint axisPosition, labelPosition;
    
    // save current context
    CGContextSaveGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, self.tickColor.CGColor);
    CGContextSetLineWidth(ctx, self.tickSize);
    
    // going over all axis tick text
    CGContextBeginPath(ctx);
    for (i = 0; i < numberOfTicks; i++)
    {
        // ith TRAxisTick object
        TRAxisTick *tick = [self tick:i];
        
        if (tick == nil)
        {
            continue;
        }
        
        // radius position of this lable
        rPosition = tick.viewOffset;
        
        // axis position
        axisPosition.x = origin.x + rPosition * cosf(DEGREES_TO_RADIANS(angle));
        axisPosition.y = origin.y - rPosition * sinf(DEGREES_TO_RADIANS(angle)) + offset;
        
        // labe head poition
        labelPosition.x = axisPosition.x;
        labelPosition.y = axisPosition.y + self.height * self.pointsPerFontSize;
        
        // make adjustment along y direction
        if (i % 2 != 0)
        {
            labelPosition.y = axisPosition.y + (self.height + 3.0) * self.pointsPerFontSize;
        }
        
        // draw line from axisPosition to labelPosition
        CGContextMoveToPoint(ctx, axisPosition.x, axisPosition.y);
        CGContextAddLineToPoint(ctx, labelPosition.x, labelPosition.y);
        
        CGContextStrokePath(ctx);
     }
    
    // restore the context
    CGContextRestoreGState(ctx);

    return ;
}

// hit test.  Potential hit objects: slider and and axis lable
-(HitObj)HitTest:(CGPoint)atPoint
           angle:(float)angle
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

    // (1) hit slider bar?
    bool visibleBar = (_showBar == TRUE && self.fishEyeNeeded);
    float barHalfWidthAngle = 180.0 * _slider.height / (3.14 * super.eyePosition);
    if (visibleBar &&
        (fabs(a - angle) <= barHalfWidthAngle || fabs(a - angle - 360.0) <= barHalfWidthAngle) &&
        fabsf(super.eyePosition - r) <= _slider.length * .5)
    {
        hit.hitObject = TRObjs_RowBar;
        return hit;
    }
    
    
    // (2) hit axis area?
    if (r > super.firstTickValue && r < super.lastTickValue)
    {
        float angleHaflRange = 180.0 * size / (3.14 * r);
        if (fabs(a - angle) <= angleHaflRange || fabs(a - angle - 360.0) <= angleHaflRange)
        {
            hit.hitObject = TRObjs_Row_Axis;
            return hit;
        }
    }
    
     // (3) hit axis lables?
    
    return hit;
}

@end
