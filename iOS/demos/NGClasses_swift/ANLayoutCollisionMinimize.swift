//
//  ANLayoutCollisionMinimize.swift
//  NGClasses
//
//  Created by iMac on 16/12/14.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit


// private fumctions
//////////////////////////////////////////////////////////////////////////////
// clear association and connections among nodes and cells
func removeTreeNodeGridCellConnections(_ node: ANLayoutNode!, grid: ANLayoutGrid!) {
    if node == nil || grid == nil {
        return
    }
    
    let cell = grid.cell(node.gridRow, col: node.gridCol)
    if cell != nil {
        node.gridRow = -1
        node.gridCol = -1
        
        cell!.nodeIndex = -1
        cell!.node = nil
        cell!.strongestNodeNearby = nil
        cell!.numberOfNodeResidents = 0
        cell!.nodeMass = 0
        cell!.nodeMassGradient = 0
        cell!.distance2Node = 1000000.0
    }
    
    for child in node.children {
        removeTreeNodeGridCellConnections(child, grid: grid)
    }
}

//////////////////////////////////////////////////////////////////////////////
// !!! scan over tree nodes to assign each node with their matched cell index while each cell can be assigned to only one node that are best matched to the cell by the distance
func bestNodeMatch(_ node: ANLayoutNode!, grid: ANLayoutGrid!, params: inout MinimizeNodeDensityParams) {
    if node == nil || grid == nil {
        return
    }
    
    // (1) get grid cell that this node falls onto
    let cell = grid.cell(node.xPosition, yPosition: node.yPosition)
    
    // (2) "spread" node mass across nearby cells
    if cell != nil {
        // cell match for this node
        node.gridRow = cell!.row
        node.gridCol = cell!.col
        
        // cell node mass distribution (by distibution function)
        switch params.massDistribution {
        case .levelOne:
            for r in (cell!.row - 1)...(cell!.row + 1) {
                for c in (cell!.col - 1)...(cell!.col + 1) {
                    let cell1 = grid.cell(r, col: c)
                    if cell1 == nil { continue }
                    
                    if r == cell!.row && c == cell!.col {
                        cell1!.nodeMass += node.size
                    }else {
                        cell1!.nodeMass += (node.size / CGFloat(abs(r - cell!.row) + abs(c - cell!.col)))    // intensity because of distance
                    }
                }
            }
        case .levelTwo:
            for r in (cell!.row - 2)...(cell!.row + 2) {
                for c in (cell!.col - 2)...(cell!.col + 2) {
                    let cell1 = grid.cell(r, col: c)
                    if cell1 == nil { continue }
                    
                    if r == cell!.row && c == cell!.col {
                        cell1!.nodeMass += node.size
                    }else {
                        cell1!.nodeMass += (node.size / CGFloat(abs(r - cell!.row) + abs(c - cell!.col)))    // intensity because of distance
                    }
                }
            }
        case .charge: break
        }
    }
    
    // (3) if node size is greater that cell size "spread" node resident to covered cells
    grid.addNodeShadow(node, cell: cell)

    // (4) best match for the cell
    let _ = grid.attach2BestMatchedNode(node)
    
    // all child nodes
    for child in node.children {
        bestNodeMatch(child, grid: grid, params: &params)
    }
    

}

// scan tree node again to assign new cell if the node is not the best match current cell
func nodeCellRematch(_ node: ANLayoutNode!, grid: ANLayoutGrid, params: inout MinimizeNodeDensityParams) {
    if node == nil { return }
    // node and cell matched to each other?
    var cell = grid.cell(node.xPosition, yPosition: node.yPosition)
    
    if cell == nil {
        // not attached to cell
        let _ = grid.attach2BestMatchedNode(node)
    } else if cell!.node != nil && cell!.node !== node {
        // not best match.  try to find another "empty" cell for this node
        // !! need to do this according to params.  for now we will serach for cell within two level cell layers: (-level, level) index range
        // (rPosition, aPosition) will be updated after this call
        cell = grid.attach2SecondBestMatchedNode(node, level: 1)
    }
    
    // all child nodes
    for child in node.children {
        nodeCellRematch(child, grid: grid, params: &params)
    }
}

// disconnect "weak" overlapped neighbor nodes from their hosting cells
func removeWeakOverlappedNodes(_ grid: ANLayoutGrid, params: inout MinimizeNodeDensityParams) {
    // (1) scan all cells and locate cell that has numberOfnodeResidents > 1.
    for r in 0..<grid.rows {
        for c in 0..<grid.cols {
            let cell = grid.cell(r, col: c)
            
            if cell == nil || cell!.numberOfNodeResidents <= 1 || cell!.node == nil || cell!.strongestNodeNearby === cell!.node {
                continue
            }
            // found one node whose hosting cell overlap with nearby nodes and is NOT the strongest one. we need to remove this node
            var fw = 0.5 * (cell!.node.size - grid.cellWidth) / grid.cellWidth + 1.0
            var fh = 0.5 * (cell!.node.size - grid.cellHeight) / grid.cellHeight + 1.0
            
            if fw <= 1 { fw = 0 }
            if fh <= 1 { fh = 0 }
            
            let w = Int(fw)
            let h = Int(fh)
            
            for r1 in (cell!.row - h)...(cell!.row + h) {
                for c1 in (cell!.col - w)...(cell!.col + w) {
                    let cell1 = grid.cell(r1, col: c1)
                    if cell1 != nil {
                        cell1!.numberOfNodeResidents = cell1!.numberOfNodeResidents - 1
                    }
                }
            }
        }
    }
}

// match to cell around current location
func nodeCellBestMatch(_ node: ANLayoutNode!, grid: ANLayoutGrid, params: inout MinimizeNodeDensityParams) {
    if node == nil{
        return
    }
    
    // node and cell matched to each other?
    let cell = grid.cell(node.xPosition, yPosition: node.yPosition)
    if cell == nil {
        // not attached to cell
        let _ = grid.attach2BestMatchedNode(node)
    } else if cell!.strongestNodeNearby !== node {
        // node is within a cell that shared by multiple nodes and the domainet node is NOT current one
        // increase the seperation between node and nearby dominating node
        // !!! note that different from calling attach2SecondBestMatchedNode that is used for solving the problem of having more than one node sharing the same cell
        // (rPosition, aPosition) will be updated after this call
//        cell = grid.moveArrayFromDomainantNode()
    }
    
    // all child nodes
    for child in node.children {
        nodeCellBestMatch(child, grid: grid, params: &params)
    }
}

// break apart (or increase distance) nodes that "sits" on different cells but overlap each other
func reduceNodeCellOverlap(_ node: ANLayoutNode!, grid: ANLayoutGrid, params: inout MinimizeNodeDensityParams) {
    if (node == nil) { return }
    
    // (1) remove "weak" overlapped neighbor nodes first
    removeWeakOverlappedNodes(grid, params: &params)
    
    // (2) find best match to the cell around current cell location
    nodeCellBestMatch(node, grid: grid, params: &params)
}


// end of _reduceNodeCellOverlap

//////////////////////////////////////////////////////////////////////////
// move node around near by layout cells to minimize collision among nodes
// by minimizing cell node density

// !!! nodes have to be already projected onto the hosting

// define parameter structure

// node mass cell distribution methods
enum NodeMassDistribution {
    case levelOne           // over nearst cell
    case levelTwo           // over two cell neighbors
    case charge             //
}

struct MinimizeNodeDensityParams {
    // ratio for margin: cell size = node size * _marginRatio
    var marginRatio: CGFloat = 1.2
    
    // size zoom factor
    var sizeZoomRatio: CGFloat = 5
    
    // dynamic values
    var nodeDensity: CGFloat = 0    // number of nodes / number of cells
    
    // node distribution functions over cell
    var massDistribution: NodeMassDistribution = .levelTwo
}


class ANLayoutCollisionMinimize {
    var params = MinimizeNodeDensityParams()
    
    fileprivate var grid = ANLayoutGrid()
    
    // attach grid object to node
    // 1. estimate average node size
    // 2. estimate average cell size
    // 3. estimate node / cell density
    func attachNodeToGrid(_ node: ANLayoutNode!) {
        // (1) get tree size
        var treeSize: CGFloat = 0
        var treeSizeTran: CGFloat = 0
        var edgeTran: CGFloat = 0
        getTreeLength(node, length: &treeSize, lengthTran: &treeSizeTran, edgeTran: &edgeTran)
        
        // (2) get average node size
        var totalSize: CGFloat = 0
        var numberOfNodes: CGFloat = 0
        getTreeNodeAverageSize(node, totalSize: &totalSize, numberOfNodes: &numberOfNodes)
       
        if numberOfNodes == 0 { return }
   
        let aveNodeSize = totalSize / numberOfNodes
        
        // (3) node cell density
        // grid dimention.
        var m = Int (2 * treeSize / aveNodeSize)
        
        // !!! to do.  make sure that grid can be zoomed in via 3 by 3
        m = (m / 3 + 1 ) * 3
        
        // number of nodes per grid cell
        params.nodeDensity = CGFloat(numberOfNodes) / CGFloat(m * m)
    
        // (4) create grid
        grid.reset(2 * treeSize, height: 2 * treeSize, rows: m, cols: m)
        
    }
    
    // adjust node positions to minimix=za collision
    // !!! assumes that attachNodeToGrid was already called before calling this one
    // !!! after this call each node should be matched to a hosting cell (node.grid_row, node.grid_col).  if the matched cell is also pointing back to the same node then it is considered as best match otherwise it is second or more match for nodes (many nodes are sharing the same cell) etc
    func minimizeNodeCollisions_Density(_ node: ANLayoutNode!) {
        // adjust node positions to minimix=za collision
        // !!! assumes that attachNodeToGrid was already called before calling this one
        if node == nil { return }
        
        ////////////////////////////////////////////////////////////////
        // first round
        ////////////////////////////////////////////////////////////////
        
        // (1) project (rPosition, aPosition) to (xPosition, yPosition)
        updateNodeXYPositions(node)

        // (2) remove node current grid cell index
        removeTreeNodeGridCellConnections(node, grid: grid)
        
        // (3) best match for node and cell seperatly
        bestNodeMatch(node, grid: grid, params: &params)

        // (4) rematch of un-hosted nodes
        nodeCellRematch(node, grid: grid, params: &params)
        
        ////////////////////////////////////////////////////////////////
        // second round
        ////////////////////////////////////////////////////////////////
        // (5) project midified (rPosition, aPosition) to (xPosition, yPosition)
        updateNodeXYPositions(node)
        
        // (6) remove node current grid cell index
        removeTreeNodeGridCellConnections(node, grid: grid)
        
        // (7) best match for node and cell seperatly
        bestNodeMatch(node, grid: grid, params: &params)
        
        // (8) break apart (or increase distance) nodes that "sits" on different cells but overlap each other
        reduceNodeCellOverlap(node, grid: grid, params: &params)
        
        ////////////////////////////////////////////////////////////////
        // final round
        ////////////////////////////////////////////////////////////////
        // we are done reducing the node collision.  update latest layout overlap information
        // (9) project midified (rPosition, aPosition) to (xPosition, yPosition)
        updateNodeXYPositions(node)
        
        // (10) remove node current grid cell index
        removeTreeNodeGridCellConnections(node, grid: grid)
        
        // (11) best match for node and cell seperatly
        bestNodeMatch(node, grid: grid, params: &params)
    }
}
