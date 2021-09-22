//
//  BorderedAndHintDisplayTextField.swift
//  MapniPhi
//
//  Created by L on 2021/9/2.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class BorderedAndHintDisplayTextField: UITextField {
    
    var underlineColor = UIColorFromHex(0x979797) {
        didSet{
            underline.strokeColor = underlineColor.cgColor
        }
    }
    
    var borderlineWidth: CGFloat = 2 {
        didSet{
            underline.lineWidth = borderlineWidth
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
        
        let leftImageView = UIImageView()
        self.leftView = leftImageView
        
        underline.fillColor = UIColor.clear.cgColor
        underline.lineWidth = fontFactor
        underline.strokeColor = underlineColor.cgColor
        layer.addSublayer(underline)
        
        self.adjustsFontSizeToFitWidth = true
        self.minimumFontSize = 10
    }
    
    func setupWithLeftView(_ left: UIImage?)  {
        
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let linePath = UIBezierPath()
        linePath.move(to: bounds.bottomLeftPoint)
        linePath.addLine(to: bounds.bottomRightPoint)
        underline.path = linePath.cgPath
    }
}
