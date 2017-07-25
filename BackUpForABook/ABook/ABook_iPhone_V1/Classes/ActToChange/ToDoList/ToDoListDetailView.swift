//
//  ToDoListDetailView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/12.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ToDoListDetailView: UIView {
    var image: UIImage! {
        didSet{
            if image != oldValue {
                
                // slices
                imageView.image = image
            }
        }
    }
    
    var text: String! {
        didSet{
            if text != oldValue {
                textLabel.text = text
            }
        }
    }
    
    var checkedImage: UIImage!

    var checked = false {
        didSet{
        
        }
    }
    
    // may be shifted
    fileprivate let imageView = UIImageView()
    fileprivate let textLabel = UILabel()
    
        // MARK: ------------- init ----------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubs()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubs()
    }
    
    fileprivate func addSubs() {
        backgroundColor = UIColor.clear
        
        // imageView
        
        // textLabel
        textLabel.numberOfLines = 0
        
        // checkBox
        
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    var labelFrame = CGRect.zero {
        didSet {
            textLabel.frame = labelFrame
            let fontSize = max(min(min(labelFrame.height, labelFrame.width) * 0.35, 11),8)
            textLabel.font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightMedium)
        }
    }
    
    
    // setup
    func setupUI(_ frame: CGRect, image: UIImage?, text: String?) {
        self.frame = frame
        self.image = image
        self.text = text
        
        imageView.frame = bounds
    }
}
