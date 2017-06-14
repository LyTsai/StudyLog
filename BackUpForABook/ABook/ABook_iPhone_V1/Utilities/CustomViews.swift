//
//  CustomViews.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/12.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// imageView added first
class ImageAndTextCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{
            if image != oldValue { imageView.image = image }
        }
    }
    
    var text: String! {
        didSet {
            if text != oldValue { textLabel.text = text }
        }
    }
    
    // open for more set
    var textLabel = UILabel()
    var imageView = UIImageView()
    var backLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    func updateUI() {
    
        imageView.contentMode = .scaleAspectFit
        
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        
        contentView.layer.addSublayer(backLayer)
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
    }
    
}

class BasicCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage! {
        didSet{
            if image != oldValue { imageView.image = image }
        }
    }
    
    var text: String! {
        didSet {
            if text != oldValue { textLabel.text = text }
        }
    }
    
    // open for more set
    var textLabel = UILabel()
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    func updateUI() {
        
        imageView.contentMode = .scaleAspectFit
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        
        
    }
    
}

