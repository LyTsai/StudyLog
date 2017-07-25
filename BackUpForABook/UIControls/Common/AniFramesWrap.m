//
//  AniFramesWrap.m
//  AProgressBars
//
//  Created by hui wang on 7/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "AniFramesWrap.h"

@interface AniFramesWrap (PrivateMethods)

-(void)startAnimation;

-(void)stopAnimation;

-(void)tick;

-(void)updateShowLayerAnimated:(BOOL)animated;

-(void)showLayer:(CALayer*)layer
        duration:(float)duration
            show:(BOOL)show
        animated:(BOOL)animated;

@end

@implementation AniFramesWrap
{
    @private
    
    // animation state
    BOOL _animt;
    
    // access of APathDrawWrap frames for animation purpose
    AniFrames* _animLayers;
    
    // current "show" frame
    int _showIndex;
    
    // timer for animation
    NSTimer* _timer;
}

// create with animation frames
-(id)initWith:(AniFrames*)animLayers
{
    self = [super init];
    
    _animLayers = animLayers;
    
    return self;
}

// set up animation
-(void)initAnimation:(CGRect)frame 
            interVal:(float)interVal
             animate:(BOOL)animate
{
    self.frame = frame;
    
    _interVal = interVal;
    _showIndex = 0;
    _animt = FALSE;
    _timer = nil;
    
    // setup all animation layers
    if (_animLayers != nil)
    {
        for (APathDrawWrap* animLayer in [_animLayers getAnimLayers])
        {
            if (animLayer == nil)
            {
                continue;
            }
            
            // hide
            animLayer.opacity = .0;
            
            // resize to bound area
            animLayer.frame = self.bounds;
            
            // add into sublayer
            [self addSublayer:animLayer];
        }
        
        // make sure layer with _showIndex is shown
        CALayer* showLayer = [[_animLayers getAnimLayers] objectAtIndex:_showIndex];
        showLayer.opacity = 1.0;
    }
    
    [self animate:animate];
    
    // test
    // self.backgroundColor = [UIColor grayColor].CGColor;
}

// start / stop animation
-(BOOL)animate:(BOOL)animate
{
    if (animate == TRUE)
    {
        [self startAnimation];
    }else
    {
        [self stopAnimation];
    }
    
    _animt = animate;
    
    return _animt;
}

-(void)startAnimation
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interVal
                                              target:self
                                            selector:@selector(tick)
                                            userInfo:nil
                                             repeats:YES];
}

-(void)stopAnimation
{
    [_timer invalidate];
}

-(void)tick
{
    [self updateShowLayerAnimated:YES];
}

-(void)updateShowLayerAnimated:(BOOL)animated
{
    if (_animLayers == nil || [_animLayers getAnimLayers].count == 0)
    {
        return ;
    }
    
    _showIndex = _showIndex % [_animLayers getAnimLayers].count;
    
    // hide curent one
    CALayer* curLayer = [[_animLayers getAnimLayers] objectAtIndex:_showIndex];
    
    // show next
    _showIndex = (_showIndex + 1) % [_animLayers getAnimLayers].count;
    CALayer* nextLayer = [[_animLayers getAnimLayers] objectAtIndex:_showIndex];
    
    // hide curent one first
    [self showLayer:curLayer duration:.5 * _interVal show:FALSE animated:TRUE];
    
    // show next one
    [self showLayer:nextLayer duration:.5 * _interVal show:TRUE animated:TRUE];
}

-(void)showLayer:(CALayer*)layer
        duration:(float)duration
            show:(BOOL)show
        animated:(BOOL)animated
{
    if (animated)
    {
        CABasicAnimation *animation = [CABasicAnimation animation];
        
        animation.keyPath = @"opacity";
        animation.fromValue = [NSNumber numberWithFloat:show == TRUE ? .0 : 1.0];
        animation.toValue = [NSNumber numberWithFloat:show == TRUE ? 1.0 : 0.0];
        animation.duration = duration;
        animation.delegate = self;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;

        
        [animation setValue:layer forKey:@"animationlayer"];
        
        [layer addAnimation:animation forKey:nil];
    }else
    {
        layer.opacity = show == TRUE ? 1.0 : 0.0;
    }
}

// delegate functions
-(void)animationDidStop:(CABasicAnimation *)animation finished:(BOOL)flag
{
    APathDrawWrap* layerDraw = [animation valueForKey:@"animationlayer"];
    
    if (layerDraw == nil)
    {
        return ;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    layerDraw.opacity = [animation.toValue floatValue];
    
    [CATransaction commit];
}

@end
