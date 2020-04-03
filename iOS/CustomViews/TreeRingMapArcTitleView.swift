//
//  TreeRingMapArcTitleView.swift
//  BeautiPhi
//
//  Created by L on 2020/3/26.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation

class TreeRingMapArcTitleView: UIView {
    var arcCenter: CGPoint!
    var arcRadius: CGFloat!
    var textHeightSpace: CGFloat!
    var drawInfo = [(title: NSMutableAttributedString, leftAngle: CGFloat, rightAngle: CGFloat)]()
    
    override func draw(_ rect: CGRect) {
        if arcCenter == nil || arcRadius == nil || textHeightSpace == nil || drawInfo.isEmpty {
            return
        }
        
        for (titleString, left, right) in drawInfo {
            ANCircleText().paintCircleText(UIGraphicsGetCurrentContext()!, text: titleString, style: .alignMiddle, radius: arcRadius, width: textHeightSpace, left: left, right: right, center: arcCenter)
        }
    }
}
