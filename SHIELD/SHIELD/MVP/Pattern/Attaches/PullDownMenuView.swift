//
//  PullDownMenuView.swift
//  AnnielyticX
//
//  Created by L on 2019/5/8.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class PullDownMenuView: UIView {
    var bottomIsTouched: (()->Void)?
    
    var bottomHeight: CGFloat = 0
    fileprivate let assistView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        assistView.frame = CGRect(x: 0, y: bounds.height - bottomHeight, width: bounds.width, height: bottomHeight)
    }
    
    fileprivate func addBasic() {
        backgroundColor = UIColor.clear
        assistView.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchBottom))
        assistView.addGestureRecognizer(tap)
        addSubview(assistView)
    }
    
    @objc fileprivate func touchBottom() {
        bottomIsTouched?()
    }
    
    var display = true {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var forPrint = false {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // draw
    override func draw(_ rect: CGRect) {
        // draw border
        let borderColor = UIColorFromHex(0x50D387)
        let mainPath = UIBezierPath(roundedRect: bounds.insetBy(dx: fontFactor, dy: fontFactor), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 4 * fontFactor, height: 4 * fontFactor))
        mainPath.lineWidth = 2 * fontFactor
        UIColorFromHex(0xACEBA0).setFill()
        mainPath.fill()
        borderColor.setStroke()
        mainPath.stroke()
        
        // top is white
        let boardPath = UIBezierPath(rect: CGRect(x: 0, y: forPrint ? fontFactor : 0, width: bounds.width, height: bounds.height - (forPrint ? bottomHeight * 0.4 : bottomHeight)).insetBy(dx: fontFactor, dy: 0))
        boardPath.lineWidth = fontFactor
        UIColor.white.setFill()
        boardPath.fill()
        boardPath.stroke()
        
        // tirAngle
        if !forPrint {
            let triH = bottomHeight * 0.5
            let tirHalfW = triH * 0.52
            let gap = (bottomHeight - triH) * 0.5
            let triPath = UIBezierPath()
            
            let topY = bounds.height - bottomHeight + gap
            let bottomY = bounds.height - gap
            
            triPath.move(to: CGPoint(x: bounds.midX, y: display ? topY: bottomY))
            triPath.addLine(to: CGPoint(x: bounds.midX - tirHalfW, y: display ? bottomY : topY))
            triPath.addLine(to: CGPoint(x: bounds.midX + tirHalfW, y: display ? bottomY : topY))
            triPath.close()
            triPath.lineJoinStyle = .round
            
            triPath.lineWidth = fontFactor * 0.63
            triPath.fill()
            UIColor.black.setStroke()
            triPath.stroke()
        }
    }
}
