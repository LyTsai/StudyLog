//
//  RandomCirclesLayout.swift
//  Demo_testUI
//
//  Created by iMac on 2018/1/10.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation

class RandomCirclesLayout: NSObject {
    // properties
    var minRadius: CGFloat = 20
    var radiusRange: UInt32 = 5
    var mapCenter = CGPoint.zero
    
    // private
    fileprivate var randomCircleInfos = [(center: CGPoint, radius: CGFloat)]()
    
    func layoutCirclesOnMap(_ mapFrame: CGRect, mapCenter: CGPoint, centerRadius: CGFloat, number: Int) {
        // prepare
        self.mapCenter = mapCenter
        let mapSize = mapFrame.size
        randomCircleInfos.removeAll()
        
        var oneTryCount = 0
        var totalTryCount = 0
        var overlap = 0
        while randomCircleInfos.count < number {
            oneTryCount += 1
            let randomRadius = minRadius + CGFloat(arc4random() % radiusRange)
            let randomX = CGFloat(arc4random() % UInt32(mapSize.width - 2 * randomRadius)) + randomRadius + mapFrame.minX // randomRadius ~ width - randomRadius
            let randomY = CGFloat(arc4random() % UInt32(mapSize.height - 2 * randomRadius)) + randomRadius + mapFrame.minY // randomRadius ~ height - randomRadius
            let randomCenter = CGPoint(x: randomX, y: randomY)
            
            // filter
            if distanceOfPoints(randomCenter, b: mapCenter) > centerRadius + randomRadius {
                // 1. not overlap with center
                var success = true
                for circleInfo in randomCircleInfos {
                    // 2. not overlap with others
                    if distanceOfPoints(circleInfo.center, b: randomCenter) < centerRadius + circleInfo.radius {
                        success = false
                        break
                    }
                }
                
                if success {
                    randomCircleInfos.append((center: randomCenter, radius: randomRadius))
                    oneTryCount = 0
                }else {
                    // failed 
                    if oneTryCount > 6000 {
                        // dead loop
                        oneTryCount = 0
                        overlap += 1
                        randomCircleInfos.append((center: randomCenter, radius: randomRadius))
                        //  recursion?
                    }
                }
            }
            
            if overlap >= max(Int(Float(number) * 0.2), 2) && totalTryCount < 15 {
                // retry
                randomCircleInfos.removeAll()
                totalTryCount += 1
            }
        }
    }
    
    fileprivate func distanceOfPoints(_ a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }
    
    // methods
    func numberOfNodes() -> Int {
        return randomCircleInfos.count
    }
    
    func getInfoAtIndex(_ index: Int) -> (center: CGPoint, radius: CGFloat) {
        if index < 0 || index >= randomCircleInfos.count {
            return (CGPoint.zero, 0)
        }
        return randomCircleInfos[index]
    }
    
    func getFrameAtIndex(_ index: Int) -> CGRect {
        let info = getInfoAtIndex(index)
        return CGRect(x: info.center.x - info.radius, y: info.center.y - info.radius, width: info.radius * 2, height: info.radius * 2)
    }
    
    func indexOfCircleTouched(_ point: CGPoint) -> Int! {
        for (i, info) in randomCircleInfos.enumerated() {
            if distanceOfPoints(info.center, b: point) < info.radius {
                return i
            }
        }
        
        return nil
    }
    
    func changeCenterAtIndex(_ index: Int, to center: CGPoint) {
        if index >= 0 && index < randomCircleInfos.count {
            randomCircleInfos[index].center = center
        }
    }
}
