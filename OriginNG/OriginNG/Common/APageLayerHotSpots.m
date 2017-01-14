//
//  APageLayerHotSpots.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/23/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "APageLayerHotSpots.h"

@implementation APageLayerHotSpots
{
    // arrauy of ANHotSpot objects
    NSMutableArray *_spots;
    
    // hot spot at the center
    ANHotSpot* _center;
}

-(void)addHotSpot:(CGPoint)center
             size:(CGSize)size
{
    if (_spots == nil)
    {
        _spots = [[NSMutableArray alloc] init];
    }
    
    [_spots addObject:[[ANHotSpot alloc] initWith:center size:size]];
}

// set center hot spot
-(void)addCenter:(CGPoint)center
            size:(CGSize)size
{
    _center = [[ANHotSpot alloc] initWith:center size:size];
}

-(void)dealloc
{
    [self removeAllHotSpotSymbols];
}

-(id)init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    _spots = [[NSMutableArray alloc] init];
    _center = nil;
    
    return self;
}

-(NSInteger)numberOfHotSpots
{
    if (_spots == nil)
    {
        return 0;
    }
    return _spots.count;
}

-(ANHotSpot*)hotSpot:(NSInteger)index
{
    if (_spots== nil || index >= _spots.count)
    {
        return nil;
    }
    
    //[[_spots objectAtIndex:index] getValue:&hs];
    
    return [_spots objectAtIndex:index];
}

// center position
-(ANHotSpot*)center
{
    return _center;
}

// remove all hot spots
-(void)removeAllHotSpotSymbols
{
    int i, nHotSpots = [self numberOfHotSpots];
    
    for (i = 0; i < nHotSpots; i++)
    {
        ANHotSpot* hotSpot = [self hotSpot:i];
        
        if (hotSpot != nil && hotSpot.symbol != nil && hotSpot.symbol.superlayer != nil)
        {
            [hotSpot.symbol removeFromSuperlayer];
            hotSpot.symbol = nil;
        }
    }
    
    if (_center && _center.symbol && _center.symbol.superlayer)
    {
        [_center.symbol removeFromSuperlayer];
        _center.symbol = nil;
    }
}

// load APageLayerPath onto page at the given hot spot
-(void)setHotSpotSymbol:(NSInteger)index
                  symbo:(APageLayerPath*)symbol
{
    ANHotSpot* hotSpot = [self hotSpot:index];
    
    if (hotSpot != nil)
    {
        // we do have a valid hot spot for the given index
        CGRect spot = CGRectMake(hotSpot.center.x - hotSpot.size.width * .5, hotSpot.center.y - hotSpot.size.height * .5, hotSpot.size.width, hotSpot.size.height);
        
        [symbol loadOntoPage:self layout:spot];
        
        hotSpot.symbol = symbol;
    }
    
    return ;
}

// load APageLayerPath onto page at the center position
-(void)setCenterHotSpotSymbol:(APageLayerPath*)symbol
{
    ANHotSpot* hotSpot = [self center];
    
    if (hotSpot != nil)
    {
        // we do have a valid hot spot for the given index
        CGRect spot = CGRectMake(hotSpot.center.x - hotSpot.size.width * .5, hotSpot.center.y - hotSpot.size.height * .5, hotSpot.size.width, hotSpot.size.height);
        
        [symbol loadOntoPage:self layout:spot];
        
        hotSpot.symbol = symbol;
    }
}

// hit test.  -1 if no hitting
// point - in the same hot spot coordonate system.  caller has to make sure of this
-(int)hitTest:(CGPoint)point
{
    int ret = -1;
    int zIndex = -1;
    
    for (NSInteger i = 0; i < [self numberOfHotSpots]; i++)
    {
        ANHotSpot* hsRect = [self hotSpot:i];
        
        if (fabs(point.x - hsRect.center.x) < (hsRect.size.width / 2) && fabs(point.y - hsRect.center.y) < (hsRect.size.height / 2))
        {
            if (ret < 0 || hsRect.symbol == nil)
            {
                ret = i;
                
                if (hsRect.symbol)
                {
                    zIndex = hsRect.symbol.zPosition;
                }
                continue;
            }
                
            if (hsRect.symbol.zPosition > zIndex)
            {
                ret = i;
                zIndex = hsRect.symbol.zPosition;
            }
        }
    }
    
    return ret;
}


@end
