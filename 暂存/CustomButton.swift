//
//  CustomButtons.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// custom button
enum CustomButtonType {
    case normal
    case roundRectHollow(color: UIColor, cornerRadius: CGFloat, title: String)
    case roundRectFill(color: UIColor, cornerRadius: CGFloat, title: String)
    case semiCircleHollow(color: UIColor, title: String)
    case semiCircleFill(color: UIColor, title: String)
}

class CustomButton: UIButton {
    var customType: CustomButtonType = .normal
//    var title = "hello"
//    var cornerRadius: CGFloat = 10.0
    
    func setCustomType(_ type: CustomButtonType) {
        customType = type
        switch type {
        case .normal:
            break
        case .roundRectHollow(let color, let cornerRadius, let title):
            setRoundRectWithStrokeColor(color, cornerRadius: cornerRadius, title: title)
        case .roundRectFill(let color, let cornerRadius, let title):
            setRoundRectWithFillColor(color, cornerRadius: cornerRadius, title: title)
        case .semiCircleHollow(let color, let title):
            setRoundRectWithStrokeColor(color, cornerRadius: bounds.height * 0.5, title: title)
        case .semiCircleFill(let color, let title):
            setRoundRectWithFillColor(color, cornerRadius: bounds.height * 0.5, title: title)
        }
        
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
    }
    
    fileprivate func setRoundRectWithStrokeColor(_ color: UIColor, cornerRadius: CGFloat, title: String) {
        roundRectView(cornerRadius, borderWidth: 3, strokeColor: color, fillColor: UIColor.clear)
        setTitle(title, for: UIControlState())
        setTitleColor(color, for: UIControlState())
    }
    
    fileprivate func setRoundRectWithFillColor(_ color: UIColor, cornerRadius: CGFloat, title: String) {
        roundRectView(cornerRadius, borderWidth: 0, strokeColor: color, fillColor: color)
        setTitle(title, for: UIControlState())
        setTitleColor(UIColor.white, for: UIControlState())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // for SemiCircle, the cornRadius shall change
        switch customType {
        case .semiCircleHollow(color: let color, title: let title):
            setRoundRectWithStrokeColor(color, cornerRadius: bounds.height * 0.5, title: title)
        case .semiCircleFill(color: let color, title: let title):
            setRoundRectWithFillColor(color, cornerRadius: bounds.height * 0.5, title: title)
        default:
            break
        }
      
    }
    
    var buttonImage: UIImage!
    var spacing: CGFloat = 10
    
    // title is set by func setCustomType
    func setImageUpTitle(_ proportion: CGFloat) {
        
        setImage(buttonImage, for: UIControlState())

        let imageSize = imageView!.frame.size
        let titleSize = titleLabel!.frame.size
        
        let totalHeight = imageSize.height + titleSize.height + spacing
        
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height), left: 0, bottom: 0, right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0, left:  -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0)
        
    }
}
