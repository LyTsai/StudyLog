//
//  TagPickerView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/29.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class TagPickerView: UIView {
    
    weak var hostVC: MatchedCardsViewController!
    var tags = [UIButton]()
    
    var currentTagIndex = 0
    // create
    fileprivate var tagHeight: CGFloat = 0
    fileprivate var topTags: Int = 3 {
        didSet{
            topFloat = CGFloat(topTags)
        }
    }
    fileprivate var topFloat: CGFloat = 0
    func setupWithFrame(_ frame: CGRect, margin: CGFloat, tagHeight: CGFloat, topNumber: Int, tagNames: [String]) {
        self.frame = frame
        self.tagHeight = tagHeight
        self.currentTagIndex = 0
        self.topTags = max(topNumber, tagNames.count / 2 + tagNames.count % 2)
        
        let gap = 0.25 * margin
        let cornerRadius = 0.35 * margin
        let tagWidth = (bounds.width - 2 * margin - (topFloat - 1) * gap) / topFloat
        
        for (i, tagName) in tagNames.enumerated() {
            let tagSheet = UIView(frame: bounds)
            let tag = UIButton(type: .custom)
            
            // calculate frames
            // tag frame
            let tagX = margin + CGFloat(i % topTags) * (tagWidth + gap)
            let refinedTagHeight = tagHeight + cornerRadius
            let tagY = (i < topTags) ? 0 : bounds.height - refinedTagHeight
            let tagFrame = CGRect(x: tagX, y: tagY, width: tagWidth, height: refinedTagHeight)
            // content frame
            let mainY = (i < topTags) ? tagHeight : bounds.height - 2 * tagHeight
            let mainFrame = CGRect(x: -tagFrame.minX, y: mainY - tagFrame.minY, width: bounds.width, height: tagHeight)

            tag.frame = tagFrame
            tagSheet.frame = mainFrame
            tag.layer.cornerRadius = cornerRadius
            
            // setup
            tag.tag = i
            tag.setTitle(tagName, for: .normal)
            tag.titleLabel?.numberOfLines = 0
            tag.titleLabel?.textAlignment = .center
            tag.setTitleColor(UIColor.black, for: .normal)
            tag.titleEdgeInsets = UIEdgeInsets(top: cornerRadius, left: 0, bottom: cornerRadius, right: 0)
            tag.titleLabel?.font = UIFont.systemFont(ofSize: tagHeight * 0.28, weight: UIFontWeightMedium)
            
            // colors
            let colorPair = colorPairs[i % colorPairs.count]
            tagSheet.backgroundColor = colorPair.fill
            tag.layer.addBlackShadow(4)
            
            // gradient back
            let backLayer = CAGradientLayer()
            backLayer.colors = [colorPair.border.cgColor, colorPair.fill.cgColor]
            backLayer.locations = [0.15, 0.8]
            backLayer.startPoint = (i < topTags) ? CGPoint.zero : CGPoint(x: 0, y: 1)
            backLayer.endPoint = (i < topTags) ? CGPoint(x: 0, y: 1) : CGPoint.zero
            backLayer.frame = CGRect(origin: CGPoint.zero, size: tagFrame.size)
            backLayer.cornerRadius = cornerRadius
            
             // add
            tag.layer.addSublayer(backLayer)
            tag.backgroundColor = UIColor.clear
            tag.bringSubview(toFront: tag.titleLabel!)
            tag.addSubview(tagSheet)
            addSubview(tag)
            tags.append(tag)
            
            // action
            tag.addTarget(self, action: #selector(showTag), for: .touchUpInside)
            
            if i != 0 {
                setHideForIndex(i)
            }
        }
        
        // the first one as default
        setShowForIndex(0)
    }
    
    
    func showTag(_ button: UIButton) {
        if button.tag != currentTagIndex {
            UIView.animate(withDuration: 0.4, animations: {
                self.setHideForIndex(self.currentTagIndex)
                self.setShowForIndex(button.tag)
            }, completion: { (true) in
                self.currentTagIndex = button.tag
                
                // display cards
                if self.hostVC != nil {
                    self.hostVC.chosenTagIndex = button.tag
                }
            })
        }
    }
    
    fileprivate func setHideForIndex(_ index: Int) {
        let offsetY = tagHeight * 0.6
        let translateY = (index < topTags) ? offsetY : -offsetY
        tags[index].transform = CGAffineTransform(translationX: 0, y: translateY)
    }
    
    fileprivate func setShowForIndex(_ index: Int) {
        tags[index].transform = CGAffineTransform.identity
        bringSubview(toFront: tags[index])
    }
    
}
