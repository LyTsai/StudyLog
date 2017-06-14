//
//  ANLayoutCollisionMinimize.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 2/12/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ANLayoutNode.h"
#import "ANLayoutGrid.h"

//////////////////////////////////////////////////////////////////////////
// move node around near by layout cells to minimize collision among nodes
// by minimizing cell node density

// !!! nodes have to be already projected onto the hosting 

// define parameter structure

// node mass cell distribution methods
typedef enum
{
    NODEMASSDISTRIBUTION_LEVEL_ONE,         // over nearst cell
    NODEMASSDISTRIBUTION_LEVEL_TWO,         // over two cell neighbors
    NODEMASSDISTRIBUTION_CHARGE             //
}NODEMASSDISTRIBUTION;

typedef struct
{
    // ratio for margin: cell size = node size * _marginRatio
    float _marginRatio;
    
    // size zoom factor
    float _sizeZoomRatio;
    
    // dynamic values
    float _nodeDensity;     // number of nodes / number of cells
    
    // node distribution functions over cell
    NODEMASSDISTRIBUTION _massDistribution;
    
}MinimizeNodeDensityParams;

// set default parameters for node density inimizing
int DefaultParams(MinimizeNodeDensityParams* params);

// minimizing node density
int ANLayoutCollisionMinimize_GridCellDensity(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params);

//////////////////////////////////////////////////////////////////////////
// by balancing forces

@interface ANLayoutCollisionMinimize : NSObject

@property MinimizeNodeDensityParams params;

// methods

// access to grid object
-(ANLayoutGrid*)grid;

// attach grid object to node
-(int)attachNodeToGrid:(ANLayoutNode*) node;

// adjust node positions to minimix=za collision
// !!! assumes that attachNodeToGrid was already called before calling this one
// !!! after this call each node should be matched to a hosting cell (node.grid_row, node.grid_col).  if the matched cell is also pointing back to the same node then it is considered as best match otherwise it is second or more match for nodes (many nodes are sharing the same cell) etc
-(int)minimizeNodeCollisions_Density:(ANLayoutNode*) node;

// force directed
-(int)minimizeNodeCollisions_Force:(ANLayoutNode*) node;

@end
