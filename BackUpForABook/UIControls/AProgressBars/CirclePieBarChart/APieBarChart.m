//
//  APieBarChart.m
//  AProgressBars
//
//  Created by hui wang on 7/18/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "APieBarChart.h"

@implementation APieBarChart

// frame - frame area for this bar chart
// keyName - key for identify this bar layer
// displayName - display name of this bar collection
// methods
-(id)initWith:(CGRect)frame
      keyName:(NSString*)keyName
  displayName:(NSString*)displayName
         bars:(ABars*)bars
   beginAngle:(float)beginAngle
     endAngle:(float)endAngle
barBeginRadius:(float)barBeginRadius
 barEndRadius:(float)barEndRadius
       barGap:(float)barGap
{
    self = [super init];
    
    _keyName = keyName;
    _displayName = displayName;
    _bars = bars;
    _barBeginRadius = barBeginRadius;
    _barEndRadius = barEndRadius;
    _beginAngle = beginAngle;
    _endAngle = endAngle;
    _barBias = 0;
    _barGap = barGap;
    
    // maximum view area at root level
    self.frame = frame;
    
    // start from the center point
    _center.x = frame.origin.x + .5 * frame.size.width;
    _center.y = frame.origin.y + .5 * frame.size.height;
    
    // background color
    self.backgroundColor = [UIColor clearColor].CGColor;
    
    return self;
}

// reposition
-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
    
    // start from the center point
    _center.x = frame.origin.x + .5 * frame.size.width;
    _center.y = frame.origin.y + .5 * frame.size.height;
}

// setup bar layout
// beginAngle, endAngle - range for this pie bars collection
// barBeginRadius, barEndRadius - size of the bar
-(void)autoLayout:(float)beginAngle
         endAngle:(float)endAngle
   barBeginRadius:(float)barBeginRadius
     barEndRadius:(float)barEndRadius
{
    _beginAngle = beginAngle;
    _endAngle = endAngle;
    _barBeginRadius = barBeginRadius;
    _barEndRadius = barEndRadius;
    
    int nBars = _bars.bars.count;
    // set _barGap using barGap as reference
    if (fabs(_endAngle - _beginAngle) < 2.0 * fabs(_barGap * (nBars + 1)))
    {
        if (_barGap > 0)
        {
            _barGap = fabs(_endAngle - _beginAngle) / (2.0 * (nBars + 1));
        }else
        {
            _barGap = -fabs(_endAngle - _beginAngle) / (2.0 * (nBars + 1));
        }
    }
    
    // compute angle ranges for each of the bars
    _deltaAngle = _endAngle - _beginAngle - _barGap * (nBars + 1);
    
    if (nBars > 0)
    {
        _deltaAngle = _deltaAngle / nBars;
    }
    
    [self setNeedsDisplay];
}

// drawing function
- (void)drawInContext:(CGContextRef)ctx
{
    // save context
    CGContextSaveGState(ctx);
    
    /*
     // test drawing
     UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
     CGContextSetLineWidth(ctx, 2.0);
     
     [rectanglePath fill];
     //[rectanglePath stroke];
     */
    
    // (1) paint pie area
    float left, right, top, bottom, size;
    
    left = _endAngle;
    right = _beginAngle;
    bottom = _barBeginRadius;
    top = _barEndRadius;
    size = top - bottom;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, _center.x, _center.y, top, right, left, TRUE);
    CGPathAddArc(path, NULL, _center.x, _center.y, bottom, left, right, FALSE);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(ctx, path);
    
    CGContextSetFillColorWithColor(ctx, _bars.backGround.bkgColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    
    // (2) paint each bars
    // size of each bar
    float step = _deltaAngle;
    // starting point of each bar
    right = _beginAngle + _barGap;
    
    // position and size of each bar
    CGRect textArea;
    
    // gap for text from the bars
    float gap = 5.0;
    
    for (ABar* bar in _bars.bars)
    {
        // (a) paint (by filling) the bar
        left = right + step;
        top = bottom + _barBias + (bar.val / _bars.maxVal) * (size - _barBias);
        
        CGMutablePathRef barPath = CGPathCreateMutable();
        
        CGPathAddArc(barPath, NULL, _center.x, _center.y, top, right, left, TRUE);
        CGPathAddArc(barPath, NULL, _center.x, _center.y, bottom, left, right, FALSE);
        CGPathCloseSubpath(barPath);
        
        CGContextAddPath(ctx, barPath);
        
        CGContextSetFillColorWithColor(ctx, bar.color1.CGColor);
        CGContextDrawPath(ctx, kCGPathFill);
        
        
        // (b) display bar value text at location (left, top)
        textArea = CGRectMake(_center.x + (top + gap) * cos(.5 * (left + right)), _center.y + (top + gap) * sin(.5 * (left + right)), 24, 12);
        [bar.text paint:ctx rect:textArea];
        
        // move onto next
        right = left + _barGap;
    }
    
    // display metric name at location (left, bottom + _barRadius)
    textArea = CGRectMake(_center.x + (_barEndRadius + gap) * cos(.5 * (_beginAngle + _endAngle)), _center.y + (_barEndRadius + gap) * sin(.5 * (_beginAngle + _endAngle)), _bars.metricName.attributedText.size.width + 2, _bars.metricName.attributedText.size.height + 2);
    
    [_bars.metricName paint:ctx rect:textArea];
    
    // done drawing
    CGContextRestoreGState(ctx);
}

@end
