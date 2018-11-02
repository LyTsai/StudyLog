//
//  RandomBallsLayout.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/9.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

//func layoutInContainer(_ center: CGPoint, minRadius: CGFloat, maxRadius: CGFloat, radii: [CGFloat]) -> [CGRect] {
//    var frames = [CGRect]()
//    var sortedRadii = radii.sorted(by: {$0 > $1})
//
//    let centerFrame = CGRect(center: center, length: 2 * maxRadius)
//    for radius in sortedRadii {
//
//    }
//
//    return frames
//}
//
//func getCenterOf(_ radius: CGFloat, centerOne: CGPoint, radiusOne: CGFloat, centerTwo: CGPoint, radiusTwo: CGFloat) {
//    let edgeOne = radius + radiusOne
//    let edgeTwo = radiusTwo + radius
//    let edgeThree = radiusOne + radiusTwo
//
//
//}

func layoutPans(_ pans: [CGFloat], inContainer roundel: CGRect, centerRadius: CGFloat) -> [CGRect] {
    if pans.count == 0 {
        return []
    }
    
    let radius = min(roundel.width, roundel.height) * 0.5
    let center = CGPoint(x: roundel.midX, y: roundel.midY)
    
    // ranking from high to low
    var ranking = [(index: Int, radius: CGFloat, center: CGPoint)]()
    for (i, pan) in pans.enumerated() {
        ranking.append((i, pan, CGPoint.zero))
    }
    ranking = ranking.sorted(by: {$0.1 >= $1.1})
    
    // placing
    let random = randomPointInRoundel(center, radius: radius, centerRadius: centerRadius)
    var placed = [ranking.first!]
    placed[0].center = random
    
    while placed.count != ranking.count {
        placed.append(ranking[placed.count])
        placed[placed.count - 1].center = randomPointInRoundel(center, radius: radius, centerRadius: centerRadius)
        // elastic potential energy
//        placed[placed.count - 1].center = random
//        var step: CGFloat = 1
        var oldU = totalU(placed)
//        while totalU(placed) > 1e-6 {
//            // get_gardU
//
//            // move
//            if totalU(placed) < oldU {
//                oldU = totalU(placed)
//                for i in 0..<placed.count {
//                    let oldC = placed[i].center
//                    placed[placed.count - 1].center = CGPoint(x: oldC.x + step, y: oldC.y + step)
//                }
//            }else {
//                oldU = totalU(placed)
//                for i in 0..<placed.count {
//                    let oldC = placed[i].center
//                    step *= 0.8
//                    placed[placed.count - 1].center = CGPoint(x: oldC.x - step, y: oldC.y - step)
//                }
//            }
//
//
////            step *= step
//        }
//
        
    }
    
    // rank back
    placed = placed.sorted(by: {$0.0 < $1.0})
    var panFrames = [CGRect]()
    for pan in placed {
        panFrames.append(CGRect(center: pan.center, length: pan.radius * 2))
    }
    
    return panFrames
}


func randomPointInRoundel(_ center: CGPoint, radius: CGFloat, centerRadius: CGFloat) -> CGPoint {
    let factor: UInt32 = 360
    let randomAngle: CGFloat = CGFloat(arc4random() % factor) / 180 * CGFloat(Double.pi)
    let randomRadius: CGFloat = (radius - centerRadius) * sqrt(CGFloat(arc4random() % factor) / CGFloat(factor)) + centerRadius
    
    return CGPoint(x: randomRadius * cos(randomAngle) + center.x, y: randomRadius * sin(randomAngle) + center.y)
}

// elastic potential energy
func totalU(_ ranking: [(index: Int, radius: CGFloat, center: CGPoint)]) -> CGFloat {
    var u: CGFloat = 0
    for (i, pan) in ranking.enumerated() {
        for j in i..<ranking.count {
            let distance = sqrt(pow(pan.center.x - ranking[j].center.x, 2) + pow(pan.center.y - ranking[j].center.y, 2))
            
            // squeezed
            if distance < pan.radius + ranking[j].radius {
                u += pow(distance - (pan.radius + ranking[j].radius), 2) * 0.5
            }
        }
    }
    
    return u
}

