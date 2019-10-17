//
//  RoadDrawModel.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/25.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
enum RoadDirection {
    case fromLeft, fromRight, fromTop
}

class RoadDrawModel {
    var branchPoint = CGPoint.zero
    var turningRadius: CGFloat = 40
    var startPoint = CGPoint.zero
    var roadWidth: CGFloat = 31.0
    
    // for draw
    var anchorInfo = [(anchor: CGPoint, played: Bool)]()
    
    var roadLineColor = UIColorFromRGB(253, green: 255, blue: 251).withAlphaComponent(0.5)
    // green sets
    var roadMainColor = UIColorFromRGB(185, green: 183, blue: 169).withAlphaComponent(0.5)
    var roadPlayedColor = UIColorFromRGB(56, green: 129, blue: 18).withAlphaComponent(0.5)
    
    // take as overlapped
    fileprivate var minGap : CGFloat {
        return roadWidth * 1.15
    }
    
    // take as one line
    fileprivate var ultraGap: CGFloat {
        return roadWidth * 0.3
    }
    
    var firstDirection = RoadDirection.fromTop
    fileprivate var maxX: CGFloat = 0
    func drawRoadWithMaxX(_ maxX: CGFloat) {
        // no point
        if anchorInfo.isEmpty  {
            return
        }
        
        self.maxX = maxX

        // line of road
        var direction: RoadDirection = firstDirection
        
        // with first
        if branchPoint != CGPoint.zero {
            let branchPath = UIBezierPath()
            branchPath.move(to: branchPoint)
            branchPath.addLine(to: CGPoint(x: branchPoint.x, y: anchorInfo.first!.anchor.y))
            strokePath(branchPath, played: false)
        }
        
        var mainPath = UIBezierPath()
        mainPath.move(to: startPoint)
        
        // connect to the first point
        direction = connectPoint(startPoint, and: anchorInfo.first!.anchor, last: direction, forPath: mainPath)
        strokePath(mainPath, played: anchorInfo.first!.played)
        mainPath = UIBezierPath()
        mainPath.move(to: anchorInfo.first!.anchor)
        
        let coPath = UIBezierPath() // just to avoid the error of "no current point" when judging the direction
        coPath.move(to: startPoint)
        // others
        for i in 0..<anchorInfo.count {
            let point = anchorInfo[i].anchor
            
            // new road part
            if i >= anchorInfo.count - 2 {
                // only last point is left
                direction = connectPoint(point, and: anchorInfo.last!.anchor, last: direction, forPath: mainPath)
                strokePath(mainPath, played: anchorInfo.last!.played)
                break
            }
            
            // connecting
            let point2 = anchorInfo[i + 1].anchor
            let point3 = anchorInfo[i + 2].anchor
            
            var needChange = false
            var middlePoint = CGPoint.zero
            if abs(point2.y - point3.y) < minGap {
                // judge
                let supposed = connectPoint(point, and: point2, last: direction, forPath: coPath)
                switch supposed {
                case .fromLeft:
                    if point3.x < point2.x {
                        middlePoint = CGPoint(x: point2.x - minGap * 0.9 , y: point2.y - minGap * 0.9)
                        needChange = true
                    }
                case .fromRight:
                    if point3.x > point2.x {
                        middlePoint = CGPoint(x: point2.x + minGap * 0.9 , y: point2.y - minGap * 0.9)
                        needChange = true
                    }
                case .fromTop:
                    middlePoint = CGPoint(x: point2.x , y: point2.y - minGap * 0.9)
                    needChange = true
                }
            }
            
            // adjust for overlap
            if needChange {
                direction = connectPoint(point, and: middlePoint, last: direction, forPath: mainPath)
                direction = connectPoint(middlePoint, and: point2, last: direction, forPath: mainPath)
                mainPath.addLine(to: point2)
                direction = .fromTop
            }else {
                direction = connectPoint(point, and: point2, last: direction, forPath: mainPath)
            }
            
            // next path, maybe stroke color is changed...
            let playState = anchorInfo[i + 1].played
            let nextState = anchorInfo[i + 2].played
            if playState != nextState {
                strokePath(mainPath, played: anchorInfo[i + 1].played)
                
                mainPath = UIBezierPath()
                mainPath.move(to: point2)
            }
        }
    }
    // draw one part of road
    fileprivate func strokePath(_ path: UIBezierPath, played: Bool) {
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        
        
        // draw main road
        path.lineWidth = roadWidth
        roadMainColor.setStroke()
        path.stroke()
        
        // coverPath
        let coverPath = path
        roadLineColor.setStroke()
        coverPath.lineWidth = roadWidth * 0.8
        coverPath.stroke()
        
        // middle path
        let roadColor = played ? roadPlayedColor : roadMainColor
        let middlePath = path
        roadColor.setStroke()
        middlePath.lineWidth = roadWidth * 0.6
        middlePath.stroke()
        
        // middle
        let roadLinePath = path
        roadLineColor.setStroke()
        roadLinePath.setLineDash([9 * fontFactor, 6 * fontFactor], count: 1, phase: 1)
        roadLinePath.lineWidth = 2 * fontFactor
        roadLinePath.stroke()
    }
    
    
    // two points
    func connectPoint(_ point1: CGPoint, and point2: CGPoint, last roadDirection: RoadDirection, forPath path: UIBezierPath) -> RoadDirection {
        var radius = (point2.y - point1.y) * 0.5
        
        var direction = roadDirection
        switch roadDirection {
        case .fromTop:
            if abs(point1.x - point2.x) < ultraGap {
                // take as close to each other, direction stays as .fromTop
                path.addLine(to: point2)
            }else {
                let control = CGPoint(x: point1.x, y: point2.y)
                path.addCurve(to: point2, controlPoint1: control, controlPoint2: control)
                direction = point1.x < point2.x ? .fromLeft : .fromRight
            }
        case .fromRight:
            if point1.x >= point2.x {
                //         point1------
                //  point2
                if radius < minGap * 0.5 {
                    if radius < ultraGap {
                        // very close
                        path.addLine(to: point2)
                        direction = .fromRight
                    }else {
                        let control = CGPoint(x: point2.x, y: point1.y)
                        path.addCurve(to: point2, controlPoint1: control, controlPoint2: control)
                        direction = .fromTop
                    }
                }else {
                    if (point2.x - radius) < roadWidth * 0.5 {
                        radius = (point2.x - roadWidth * 0.5) * 0.5
                    }
                    var startP = CGPoint(x: point2.x, y: point1.y)
                    
                    if radius > turningRadius && abs(point1.x - point2.x) > turningRadius {
                        let offsetX = point1.x - point2.x
                        let breakY = point2.y - 2 * turningRadius
                        path.addLine(to: CGPoint(x: point2.x + offsetX * 0.8, y: point1.y))
                        path.addLine(to: CGPoint(x: point2.x + offsetX * 0.6, y: breakY))
                        startP = CGPoint(x: point2.x, y: breakY)
                    }
                    
                    radius = min(radius, turningRadius)
                    path.addLine(to: startP)
                    addLeftRoundedRect(startP, bottom: point2, radius: radius, forPath: path)
                    direction = .fromLeft
                }
            }else {
                // point1------
                //        point2
                if radius < minGap * 0.5  {
                    //                    print("error for from right")
                }else {
                    if (point1.x - radius) < roadWidth * 0.5 {
                        // topLeftCorner, down
                        radius = (point1.x - roadWidth * 0.5) * 0.6
                    }
                    
                    radius = min(radius, turningRadius)
                    addLeftRoundedRect(point1, bottom: CGPoint(x: point1.x, y: point2.y), radius: radius, forPath: path)
                    path.addLine(to: point2)
                    direction = .fromLeft
                }
            }
            
        case .fromLeft:
            if point2.x >= point1.x {
                // ------ point1
                //              point2
                if radius < minGap * 0.5 {
                    if radius < ultraGap {
                        // very close
                        path.addLine(to: point2)
                        direction = .fromLeft
                    }else {
                        let control = CGPoint(x: point2.x, y: point1.y)
                        path.addCurve(to: point2, controlPoint1: control, controlPoint2: control)
                        direction = .fromTop
                    }
                }else {
                    if (point2.x + radius) >= maxX - roadWidth * 0.5 {
                        radius = (maxX - point2.x - roadWidth * 0.5) * 0.6
                    }
                    
                    var startP = CGPoint(x: point2.x, y: point1.y)
                    
                    if radius > turningRadius && abs(point1.x - point2.x) > turningRadius {
                        let offsetX = point2.x - point1.x
                        let breakY = point2.y - 2 * turningRadius
                        path.addLine(to: CGPoint(x: point1.x + offsetX * 0.4, y: point1.y))
                        path.addLine(to: CGPoint(x: point1.x + offsetX * 0.6, y: breakY))
                        startP = CGPoint(x: point2.x, y: breakY)
                    }
                    
                    radius = min(radius, turningRadius)
                    path.addLine(to: startP)
                    addRightRoundedRect(startP, bottom: point2, radius: radius, forPath: path)
                    
                    direction = .fromRight
                }
            }else {
                //  ------  point1
                // point2
                if radius < minGap * 0.5 {
                    //                    print("error for from left")
                }else {
                    if (point1.x + radius + roadWidth * 0.5) >= maxX {
                        // topLeftCorner, down
                        radius = (maxX - point1.x - roadWidth * 0.5) * 0.6
                    }
                    
                    radius = min(radius, turningRadius)
                    addRightRoundedRect(point1, bottom: CGPoint(x: point1.x, y: point2.y), radius: radius, forPath: path)
                    path.addLine(to: point2)
                    direction = .fromRight
                }
            }
        }
        
        return direction
    }
    
    // if radius is half gapY, is a half-circle then
    func addRightRoundedRect(_ top: CGPoint, bottom: CGPoint, radius: CGFloat, forPath path: UIBezierPath) {
        if radius * 2 > (bottom.y - top.y) + 1 || abs(top.x - bottom.x) > 1 {
            print("radius is too large or not aligned")
            path.addLine(to: bottom)
            return
        }
        
        // arc-line-arc
        path.addArc(withCenter: CGPoint(x: top.x, y: top.y + radius), radius: radius, startAngle: -CGFloat(Double.pi) / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: top.x + radius, y: bottom.y - radius))
        path.addArc(withCenter: CGPoint(x: top.x, y: bottom.y - radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi) / 2, clockwise: true)
    }
    
    func addLeftRoundedRect(_ top: CGPoint, bottom: CGPoint, radius: CGFloat, forPath path: UIBezierPath) {
        if radius * 2 > (bottom.y - top.y) + 1 || abs(top.x - bottom.x) > 1 {
            print("radius is too large or not aligned")
            path.addLine(to: bottom)
            
            return
        }
        
        path.addArc(withCenter: CGPoint(x: top.x, y: top.y + radius), radius: radius, startAngle: -CGFloat(Double.pi) / 2, endAngle: -CGFloat(Double.pi), clockwise: false)
        path.addLine(to: CGPoint(x: top.x - radius, y: bottom.y - radius))
        path.addArc(withCenter: CGPoint(x: top.x, y: bottom.y - radius), radius: radius,  startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi) / 2, clockwise: false)
    }
}
