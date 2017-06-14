//
//  ANTreeGraphNodeLines.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/9/1.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: - definition of enums for types
enum LinePathType {
    case Straight
    case Segment
    case Curve
}

enum LineEndType {
    case Normal
    case LinesArrow
    case Triangle
}

enum LineColorType {
    case Single
    case Gradient
    
}

enum LineWidthType {
    case Single
    case EaseIn
    case EaseOut
}

struct ANLineDrawStyle {
    var lineWidth: CGFloat
    /** use UIColor directly, as not take this as "Model" */
    var lineColor: UIColor
    var lineCap : CGLineCap
    var lineJoin: CGLineJoin
}

// MARK: - the properties for ONE line
class ANLine {
    var lineDrawStyle = ANLineDrawStyle(lineWidth: 0.5, lineColor: UIColor.cyan, lineCap: .butt, lineJoin: .bevel)

    var linePathType: LinePathType = .Straight
    
    var lineEndType: LineEndType = .Normal
    var endInfo:(includedAngle: CGFloat, edgeLength: CGFloat) = (CGFloat(M_PI / 3), 40)
    
    var colorType: LineColorType = .Single
    var colors = [CGColor]()
    
    var beginPoint = CGPoint.zero
    
    // for LineConnectionType.TwoPoints
    var endPoint = CGPoint.zero
    var breakPoints = [CGPoint]()           // if the type is segment
    var controlPoints = [CGPoint]()         // if the type is curve, use bezier curve
    
    /** the path of the line */
    var linePath: UIBezierPath {
        get {
            let path = UIBezierPath()
            
            // basic properties
            path.lineWidth = lineDrawStyle.lineWidth
            path.lineCapStyle = lineDrawStyle.lineCap
            path.lineJoinStyle = lineDrawStyle.lineJoin
            
            // draw path
            path.move(to: beginPoint)
            switch linePathType {
            case .Straight:
                path.addLine(to: endPoint)
            case .Segment:
                if breakPoints.count > 0 {
                    for point in breakPoints {
                        path.addLine(to: point)
                    }
                }
                path.addLine(to: endPoint)
            case .Curve:
                if controlPoints.count < 2 {
                    path.addLine(to: endPoint)
                }else {
                    path.addCurve(to: endPoint, controlPoint1: controlPoints.first!, controlPoint2: controlPoints.last!)
                }
            }
    
            return path
        }
    }
    
    // in case the DrawStyle for arrow is different from the line
    /** the path of the line's end, if necessary */
    var endPath: UIBezierPath {
        get {
            let arrowPath = UIBezierPath()
            
            arrowPath.lineWidth = lineDrawStyle.lineWidth
            arrowPath.lineCapStyle = lineDrawStyle.lineCap
            arrowPath.lineJoinStyle = lineDrawStyle.lineJoin
            
            let includedAngle = endInfo.includedAngle
            let edgeLength = endInfo.edgeLength
            var pathEndPoint = linePath.currentPoint
            
            // [0, M_PI], [M_PI, 2 * M_PI]
            var lineAngle : CGFloat
            let deltaX = pathEndPoint.x - beginPoint.x
            let deltaY = pathEndPoint.y - beginPoint.y
            
            lineAngle = atan(deltaY / deltaX)
            if deltaX >= 0 {
                lineAngle += CGFloat(M_PI)
            }
            
            let edgeAngle1 = lineAngle - includedAngle * 0.5
            let edgeAngle2 = lineAngle + includedAngle * 0.5
            
            switch lineEndType {
            case .LinesArrow:
                formEndPath(arrowPath, pathEndPoint: pathEndPoint, edgeLength: edgeLength, edgeAngle1: edgeAngle1, edgeAngle2: edgeAngle2)
            case .Triangle:
                // move more points
                pathEndPoint = movePointBack(pathEndPoint, edge: -edgeLength * cos(includedAngle * 0.5), angle: lineAngle)
                formEndPath(arrowPath, pathEndPoint: pathEndPoint, edgeLength: edgeLength, edgeAngle1: edgeAngle1, edgeAngle2: edgeAngle2)
                arrowPath.close()
            default:
                break
            }
            
            return arrowPath
        }
    }
    
    // calculate points for move along line
    func formEndPath(_ arrowPath: UIBezierPath, pathEndPoint: CGPoint, edgeLength: CGFloat, edgeAngle1: CGFloat, edgeAngle2: CGFloat) {
        let arrowEnd1 = movePointBack(pathEndPoint, edge: edgeLength, angle: edgeAngle1)
        let arrowEnd2 = movePointBack(pathEndPoint, edge: edgeLength, angle: edgeAngle2)
        
        arrowPath.move(to: arrowEnd1)
        arrowPath.addLine(to: pathEndPoint)
        arrowPath.addLine(to: arrowEnd2)
    }
    
    func movePointBack(_ point: CGPoint, edge: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: point.x + cos(angle) * edge, y: point.y + sin(angle) * edge)
    }
}

// ABSPoint is defined using objects such as node on the node graph
// reference type
enum AnchorPosition {
    case Left_Top, Left_Bottom, Left_Center,
    Right_Top, Right_Bottom, Right_Center,
    Top_Center,Bottom_Center, Center
}

// class for ABSPoint
class ABSPoint {
    var relatedNodeIndexPath: NodeIndexPath = NodeIndexPath(row: 0, column: 0)
    var anchorRef : AnchorPosition = .Top_Center
    var anchorOffset: UIOffset = UIOffset(horizontal: 0, vertical: 0)
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
    class func createABSLineWithBeginRow(_ beginRow: Int, beginColumn: Int, beginAnchorRef: AnchorPosition, endRow: Int, endColumn: Int, endAnchorRef: AnchorPosition, type: LinePathType) -> ABSLine {
        let oneLine = ABSLine()

        oneLine.begin.relatedNodeIndexPath = NodeIndexPath(row: beginRow, column: beginColumn)
        oneLine.begin.anchorRef = beginAnchorRef
        oneLine.end.relatedNodeIndexPath = NodeIndexPath(row: endRow, column: endColumn)
        oneLine.end.anchorRef = endAnchorRef
        oneLine.linePathType = type
        
        return oneLine
    }
    
    class func createOffsetABSLineWithBeginRow(_ beginRow: Int, beginColumn: Int, beginAnchorRef: AnchorPosition, beginOffset: UIOffset, endRow: Int, endColumn: Int, endAnchorRef: AnchorPosition, endOffset : UIOffset,  type : LinePathType) -> ABSLine {
        let oneLine = createABSLineWithBeginRow(beginRow, beginColumn: beginColumn, beginAnchorRef: beginAnchorRef, endRow: endRow, endColumn: endColumn, endAnchorRef: endAnchorRef, type: type)
        
        oneLine.begin.anchorOffset = beginOffset
        oneLine.end.anchorOffset = endOffset
        
        return oneLine
    }
}

protocol ANTreeMapNodeLineDataProtocal{
    // attached node graph map
    func attachedNodeLayout() -> ANTreeGraphLayout
    func updateLineCollection()-> [ABSLine]
    func getLineDrawingStyle(_ index : Int) -> ANLineDrawStyle
    func getLineEndType(_ index: Int) -> LineEndType
    func getEndInfo(_ index: Int) -> (includedAngle: CGFloat, edgeLength: CGFloat)
    func getLineColorType(_ index: Int) -> LineColorType
    func getGradientColors(_ index: Int) -> [CGColor]
}

// "projector" that projects collection of ABSLines onto attached node graph
class ANTreeGraphLineProjector {
    var dataSoure: ANTreeMapNodeLineDataProtocal!
    var graphLines = [ANLine]()
    
    func reloadData() {
        graphLines.removeAll()
        let nodeLayout = dataSoure.attachedNodeLayout()
        let absLineArray = dataSoure.updateLineCollection()
        
        for (index, oneABSLine) in absLineArray.enumerated() {
            // line drawing style information
            // map it to physical line on node graph
            let onePhysicalLine = ANLine()
            
            // map line points
            onePhysicalLine.beginPoint = mapABSPoint(oneABSLine.begin, nodeLayout: nodeLayout)
            onePhysicalLine.endPoint = mapABSPoint(oneABSLine.end, nodeLayout: nodeLayout)
            
            // absPoints
            for absPoint in oneABSLine.breakPoints {
                onePhysicalLine.breakPoints.append(mapABSPoint(absPoint, nodeLayout: nodeLayout))
            }

            for absPoint in oneABSLine.controlPoints {
                onePhysicalLine.controlPoints.append(mapABSPoint(absPoint, nodeLayout: nodeLayout))
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
    
    private func mapABSPoint(_ absPoint: ABSPoint, nodeLayout: ANTreeGraphLayout) -> CGPoint {
        let nodeRect = nodeLayout.dataSoure.getNodeFrame(absPoint.relatedNodeIndexPath.row, column: absPoint.relatedNodeIndexPath.column)
        var mappedPosition = CGPoint.zero
        
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
    func linesHangFromNode(_ nodeIndexPath: NodeIndexPath, toRow: Int, toColumns: [Int], proportionOfFrom: CGFloat) -> [ABSLine]{
         // the situation of wrong indexPath or row , some judges.
        let nodeLayout = dataSoure.attachedNodeLayout()
        var hangLines = [ABSLine]()
        var columnIndexes = toColumns.sorted()
        
        let realProportion = max(0.1, min(proportionOfFrom, 0.9)) // from 0.1 to 0.9
        let fromRect = nodeLayout.dataSoure.getNodeFrame(nodeIndexPath.row, column: nodeIndexPath.column)
        let toRect = nodeLayout.dataSoure.getNodeFrame(toRow, column: 0)
        
        let shift = toRect.minY - fromRect.maxY
        let fromOffset = UIOffset(horizontal: 0, vertical: shift * realProportion + fromRect.height * 0.5)
        let toOffset = UIOffset(horizontal: 0, vertical: -shift * (1 - realProportion) - toRect.height * 0.5)
        
        if toColumns.count == 0 {
            for c in 0..<nodeLayout.rowAtIndex(toRow)!.numberOfNodes() {
                columnIndexes.append(c)
            }
        }
        
        hangLines.append(ABSLine.createOffsetABSLineWithBeginRow(nodeIndexPath.row, beginColumn: nodeIndexPath.column, beginAnchorRef: .Center, beginOffset: UIOffset(horizontal: 0, vertical: 0), endRow: nodeIndexPath.row, endColumn: nodeIndexPath.column, endAnchorRef: .Center, endOffset: fromOffset, type: .Straight))
        // add the horizontal line
        hangLines.append(ABSLine.createOffsetABSLineWithBeginRow(toRow, beginColumn: columnIndexes.first!, beginAnchorRef: .Center, beginOffset: toOffset, endRow: toRow, endColumn: columnIndexes.last!, endAnchorRef: .Center, endOffset: toOffset, type: .Straight))
    
        
        for i in 0..<columnIndexes.count {
            let toRect = nodeLayout.dataSoure.getNodeFrame(toRow, column: i)
            
            if fromRect == CGRect.zero || toRect == CGRect.zero{
                continue
            }
            
            hangLines.append(ABSLine.createOffsetABSLineWithBeginRow(toRow, beginColumn: columnIndexes[i], beginAnchorRef: .Center, beginOffset: UIOffset.zero, endRow: toRow, endColumn: columnIndexes[i], endAnchorRef: .Center, endOffset: toOffset, type: .Straight))
        }
        
        return hangLines
    }
}

// will draw projected lines from attached projector
class ANLineCollectionView: UIView {
    var lines : ANTreeGraphLineProjector!
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers = nil
        for line in lines.graphLines{
            // color first
            if line.colorType == LineColorType.Gradient {
                layer.addSublayer(gradientLayerForLine(line))
                // all drawn now
                continue
            }

            // one color
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
        }
    }
    
    // gradientLayer
    func gradientLayerForLine(_ line: ANLine) -> CALayer {
        let linePath = line.linePath
        let endPath = line.endPath
        let lineWidth = line.lineDrawStyle.lineWidth
        
        // the line for mask, stroke
        let lineMaskLayer = CAShapeLayer()
        lineMaskLayer.lineWidth = lineWidth
        lineMaskLayer.frame = bounds
        lineMaskLayer.lineCap = kCALineCapButt
        lineMaskLayer.fillColor = UIColor.clear.cgColor
        lineMaskLayer.strokeColor = UIColor.yellow.cgColor
        lineMaskLayer.path = linePath.cgPath
        
        // the end for mask
        let endMaskLayer = CAShapeLayer()
        endMaskLayer.lineWidth = lineWidth
        endMaskLayer.frame = bounds
        endMaskLayer.lineCap = kCALineCapButt
        if line.lineEndType == .Triangle {
            // triangle end, fill
            endMaskLayer.fillColor = UIColor.blue.cgColor
            endMaskLayer.strokeColor = UIColor.clear.cgColor
        } else {
            // linesArrow, stroke
            lineMaskLayer.fillColor = UIColor.blue.cgColor
            lineMaskLayer.strokeColor = UIColor.clear.cgColor
        }
        endMaskLayer.path = endPath.cgPath
        
        let maskLayer = CAShapeLayer()
        maskLayer.addSublayer(lineMaskLayer)
        maskLayer.addSublayer(endMaskLayer)
        
        // info of path
        let allPath = linePath.copy() as! UIBezierPath
        allPath.append(endPath)
        
        let pathFrame = allPath.bounds
        let roughFrame = CGRect(x: max(pathFrame.origin.x - lineWidth * 0.5 * sqrt(2), 0), y: max(pathFrame.origin.y - lineWidth * 0.5 * sqrt(2), 0), width: pathFrame.width + lineWidth * sqrt(2), height: pathFrame.height + lineWidth * sqrt(2)) // in consideration of the curve line
        
        var gradientStartPoint = CGPoint.zero
        var gradientEndPoint = CGPoint(x: 1, y: 0)
        
        var deltaX = linePath.currentPoint.x - line.beginPoint.x
        var deltaY = linePath.currentPoint.y - line.beginPoint.y
        let a = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        deltaX /= a
        deltaY /= a
        
        if abs(deltaX) > abs(deltaY) {
            deltaX = deltaX / abs(deltaX)
            deltaY = deltaY / abs(deltaX)
        } else {
            deltaX = deltaX / abs(deltaY)
            deltaY = deltaY / abs(deltaY)
        }
        
        // use pathFrame, not roughFrame —— considering the triangle
        switch (deltaX, deltaY) {
        case (0, 0...1):                            // + y-axis
            gradientEndPoint = CGPoint(x: 0, y: 1)
        case (0...1, 0...1):                        // first quadrant(including + x-axis)
            gradientEndPoint = CGPoint(x: deltaX, y: deltaY)
        case (-1...0, 0...1):                       // second quadrant(including - x-axis)
            gradientStartPoint = CGPoint(x: -deltaX, y: 0)
            gradientEndPoint = CGPoint(x: 0, y: deltaY)
        case (-1...0, -1...0):                      // third quadrant (including - y-axis)
            gradientStartPoint = CGPoint(x: -deltaX, y: -deltaY)
            gradientEndPoint = CGPoint.zero
        case (0...1, -1...0):                       // forth quadrant
            gradientStartPoint = CGPoint(x: 0, y: -deltaY)
            gradientEndPoint = CGPoint(x: deltaX, y: 0)
        default:
            break
        }
        
        // gradient
        let gradientLayer = CAGradientLayer()
    
        // set as the rough frame of the path (arrow + line)
        gradientLayer.frame = roughFrame
        gradientLayer.colors = line.colors
        gradientLayer.locations = [0.1,0.9,1]
        gradientLayer.startPoint = gradientStartPoint
        gradientLayer.endPoint = gradientEndPoint
        
        let midLayer = CALayer()
        midLayer.addSublayer(gradientLayer) //  so, the position of path is correct
        midLayer.mask = maskLayer
        
        return midLayer
    }
    
}
