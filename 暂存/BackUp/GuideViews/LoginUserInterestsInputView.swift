//
//  LoginUserInterestsInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class LoginUserInterestsInputView: LoginUserBasicInputView {
    // result
    var interests = [String]()
    
    // create
    fileprivate var selections = ["Overcome Illness", "Be Healther", "Anti-aging", "Longevity"]
    fileprivate var chooseViews = [ChooseView]()
    override func addBasicViews() {
        super.addBasicViews()
        
        title = "Interested in"
        
        // choose views
        for (i, text) in selections.enumerated() {
            let image = UIImage(named: "interest_\(i)")
            let chooseView = ChooseView()
            chooseView.startWithImage(image, text: text, imagePro: 1, chosenColor: tabTintGreen, unchosenImage: image, unchosenColor: textTintGray)
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(chooseInterest))
            chooseView.addGestureRecognizer(tapGR)
            
            addSubview(chooseView)
            chooseViews.append(chooseView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let mainFrame = CGRect(x: 80 * fontFactor, y: topHeight + 15 * fontFactor, width: bounds.width - 160 * fontFactor, height: bounds.height - topHeight - bottomHeight - 15 * fontFactor)
//        let viewHeight = mainFrame.height * 0.5
//        let viewWidth = mainFrame.width * 0.45
//        let gap = mainFrame.width - 2 * viewWidth
//
//        for (i, chooseView) in chooseViews.enumerated() {
//            chooseView.frame = CGRect(x: (viewWidth + gap) * CGFloat(i % 2) + mainFrame.minX, y: viewHeight * CGFloat(i / 2) + mainFrame.minY, width: viewWidth, height: viewHeight)
//        }
    }
    
    func chooseInterest(_ tapGR: UITapGestureRecognizer) {
        let chosen = tapGR.view as! ChooseView
        chosen.isChosen = !chosen.isChosen
    
        // add or remove
        interests.removeAll()
        for view in chooseViews {
            if view.isChosen {
                interests.append(view.textLabel.text!)
            }
        }
    }
}
