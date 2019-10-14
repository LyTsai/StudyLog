//
//  CardOptionCell.swift
//  AnnielyticX
//
//  Created by L on 2019/4/24.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

// MARK: -------------- cell ------------------------
let cardOptionCellID = "card option Cell Identifier"
class CardOptionCell: ImageAndTextViewCell {
    var ratio: CGFloat = 0.7
    var textLines: CGFloat = 3
    var horizontal = false
    var mainColor = UIColor.blue {
        didSet{
            backLayer.strokeColor = mainColor.cgColor
        }
    }

    var resultTag: Bool! {
        didSet{
            if resultTag != oldValue {
                if resultTag == nil {
                    result.isHidden = true
                }else {
                    result.isHidden = false
                    result.text = resultTag ? "ME" : "NOT ME"
                    result.backgroundColor = resultTag ? UIColorFromRGB(61, green: 59, blue: 238) : UIColorFromRGB(204, green: 123, blue: 0)
                }
            }
        }
    }
    
    var isChosen = false {
        didSet{
            backLayer.shadowColor = isChosen ? UIColor.black.cgColor : UIColor.clear.cgColor
            maskLayer.isHidden = !isChosen
        }
    }
    
    //    fileprivate let crossImage = UIImageView(image: UIImage(named: "redCross"))
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate let result = UILabel()
    override func updateUI() {
        super.updateUI()
        
        backLayer.fillColor = UIColor.white.cgColor
        backLayer.strokeColor = mainColor.cgColor
        backLayer.addBlackShadow(2 * fontFactor)
        
        result.isHidden = true
        result.textAlignment = .center
        result.textColor = UIColor.white
        contentView.addSubview(result)
        result.layer.masksToBounds = true
        result.layer.borderColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        contentView.layer.addSublayer(maskLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let backLength = min(bounds.width, bounds.height) * ratio
        let borderWidth = backLength / 65
        // image and back
        var topFrame = CGRect(center: CGPoint(x: bounds.midX, y: backLength * 0.5 + 2 * borderWidth), length: backLength)
        
        // larger
        backLayer.lineWidth = borderWidth
        backLayer.path = UIBezierPath(roundedRect: topFrame, cornerRadius: 3 * borderWidth).cgPath
        imageView.frame = topFrame.insetBy(dx: borderWidth * 1.5, dy: borderWidth * 1.5)
        
        // text
        let labelHeight = bounds.height - backLength - borderWidth * 2
        textView.frame = CGRect(x: 0, y: bounds.height - labelHeight, width: bounds.width, height: labelHeight)
        textView.font = UIFont.systemFont(ofSize: min(labelHeight, bounds.width) / textLines * 0.9, weight: .bold)
        
        if horizontal {
            topFrame = CGRect(center: CGPoint(x: bounds.height * 0.5, y: bounds.height * 0.5), length: backLength)
            // larger
            
            textView.textAlignment = .left
            
            backLayer.lineWidth = borderWidth
            backLayer.path = UIBezierPath(roundedRect: topFrame, cornerRadius: 3 * borderWidth).cgPath
            imageView.frame = topFrame.insetBy(dx: borderWidth * 1.5, dy: borderWidth * 1.5)
            
            textView.font = UIFont.systemFont(ofSize: bounds.height / textLines * 0.85, weight: .medium)
            textView.frame = CGRect(x: imageView.frame.maxX, y: 0, width: bounds.width - imageView.frame.maxX, height: bounds.height)
            
            let tHeight = textView.layoutManager.usedRect(for: textView.textContainer).height
            if tHeight < bounds.height {
                textView.frame = CGRect(x: imageView.frame.maxX, y: (bounds.height - tHeight) * 0.5, width: bounds.width - imageView.frame.maxX, height: tHeight)
            }
        }
        
        result.frame = CGRect(x: topFrame.minX + 2 * borderWidth, y: topFrame.minY + 2 * borderWidth, width: 45 * borderWidth, height: 12 * borderWidth)
        result.font = UIFont.systemFont(ofSize: 9 * borderWidth, weight: .semibold)
        result.layer.cornerRadius = 6 * borderWidth
        result.layer.borderWidth = borderWidth
        maskLayer.path = backLayer.path
    }
}

