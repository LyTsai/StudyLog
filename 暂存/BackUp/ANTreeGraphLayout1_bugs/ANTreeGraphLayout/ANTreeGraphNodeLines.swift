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


class ANNodeLine {
    var start: ABSPoint!
    var end: ABSPoint!
    var lineType: LineType = LineType.Straight
    var absPoints = [ABSPoint]()                 // control or break points
    
    var lineDrawStyle = LineDrawStyle(lineWidth: 0.5, lineColor: UIColor.cyanColor(), lineCap: .Butt, lineJoin: .Bevel)
    
    var lineConnectionType: LineConnectionType = .TwoPoints
    
    private func mapABSPoint(absPoint: ABSPoint, nodeMap: ANTreeMap) -> CGPoint {
        let nodeRect = nodeMap.getCellRectAtIndexPath(absPoint.relatedNodeIndexPath)
        var mappedPosition = CGPointZero
        
        switch absPoint.anchorRef {
        case .Left_Top: mappedPosition = CGPoint(x: nodeRect.minX, y: nodeRect.minY)
        case .Left_Bottom: mappedPosition = CGPoint(x: nodeRect.minX, y: nodeRect.maxY)
        case .Left_Center: mappedPosition = CGPoint(x: nodeRect.midX, y: nodeRect.midY)
        
        case .Right_Top: mappedPosition = CGPoint(x: nodeRect.maxX, y: nodeRect.minY)
        case .Right_Bottom: mappedPosition = CGPoint(x: nodeRect.maxX, y: nodeRect.maxY)
        case .Right_Center: mappedPosition = CGPoint(x: nodeRect.maxX, y: nodeRect.midY)
            
        case .Top_Center: mappedPosition = CGPoint(x: nodeRect.minX, y: nodeRect.midY)
        case .Bottom_Center: mappedPosition = CGPoint(x: nodeRect.midX, y: nodeRect.maxY)
        case .Center: mappedPosition = CGPoint(x: nodeRect.midX, y: nodeRect.midY)
        }
        
        // add Offset
        mappedPosition = CGPoint(x: mappedPosition.x + absPoint.anchorOffset.horizontal, y: mappedPosition.y + absPoint.anchorOffset.vertical)
        
        return mappedPosition
    }

    let nodeMap = ANTreeMap()
    
    /** the path of the line */
    var path: UIBezierPath {
        get {
            let path = UIBezierPath()
            let startPoint = mapABSPoint(start, nodeMap: nodeMap)

            
            // basic properties
            path.lineWidth = lineDrawStyle.lineWidth
            path.lineCapStyle = lineDrawStyle.lineCap
            path.lineJoinStyle = lineDrawStyle.lineJoin
            
            // draw path
            path.moveToPoint(startPoint)
            switch lineConnectionType {
            case .TwoPoints:
                drawBetweenTwoPoints(path)
//            case .BreakHanged:
//                drawBreakHanged(path)
                
            default:
                break
            }
            return path
        }
    }
    
    // MARK: draw methods
    func drawBetweenTwoPoints(path: UIBezierPath) {
        let endPoint = mapABSPoint(end, nodeMap: nodeMap)
        var points = [CGPoint]()
        
        for absPoint in absPoints {
            points.append(mapABSPoint(absPoint, nodeMap: nodeMap))
        }
        
        switch lineType {
        case .Straight:
            path.addLineToPoint(endPoint)
        case .Segment:
            if points.count > 0 {
                for point in points {
                    path.addLineToPoint(point)
                }
            }
            path.addLineToPoint(endPoint)
        case .Curve:
            if points.count < 2 {
                path.addLineToPoint(endPoint)
            }else {
                path.addCurveToPoint(endPoint, controlPoint1: points.first!, controlPoint2: points.last!)
            }
        }
    }
    
//    func drawBreakHanged(path: UIBezierPath) {
//        if connectionPoints.count == 0 {
//            path.addLineToPoint(endPoint)
//        } else if connectionPoints.count == 1 {
//            path.addLineToPoint(connectionPoints.first!)
//        }else {
//            path.addLineToPoint(hangingPoint)
//            
//            let firstPosition = connectionPoints.first!.x
//            let lastPosition = connectionPoints.last!.x
//            
//            // line and Connection
//            path.moveToPoint(connectionPoints.first!)
//            path.addLineToPoint(CGPoint(x: firstPosition, y: hangingPoint.y))
//            path.addLineToPoint(CGPoint(x: lastPosition, y: hangingPoint.y))
//            path.addLineToPoint(connectionPoints.last!)
//            
//            for point in connectionPoints {
//                path.moveToPoint(CGPoint(x: point.x, y: hangingPoint.y))
//                path.addLineToPoint(point)
//            }
//        }
//    }
    
}
//
protocol ANTreeMapNodeLineDataProtocal{
    func getLineConnectionTypes(row row: Int, column: Int) -> [LineConnectionType]  // About the lines
    func getLineNode(row row: Int, column: Int, lineIndex: Int) -> ANNodeLine

    
    func getLineHangingPoint(row row: Int, column: Int, lineIndex: Int) -> CGPoint
    func getLineConnectionPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]
}
//
//// drawlines and connect lines with nodes
//class ANNodeLinesView: UIView {
//    
//    var nodeData: ANTreeMapDataSourceProtocal!
//    var lineData: ANTreeMapLineDataProtocal!
//    
//    func linePathsForNode(row i: Int, column j: Int) -> [ANLine] {
//        let overAll = lineData.getLineOverallInformation(row: i, column: j)
//        var lines = [ANLine]()
//        
//        for index in 0..<overAll.count {
//            let oneLine = ANLine()
//            
//            oneLine.lineDrawStyle = lineData.getLineDrawStyle(row: i, column: j, lineIndex: index)
//            oneLine.lineType = lineData.getLineType(row: i, column: j, lineIndex: index)
//            oneLine.lineConnectionType = overAll[index].connectionType
//            
//            oneLine.startPoint = overAll[index].startPoint
//            
//            oneLine.endPoint = lineData.getLineEndPoint(row: i, column: j, lineIndex: index)
//            oneLine.breakPoints = lineData.getLineBreakPoints(row: i, column: j, lineIndex: index)
//            oneLine.controlPoints = lineData.getLineControlPoints(row: i, column: j, lineIndex: index)
//            oneLine.hangingPoint = lineData.getLineHangingPoint(row: i, column: j, lineIndex: index)
//            oneLine.connectionPoints = lineData.getLineConnectionPoints(row: i, column: j, lineIndex: index)
//            
//            lines.append(oneLine)
//        }
//        
//        return lines
//    }
//    
//    override func drawRect(rect: CGRect) {
//        for i in 0..<nodeData.numberOfRows() {
//            for j in 0..<nodeData.numberOfColumns(i) {
//                let lines = linePathsForNode(row: i, column: j)
//                for line in lines{
//                    line.lineDrawStyle.lineColor.setStroke()
//                    line.path.stroke()
//                }
//            }
//        }
//    }
//}

