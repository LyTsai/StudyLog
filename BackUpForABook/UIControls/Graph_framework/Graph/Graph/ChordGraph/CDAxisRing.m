//
//  CDAxisRing.m
//  ChordGraph
//
//  Created by Hui Wang on 6/28/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDAxisRing.h"

@implementation CDAxisRing

// private data
float _runtimeSize_axis;

-(id)init
{
    self = [super init];
    
    _size = 0;
    _runtimeSize_axis = 1.0;
    
    return self;
}

// here is your chance to compute the run time size
-(void)translateChildernFontSize:(float)pointsPerFontSize
{
    _runtimeSize_axis = _size * pointsPerFontSize;
}

// get run time size
-(float)runtimeSize
{
    return _runtimeSize_axis;
}

// hit test
-(HitCDObj)hitTest:(CGPoint)atPoint
            radius:(float)radius
            center:(CGPoint)origin
{
    HitCDObj hitObj;
    
    hitObj.hitObject = CDObjs_None;
    
    /*
    if (slices == nil)
    {
        return hitObj;
    }
    */
    
    float width = [self runtimeSize];
    float r1, r2;
    
    // convert atPoint to position in (angle, radius) coordinate position first
    CGFloat r = hypotf(atPoint.x - origin.x, atPoint.y - origin.y);
    float a = 180.0 * atan(-(atPoint.y - origin.y) / (atPoint.x - origin.x)) / 3.14;
    
    if ((atPoint.x - origin.x) < 0)
    {
        a += 180;
    }
    
    if (a < .0)
    {
        a += 360.0;
    }
    
    r1 = radius;
    r2 = r1 + width;
    
    if (r < r1 || r > r2)
    {
        // out of ring range
        return hitObj;
    }
    
    /*
    // go over all slice axis
    int i, j;
    for (i = 0; i < slices.count; i++)
    {
        if ([[slices objectAtIndex:i] isKindOfClass:[CDRingSlice class]] == FALSE)
        {
            continue;
        }
        
        CDRingSlice* oneSlice = [slices objectAtIndex:i];
        // hit test this slice
        if (a < oneSlice.right || a > oneSlice.left)
        {
            // out of slice range
            continue;
        }
        
     }
     */
    
    return hitObj;
}

@end
