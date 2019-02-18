//
//  SelectCardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/29.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

class SelectCardTemplateView: CardTemplateView {
    override func key() -> String {
        return SelectCardTemplateView.styleKey()
    }

    class func styleKey() -> String {
//        NSUUID().uuidString.lowercased()
        return "70d7a750-e84b-42fe-a699-80ff9ea21c9f"
    }
    // properties
    var titleLabel = UILabel()
    var multipleChoiceView = SpinningMultipleChoiceCardsTemplateView()
    fileprivate var handImageView = UIImageView()
    
    // proportions for layout
    var imageWidthPro: CGFloat = 0.94
    var imageHeightPro: CGFloat = 0.9
    var labelHeightPro: CGFloat = 0.191
    var choiceHeightPro: CGFloat = 0.722
    var handWidthPro: CGFloat = 0.15
    
    // init
    // MARK: ----- init -------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI(){
        // background image view with corners
        backImageView.image = UIImage(named: "selectBack")
        addSubview(backImageView)
        
        // titleView
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        backImageView.addSubview(titleLabel)
        
        // cards
        addSubview(multipleChoiceView)
        
        // hand
        handImageView.image = UIImage(named: "hand")
        addSubview(handImageView)
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // calculated results
        let imageWidth = imageWidthPro * bounds.width
        let imageHeight = imageHeightPro * bounds.height
        let labelHeight = labelHeightPro * bounds.height
        let choiceHeight = choiceHeightPro * bounds.height
        let handWidth = handWidthPro * bounds.width
        
        // setup
        backImageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        backImageView.layer.cornerRadius = 0.015 * bounds.width
        titleLabel.frame = CGRect(x: 0, y: 0, width: imageWidth, height: labelHeight)
        multipleChoiceView.frame = CGRect(x: 0, y: bounds.height - choiceHeight, width: bounds.height, height: choiceHeight)
        handImageView.frame = CGRect(x: bounds.midX - imageWidth * 0.5, y: imageHeight - handWidth, width: handWidth, height: handWidth)
    }
    
    // data
//            titleLabel.text = vCard.title
}
