//
//  MultipleUserViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/27.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MultipleUserViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate var chosenTable: UserSelectionTableView!
    fileprivate let userView = UserSelectionView()
//    fileprivate let shadowLayer = CAShapeLayer()
    func addAllBarButtonItems(_ titleForCenter: String) {
        let currentUserKey = UserCenter.sharedCenter.currentGameTargetUser.Key()
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        spacer.width = -10
        
        // left
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 13 * width / 375, height: 22 * width / 375)
        backButton.setBackgroundImage(UIImage(named: "barButton_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        // title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width - 13 * width / 375 - 42 - 60 - 35, height: 44))
        titleLabel.text = titleForCenter
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        // choose icon
        // user
        let allUsers = CardSelectionResults.cachedCardProcessingResults.getAllUsersPlayed()
        let total = allUsers.values.first!.count + (allUsers.keys.first! == true ? 1 : 0)
        
        userView.setupWithFrame(CGRect(x: 0, y: 0, width: 42, height: 40), text: getDisplayName(currentUserKey), more: total != 1, margin: 2)
        
        if total != 1 {
            let offset: CGFloat = 5
            let tableFrame = CGRect(x: 5, y: 65, width: 120, height: CGFloat(min(total, 4) * 30) + offset)
            chosenTable = UserSelectionTableView.createWithFrame(tableFrame, users: allUsers, chosenUserKey: currentUserKey)
            chosenTable.backgroundColor = UIColorGray(252)
            chosenTable.hostVC = self
            
            // mask & shadow
            // mask
            let mask = CAShapeLayer()
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: offset, width: tableFrame.width, height: tableFrame.height - offset), cornerRadius: 5)
            let pointerX = tableFrame.width * 0.31
            path.move(to: CGPoint(x: pointerX, y: 0))
            path.addLine(to: CGPoint(x: pointerX - 0.8 * offset, y: offset))
            path.addLine(to: CGPoint(x: pointerX + 0.8 * offset, y: offset))
            mask.path = path.cgPath
            chosenTable.layer.mask = mask
            // shadow
//            shadowLayer.shadowPath = UIBezierPath(rect: tableFrame.insetBy(dx: 0, dy: offset)).cgPath
//            shadowLayer.shadowOffset = CGSize(width: 0, height: offset)
//            shadowLayer.shadowColor = UIColor.clear.cgColor
//            shadowLayer.shadowRadius = 3
//            shadowLayer.shadowOpacity = 0.9
//            
//            view.layer.addSublayer(shadowLayer)
            view.addSubview(chosenTable)
            // start
            chosenTable.isHidden = true
            
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(chooseUser))
            userView.addGestureRecognizer(tapGR)
            
        }else {
            print("only 1 is answered")
        }
        
        navigationItem.leftBarButtonItems = [spacer, UIBarButtonItem(customView: backButton), UIBarButtonItem(customView: userView),UIBarButtonItem(customView: titleLabel)]
        
        // right: My Share
        let shareBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        shareBarButton.setTitle("My Share", for: .normal)
        shareBarButton.titleLabel?.textAlignment = .right
        shareBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareBarButton)
    }
    
    func reloadWithUserKey(_ userKey: String) {
        // user icon
        userView.setupTitle(getDisplayName(userKey))
        userView.duringChoosing(false)
        if chosenTable != nil {
            chosenTable.isHidden = true
//            shadowLayer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    fileprivate func getDisplayName(_ userKey: String) -> String? {
        if userKey == UserCenter.sharedCenter.loginUserObj.key {
            return "My Cards"
        }else {
            return UserCenter.sharedCenter.getPseudoUser(userKey)!.name
        }
    }
    
    // bar button items
    func backButtonClicked() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func chooseUser() {
        if chosenTable != nil {
            chosenTable.isHidden = !chosenTable.isHidden
            userView.duringChoosing(!chosenTable.isHidden)
//            shadowLayer.shadowColor = chosenTable.isHidden ? UIColor.clear.cgColor : UIColor.black.cgColor
        }
    }
    

}
