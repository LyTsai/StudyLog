//
//  PlayerButton.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/4.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class PlayerButton: UIButton {
    var buttonAction: (()->())?
    var userIsChanged: (()->())?
    
    var userIcon: UIImage!

    fileprivate let label = UILabel()
    fileprivate let iconImageView = UIImageView()
    
    class func createForNavigationItem() -> PlayerButton {
        let button = PlayerButton(frame: CGRect(x: 0, y: 0, width: 45, height: 39))
        button.setupBasic()
        button.setupForNavi()
        button.setWithCurrentUser()
        
        return button
    }
    
    class func createAsNormalView(_ frame: CGRect) -> PlayerButton {
        let button = PlayerButton(frame: frame)
        button.setupBasic()
        button.setWithCurrentUser()
        
        return button
    }
    
    fileprivate func setupBasic() {
        label.textAlignment = .center
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.borderWidth = 0.8
        iconImageView.backgroundColor = UIColor.white
        
        addSubview(iconImageView)
        addSubview(label)

        let iconL: CGFloat = min(bounds.width, bounds.height * 0.9)
        let labelH: CGFloat = bounds.height * 0.35
        iconImageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: iconL * 0.5), length: iconL)
        label.frame = CGRect(x: 0, y: bounds.height - labelH, width: bounds.width, height: labelH)
        label.font = UIFont.systemFont(ofSize: 0.7 * labelH, weight: .medium)
        iconImageView.layer.cornerRadius = iconL * 0.5
        label.layer.cornerRadius = labelH * 0.5
        
        self.addTarget(self, action: #selector(buttonIsTouched), for: .touchUpInside)
    }
    
    fileprivate var forNavi = false
    fileprivate func setupForNavi() {
        forNavi = true
        let iconL: CGFloat = 35
        let labelH: CGFloat = 14
        iconImageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: iconL * 0.5), length: iconL)
        label.frame = CGRect(x: 0, y: bounds.height - labelH, width: bounds.width, height: labelH)
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        iconImageView.layer.cornerRadius = iconL * 0.5
        label.layer.cornerRadius = labelH * 0.5
    }
    
    weak var naviViewNavigation: UINavigationController!
    fileprivate var navigationForPush: UINavigationController! {
        return forNavi ? naviViewNavigation : navigation
    }
    @objc func buttonIsTouched() {
        if buttonAction == nil {
            if userCenter.userState == .login {
                showPlayer()
            }else {
                let loginVC = LoginViewController.createFromNib()
                loginVC.hidesBottomBarWhenPushed = true
                navigationForPush?.pushViewController(loginVC, animated: true)
            }
        }else {
            buttonAction!()
        }
    }
    
    fileprivate func showPlayer() {
        let playerVC = ABookPlayerViewController.initFromStoryBoard()
        playerVC.currentUserIsChanged = userIsChanged
        navigationForPush?.pushViewController(playerVC, animated: true)
    }
    
    func setWithCurrentUser() {
        if userCenter.userState == .login {
            let isUser = (userCenter.currentGameTargetUser.Key() == userCenter.loginKey)
            label.text = isUser ? "Me" : userCenter.getPseudoUser(userCenter.currentGameTargetUser.Key())!.displayName
            iconImageView.image = userCenter.currentGameTargetUser.userInfo().imageObj ?? ProjectImages.sharedImage.tempAvatar
            label.backgroundColor = UIColorFromHex(0x50D387)
        }else {
            label.text = "Login"
            iconImageView.image = #imageLiteral(resourceName: "Login")
            label.backgroundColor = UIColorFromHex(0xFDBB05)
        }
    }
}
