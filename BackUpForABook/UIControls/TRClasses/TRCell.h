//
//  TRCell.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "TRShowStyle.h"
// display cell object as layer
//#import "APageLayerPath.h"

// !!! To do, put in place the TRShowStyle drawing object
// TRCell represents the visual projection of selected items in TRDataTable onto TRMap cells
// at run time TRCell collections of each TRSlices are filled with view projection result along
// with back links into TRDatatable
// cell has foolowing information:
// (1) metric value (or values) that can be used to show to end user on finger touch
// (2) mapped legend color that has the predefined meanings for end users
// (3) size information that is mapped to the predefined nformation (servirity for example)
// (4) drawing style: flat, 3D, gradient color, shadowing, transparent etc
// !!!Is used by TRSlice object class
@interface TRCell : NSObject

// cell display style
@property(nonatomic)CellValueShow displayStyle;
// cell display shape
@property(nonatomic)CellValueShape cellShape;
// draw with shadow
@property(nonatomic)BOOL withShadow;
// draw with outline
@property(nonatomic)BOOL withOutline;
// transparent

// gradient

// size (font size) of visual display
@property(nonatomic)NSInteger displaySize;
// true for displaying the cell value string on the map
@property(nonatomic)BOOL showValue;

// info of metric associated with this cell
// metrice value
@property(nonatomic)double value;
// metric unit string
@property(strong, nonatomic)NSString* unit;
// metric name string
@property(strong, nonatomic)NSString* name;

// tip message
@property(strong, nonatomic)NSString *text;

/////////////////////////////////////////////////////////////
// drawing information
/////////////////////////////////////////////////////////////

// option 1: if display cell as CALayer
@property(strong, nonatomic)CALayer *layer;

// option 2: if draw cell using in memory image with UIKIT
// main color for displaying the cell metric value
@property(strong, nonatomic)UIColor *metricColor;
// image for CellValueShape == CellValueShape_Image
@property(strong, nonatomic)UIImage *image;

// or display the cell via core animation

@end
