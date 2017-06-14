//
//  TRSlice.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/20/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRSliceBackground.h"
#import "TRRowAxis.h"
#import "TRColumnAxis.h"
#import "TRSliceGrid.h"
#import "TRDataTableSliceView.h"
#import "TRCellTip.h"

// Tree ring slice represents the basic componet that are used to build tree ring map
// it povide the layout for hosting table content and cell drawing objects.
//  A tree ring ap is made of collection of such tree ring slices

// default tree ring map slice view styles
typedef enum
{
    SliceViewStyle_0,       // original default
    SliceViewStyle_1,       // default 1
    SliceViewStyle_2        // default 2
}SliceViewStyle;

@interface TRSlice : NSObject{
    
    // table data elements with cell presentation information
    TRDataTableSliceView *table;
    
    // origin position
    CGPoint origin;
    
    // total visual area of grid.  !! in point unit not font size.
    Slice size;
    
    // background painting object
    TRSliceBackground *background;
    
    // slice grid painting object that knows where to put visual presentation of table elements
    TRSliceGrid *grid;
    
    // Grid dimension:
    // axis along the ring direction (or row position)
    TRRowAxis *ringAxis;
    
    // axis along the angle positions (or column position)
    TRColumnAxis *angleAxis;
}

// reference to host view layer
@property(strong, nonatomic) CALayer *parent;

// GUI properties
// rect size of root frame for coordinate system adjustment (left, bottom) => (left, top)
@property(nonatomic)CGRect hostFrame;
// grid visual size in point unit instead of font size
@property(nonatomic)Slice size;
// origin of this slice
@property(nonatomic)CGPoint origin;

// unit font size
@property(nonatomic)float pointsPerFontSize;

// data table object.  table of row and column
@property(strong, nonatomic)TRDataTableSliceView *table;

// slice background object
@property(strong, nonatomic)TRSliceBackground *background;

// slice grid
@property(strong, nonatomic)TRSliceGrid *grid;

// ring axis.  axis along the ring direction (or row position)
@property(strong, nonatomic)TRRowAxis* ringAxis;

// angle axis.  axis along the angle positions (or column position)
@property(strong, nonatomic)TRColumnAxis* angleAxis;

// draw row slider bar one the left or right axis
@property(nonatomic)BarPosition rowBarStyle;

// show and hide row axis tick lables on specified side
@property(nonatomic)BOOL rowLabelOnLeft;
@property(nonatomic)BOOL rowLabelOnRight;

// slice border style that can be setup for the use of either the divider between
// two slices or the x-axis edge bars
@property(strong, nonatomic)UIColor *borderColor;
@property(strong, nonatomic)UIColor *borderInnerColor;
@property(strong, nonatomic)UIColor *borderShadowColor;

// left border visual information
@property(nonatomic)BOOL showLeftBorderShadow;
@property(nonatomic)SliceBorder leftBorderStyle;
// in font size
@property(nonatomic)NSInteger leftBorderSize;

@property(nonatomic)BOOL showRightBorderShadow;
@property(nonatomic)SliceBorder rightBorderStyle;
// in font size
@property(nonatomic)NSInteger rightBorderSize;

// margins at left and right side to control how much space reservered for visual.  in degree
@property(nonatomic)float leftAngleMargin;
@property(nonatomic)float rightAngleMargin;

// margin at top and bottom side to control how much space reserved for visual.  in font size
@property(nonatomic)float topEdgeMargin;
@property(nonatomic)float bottomEdgeMargin;

// cell tip. one per slice.
@property(strong, nonatomic)TRCellTip *cellTip;

// end

// GUI methods
////////////////////////////////////////////////////
// setup slice view style
-(void)setStyle:(SliceViewStyle)style;

////////////////////////////////////////////////////
// attach table of metric values and view mapping table to slice
// parent - parent layer
// metricValues - metrics values
-(void)showMetricDataTable:(TRMetricDataTable*)metricValues;

////////////////////////////////////////////////////
// paint on the given context
-(void)Paint:(CGContextRef)ctx;

////////////////////////////////////////////////////
// hit test
-(HitObj)HitTest:(CGPoint) atPoint;

// table cell hit test
-(HitObj)cellTableHitTest:(CGPoint) atPoint;

// Reset axis slider bar position
-(void)setColumnAxisSliderBarPosition:(float)barPosition;
-(void)setRowAxisSliderBarPosition:(float)barPosition;

////////////////////////////////////////////////////

// event.  call whenever visual and table data are out of sync
// view is made dirty
-(void)onDirtyView;
-(void)onSize;
@end
