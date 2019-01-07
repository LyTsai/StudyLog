//
//  WindingRoadCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class WindingRoadCollectionView: UICollectionView, UIScrollViewDelegate {
    var turningRadius: CGFloat = 50
    var startFlagFrame = CGRect.zero
    var endPoint = CGPoint.zero
    var roadWidth: CGFloat = 20.0
    
    var anchorInfo = [CGPoint]()
    
    var roadLineColor = UIColorFromRGB(252, green: 255, blue: 250)
    var roadMainColor = UIColorFromRGB(203, green: 205, blue: 190)
    
    // update
    func setAnchorInfoWithItems(_ items: [RoadItemDisplayModel]) {
        let layout = collectionViewLayout as! BlockFlowLayout
        let attriArray = layout.attriArray
        anchorInfo.removeAll()
        
        for (i, attri) in attriArray.enumerated() {
            let item = items[i]
            anchorInfo.append(CGPoint(x: attri.frame.origin.x + item.anchorPoint.x, y: attri.frame.origin.y + item.anchorPoint.y))
        }

        anchorInfo.append(endPoint)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNeedsDisplay()
    }
    
    // draw roads
    enum RoadDirection {
        case fromLeft, fromRight, fromTop
    }
    
    
    // take as overlapped
    fileprivate var minGap : CGFloat {
        return roadWidth * 1.15
    }
    
    // take as one line
    fileprivate var ultraGap: CGFloat {
        return roadWidth * 0.3
    }
    
    override func draw(_ rect: CGRect) {
        anchorInfo.sort { (point1, point2) -> Bool in
            return point1.y <= point2.y
        }
        
        // line of road
        let mainPath = UIBezierPath()
        mainPath.lineJoinStyle = .round
        mainPath.lineCapStyle = .round
        
        var direction: RoadDirection = .fromTop
        
        // lines
        let startPoint = CGPoint(x: startFlagFrame.midX, y: startFlagFrame.midY)
        mainPath.move(to: startPoint)
        
        // connect to the first point
        direction = connectPoint(startPoint, and: anchorInfo.first!, last: direction, forPath: mainPath)
        
        let coPath = UIBezierPath() // just to avoid the error of "no current point" when judging the direction
        coPath.move(to: startPoint)
        // others
        for (i, point) in anchorInfo.enumerated() {
            if i >= anchorInfo.count - 2 {
                // only last point is left
                direction = connectPoint(point, and: anchorInfo.last!, last: direction, forPath: mainPath)
                break
            }
            
            // connecting
            let point2 = anchorInfo[i + 1]
            let point3 = anchorInfo[i + 2]
            
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
        }
        
        // draw main road
        mainPath.lineWidth = roadWidth
        roadMainColor.setStroke()
        mainPath.stroke()
        
        // coverPath
        let coverPath = mainPath
        roadLineColor.setStroke()
        coverPath.lineWidth = roadWidth * 0.8
        coverPath.stroke()
        
        // middle path
        let middlePath = mainPath
        roadMainColor.setStroke()
        middlePath.lineWidth = roadWidth * 0.65
        middlePath.stroke()
        
        // middle
        let roadLinePath = mainPath
        roadLineColor.setStroke()
        roadLinePath.setLineDash([9, 6], count: 1, phase: 1)
        roadLinePath.lineWidth = 2
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
                        radius = (point2.x - roadWidth * 0.5) * 0.6
                    }
                    
                    radius = min(radius, turningRadius)
                    path.addLine(to: CGPoint(x: point2.x, y: point1.y))
                    addLeftRoundedRect(CGPoint(x: point2.x, y: point1.y), bottom: point2, radius: radius, forPath: path)
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
                    if (point2.x + radius) >= bounds.width - roadWidth * 0.5 {
                        radius = (bounds.width - point2.x - roadWidth * 0.5) * 0.6
                    }
                    
                    radius = min(radius, turningRadius)
                    path.addLine(to: CGPoint(x: point2.x, y: point1.y))
                    addRightRoundedRect(CGPoint(x: point2.x, y: point1.y), bottom: point2, radius: radius, forPath: path)
                    direction = .fromRight
                }
            }else {
                //  ------  point1
                // point2
                if radius < minGap * 0.5 {
                    //                    print("error for from left")
                }else {
                    if (point1.x + radius + roadWidth * 0.5) >= bounds.width {
                        // topLeftCorner, down
                        radius = (bounds.width - point1.x - roadWidth * 0.5) * 0.6
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
        if radius * 2 > (bottom.y - top.y) || top.x != bottom.x {
            print("radius is too large or not algned")
            return
        }
        
        // arc-line-arc
        path.addArc(withCenter: CGPoint(x: top.x, y: top.y + radius), radius: radius, startAngle: -CGFloat(Double.pi) / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: top.x + radius, y: bottom.y - radius))
        path.addArc(withCenter: CGPoint(x: top.x, y: bottom.y - radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi) / 2, clockwise: true)
    }
    
    func addLeftRoundedRect(_ top: CGPoint, bottom: CGPoint, radius: CGFloat, forPath path: UIBezierPath) {
        if radius * 2 > (bottom.y - top.y) || top.x != bottom.x {
            print("radius is too large or not algned")
            return
        }
        
        path.addArc(withCenter: CGPoint(x: top.x, y: top.y + radius), radius: radius, startAngle: -CGFloat(Double.pi) / 2, endAngle: -CGFloat(Double.pi), clockwise: false)
        path.addLine(to: CGPoint(x: top.x - radius, y: bottom.y - radius))
        path.addArc(withCenter: CGPoint(x: top.x, y: bottom.y - radius), radius: radius,  startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi) / 2, clockwise: false)
    }
}
