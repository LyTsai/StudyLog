//
//  IntroPageViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IntroPageViewController: UIViewController {
    // table view
    var introPageView: IntroPageRisksCollectionView!
    fileprivate let topTitleLabel = UILabel()
    // viewDidLoad
    fileprivate var hint: IntroPageHintView!
    fileprivate let user = PlayerButton.createForNavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        
        // title
        topTitleLabel.textColor = UIColor.white
        topTitleLabel.textAlignment = .center
        topTitleLabel.numberOfLines = 0
        
        let riskClassName = cardsCursor.selectedRiskClass.name!
        if cardsCursor.riskTypeKey != nil {
            topTitleLabel.text = "\(riskClassName)\n-\(collection.getRiskTypeByKey(cardsCursor.riskTypeKey)!.name!)"
        }else {
            topTitleLabel.text = riskClassName
        }
        
        navigationItem.titleView = topTitleLabel
        topTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        user.naviViewNavigation = navigationController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: user)

        view.layer.contents = ProjectImages.sharedImage.backImage?.cgImage
        
        // get risks from backends
        introPageView = IntroPageRisksCollectionView.createWithFrame(mainFrame)
        view.addSubview(introPageView)
    }
    
    // for title and reload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navigation title
        let riskClassName = cardsCursor.selectedRiskClass.name!
        if  introPageView != nil {
            introPageView.loadWithCurrentData()
            if introPageView.risks.count > 1 {
                if !userDefaults.bool(forKey: "introPageHintShowed") {
                    if hint == nil {
                        let hintWidth = 220 * fontFactor
                        hint = IntroPageHintView(frame: CGRect(x: width - hintWidth - 25 * standWP, y: topLength + 5 * fontFactor, width: hintWidth, height: 130 * fontFactor))
                        view.addSubview(hint)
                    }
                    hint.setupWithName(riskClassName)
                    introPageView.isUserInteractionEnabled = false
                }
            }
        }
        
        user.setWithCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        introPageView.checkForHint()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hint != nil {
            userDefaults.set(true, forKey: "introPageHintShowed")
            userDefaults.synchronize()
            
            introPageView.isUserInteractionEnabled = true
            hint.stopTimer()
            hint.removeFromSuperview()
            hint = nil
        }
    }
}

