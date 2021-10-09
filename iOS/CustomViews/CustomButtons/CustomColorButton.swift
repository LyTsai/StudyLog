//
//  CustomColorButton.swift
//  FacialRejuvenationByDesign
//
//  Created by L on 2019/6/11.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation
import UIKit

class CustomColorButton: UIButton {
    override var isSelected: Bool {
        didSet{
            backgroundColor = isSelected ? buttonTintColor : (lightMode ? UIColor.white : UIColor.clear)
            layer.borderColor = isSelected ? buttonTintColor.cgColor : normalColor.cgColor
            self.buttonTitleLabel.textColor = isSelected ? UIColor.white : normalColor
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
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate let buttonTitleLabel = UILabel()
    fileprivate func setupBasic() {
        // text
        buttonTitleLabel.numberOfLines = 0
        buttonTitleLabel.textAlignment = .center
        self.addSubview(buttonTitleLabel)
        
        // basic
        setNormalColor(normalColor)
        
        isSelected = false
    }
    
    // set up
    fileprivate var normalColor = UIColor.black
    func setNormalColor(_ color: UIColor) {
        self.normalColor = color
        if !isSelected {
            self.layer.borderColor = normalColor.cgColor
            self.buttonTitleLabel.textColor = normalColor
        }
    }
    
    fileprivate var lightMode = true
    func setForDarkBack() {
        lightMode = false
        setNormalColor(UIColor.white)
        
        backgroundColor = isSelected ? buttonTintColor : (lightMode ? UIColor.white : UIColor.clear)
    }
  
    func setTitle(_ title: String) {
        self.setTitle(nil, for: .normal)
        self.setTitle(nil, for: .selected)
        
        // real display
        self.buttonTitleLabel.text = title
    }
    
    func setAsDisable(_ disable: Bool) {
        self.isUserInteractionEnabled = !disable
        self.alpha = disable ? 0.6 : 1
    }
    
    // set
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.height / 46
        layer.borderWidth = one * 1.5
        layer.cornerRadius = 8 * one
        
        // font
        self.buttonTitleLabel.frame = bounds.insetBy(dx: one, dy: one)
        self.buttonTitleLabel.font = UIFont.systemFont(ofSize: 18 * one, weight: .medium)
    }
}


