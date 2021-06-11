//
//  InnerShadowCheckButton.swift
//  WholeSHIELD
//
//  Created by L on 2020/7/22.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation

class InnerShadowCheckButton: UIButton {
    var roundCornered = true {
        didSet{
            if roundCornered != oldValue {
                setNeedsLayout()
            }
        }
    }
    override var isSelected: Bool {
        didSet{
            setAccordingToState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBasic()
    }
    
    fileprivate let textLabel = UILabel()
    fileprivate let checked = UIImageView(image: UIImage(named: "icon_matchCheck"))
    fileprivate let innerShapeLayer = CAShapeLayer()
    fileprivate var chosenColor = buttonTintColor
    fileprivate func setupBasic() {
        self.backgroundColor = UIColor.clear
        
        // text and check
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        addSubview(textLabel)
        
        checked.contentMode = .scaleAspectFit
        addSubview(checked)
        
        // inner
        innerShapeLayer.addBlackShadow(2 * fontFactor)
        innerShapeLayer.shadowOffset = CGSize(width: 0, height: 2 * fontFactor)
        innerShapeLayer.fillRule = .evenOdd
        self.layer.addSublayer(innerShapeLayer)
        
        self.layer.addBlackShadow(2 * fontFactor)
        self.layer.shadowOpacity = 0.3
        textLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        
        setAccordingToState()
    }
    
    func setAlignment(_ alignment: NSTextAlignment) {
        self.textLabel.textAlignment = alignment
    }
    
    func setupWithTitle(_ title: String?, chosenColor: UIColor) {
        self.chosenColor = chosenColor
        self.textLabel.text = title
        self.setTitle(nil, for: .normal)
        
        // color
        innerShapeLayer.fillColor = chosenColor.cgColor
        self.layer.borderColor = chosenColor.cgColor
        
        if isSelected {
            self.backgroundColor = chosenColor
        }
    }
    
    // set up
    fileprivate func setAccordingToState() {
        self.backgroundColor = isSelected ? chosenColor : UIColor.white
        textLabel.textColor = isSelected ? UIColor.white : UIColor.black
        innerShapeLayer.isHidden = !self.isSelected
        
        self.layer.shadowColor = (self.isSelected ? UIColor.clear : UIColor.black).cgColor
    }
    
//    var calculateTextWidth: CGFloat {
//        if let attributedText = textLabel.attributedText {
//            let oneH = bounds.height / 44
//            let boundingW = attributedText.boundingRect(with: CGSize(width: width, height: bounds.height), options: .usesLineFragmentOrigin, context: nil).width
//
//            return boundingW + bounds.height + 10 * oneH
//        }
//
//        return self.bounds.width
//    }
    
    var calculatedTextHeight: CGFloat {
        if let attributedText = textLabel.attributedText {
            let boundingH = attributedText.boundingRect(with: CGSize(width: textLabel.bounds.width, height: height), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height

            print(boundingH)
            return boundingH
        }
        
        return self.bounds.height
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let oneH = bounds.height / 40
        textLabel.font = UIFont.systemFont(ofSize: 16 * oneH, weight: .medium)
        
        let radius = roundCornered ? bounds.height * 0.5 : 4 * fontFactor
        textLabel.frame = CGRect(x: radius, y: oneH, width: bounds.width - 2 * radius - 5 * oneH, height: bounds.height)
        checked.frame = CGRect(x: textLabel.frame.maxX + oneH, y: 0, width: radius - 5 * oneH, height: bounds.height)
        
        self.layer.borderWidth = oneH
        self.layer.cornerRadius = radius
        
        // inner
        
        let innerShape = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        innerShape.append(UIBezierPath(roundedRect: bounds.insetBy(dx: oneH * 2, dy: oneH * 2), cornerRadius: radius - oneH))
        innerShapeLayer.path = innerShape.cgPath
        
        let innerMask = CAShapeLayer()
        innerMask.fillColor = UIColor.red.cgColor
        innerMask.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        innerShapeLayer.mask = innerMask
    }
}

