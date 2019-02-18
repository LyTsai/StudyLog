//
//  TotalSummaryViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class TotalSummaryViewController: UIViewController {
    
    fileprivate var stackHeight: CGFloat {
        return height * 121 / 667
    }
    
    fileprivate let anotherGameButton = UIButton.customNormalButton("Play a different game")
    fileprivate let someoneElseButton = UIButton.customNormalButton("Play for someone else")
    fileprivate let actionPlanButton = UIButton.customNormalButton("Action Plan")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        let table = TotalSummaryTableView.createWithFrame(CGRect(x: 0, y: 64, width: width, height: height - 64 - 49 - stackHeight))
        view.addSubview(table)
        
        let stackView = UIView(frame: CGRect(x: 0, y: table.frame.maxY, width: width, height: stackHeight))
        stackView.backgroundColor = UIColor.white
        
        let hGap = 8 * stackHeight / 121
        let length = 315 * width / 375
        let buttonX = (width - length) * 0.5
        
        let buttonHeight = (stackHeight - 2 * hGap) * 0.5

        anotherGameButton.isSelected = true
        anotherGameButton.frame = CGRect(x: buttonX, y: hGap, width: length, height: buttonHeight)
        someoneElseButton.frame = CGRect(x: buttonX, y: hGap * 1.5 + buttonHeight, width: length * 0.55, height: buttonHeight)
        actionPlanButton.frame = CGRect(x: anotherGameButton.frame.maxX - 0.415 * length, y: hGap * 1.5 + buttonHeight, width: 0.415 * length, height: buttonHeight)
        
        let font = UIFont.systemFont(ofSize: buttonHeight / 3)
        anotherGameButton.titleLabel?.font = font
        someoneElseButton.titleLabel?.font = font
        actionPlanButton.titleLabel?.font = font
        
        anotherGameButton.addTarget(self, action: #selector(playAnotherGame), for: .touchUpInside)
        someoneElseButton.addTarget(self, action: #selector(playForOthers), for: .touchUpInside)
        actionPlanButton.addTarget(self, action: #selector(actionPlan), for: .touchUpInside)
        
        stackView.addSubview(anotherGameButton)
        stackView.addSubview(someoneElseButton)
        stackView.addSubview(actionPlanButton)
        
        view.addSubview(stackView)
    }
    
    // actions
    func playAnotherGame() {
        anotherGameButton.isSelected = true
        someoneElseButton.isSelected = false
        actionPlanButton.isSelected = false
        
        let home = ABookLandingPageViewController()
        navigationController?.pushViewController(home, animated: true)
    }
    
    func playForOthers() {
        anotherGameButton.isSelected = false
        someoneElseButton.isSelected = true
        actionPlanButton.isSelected = false
        
        // check log in
        if UserCenter.sharedCenter.userState == .none {
            // user is not logged in
            // hide tabbar and push the login
            let loginVC = LoginViewController()
            loginVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(loginVC, animated: true)
        }else {
            let playForOthers = PlayForOthersViewController()
            navigationController?.pushViewController(playForOthers, animated: true)
        }
    }
    
    func actionPlan() {
        anotherGameButton.isSelected = false
        someoneElseButton.isSelected = false
        actionPlanButton.isSelected = true
        
        print("action plan clicked")
    }
}
