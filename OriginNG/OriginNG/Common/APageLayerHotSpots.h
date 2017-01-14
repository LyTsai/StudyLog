//
//  APageLayerHotSpots.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 10/23/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "APageLayerPath.h"
#import "ANHotSpot.h"

// used for passing hot spot location
typedef struct
{
    // hot spot center position
    CGPoint _center;
    // size of hot spot
    CGSize _size;
    // Hui !!! To do
    // "center of mass" position for hot spot archoring
    // !!! note that this will be used to assign each node (hot spot) to the cluster that centered around cluster center
    CGPoint _archor;
    // hot spot vector distance from archor ratio when sizing the container:
    // vector = {_center - _archor}
    // new postion: _center = _center + _archor_ratio * vector
    float _archor_ratio;
    // hot spot size ratio depending on the distance from archor point:
    // new size: _size = _size + _size_ratio * sizing ratio
    float _size_ratio;
}HOTSPOT;

// a layer of drawing path with hot spots
@interface APageLayerHotSpots : APageLayerPath

///////////////////////////////////////////////////////////
// access to hopt spots used by user of hot spot
///////////////////////////////////////////////////////////
// get desired upper limits of hot spots
-(NSInteger)numberOfHotSpots;

// hot spots in layer's coordinate
-(ANHotSpot*)hotSpot:(NSInteger)index;
-(ANHotSpot*)center;

///////////////////////////////////////////////////////////
// hot spot creation used by hot spot provider
///////////////////////////////////////////////////////////

// fill in with hot spots 
-(void)addHotSpot:(CGPoint)center size:(CGSize)size;
// set center hot spot
-(void)addCenter:(CGPoint)center size:(CGSize)size;

///////////////////////////////////////////////////////////
// called by user to put symbol on hot spot
///////////////////////////////////////////////////////////

// load APageLayerPath onto page at the given hot spot
-(void)setHotSpotSymbol:(NSInteger)index
                  symbo:(APageLayerPath*)symbol;


// load APageLayerPath onto page at the center position
-(void)setCenterHotSpotSymbol:(APageLayerPath*)symbol;

// free up symbol resources
-(void)removeAllHotSpotSymbols;

// hit test.  return the hot spot being hit. -1 if no hitting
// point - in the same hot spot layer's coordonate system.  caller has to make sure of this
-(int)hitTest:(CGPoint)point;

@end
