//
//  BubbleView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/21.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class BubbleView: UIView {
    let displayLabel = UILabel()
    fileprivate let bubbleLayer = CAShapeLayer()
    fileprivate let maskline = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func addBasic() {
        isUserInteractionEnabled = false
        
        backgroundColor = UIColor.clear
        
        bubbleLayer.fillColor = UIColor.white.cgColor
        bubbleLayer.strokeColor = UIColor.black.cgColor
        maskline.backgroundColor = UIColor.white
        // label
        displayLabel.numberOfLines = 0
        
        // layers and mask
        layer.addSublayer(bubbleLayer)
        addSubview(displayLabel)
        addSubview(maskline)
    }
    
    func displayText(_ attributedText: NSAttributedString) {
        displayLabel.attributedText = attributedText
    }

    func layoutWithFrame(_ frame: CGRect, focusX: CGFloat, arrowH: CGFloat, lineWidth: CGFloat, arrowTop: Bool) {
        self.frame = frame
        bubbleLayer.lineWidth = lineWidth
        
        // layout
        let radius = 6 * lineWidth
        let textFrame = CGRect(x: 0, y: arrowTop ? arrowH : 0, width: bounds.width, height: bounds.height - arrowH)
        displayLabel.frame = textFrame.insetBy(dx: 2 * lineWidth, dy: lineWidth)
        
        // border
        let path = UIBezierPath(roundedRect: textFrame, cornerRadius: radius)
        let arrowBottomY = arrowTop ? textFrame.minY : textFrame.maxY
        path.move(to: CGPoint(x: focusX - arrowH * 0.5, y: arrowBottomY))
        path.addLine(to: CGPoint(x: focusX, y: arrowTop ? 0 : bounds.height))
        path.addLine(to: CGPoint(x: focusX + arrowH * 0.5, y: arrowBottomY))
        
        bubbleLayer.path = path.cgPath
        
        maskline.frame = CGRect(x: focusX - arrowH * 0.5, y: arrowBottomY - lineWidth * 0.5, width: arrowH, height: lineWidth)
    }
}
