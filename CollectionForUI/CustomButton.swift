//
//  CustomButton.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/26.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class CustomButton: UIButton {
    var key: String!
    
    /**back ground image*/
    var backImage: UIImage! {
        didSet{
            setBackgroundImage(backImage, for: .normal)
        }
    }
    
    /** image on top */
    func verticalWithImage(_ image: UIImage?, title: String?, heightRatio: CGFloat) {
        createWithImage(image, text: title)
        
        let iHRatio = min(max(0, heightRatio), 1)
        let imageHeight = iHRatio * bounds.height
        let labelHeight = (1 - iHRatio) * bounds.height
        
        // frame
        let imageFrame = CGRect(x: 0, y: 0, width: bounds.width, height: imageHeight)
        let labelFrame = CGRect(x: 0, y: imageHeight, width: bounds.width, height: labelHeight)
        
        adjustFrame(imageFrame, textFrame: labelFrame)
    }
    
    /** label on top */
    func verticalWithText(_ title: String?, image: UIImage?, heightRatio: CGFloat) {
        createWithImage(image, text: title)
        
        let lHRatio = min(max(0, heightRatio), 1)
        let labelHeight = lHRatio * bounds.height
        let imageHeight = (1 - lHRatio) * bounds.height
        
        // frame
        let labelFrame = CGRect(x: 0, y: 0, width: bounds.width, height: labelHeight)
        let imageFrame = CGRect(x: 0, y: labelHeight, width: bounds.width, height: imageHeight)
        
        adjustFrame(imageFrame, textFrame: labelFrame)
    }
    
    // MARK: ------- private
    fileprivate let iconImageView = UIImageView()
    fileprivate let textLabel = UILabel()
    fileprivate func createWithImage(_ image: UIImage?, text: String?) {
        // image
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = image
        
        // title
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        addSubview(iconImageView)
        addSubview(textLabel)
    }
    fileprivate func adjustFrame(_ imageFrame: CGRect, textFrame: CGRect) {
        iconImageView.frame = imageFrame
        textLabel.frame = textFrame
        textLabel.font = UIFont.systemFont(ofSize: textFrame.height * 0.32)
    }
}
