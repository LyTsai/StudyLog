//
//  AddAndChoose.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: ----------- image and text cell view -------------
let addAndChooseCellID = "add And choose Cell Identifier"
class AddAndChooseCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{
            if image != oldValue {
                imageView.image = image
            }
        }
    }
    
    var text = "" {
        didSet{
            if text != oldValue {
                textLabel.text = text
            }
        }
    }
    
    // false as default
    var isChosen = false {
        didSet {
            if isChosen != oldValue {
                imageView.layer.borderColor = isChosen ? selectedColor.cgColor : unselectedColor.cgColor
                checkImageView.isHidden = !isChosen
            }
        }
    }
    
    var isLast = false {
        didSet {
            if isLast != oldValue {
                imageView.layer.borderWidth = isLast ? 0 : 1.1
            }
        }
    }
    
    
    /** border of image view */
    var unselectedColor = UIColorFromRGB(178, green: 188, blue: 202)
    var selectedColor = UIColorFromRGB(139, green: 195, blue: 74)
    // size
    /** image height ratio */
    var ihRatio: CGFloat = 0.65 {
        didSet{
            if ihRatio != oldValue {
                layoutSubviews()
            }
        }
    }
    /** text height ratio */
    var thRatio: CGFloat = 0.3 {
        didSet{
            if thRatio != oldValue {
                layoutSubviews()
            }
        }
    }
    
    // set up, private
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate let textLabel = UILabel()
    fileprivate let checkImageView = UIImageView()
    fileprivate func setupBasic() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = unselectedColor.cgColor
        imageView.layer.borderWidth = 1.1
        imageView.layer.masksToBounds = true
        
        checkImageView.isHidden = true
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.image = UIImage(named: "process_answered")
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
        contentView.addSubview(checkImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (ihRatio + thRatio) > 1 {
            print("wrong ratio")
            thRatio = 1 - ihRatio - 0.05
        }
        
        var imageLength = ihRatio * bounds.height
        let labelHeight = thRatio * bounds.height
        
        if imageLength > bounds.width {
            print("the height is too small")
            imageLength = bounds.width
        }
        
        // assign
        let imageFrame = CGRect(x: bounds.midX - imageLength * 0.5, y: 0, width: imageLength, height: imageLength)
        imageView.frame = imageFrame
        imageView.layer.cornerRadius = imageLength * 0.5
        let checkLength = imageLength * 15 / 40
        checkImageView.frame = CGRect(x: imageFrame.maxX - checkLength, y: imageFrame.maxY - checkLength, width: checkLength, height: checkLength)
        textLabel.frame = CGRect(x: 0, y: bounds.height - labelHeight, width: bounds.width, height: labelHeight)
        textLabel.font = UIFont.systemFont(ofSize: labelHeight / 2.4)
    }
}
