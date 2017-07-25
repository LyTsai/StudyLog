//
//  ACircularBar.h
//  AProgressBars
//
//  Created by hui wang on 7/21/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ABars.h"

#import "APathDrawWrap.h"

// define chart style

// represents class for a circular bar chart
@interface ACircularBarChart : CALayer
{
    @private
    
}

// properties
// bar data set
@property(strong, nonatomic)ABars* bars;
// name for id purpose of this bar chart.  the same as bars.key and bars.metricName 
@property NSString* keyName;
// name for display purpose
@property NSString* displayName;

// visual presentation
// bar width
@property int barSize;
// "empty" bar background color
@property(strong, nonatomic)UIColor* emptyBarColor;

// object createtion
-(id)initWith:(ABars*)bars
      keyName:(NSString*)keyName
  displayName:(NSString*)displayName
      barSize:(int)barSize;

@end
