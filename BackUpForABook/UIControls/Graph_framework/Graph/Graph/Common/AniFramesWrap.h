//
//  AniFramesWrap.h
//  AProgressBars
//
//  Created by hui wang on 7/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AniFrames.h"

// generic base class for "warpping" a series of animating frames
@interface AniFramesWrap : CAShapeLayer
{
    
}

// properties:

// animation frequency
@property float interVal;

// methoids
// create with animation frames
-(id)initWith:(AniFrames*)animLayers;

// set up animation
-(void)initAnimation:(CGRect)frame 
            interVal:(float)interVal
             animate:(BOOL)animate;

// start / stop animation
-(BOOL)animate:(BOOL)animate;

@end
