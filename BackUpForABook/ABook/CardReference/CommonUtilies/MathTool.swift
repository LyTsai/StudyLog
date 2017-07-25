//
//  MathTool.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// ------------- calcultion of angles, postions -----------
struct Calculation {
    // clockwise
    func getPositionByAngle(_ radian: CGFloat, radius: CGFloat, origin: CGPoint) -> CGPoint {
        return CGPoint(x: origin.x + radius * cos(radian), y: origin.y + radius * sin(radian))
    }
    
    func angleGap(_ totalNumber: Int, totalAngle: CGFloat) -> CGFloat {
        if totalNumber <= 0  {
       
            return 0
        }
        return totalAngle / CGFloat(totalNumber)
    }
    
    func getAngle(_ index: Int, totalNumber: Int, startAngle: CGFloat, endAngle: CGFloat) -> CGFloat {
        if totalNumber == 0 || index >= totalNumber || index < 0 {

            return 0
        }
        
        return startAngle + CGFloat(index) * angleGap(totalNumber, totalAngle: endAngle - startAngle)
    }
    
    // squre in a sector
    func inscribeSqureRect(_ angleGap: CGFloat, startAngle: CGFloat, radius: CGFloat, vertex: CGPoint) -> CGRect {
        let halfGap = angleGap / 2
        let length = radius / sqrt(1 + 1 / (4 * sin(halfGap) * sin(halfGap)) + 1 / tan(halfGap))
        let position = getPositionByAngle(startAngle + halfGap, radius:  (1 + 1 / tan(halfGap)) * length / 2 , origin: vertex)
        
        return CGRect(center: position, length: length)
    }
    
    func distanceOfPointA(_ a: CGPoint, pointB b: CGPoint) -> CGFloat {
        let dx = b.x - a.x
        let dy = b.y - a.y
        
        return sqrt(dx * dx + dy * dy)
    }
    
    func angleOfPoint(_ a: CGPoint, center c: CGPoint) -> CGFloat {
        return atan2(c.y - a.y, c.x - a.x)
    }
    

}
