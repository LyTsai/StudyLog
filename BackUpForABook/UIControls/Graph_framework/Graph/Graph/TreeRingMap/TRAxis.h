//
//  TRAxis.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/24/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "TRAxisTick.h"

@interface TRAxis : NSObject{
     AxisTickStyle axStyle;
    // min, max values that define the axis view position
    // for example, if this is angle axis the {0.0, 180} of {min, max} defines the
    // angle range for this axis.  if this is the row axis then {min, max} defines the
    // point size for the view layout range etc
    // total value range mapped for this axis
    float min;
    float max;
    int numberOfTicks;
    // value range for axis ticks (in the same unit as min and max)
    float firstTickValue;
    float lastTickValue; 
    // array of TRAxisTick object that includes following information:
    // unit, position, string, drawing style
    NSMutableArray *ticks;
}

// unit font size
@property(nonatomic)float pointsPerFontSize;

// font size information for the remainder label
// for uniform font the size are the same otherwise the size will be scaled between
// fontSizeLarge and fontSizeSmall between two ends of row axis
@property(nonatomic)BOOL uniformFontSize;
@property(nonatomic)float fontSizeLarge;
@property(nonatomic)float fontSizeSmall;
@property(nonatomic)float fontSize_Remainder;

// position starting which attrRemainderDictionary attributes will be used
@property(nonatomic)int maxNumberOfFullSizeLetters;

// start and end of axis value range
@property(nonatomic) float min;
@property(nonatomic) float max;
@property(nonatomic) float firstTickValue;
@property(nonatomic) float lastTickValue;
@property(readonly, nonatomic) int numberOfTicks;
// show label
@property(nonatomic)BOOL showLable;
// show ticks
@property(nonatomic)BOOL showTicks;
// color of tick
@property(strong,nonatomic)UIColor* tickColor;
// thickness of tick line
@property(nonatomic)float tickSize;
// height of tick
@property(nonatomic)float height;
// tick lable orientation (horizantal or radius direction)
@property(nonatomic)TickLableOrientation tickLableDirection;
// space between axis and axis label
@property(nonatomic) int spaceBetweenAxisAndLable;

// space margin for tick lables.  this defines the maximum distance (area) from ring border for showing lables
@property(nonatomic)float labelMargin;

// disable / enable fishy eye
@property(nonatomic) BOOL fishyEye;
// position of fish eye in view space unit
@property(nonatomic) float eyePosition;
// radius of fish eye circle
@property(nonatomic) float eyeRadius;
// number of axis ticks to be put on the radius
@property(nonatomic) int eyeTicks;

// methods of getting axis information
// return label view position for the given index.  called when drawing the axis
-(float)position:(int)index;
// return tick object at given index
-(TRAxisTick*)tick:(int)index;

// methods of setting up axis ticks
// set axis style
-(void)setTickStyle:(AxisTickStyle)style;

// call to reset visual display space and first , last tick positions and tick lables
// tickLabels - array of NSString 
-(BOOL)setAxisTicks:(float)axMin
                max:(float)axMax
         tickLabels:(NSArray*)tickLabels
     firstTickValue:(float)firstTick
      lastTickValue:(float)lastTick;

// was fish eye needed for scaling?
-(bool)fishEyeNeeded;

// set axis tick label font size
-(void)setTickLabelFonts:(BOOL)uniform
                   large:(float)large
                   small:(float)small;

// call to reflect the current axis settings after setting up axis tick parameters
-(void)reSize;

@end
