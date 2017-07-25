//
//  CDRingSlice.m
//  ChordGraph
//
//  Created by Hui Wang on 6/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDRingSlice.h"

@implementation CDRingSlice

-(id)init
{
    self = [super init];
    
    _cells = nil;
    _backgropund = [[CDSliceBackground alloc] init];
    _sizeStyle = SliceSize_Auto;
    _maxSize = 180.0;
    _size = 90.0;
    _gap = .5;
    _showBackground = FALSE;
    
    return self;
}

// init with given slice cells
-(id)initWith:(NSMutableArray*)cells
{
    // make sure cells are of CDCell type
    int i;
    
    for (i = 0; i < cells.count; i++)
    {
        if ([[cells objectAtIndex:i] isKindOfClass:[CDCell class]] != TRUE)
        {
            return nil;
        }
    }
    
    self = [super init];
    _cells = [[NSMutableArray alloc] initWithArray:cells copyItems:TRUE];
    return self;
}

// init from given slice
-(id)initFrom:(CDRingSlice*)slice
{
    // make sure cells are of CDCell type
    int i;
    
    for (i = 0; i < slice.cells.count; i++)
    {
        if ([[slice.cells objectAtIndex:i] isKindOfClass:[CDCell class]] != TRUE)
        {
            return nil;
        }
    }

    self = [super init];
    _cells = [[NSMutableArray alloc] initWithArray:slice.cells copyItems:TRUE];
    return self;
}

// set number of cells
-(void)createCells:(int)nCells
{
    if (_cells != nil)
    {
        [_cells removeAllObjects];
    }else
    {
        _cells = [[NSMutableArray alloc] initWithCapacity:nCells];
    }
    
    int i;
    
    for (i = 0; i < nCells; i++)
    {
        [_cells addObject:[[CDCell alloc] init]];
    }
}

// get number of cells
-(int)numberOfCells
{
    return _cells.count;
}

// access to cess
-(CDCell*)cell:(int)nCell
{
    if (_cells == nil || nCell >= _cells.count)
    {
        return nil;
    }
    return [_cells objectAtIndex:nCell];
}

// call to make sure all visual changes are in sync with the internal data
-(void)onDirtyView
{
    // compute the positions and size for each cell
    // the cells are distributed within the range (left, right)
    int i;
    
    if ([self numberOfCells] <= 0)
    {
        return ;
    }
    
    float totalWeight = 0.0;
    for (i = 0; i < [self numberOfCells]; i++)
    {
        totalWeight += [self cell:i].sizeWeight;
    }
    
    float density = (_left - _right - _gap * (_cells.count - 1)) / totalWeight;
    
    float start = _right;
    for (i = 0; i < [self numberOfCells]; i++)
    {
        [self cell:i].right = start;
        [self cell:i].left = start + density * [self cell:i].sizeWeight;
  
        start = [self cell:i].left + _gap;
    }
    
    // update all cells
    for (i = 0; i < [self numberOfCells]; i++)
    {
        [[self cell:i] onDirtyView];
    }
}

// paint ring slice
-(void)paint:(CGContextRef)ctx
      center:(CGPoint)origin
      bottom:(float)bottom
         top:(float)top
 frameHeight:(int)height
{
    // save current context
    CGContextSaveGState(ctx);

    if (_showBackground)
    {
        // paint ring slice back ground first
        Slice size;
    
        size.left = _left;
        size.right = _right;
        size.bottom = bottom;
        size.top = top;
    
        [_backgropund paint:ctx layout:size center:origin];
    }
    
    // paint ring slice cells
    int i;
    for (i = 0; i < _cells.count; i++)
    {
        [[_cells objectAtIndex:i] paint:ctx center:origin bottom:bottom top:top frameHeight:height];
    }
    
    // restore the original contest
    CGContextRestoreGState(ctx);
}

@end
