//
//  ACircleExtendBar.h
//  AProgressBars
//
//  Created by hui wang on 7/6/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h> 
#import "Utils.h"
#import "ABars.h"

#import "APathDrawWrap.h"
#import "APieBarChart.h"

// add all symbols here
#import "ASymbol_Heart.h"
#import "ASymbol_NewCholestrol.h"
#import "ASymbol_Diabetes.h"
#import "ASymbol_CVD.h"
#import "ASymbol_10_Year Survival.h"
#import "ASymbol_Stroke.h"

@interface ACircleExtendBar : CALayer
{
    @private
    
    // private members
    // pie bar archor center point
    CGPoint _center;
    // angle space for each bar
    float _deltaAngle;
    // size of current circle symbol
    float _symbolRadius;
}

// properties:
// The Circle extended bar is made up with following components:
// (1) The circle icon at the end
@property(strong, nonatomic)APathDrawWrap* symbol;
// pir bar chart object
@property APieBarChart* pieChart;

// angle ragne of pie bar
@property float beginAngle;
@property float endAngle;
// size of pie bar
@property float bottom;
@property float top;
// gap between barchart bars
@property float barGap;

// center position of circle symbol (to read for animation purpose)
@property(readonly)CGPoint symbolPos;

// method
// object inititalization
// frame - set to frame area of parent layer
// keyName - key for identify this bar layer
// displayName - display name of this bar collection
// bars - 
// symbol - the circle symbol layer object
// symbolRadius - inital size of circle symbol
// symbolRadiusDis - initial location of symbol from the center
// barRadius - size of full bar (range)
// barGap - gap between bars
-(id)initWith:(CGRect)frame
      keyName:(NSString*)keyName
  displayName:(NSString*)displayName
         bars:(ABars*)bars
       symbol:(APathDrawWrap*)symbol
 symbolRadius:(float)symbolRadius
       bottom:(float)bottom
          top:(float)top
       barGap:(float)barGap;

// setup bar layout
// beginAngle, endAngle - range for this pie bars collection 
-(void)autoLayout:(float)beginAngle
         endAngle:(float)endAngle;
@end
