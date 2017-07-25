//
//  CDEdge.m
//  ChordGraph
//
//  Created by Hui Wang on 7/16/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDEdge.h"

@implementation CDEdge

// private data
float _runtimeSize_edge;

// methods
-(id)init
{
    self = [super init];
    
    _size = .0;
    _runtimeSize_edge = 1.0;
    _background = [[CDSliceBackground alloc] init];
    
    _background.highlight = FALSE;
    _background.highlightStyle = HighLightStyle_Fill;
    _background.style = BackgroudStyle_Color_Fill;
    _background.bkgColor = [UIColor lightGrayColor];
    _background.edgeColor = [UIColor lightGrayColor];
    
    return self;
}

// here is your chance to compute the run time size
-(void)translateChildernFontSize:(float)pointsPerFontSize
{
    _runtimeSize_edge = _size * pointsPerFontSize;
}

// get run time size
-(float)runtimeSize
{
    return _runtimeSize_edge;
}


@end
