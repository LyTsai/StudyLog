//
//  ACircleExtendBar.m
//  AProgressBars
//
//  Created by hui wang on 7/6/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ACircleExtendBar.h"
#import "APieBarChart.h"

@implementation ACircleExtendBar

//@synthesize keyName, displayName, circleRadius, barRadius, barGap;

// object inititalization
// frame - maximum frame area of this layer can draw onto relative to its parent layer
// keyName - key for identify this bar layer
// displayName - display name of this bar
// symbol - the circle symbol layer object
// circleRadius - size of circle symbol
// barRadius - size of full bar (range)
// barGap - gap between bars
// beginAngle, endAngle - range for this pie bars collection
// nBars - number of bars
-(id)initWith:(CGRect)frame
      keyName:(NSString*)keyName
  displayName:(NSString*)displayName
         bars:(ABars*)bars
       symbol:(APathDrawWrap*)symbol
 symbolRadius:(float)symbolRadius
       bottom:(float)bottom
          top:(float)top
       barGap:(float)barGap
{
    self = [super init];
    
    _symbolPos = frame.origin;
    _symbolRadius = symbolRadius;
    
    _beginAngle = 0;
    _endAngle = 0;
    _bottom = bottom;
    _top = top;
    _barGap = barGap;
    
    // maximum view area at root level
    self.frame = frame;
    
    // start from the center point
    _center.x = self.bounds.origin.x + .5 * self.bounds.size.width;
    _center.y = self.bounds.origin.y + .5 * self.bounds.size.height;
  
    // (1) pie chart object
    _pieChart = [[APieBarChart alloc] initWith:self.bounds keyName:keyName displayName:displayName bars:bars beginAngle:_beginAngle endAngle:_endAngle barBeginRadius:.0 barEndRadius:.0 barGap:barGap];
    
    // (2) symbol object
    _symbol = symbol;
    _symbol.frame = CGRectMake(_center.x - symbolRadius, _center.y - symbolRadius, 2.0 * symbolRadius, 2.0 * symbolRadius);
    
    // (3) "no show" at the beginning.  will show at the end of animation.  See "animationDidStop" in ACirclePopup.m
    _symbol.opacity = 0.0;
    _pieChart.opacity = 0.0;
    
    // (4) add into parent layer
    [self addSublayer:_pieChart];
    [self addSublayer:_symbol];
    
    // background color
    self.backgroundColor = [UIColor clearColor].CGColor;
    
    return self;
}

// reposition
-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
    
    _symbolPos = frame.origin;
    
    // start from the center point
    _center.x = self.bounds.origin.x + .5 * self.bounds.size.width;
    _center.y = self.bounds.origin.y + .5 * self.bounds.size.height;
    
    // pie chart parent frame area
    _pieChart.frame = frame;
    
    // symbol layout
    [self autoLayout:_beginAngle endAngle:_endAngle];
}

// setup bar layout
// beginAngle, endAngle - range for this pie bars collection
-(void)autoLayout:(float)beginAngle
         endAngle:(float)endAngle
{
    _beginAngle = beginAngle;
    _endAngle = endAngle;
    
    // setup symbol size and position
    float halfAngle = .5 * (_endAngle - _beginAngle);
    
    // compute size and position of circle symbol (pos, circleRadius) based on _symbolRadiusDis
    _symbolPos.x = _center.x + _bottom * cos(.5 * (_endAngle + _beginAngle));
    _symbolPos.y = _center.y + _bottom * sin(.5 * (_endAngle + _beginAngle));
    _symbolRadius = _bottom * fabs(sin(halfAngle));
    
    // (1) set symbol to position _symbolPos
    _symbol.frame = CGRectMake(_symbolPos.x - _symbolRadius, _symbolPos.y - _symbolRadius, 2.0 * _symbolRadius, 2.0 * _symbolRadius);
    
    // (2) setup pie chart visual layout
    _pieChart.barBias = _symbolRadius;
    [_pieChart autoLayout:beginAngle endAngle:endAngle barBeginRadius:_bottom barEndRadius:(_top)];
    
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
    
    /* Clipping not working well here yet.  we fix this by setting the path background in _symbol shapelayer
    // (1) Exclude the symbol area
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, _symbol.frame.origin.x, _symbol.frame.origin.y);
    
    CGMutablePathRef clipPath = CGPathCreateMutableCopyByTransformingPath(_symbol.path, &transform);
    CGContextAddPath(ctx, clipPath);
    */
    
    CGContextRestoreGState(ctx);
}

@end
