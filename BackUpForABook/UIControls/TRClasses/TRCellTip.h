//
//  TRCellTip.h
//  ATreeRingMap
//
//  Created by hui wang on 9/13/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRCell.h"
#import "ANText.h"

// object for showing cell tip
@interface TRCellTip : NSObject

// show tip?
@property(nonatomic)bool show;
// cell coordinate
@property(nonatomic)int sliceIndex;
@property(nonatomic)int columnIndex;
@property(nonatomic)int rowIndex;
// text painter
@property(strong, nonatomic)ANText* cellTip;

// method
-(void)Paint:(CGContextRef)ctx
        cell:(TRCell*)cell
    position:(CGPoint)position;

@end
