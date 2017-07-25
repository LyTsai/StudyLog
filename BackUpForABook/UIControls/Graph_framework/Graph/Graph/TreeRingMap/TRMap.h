//
//  TRMap.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/20/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "TRSlice.h"
#import "TRMLabels.h"
#import "TRLegend.h"
#import "TRCenterLabel.h"

@interface TRMap : UIControl{
    // collection of tree ring slices
    NSMutableArray *allSlices;
}

// properties:

// off screen drawing
@property(nonatomic)BOOL offscreen;

// current tree ring map size information
// tree ring map origin position
// center
@property(readonly, nonatomic)CGPoint origin;
// inner and outside radius
@property(readonly, nonatomic)float min;
@property(readonly, nonatomic)float max;

// you set the font size
@property(nonatomic)float fontSize;

// label in the center
@property(strong, nonatomic)TRCenterLabel* centerLabel;

// lables on the map (left top)
@property(strong, nonatomic)TRMLabels* lables;
// legend on thje map (left top, or right bottom)
@property(strong, nonatomic)TRLegend* legend;
// date on the map (right top)
@property(strong, nonatomic)TRMLabels* date;
// note on the right bottom
@property(strong, nonatomic)TRMLabels* notes;

// set size of tree ring map
// !!! caller needs to decide when to call onDirtyView to make sure the view and data table are in sync
// !!! you may call with position and size of tree ring map
// !!! make sure the control is set with frame size first
// min, max - radius for the two ring map edges
-(void)setTRSize:(CGPoint)origin
             min:(float)min
             max:(float)max;

// !!! or you may let the control to find out the best settings by setting these properties instead:
// !!! after setting inner and outer space in font point size you only need to call: autoResize
// radius of inner circle at the center of tree ring map
@property(nonatomic)float innerSpace;
// space between tree ring out most ring and bound
@property(nonatomic)float outerSpace;

-(void)autoResize:(CGRect)size;
-(void)autoFit;

// compose tree ring map by passing a set of tree slice angle positions.  usually called at initialization phase to create initial tree ring slices
-(void)composeTreeRingMap:(NSArray*)slicePositions;
// call to make sure tree ring slices are all in sync between view and data set
-(void)onDirtyView;

// get number of slices
-(int)numberOfSlices;
// access to ring slice
-(TRSlice*)getSlice:(int)position;
@end
