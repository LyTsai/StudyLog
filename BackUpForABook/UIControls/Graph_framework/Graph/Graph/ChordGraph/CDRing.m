//
//  CDRing.m
//  ChordGraph
//
//  Created by Hui Wang on 6/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDRing.h"

@implementation CDRing

// private data
float _runtimeSize;

-(id)init
{
    self = [super init];
    
    slices = nil;
    _gap = 1.0;
    _size = 16;
    
    _showTop = TRUE;
    _topEdgeColor = [UIColor darkGrayColor];
    _showBottom = FALSE;
    _bottomEdgeColor = [UIColor darkGrayColor];
    
    _runtimeSize = 1;
    
    return self;
}

// here is your chance to compute the run time size
-(void)translateChildernFontSize:(float)pointsPerFontSize
{
    _runtimeSize = _size * pointsPerFontSize;
}

// get run time size
-(float)runtimeSize
{
    return _runtimeSize;
}

// set number of slices
-(void)createSlices:(int)nSlices
{
    if (slices == nil)
    {
        slices = [[NSMutableArray alloc] initWithCapacity:nSlices];
    }else
    {
        [slices removeAllObjects];
    }
    
    // create slices for holding slice rings
    int i;
    
    for (i = 0; i < nSlices; i++)
    {
        [slices addObject:([[CDRingSlice alloc] init])];
    }
}

// set ring slice
-(void)setSlice:(int)nSlice
          slice:(CDRingSlice*)slice
{
    if (slices == nil)
    {
        slices = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    if ([slices objectAtIndex:nSlice] == nil)
    {
        [slices insertObject:([[CDRingSlice alloc] init]) atIndex:nSlice];
    }
}

// number of slices
-(int)numberOfSlices
{
    return slices.count;
}

// get ring slice
-(CDRingSlice*)getSlice:(int)position
{
    if (slices == nil || position >= slices.count)
    {
        return nil;
    }
    
    return [slices objectAtIndex:position];
}

// paint ring slice
-(void)paint:(CGContextRef)ctx
      radius:(float)radius
        size:(int)size
      center:(CGPoint)origin
{
    // save current context
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, .5);
    
    if (_showTop)
    {
        // top ring edge border
        CGContextSetStrokeColorWithColor(ctx, _topEdgeColor.CGColor);
        // get path
        UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:origin
                                                          radius:(radius + size)
                                                      startAngle:0
                                                        endAngle:2.0 * M_PI
                                                       clockwise:YES];
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circle.CGPath);
        CGContextDrawPath(ctx, kCGPathStroke);
    }
  
    if (_showBottom)
    {
        // bottom edge border
        UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:origin
                                                              radius:radius
                                                          startAngle:0
                                                            endAngle:2.0 * M_PI
                                                           clockwise:YES];
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circle.CGPath);
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    
    // restore the original contest
    CGContextRestoreGState(ctx);
    return ;
}

// hit test
// hit test
// atPoint - point
// ring - ring index
// radius - ring radius
-(HitCDObj)hitTest:(CGPoint)atPoint
              ring:(int)ring
            radius:(float)radius
            center:(CGPoint)origin
{
    HitCDObj hitObj;
    
    hitObj.hitObject = CDObjs_None;
    
    if (slices == nil)
    {
        return hitObj;
    }
    
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
    
    // within the ring range
    hitObj.hitObject = CDObjs_Ring;
    hitObj.ringIndex = ring;
    
    // go over all slices
    int i, j;
    bool within;
    for (i = 0; i < slices.count; i++)
    {
        if ([[slices objectAtIndex:i] isKindOfClass:[CDRingSlice class]] == FALSE)
        {
            continue;
        }
        
        CDRingSlice* oneSlice = [slices objectAtIndex:i];
        // hit test this slice
        within = (a >= oneSlice.right && a <= oneSlice.left) || ((a + 360) >= oneSlice.right && (a + 360) <= oneSlice.left);
        if (within == false)
        {
            // out of slice range
            continue;
        }
        
        hitObj.hitObject = CDObjs_Slice;
        hitObj.sliceIndex = i;
        // hit test all slice cells
        for (j = 0; j < oneSlice.cells.count; j++)
        {
            if ([[oneSlice.cells objectAtIndex:j] isKindOfClass:[CDCell class]] == FALSE)
            {
                continue;
            }
        
            CDCell* oneCell = [oneSlice.cells objectAtIndex:j];
        
            // hit test this cell
            within = (a >= oneCell.right && a <= oneCell.left) || ((a + 360) >= oneCell.right && (a + 360) <= oneCell.left);
            if (within)
            {
                hitObj.hitObject = CDObjs_Cell;
                hitObj.cellIndex = j;
                return hitObj;
            }
        }
    }
    
    return hitObj;
}

@end
