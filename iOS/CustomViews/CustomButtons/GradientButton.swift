//
//  GradientButton.swift
//  SHIELD
//
//  Created by L on 2020/6/11.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation
import UIKit

class GradientButton: UIButton {
    var buttonColor = buttonFillColor {
        didSet {
            setAccordingToCurrentState()
        }
    }
    
    var roundCorner = false {
        didSet {
            if roundCorner != oldValue {
                setNeedsLayout()
            }
        }
    }
    override var isSelected: Bool {
        didSet{
            self.setAccordingToCurrentState()
        }
    }
     
    // from xib, may be the text is set
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let xibTitle = self.titleLabel?.text {
            self.setTitle(xibTitle)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }
    
    fileprivate let buttonTitleLabel = UILabel()
    fileprivate let gradient = CAGradientLayer()
    fileprivate func addBasic() {
        // gradient
        gradient.opacity = 0.45
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.locations = [0, 0.55]
        titleLabel?.numberOfLines = 0
        
        self.layer.addSublayer(gradient)
        
        // text
        buttonTitleLabel.numberOfLines = 0
        buttonTitleLabel.textAlignment = .center
        self.addSubview(buttonTitleLabel)
        
        // default as selected
        isSelected = true
    }
    
    fileprivate func setAccordingToCurrentState() {
        self.backgroundColor = isSelected ? buttonColor : UIColor.white
        self.layer.borderColor = (isSelected ? UIColor.clear : buttonColor).cgColor
        self.buttonTitleLabel.textColor = isSelected ? UIColor.white : UIColor.black
    }
    
    // gradient animation
    func useAnimation() {
        gradient.removeAllAnimations()
        gradient.locations = [0, 0.55]

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0.55]
        animation.toValue = [0.55, 1]
        animation.autoreverses = true
        animation.duration = 1.5
        animation.repeatCount = MAXFLOAT

        gradient.add(animation, forKey: nil)
    }
     
    // title setup
    func setTitle(_ title: String?) {
        self.setTitle(nil, for: .normal)
        self.setTitle(nil, for: .selected)
        
        // real display
        self.buttonTitleLabel.text = title
    }
    
    // color
    func resetGradientColor(_ color: UIColor) {
        self.buttonColor = color
        self.setAccordingToCurrentState()
    }
   
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
         
        let one = bounds.height / 48
        layer.borderWidth = one
        
        let radius = roundCorner ? bounds.height * 0.5 : 8 * one
        layer.cornerRadius = radius
        let gap = one * 1.5
        gradient.frame = bounds.insetBy(dx: gap, dy: gap)
        gradient.cornerRadius = radius - gap
        
        self.buttonTitleLabel.frame = bounds.insetBy(dx: one, dy: one)
        self.buttonTitleLabel.font = UIFont.systemFont(ofSize: 18 * one, weight: .medium)
    }
}
