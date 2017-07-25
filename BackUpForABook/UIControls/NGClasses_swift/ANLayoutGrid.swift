//
//  ANLayoutGrid.swift
//  NGClasses
//
//  Created by iMac on 16/12/14.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ANLayoutGrid {
    var rows: Int = 0
    var cols: Int = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    // array of ANLayoutGridCell array
    fileprivate var cells = [[ANLayoutGridCell]]()
    
    // grid origin (to match the circle center)
    var x0: CGFloat = 0
    var y0: CGFloat = 0
    
    // cell size
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    var cellSize: CGFloat = 0
    
    // MARK: --------- methods ----------
    init() {
        
    }
    
    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        
        // create cell objects
        for i in 0..<rows {
            var cellI = [ANLayoutGridCell]()
            for j in 0..<cols {
                cellI.append(ANLayoutGridCell(row: i, col: j))
            }
            cells.append(cellI)
        }
    }
    
    func reset(_ rows: Int, cols: Int)  {
        if rows < 0 || cols < 0 {
            return
        }
        
        self.rows = rows
        self.cols = cols
        
        x0 = 0
        y0 = 0
        cells = [[ANLayoutGridCell]]()
        
        // create cell objects
        for i in 0..<rows {
            var cellI = [ANLayoutGridCell]()
            for j in 0..<cols {
                cellI.append(ANLayoutGridCell(row: i, col: j))
            }
            cells.append(cellI)
        }
        
        cellWidth = 0
        cellHeight = 0
        cellSize = 0
    }
    
    func reset(_ width: CGFloat, height: CGFloat, rows: Int, cols: Int)  {
        reset(rows, cols: cols)
        self.width = width
        self.height = height
        
        cellWidth = width / CGFloat(cols)
        cellHeight = height / CGFloat(rows)
        cellSize = sqrt(cellWidth * cellWidth + cellWidth * cellHeight)
        
        // coordinate origin
        x0 = width * 0.5
        y0 = height * 0.5
    }
    
    // empty nosting node (or disconnect from nodes)
    // TODO:  func, -(void) disconnectFromHostingNodes
    
    // by index
    func cell(_ row: Int, col: Int) -> ANLayoutGridCell? {
        if cells.count == 0 || row < 0 || row >= rows || col < 0 || col >= cols || rows <= 0 || rows <= 0 {
            return nil
        }
        
        return cells[row][col]
    }
    
    // by node (xPosition, yPosition) position
    func cell(_ xPos: CGFloat, yPosition yPos: CGFloat) -> ANLayoutGridCell? {
        if cells.count == 0 {
            return nil
        }
   
        var colIdx = Int((xPos + x0) / cellWidth)
        var rowIdx = Int((yPos + y0) / cellHeight)
        
        if colIdx < 0 { colIdx = 0 }
        if rowIdx < 0 { rowIdx = 0 }
        
        return cell(rowIdx, col: colIdx)
    }
    
    // host node by shortest distance.  return nil if node is not the best one
    func attach2BestMatchedNode(_ node: ANLayoutNode!) -> ANLayoutGridCell? {
        let cell = self.cell(node.xPosition, yPosition: node.yPosition)
        if cell == nil {
            return nil
        }
        
        // distance between node and cell
        let dis = distance(node, row: cell!.row, col: cell!.col)
        
        if cell!.nodeIndex < 0 || cell!.node == nil || cell!.distance2Node > dis {
            cell!.nodeIndex = node.index
            cell!.node = node
            cell!.distance2Node = dis
            
            node.gridRow = cell!.row
            node.gridCol = cell!.col
            
            return cell!
        }
        
        // not a closer one
        return nil
    }
    
    
    // called to break nodes from sharing the same cell.
    // !!! for every node it should be matched to a cell (node.grid_row, node.grid_col).  if the matched cell is also pointing back to the same node then it is considered as best match otherwise it is second or more match for nodes (many nodes are sharing the same cell) etc
    func attach2SecondBestMatchedNode(_ node: ANLayoutNode!, level: Int) -> ANLayoutGridCell? {
        if node == nil { return nil }
        
        // node's currently attached cell object
        let cell0 = self.cell(node.gridRow, col: node.gridCol)
        if cell0 == nil { return nil }
        
        let cell = cell0!
        // first level match is a best one?
        if cell.node === node {
            // yes
            return cell
        }
        
        // cell is currently ocupied by another node.  need to search for secod best one within range (-level, level)
        // the new hosting cell should be the one that has the smallest nodeMass
        var minMass = cell.nodeMass
        
        // desired distance between node and cell.node
        let dis = (node.size + cell.node.size) * 0.5
        
        var cellNew: ANLayoutGridCell!
        
        for r in (cell.row - level)...(cell.row + level) {
            for c in (cell.col - level)...(cell.col + level) {
                if r == cell.row && c == cell.col {
                    continue
                }
                
                // try at new cell position
                let cell1 = self.cell(r, col: c)
                
                if cell1 == nil || cell1!.nodeIndex >= 0 ||
                    cell1!.node != nil || cell1!.numberOfNodeResidents > 0.5 || // already ocupied by nodes
                    cell1!.nodeMass > minMass {
                    // cell1 is already taken or has more node overlap than current hosting cell
                    continue
                }
                
                if cell1!.nodeMass == minMass && cellNew != nil {
                    // already found another "best match" for node
                    continue
                }
                
                // found a sencond best match for node
                minMass = cell1!.nodeMass
                cellNew = cell1!
            }
        }
        
        // did we find a new match?
        if cellNew != nil {
            // yes.  adjust new node position
            var xPos = node.xPosition + cellWidth * CGFloat(cellNew.col - node.gridCol)
            var yPos = node.yPosition + cellHeight * CGFloat(cellNew.row - node.gridRow)
            
            // are we too far away from node node?
            let seperation = self.distance(cell.node, xPosition: xPos, yPosition: yPos)
            if seperation > dis {
                // yes.  we have too much adjustment
                // direction from cell.node to cellnew
                let angle = atan2((self.yPos(cellNew.row) - cell.node.yPosition), (self.xPos(cellNew.col) - cell.node.xPosition) )
                var dis1 = seperation - 0.25 * cellSize
                dis1 = max(dis, dis1)
                
                xPos = cell.node.xPosition + dis1 * cos(angle)
                yPos = cell.node.yPosition + dis1 * sin(angle)
            }
            
            // convert (xPos, yPos) to (rPosition, aPosition)
            node.rPosition = sqrt(xPos * xPos + yPos * yPos)
            node.aPosition = radiansToDegrees(atan2(yPos, xPos))
            
            node.rPositionTran = node.rPosition
            node.aPositionTran = node.aPosition
            
            // connect between node and cellnew
            node.gridRow = cellNew.row
            node.gridCol = cellNew.col
            
            cellNew.nodeIndex = node.index;
            cellNew.node = node;
            
            cellNew.numberOfNodeResidents = cellNew.numberOfNodeResidents + (node.size * node.size) / (cellWidth * cellHeight)
        }
        
        return cellNew
    }

  
    // given node is NOT sharing the cell with another node but sits on a cell that is "over shadowed" by other node.  one cell can be overlapped or over shadowed by more than on node.  we will move nodes away from the dominant node (the one tha has most in size measured by the number leafs under the node).  move given node away from the dominat one
    // node - node to be seperated from dominant node
    // level - maximum distance for shifting
    func moveAwayFromDominantNode(_ node: ANLayoutNode!, level: Int) -> ANLayoutGridCell? {
        if node == nil {
            // TODO: --------- return 0 in the orginal file
            //            return ANLayoutGridCell()
            return nil
        }
        
        // cell object node is associated with
        let cell = self.cell(node.gridRow, col: node.gridCol)
        if cell == nil || cell!.strongestNodeNearby == nil {
            return nil
        }
        
        if node === cell!.strongestNodeNearby && node === cell!.node {
            // no need to remove as the dominant node
            // TODO: --------- return 0 in the orginal file
            return nil
        }
        
        // desired seperation between given node and the dominant one
        let dis = node.size + cell!.strongestNodeNearby.size * 0.5
        
        // current seperation
        let dx = CGFloat(node.gridCol - cell!.strongestNodeNearby.gridCol) * cellWidth
        let dy = CGFloat(node.gridRow - cell!.strongestNodeNearby.gridRow) * cellHeight
        let dis0 = sqrt(dx * dx + dy * dy)
        
        if dis0 >= dis {
            // already has enough seperation
            return nil
        }
        
        // need to serach for secod best one within range (-level, level)
        // the new hosting cell should be the one that has the smallest nodeMass
        var minMass = cell!.nodeMass
        var minDis: CGFloat = 100000.0
        
        var cellNew: ANLayoutGridCell!
        
        // sersach for new hosting cell around cell
        var row0 = cell!.row
        var col0 = cell!.col
        
        // need to move towards the root direction
        if node.root != nil {
            // move towards root to avoid cross over links among nodes
            // root of node
            let root = (node.root)!
            // root of cell.strongestNodeNearby
            let root0 = cell!.strongestNodeNearby.root
            
            // TODO: -------- maybe something wrong
            //            if root0 == nil {
            //                root0 = cell!.strongestNodeNearby.root
            //            }
            // direction from root0 to root
            let angle = atan2((root.yPosition - root0!.yPosition), (root.xPosition - root0!.xPosition))
            
            var dx = CGFloat(level) * cos(angle)
            var dy = CGFloat(level) * sin(angle)
            
            // find the best match in the range of level around (cell.row + dy, cell.col + dx)
            if dx - CGFloat(Int(dx)) > 0.5 { dx += 1 }
            if dy - CGFloat(Int(dy)) > 0.5 { dy += 1 }
            
            row0 = cell!.row + Int(dy)
            col0 = cell!.col + Int(dx)
        } else {
            row0 = cell!.row
            col0 = cell!.col
        }
        
        // serach for new hosting cell near (row0, col0)
        // node does not have root
        for r in (row0 - level)...(row0 + level) {
            for c in (col0 - level)...(col0 + level) {
                if r == row0 && c == col0 {
                    continue
                }
                
                // try at new cell position
                let cell1 = self.cell(r, col: c)
                if cell1 == nil || cell1!.nodeMass > minMass {
                    // cell1 is already taken or has more node overlap than current hosting cell
                    continue
                }
                
                if cell1 == nil || cell1!.nodeIndex >= 0 ||
                    cell1!.node != nil || cell1!.numberOfNodeResidents > 0.5 || // already ocupied by nodes
                    cell!.node === cell1!.strongestNodeNearby || cell1!.nodeMass > minMass {
                    // already found another "best match" for node
                    continue
                }
                // found a sencond best match for node
                minMass = cell1!.nodeMass
                minDis = self.distance(cell1, node1: cell1)
                cellNew = cell1
            }
        }

        // did we find a new match?.  shift enough space only
        if cellNew != nil {
            // yes.  adjust new node position
            var xPos = node.xPosition + cellWidth * CGFloat(cellNew!.col - node.gridCol)
            var yPos = node.yPosition + cellHeight * CGFloat(cellNew!.row - node.gridRow)
            
            // are we too far away from node cell.strongestNodeNearby?
            let seperation = self.distance(cell!.strongestNodeNearby, xPosition: xPos, yPosition: yPos)
            if seperation > dis {
                // yes.  we have too much adjustment.  shrink by one cell size
                // direction from cell.strongestNodeNearby to cellnew
                let angle = atan2((self.yPos(cellNew.row) - cell!.strongestNodeNearby.yPosition), (self.xPos(cellNew.col) - cell!.strongestNodeNearby.xPosition))
                let dis1 = max(seperation - 0.5 * cellSize, dis)
                
                xPos = cell!.strongestNodeNearby.xPosition + dis1 * cos(angle)
                yPos = cell!.strongestNodeNearby.yPosition + dis1 * sin(angle)
                
                // convert (xPos, yPos) to (rPosition, aPosition)
                node.rPosition = sqrt(xPos * xPos + yPos * yPos)
                node.aPosition = radiansToDegrees(atan2(yPos, xPos))
            }
            
            // connect between node and cellnew
            node.gridRow = cellNew.row
            node.gridCol = cellNew.col
            cellNew.nodeIndex = node.index
            cellNew.node = node
            cellNew.numberOfNodeResidents = cellNew.numberOfNodeResidents + (node.size * node.size) / (cellWidth * cellHeight)
            
        }
        // TODO: -------------   return 0 in orginal file
        return cellNew
    
  }
    
    // add "shadows" over near by cells by the given node
    func addNodeShadow(_ node: ANLayoutNode!, cell: ANLayoutGridCell!) {
        // MARK: ---------- new added  
        if node == nil || cell == nil {
            return
        }
        
        var fw = 0.5 * (node.size - cellWidth) / cellWidth + 1.0
        var fh = 0.5 * (node.size - cellHeight) / cellHeight + 1.0
        
        // effective size for the cell
        var e_w = node.size
        var e_h = node.size
        let cell_area = cellWidth * cellHeight
        var e_resident: CGFloat = 1.0
        
        if fw <= 1 { fw = 0 }
        if fh <= 1 { fh = 0 }
        
        // margin around cell for distribution
        let w = Int(fw)
        let h = Int(fh)
        
        for r in (cell.row - h)...(cell.row + h) {
            e_h = (r == cell.row) ? node.size : (0.5 * (node.size + cellHeight) - CGFloat(abs(r - cell.row)) * cellHeight)
            e_h = max(min(e_h, cellHeight),0)
            
            for c in (cell.row - w)...(cell.row + w) {
                e_w = (c == cell.col) ? node.size : (0.5 * (node.size + cellWidth) - CGFloat(abs(c - cell.col)) * cellWidth)
                e_w = max(min(e_w, cellWidth),0)
                
                e_resident = max(e_h * e_w / cell_area, 1.0)
                
                let cell1 = self.cell(r, col: c)
                if cell1 != nil {
                    cell1!.numberOfNodeResidents = cell1!.numberOfNodeResidents + e_resident
                    if cell1!.strongestNodeNearby == nil || cell1!.strongestNodeNearby.leafs < node.leafs {
                        cell1!.strongestNodeNearby = node
                    }
                }
            }
        }
    }
    // remove "shadows" over near by cells by the given nodes
    // TODO: func,  -(int)removeNodeShadow:(ANLayoutNode*) node cell:(ANLayoutGridCell*) cell
    
    
    // return distance between node and cell (row, col)
    func distance(_ node: ANLayoutNode!, row: Int, col: Int) -> CGFloat {
        let dis: CGFloat = 10000000.0
        if node == nil { return dis }
        
        if cells.count == 0 || row <= 0 || col <= 0 || rows <= 0 || cols <= 0 {
            return dis
        }
        
        let x = (CGFloat(col) + 0.5) * cellWidth
        let y = (CGFloat(row) + 0.5) * cellHeight
        
        let xPos = node.rPosition * cos(degreesToRadians(node.aPosition))
        let yPos = node.rPosition * sin(degreesToRadians(node.aPosition))
        
        let x1 = xPos + x0 - x
        let y1 = yPos + y0 - y
        
        return sqrt(x1 * x1 + y1 * y1)
    }

    func distance(_ node: ANLayoutNode!, xPosition: CGFloat, yPosition: CGFloat) -> CGFloat {
        let dis: CGFloat = 10000000.0
        
        if cells.count == 0 || node == nil {
            return dis
        }
        
        let dx = node.xPosition - xPosition
        let dy = node.yPosition - yPosition
        
        return sqrt(dx * dx + dy * dy)
    }
    
    
    // return distance between two given cells
    func distance(_ cell: ANLayoutGridCell!, node1 cell1: ANLayoutGridCell!) -> CGFloat {
        if cell == nil || cell1 == nil {
            return 10000000.0
        }
        let dx = CGFloat(cell.col - cell1.col)
        let dy = CGFloat(cell.row - cell1.row)
        
        return sqrt(dx * dx + dy * dy)
    }
    
    // return center postion for given cell (row, col)
    func xPos(_ col: Int) -> CGFloat {
        return cellWidth * (CGFloat(col) + 0.5) - x0
    }
    
    func yPos(_ row: Int) -> CGFloat {
        return cellHeight * (CGFloat(row) + 0.5) - y0
    }

}
