//
//  ViewForAdd.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/5.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ViewForAdd: UIView {
    class func createWithFrame(_ frame: CGRect, topImage: UIImage?, title: String?, prompt: String?) -> ViewForAdd {
        let view = ViewForAdd(frame: frame)
        view.setupWithTopImage(topImage, title: title, prompt: prompt)
        
        return view
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let promptLabel = UILabel()
    let personImageView = UIImageView(image: UIImage(named: "icon_person"))
    fileprivate let topImageView = UIImageView()
  
    fileprivate func setupWithTopImage(_ topImage: UIImage?, title: String?, prompt: String?) {
        topImageView.image = topImage
        topImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        promptLabel.text = prompt
        promptLabel.textAlignment = .center
        promptLabel.numberOfLines = 0
        
        personImageView.contentMode = .scaleAspectFit
        
        // add subviews
        addSubview(topImageView)
        addSubview(titleLabel)
        addSubview(promptLabel)
        addSubview(personImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let standardH = bounds.height / 285
        
        // calendar image
        let topLength = 50 * standardH
        
        topImageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: topLength * 0.5), length: topLength)
        
        // title
        let titleFrame = CGRect(x: 0, y: topLength + 4 * standardH, width: bounds.width, height: 70 * standardH)
        titleLabel.frame = titleFrame
        titleLabel.font = UIFont.systemFont(ofSize: 28 * standardH, weight: UIFontWeightSemibold)
        titleLabel.adjustWithWidthKept()
        
        // prompt
        let promptFrame = CGRect(x: 0, y: titleFrame.maxY + 4 * standardH, width: bounds.width, height: 50 * standardH)
        promptLabel.frame = promptFrame
        promptLabel.font = UIFont.systemFont(ofSize: 18 * standardH, weight: UIFontWeightMedium)
        promptLabel.adjustWithWidthKept()
        
        // person
        let bottomLength = min(bounds.height - promptFrame.maxY - 5 * standardH, 116 * standardH)
        personImageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - bottomLength * 0.5), length: bottomLength)
    }
}
