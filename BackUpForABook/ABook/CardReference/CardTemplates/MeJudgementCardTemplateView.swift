//
//  MeJudgementCard.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MeJudgementCardTemplateView: JudgementCardTemplateView {
    override func key() -> String {
        return MeJudgementCardTemplateView.styleKey()
    }
    
    override class func styleKey() -> String {
        return "836a757b-5673-456c-913f-b88f56ec0985"
    }
    
    override func loadView() {
        super.loadView()
        
        changeImageAndText("Me", button: confirmButton)
        changeImageAndText("Not Me", button: denyButton)
    }
    
    fileprivate func changeImageAndText(_ text: String, button: UIButton) {
        button.setBackgroundImage(ProjectImages.sharedImage.lightBG, for: .normal)
        button.setBackgroundImage(ProjectImages.sharedImage.greenBG, for: .selected)
        button.setTitle(text, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.titleEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 5, right: 5)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
  
}
