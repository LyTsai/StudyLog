//
//  TRCell.m
//  ATreeRingMap
//
//  Created by Hui Wang on 5/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "TRCell.h"

// Represnts cell object class that holds the visual presentation information
@implementation TRCell

- (id)init
{
	self = [super init];
	if (self) {
        _displayStyle = CellValueShow_Flat;
        _cellShape = CellValueShape_Circle;
        _showValue = TRUE;
        _value = -1.0;
        _name = nil;
        _unit = nil;
        _text = nil;
        _displaySize = 8;
        _layer = nil;
        _metricColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        _image = nil;
    }
    
    return self;
}
@end
