//
//  ACircularBar.m
//  AProgressBars
//
//  Created by hui wang on 7/21/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ACircularBarChart.h"

@interface ACircularBarChart (PrivateMethods)

// draw empty backlground circle bars
-(void)drawEmptyBar:(CGContextRef)context;

// draw progress bar
-(void)drawProgressBar:(CGContextRef)context;

// draw bar origin symbol
-(void)drawBegin:(CGContextRef)context;

// draw bar end symbol
-(void)drawEnd:(CGContextRef)context;

// draw reading in the middle
-(void)drawReadings:(CGContextRef)context;

// draw text (under circle)
-(void)drawTitle:(CGContextRef)context;

@end

@implementation ACircularBarChart
{
    @private
    
    // center position of circle
    CGPoint _center;
    // radius
    int _radius;
    // begin position (angle)
    int _base;
}

// object createtion
-(id)initWith:(ABars*)bars
      keyName:(NSString*)keyName
  displayName:(NSString*)displayName
      barSize:(int)barSize
{
    self = [super init];
    
    if (self)
    {
        _bars = bars;
        _keyName = keyName;
        _displayName = displayName;
        _barSize = barSize;
        _emptyBarColor = [UIColor colorWithRed: .0 green: .0 blue: .0 alpha: .2];
        
        // test
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    return self;
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    // resize circle bar dimensions
    _center.x = bounds.origin.x + bounds.size.width / 2;
    _center.y = bounds.origin.y + bounds.size.height / 2;
    _radius = MIN(bounds.size.width, bounds.size.height) / 2 - _barSize / 2 - 1;
}

// circle progress chart drawing
- (void)drawInContext:(CGContextRef)context
{
    CGContextSaveGState(context);

    // (1) empty bar
    [self drawEmptyBar:context];
    
    // (2) progress bar
    [self drawProgressBar:context];
    
    // (3) draw end dot
    [self drawEnd:context];
    
    // (4) draw readings
    [self drawReadings:context];
    
    CGContextRestoreGState(context);
}

// draw empty backlground circle bars
-(void)drawEmptyBar:(CGContextRef)context
{
    int r = _radius;
    
    for (ABar* bar in _bars.bars)
    {
        UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:_center radius:r startAngle:0 endAngle:DEGREES_TO_RADIANS(360)  clockwise:YES];
    
        CGContextAddPath(context, bezierPath.CGPath);
    
        CGContextSetLineWidth(context, _barSize);
        CGContextSetStrokeColorWithColor(context, _emptyBarColor.CGColor);
    
        CGContextDrawPath(context, kCGPathStroke);
        
        r = r - _barSize;
    }
}

// draw progress bar
-(void)drawProgressBar:(CGContextRef)context
{
    int r = _radius;
    float range;
    
    for (ABar* bar in _bars.bars)
    {
        range = .01 * bar.height * 2 * M_PI;
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:_center radius:r startAngle:-M_PI_2 endAngle:(-M_PI_2 + range)  clockwise:YES];
    
        CGContextAddPath(context, bezierPath.CGPath);
    
        CGContextSetLineWidth(context, _barSize - 1.5);
        CGContextSetStrokeColorWithColor(context, bar.color1.CGColor);
        CGContextSetLineCap(context, kCGLineCapRound);
    
        CGContextDrawPath(context, kCGPathStroke);
        
        r = r - _barSize;
    }
}

// draw bar origin symbol
-(void)drawBegin:(CGContextRef)context
{
    
}

// draw bar end symbol
-(void)drawEnd:(CGContextRef)context
{
    int r = _radius;
    float range;
    CGPoint pt;
    
    for (ABar* bar in _bars.bars)
    {
        range = .01 * bar.height * 2 * M_PI;
        // begin from -M_PI_2
        range = -M_PI_2 + range - DEGREES_TO_RADIANS(3);
        
        pt.x = _center.x + r * cosf(range);
        pt.y = _center.y + r * sinf(range);
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:pt radius:1.5 startAngle:0 endAngle:DEGREES_TO_RADIANS(360)  clockwise:YES];
        
        CGContextAddPath(context, bezierPath.CGPath);
        
        CGContextSetFillColorWithColor(context, [UIColor darkTextColor].CGColor);
        CGContextDrawPath(context, kCGPathFill);
        
        r = r - _barSize;
    }
}

// draw reading in the middle
-(void)drawReadings:(CGContextRef)context
{
    CGRect textArea;
    int w, h, b, l;
    
    // find total size first
    l = 0;
    for (ABar* bar in _bars.bars)
    {
        l += bar.text.attributedText.size.width;
    }
    
    b = _center.x - l / 2;
    
    for (ABar* bar in _bars.bars)
    {
        w = bar.text.attributedText.size.width;
        h = bar.text.attributedText.size.height;
        
        textArea = CGRectMake(b, _center.y, w + 2, h + 2);
        
        [bar.text paint:context rect:textArea];
        
        b += (w + 1);
    }
}

@end
