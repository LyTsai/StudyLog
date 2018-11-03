//
//  IntroPagePlayForOthersView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/15.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class PlayForOthersView: UIView, UISearchBarDelegate {
    weak var hostVC: PlayForOthersViewController!
    
    class func createViewWithFrame(_ frame: CGRect) -> PlayForOthersView {
        let view = PlayForOthersView()
        view.setupViewWithFrame(frame)
        
        return view
    }
    
    // layout data
    fileprivate var firstLineY: CGFloat {
        return bounds.height * 0.158
    }
    
    var othersTable: OtherUsersTableView!
    
    fileprivate func setupViewWithFrame(_ frame: CGRect) {
        self.frame = frame
        backgroundColor = UIColor.white
        
        // loginUser
        let loginUserRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.234)
        let loginUser = userCenter.loginUserObj
        
        // recently "played" games by user
        let tested = [RiskObjModel]()
        
        let loginUserView = PlayForOthersUserInfoView.createUserInfoView(loginUser.imageObj, userName: "My", lastDate: Date(), tested: tested)
        loginUserView.recentGamesView.isHidden = true
        loginUserView.frame = loginUserRect
        loginUserView.backgroundColor = introPageBGColor
        
        let userMaskView = UIView(frame: CGRect(x: 0, y: firstLineY, width: bounds.width, height: loginUserRect.height - firstLineY))
        userMaskView.backgroundColor = UIColor.white
        loginUserView.addSubview(userMaskView)
        
        addSubview(loginUserView)
        
        let gap = loginUserView.userIconView.frame.minX
        
        /*
        // search bar and table (hold on)
        let searchBar = UISearchBar(frame: CGRect(x: gap, y: firstLineY, width: bounds.width - 2 * gap, height: gap * 2))
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "My family and friends"
        
        let searchField = searchBar.value(forKey: "_searchField") as! UITextField
        searchField.setValue(heavyGreenColor, forKeyPath: "_placeholderLabel.textColor")
       
        addSubview(searchBar)
        */
        
        // table
        othersTable = OtherUsersTableView.createWithFrame(CGRect(x: gap, y: firstLineY, width: bounds.width - 2 * gap, height: 0.6 * bounds.height))
        addSubview(othersTable)
        
        // add button
        let topMargin = 0.1 * bounds.height
        let buttonWidth = bounds.width * 0.4795
        let buttonHeight = buttonWidth * 0.28
        
        let addButton = UIButton.customThickRectButton("Add People")
        addButton.adjustThickRectButton(CGRect(x: bounds.midX - buttonWidth * 0.5, y: topMargin + othersTable.frame.maxY, width: buttonWidth, height: buttonHeight))
        addButton.addTarget(self, action: #selector(addPeople), for: .touchUpInside)
        
        addSubview(addButton)
       
        let lineView = UIView(frame: CGRect(x: 0, y: firstLineY, width: bounds.width, height: 2))
        lineView.backgroundColor = introPageFontColor
        addSubview(lineView)
    }
    
    func addPeople() {
        let userInputVC = UserInfoInputViewController()
        userInputVC.playForOthersDelegate = self
        
        userInputVC.modalPresentationStyle = .overCurrentContext
        hostVC.present(userInputVC, animated: true, completion: nil)
    }

}
