//
//  SurroundingMapView.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/16.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class SurroundingMapView: UIView {
    var root: UIView!
    var children = [UIView]()
    
    func loadWithRoot(_ root: UIView, children: [UIView]) {
        for sub in subviews {
            sub.removeFromSuperview()
        }
        
        self.root = root
        self.children = children
        
        // add
        addSubview(root)
        for child in children {
            addSubview(child)
        }
    }
    
    func layNodes(_ rootSize: CGSize, childSize: CGSize)  {
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        root.frame = CGRect(center: viewCenter, width: rootSize.width, height: rootSize.height)
//        if children.count < 10 {
            ButterflyLayout.layoutEvenOvalWithRootCenter(viewCenter, children: children, ovalA: bounds.midX - rootSize.width * 0.5, ovalB: bounds.midY - rootSize.height * 0.5, startAngle: 0, expectedSize: childSize)
//        }
        
//        else {
//            let randomLayout = RandomCirclesLayout()
//            randomLayout.minRadius = max(childSize.width, childSize.height) * 0.5
//            randomLayout.radiusRange = 1
//            randomLayout.layoutCirclesOnMap(bounds, mapCenter: viewCenter, centerRadius: max(rootSize.width, rootSize.height) * 0.5, number: children.count)
//        }
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        for child in children {
            path.move(to: root.center)
//            path.addCurve(to: child.center, controlPoint1: <#T##CGPoint#>, controlPoint2: <#T##CGPoint#>)
            
            path.addLine(to: child.center)
        }
        
        path.stroke()
    }
}
