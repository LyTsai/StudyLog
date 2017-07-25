//
//  APieBarChart.h
//  AProgressBars
//
//  Created by hui wang on 7/18/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ABars.h"

// class represnting one slice of pie bar chart that combined with symboal to make object AcircleExtentBar for one metric
@interface APieBarChart : CALayer
{
    @private
    
    // private members
    // pie bar archor center point
    CGPoint _center;
    // angle space for each bar
    float _deltaAngle;
}

// properties
@property(strong, nonatomic)ABars* bars;
// name for id purpose of this bar chart group.  the same as bars.key and bars.metricName
@property NSString* keyName;
// name for display purpose
@property NSString* displayName;

// bar visual range for mapping the metric values
// range for this pie bars collection
@property float beginAngle;
@property float endAngle;
@property float barBeginRadius;
@property float barEndRadius;
// "gap between bars"
@property float barGap;
// base in case of laying behind a symboal.  has value of _symbolRadius. zero most of the case
@property float barBias;


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
       barGap:(float)barGap;

// setup bar layout
// beginAngle, endAngle - range for this pie bars collection
// barBeginRadius, barEndRadius - size of the bar
-(void)autoLayout:(float)beginAngle
         endAngle:(float)endAngle
   barBeginRadius:(float)barBeginRadius
     barEndRadius:(float)barEndRadius;

@end
