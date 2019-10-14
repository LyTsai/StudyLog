//
//  CustomButton.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/26.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import SDWebImage

class CustomButton: UIButton {
    var key: String!
    
    var fontRatio: CGFloat = 0.3
    /**back ground image*/
    var backImage: UIImage! {
        didSet{
            setBackgroundImage(backImage, for: .normal)
        }
    }
    
    var selectedBackImage: UIImage! {
        didSet{
            setBackgroundImage(selectedBackImage, for: .selected)
        }
    }
    
    fileprivate let textLabel = UILabel()
    
    var itemTitle: String!

    /** set the font for textLabel and cut size */
    var textFont = UIFont.systemFont(ofSize: 10) {
        didSet{
            textLabel.font = textFont
            textLabel.adjustWithWidthKept()
        }
    }
    
    var labelFrame = CGRect.zero {
        didSet{
            textLabel.frame = labelFrame
        }
    }
    
    var darken = false {
        didSet{
            self.alpha = darken ? 0.4 : 1
        }
    }
    
    fileprivate let checkmark = UIImageView(image: UIImage(named: "fullCheck"))
    var showCheck = false {
        didSet{
            if showCheck {
                if checkmark.superview == nil {
                    addSubview(checkmark)
                }
                checkmark.isHidden = false
            }else {
                checkmark.isHidden = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let length = min(bounds.width, bounds.height) * 0.4
        checkmark.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), length: length)
    }
    
    // for arc buttons, riskType button
    fileprivate let promptLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let promptShadow = CAShapeLayer()
    class func usedAsRiskTypeButton(_ riskTypeKey: String) -> CustomButton {
        let button = CustomButton(type: .custom)
        button.usedForRiskType()
        button.setForRiskType(riskTypeKey)
        return button
    }
    
    fileprivate func usedForRiskType() {
        backgroundColor = UIColor.white
        layer.addBlackShadow(4 * fontFactor)
        layer.shadowOffset = CGSize(width: 0, height: 4 * fontFactor)
        
        // gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint.zero
        
        layer.addSublayer(gradientLayer)
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.black
        addSubview(textLabel)
        
        layer.addSublayer(promptShadow)
        
        // prompt
        promptLabel.numberOfLines = 0
        promptLabel.textAlignment = .center
        promptLabel.textColor = UIColor.black
        promptLabel.backgroundColor = UIColor.white
        addSubview(promptLabel)
        
        // border
        layer.borderWidth = 2 * fontFactor
        promptLabel.layer.borderWidth = 1.5 * fontFactor
    }
    
    
    func setForRiskType(_ riskTypeKey: String) {
        if let riskType = collection.getRiskTypeByKey(riskTypeKey) {
            self.key = riskTypeKey
            // break string
            let name = riskType.name ?? "Nil Nill"
            let typeName = String(name[0..<3])
            let leftString = String(name[4..<name.count])
            textLabel.text = leftString
            promptLabel.text = typeName
            
            // color
            changeRiskTypeButtonColor(riskType.realColor ?? tabTintGreen)
        }
    }
    
    func adjustRiskTypeButtonWithFrame(_ frame: CGRect) {
        self.frame = frame
    
        layer.cornerRadius = 10 * fontFactor
        
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 10 * fontFactor
        gradientLayer.locations = [0.1, 0.85, 1]
        
        let buttonLength = bounds.width
        let buttonHeight = bounds.height
        let xMargin = 4 * buttonLength / 66
        
        labelFrame = CGRect(x: xMargin, y: xMargin * 0.5, width: buttonLength - 2 * xMargin, height: buttonHeight * 0.36)
        let promptFrame = CGRect(x: xMargin * 1.5, y: buttonHeight * 0.38, width: buttonLength - 3 * xMargin, height: buttonHeight * 0.52)
        
        promptLabel.frame = promptFrame
        promptLabel.layer.cornerRadius = 6 * fontFactor
        promptLabel.layer.masksToBounds = true
        
        promptShadow.path = UIBezierPath(roundedRect: promptFrame, cornerRadius: 8 * fontFactor).cgPath
        promptShadow.addBlackShadow(1.5 * fontFactor)
        promptShadow.shadowOffset = CGSize(width: 0, height: 2 * fontFactor)
        
        textLabel.font = UIFont.systemFont(ofSize: buttonLength * 0.14, weight: .semibold)
        promptLabel.font = UIFont.systemFont(ofSize: buttonLength * 0.22, weight: .bold)
    }
    
    var riskTypeColor = tabTintGreen
    func changeRiskTypeButtonColor(_ color: UIColor) {
        self.riskTypeColor = color
        gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0.6).cgColor]
        
        // border
        layer.borderColor = color.cgColor
        promptLabel.layer.borderColor = color.cgColor
    }
    
    /** for test */
    func useCheckColor() {
        backgroundColor = UIColor.red
        textLabel.backgroundColor = UIColor.blue
    }
    
    /** image on top */
    // only for riskclass now
    func verticalWithImage(_ image: URL?, title: String?, heightRatio: CGFloat) {
        createWithImage(image, text: title)
        verticalWithRatio(heightRatio, fontRatio: 0.28)
    }
    
    func verticalWithRatio(_ heightRatio: CGFloat, fontRatio: CGFloat) {
        let iHRatio = min(max(0, heightRatio), 1)
        let imageHeight = iHRatio * bounds.height
        let labelHeight = (1 - iHRatio) * bounds.height
        let offset = imageHeight * 0.12
        
        // frame
        let imageFrame = CGRect(x: 0, y: 0, width: bounds.width, height: imageHeight)
        let labelFrame = CGRect(x: 0, y: imageHeight - offset, width: bounds.width, height: labelHeight + offset)
        
        iconImageView.frame = imageFrame
        textLabel.frame = labelFrame
        textLabel.font = UIFont.systemFont(ofSize: labelFrame.height * fontRatio, weight: .semibold)
    }

    
    /** label on top */
    func verticalWithText(_ title: String?, image: URL?, heightRatio: CGFloat) {
        createWithImage(image, text: title)
        
        let lHRatio = min(max(0, heightRatio), 1)
        let labelHeight = lHRatio * bounds.height
        let imageHeight = (1 - lHRatio) * bounds.height
        
        // frame
        let labelFrame = CGRect(x: 0, y: 0, width: bounds.width, height: labelHeight)
        let imageFrame = CGRect(x: 0, y: labelHeight, width: bounds.width, height: imageHeight)
        
        adjustFrame(imageFrame, textFrame: labelFrame)
    }
    
    func setupWithText(_ text: String?, imageUrl: URL?) {
        iconImageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, progress: nil) { (image, error, type, url) in

        }
        
        // title
        textLabel.text = text
    }
    
    // MARK: ------- private
    fileprivate let iconImageView = UIImageView()
    func createWithImage(_ imageUrl: URL?, text: String?) {
        // image
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, progress: nil) { (image, error, type, url) in

        }

        // title
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        itemTitle = text
        
        addSubview(iconImageView)
        addSubview(textLabel)
    }
    fileprivate func adjustFrame(_ imageFrame: CGRect, textFrame: CGRect) {
        iconImageView.frame = imageFrame
        textLabel.frame = textFrame
        textLabel.font = UIFont.systemFont(ofSize: textFrame.height * fontRatio, weight: .semibold)
    }
    
    
    // riskClass
    class func createBlackBorderButton() -> CustomButton {
        let button = CustomButton(type: .custom)
        button.setToRoundBlackBorderButton()
        return button
    }
    
    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate func setToRoundBlackBorderButton() {
        layer.borderColor = UIColor.black.cgColor
        
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.addBlackShadow(2)
        shapeLayer.lineWidth = 0
        shapeLayer.shadowOffset = CGSize.zero
        
        // icon
        iconImageView.contentMode = .scaleAspectFit
        
        // title
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        layer.addSublayer(shapeLayer)
        addSubview(iconImageView)
        addSubview(textLabel)
        
        layer.masksToBounds = true
    }
    
    func adjustRoundBlackBorderButton() {
        let one = bounds.width / 66
        layer.cornerRadius = bounds.height * 0.5
        layer.borderWidth = one
        let offset = 5 * one
        shapeLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: offset, dy: offset)).cgPath
        shapeLayer.shadowRadius = one
    
        // topImage
        let radius = bounds.midX - offset
        let imageHeight = 0.8 * radius
        let imageLeft = sqrt(pow(radius, 2) - pow(imageHeight * 0.5, 2))
        let imageY = radius - imageLeft + offset
        let imageFrame = CGRect(x: bounds.midX - imageHeight * 0.5, y: imageY, width: imageHeight, height: imageHeight)
        // label
        let labelWidth = 2 * radius * 0.75
        let labelHeight = sqrt(pow(radius, 2) - pow(0.5 * labelWidth, 2)) + (imageLeft - imageHeight)
        let labelFrame = CGRect(x: bounds.midX - labelWidth * 0.5, y: imageFrame.maxY, width: labelWidth, height: labelHeight)
        
        iconImageView.frame = imageFrame
        textLabel.frame = labelFrame
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.26, weight: .medium)
    }
}
