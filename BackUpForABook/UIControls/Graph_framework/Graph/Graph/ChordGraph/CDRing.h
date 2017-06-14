//
//  CDRing.h
//  ChordGraph
//
//  Created by Hui Wang on 6/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDRingSlice.h"
#import "CDConnection.h"

// CDRing represents one ring that has rows from each slices defined for the chord graph
@interface CDRing : NSObject{
    // NSArray of CDRingSlice
    NSMutableArray *slices;
}

// properties
// ring size along radius direction.  !!! size is in font unit.
@property(nonatomic)float size;

// TRUE - slices fall into the same slice visual space allocated by host.  otherwise evenly distributed over given ring space
@property(nonatomic)BOOL useHostLayout;
// visual gap between slice cells in angle degree.
@property(nonatomic)float gap;

// edge borders
// top / bottom edge border colors
@property(nonatomic)BOOL showTop;
@property(strong, nonatomic)UIColor* topEdgeColor;
@property(nonatomic)BOOL showBottom;
@property(strong, nonatomic)UIColor* bottomEdgeColor;

// methods
// here is your chance to compute the run time size
-(void)translateChildernFontSize:(float)pointsPerFontSize;
// get run time size
-(float)runtimeSize;

// slices
// create slices
-(void)createSlices:(int)nSlices;
// set ring slice
-(void)setSlice:(int)nSlice
          slice:(CDRingSlice*)slice;
// number of slices
-(int)numberOfSlices;
// get ring slice
-(CDRingSlice*)getSlice:(int)position;

// paint
// paint ring slice
-(void)paint:(CGContextRef)ctx
      radius:(float)radius
        size:(int)size
      center:(CGPoint)origin;


// hit test
// atPoint - point
// ring - ring index
// radius - ring radius
-(HitCDObj)hitTest:(CGPoint)atPoint
              ring:(int)ring
            radius:(float)radius
            center:(CGPoint)origin;
@end
