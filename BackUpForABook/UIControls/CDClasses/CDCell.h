//
//  CDCell.h
//  ChordGraph
//
//  Created by Hui Wang on 6/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "Define.h"
#import "CDConnection.h"
#import "ANCircleText.h"
#import "CDSliceBackground.h"

@interface CDCell : NSObject{
    ANCircleText* textPainter;
}

// properties
// array of CDConnection object ids
@property(strong,nonatomic)NSMutableArray *connectorIDs;

@property(nonatomic)BOOL showImage;
@property(nonatomic)BOOL showSymbol;
@property(nonatomic)BOOL showBackground;
// image for CellValueShape == CellValueShape_Image
@property(strong, nonatomic)UIImage *image;
// details text for showValue = true
@property(strong, nonatomic)NSMutableString *text;
// text symbol attributed string
@property(strong, nonatomic)NSMutableDictionary* symbolAttributes;
// short symbol for showSymbol = true
@property(nonatomic)NSMutableString *symbol;
// background
@property(strong, nonatomic)CDSliceBackground *backgropund;
// size in degree unit.  will be used in the future to reflect the "weight" of this cell
// this size is "desired" sie in case of multiple cells are set with large size that will exceed the max slice size.  the actual size of cells will be decide based on tthis weight
@property(nonatomic)float sizeWeight;
// size decided at run time.  Do not try to set these values!!!
// range (starting angle, width) or (left, right) being set dynamicly.  caller should not set this values
@property(nonatomic)float left;
@property(nonatomic)float right;

// methods
// remove connector
-(void)removeConnector:(id)connectorID;
// invalidate gui
-(void)invalidate;

// call to make sure all visual changes are in sync with the internal data
-(void)onDirtyView;

// paint ring slice
-(void)paint:(CGContextRef)ctx
      center:(CGPoint)origin
      bottom:(float)bottom
         top:(float)top
 frameHeight:(int)height;

@end
