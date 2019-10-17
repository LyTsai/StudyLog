//
//  MathTool.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let CGFloatPi = CGFloat(Double.pi)

// ------------- calculation of angles, postions -----------
// all angle is radian
struct Calculation {
    // clockwise
    static func getPositionByAngle(_ radian: CGFloat, radius: CGFloat, origin: CGPoint) -> CGPoint {
        return CGPoint(x: origin.x + radius * cos(radian), y: origin.y + radius * sin(radian))
    }
    
    static func angleGap(_ totalNumber: Int, totalAngle: CGFloat) -> CGFloat {
        if totalNumber <= 0  {
       
            return 0
        }
        return totalAngle / CGFloat(totalNumber)
    }
    
    static func getAngle(_ index: Int, totalNumber: Int, startAngle: CGFloat, endAngle: CGFloat) -> CGFloat {
        if totalNumber == 0 || index >= totalNumber || index < 0 {

            return 0
        }
        
        return startAngle + CGFloat(index) * angleGap(totalNumber, totalAngle: endAngle - startAngle)
    }
    
    // squre in a sector
    static func inscribeSqureRect(_ angleGap: CGFloat, startAngle: CGFloat, radius: CGFloat, vertex: CGPoint) -> CGRect {
        let halfGap = angleGap / 2
        let length = radius / sqrt(1 + 1 / (4 * sin(halfGap) * sin(halfGap)) + 1 / tan(halfGap))
        let position = getPositionByAngle(startAngle + halfGap, radius: (1 + 1 / tan(halfGap)) * length / 2 , origin: vertex)
        
        return CGRect(center: position, length: length)
    }
    
    static func inscribeSqureLength(_ angleGap: CGFloat, radius: CGFloat) -> CGFloat {
        let halfGap = angleGap / 2
        let length = radius / sqrt(1 + 1 / (4 * sin(halfGap) * sin(halfGap)) + 1 / tan(halfGap))
        return length
    }
    
    static func distanceOfPointA(_ a: CGPoint, pointB b: CGPoint) -> CGFloat {
        let dx = b.x - a.x
        let dy = b.y - a.y
        
        return sqrt(dx * dx + dy * dy)
    }
    
    static func angleOfPoint(_ a: CGPoint, center c: CGPoint) -> CGFloat {
        let angle = atan2(c.y - a.y, c.x - a.x)
        return angle + CGFloat(Double.pi) // 0 - pi
    }
    
    // layout
    static func layoutEvenCircleWithCenter(_ center: CGPoint, nodes: [UIView], radius: CGFloat, startAngle: CGFloat, expectedLength: CGFloat) {
        if nodes.isEmpty {
            return
        }
        
        if nodes.count == 1 {
            nodes.first!.frame = CGRect(center: getPositionByAngle(startAngle, radius: radius, origin: center), length: expectedLength)
            return
        }
        
        let angleGap = 2 * CGFloatPi / CGFloat(nodes.count)
        let inscribeLength = radius * sin(angleGap * 0.5) * 2
        let nodeLength = min(inscribeLength, expectedLength)
        for (i, node) in nodes.enumerated() {
            let angle = startAngle + CGFloat(i) * angleGap
            node.frame = CGRect(center: Calculation.getPositionByAngle(angle, radius: radius, origin: center), length: nodeLength)
        }
    }
    
    static func placeNodes(_ nodes: [UIView], center: CGPoint, radius: CGFloat, startAngle: CGFloat) {
        if nodes.isEmpty {
            return
        }
        
        let angleGap = 2 * CGFloatPi / CGFloat(nodes.count)
        for (i, node) in nodes.enumerated() {
            let angle = startAngle + CGFloat(i) * angleGap
            node.center = Calculation.getPositionByAngle(angle, radius: radius, origin: center)
        }
    }
}
