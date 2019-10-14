//
//  TreeRingMapAxisView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/5.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapAxisView: UIView {
    fileprivate let textLabel = UILabel()
    fileprivate let imageView = UIImageView()
    
    fileprivate var axis: TreeRingMapAxisDataModel!
    class func createWithAxis(_ axis: TreeRingMapAxisDataModel) -> TreeRingMapAxisView {
        let axisView = TreeRingMapAxisView()
        axisView.setupWithAxis(axis)
        return axisView
    }
    
    func focused(_ focused: Bool)  {
        self.transform = focused ? CGAffineTransform(scaleX: 1.2, y: 1.2) : CGAffineTransform.identity
        self.layer.shadowColor = focused ? UIColor.black.cgColor : UIColor.clear.cgColor
        
        if focused {
            self.isHidden = false
        }
    }
    
    func setImage(_ imageUrl: URL?) {
        if imageUrl != nil {
            axis.imageUrl = imageUrl
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "cache-image"), options: .refreshCached, completed: nil)
        }
    }
    
    fileprivate func setupWithAxis(_ axis: TreeRingMapAxisDataModel) {
        self.axis = axis
        layer.addBlackShadow(fontFactor * 2)
        layer.shadowOpacity = 0.6
        
        // image
        if axis.showImage {
            if imageView.superview == nil {
                imageView.backgroundColor = UIColor.white
                imageView.contentMode = .scaleAspectFit
                imageView.layer.masksToBounds = true
                
                addSubview(imageView)
            }
            imageView.sd_setImage(with: axis.imageUrl, placeholderImage: UIImage(named: "cache-image"), options: .refreshCached, completed: nil)
            imageView.layer.borderColor = axis.imageBorderColor.cgColor
        }else {
            imageView.removeFromSuperview()
        }
        
        // text
        if axis.showText {
            if textLabel.superview == nil {
                textLabel.numberOfLines = 0
                textLabel.layer.masksToBounds = true
                addSubview(textLabel)
            }
            textLabel.text = axis.displayText
            textLabel.textAlignment = axis.textAlignment
            textLabel.textColor = axis.textColor
            textLabel.backgroundColor = axis.textBackgoundColor
        }else {
            textLabel.removeFromSuperview()
        }
        

        focused(false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !axis.showImage {
            textLabel.frame = bounds
            textLabel.font = UIFont.systemFont(ofSize: min(bounds.height * 0.3, bounds.width * 0.5))
        }
        if !axis.showText {
            imageView.frame = bounds
        }
        
        if axis.showImage && axis.showText {
            // show both
            let imageL = min(bounds.width, bounds.height * 0.9)
            imageView.frame = CGRect(x: bounds.midX - imageL * 0.5, y: 0, width: imageL, height: imageL)
            let textH = max(bounds.height - imageL, bounds.height * 0.3)
            let textW = min(bounds.width, imageL * 1.5)
            textLabel.frame = CGRect(x: bounds.midX - textW * 0.5, y: bounds.height - textH, width: textW, height: textH)
            textLabel.font = UIFont.systemFont(ofSize: textH * 0.8)
            textLabel.layer.cornerRadius = textH * 0.5
        }
        
        if axis.showImage {
            imageView.layer.borderWidth = fontFactor
            imageView.layer.cornerRadius = axis.roundImage ? imageView.frame.width * 0.5 : 4 * fontFactor
        }
        
        if axis.inside {
            imageView.frame = bounds
            textLabel.frame = bounds
            
            textLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.3, weight: .medium)
        }
    }
}
