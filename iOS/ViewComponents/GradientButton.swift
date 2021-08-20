//
//  GradientButton.swift
//  MagniPhi
//
//  Created by L on 2021/5/10.
//  Copyright © 2021 MingHui. All rights reserved.
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
        self.backgroundColor = UIColor.white
        
        // gradient
        gradient.opacity = 0.8
        gradient.colors = [UIColorFromHex(0xECFFC9).cgColor, UIColorFromHex(0x67BD45).cgColor]
        gradient.locations = [0, 0.99]
        self.layer.addSublayer(gradient)
        
        // text
        buttonTitleLabel.numberOfLines = 0
        buttonTitleLabel.textAlignment = .center
        self.addSubview(buttonTitleLabel)
        
        // default as selected
        isSelected = true
    }
    
    fileprivate func setAccordingToCurrentState() {
        self.gradient.isHidden = !isSelected
        self.layer.borderColor = (isSelected ? projectTintColor : buttonColor).cgColor
        self.buttonTitleLabel.textColor = isSelected ? UIColor.black : buttonColor
    }
    
   
    // title setup
    func setTitle(_ title: String?) {
        self.setTitle(nil, for: .normal)
        self.setTitle(nil, for: .selected)
        
        // real display
        self.buttonTitleLabel.text = title
    }
    
    fileprivate var action: (() -> Void)?
    func addButtonAction(_ action: (() -> Void)?) {
        self.action = action
        if (self.actions(forTarget: self, forControlEvent: .touchUpInside) ?? []).isEmpty {
            self.addTarget(self, action: #selector(buttonIsTouched), for: .touchUpInside)
        }
    }
    @objc func buttonIsTouched() {
        self.action?()
    }
    
    func setAsMoreGradients() {
        self.roundCorner = true
        gradient.opacity = 1
        gradient.colors = [UIColorFromHex(0xD4FF89).cgColor, UIColorFromHex(0x98D150).cgColor, UIColorFromHex(0x368F12).cgColor]
        gradient.locations = [0, 0.1, 0.99]
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
         
        let one = bounds.height / 40
        layer.borderWidth = one
        
        let innerFrame = bounds.insetBy(dx: 0.5 * one, dy: 0.5 * one)
        let radius = roundCorner ? bounds.height * 0.5 : 4 * one
        layer.cornerRadius = radius
        gradient.frame = innerFrame
        gradient.cornerRadius = radius - 0.5 * one
        
        self.buttonTitleLabel.frame = innerFrame
        self.buttonTitleLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: .medium)
    }
}
