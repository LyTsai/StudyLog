//
//  GradientBackStrokeButton.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/25.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class GradientBackStrokeButton: UIButton {
    override var isSelected: Bool {
        didSet{
            titleStrokeLabel.isHidden = !isSelected
            titleTextLabel.backgroundColor = isSelected ? UIColor.clear : UIColor.white
            titleTextLabel.textColor = isSelected ? UIColor.white : UIColor.black
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
    fileprivate let titleTextLabel = UILabel()
    fileprivate let titleStrokeLabel = UILabel()
    fileprivate let gradient = CAGradientLayer()
    fileprivate func addBasic() {
        backgroundColor = UIColorFromHex(0x7ED321)
        gradient.colors = [UIColor.white.withAlphaComponent(0.6).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.locations = [0, 1]
        
        titleTextLabel.textAlignment = .center
        titleStrokeLabel.textAlignment = .center
        titleTextLabel.numberOfLines = 0
        titleStrokeLabel.numberOfLines = 0
        
        layer.addSublayer(gradient)
        addSubview(titleStrokeLabel)
        addSubview(titleTextLabel)
        
        isSelected = true
    }
    
    func setupWithTitle(_ title: String) {
        titleTextLabel.text = title
        titleStrokeLabel.attributedText = NSAttributedString(string: title, attributes: [.strokeWidth: NSNumber(value: -15)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = min(bounds.width / 135, bounds.height / 44)
        gradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.6)
        titleTextLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: .medium)
        titleStrokeLabel.font = titleTextLabel.font
        
        let inset = 2.5 * one
        titleTextLabel.frame = bounds.insetBy(dx: inset, dy: inset)
        titleStrokeLabel.frame = titleTextLabel.frame
        layer.borderWidth = one
        layer.cornerRadius = 4 * one
    }
}
