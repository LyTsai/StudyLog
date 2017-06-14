//
//  AniFrames.h
//  AProgressBars
//
//  Created by hui wang on 7/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APathDrawWrap.h" 

// has collection of APathDrawWrap object for frame animation
@interface AniFrames : NSObject
{
    
}

// add frames in order
-(int)addAnimLayer:(APathDrawWrap*) animLayer;

// remove all animation layers
-(void)removeAnimLayers;

// access to APathDrawWrap animation layers
-(NSArray*)getAnimLayers;

@end
