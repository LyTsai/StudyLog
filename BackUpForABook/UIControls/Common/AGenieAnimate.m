//
//  AGenieAnimate.m
//  AProgressBars
//
//  Created by hui wang on 7/26/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "AGenieAnimate.h"
#import "UIView+Genie.h"

@implementation AGenieAnimate
{
    @private
    
}

// "in"
-(void)genieMoveIn:(UIView*)view
             layer:(CALayer*)layer
          outSpace:(CGRect)outSpace
         homeSpace:(CGRect)homeSpace
          duration:(float)duration
        completion:(void (^)())completion
{
    // "refresh" and detach layer
    layer.hidden = TRUE;
    [layer removeFromSuperlayer];
    layer.hidden = FALSE;

    // set to layer's frame
    UIView* _genieView = [[UIView alloc] initWithFrame:outSpace];
    
    // add to the same view as animated layer
    [view addSubview:_genieView];
    
    // attach layer to genieView
    [_genieView.layer addSublayer:layer];
    
    // !!! move layer to {0, 0} orogin
    layer.frame = _genieView.bounds;
    
    // desice the BCRectEdge type based on relative position between homeSpace and outSpace
    BCRectEdge side = BCRectEdgeRight;
    
    if ((outSpace.origin.x + outSpace.size.width) > (homeSpace.origin.x + homeSpace.size.width))
    {
        side = BCRectEdgeRight;
    }else if ((outSpace.origin.x + outSpace.size.width) < (homeSpace.origin.x))
    {
        side = BCRectEdgeLeft;
    }else if ((outSpace.origin.y + outSpace.size.height) > (homeSpace.origin.y + homeSpace.size.height))
    {
        side = BCRectEdgeBottom;
    }else
    {
        side = BCRectEdgeTop;
    }
    
    
    [_genieView genieInTransitionWithDuration:duration
                              destinationRect:homeSpace
                              destinationEdge:side
                                   completion:completion];
    
    // recover
    [_genieView removeFromSuperview];
    [layer removeFromSuperlayer];
    
    // done
    _genieView = nil;
}

// "out"
-(void)genieMoveOut:(UIView*)view
              layer:(CALayer*)layer
           outSpace:(CGRect)outSpace
          homeSpace:(CGRect)homeSpace
           duration:(float)duration
         completion:(void (^)())completion;
{
    // "refresh" and detach layer
    layer.hidden = TRUE;
    [layer removeFromSuperlayer];
    layer.hidden = FALSE;
    
    // set to layer's frame
    UIView* _genieView = [[UIView alloc] initWithFrame:outSpace];
    
    // add to the same view as animated layer
    [view addSubview:_genieView];
    
    // attach layer to genieView
    [_genieView.layer addSublayer:layer];
    
    // !!! move layer to {0, 0} orogin
    layer.frame = _genieView.bounds;
    
    // desice the BCRectEdge type based on relative position between homeSpace and outSpace
    BCRectEdge side = BCRectEdgeRight;
    
    if ((outSpace.origin.x + outSpace.size.width) > (homeSpace.origin.x + homeSpace.size.width))
    {
        side = BCRectEdgeRight;
    }else if ((outSpace.origin.x + outSpace.size.width) < (homeSpace.origin.x))
    {
        side = BCRectEdgeLeft;
    }else if ((outSpace.origin.y + outSpace.size.height) > (homeSpace.origin.y + homeSpace.size.height))
    {
        side = BCRectEdgeBottom;
    }else
    {
        side = BCRectEdgeTop;
    }

    [_genieView genieOutTransitionWithDuration:duration
                                     startRect:homeSpace
                                     startEdge:side
                                    completion:completion];
    
    // recover
    [layer removeFromSuperlayer];
    [_genieView removeFromSuperview];
    
    // done
    _genieView = nil;
}

// move from to animation only.  !!!  call genieOutTransitionWithDuration to make sure that the view will be shown after the animation
-(void)genieMoveFly:(UIView*)view
              layer:(CALayer*)layer
            toSpace:(CGRect)toSpace
          fromSpace:(CGRect)fromSpace
           duration:(float)duration
         completion:(void (^)())completion
{
    // set to layer's frame
    UIView* _genieView = [[UIView alloc] initWithFrame:toSpace];
    
    // add to the same view as animated layer
    [view addSubview:_genieView];
    
    // save information for later recovery
    CALayer* parent = layer.superlayer;
    CGRect layerFrame = layer.frame;
    
    // attach layer to genieView
    [_genieView.layer addSublayer:layer];
    
    // !!! move layer to {0, 0} orogin
    layer.frame = _genieView.bounds;
    
    // desice the BCRectEdge type based on relative position between homeSpace and outSpace
    BCRectEdge side = BCRectEdgeRight;
    
    if ((toSpace.origin.y + toSpace.size.height) < fromSpace.origin.y)
    {
        side = BCRectEdgeTop;
    }else if ((fromSpace.origin.y + fromSpace.size.height) < toSpace.origin.y)
    {
        side = BCRectEdgeBottom;
    }else if ((fromSpace.origin.x + fromSpace.size.width) < toSpace.origin.x)
    {
        side = BCRectEdgeRight;
    }else if ((toSpace.origin.x + toSpace.size.width) < (fromSpace.origin.x))
    {
        side = BCRectEdgeLeft;
    }
    
    [_genieView genieOutTransitionWithDuration:duration
                                     startRect:fromSpace
                                     startEdge:side
                                    completion:completion];
    // detach
    [layer removeFromSuperlayer];
    [_genieView removeFromSuperview];
    
    // recover: parent, frame and transform
    if (parent)
    {
        [parent addSublayer:layer];
    }
    layer.frame = layerFrame;
    
    // done
    _genieView = nil;
}

@end
