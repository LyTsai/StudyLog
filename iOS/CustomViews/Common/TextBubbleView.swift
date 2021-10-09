//
//  TextBubbleView.swift
//  MagniPhi
//
//  Created by Lydire on 2021/7/29.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class TextBubbleView: UIView {
    var bubbleIsTouched: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBasic()
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let bubbleShape = CAShapeLayer()
    fileprivate func setupBasic() {
        self.backgroundColor = UIColor.clear
        bubbleShape.fillColor = UIColor.white.cgColor
        bubbleShape.addBlackShadow(12)
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        layer.addSublayer(bubbleShape)
        addSubview(titleLabel)
    }
    
    var attributedString: NSAttributedString? {
        didSet {
            self.titleLabel.attributedText = attributedString
        }
    }
    
    func setupTopBubbleWithX(_ bubblePoint: CGPoint, edgeInsets: UIEdgeInsets, confine: CGRect, radius: CGFloat, overlapOnWindow: Bool) {
        // calculte
        let maxTextH = attributedString?.boundingRect(with: CGSize(width: confine.width - edgeInsets.left - edgeInsets.right, height: confine.height - edgeInsets.top - edgeInsets.bottom), options: .usesLineFragmentOrigin, context: nil).height ?? 10
        
        let bubbleH = maxTextH + edgeInsets.top + edgeInsets.bottom + 5 // extra
        self.frame = overlapOnWindow ? UIScreen.main.bounds : CGRect(x: confine.minX, y: bubblePoint.y, width: confine.width, height: bubbleH + confine.minY - bubblePoint.y)
        

        let mainFrame = overlapOnWindow ? CGRect(x: confine.minX, y: confine.minY, width: confine.width, height: bubbleH) : CGRect(x: 0, y: bounds.height - bubbleH, width: bounds.width, height: bubbleH)
        
        let bubblePath = UIBezierPath.getTopArrowBubblePathWithMainFrame(mainFrame, arrowPoint: overlapOnWindow ? bubblePoint : CGPoint(x: bubblePoint.x - confine.minX, y: 0), radius: radius)
        bubbleShape.path = bubblePath.cgPath
        titleLabel.frame = mainFrame.inset(by: edgeInsets)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
        bubbleIsTouched?()
    }
}
