//
//  APathDraw.m
//  AProgressBars
//
//  Created by hui wang on 7/13/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "APathDraw.h"

@implementation APathDraw

// methods
-(void)initDrawPros
{
    _pathRefSize = CGPointMake(100, 100);
    
    _pathEdgeColor = [UIColor lightGrayColor]; //[UIColor colorWithRed: 0.165 green: 0.667 blue: 0.886 alpha: 1];
    _pathFillColor = [UIColor clearColor];
    _pathThickness = 1.0;
}

@end
