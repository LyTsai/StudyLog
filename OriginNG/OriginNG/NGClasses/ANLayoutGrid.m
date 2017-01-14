//
//  ANLayoutGrid.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 2/13/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "ANLayoutGrid.h"
#import "ANRadialLayout.h"

@implementation ANLayoutGrid
{
    @private
    
    // array of ANLayoutGridCell array
    NSMutableArray *_cells;

    // grid origin (to match the circle center)
    float _x0;
    float _y0;
    
    // cell size
    float _cell_width;
    float _cell_height;
    float _cell_Size;
}

-(instancetype)initWith:(int)cols
                   rows:(int)rows
{
    self = [super init];
    
    if (self == nil)
    {
        return self;
    }

    _cols = cols;
    _rows = rows;
    
    _x0 = .0;
    _y0 = .0;
    
    // reserve
    _cells = [[NSMutableArray alloc] initWithCapacity:rows];
    
    int i, j;
    
    for (i = 0; i < rows; i++)
    {
        _cells[i] = [[NSMutableArray alloc] initWithCapacity:cols];
    }
    
    // create cell objects
    for (i = 0; i < rows; i++)
    {
        for (j = 0; j < cols; j++)
        {
            [_cells[i] addObject:[[ANLayoutGridCell alloc] initWith:i col:j]];
        }
    }
    
    _cell_width = .0;
    _cell_height = .0;
    _cell_Size = .0;
    
    return self;
}

-(void) reSet:(int)rows
         cols:(int)cols
{
    if (rows < 0 || cols < 0)
    {
        return ;
    }
    
    _rows = rows;
    _cols = cols;
    
    _x0 = .0;
    _y0 = .0;
    
    _cells = [[NSMutableArray alloc] initWithCapacity:_rows];
    
    int i, j;
    
    for (i = 0; i < _rows; i++)
    {
        _cells[i] = [[NSMutableArray alloc] initWithCapacity:_cols];
    }
    
    // create cell objects
    for (i = 0; i < _rows; i++)
    {
        for (j = 0; j < _cols; j++)
        {
            [_cells[i] addObject:[[ANLayoutGridCell alloc] initWith:i col:j]];
        }
    }
    
    _cell_width = .0;
    _cell_height = .0;
    _cell_Size = .0;
}

-(void) reSet:(float) width
       height:(float) height
         rows:(int) rows
         cols:(int) cols
{
    // create grid first
    [self reSet:rows cols:cols];
    
    // grid space size
    _width = width;
    _height = height;
    
    _cell_width = width / cols;
    _cell_height = height / rows;
    _cell_Size = sqrtf(_cell_width * _cell_width + _cell_height * _cell_height);
    
    // coordinate origin
    _x0 = width * .5;
    _y0 = height * .5;
    
    return ;
}

// empty nosting node (or disconnect from nodes)
-(void) disconnectFromHostingNodes
{
    if (_cells == nil)
    {
        return ;
    }
    
    for (int r = 0; r < _cells.count; r++)
    {
        for (int c = 0; c < [_cells[r] count]; c++)
        {
            ANLayoutGridCell* cell = _cells[r][c];
            cell.node = nil;
            cell.row = -1;
            cell.col = -1;
        }
    }
}

// by index
-(ANLayoutGridCell*)cell:(int)row
                     col:(int)col
{
    if (_cells == nil || row < 0 || col < 0 || row >= _rows || col >= _cols || _rows <= 0 || _cols <= 0)
    {
        return nil;
    }
    
    return _cells[row][col];
}

// by node (xPosition, yPosition) position
-(ANLayoutGridCell*)cell:(float) xPos
               yPosition:(float) yPos
{
    if (_cells == nil)
    {
        return nil;
    }
    
    int colIdx = (xPos + _x0) / _cell_width;
    int rowIdx = (yPos + _y0) / _cell_height;
    
    if (colIdx < 0)
    {
        colIdx = 0;
    }
    
    if (rowIdx < 0)
    {
        rowIdx = 0;
    }
    
    return [self cell:rowIdx col:colIdx];
}

// host node by shortest distance.  return nil if node is not the best one
-(ANLayoutGridCell*) attch2BestMatchedNode:(ANLayoutNode*) node
{
    ANLayoutGridCell* cell = [self cell:node.xPosition yPosition:node.yPosition];
    if (cell == nil)
    {
        return nil;
    }
    
    // distance between node and cell
    float dis = [self distance:node row:cell.row col:cell.col];
    
    if (cell.nodeIndex < 0 || cell.node == nil || cell.distance2Node > dis)
    {
        cell.nodeIndex = node.index;
        cell.node = node;
        cell.distance2Node = dis;
        
        node.grid_row = cell.row;
        node.grid_col = cell.col;
        
        return cell;
    }
    
    // not a closer one
    return nil;
}

// called to break nodes from sharing the same cell.
// !!! for every node it should be matched to a cell (node.grid_row, node.grid_col).  if the matched cell is also pointing back to the same node then it is considered as best match otherwise it is second or more match for nodes (many nodes are sharing the same cell) etc
-(ANLayoutGridCell*) attch2SecondBestMatchedNode:(ANLayoutNode*) node
                                           level:(int)level
{
    if (node == nil)
    {
        return 0;
    }
    
    // node's currently attached cell object
    ANLayoutGridCell* cell = [self cell:node.grid_row col:node.grid_col];
    if (cell == nil)
    {
        return nil;
    }

    // first level match is a best one?
    if (cell.node == node)
    {
        // yes
        return cell;
    }
    
    // cell is currently ocupied by another node.  need to search for secod best one within range (-level, level)
    // the new hosting cell should be the one that has the smallest nodeMass
    float minMass = cell.nodeMass;
    
    // desired distance between node and cell.node
    float dis = (node.size + cell.node.size) * .5;
    
    ANLayoutGridCell* cellnew = nil;
  
    for (int r = (cell.row - level); r <= (cell.row + level); r++)
    {
        for (int c = (cell.col - level); c <= (cell.col + level); c++)
        {
            if (r == cell.row && c == cell.col)
            {
                continue;
            }
            
            // try at new cell position
            ANLayoutGridCell* cell1 = [self cell:r col:c];
            
            if (cell1 == nil || cell1.nodeIndex >= 0 ||
                cell1.node != nil || cell1.numberOfnodeResidents > .5 || // already ocupied by nodes
                cell1.nodeMass > minMass)
            {
                // cell1 is already taken or has more node overlap than current hosting cell
                continue;
            }
            
            if (cell1.nodeMass == minMass && cellnew != nil)
            {
                // already found another "best match" for node
                continue;
            }
            
            // found a sencond best match for node
            minMass = cell1.nodeMass;
            cellnew = cell1;
        }
    }
    
    // did we find a new match?
    if (cellnew != nil)
    {
        // yes.  adjust new node position
        float xPos = node.xPosition + _cell_width * (cellnew.col - node.grid_col);
        float yPos = node.yPosition + _cell_height * (cellnew.row - node.grid_row);
        
        // are we too far away from node node?
        float seperation = [self distance:cell.node xPosition:xPos yPosition:yPos];
        if (seperation > dis)
        {
            // yes.  we have too much adjustment
            // direction from cell.node to cellnew
            float angle = atan2f(([self yPos:cellnew.row] - cell.node.yPosition), ([self xPos:cellnew.col] - cell.node.xPosition));
            
            float dis1 = seperation - .25 * [self cellSize];
            if (dis1 < dis)
            {
                dis1 = dis;
            }

            xPos = cell.node.xPosition + dis1 * cosf(angle);
            yPos = cell.node.yPosition + dis1 * sinf(angle);
        }
        
        // convert (xPos, yPos) to (rPosition, aPosition)
        node.rPosition = sqrtf(xPos * xPos + yPos * yPos);
        node.aPosition = RADIANS_TO_DEGREES(atan2f(yPos, xPos));
        
        node.rPosition_tran = node.rPosition;
        node.aPosition_tran = node.aPosition;
        
        // connect between node and cellnew
        node.grid_row = cellnew.row;
        node.grid_col = cellnew.col;
        
        cellnew.nodeIndex = node.index;
        cellnew.node = node;
        
        cellnew.numberOfnodeResidents = cellnew.numberOfnodeResidents + (node.size * node.size) / (_cell_width * _cell_height);
    }
    
    return cellnew;
}

// given node is NOT sharing the cell with another node but sits on a cell that is "over shadowed" by other node.  one cell can be overlapped or over shadowed by more than on node.  we will move nodes away from the dominant node (the one tha has most in size measured by the number leafs under the node).  move given node away from the dominat one
// node - node to be seperated from dominant node
// level - maximum distance for shifting
-(ANLayoutGridCell*) moveAwayFromDominantNode:(ANLayoutNode*) node
                                        level:(int)level
{
    if (node == nil)
    {
        return 0;
    }
    
    // cell object node is associated with
    ANLayoutGridCell* cell = [self cell:node.grid_row col:node.grid_col];
    
    if (cell == nil || cell.strongestNodeNearby == nil)
    {
        return nil;
    }

    if (node == cell.strongestNodeNearby && node == cell.node)
    {
        // no need to remove as the dominant node
        return 0;
    }
    
    // desired seperation between given node and the dominant one
    float dis = (node.size + cell.strongestNodeNearby.size) * .5;
    
    // current seperation
    float dx = (node.grid_col - cell.strongestNodeNearby.grid_col) * _cell_width;
    float dy = (node.grid_row - cell.strongestNodeNearby.grid_row) * _cell_height;
    float dis0 = sqrt(dx * dx + dy * dy);
    
    if (dis0 >= dis)
    {
        // already has enough seperation
        return 0;
    }
    
    // need to serach for secod best one within range (-level, level)
    // the new hosting cell should be the one that has the smallest nodeMass
    float minMass = cell.nodeMass;
    float minDis = 100000.0;
    
    ANLayoutGridCell* cellnew = nil;
    
    // sersach for new hosting cell around cell
    int row0 = cell.row;
    int col0 = cell.col;
    
    // need to move towards the root direction
    if (node.root)
    {
        // move towards root to avoid cross over links among nodes
        
        // root of node
        ANLayoutNode* root = node.root;
        
        // root of cell.strongestNodeNearby
        ANLayoutNode* root0 = cell.strongestNodeNearby.root;
        
        if (root0 == nil)
        {
            root0 = cell.strongestNodeNearby.root;
        }
        
        // direction from root0 to root
        float angle = atan2f((root.yPosition - root0.yPosition), (root.xPosition - root0.xPosition));
        
        float dx = level * cosf(angle);
        float dy = level * sinf(angle);
        
        // find the best match in the range of level around (cell.row + dy, cell.col + dx)
        if ((dx - (int)dx) > .5)
        {
            dx += 1.0;
        }
        
        if ((dy - (int)dy) > .5)
        {
            dy += 1.0;
        }
        
        row0 = cell.row + dy;
        col0 = cell.col + dx;
    }else
    {
        row0 = cell.row;
        col0 = cell.col;
    }
    
    // serach for new hosting cell near (row0, col0)
    // node does not have root
    for (int r = (row0 - level); r <= (row0 + level); r++)
    {
        for (int c = (col0 - level); c <= (col0 + level); c++)
        {
            if (r == row0 && c == col0)
            {
                continue;
            }
            
            // try at new cell position
            ANLayoutGridCell* cell1 = [self cell:r col:c];
            
            if (cell1 == nil || cell1.nodeMass > minMass)
            {
                // cell1 is already taken or has more node overlap than current hosting cell
                continue;
            }
            
            if (cell1 == nil || cell1.nodeIndex >= 0 ||
                cell1.node != nil || cell1.numberOfnodeResidents > .5 || // already ocupied by nodes
                (cell1.node == cell1.strongestNodeNearby) ||
                cell1.nodeMass > minMass)
            {
                // already found another "best match" for node
                continue;
            }
            
            // found a sencond best match for node
            minMass = cell1.nodeMass;
            minDis = [self distance:cell node1:cell1];
            cellnew = cell1;
        }
    }
    
    // did we find a new match?.  shift enough space only
    if (cellnew != nil)
    {
        // yes.  adjust new node position
        float xPos = node.xPosition + _cell_width * (cellnew.col - node.grid_col);
        float yPos = node.yPosition + _cell_height * (cellnew.row - node.grid_row);
        
        // are we too far away from node cell.strongestNodeNearby?
        float seperation = [self distance:cell.strongestNodeNearby xPosition:xPos yPosition:yPos];
        if (seperation > dis)
        {
            // yes.  we have too much adjustment.  shrink by one cell size
            // direction from cell.strongestNodeNearby to cellnew
            float angle = atan2f(([self yPos:cellnew.row] - cell.strongestNodeNearby.yPosition), ([self xPos:cellnew.col] - cell.strongestNodeNearby.xPosition));
            
            float dis1 = seperation - .5 * [self cellSize];
            if (dis1 < dis)
            {
                dis1 = dis;
            }
            
            xPos = cell.strongestNodeNearby.xPosition + dis1 * cosf(angle);
            yPos = cell.strongestNodeNearby.yPosition + dis1 * sinf(angle);
        }
 
        // convert (xPos, yPos) to (rPosition, aPosition)
        node.rPosition = sqrtf(xPos * xPos + yPos * yPos);
        node.aPosition = RADIANS_TO_DEGREES(atan2f(yPos, xPos));
        
        node.rPosition_tran = node.rPosition;
        node.aPosition_tran = node.aPosition;
        
        // connect between node and cellnew
        node.grid_row = cellnew.row;
        node.grid_col = cellnew.col;
        
        cellnew.nodeIndex = node.index;
        cellnew.node = node;
        cellnew.numberOfnodeResidents = cellnew.numberOfnodeResidents + (node.size * node.size) / (_cell_width * _cell_height);;
    }

    return 0;
}

// add "shadows" over near by cells by the given node
-(int)addNodeShadow:(ANLayoutNode*) node
               cell:(ANLayoutGridCell*) cell
{
    float fw = (.5 * (node.size - self.cellWidth)) / self.cellWidth + 1.0;
    float fh = (.5 * (node.size - self.cellHeight)) / self.cellHeight + 1.0;
    
    // effective size for the cell
    float e_w = node.size;
    float e_h = node.size;
    float cell_area = self.cellWidth * self.cellHeight;
    float e_resident = 1.0;
    
    if (fw <= 1)
    {
        fw = 0;
    }
    
    if (fh <= 1)
    {
        fh = 0;
    }
    
    // margin around cell for distribution
    int w = fw;
    int h = fh;
    
    for (int r = cell.row - h; r <= cell.row + h; r++)
    {
        if (r == cell.row)
        {
            e_h = node.size;
        }else
        {
            e_h = .5 * (node.size + self.cellHeight) - abs(r - cell.row) * self.cellHeight;
        }
        
        if (e_h < 0)
        {
            e_h = 0;
        }else if (e_h > self.cellHeight)
        {
            e_h = self.cellHeight;
        }
        
        for (int c = cell.col - w; c <= cell.col + w; c++)
        {
            if (c == cell.col)
            {
                e_w= node.size;
            }else
            {
                e_w = .5 * (node.size + self.cellWidth) - abs(c - cell.col) * self.cellWidth;
            }
            
            if (e_w < 0)
            {
                e_w = 0;
            }else if (e_w > self.cellWidth)
            {
                e_w = self.cellWidth;
            }
            
            e_resident = (e_h * e_w) / cell_area;
            if (e_resident > 1.0)
            {
                e_resident = 1.0;
            }
            
            ANLayoutGridCell* cell1 = [self cell:r col:c];
            
            if (cell1 != nil)
            {
                cell1.numberOfnodeResidents = cell1.numberOfnodeResidents + e_resident;
                
                if (cell1.strongestNodeNearby == nil || [cell1.strongestNodeNearby leafs] < node.leafs)
                {
                    cell1.strongestNodeNearby = node;
                }
            }
        }
    }

    return 0;
}

// remove "shadows" over near by cells by the given nodes
-(int)removeNodeShadow:(ANLayoutNode*) node
                  cell:(ANLayoutGridCell*) cell
{
    float fw = (.5 * (node.size - self.cellWidth)) / self.cellWidth + 1.0;
    float fh = (.5 * (node.size - self.cellHeight)) / self.cellHeight + 1.0;
    
    // effective size for the cell
    float e_w = node.size;
    float e_h = node.size;
    float cell_area = self.cellWidth * self.cellHeight;
    float e_resident = 1.0;
    
    if (fw <= 1)
    {
        fw = 0;
    }
    
    if (fh <= 1)
    {
        fh = 0;
    }
    
    // margin around cell for distribution
    int w = fw;
    int h = fh;
    
    for (int r = cell.row - h; r <= cell.row + h; r++)
    {
        if (r == cell.row)
        {
            e_h = node.size;
        }else
        {
            e_h = .5 * (node.size + self.cellHeight) - abs(r - cell.row) * self.cellHeight;
        }
        
        if (e_h < 0)
        {
            e_h = 0;
        }else if (e_h > self.cellHeight)
        {
            e_h = self.cellHeight;
        }
        
        for (int c = cell.col - w; c <= cell.col + w; c++)
        {
            if (c == cell.col)
            {
                e_w= node.size;
            }else
            {
                e_w = .5 * (node.size + self.cellWidth) - abs(c - cell.col) * self.cellWidth;
            }
            
            if (e_w < 0)
            {
                e_w = 0;
            }else if (e_w > self.cellWidth)
            {
                e_w = self.cellWidth;
            }
            
            e_resident = (e_h * e_w) / cell_area;
            if (e_resident > 1.0)
            {
                e_resident = 1.0;
            }
            
            ANLayoutGridCell* cell1 = [self cell:r col:c];
            
            if (cell1 != nil)
            {
                cell1.numberOfnodeResidents = cell1.numberOfnodeResidents - e_resident;
                if (cell1.numberOfnodeResidents < .0)
                {
                    cell1.numberOfnodeResidents = .0;
                }
            }
        }
    }
    
    return 0;
}

// return distance between node and cell (row, col)
-(float) distance:(ANLayoutNode*) node
              row:(int) row
              col:(int) col
{
    float dis = 10000000.0;
    
    if (node == nil)
    {
        return dis;
    }
    
    if (_cells == nil || row <= 0 || col <= 0 || _rows <= 0 || _cols <= 0)
    {
        return dis;
    }
    
    float x = (col + .5) * _cell_width;
    float y = (row + .5) * _cell_height;
    
    float xPos = node.rPosition * cosf(DEGREES_TO_RADIANS(node.aPosition));
    float yPos = node.rPosition * sinf(DEGREES_TO_RADIANS(node.aPosition));
    
    return sqrtf((xPos + _x0 - x) * (xPos + _x0 - x) + (yPos + _y0 - y) * (yPos + _y0 - y));
}

-(float) distance:(ANLayoutNode*) node
        xPosition:(float)xPosition
        yPosition:(float)yPosition
{
    float dis = 10000000.0;
    
    if (_cells == nil || node == nil)
    {
        return dis;
    }
    
    float dx = node.xPosition - xPosition;
    float dy = node.yPosition - yPosition;
    
    return sqrtf(dx * dx + dy * dy);
}

// return distance between two given cells
-(float) distance:(ANLayoutGridCell*) cell
            node1:(ANLayoutGridCell*) cell1
{
    if (cell == nil || cell1 == nil)
    {
        return 10000000.0;;
    }
    
    float dx = cell.col - cell1.col;
    float dy = cell.row - cell1.row;
    
    return sqrtf(dx * dx + dy * dy);
}

// return center postion for given cell (row, col)
-(float)xPos:(int)col
{
    return _cell_width * ((float)col + .5) - _x0;
}

-(float)yPos:(int)row
{
    return _cell_height * ((float)row + .5) - _y0;
}

// cell size info
-(float)cellWidth
{
    return _cell_width;
}

-(float)cellHeight
{
    return _cell_height;
}

-(float)cellSize
{
    return _cell_Size;
}

@end
