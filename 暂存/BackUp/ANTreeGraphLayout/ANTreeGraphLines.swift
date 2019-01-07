//
//  ANTreeGraphLines.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: - definition of enums for types
// the type of line(s) for one node
enum LineConnectionType {
    case None               // no lines

    case TwoPoints          // connect between tow points, use
    case BreakHanged
    case TurnedHanged
}


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
    var lineDrawStyle = ANLineDrawStyle(lineWidth: 0.5, lineColor: UIColor.cyanColor(), lineCap: .Butt, lineJoin: .Bevel)
    
    var lineConnectionType: LineConnectionType = .TwoPoints
    var linePathType: LinePathType = .Straight

    var lineEndType: LineEndType = .Normal
    var endInfo:(includedAngle: CGFloat, edgeLength: CGFloat) = (CGFloat(M_PI / 3), 40)
    
    var colorType: LineColorType = .Single
    var colors = [CGColor]()
    
    var beginPoint = CGPointZero

    // for LineConnectionType.TwoPoints
    var endPoint = CGPointZero
    var breakPoints = [CGPoint]()           // if the type is segment
    var controlPoints = [CGPoint]()         // if the type is curve, use bezier curve

    // for LineConnectionType.BreakHanged
    var hangingPoint = CGPointZero
    var connectionPoints = [CGPoint]()
    
    /** the path of the line */
    var linePath: UIBezierPath {
        get {
            let path = UIBezierPath()
            
            // basic properties
            path.lineWidth = lineDrawStyle.lineWidth
            path.lineCapStyle = lineDrawStyle.lineCap
            path.lineJoinStyle = lineDrawStyle.lineJoin
            
            // draw path
            path.moveToPoint(beginPoint)
            switch lineConnectionType {
            case .TwoPoints:
                drawBetweenTwoPoints(path)
            case .BreakHanged:
                drawBreakHanged(path)
            default:
                break
            }
            
            return path
        }
    }
    
    func drawBetweenTwoPoints(path: UIBezierPath) {
        switch linePathType {
        case .Straight:
            path.addLineToPoint(endPoint)
        case .Segment:
            if breakPoints.count > 0 {
                for point in breakPoints {
                    path.addLineToPoint(point)
                }
            }
            path.addLineToPoint(endPoint)
        case .Curve:
            if controlPoints.count < 2 {
                path.addLineToPoint(endPoint)
            }else {
                path.addCurveToPoint(endPoint, controlPoint1: controlPoints.first!, controlPoint2: controlPoints.last!)
            }
        }
    }
    
    func drawBreakHanged(path: UIBezierPath) {
        if connectionPoints.count == 0 {
            path.addLineToPoint(endPoint)
        } else if connectionPoints.count == 1 {
            path.addLineToPoint(connectionPoints.first!)
        }else {
            path.addLineToPoint(hangingPoint)
            
            let firstPosition = connectionPoints.first!.x
            let lastPosition = connectionPoints.last!.x
            
            // line and Connection
            path.moveToPoint(connectionPoints.first!)
            path.addLineToPoint(CGPoint(x: firstPosition, y: hangingPoint.y))
            path.addLineToPoint(CGPoint(x: lastPosition, y: hangingPoint.y))
            path.addLineToPoint(connectionPoints.last!)
            
            for point in connectionPoints {
                path.moveToPoint(CGPoint(x: point.x, y: hangingPoint.y))
                path.addLineToPoint(point)
            }
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
                arrowPath.closePath()
            default:
                break
            }
            
            return arrowPath
        }
    }
    
    // calculate points for move along line
    func formEndPath(arrowPath: UIBezierPath, pathEndPoint: CGPoint, edgeLength: CGFloat, edgeAngle1: CGFloat, edgeAngle2: CGFloat) {
        let arrowEnd1 = movePointBack(pathEndPoint, edge: edgeLength, angle: edgeAngle1)
        let arrowEnd2 = movePointBack(pathEndPoint, edge: edgeLength, angle: edgeAngle2)
        
        arrowPath.moveToPoint(arrowEnd1)
        arrowPath.addLineToPoint(pathEndPoint)
        arrowPath.addLineToPoint(arrowEnd2)
    }
    
    func movePointBack(point: CGPoint, edge: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: point.x + cos(angle) * edge, y: point.y + sin(angle) * edge)
    }
    
    // MARK: gradientColor
    var gradientLayer: CAGradientLayer {
        get {
            let allPath = linePath
            allPath.appendPath(endPath)
            
            var pathFrame = allPath.bounds
            let lineWidth = lineDrawStyle.lineWidth
            pathFrame = CGRect(x: pathFrame.origin.x - lineWidth * 0.5, y: pathFrame.origin.y - lineWidth * 0.5 , width: pathFrame.width + lineWidth, height: pathFrame.height + lineWidth)
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = pathFrame
            
            maskLayer.lineWidth = lineWidth
            maskLayer.lineCap = kCALineCapButt
            maskLayer.path = allPath.CGPath
            
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = pathFrame
            gradientLayer.colors = colors
            gradientLayer.locations = [0.5, 0.8, 1]
            
            gradientLayer.mask = maskLayer
            
            return gradientLayer
        }
    }
}

protocol ANTreeMapLineDataProtocal {
    func getLineOverallInformation(row row: Int, column: Int) -> [(beginPoint: CGPoint, connectionType: LineConnectionType)]
  
    // About the lines
    func getLineDrawStyle(row row: Int, column: Int, lineIndex: Int) -> ANLineDrawStyle
    
    func getLinePathType(row row: Int, column: Int, lineIndex: Int) -> LinePathType
    
    func getLineEndPoint(row row: Int, column: Int, lineIndex: Int) -> CGPoint
    func getLineBreakPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]
    func getLineControlPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]
    
    func getLineHangingPoint(row row: Int, column: Int, lineIndex: Int) -> CGPoint
    func getLineConnectionPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]
}

// drawlines and connect lines with nodes
class ANLinesView: UIView {
    
    var nodeData: ANTreeMapDataSourceProtocal!
    var lineData: ANTreeMapLineDataProtocal!
    
    func linePathsForNode(row i: Int, column j: Int) -> [ANLine] {
        let overAll = lineData.getLineOverallInformation(row: i, column: j)
        var lines = [ANLine]()
        
        for index in 0..<overAll.count {
            let oneLine = ANLine()
            
            oneLine.lineDrawStyle = lineData.getLineDrawStyle(row: i, column: j, lineIndex: index)
            oneLine.linePathType = lineData.getLinePathType(row: i, column: j, lineIndex: index)
            oneLine.lineConnectionType = overAll[index].connectionType
            
            oneLine.beginPoint = overAll[index].beginPoint
            
            oneLine.endPoint = lineData.getLineEndPoint(row: i, column: j, lineIndex: index)
            oneLine.breakPoints = lineData.getLineBreakPoints(row: i, column: j, lineIndex: index)
            oneLine.controlPoints = lineData.getLineControlPoints(row: i, column: j, lineIndex: index)
            oneLine.hangingPoint = lineData.getLineHangingPoint(row: i, column: j, lineIndex: index)
            oneLine.connectionPoints = lineData.getLineConnectionPoints(row: i, column: j, lineIndex: index)
            
            lines.append(oneLine)
        }
        
        return lines
    }

    override func drawRect(rect: CGRect) {
        for i in 0..<nodeData.numberOfRows() {
            for j in 0..<nodeData.numberOfColumns(i) {
               let lines = linePathsForNode(row: i, column: j)
                for line in lines{
                    line.lineDrawStyle.lineColor.setStroke()
                    line.linePath.stroke()
                }
            }
        }
    }
 }
