//
//  CommentsBarButton.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// 22 * 22, label: 11 * 11, icon: 19 * 19
class CommentsView: UIView {
    var numberOfComments: Int = 0 {
        didSet{
            if numberOfComments != oldValue {
                if numberOfComments > 0 {
                    numberLabel.isHidden = false
                    numberLabel.text = "\(numberOfComments)"
                }else {
                    numberLabel.isHidden = true
                }
            }
        }
    }
    
    fileprivate let numberLabel = UILabel()
    class func createWithSize(_ size: CGSize, number: Int) -> CommentsView {
        let comments = CommentsView(frame: CGRect(origin: CGPoint.zero, size: size))
        comments.setupUI()
        comments.numberOfComments = number
        
        return comments
    }
    
    fileprivate func setupUI() {
        // set up
        let commentsImageView = UIImageView(image: UIImage(named: "icon_comments"))
        numberLabel.textAlignment = .center
        numberLabel.textColor = UIColor.white
        numberLabel.backgroundColor = UIColor.red
        
        // show
        addSubview(commentsImageView)
        addSubview(numberLabel)
        numberLabel.isHidden = true
        
        // frame
        let commentsLength = 19 / 22 * min(bounds.width, bounds.height)
        let numberLength = min(bounds.midX, bounds.midY)
        
        commentsImageView.frame = CGRect(x: 0, y: bounds.height - commentsLength, width: commentsLength, height: commentsLength)
        numberLabel.frame = CGRect(x: bounds.width - numberLength, y: 0, width: numberLength, height: numberLength)
        
        numberLabel.font = UIFont.systemFont(ofSize: numberLength * 0.5, weight: UIFontWeightBold)
        numberLabel.layer.cornerRadius = numberLength * 0.7
        numberLabel.layer.masksToBounds = true
    }
}
