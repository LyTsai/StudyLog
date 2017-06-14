//
//  AGenieAnimate.h
//  AProgressBars
//
//  Created by hui wang on 7/26/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

// "genie" animation
@interface AGenieAnimate : NSObject

// animation functions:

// to use genie functions make sure you do following before calling the functios:
// (1) create the object to be aniamted and move it to the right location first
// (2) pass layer and parent view to animate

// "in"
-(void)genieMoveIn:(UIView*)view
             layer:(CALayer*)layer
          outSpace:(CGRect)outSpace
         homeSpace:(CGRect)homeSpace
          duration:(float)duration
        completion:(void (^)())completion;

// "out"
-(void)genieMoveOut:(UIView*)view
              layer:(CALayer*)layer
           outSpace:(CGRect)outSpace
          homeSpace:(CGRect)homeSpace
           duration:(float)duration
         completion:(void (^)())completion;

// move from to animation only
-(void)genieMoveFly:(UIView*)view
              layer:(CALayer*)layer
            toSpace:(CGRect)toSpace
          fromSpace:(CGRect)fromSpace
           duration:(float)duration
         completion:(void (^)())completion;
@end
