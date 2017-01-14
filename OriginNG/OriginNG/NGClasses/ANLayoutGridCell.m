//
//  ANLayoutGridCell.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 2/13/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "ANLayoutGridCell.h"

@implementation ANLayoutGridCell

-(void)dealloc
{
    _node = nil;
}

-(instancetype) init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    _col = -1;
    _row = -1;
    _nodeIndex = -1;
    _distance2Node = 10000000.0;  // invalid
    _numberOfnodeResidents = 0.0;
    _nodeMass = .0;
    _nodeMassGradient = .0;
    _node = nil;
    _strongestNodeNearby = nil;
    
    return self;
}

-(instancetype)initWith:(int)row
                    col:(int)col
{
    self = [self init];
    
    _col = col;
    _row = row;
    _nodeIndex = -1;
    _distance2Node = 10000000.0;  // invalid
    _numberOfnodeResidents = 0.0;
    _nodeMass = .0;
    _nodeMassGradient = .0;
    _node = nil;
    _strongestNodeNearby = nil;
    
    return self;
}

-(void) reSet
{
    _col = -1;
    _row = -1;
    _nodeIndex = -1;
    _distance2Node = 10000000.0;  // invalid
    _numberOfnodeResidents = 0.0;
    _nodeMass = .0;
    _nodeMassGradient = .0;
    _node = nil;
    _strongestNodeNearby = nil;
}

@end
