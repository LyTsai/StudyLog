//
//  ANTreeGraphLayout.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/15.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: Defination of Node
enum SizeType {
    case NA                // not defined
    case Fixed             // fixed size
    case Ratio             // proprtional to the total size
    case EvenDistributed   // even distributed of total among nodes
}

class ANTreeNode {
    /** the view or layer of this node*/
    var obj: AnyObject!
    /** used to calculate the size of node */
    var sizeType: SizeType = .EvenDistributed
    var ratio: CGFloat = 0.1
    var weight : CGFloat = 1.0
    
    /** if the tree is layout topDown, is middleX, used for row */
    var position: CGFloat = 0.0
    /** if the tree is layout topDown, is width. Height is decided by type or row's height) */
    var size: CGFloat = 44
    var maxSize: CGFloat = 64
    var minSize: CGFloat = 22
}

// MARK: Defination of Row
enum Alignment {
    case Center            // line up row around center position
    
    case Left              // line up nodes to left position
    case Right             // line up nodes to right position
    
    case AnchorNode        // line up nodes using anchor point node from row above
}

struct IndexPath {
    var row: Int
    var column: Int
}

class ANTreeRow {
    var sizeType: SizeType = .EvenDistributed
    var ratio: CGFloat = 0.1
    var weight : CGFloat = 1.0
    /** the alignment of nodes in this row */
    var alignment: Alignment = .Center
    
    /** height of this row */
    var size: CGFloat = 44
    var maxSize: CGFloat = 64
    var minSize: CGFloat = 22
    /** the middleY used for map */
    var position: CGFloat = 0.0
    
    /** size (including the margins on both edges) of this row */
    var width: CGFloat = 600
    var leftMargin: CGFloat = 0.0
    var rightMargin: CGFloat = 0.0
    var nodeGap: CGFloat = 0.0
    
    // the node in this array cannot be nil 
    // if no nodes, is a void array
    private var nodes = [ANTreeNode]()
    
    func addNode(node: ANTreeNode?) -> Int {
        if node != nil {
            nodes.append(node!)
        }
        return nodes.count
    }
    
    func numberOfNodes() -> Int {
        return nodes.count
    }
    
    func nodeAtIndex(index: Int) -> ANTreeNode? {
        if index < 0 || index >= numberOfNodes() {
            return nil
        }
        return nodes[index]
    }
    
    func clearNodes()  {
        nodes.removeAll()
    }
    
    // -1 indicates no anchor point is assigned, and the center will be used as anchor point
    var anchorNodeIndex: Int = -1
    var parentAnchorNodeIndexPath = IndexPath(row: -1, column: -1)
    var anchorNode: ANTreeNode? {
        get {
            if anchorNodeIndex >= nodes.count {
                return nil
            }
            if anchorNodeIndex < 0  {
                switch alignment {
                case .AnchorNode:
                    if nodes.count != 0 {
                        return nodes.count % 2 == 0 ? nodes[nodes.count/2 - 1] : nodes[(nodes.count - 1)/2]
                    }
                    //TODO: left and right, not ok now, change later
                case .Left:
                    return nodes.first
                case .Right:
                    return nodes.last
                default:
                    return nil
                }
            }
            return nodes[anchorNodeIndex]
        }
    }
   
    func setAnchorNodePosition(position: CGFloat)  {
        let node = anchorNode
        if node != nil {
            node!.position = position
        }
    }

    func resize()  {
        if abs(width) <= 1e-06 {
            return
        }
        var wtotal = width - leftMargin - rightMargin
        var n: CGFloat = 0.0
        var w: CGFloat = 0.0
      
        // In one row, the nodes can have different sizeTypes
        // |-leftMargin-|-gap-|-node-|-gap-|...|-node-|-gap-|-righMargin-|
        for (_, node) in nodes.enumerate() {
            switch node.sizeType {
            case .Fixed:
                node.size = min(max(node.size, node.minSize), node.maxSize)
                wtotal -= nodeGap + node.size
            case .Ratio:
                // use the height of row to decide the rect of node
                node.size = min(max(node.ratio * size, node.minSize), node.maxSize)
                wtotal -= nodeGap + node.size
            case .EvenDistributed:
                n += node.weight
            default:
                break
            }
        }
        
        // Calculate for sizeType.EvenDistributed
        if abs(n) > 1e-06 {
            w = (wtotal - nodeGap) / n
        }
        for node in nodes {
            if node.sizeType == .EvenDistributed {
                node.size = min(max(w * node.weight - nodeGap, node.minSize), node.maxSize)
            }
        }
        
        let anchorPosition = (anchorNode != nil && anchorNode!.position >= 0) ? anchorNode!.position : width * 0.5

        var l: CGFloat = 0.0
        var s: CGFloat = leftMargin + nodeGap
        for node in nodes {
            node.position = s + node.size * 0.5
            s = node.position + node.size * 0.5 + nodeGap
        }
        l = s

        s = 0
        if anchorNode != nil {
            s = anchorPosition - anchorNode!.position
        }else {
            s = (width - l) * 0.5
        }
        
        if s > 0 {
            s = min(s, width - nodes.last!.position - rightMargin)
        }else {
            s = max(s, leftMargin - nodes.first!.position)
        }
        
        // for -1 anchor && even number
        if alignment == .AnchorNode && anchorNodeIndex < 0 && nodes.count%2 == 0{
            s -= (size + nodeGap) * 0.5
        }
        
        for node in nodes {
            node.position += s
        }
    }
}

// MARK: Map
class ANTreeMap {
    var topMargin: CGFloat = 0
    var bottomMargin: CGFloat = 0
    var rowGap: CGFloat = 22
    
    // array of ANTreeRow.
    // array informastion:
    // (1) the first array element is root, element i is one row above next array element i+1
    // (2) root node is located at the center horizoatal position
    private var rows = [ANTreeRow]()
    private var origin: CGPoint = CGPointZero
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    // MARK: collection of rows
    func addRow(row: ANTreeRow?) -> Int {
        if row != nil {
            rows.append(row!)
        }
        
        return rows.count
    }
    
    func numberOfRows() -> Int {
        return rows.count
    }
    
    func rowAtIndex(index: Int) -> ANTreeRow? {
        if index < 0 || index >= rows.count {
            return nil
        }
        
        return rows[index]
    }
    
    func clearRows()  {
        rows.removeAll()
    }
    
    // the orginal data of node, add the origin data to show in map
    func getCellRectAtIndexPath(indexPath: IndexPath) -> CGRect {
        if indexPath.row >= rows.count || indexPath.column >= rowAtIndex(indexPath.row)!.numberOfNodes() {
            return CGRectZero
        }
        
        let row = rowAtIndex(indexPath.row)
        if row == nil {
            return CGRectZero
        }
        
        let node = row!.nodeAtIndex(indexPath.column)
        if node == nil {
            return CGRectZero
        }
        
        return CGRect(x: origin.x + node!.position - node!.size * 0.5, y: origin.y + row!.position - row!.size * 0.5, width: node!.size, height: row!.size)
    }
    
    private func resizeWithCGSize(size: CGSize) {
        width = size.width
        height = size.height
        
        if rows.count == 0 || abs(width) <= 1e-6 || abs(height) <= 1e-6 {
            return
        }
        
        resizeRowHeights()
        
        // set heights for all rows first
        // set node width for all nodes in each row.
        // !!! you have to make sure to set the anchor node for each row before resizing nodes
        // make sure you start from 0 element
        for (i, row) in rows.enumerate() {
            let anchorNode = row.anchorNode
  
            if anchorNode != nil {
                switch row.alignment {
                case .AnchorNode:
                    let nodeIndexPath = row.parentAnchorNodeIndexPath
                    let refRow = rowAtIndex(nodeIndexPath.row)
                    let refNode = (refRow != nil) ? refRow!.nodeAtIndex(nodeIndexPath.column) : nil

                    if nodeIndexPath.row < i && refNode != nil {
                        anchorNode!.position = refNode!.position
                    } else {
                        let rowAbove = rows[i - 1]
                        let firstNode = rowAbove.nodeAtIndex(0)!
                        let lastNode = rowAbove.nodeAtIndex(rowAbove.numberOfNodes() - 1)!
                        anchorNode!.position = (firstNode.position + lastNode.position) * 0.5 + rowAbove.nodeGap
                    }
                case .Center:
                    anchorNode!.position = width * 0.5
                case .Left:
                    anchorNode!.position = 0
                case .Right:
                    anchorNode!.position = width
                }
            }
            row.width = width
            row.resize()
        }
    }
    
    func setFrame(rect: CGRect)  {
        origin = rect.origin
        resizeWithCGSize(rect.size)
    }
    
    func resizeRowHeights()  {

        if abs(height) <= 1e-6 || rows.count == 0 {
            return
        }
        var n: CGFloat = 0
        var h: CGFloat = 0
        var hTotal : CGFloat = height - topMargin - bottomMargin

        for row in rows {
            switch row.sizeType {
            case .Fixed:
                row.size = min(max(row.size, row.minSize), row.maxSize)
                hTotal -= rowGap + row.size
            case .Ratio:
                row.size = min(max(row.ratio * height, row.minSize), row.maxSize)
                hTotal -= rowGap + row.size
            case .EvenDistributed:
                n += row.weight
            default:
                break
            }
        }
        
        // Calculate for sizeType.EvenDistributed
        if abs(n) > 1e-06 {
            h = (hTotal - rowGap) / n
        }
        for row in rows {
            if row.sizeType == .EvenDistributed {
                row.size = min(max(h * row.weight - rowGap, row.minSize), row.maxSize)
            }
        }
        
        var s = rowGap + topMargin
        for row in rows {
            row.position = s + row.size * 0.5
            s = row.position + row.size * 0.5 + rowGap
        }
    }
}

// return view object (of either UIView or CALayer) for given node at (row, column)
// MARK: the protocal which combine the view with the layout
protocol ANTreeMapDataSourceProtocal {
    
    func getNodeView(row row: Int, column: Int) -> AnyObject?

    // tree map structure
    /** return number of rows */
    func numberOfRows() -> Int
    /** return gap among rows */
    func getRowGap() -> CGFloat
    // return margins at top and bottom
    func getTopMargin() -> CGFloat
    func getBottomMargin() -> CGFloat
    
    // information for each row
    func numberOfColumns(row: Int) -> Int
    // return layout information for given row
    func getRowSizeType(row: Int) -> SizeType
    func getRowMaxSize(row: Int) -> CGFloat
    func getRowMinSize(row: Int) -> CGFloat
    func getSize(row: Int) -> CGFloat
    func getRatio(row: Int) -> CGFloat
    func getWeight(row: Int) -> CGFloat
    func getNodeGap(row: Int) -> CGFloat
    func getLeftEdgeMargin(row: Int) -> CGFloat
    func getRightEdgeMargin(row: Int) -> CGFloat
    
    // archor node in current row
    func getAnchorNodeIndex(row: Int) -> Int
    // parent node (from row above) of archor node for getting anchor node position.
    func getAnchorNodeParentIndexPath(row: Int) -> IndexPath
    // type of anchor
    func getAlignment(row: Int) -> Alignment
  
    // information for each node
    // return layout information for given node at (row, column)
    func getNodeSizeType(row row: Int, column: Int) -> SizeType
    func getNodeMaxSize(row row: Int, column: Int) -> CGFloat
    func getNodeMinSize(row row: Int, column: Int) -> CGFloat
    func getNodeSize(row row: Int, column: Int) -> CGFloat
    func getNodeRatio(row row: Int, column: Int) -> CGFloat
    func getNodeWeight(row row: Int, column: Int) -> CGFloat
}

class ANTreeGraphLayout: ANTreeMap {
    // delegate for callback event purpose
    var dataSoure: ANTreeMapDataSourceProtocal!
    func reloadData()  {
        clearRows()
        
        rowGap = dataSoure.getRowGap()
        topMargin = dataSoure.getTopMargin()
        bottomMargin = dataSoure.getBottomMargin()
        
        let nRows = dataSoure.numberOfRows()
        for i in 0..<nRows {
            let oneRow = ANTreeRow()
            let nNodes = dataSoure.numberOfColumns(i)

            for j in 0..<nNodes {
                let oneNode = ANTreeNode()
                oneNode.obj = dataSoure.getNodeView(row: i, column: j)
                oneNode.sizeType = dataSoure.getNodeSizeType(row: i, column: j)
                oneNode.size = dataSoure.getNodeSize(row: i, column: j)
                oneNode.ratio = dataSoure.getNodeRatio(row: i, column: j)
                oneNode.weight = dataSoure.getNodeWeight(row: i, column: j)
                oneNode.maxSize = dataSoure.getNodeMaxSize(row: i, column: j)
                oneNode.minSize = dataSoure.getNodeMinSize(row: i, column: j)
                
                oneRow.addNode(oneNode)
            }
            
            // return layout information for given row
            oneRow.sizeType = dataSoure.getRowSizeType(i)
            oneRow.maxSize = dataSoure.getRowMaxSize(i)
            oneRow.minSize = dataSoure.getRowMinSize(i)
            oneRow.size = dataSoure.getSize(i)
            oneRow.ratio = dataSoure.getRatio(i)
            oneRow.weight = dataSoure.getWeight(i)
            oneRow.nodeGap = dataSoure.getNodeGap(i)
            oneRow.anchorNodeIndex = dataSoure.getAnchorNodeIndex(i)
            oneRow.parentAnchorNodeIndexPath = dataSoure.getAnchorNodeParentIndexPath(i)
            oneRow.alignment = dataSoure.getAlignment(i)
            oneRow.leftMargin = dataSoure.getLeftEdgeMargin(i)
            oneRow.rightMargin = dataSoure.getRightEdgeMargin(i)

            addRow(oneRow)
        }
        
        resizeWithCGSize(CGSize(width: width, height: height))
    }
}

