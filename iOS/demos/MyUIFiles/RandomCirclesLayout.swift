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
    
    // private
    fileprivate var randomCircleInfos = [(center: CGPoint, radius: CGFloat)]()

    func layoutCirclesOnMap(_ mapFrame: CGRect, centerRadius: CGFloat, number: Int) {
        // prepare
        let mapCenter = CGPoint(x: mapFrame.midX, y: mapFrame.midY)
        let mapSize = mapFrame.size
        randomCircleInfos.removeAll()
        
        var oneTryCount = 0
        var goBackTryCount = 0
        while randomCircleInfos.count < number {
            oneTryCount += 1
            let randomRadius = minRadius + CGFloat(arc4random() % radiusRange)
            let randomX = CGFloat(arc4random() % UInt32(mapSize.width - 2 * randomRadius)) + randomRadius // randomRadius ~ width - randomRadius
            let randomY = CGFloat(arc4random() % UInt32(mapSize.height - 2 * randomRadius)) + randomRadius // randomRadius ~ height - randomRadius
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
                }
                
                if oneTryCount > 2000 {
                    // dead loop
                    oneTryCount = 0

                    if goBackTryCount < number * 10  {
                        // go back, remove some nodes and retry
                        randomCircleInfos.removeLast()
                        goBackTryCount += 1
                    }else {
                        // add anyway
                        print("add any way")
                        randomCircleInfos.append((center: randomCenter, radius: randomRadius))
                    }
                }
            }
        }
    }
    
    fileprivate func distanceOfPoints(_ a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }
    
    func getFrameAtIndex(_ index: Int) -> CGRect {
        if index < 0 || index > randomCircleInfos.count {
            return CGRect.zero
        }
        let info = randomCircleInfos[index]
        return CGRect(x: info.center.x - info.radius, y: info.center.y - info.radius, width: info.radius * 2, height: info.radius * 2)
    }
}
