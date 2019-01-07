//
//  VisualNode.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/15.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

@objc protocol VisualNodeDelegate {
    @objc optional func nodeIsTapped(_ node: VisualNode)
    @objc optional func nodeIsPanned(_ node: VisualNode, pan: UIPanGestureRecognizer)
}

// visual node
class VisualNode: UIView, UIGestureRecognizerDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        basicSetup()
    }
    
    fileprivate func basicSetup() {
        backgroundColor = UIColor.clear
        
        // tap
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGR.delegate = self
        addGestureRecognizer(tapGR)
        
        // pan
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGR.delegate = self
        addGestureRecognizer(panGR)
    }
    
    override var frame: CGRect {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var delegate: VisualNodeDelegate!
    
    var key = ""
    var color = tabTintGreen
//    var assessment = PlayResultState.high {
//        didSet{
//            // assessment colors
//        }
//    }
    
    var showAssessment = false
    var assessmentColor = UIColor.green
    
    var enabled = true
    
    var fillColor: UIColor {
        return enabled ? color : UIColorGray(183)
    }
    
    var borderColor: UIColor {
        return showAssessment ? assessmentColor : UIColor.clear
    }
    var borderWidth = fontFactor
    
    // data
    var text: String!
    var image: UIImage!
    var imageUrl: URL!
    
//    var font = UIFont.systemFont(ofSize: <#T##CGFloat#>)
    

    override func draw(_ rect: CGRect) {
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) * 0.5
  
        // back
        let path = UIBezierPath(arcCenter: viewCenter, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
        fillColor.setFill()
        borderColor.setStroke()
        path.lineWidth = borderWidth
        path.fill()
        path.stroke()
        
        // text
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineBreakMode = .byWordWrapping
        textStyle.alignment = .center
        
        let textAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: radius * 0.35), NSParagraphStyleAttributeName: textStyle]
        drawString(NSAttributedString(string: text, attributes: textAttributes), inRect: CGRect(center: viewCenter, length: radius * 2).insetBy(dx: radius * 0.16, dy: radius * 0.16), alignment: .center)
    }
}

// gestures
extension VisualNode {
    func tapped()  {
        if delegate != nil {
            delegate.nodeIsTapped?(self)
        }
    }
    
    func panned(_ panGR: UIPanGestureRecognizer) {
        if delegate != nil {
            delegate.nodeIsPanned?(self, pan: panGR)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
