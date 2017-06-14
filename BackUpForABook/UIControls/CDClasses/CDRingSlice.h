//
//  CDRingSlice.h
//  ChordGraph
//
//  Created by Hui Wang on 6/26/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "CDCell.h"
#import "CDSliceBackground.h"

// represents one collection (slice) of CDCell
@interface CDRingSlice : NSObject{
}

// properties
// label used for region title
@property(nonatomic)NSMutableString* label;
// cell collection
@property(strong, nonatomic)NSMutableArray* cells;
// show background?
@property(nonatomic)bool showBackground;
// background
@property(strong, nonatomic)CDSliceBackground *backgropund;
// space between slice cells
@property(nonatomic)float gap;

// init with given slice cells
-(id)initWith:(NSMutableArray*)cells;
// init from given slice
-(id)initFrom:(CDRingSlice*)slice;

// set number of cells
-(void)createCells:(int)nCells;
// get number of cells
-(int)numberOfCells;
// access to cess
-(CDCell*)cell:(int)nCell;

// gui properties
// visual space for this slice
// in angel degree
@property(nonatomic)SliceSize sizeStyle;
// maximum range if sizeStyle = SliceSize_Auto.  !!! in degree
@property(nonatomic)float maxSize;
// size if sizeStyle = SliceSize_Fixed.  !!! in degree
@property(nonatomic)float size;
// range (starting angle, width) or (left, right) being set dynamicly.  caller should not set this values
@property(nonatomic)float left;
@property(nonatomic)float right;

// call to make sure all visual changes are in sync with the internal data
-(void)onDirtyView;

// paint ring slice
-(void)paint:(CGContextRef)ctx
      center:(CGPoint)origin
      bottom:(float)bottom
         top:(float)top
 frameHeight:(int)height;

@end
