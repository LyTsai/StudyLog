//
//  RiskSelectionHintView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/19.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class RiskSelectionHintView: UIView {
    weak var hostView: AssessmentTopView!
    
    class func createWithFrame(_ frame: CGRect, hint: NSAttributedString!, personImage: UIImage!, color: UIColor) -> RiskSelectionHintView {
        let hintView = RiskSelectionHintView(frame: frame)
        hintView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        hintView.setupWithHint(hint, personImage: personImage, color: color)
        return hintView
    }
    
    fileprivate func setupWithHint(_ hint: NSAttributedString!, personImage: UIImage!, color: UIColor) {
        // backLayer
        let backLayer = CAShapeLayer()
        backLayer.fillColor = UIColor.white.cgColor
        backLayer.strokeColor = color.cgColor
        backLayer.lineWidth = 6 * fontFactor
        
        // textView
        let textViewWidth = frame.width * 0.76
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: textViewWidth, height: bounds.height * 0.6))
        textView.textContainerInset = UIEdgeInsets.zero
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isSelectable = false
        
        // dismiss button
        let hideButton = UIButton(type: .custom)
        hideButton.setBackgroundImage(ProjectImages.sharedImage.grayCircleDismiss, for: .normal)
        hideButton.addTarget(self, action: #selector(hideHint), for: .touchUpInside)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideHint))
        addGestureRecognizer(tapGR)
        
        layer.addSublayer(backLayer)
        addSubview(hideButton)
        addSubview(textView)
        
        // frame adjust
        textView.attributedText = hint
        if hint == nil {
            textView.text = "Pick the card with the description that matches you the best."
            textView.font = UIFont.systemFont(ofSize: 20 * maxOneP, weight: .semibold)
        }
        textView.sizeToFit()
        let textViewHeight = max(min(textView.frame.height, frame.height * 0.6), frame.height * 0.15)
        textView.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height * 0.45), width: textViewWidth, height: textViewHeight)
        
        let hideLength = 20 * maxOneP
        hideButton.frame = CGRect(x: textView.frame.maxX, y: textView.frame.minY - hideLength, width: hideLength, height: hideLength)
        
        let offset = hideLength + backLayer.lineWidth
        let innerFrame = textView.frame.insetBy(dx: -offset , dy: -offset)
        let borderPath = UIBezierPath(roundedRect: innerFrame, cornerRadius: 4 * fontFactor)
        
        backLayer.path = borderPath.cgPath
        
        // white border
        backLayer.frame = bounds
        backLayer.backgroundColor = UIColor.white.cgColor
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: innerFrame.insetBy(dx: -1.5 * backLayer.lineWidth, dy: -1.5 * backLayer.lineWidth), cornerRadius: 4 * fontFactor).cgPath
        maskLayer.fillColor = UIColor.red.cgColor
        backLayer.mask = maskLayer
    }

    // hide
    @objc func hideHint()  {
        if hostView != nil {
            hostView.hideRiskHint()
        }else {
            // transform
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.alpha = 0.6
            }) { (true) in
                self.isHidden = true
            }
        }
    }
}
