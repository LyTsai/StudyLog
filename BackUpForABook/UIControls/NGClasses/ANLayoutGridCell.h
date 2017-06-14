//
//  ANLayoutGridCell.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 2/13/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANLayoutNode.h"

@interface ANLayoutGridCell : NSObject

// column and row
@property int col;
@property int row;

// current node resident.  the same node index
@property int nodeIndex;

// distance between cell center and its hosting node
@property float distance2Node;

// node distribution (or overlapp) information
// nodes that falls (or overlapped with) onto this cell
// !!! this is a "effective" number of resident.  for example, if a node os size .5 falls onto a cell of size 1 then the contribution to this value is .5
@property float numberOfnodeResidents;
// effective node mass attached to this cell
@property float nodeMass;
// node mass gradient
@property float nodeMassGradient;

// hosted node
@property(weak) ANLayoutNode* node;

// most "dominat" node that may not be hosted within this cell by ovelap with this cell
@property(weak) ANLayoutNode* strongestNodeNearby;

// method

-(instancetype)initWith:(int)row
                    col:(int)col;

// reset cell
-(void) reSet;

@end
