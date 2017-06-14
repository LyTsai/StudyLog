//
//  ACircleBarPanel.h
//  AProgressBars
//
//  Created by hui wang on 7/21/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ACircularBarChart.h"
 
@interface ACircleBarPanel : CAShapeLayer
{
    
}

// properties

// seperation between chart
@property int gap;
// default bar size of each chart
@property int barSize;

// animation settings

// get show state
@property(readonly) BOOL isShow;

// add one circle bar chart into collection
-(int)addCircleBarChartLayer:(ACircularBarChart*)layer;

// feed metric data (ABars) set.  see function "_createSampleBarCollections"
-(void)setMetricCollections:(NSArray*)metricBarsCollection;

// create the object
- (id)initWith:(CGRect)frame
          show:(BOOL)show;

// show or hide it
-(BOOL)show:(BOOL)show;

// access to chart
-(ACircularBarChart*)getChart:(NSString*)key;

@end
