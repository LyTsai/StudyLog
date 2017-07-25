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
    case fixed             // fixed size
    case ratio             // proprtional to the total size
    case evenDistributed   // even distributed of total among nodes
}

struct NodeIndexPath {
    var row: Int
    var column: Int
}

class ANTreeNode {
    /** the view or layer of this node*/
    var obj: AnyObject!
    /** used to calculate the size of node */
    var sizeType: SizeType = .evenDistributed
    var ratio: CGFloat = 0.1
    var weight : CGFloat = 1.0
    
    /** if the tree is layout topDown, is middleX, used for row */
    var position: CGFloat = 0.0
    /** if the tree is layout topDown, is width. Height is decided by type or row's height) */
    var size: CGFloat = 44
    var maxSize: CGFloat = 64
    var minSize: CGFloat = 22
    
    var nodeFrame: CGRect = CGRect.zero
}

// MARK: Defination of Row
enum Alignment {
    case center            // line up row around center position
    
    case left              // line up nodes to left position
    case right             // line up nodes to right position
    
    case anchorNode        // line up nodes using anchor point node from row above
}

class ANTreeRow {
    var sizeType: SizeType = .evenDistributed
    var ratio: CGFloat = 0.1
    var weight : CGFloat = 1.0
    /** the alignment of nodes in this row */
    var alignment: Alignment = .center
    
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
    fileprivate var nodes = [ANTreeNode]()
    
    func addNode(_ node: ANTreeNode?) -> Int {
        if node != nil {
            nodes.append(node!)
        }
        return nodes.count
    }
    
    func numberOfNodes() -> Int {
        return nodes.count
    }
    
    func nodeAtIndex(_ index: Int) -> ANTreeNode? {
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
    var parentAnchorNodeIndexPath = NodeIndexPath(row: -1, column: -1)
    var anchorNode: ANTreeNode? {
        get {
            if anchorNodeIndex >= nodes.count {
                return nil
            }
            if anchorNodeIndex < 0  {
                switch alignment {
                case .anchorNode:
                    if nodes.count != 0 {
                        return nodes.count % 2 == 0 ? nodes[nodes.count/2 - 1] : nodes[(nodes.count - 1)/2]
                    }
                    //TODO: left and right, not ok now, change later
                case .left:
                    return nodes.first
                case .right:
                    return nodes.last
                default:
                    return nil
                }
            }
            return nodes[anchorNodeIndex]
        }
    }
   
    func setAnchorNodePosition(_ position: CGFloat)  {
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
        for (_, node) in nodes.enumerated() {
            switch node.sizeType {
            case .fixed:
                node.size = min(max(node.size, node.minSize), node.maxSize)
                wtotal -= nodeGap + node.size
            case .ratio:
                // use the height of row to decide the rect of node
                node.size = min(max(node.ratio * size, node.minSize), node.maxSize)
                wtotal -= nodeGap + node.size
            case .evenDistributed:
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
            if node.sizeType == .evenDistributed {
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
        if alignment == .anchorNode && anchorNodeIndex < 0 && nodes.count%2 == 0{
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
    fileprivate var rows = [ANTreeRow]()
    fileprivate var origin: CGPoint = CGPoint.zero
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    // MARK: collection of rows
    func addRow(_ row: ANTreeRow?) -> Int {
        if row != nil {
            rows.append(row!)
        }
        
        return rows.count
    }
    
    func numberOfRows() -> Int {
        return rows.count
    }
    
    func rowAtIndex(_ index: Int) -> ANTreeRow? {
        if index < 0 || index >= rows.count {
            return nil
        }
        
        return rows[index]
    }
    
    func clearRows()  {
        rows.removeAll()
    }
    
    // the orginal data of node, add the origin data to show in map
    func getCellRectAtNodeIndexPath(_ indexPath: NodeIndexPath) -> CGRect {
        if indexPath.row >= rows.count || indexPath.column >= rowAtIndex(indexPath.row)!.numberOfNodes() {
            return CGRect.zero
        }
        
        let row = rowAtIndex(indexPath.row)
        if row == nil {
            return CGRect.zero
        }
        
        let node = row!.nodeAtIndex(indexPath.column)
        if node == nil {
            return CGRect.zero
        }
        
        return CGRect(x: origin.x + node!.position - node!.size * 0.5, y: origin.y + row!.position - row!.size * 0.5, width: node!.size, height: row!.size)
    }
    
    fileprivate func resizeWithCGSize(_ size: CGSize) {
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
        for (i, row) in rows.enumerated() {
            let anchorNode = row.anchorNode
  
            if anchorNode != nil {
                switch row.alignment {
                case .anchorNode:
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
                case .center:
                    anchorNode!.position = width * 0.5
                case .left:
                    anchorNode!.position = 0
                case .right:
                    anchorNode!.position = width
                }
            }
            row.width = width
            row.resize()
        }
    }
    
    func setFrame(_ rect: CGRect)  {
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
            case .fixed:
                row.size = min(max(row.size, row.minSize), row.maxSize)
                hTotal -= rowGap + row.size
            case .ratio:
                row.size = min(max(row.ratio * height, row.minSize), row.maxSize)
                hTotal -= rowGap + row.size
            case .evenDistributed:
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
            if row.sizeType == .evenDistributed {
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
    
    func getNodeFrame(_ row: Int, column: Int) -> CGRect
    func getNodeView(_ row: Int, column: Int) -> AnyObject?

    // tree map structure
    /** return number of rows */
    func numberOfRows() -> Int
    /** return gap among rows */
    func getRowGap() -> CGFloat
    // return margins at top and bottom
    func getTopMargin() -> CGFloat
    func getBottomMargin() -> CGFloat
    
    // information for each row
    func numberOfColumns(_ row: Int) -> Int
    // return layout information for given row
    func getRowSizeType(_ row: Int) -> SizeType
    func getRowMaxSize(_ row: Int) -> CGFloat
    func getRowMinSize(_ row: Int) -> CGFloat
    func getSize(_ row: Int) -> CGFloat
    func getRatio(_ row: Int) -> CGFloat
    func getWeight(_ row: Int) -> CGFloat
    func getNodeGap(_ row: Int) -> CGFloat
    func getLeftEdgeMargin(_ row: Int) -> CGFloat
    func getRightEdgeMargin(_ row: Int) -> CGFloat
    
    // archor node in current row
    func getAnchorNodeIndex(_ row: Int) -> Int
    // parent node (from row above) of archor node for getting anchor node position.
    func getAnchorNodeParentIndexPath(_ row: Int) -> NodeIndexPath
    // type of anchor
    func getAlignment(_ row: Int) -> Alignment
  
    // information for each node
    // return layout information for given node at (row, column)
    func getNodeSizeType(_ row: Int, column: Int) -> SizeType
    func getNodeMaxSize(_ row: Int, column: Int) -> CGFloat
    func getNodeMinSize(_ row: Int, column: Int) -> CGFloat
    func getNodeSize(_ row: Int, column: Int) -> CGFloat
    func getNodeRatio(_ row: Int, column: Int) -> CGFloat
    func getNodeWeight(_ row: Int, column: Int) -> CGFloat
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
                oneNode.nodeFrame = dataSoure.getNodeFrame(i, column: j)
                oneNode.obj = dataSoure.getNodeView(i, column: j)
                oneNode.sizeType = dataSoure.getNodeSizeType(i, column: j)
                oneNode.size = dataSoure.getNodeSize(i, column: j)
                oneNode.ratio = dataSoure.getNodeRatio(i, column: j)
                oneNode.weight = dataSoure.getNodeWeight( i, column: j)
                oneNode.maxSize = dataSoure.getNodeMaxSize(i, column: j)
                oneNode.minSize = dataSoure.getNodeMinSize(i, column: j)
                
                let _ = oneRow.addNode(oneNode)
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

            let _ = addRow(oneRow)
        }
        
        resizeWithCGSize(CGSize(width: width, height: height))
    }
}

