//
//  PlayForOthersViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/15.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class PlayForOthersViewController: UIViewController {
    fileprivate var marginGap: CGFloat {
        return view.bounds.width / 75.0
    }
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 13, height: 22)
        backButton.setBackgroundImage(UIImage(named: "barButton_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationController?.navigationBar.topItem?.title = ""
        
        // background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [introPageTopColor.cgColor, introPageBottomColor.cgColor]
        gradientLayer.locations = [0.2, 0.8]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
        let playForOthersView = PlayForOthersView.createViewWithFrame(CGRect(x: marginGap, y: 64 + marginGap, width: view.bounds.width - 2 * marginGap, height: view.bounds.height - 2 * marginGap - 64 - 49))
        playForOthersView.layer.cornerRadius = marginGap
        playForOthersView.layer.masksToBounds = true
        playForOthersView.hostVC = self
        playForOthersView.othersTable.delegateNavi = navigationController
        
        view.addSubview(playForOthersView)
    }
    
    // for title
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Welcome to the game"
    }
    
    func backButtonClicked() {
        // get back, ignore the login view
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: IntroPageViewController.self) {
                let _ = navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        
        // for total summary
        let _ = navigationController?.popViewController(animated: true)
    }
}
