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
        backgroundColor = UIColor.white
        
        // imageView
        imageView.contentMode = .scaleAspectFit
        // textLabel
        textLabel.numberOfLines = 0
        
        // add
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    // setup
    func setupUI(_ frame: CGRect, image: UIImage?, text: String?, covered: CGFloat) {
        self.frame = frame
        self.image = image
        self.text = text
        
        let margin = 8 / 80 * min(frame.width, frame.height)
        let imageLength = 3 / 8 * min(frame.width, frame.height)
        imageView.frame = CGRect(x: margin, y: margin, width: imageLength, height: imageLength)
        
        // textlabel
        let textHeight = frame.height - imageLength - 2 * margin
        textLabel.frame = CGRect(x: margin, y: imageLength + 2 * margin, width: frame.width - 2 * margin, height: textHeight)
        textLabel.font = UIFont.systemFont(ofSize: textHeight * 0.3)
    }
    
    // with model
    class func createWithFrame(_ frame: CGRect, item: ToDoListItem, covered: CGFloat) -> ToDoListDetailView {
        let detailView = ToDoListDetailView()
        detailView.setupUI(frame, image: item.image, text: item.text, covered: covered)
        
        return detailView
    }
    

}
