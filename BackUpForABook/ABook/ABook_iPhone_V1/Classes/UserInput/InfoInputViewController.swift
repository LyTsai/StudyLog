//
//  InfoInputViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class InfoInputViewController: UIViewController {
    var slideView: SlideDisplayView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "homeBackImage")!)
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.title = "Welcom to the game"
        
        let requiredInfos = InfoInputModel.getRequiredInfo()
        var topViews = [UIView]()
        var texts = [String]()
        
        for info in requiredInfos {
            let infoView = InfoInputView.createWithFrame(CGRect(x: 0, y: 0, width: width - 10, height: width - 10), title: info.title, units: info.units)
            infoView.hostDelegate = self
            
            topViews.append(infoView)
            texts.append(info.descri)
        }
        
        slideView = SlideDisplayView.createWithFrame(CGRect(x: 0, y: 69, width: width, height: height - 49 - 69), topViews: topViews, descriptions: texts, heightPros:(0.7, 0.2), hMargin: 5)
        view.addSubview(slideView)
    }

}

