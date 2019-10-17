//
//  LoginUserGenderInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class UserGenderInputView: DashBorderView {
    var sexString: String! {
        if isMale == nil {
            return nil
        }else {
            return isMale ? "Male" : "Female"
        }
    }
    
    var isMale: Bool! {
        didSet{
            if isMale == nil {
                maleImageView.alpha = 1
                femaleImageView.alpha = 1
                
                maleLabel.textColor = UIColor.black
                femaleLabel.textColor = UIColor.black
                
                maleCheck.isHidden = true
                femaleCheck.isHidden = true
            }else {
                maleImageView.alpha = isMale ? 1 : 0.3
                femaleImageView.alpha = isMale ? 0.3 : 1
                
                maleLabel.textColor = isMale ? tabTintGreen : UIColorGray(155)
                femaleLabel.textColor = isMale ? UIColorGray(155) : tabTintGreen
                
                maleCheck.isHidden = !isMale
                femaleCheck.isHidden = isMale
            }
        }
    }
    
    // create
    fileprivate let maleImageView = UIImageView(image: UIImage(named: "maleIcon"))
    fileprivate let femaleImageView = UIImageView(image: UIImage(named: "femaleIcon"))
    fileprivate let maleLabel = UILabel()
    fileprivate let femaleLabel = UILabel()
    fileprivate let maleCheck = UIImageView(image: ProjectImages.sharedImage.fullCheck)
    fileprivate let femaleCheck = UIImageView(image: ProjectImages.sharedImage.fullCheck)
    
    override func addBasicViews() {
        super.addBasicViews()
      
        addSubview(maleImageView)
        addSubview(femaleImageView)
        
        maleLabel.text = "Male"
        maleLabel.textAlignment = .center
        femaleLabel.text = "Female"
        femaleLabel.textAlignment = .center
        
        addSubview(maleLabel)
        addSubview(femaleLabel)
        addSubview(maleCheck)
        addSubview(femaleCheck)
  
        // gesture
        maleImageView.isUserInteractionEnabled = true
        femaleImageView.isUserInteractionEnabled = true
        let tapMale = UITapGestureRecognizer(target: self, action: #selector(chooseMale))
        maleImageView.addGestureRecognizer(tapMale)
        let tapFemale = UITapGestureRecognizer(target: self, action: #selector(chooseFemale))
        femaleImageView.addGestureRecognizer(tapFemale)
        
        isMale = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // images
        // 90 * 239
        let imageHeight = min(bounds.height * 0.65, bounds.width * 0.45 * 97 / 108)
        let imageWidth = imageHeight / 108 * 97
        var viewY = bounds.height * 0.7 - imageHeight
        let leftX = (bounds.width - 2 * imageWidth) / 6
        
        let leftFrame = CGRect(x: bounds.midX - imageWidth - leftX, y: viewY, width: imageWidth, height: imageHeight)
        let rightFrame = CGRect(x: bounds.midX + leftX , y: viewY, width: imageWidth, height: imageHeight)
        
        maleImageView.frame = leftFrame
        femaleImageView.frame = rightFrame
        
        viewY += bounds.height * 0.02 + imageHeight
        maleLabel.frame = CGRect(x: leftFrame.minX, y: viewY, width: imageWidth, height: bounds.height * 0.1)
        femaleLabel.frame = CGRect(x: rightFrame.minX, y: viewY, width: imageWidth, height: bounds.height * 0.1)
        maleLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.05, weight: .semibold)
        femaleLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.05, weight: .semibold)
    
        let checkLength = bounds.height * 0.08
        viewY += bounds.height * 0.06 + maleLabel.frame.height
        maleCheck.frame = CGRect(center: CGPoint(x: leftFrame.midX, y: viewY), length: checkLength)
        femaleCheck.frame = CGRect(center: CGPoint(x: rightFrame.midX, y: viewY), length: checkLength)
    }
    
    // actions
    @objc func chooseMale()  {
        isMale = true
    }
    
    @objc func chooseFemale() {
        isMale = false
    }
    
}

