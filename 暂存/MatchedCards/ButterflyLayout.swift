//
//  ButterflyLayout.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/9.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class ButterflyLayout {
    // may overlap
    class func layoutCircleWithRootCenter(_ rootCenter: CGPoint, children: [UIView], radius: CGFloat, startAngle: CGFloat, expectedLength: CGFloat) {
        if children.count == 0 {
            return
        }
        
        if children.count == 1 {
            children.first!.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(startAngle), radius: radius, origin: rootCenter), length: expectedLength)
            children.first!.alpha = 1
            return
        }
        
        let angleGap = 360 / CGFloat(children.count)
        for (i, child) in children.enumerated() {
            let angle = startAngle + CGFloat(i) * angleGap
            child.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(angle), radius: radius, origin: rootCenter), length: expectedLength)
            child.alpha = 1
        }
        
    }
    
    // 360degrees, a circle
    class func layoutEvenCircleWithRootCenter(_ rootCenter: CGPoint, children: [UIView], radius: CGFloat, startAngle: CGFloat, expectedLength: CGFloat) {
        if children.count == 0 {
            return
        }

        if children.count == 1 {
            children.first!.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(startAngle), radius: radius, origin: rootCenter), length: expectedLength)
            children.first!.alpha = 1
            return
        }
        
        let angleGap = 360 / CGFloat(children.count)
        let inscribeLength = radius * sin(radianOfAngle(angleGap * 0.5)) * 2
        let childLength = min(inscribeLength, expectedLength)
        for (i, child) in children.enumerated() {
            let angle = startAngle + CGFloat(i) * angleGap
            child.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(angle), radius: radius, origin: rootCenter), length: childLength)
            child.alpha = 1
        }
    }
    
    class func layoutEvenCircleWithRootCenter(_ rootCenter: CGPoint, children: [UIView], radius: CGFloat, startAngle: CGFloat, expectedLength: CGFloat, except: UIView) {
        var layed = [UIView]()
        for child in children {
            if child != except {
                layed.append(child)
            }
        }
    
        layoutEvenCircleWithRootCenter(rootCenter, children: layed, radius: radius, startAngle: startAngle, expectedLength: expectedLength)
    }
    
    // 360degrees, a circle
    class func layoutEvenCircleWithRootCenter(_ rootCenter: CGPoint, children: [UIView], radius: CGFloat, startAngle: CGFloat, expectedLength: CGFloat, enlargeIndex: Int!) {
         layoutEvenCircleWithRootCenter(rootCenter, children: children, radius: radius, startAngle: startAngle, expectedLength: expectedLength)
        
        if enlargeIndex == nil || enlargeIndex >= children.count {
            return
        }
        
        let angleGap = 360 / CGFloat(children.count + 1)
        let inscribeLength = radius * sin(radianOfAngle(angleGap * 0.5)) * 2
        let childLength = min(inscribeLength, expectedLength)
        var angle = startAngle
        for (i, child) in children.enumerated() {
            if i == enlargeIndex {
                angle += 0.5 * angleGap
            }
            child.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(angle), radius: radius, origin: rootCenter), length: i == enlargeIndex ?  childLength * 1.8 : childLength)
            child.alpha = 1
            
            angle += (i == enlargeIndex) ? 1.5 * angleGap : angleGap
        }
    }
    
    // start + total
    class func layoutOneGroupWithRootCenter(_ rootCenter: CGPoint, children: [UIView] , childSize: CGSize, childAlpha: CGFloat, radius: CGFloat, startAngle: CGFloat, totalAngle: CGFloat, chosenIndex: Int!, chosenSize: CGSize, chosenRadius: CGFloat, chosenAngle: CGFloat) {
        
        if children.count == 0 {
            return
        }

        if children.count == 1 {
            children.first!.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(chosenAngle), radius: radius, origin: rootCenter), width: childSize.width, height: childSize.height)
            children.first!.alpha = 1
            return
        }
        
        let angleGap = totalAngle / CGFloat(children.count - 1)
        if chosenIndex == nil || chosenIndex < 0 || chosenIndex > children.count - 1 {
            for (i, child) in children.enumerated() {
                let angle = startAngle + CGFloat(i) * angleGap
                child.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(angle), radius: radius, origin: rootCenter), width: childSize.width, height: childSize.height)
                child.alpha = 1
            }
            
            return
        }
        
        // with chosen for next
        let chosen = children[chosenIndex]
        chosen.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(chosenAngle), radius: chosenRadius, origin: rootCenter), width: chosenSize.width, height: chosenSize.height)
        chosen.alpha = 1
        var remains = [UIView]()
        for child in children {
            if child != chosen {
                remains.append(child)
            }
        }
        
        var angle = startAngle
        for child in remains {
            if abs(angle - chosenAngle) < angleGap * 0.5 {
                angle += angleGap
            }

            child.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(angle), radius: radius, origin: rootCenter), width: childSize.width * 0.8, height: childSize.width * 0.8)
            child.alpha = childAlpha
            angle += angleGap
        }
    }
    
    class func setAlphaOfNodes(_ nodes: [UIView], alpha: CGFloat)  {
        for node in nodes {
            node.alpha = alpha
        }
    }
    
    class func radianOfAngle(_ angle: CGFloat) -> CGFloat {
        return CGFloat(Double.pi) / 180 * angle
    }
}

// oval
extension ButterflyLayout {
    // a:x ,b:y , may overlap, length is not calculated
    // a and b are half of the definiation
    class func layoutEvenOvalWithRootCenter(_ rootCenter: CGPoint, children: [UIView], ovalA: CGFloat, ovalB: CGFloat, startAngle: CGFloat, expectedSize: CGSize) {
        
        if children.count == 0 {
            return
        }
        
        // clear
        let angleGap = CGFloat(Double.pi * 2) / CGFloat(children.count)
        // calculation
        for (i, item) in children.enumerated() {
            let floatI = CGFloat(i)
            let angle = startAngle + angleGap * floatI
            let radius = 1.0 / sqrt(cos(angle) * cos(angle) / (ovalA * ovalA) + sin(angle) * sin(angle) / (ovalB * ovalB))
            item.frame = CGRect(center: CGPoint(x: radius * cos(angle) + rootCenter.x, y: radius * sin(angle) + rootCenter.y), width: expectedSize.width , height: expectedSize.height)
            item.alpha = 1
        }
    }
    
    class func layoutOvalGroupWithRootCenter(_ rootCenter: CGPoint, children: [UIView] , childSize: CGSize, childAlpha: CGFloat, ovalA: CGFloat, ovalB: CGFloat, startAngle: CGFloat, totalAngle: CGFloat, chosenIndex: Int!, chosenSize: CGSize, chosenRadius: CGFloat, chosenAngle: CGFloat) {
        if children.count == 0 {
            return
        }
        
        if children.count == 1 {
            children.first!.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(chosenAngle), radius: chosenRadius, origin: rootCenter), width: childSize.width, height: childSize.height)
            children.first!.alpha = 1
            return
        }
        
        let angleGap = totalAngle / CGFloat(children.count - 1)
        if chosenIndex == nil || chosenIndex < 0 || chosenIndex > children.count - 1 {
            for (i, child) in children.enumerated() {
                let angle = radianOfAngle(startAngle + CGFloat(i) * angleGap)
                let radius = 1.0 / sqrt(cos(angle) * cos(angle) / (ovalA * ovalA) + sin(angle) * sin(angle) / (ovalB * ovalB))
                child.frame = CGRect(center: CGPoint(x: radius * cos(angle) + rootCenter.x, y: radius * sin(angle) + rootCenter.y), width: childSize.width , height: childSize.height)
                child.alpha = 1
            }
            
            return
        }
        
        // with chosen for next
        let chosen = children[chosenIndex]
        chosen.frame = CGRect(center: Calculation().getPositionByAngle(radianOfAngle(chosenAngle), radius: chosenRadius, origin: rootCenter), width: chosenSize.width, height: chosenSize.height)
        chosen.alpha = 1
        var remains = [UIView]()
        for child in children {
            if child != chosen {
                remains.append(child)
            }
        }
        
        var angle = startAngle
        for child in remains {
            if abs(angle - chosenAngle) < angleGap * 0.5 {
                angle += angleGap
            }
            let rAngle = radianOfAngle(angle)
            let radius = 1.0 / sqrt(cos(rAngle) * cos(rAngle) / (ovalA * ovalA) + sin(rAngle) * sin(rAngle) / (ovalB * ovalB))
            child.frame = CGRect(center: CGPoint(x: radius * cos(rAngle) + rootCenter.x, y: radius * sin(rAngle) + rootCenter.y), width: childSize.width , height: childSize.height)
            child.alpha = childAlpha
            angle += angleGap
        }
    }
}
