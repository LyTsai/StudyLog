//
//  ANLayoutGrid.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 2/13/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANLayoutGridCell.h"

// representing current node distribution over rect grid area.  the grid is of the same size as virtual radial circle where the virtual cicle is partitioned into grid of cells
// cell grid used for reducing node overlap.  the grid is created on top of node layput rect area with each cell accumulating "potential" as result of near by node distribution
@interface ANLayoutGrid : NSObject

-(instancetype)initWith:(int)cols
                   rows:(int)rows;
// grid size
@property int rows;
@property int cols;
@property float width;
@property float height;

// reset grid
-(void) reSet:(int)rows
         cols:(int)cols;

-(void) reSet:(float) width
       height:(float) height
         rows:(int) rows
         cols:(int) cols;

// empty nosting node (or disconnect from nodes)
-(void) disconnectFromHostingNodes;

// access to grid cell

// by index
-(ANLayoutGridCell*)cell:(int)row
                     col:(int)col;

// by position
-(ANLayoutGridCell*)cell:(float) xPosition
               yPosition:(float) yPosition;

// host node by shortest distance.  return nil if node is not the best one
-(ANLayoutGridCell*) attch2BestMatchedNode:(ANLayoutNode*) node;

// !! need to do this according to params.  for now we will serach for cell within two level cell layers: (1, -1) index range
-(ANLayoutGridCell*) attch2SecondBestMatchedNode:(ANLayoutNode*) node
                                           level:(int)level;

// given node is sharing the cell with another dominant node.  move given node away from the dominat one
// node - node to be seperated from dominant node
// level - maximum distance for shifting
-(ANLayoutGridCell*) moveAwayFromDominantNode:(ANLayoutNode*) node
                                        level:(int)level;

// add "shadows" over near by cells by the given node
-(int)addNodeShadow:(ANLayoutNode*) node
               cell:(ANLayoutGridCell*) cell;

// remove "shadows" over near by cells by the given nodes
-(int)removeNodeShadow:(ANLayoutNode*) node
                  cell:(ANLayoutGridCell*) cell;

// return distance between node and cell
-(float) distance:(ANLayoutNode*) node
              row:(int) row
              col:(int) col;

-(float) distance:(ANLayoutNode*) node
        xPosition:(float)xPosition
        yPosition:(float)yPosition;

// return distance between two given cells
-(float) distance:(ANLayoutGridCell*) cell
            node1:(ANLayoutGridCell*) cell1;

// return center postion for given cell (row, col) in circle coordinate
-(float)xPos:(int)col;
-(float)yPos:(int)row;

// cell size info
-(float)cellWidth;
-(float)cellHeight;
-(float)cellSize;

@end
