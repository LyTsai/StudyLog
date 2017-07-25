//
//  ABatteryBar.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 9/12/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ABatteryBar.h"
#import "ANText.h"

@implementation ABatteryBar
{
    @private
    
    ANText* _readings;
    
    // range of indicator rect
    float _barPos_l;
    float _barPos_t;
    float _bar_width;
    float _bar_height;
    
    // progress bar length that is propertional to value
    float _barLength;
}

-(NSString*)getKey
{
    return @"batteryChart";
}

-(void)initDrawPros
{
    [super initDrawPros];
    
    self.pathRefSize = CGPointMake(135, 24);
    
    _barPos_l = 6.2;
    _barPos_t = 5;
    _bar_width = 117.5;
    _bar_height = 14;
    
    _barLength = .0;
    
    _color = [UIColor colorWithRed: 0.796 green: 0.796 blue: 0.796 alpha: 1];
    _indicatorColor = [UIColor colorWithRed: 0 green: 1 blue: 0 alpha: .8];
    
    _min = .0;
    _max = 100.0;
    
    _unit = @" %";
    
    _readings = [[ANText alloc] initWithFont:@"Helvetica Bold" size:16.0 shadow:FALSE underline:FALSE];
    _readings.textFillColor = [UIColor darkTextColor];
    
    [_readings.text setString:[NSNumber numberWithFloat:_value].stringValue];
    [_readings.text appendString:_unit];
}

-(void)setValue:(double)value
{
    _value = value;
    _barLength = (_value - _min) * _bar_width / (_max - _min);
    
    [_readings.text setString:[NSNumber numberWithFloat:_value].stringValue];
    [_readings.text appendString:_unit];
    
    [self setNeedsDisplay];
    
    return ;
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    // (1) battery Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(130.2, 6.3)];
    [bezierPath addCurveToPoint: CGPointMake(127.3, 0) controlPoint1: CGPointMake(130.2, 6.3) controlPoint2: CGPointMake(129.9, 2.6)];
    [bezierPath addLineToPoint: CGPointMake(3, 0)];
    [bezierPath addCurveToPoint: CGPointMake(0, 11.9) controlPoint1: CGPointMake(3, 0) controlPoint2: CGPointMake(0, 1.4)];
    [bezierPath addLineToPoint: CGPointMake(0, 11.9)];
    [bezierPath addLineToPoint: CGPointMake(0, 12)];
    [bezierPath addLineToPoint: CGPointMake(0, 12.1)];
    [bezierPath addLineToPoint: CGPointMake(0, 12.1)];
    [bezierPath addCurveToPoint: CGPointMake(3, 24) controlPoint1: CGPointMake(0, 22.6) controlPoint2: CGPointMake(3, 24)];
    [bezierPath addLineToPoint: CGPointMake(127.4, 24)];
    [bezierPath addCurveToPoint: CGPointMake(130.3, 17.7) controlPoint1: CGPointMake(130, 21.4) controlPoint2: CGPointMake(130.3, 17.7)];
    [bezierPath addLineToPoint: CGPointMake(134.5, 17.7)];
    [bezierPath addLineToPoint: CGPointMake(134.5, 12.1)];
    [bezierPath addLineToPoint: CGPointMake(134.5, 11.9)];
    [bezierPath addLineToPoint: CGPointMake(134.5, 6.3)];
    [bezierPath addLineToPoint: CGPointMake(130.2, 6.3)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(126.3, 21.8)];
    [bezierPath addLineToPoint: CGPointMake(4.1, 21.8)];
    [bezierPath addLineToPoint: CGPointMake(4.1, 2.3)];
    [bezierPath addLineToPoint: CGPointMake(126.4, 2.3)];
    [bezierPath addLineToPoint: CGPointMake(126.4, 21.8)];
    [bezierPath addLineToPoint: CGPointMake(126.3, 21.8)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    bezierPath.usesEvenOddFillRule = YES;
    
    [_color setFill];
    [bezierPath fill];

    // (2) indicator Drawing
    CGRect IndicatorRect = CGRectMake(_barPos_l, _barPos_t, _barLength, _bar_height);
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:IndicatorRect];
    [_indicatorColor setFill];
    [rectanglePath fill];
    
    // (3) label drawing in the center
    CGRect textArea;
    CGPoint lbpos;
    
    lbpos.x = CGRectGetMidX(IndicatorRect) - _readings.attributedText.size.width / 2;
    lbpos.y = CGRectGetMidY(IndicatorRect) - _readings.attributedText.size.height / 2;
    
    //textArea = CGRectMake(lbpos.x, lbpos.y, _readings.attributedText.size.width + 2, _readings.attributedText.size.height + 2);
    
    textArea = CGRectMake(CGRectGetMidX(self.bounds) - _readings.attributedText.size.width / 2, CGRectGetMidY(self.bounds) + _readings.attributedText.size.height / 4, _readings.attributedText.size.width + 2, _readings.attributedText.size.height + 2);
    
    [_readings paint:context rect:textArea];

    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
