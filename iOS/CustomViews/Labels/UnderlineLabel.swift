//
//  UnderlineLabel.swift
//  SHIELD
//
//  Created by L on 2020/4/13.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation

class UnderlineLabel: UILabel {
    var underlineColor = UIColorFromHex(0xC8C7CC) {
        didSet{
            underline.strokeColor = underlineColor.cgColor
        }
    }
    var underlineWidth: CGFloat = 2 {
           didSet{
               underline.lineWidth = underlineWidth
           }
       }
    
    fileprivate let underline = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        self.adjustsFontSizeToFitWidth = true
        // line setup
        underline.fillColor = UIColor.clear.cgColor
        underline.lineWidth = fontFactor
        underline.strokeColor = underlineColor.cgColor
        layer.addSublayer(underline)
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let linePath = UIBezierPath()
        linePath.move(to: bounds.bottomLeftPoint)
        linePath.addLine(to: bounds.bottomRightPoint)
        underline.path = linePath.cgPath
    }
}
