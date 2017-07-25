//
//  TRRowAxis.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRAxis.h"
#import "Define.h"
#import "DSSlider.h"

@interface TRRowAxis : TRAxis

// slider bar
// show or hide slider bar for "fish eye" like axis tick repositioning
@property(nonatomic)BOOL showBar;
// the slider bar object
@property(strong, nonatomic)DSSlider *slider;

// paint axis
// start, end - range of visual space
// angle - axis direction
// tickoffset - tick offset away form the axis 0 ground
// origin - center point of ring
-(void)paint:(CGContextRef)ctx
startPosition:(float)start
 endPosition:(float)end
       angle:(float)angle
      offset:(float)offset
      center:(CGPoint)origin
 frameHeight:(int)height;

// show the sloder bar
-(void)paintSliderBar:(CGContextRef)ctx
        startPosition:(float)start
          endPosition:(float)end
                angle:(float)angle 
               center:(CGPoint)origin;

// hit test.  Potential hit objects: slider, begin arrow and end arrow
-(HitObj)HitTest:(CGPoint)atPoint
           angle:(float)angle
         barSize:(float)size
          center:(CGPoint)origin;

@end
