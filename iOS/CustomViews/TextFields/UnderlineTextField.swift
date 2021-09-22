//
//  UnderlineTextField.swift
//  SHIELD
//
//  Created by L on 2020/4/10.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation
import UIKit

class UnderlineTextField: UITextField {
    var underlineColor = UIColorFromHex(0x979797) {
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
        self.borderStyle = .none
        
        underline.fillColor = UIColor.clear.cgColor
        underline.lineWidth = fontFactor
        underline.strokeColor = underlineColor.cgColor
        layer.addSublayer(underline)
        
        self.adjustsFontSizeToFitWidth = true
        self.minimumFontSize = 10
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let linePath = UIBezierPath()
        linePath.move(to: bounds.bottomLeftPoint)
        linePath.addLine(to: bounds.bottomRightPoint)
        underline.path = linePath.cgPath
    }
}
