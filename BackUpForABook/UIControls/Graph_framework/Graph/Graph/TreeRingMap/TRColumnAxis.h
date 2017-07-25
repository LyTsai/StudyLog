//
//  TRColumnAxis.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "TRAxis.h"
#import "Define.h"
#import "DSArrow.h"
#import "DSSlider.h"
#import "DSCircle.h"
#import "TRSliceRing.h"
#import "TRSliceTitle.h"

@interface TRColumnAxis : TRAxis

// properties

// "fishy eye" slider bar and resize bar (or arrows)
// slider bar (on the ring)
// show or hide slider bar
@property(nonatomic)BOOL showBar;
@property(strong, nonatomic)DSSlider *slider;

// draw arrow shape at begin and end of borader
@property(nonatomic)BOOL showBeginArrow;
@property(strong, nonatomic)DSArrow *beginArrow;
@property(nonatomic)BOOL showEndArrow;
@property(strong, nonatomic)DSArrow *endArrow;

// draw "circle" resize bar at the "begin" position which means drawing on the right edge of the slice
@property(strong, nonatomic)DSCircle *circleBar;

// axis ring (hosting column title)
@property(strong, nonatomic)TRSliceRing *ring;

// axis title
@property(strong, nonatomic)TRSliceTitle* title;

// show and hide axis tick lables
@property(nonatomic) BOOL showTickLabels;
 
// paint column axis
// start - start angle of visual space
// end - end angle of visual space.  defines the visual area for the tree ring map to be mapped onto
// radius - postion along radius
// size - outside ring bar size
// origin - tree ring center
// height - hosting window height for flipping along y direction
// circleBarOnRight - true if need to draw circle bar on the right board line
-(void)paint:(CGContextRef)ctx
  startAngle:(float)start
    endAngle:(float)end
      radius:(float)radius
     barSize:(float)size
      center:(CGPoint)origin
 frameHeight:(int)height
circleBarOnRight:(BOOL)circleBarOnRight;

// hit test.  Potential hit objects: slider, begin arrow and end arrow
-(HitObj)HitTest:(CGPoint)atPoint
          radius:(float)radius
         barSize:(float)size
          center:(CGPoint)origin;

@end
