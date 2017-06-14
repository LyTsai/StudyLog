//
//  TreeRingMapView.h
//  ATreeRingMap
//
//  Created by hui wang on 9/5/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TRMap.h"

@interface TreeRingMapView : UIView

// resize tree ring map
-(void)setSize:(CGRect)frame;

// create one slice tree ring map
-(void)addOneSlice:(float)begin
               end:(float)end;

// create two slices tree ring map
-(void)addTwoSlices:(float)begin
                mid:(float)mid
                end:(float)end;

// create N-slices tree ring map
-(void)addNSlices:(NSMutableArray*)slicePositions;

// get number of ring slices
-(int)numberOfSlices;

// access the slice
-(TRSlice*)getSlice:(int)position;

// load data table into ring slice
-(void)loadDataTableIntoSlice:(TRMetricDataTable*)dataTable
                        slice:(TRSlice*)slice;

// set slice style
-(void)setSliceStyle:(TRSlice*)slice
               style:(SliceViewStyle)style;

////////////////////////////////////////////////
// test methods for loading the view with predefined table and view styles

// x axis - name and photo, y axis - risk factors with two slices of static and dynamic risk factors
-(void)test_VTD_GAME_OF_SCORE_Static_Dynamic;
////MH.dingf Test function1
-(void)testForShowTreeRingMap:(TRMetricDataTable *)dataTableA and:(TRMetricDataTable *)dataTableB andLabelString:(NSMutableArray *)labelStringArr;
////MH.dingf Test function2
-(void)testForShowMeasurement:(TRMetricDataTable *)dataTableA and:(TRMetricDataTable *)dataTableB;

@end
