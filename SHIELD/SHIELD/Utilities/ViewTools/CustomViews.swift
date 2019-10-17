//
//  CustomViews.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/12.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

/** with back layer */
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
    
    var imageUrl: URL! {
        didSet{
            imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, progress: nil) { (image, error, type, url) in
            }
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
        
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
    }
    
}


/** image and text view */
class ImageAndTextViewCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{
            if image != oldValue { imageView.image = image }
        }
    }
    
    var text: String! {
        didSet {
            if text != oldValue {
                textView.text = text
            }
        }
    }
    
    var attributedText: NSAttributedString! {
        didSet{
            if attributedText != oldValue {
                textView.attributedText = attributedText 
            }
        }
    }
    
    
    var imageUrl: URL! {
        didSet{
            imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, progress: nil) { (image, error, type, url) in
            }
        }
    }
    
    // open for more set
    var textView = UITextView()
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
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.bounces = false
        textView.textContainerInset = UIEdgeInsets.zero
        
        // add
        contentView.layer.addSublayer(backLayer)
        contentView.addSubview(imageView)
        contentView.addSubview(textView)
    }
    
    var answer: String = ""
    var question: String = ""
    func setTextWithAnswer(_ answer: String, question: String) {
        self.answer = answer
        self.question = question
    }
}

