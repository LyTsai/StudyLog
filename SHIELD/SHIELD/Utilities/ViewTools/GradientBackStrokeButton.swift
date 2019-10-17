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
    
    var roundCorner = false {
        didSet{
            setNeedsLayout()
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
        gradient.locations = [0, 0.6]
        
        titleTextLabel.textAlignment = .center
        titleStrokeLabel.textAlignment = .center
        titleTextLabel.numberOfLines = 0
        titleStrokeLabel.numberOfLines = 0
        titleTextLabel.layer.masksToBounds = true
        
        layer.addSublayer(gradient)
        addSubview(titleStrokeLabel)
        addSubview(titleTextLabel)
        
        isSelected = true
    }
    
    fileprivate var title = ""
    func setupWithTitle(_ title: String) {
        self.title = title
        
        titleTextLabel.text = title
        titleStrokeLabel.attributedText = NSAttributedString(string: title, attributes: [.strokeWidth: NSNumber(value: -10)])
        fontAdjust()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.height / 44
        layer.borderWidth = one
        layer.cornerRadius = roundCorner ? bounds.height * 0.5 : 4 * one
        
        let inset = 3 * one
        gradient.frame = bounds.insetBy(dx: inset, dy: inset)
        titleTextLabel.frame = bounds.insetBy(dx: inset, dy: inset)
        titleStrokeLabel.frame = titleTextLabel.frame
        
        gradient.cornerRadius = roundCorner ? gradient.bounds.height * 0.5 : 4 * one
        titleTextLabel.layer.cornerRadius = roundCorner ? titleTextLabel.bounds.height * 0.5 : 4 * one
        
        fontAdjust()
    }
    
    fileprivate func fontAdjust() {
        let one = bounds.height / 44
        var font = UIFont.systemFont(ofSize: 16 * one, weight: .medium)
        
        let maxH = NSAttributedString(string: title, attributes: [.font: font]).boundingRect(with: bounds.size, options: .usesLineFragmentOrigin, context: nil).height
        if maxH > titleTextLabel.bounds.height {
            font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        }
        
        titleTextLabel.font = font
        titleStrokeLabel.font = font
    }
}
