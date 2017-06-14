//
//  ACirclePopup.h
//  AProgressBars
//
//  Created by hui wang on 7/6/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ACircleExtendBar.h"

@interface ACirclePopup : CAShapeLayer
{
    
}

// properties

// APathDrawWrap icon symbols for metrics
@property(strong, nonatomic)NSMutableDictionary* metricSymbols;

// Popup visual boundary
// center position in client area
@property(nonatomic) CGPoint origin;
// size of circle bars (radius distance of pie edge).  size <= min(frame.size.width, frame.size.heigth)
@property float size;
// distance from _origin to the center of circle symbol
@property float radius;
// prefered angle range for laying out the circle objects
@property float beginAngle;
@property float endAngle;
// gap between each pies
@property float gapAngle;

// animation settings
// symbol duration
@property float durationSymbol;
// pie chart duration
@property float durationPieChart;
// delay in between the circles
@property float delay;

// get show state
@property(readonly) BOOL isShow;

// methods
// add a layer to the list
-(int)addCircleLayer:(ACircleExtendBar*)layer;

// feed metric data (ABars) set.  see function "_createSampleBarCollections" 
-(void)setMetricCollections:(NSArray*)metricBarsCollection;

// calculate and return estimated size
-(float)estimateCircleRadius;

// create the object
- (id)initWith:(CGRect)frame
          show:(BOOL)show;

// show or hide it
-(BOOL)show:(BOOL)show;

// access to chart for the given key
-(APieBarChart*)getChart:(NSString*)key;

@end
