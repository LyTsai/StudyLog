//
//  SimpleTestVC.swift
//  Demo_testUI
//
//  Created by iMac on 17/4/19.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// for test
class SimpleTestVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let arc = ArcView(frame: view.bounds)
        view.addSubview(arc)
    }
}


class ArcView: UIView {
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: min(bounds.width, bounds.height) * 0.3, startAngle: CGFloat(M_PI) * 225 / 180, endAngle: CGFloat(M_PI) * 315 / 180, clockwise: true)
        ctx?.setStrokeColor(UIColor.red.cgColor)
        ctx?.setLineWidth(4)
        ctx?.drawPath(using: .stroke)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: min(bounds.width, bounds.height) * 0.3, startAngle: CGFloat(M_PI) * 225 / 180, endAngle: CGFloat(M_PI) * 315 / 180, clockwise: true)
        UIColor.green.setStroke()
        path.lineWidth = 4
        
        path.stroke()
        
        let rect = UIBezierPath(roundedRect: bounds.insetBy(dx: 10, dy: 40), byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize(width: 20, height: 100))
        rect.lineWidth = 4
        rect.stroke()
    }
    
}
