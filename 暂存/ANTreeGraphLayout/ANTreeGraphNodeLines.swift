//
//  ANTreeGraphNodeLines.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/9/1.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// ABSPoint is defined using objects such as node on the node graph
// reference type
enum AnchorPosition {
    case Left_Top, Left_Bottom, Left_Center,
    Right_Top, Right_Bottom, Right_Center,
    Top_Center,Bottom_Center, Center
}

// offset type
enum AnchorOffset {
    case Zero, Fixed, Ratio_NodeWidth, Ratio_NodeHeight, Ratio_RowSize, Ratio_ColumnSize
}

// class for ABSPoint
class ABSPoint {
    var relatedNodeIndexPath: IndexPath = IndexPath(row: 0, column: 0)

    // reference point of anchor node
    var anchorRef : AnchorPosition = .Top_Center
    
    // offset from anchor point
    var offsetType : AnchorOffset = .Zero
    var anchorOffset: UIOffset = UIOffsetZero
}

// location info of lines, not including colors and so on
class ABSLine {
    var begin = ABSPoint()
    var end =  ABSPoint()
    var linePathType: LinePathType = LinePathType.Straight
    var lineEndType: LineEndType = LineEndType.Normal
    
    var breakPoints = [ABSPoint]()
    var controlPoints = [ABSPoint]()
    
    // create a line from some data.
    // class func
    class func createABSLineWithBeginRow(beginRow: Int, beginColumn: Int, beginAnchorRef: AnchorPosition, endRow: Int, endColumn: Int, endAnchorRef: AnchorPosition, type: LinePathType) -> ABSLine {
        let oneLine = ABSLine()

        oneLine.begin.relatedNodeIndexPath = IndexPath(row: beginRow, column: beginColumn)
        oneLine.begin.anchorRef = beginAnchorRef
        oneLine.end.relatedNodeIndexPath = IndexPath(row: endRow, column: endColumn)
        oneLine.end.anchorRef = endAnchorRef
        oneLine.linePathType = type
        
        return oneLine
    }
    
    class func createOffsetABSLineWithBeginRow(beginRow: Int, beginColumn: Int, beginAnchorRef: AnchorPosition, beginOffset: UIOffset, endRow: Int, endColumn: Int, endAnchorRef: AnchorPosition, endOffset : UIOffset,  type : LinePathType) -> ABSLine {
        let oneLine = createABSLineWithBeginRow(beginRow, beginColumn: beginColumn, beginAnchorRef: beginAnchorRef, endRow: endRow, endColumn: endColumn, endAnchorRef: endAnchorRef, type: type)
        
        oneLine.begin.anchorOffset = beginOffset
        oneLine.end.anchorOffset = endOffset
        
        return oneLine
    }
}

protocol ANTreeMapNodeLineDataProtocal{
    // attached node graph map
    func attachedNodeMap() -> ANTreeMap
    func updateLineCollection()-> [ABSLine]
    func getLineDrawingStyle(index : Int) -> ANLineDrawStyle
    func getLineEndType(index: Int) -> LineEndType
    func getEndInfo(index: Int) -> (includedAngle: CGFloat, edgeLength: CGFloat)
    func getLineColorType(index: Int) -> LineColorType
    func getGradientColors(index: Int) -> [CGColor]
}

// "projector" that projects collection of ABSLines onto attached node graph
class ANTreeGraphLineProjector {
    var dataSoure: ANTreeMapNodeLineDataProtocal!
    var graphLines = [ANLine]()
    
    func reloadData() {
        graphLines.removeAll()
        let nodeMap = dataSoure.attachedNodeMap()
        let absLineArray = dataSoure.updateLineCollection()
        
        for (index, oneABSLine) in absLineArray.enumerate() {
            // line drawing style information
            // map it to physical line on node graph
            let onePhysicalLine = ANLine()
            
            // map line points
            onePhysicalLine.beginPoint = mapABSPoint(oneABSLine.begin, nodeMap: nodeMap)
            onePhysicalLine.endPoint = mapABSPoint(oneABSLine.end, nodeMap: nodeMap)
            
            // absPoints
            for absPoint in oneABSLine.breakPoints {
                onePhysicalLine.breakPoints.append(mapABSPoint(absPoint, nodeMap: nodeMap))
            }

            for absPoint in oneABSLine.controlPoints {
                onePhysicalLine.controlPoints.append(mapABSPoint(absPoint, nodeMap: nodeMap))
            }
            
            // line drawing information
            onePhysicalLine.lineDrawStyle = dataSoure.getLineDrawingStyle(index)
            onePhysicalLine.lineEndType = dataSoure.getLineEndType(index)
            onePhysicalLine.endInfo = dataSoure.getEndInfo(index)
            onePhysicalLine.colorType = dataSoure.getLineColorType(index)
            onePhysicalLine.colors = dataSoure.getGradientColors(index)
            
            // add this line into collection
            graphLines.append(onePhysicalLine)
        }
    }
    
    private func mapABSPoint(absPoint: ABSPoint, nodeMap: ANTreeMap) -> CGPoint {
        let nodeRect = nodeMap.getCellRectAtIndexPath(absPoint.relatedNodeIndexPath)
        var mappedPosition = CGPointZero
        
        switch absPoint.anchorRef {
        case .Left_Top: mappedPosition = CGPoint(x: nodeRect.minX, y: nodeRect.minY)
        case .Left_Bottom: mappedPosition = CGPoint(x: nodeRect.minX, y: nodeRect.maxY)
        case .Left_Center: mappedPosition = CGPoint(x: nodeRect.minX, y: nodeRect.midY)
            
        case .Right_Top: mappedPosition = CGPoint(x: nodeRect.maxX, y: nodeRect.minY)
        case .Right_Bottom: mappedPosition = CGPoint(x: nodeRect.maxX, y: nodeRect.maxY)
        case .Right_Center: mappedPosition = CGPoint(x: nodeRect.maxX, y: nodeRect.midY)
            
        case .Top_Center: mappedPosition = CGPoint(x: nodeRect.midX, y: nodeRect.minY)
        case .Bottom_Center: mappedPosition = CGPoint(x: nodeRect.midX, y: nodeRect.maxY)
        case .Center: mappedPosition = CGPoint(x: nodeRect.midX, y: nodeRect.midY)
        }
        
        // add Offset
        mappedPosition = CGPoint(x: mappedPosition.x + absPoint.anchorOffset.horizontal, y: mappedPosition.y + absPoint.anchorOffset.vertical)
        
        return mappedPosition
    }


    // MARK: several regular situations
    /*
     to      to       to       to     to
     
                    from
     
     to      to       to       to     to
     */
    // assume the node is connected to all the nodes in one row
    // if toColumns is void, means all
    func linesHangFromNode(nodeIndexPath: IndexPath, toRow: Int, toColumns: [Int], proportionOfFrom: CGFloat) -> [ABSLine]{
    
         // the situation of wrong indexPath or row , some judges.
        
        let nodeMap = dataSoure.attachedNodeMap()
        var hangLines = [ABSLine]()
        var columnIndexes = toColumns.sort()
        
        let realProportion = max(0.1, min(proportionOfFrom, 0.9)) // from 0.1 to 0.9
        let fromRect = nodeMap.getCellRectAtIndexPath(nodeIndexPath)
        let toRect = nodeMap.getCellRectAtIndexPath(IndexPath(row: toRow, column: 0))
        
        let shift = toRect.minY - fromRect.maxY
        let fromOffset = UIOffset(horizontal: 0, vertical: shift * realProportion + fromRect.height * 0.5)
        let toOffset = UIOffset(horizontal: 0, vertical: -shift * (1 - realProportion) - toRect.height * 0.5)
        
        if toColumns.count == 0 {
            for c in 0..<nodeMap.rowAtIndex(toRow)!.numberOfNodes() {
                columnIndexes.append(c)
            }
        }
        
        
        hangLines.append(ABSLine.createOffsetABSLineWithBeginRow(nodeIndexPath.row, beginColumn: nodeIndexPath.column, beginAnchorRef: .Center, beginOffset: UIOffsetZero, endRow: nodeIndexPath.row, endColumn: nodeIndexPath.column, endAnchorRef: .Center, endOffset: fromOffset, type: .Straight))
        // add the horizontal line
        hangLines.append(ABSLine.createOffsetABSLineWithBeginRow(toRow, beginColumn: columnIndexes.first!, beginAnchorRef: .Center, beginOffset: toOffset, endRow: toRow, endColumn: columnIndexes.last!, endAnchorRef: .Center, endOffset: toOffset, type: .Straight))
    
        
        for i in 0..<columnIndexes.count {
            let toRect = nodeMap.getCellRectAtIndexPath(IndexPath(row: toRow, column: i))
            
            if fromRect == CGRectZero || toRect == CGRectZero{
                continue
            }
            
            hangLines.append(ABSLine.createOffsetABSLineWithBeginRow(toRow, beginColumn: columnIndexes[i], beginAnchorRef: .Center, beginOffset: UIOffsetZero, endRow: toRow, endColumn: columnIndexes[i], endAnchorRef: .Center, endOffset: toOffset, type: .Straight))
        }
        
        return hangLines
    }
}

// will draw projected lines from attached projector
class ANLineCollectionView: UIView {
    var lines : ANTreeGraphLineProjector!
    
    var layers = [CAGradientLayer]()
    
    override func drawRect(rect: CGRect) {
        for line in lines.graphLines{
            line.lineDrawStyle.lineColor.setStroke()
            line.linePath.stroke()
            
            // end
            switch line.lineEndType {
            case .LinesArrow:
                line.lineDrawStyle.lineColor.setStroke()
                line.endPath.stroke()
            case .Triangle:
                line.lineDrawStyle.lineColor.setFill()
                line.endPath.fill()
            default:
                break
            }
            
            // color
            // endless loop for addSub
            if line.colorType == LineColorType.Gradient {
                layers.append(line.gradientLayer)
            }
        }
        
    }
    
    
}