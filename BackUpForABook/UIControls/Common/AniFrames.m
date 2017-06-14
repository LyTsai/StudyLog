//
//  AniFrames.m
//  AProgressBars
//
//  Created by hui wang on 7/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "AniFrames.h"

@implementation AniFrames
{
    @private
    
    // collection of APathDrawWrap frames for animation purpose
    NSMutableArray* _layers;
}

// add frames in order
-(int)addAnimLayer:(APathDrawWrap*) animLayer
{
    if (_layers == nil)
    {
        _layers = [[NSMutableArray alloc] init];
    }
    
    // add into collection
    [_layers addObject:animLayer];
    
    return _layers.count;
}

// remove all animation layers
-(void)removeAnimLayers
{
    [_layers removeAllObjects];
}

// access to animation layers
-(NSArray*)getAnimLayers
{
    return _layers;
}

@end
