//
//  TRSliceGrid.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/24/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRCell.h"
#import "TRAxis.h"
#import "TRDataTableSliceView.h"
#import "TRGridLine.h"

// grid visual presentation of TRSlice
// the coordiantes in grid are expressed in the form of radius and angle (radius, angle)
// the direction of radous goes from inside to outside and the angle goes from right to left
@interface TRSliceGrid : NSObject{
}

// true if grid cells are presented as layer for performance instead of image drawing
@property BOOL cellShowAsLayer;
// background color for even rows
@property(strong, nonatomic)UIColor *evenRowBackgroundColor;
@property(strong, nonatomic)UIColor *oddRowBackgroundColor;

// column and row grid line drawing properties
@property(strong, nonatomic)TRGridLine *columnGridLine;
@property(strong, nonatomic)TRGridLine *rowGridLine;

// background color for highlighted cell
@property(strong, nonatomic) UIColor *highLightedcellBackgroundColor;
@property(strong, nonatomic) UIColor *highLightedcellBorderColor;

// row and column hight
@property int rowFocus;
@property int columnFocus;

// methods
// paint grid and grid cell tabel on the given context
-(void)paint:(CGContextRef)ctx
       table:(TRDataTableSliceView*) table
      layout:(Slice)size
      center:(CGPoint)origin
    ringAxis:(TRAxis *)ringAxis
   angleAxis:(TRAxis *)angleAxis;

@end
