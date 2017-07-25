//
//  TRAxis.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/24/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRAxis.h"

@interface TRAxis (PrivateMethods)
// even resize
-(void)reSize_Even;
// linear resize
-(void)reSize_Linear;
// fish eye axis tick style
-(void)reSize_FishEye;
// compute effective radius
-(float)effectiveRadius:(float)delta;
// update tick fonts
-(void)updateTickFonts;
@end

// Genric tree ring map axis
@implementation TRAxis

@synthesize min, max, numberOfTicks, firstTickValue, lastTickValue;

// dynamic properties
// do we have a need for the "fish eye"?
bool _fishEyeNeeded;

-(id)init
{
    self = [super init];
    
    _pointsPerFontSize = 1.0;
    
    _showLable = FALSE;
    _showTicks = FALSE;
    _tickColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.8];
    _tickSize = .5;
    _height = 3;
    
    ticks = [[NSMutableArray alloc] initWithCapacity:100];
    axStyle = AxisTickStyle_Even;
    
    _uniformFontSize = FALSE;
    _fontSizeLarge = 10.0;
    _fontSizeSmall = 8.0;
    _fontSize_Remainder = 8.0;
    
    _maxNumberOfFullSizeLetters = 28;
    
    min = 0.0;
    max = 90.0;
    numberOfTicks = ticks.count;
    firstTickValue = min;
    lastTickValue = max;
    
    _tickLableDirection = TickLableOrientation_0;
    _spaceBetweenAxisAndLable = 6;
    
    // in font size
    _labelMargin = 80;
    
    _fishyEye = TRUE;
    _eyePosition = (firstTickValue + lastTickValue) * .5;
    _eyeRadius = 50;
    _eyeTicks = 5;
    
    // dynamic internal data
    _fishEyeNeeded = false;
    
    return self;
}

// methods of getting axis information
-(float)position:(int)index
{
    if (ticks == nil)
    {
        return 0.0;
    }
    
    if (index >= ticks.count)
    {
        return max;
    }
    
    if (index < 0)
    {
        return min;
    }
    
    return [self tick:index].viewOffset;
}

// return tick object at given index
-(TRAxisTick*)tick:(int)index
{
    return [ticks objectAtIndex:index];
}

// methods
-(void)setTickStyle:(AxisTickStyle)style
{
    axStyle = style;
    [self reSize];
}

// was fish eye needed for scaling?
-(bool)fishEyeNeeded
{
    return _fishEyeNeeded;
}

// call to reset visual display space and first , last tick positions and tick lables
-(BOOL)setAxisTicks:(float)axMin
                max:(float)axMax
         tickLabels:(NSArray*)tickLabels
     firstTickValue:(float)firstTick
      lastTickValue:(float)lastTick
{
    if (tickLabels == nil)
    {
        return FALSE;
    }
    
    int i;
    for (i = 0; i < tickLabels.count; i++)
    {
        if ([[tickLabels objectAtIndex:i] isKindOfClass:[NSString class]] != TRUE)
        {
            return FALSE;
        }
    }
    
    min = axMin;
    max = axMax;
    firstTickValue = firstTick;
    lastTickValue = lastTick;
    
    if (ticks != nil)
    {
        [ticks removeAllObjects];
    }else
    {
        ticks = [[NSMutableArray alloc] initWithCapacity:tickLabels.count];
    }
    
    // copy tick texts
    TRAxisTick *oneTick;
    for (i = 0; i < tickLabels.count; i++)
    {
        oneTick = [[TRAxisTick alloc] init];
        oneTick.label.shortString = [tickLabels objectAtIndex:i];
        oneTick.label.fullString = [tickLabels objectAtIndex:i];
        [ticks addObject:oneTick];
    }
    
    numberOfTicks = ticks.count;
    
    // call to create tick holders
    [self reSize];

    // update tick fonts
    [self updateTickFonts];
    
    return TRUE;
}

-(void)reSize
{
    _fishEyeNeeded = false;
    
    if (axStyle == AxisTickStyle_Even)
    {
        if (_fishyEye == TRUE)
        {
            // Fishy eye only applys to even distributed axis style
            [self reSize_FishEye];
        }else
        {
            [self reSize_Even];
        }
    }else if (axStyle == AxisTickStyle_Linear_MinMax)
    {
        [self reSize_Linear];
    }
}

// even resize
-(void)reSize_Even
{
    int i;
    
    float delta = lastTickValue - firstTickValue;
    
    if (ticks.count > 1)
    {
        delta = (lastTickValue - firstTickValue) / (ticks.count - 1);
    }
    
    TRAxisTick *oneTick;
    for (i = 0; i < ticks.count; i++)
    {
        oneTick = [ticks objectAtIndex:i];
        oneTick.gridIndex = i;
        oneTick.viewOffset = i * delta + firstTickValue;
        oneTick.viewSpace = _spaceBetweenAxisAndLable * _pointsPerFontSize;
    }
}

// linear resize
-(void)reSize_Linear
{
    
}

// overwrite setter function
-(void)setEyePosition:(float)eyePosition
{
    // make sure the new eye position will not cause eye reagion to be outside the axis value range defined by {lastTickValue, firstTickValue}
    if (_fishyEye != TRUE && ((eyePosition - _eyeRadius * _pointsPerFontSize) <= firstTickValue || (eyePosition + _eyeRadius * _pointsPerFontSize) >= lastTickValue))
    {
        return ;
    }
    _eyePosition = eyePosition;
}

// compute effective radius
-(float)effectiveRadius:(float)delta
{
    float _effectiveRadius = MIN(_eyeRadius * _pointsPerFontSize, ABS(lastTickValue - firstTickValue) * .5 - 2 * delta);
    return _effectiveRadius;
}

// fishy eye label tick distribution
-(void)reSize_FishEye
{
    // linear fill first
    [self reSize_Even];
    
    // the axis region is divided into three different zones:
    // {firstTickValue, _eyePosition - _effectiveRadius}
    // {_eyePosition - _effectiveRadius, _eyePosition + _effectiveRadius}
    // {_eyePosition + _effectiveRadius, lastTickValue}
    
    // current tick density
    float delta = (lastTickValue - firstTickValue) / (ticks.count - 1);
    float _effectiveRadius = [self effectiveRadius:delta];
    
    if (ticks.count <= 1 || _eyeTicks <= 1 || (2 * _effectiveRadius / _eyeTicks) <= delta)
    {
        // no need to zoom in
        _fishEyeNeeded = false;
        return ;
    }
    
    // we got here because we have lower tick density inside the eye region
    // each region has its own 'density'
    // fish eye view is needed
    _fishEyeNeeded = true;
    
    float denl, denm, denr;
    
    // set up the tick densities for the three zones
    denl = (lastTickValue - firstTickValue - 2 * _effectiveRadius) / (ticks.count - _eyeTicks - 1);
    denr = denl;
    // eye is only part of region
    denm = 2 * _effectiveRadius / _eyeTicks;
    
    // make adjustment for _eyePosition first to make sure the eye is always within the tick range
    if ((_eyePosition + _effectiveRadius) > (lastTickValue - denl))
    {
        _eyePosition = lastTickValue - _effectiveRadius - denl;
    }else if ((_eyePosition - _effectiveRadius) < (firstTickValue + denr))
    {
        _eyePosition = firstTickValue + _effectiveRadius + denr;
    }
    
    // the mapping of three regions are:
    // {firstTickValue, _eyePosition - _effectiveRadius} => {min, min + denl * (_eyePosition - _effectiveRadius - firstTickValue)}
    // {_eyePosition - _effectiveRadius, _eyePosition + _effectiveRadius} => {min + denl * (_eyePosition - _effectiveRadius - firstTickValue), max - denr * (last - _eyePosition - _effectiveRadius)}
    // {_eyePosition + _effectiveRadius, lastTickValue} => {max - denr * (last - _eyePosition - _effectiveRadius), max}
    
    float prevPos, deltaidx, eyel, eyer;
    int i;
 
    // eye lefet and right edge index position
    eyel = (_eyePosition - _effectiveRadius - firstTickValue) / denl;
    eyer = eyel + _eyeTicks;
    
    // start with firstTickValue position
    prevPos = firstTickValue - denl;
    for (i = 0; i < ticks.count; i++)
    {
        TRAxisTick *tick = [self tick:i];
        
        if (tick == nil)
        {
            continue;
        }
        
        // view position for ith tick in terms of denl
        if (i <= eyel)
        {
            // on the left side of "eye"
            tick.viewOffset = prevPos + denl;
            prevPos = prevPos + denl;
        }else if (i > eyer)
        {
            // on the right side of the eye
            if ((i - eyer) < 1.0)
            {
                // first time getting into the right side of eye
                deltaidx = eyer - (int)eyer;
                prevPos = _eyePosition + _effectiveRadius - deltaidx * denr;
            }
            
            tick.viewOffset = prevPos + denr;
            prevPos = prevPos + denr;
        }else
        {
            // inside the eye
            if ((i - eyel) < 1.0)
            {
                // first time getting into the eye region
                // delta index that are on the left side of eye (needed to be deducted for the inside eye position)
                deltaidx = eyel - (int)eyel;
                prevPos = _eyePosition - _effectiveRadius - deltaidx * denm;
            }
   
            tick.viewOffset = prevPos + denm;
            prevPos = prevPos + denm;
        }
    }
}

// set axis tick label font size
-(void)setTickLabelFonts:(BOOL)uniform
                   large:(float)large
                   small:(float)small
{
    _uniformFontSize = uniform;
    _fontSizeLarge = large;
    _fontSizeSmall = small;
    _fontSize_Remainder =small; 

    [self updateTickFonts];
    
    return ;
}

// update tick fonts
-(void)updateTickFonts
{
    // go over all ticks in ticks
    id obj;
    
    for (obj in ticks)
    {
        if ([obj isKindOfClass:[TRAxisTick class]] != TRUE)
        {
            // not TRAxisTick type of class
            continue;
        }
        
        TRAxisTick* tick = obj;
        
        if (tick.label == nil)
        {
            continue;
        }
        
        tick.label.fontSizeLarge = _fontSizeLarge;
        tick.label.fontSizeSmall = _fontSizeSmall;
        tick.label.fontSize_Remainder = _fontSize_Remainder;
        tick.label.maxNumberOfFullSizeLetters = _maxNumberOfFullSizeLetters;
        [tick.label updateAttributedString];
    }
}

@end
