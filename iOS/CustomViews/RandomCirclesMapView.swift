//
//  RandomCirclesMapView.swift
//  Demo_testUI
//
//  Created by iMac on 2018/1/10.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RandomCirclesDelegate {
    @objc optional func circlesLayout(_ layout: RandomCirclesLayout, isSelectedAtIndex: Int)
}


//protocol RandomCirclesDataDource {
//    func numberOfCircles(_ inView: RandomCirclesMapView) -> Int
//    func circleInView(_ view: RandomCirclesMapView, atIndex: Int) -> UIView
//}



class RandomCirclesLayout: NSObject {
    // protocol
    var randomDelegate: RandomCirclesDelegate!
//    var randomDataSource: RandomCirclesDataDource!
    
    // properties

    var middleScale: CGFloat = 0.6
    var minRadius: CGFloat = 30
    var radiusRange: UInt32 = 40
    
    // private
    fileprivate var randomCircleInfos = [(center: CGPoint, radius: CGFloat)]()

    
    func layoutCirclesOnMap(_ mapFrame: CGRect, centerRadius: CGFloat, number: Int) {
        // prepare
        let mapCenter = CGPoint(x: mapFrame.midX, y: mapFrame.midY)
        let mapSize = mapFrame.size
        randomCircleInfos.removeAll()
        
        var tried = 0
        while randomCircleInfos.count < number {
            tried += 1
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
                    tried = 0
                }
                
                if tried > 1000 {
                    // dead loop, add anyway ......
                    randomCircleInfos.append((center: randomCenter, radius: randomRadius))
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
        return CGRect(x: info.center.x - info.radius, y: info.center.y - info.radius, width: info.radius * 2, height: info.radius * 0.5)
    }
}
