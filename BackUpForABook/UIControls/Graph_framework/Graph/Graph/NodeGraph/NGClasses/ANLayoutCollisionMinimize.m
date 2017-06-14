//
//  ANLayoutCollisionMinimize.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 2/12/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "ANLayoutCollisionMinimize.h"
#import "ANRadialLayout.h"

// private fumctions

// clear association and connections among nodes and cells
int _removeTreeNodeGridCellConnections(ANLayoutNode* node, ANLayoutGrid* grid);

// one node can only fall into one cell while one cell may be overlapped with multiple nodes.
// !!! scan over tree nodes to assign each node with their matched cell index while each cell can be assigned to only one node that are best matched to the cell by the distance
int _bestNodeMatch(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params);

// scan tree node again to assign new cell if the node is not the best match current cell
int _nodeCellRematch(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params);

// break apart (or increase distance) nodes that "sits" on different cells but overlap each other
int _reduceNodeCellOverlap(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params);

// make position adjustment if multiple nodes have to be hosted by one cell (via force !!! to do later)
int _nodePositionAdjustment(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params);

//////////////////////////////////////////////////////////////////////////////
// clear association and connections among nodes and cells
int _removeTreeNodeGridCellConnections(ANLayoutNode* node, ANLayoutGrid* grid)
{
    if (node == nil || grid == nil)
    {
        return 0;
    }
    
    ANLayoutGridCell* cell = [grid cell:node.grid_row col:node.grid_col];
    
    if (cell != nil)
    {
        node.grid_row = -1;
        node.grid_col = -1;
    
        cell.nodeIndex = -1;
        cell.node = nil;
        cell.strongestNodeNearby = nil;
        cell.numberOfnodeResidents = 0;
        cell.nodeMass = 0.0;
        cell.nodeMassGradient = .0;
        cell.distance2Node = 1000000.0;
    }
    
    for (ANLayoutNode* obj in node.childern)
    {
        _removeTreeNodeGridCellConnections(obj, grid);
    }
    
    return 0;
}

//////////////////////////////////////////////////////////////////////////////
// !!! scan over tree nodes to assign each node with their matched cell index while each cell can be assigned to only one node that are best matched to the cell by the distance
int _bestNodeMatch(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params)
{
    if (node == nil || grid == nil || params == nil)
    {
        return 0;
    }
    
    // (1) get grid cell that this node falls onto
    ANLayoutGridCell* cell = [grid cell:node.xPosition yPosition:node.yPosition];
    
    // (2) "spread" node mass across nearby cells
    if (cell != nil)
    {
        // cell amtch for this node
        node.grid_row = cell.row;
        node.grid_col = cell.col;
    
        // cell node mass distribution (by distibution function)
        if (params->_massDistribution == NODEMASSDISTRIBUTION_LEVEL_ONE)
        {
            for (int r = cell.row - 1; r <= cell.row + 1; r++)
            {
                for (int c = cell.col - 1; c <= cell.col + 1; c++)
                {
                    ANLayoutGridCell* cell1 = [grid cell:r col:c];
                    
                    if (cell1 == nil)
                    {
                        continue;
                    }
                    
                    if (r == cell.row && c == cell.col)
                    {
                        cell1.nodeMass += node.size;
                    }else
                    {
                        cell1.nodeMass += (node.size / (abs(r - cell.row) + abs(c - cell.col)));    // intensity because of distance
                    }
                }
            }
        }else if (params->_massDistribution == NODEMASSDISTRIBUTION_LEVEL_TWO)
        {
            for (int r = cell.row - 2; r <= cell.row + 2; r++)
            {
                for (int c = cell.col - 2; c <= cell.col + 2; c++)
                {
                    ANLayoutGridCell* cell1 = [grid cell:r col:c];
                    
                    if (cell1 == nil)
                    {
                        continue;
                    }
                    
                    if (r == cell.row && c == cell.col)
                    {
                        cell1.nodeMass += node.size;
                    }else
                    {
                        cell1.nodeMass += (node.size / (abs(r - cell.row) + abs(c - cell.col)));    // intensity because of distance
                    }
                }
            }
        }else if (params->_massDistribution == NODEMASSDISTRIBUTION_CHARGE)
        {
            
        }
    }
    
    // (3) if node size is greater that cell size "spread" node resident to covered cells
    [grid addNodeShadow:node cell:cell];
    
    // (4) best match for the cell
    [grid attch2BestMatchedNode:node];
    
    // all child nodes
    for (int i = 0; i < node.childern.count; i++)
    {
        _bestNodeMatch([node.childern objectAtIndex:i], grid, params);
    }

    return 0;
}

// scan tree node again to assign new cell if the node is not the best match current cell
int _nodeCellRematch(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params)
{
    if (node == nil || grid == nil || params == nil)
    {
        return 0;
    }
    
    // node and cell matched to each other?
    ANLayoutGridCell* cell = [grid cell:node.xPosition yPosition:node.yPosition];
    
    if (cell == nil)
    {
        // not attched to cell
        [grid attch2BestMatchedNode:node];
    }else if (cell.node != nil && cell.node != node)
    {
        // not best match.  try to find another "empty" cell for this node
        // !! need to do this according to params.  for now we will serach for cell within two level cell layers: (-level, level) index range
        // (rPosition, aPosition) will be updated after this call
        cell = [grid attch2SecondBestMatchedNode:node level:1];
    }
     
    // all child nodes
    for (int i = 0; i < node.childern.count; i++)
    {
        _nodeCellRematch([node.childern objectAtIndex:i], grid, params);
    }

    return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// break apart (or increase distance) nodes that "sits" on different cells but overlap each other

// disconnect "weak" overlapped neighbor nodes from their hosting cells
int _removeWeakOverlappedNodes(ANLayoutGrid* grid, MinimizeNodeDensityParams* params)
{
    if (grid == nil || params == nil)
    {
        return 0;
    }

    // (1) scan all cells and locate cell that has numberOfnodeResidents > 1.
    for (int r = 0; r < grid.rows; r++)
    {
        for (int c = 0; c < grid.cols; c++)
        {
            ANLayoutGridCell* cell = [grid cell:r col:c];
            
            if (cell == nil ||
                cell.numberOfnodeResidents <= 1 ||      // only one node overlap
                cell.node == nil ||
                cell.strongestNodeNearby == cell.node)  // hosting node is the stringest one
            {
                continue;
            }
            
            // found one node whose hosting cell overlap with nearby nodes and is NOT the strongest one. we need to remove this node
            
            float fw = (.5 * (cell.node.size - grid.cellWidth)) / grid.cellWidth + 1.0;
            float fh = (.5 * (cell.node.size - grid.cellHeight)) / grid.cellHeight + 1.0;
            
            if (fw <= 1)
            {
                fw = 0;
            }
            
            if (fh <= 1)
            {
                fh = 0;
            }
            
            int w = fw;
            int h = fh;
            
            for (int r1 = cell.row - h; r1 <= cell.row + h; r1++)
            {
                for (int c1 = cell.col - w; c1 <= cell.col + w; c1++)
                {
                    ANLayoutGridCell* cell1 = [grid cell:r1 col:c1];
                    
                    if (cell1 != nil)
                    {
                        cell1.numberOfnodeResidents = cell1.numberOfnodeResidents - 1.0;
                    }
                }
            }
        }
    }

    return 0;
}

// match to cell around current location
int _nodeCellBestMatch(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params)
{
    if (node == nil || grid == nil || params == nil)
    {
        return 0;
    }
    
    // node and cell matched to each other?
    ANLayoutGridCell* cell = [grid cell:node.xPosition yPosition:node.yPosition];
    
    if (cell == nil)
    {
        // not attched to cell
        [grid attch2BestMatchedNode:node];
    }else if (cell.strongestNodeNearby != node)
    {
        // node is within a cell that shared by multiple nodes and the domainet node is NOT current one
        // increase the seperation between node and nearby dominating node
        // !!! note that different from calling attch2SecondBestMatchedNode that is used for solving the problem of having more than one node sharing the same cell
        // (rPosition, aPosition) will be updated after this call
        cell = [grid moveAwayFromDominantNode:node level:2.0];
    }
    
    // all child nodes
    for (int i = 0; i < node.childern.count; i++)
    {
        _nodeCellBestMatch([node.childern objectAtIndex:i], grid, params);
    }
    
    return 0;
}

// break apart (or increase distance) nodes that "sits" on different cells but overlap each other
int _reduceNodeCellOverlap(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params)
{
    if (node == nil || grid == nil || params == nil)
    {
        return 0;
    }
    
    // (1) remove "weak" overlapped neighbor nodes first
    _removeWeakOverlappedNodes(grid, params);
    
    // (2) find best match to the cell around current cell location
    _nodeCellBestMatch(node, grid, params);
    
    return 0;
}

// end of _reduceNodeCellOverlap
///////////////////////////////////////////////////////////////////////////////////////////////////////

// make position adjustment if multiple nodes have to be hosted by one cell (via force !!! to do later)
int _nodePositionAdjustment(ANLayoutNode* node, ANLayoutGrid* grid, MinimizeNodeDensityParams* params)
{
    return 0;
}

//////////////////////////////////////////////////////////////////////////////

// set default parameters for node density inimizing
int DefaultParams(MinimizeNodeDensityParams* params)
{
    params->_marginRatio = 1.20;        // 20 percent margin for hosting the node
    params->_sizeZoomRatio = 5.0;       // see loadTestNodeTree function for example
    params->_massDistribution = NODEMASSDISTRIBUTION_LEVEL_TWO;
    
    return 0;
}

@implementation ANLayoutCollisionMinimize
{
    // private
    @private
    ANLayoutGrid* _grid;
}

-(instancetype)init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    _grid = [[ANLayoutGrid alloc] init];
    
    DefaultParams(&_params);
  
    return self;
}

-(ANLayoutGrid*)grid
{
    return _grid;
}

// attach grid object to node:
// 1. estimate average node size
// 2. estimate average cell size
// 3. estimate node / cell density
-(int)attachNodeToGrid:(ANLayoutNode*) node
{
    // (1) get tree size
    float treeSize = .0, treeSize_tran = .0, edge_tran = .0;
    getTreeLength(node, &treeSize, &treeSize_tran, &edge_tran);
    
    // (2) get average node size
    float totalSize = .0, numberOfNodes = 0;
    getTreeNodeAverageSize(node, &totalSize, &numberOfNodes);
    
    if (numberOfNodes == 0)
    {
        return 0;
    }
    
    float aveNodeSize = totalSize / numberOfNodes;
    
    // (3) node cell density
    // grid dimention.
    int m = 2. * treeSize / aveNodeSize;
    
    // !!! to do.  make sure that grid can be zoomed in via 3 by 3
    m = ((m / 3) + 1) * 3;
    
    // number of nodes per grid cell
    _params._nodeDensity = numberOfNodes / (m * m);

    // (4) create grid
    _grid = [[ANLayoutGrid alloc] init];
    
    [_grid reSet:2.0 * treeSize height:2.0 * treeSize rows:m cols:m];
    
    return 0;
}

// adjust node positions to minimize collision
// !!! assumes that attachNodeToGrid was already called before calling this one
// !!! after this call each node should be matched to a hosting cell (node.grid_row, node.grid_col).  if the matched cell is also pointing back to the same node then it is considered as best match otherwise it is second or more match for nodes (many nodes are sharing the same cell) etc
-(int)minimizeNodeCollisions_Density:(ANLayoutNode*) node
{
    // adjust node positions to minimix=za collision
    // !!! assumes that attachNodeToGrid was already called before calling this one
    if (node == nil || _grid == nil)
    {
        return 0;
    }
    
    ////////////////////////////////////////////////////////////////
    // first round
    ////////////////////////////////////////////////////////////////
    
    // (1) project (rPosition, aPosition) to (xPosition, yPosition)
    updateNodeXYPositions(node);

    // (2) remove node current grid cell index
    _removeTreeNodeGridCellConnections(node, _grid);
    
    // (3) best match for node and cell seperatly
    _bestNodeMatch(node, _grid, &_params);
    
    // (4) rematch of un-hosted nodes
    _nodeCellRematch(node, _grid, &_params);
    
    ////////////////////////////////////////////////////////////////
    // second round
    ////////////////////////////////////////////////////////////////
    // (5) project midified (rPosition, aPosition) to (xPosition, yPosition)
    updateNodeXYPositions(node);

    // (6) remove node current grid cell index
    _removeTreeNodeGridCellConnections(node, _grid);
    
    // (7) best match for node and cell seperatly
    _bestNodeMatch(node, _grid, &_params);
    
    // (8) break apart (or increase distance) nodes that "sits" on different cells but overlap each other
    _reduceNodeCellOverlap(node, _grid, &_params);
    
    ////////////////////////////////////////////////////////////////
    // final round
    ////////////////////////////////////////////////////////////////
    // we are done reducing the node collision.  update latest layout overlap information
    // (9) project midified (rPosition, aPosition) to (xPosition, yPosition)
    updateNodeXYPositions(node);
    
    // (10) remove node current grid cell index
    _removeTreeNodeGridCellConnections(node, _grid);
    
    // (11) best match for node and cell seperatly
    _bestNodeMatch(node, _grid, &_params);
    
    return 0;
}

// force directed
-(int)minimizeNodeCollisions_Force:(ANLayoutNode*) node
{
    
    return 0;
}

@end
