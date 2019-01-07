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

// TODO: maybe some more else, like dash lines && straight, maybe another enum is needed
enum LineType {
    case Straight
    case Segment
    case Curve
}

// MARK: - the properties for ONE line
struct LineDrawStyle {
    var lineWidth: CGFloat
    /** use UIColor directly, as not take this as "Model" */
    var lineColor: UIColor
    var lineCap : CGLineCap
    var lineJoin: CGLineJoin
}

class ANLine {
    var lineDrawStyle = LineDrawStyle(lineWidth: 0.5, lineColor: UIColor.cyanColor(), lineCap: .Butt, lineJoin: .Bevel)
    
    var lineConnectionType: LineConnectionType = .TwoPoints
    var lineType: LineType = .Straight
    
    var startNode = ANTreeNode()
    var endNode = ANTreeNode()
    
    var startPoint = CGPointZero

    // for LineConnectionType.TwoPoints
    var endPoint = CGPointZero
    var breakPoints = [CGPoint]()           // if the type is segment
    var controlPoints = [CGPoint]()         // if the type is curve, use bezier curve

    // for LineConnectionType.BreakHanged
    var hangingPoint = CGPointZero
    var connectionPoints = [CGPoint]()
    
    /** the path of the line */
    var path: UIBezierPath {
        get {
            let path = UIBezierPath()
            
            // basic properties
            path.lineWidth = lineDrawStyle.lineWidth
            path.lineCapStyle = lineDrawStyle.lineCap
            path.lineJoinStyle = lineDrawStyle.lineJoin
            
            // draw path
            path.moveToPoint(startPoint)
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
    
    // MARK: draw methods
    func drawBetweenTwoPoints(path: UIBezierPath) {
        switch lineType {
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
    
}

protocol ANTreeMapLineDataProtocal {
    func getLineOverallInformation(row row: Int, column: Int) -> [(startPoint: CGPoint, connectionType: LineConnectionType)]
  
    // About the lines
    func getLineDrawStyle(row row: Int, column: Int, lineIndex: Int) -> LineDrawStyle
    
    func getLineType(row row: Int, column: Int, lineIndex: Int) -> LineType
    
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

    override func drawRect(rect: CGRect) {
        print("This is a test code")
        
        for i in 0..<nodeData.numberOfRows() {
            for j in 0..<nodeData.numberOfColumns(i) {
                let lines = linePathsForNode(row: i, column: j)
                for line in lines{
                    line.lineDrawStyle.lineColor.setStroke()
                    line.path.stroke()
                }
            }
        }
    }

    private func linePathsForNode(row i: Int, column j: Int) -> [ANLine] {
        let overAll = lineData.getLineOverallInformation(row: i, column: j)
        var lines = [ANLine]()

        for index in 0..<overAll.count {
            let oneLine = ANLine()
            
            oneLine.lineDrawStyle = lineData.getLineDrawStyle(row: i, column: j, lineIndex: index)
            oneLine.lineType = lineData.getLineType(row: i, column: j, lineIndex: index)
            oneLine.lineConnectionType = overAll[index].connectionType
            
            oneLine.startPoint = overAll[index].startPoint
            
            oneLine.endPoint = lineData.getLineEndPoint(row: i, column: j, lineIndex: index)
            oneLine.breakPoints = lineData.getLineBreakPoints(row: i, column: j, lineIndex: index)
            oneLine.controlPoints = lineData.getLineControlPoints(row: i, column: j, lineIndex: index)
            oneLine.hangingPoint = lineData.getLineHangingPoint(row: i, column: j, lineIndex: index)
            oneLine.connectionPoints = lineData.getLineConnectionPoints(row: i, column: j, lineIndex: index)
            
            lines.append(oneLine)
        }
        
        return lines
    }

 }
