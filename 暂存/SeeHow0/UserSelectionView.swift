//
//  MenuSelectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/26.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class UserSelectionView: UIView {
    // set
//    fileprivate let imageView = UIImageView()
//    fileprivate let iconLabel = UILabel()
    fileprivate let label = UILabel()
    fileprivate let moreImageView = UIImageView(image: UIImage(named: "icon_forDetail")) // #imageLiteral(resourceName: "icon_forDetail"), 12 * 18
    
    func setupWithFrame(_ frame: CGRect, text: String?, more: Bool, margin: CGFloat) {
        self.frame = frame
        
        // label
        let length = min(bounds.width, bounds.height) - margin
        label.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: length, height: length))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFont(ofSize: length * 0.31, weight: UIFontWeightMedium)
//        label.textColor = UIColor.white
        label.backgroundColor = textTintGray
        
        label.layer.cornerRadius = length * 0.5
        label.layer.masksToBounds = true
        
        addSubview(label)
        
        // arrow, 12 * 18
        if more {
            let leftLength = (sqrt(2) - 1) * length * 0.45 + margin
            moreImageView.frame = CGRect(x: bounds.width - leftLength, y: bounds.height - leftLength, width: leftLength, height: leftLength)
            moreImageView.contentMode = .scaleAspectFit
            moreImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            addSubview(moreImageView)
        }
    }
    
    func duringChoosing(_ choosing: Bool) {
        moreImageView.transform = choosing ? CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2)) : CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
    }
    
    func setupTitle(_ title: String?) {
        label.text = title
    }
    
}
