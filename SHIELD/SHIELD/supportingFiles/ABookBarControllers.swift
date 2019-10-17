//
//  BarControllers.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit
// MARK: ---------- tab bar controller -------------------
class ABookTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = tabTintGreen
        tabBar.backgroundColor = UIColor.white
        delegate = self
//        moreNavigationController.setNavigationBarHidden(true, animated: true)
//        moreNavigationController.navigationBar.isHidden = true
        
        // setup images
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                if index < 5 {
                    item.image = UIImage(named: "tab_\(index)")?.withRenderingMode(.alwaysOriginal)
                    item.selectedImage = UIImage(named: "tab_\(index)_selected")?.withRenderingMode(.alwaysOriginal)
                }else {
                    item.image = UIImage(named: "tab_\(5)")
                    item.selectedImage = UIImage(named: "tab_\(5)")
                }
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 100 {
            GameTintApplication.sharedTint.focusingTierIndex = -1
        }
    }

}

// MARK: ---------- navigation controller -------------------
class ABookNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.white
        navigationBar.barStyle = .black
        
        // backButton
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -width,vertical: 0), for: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -width,vertical: 0), for: .compact)
        setToNormalBar()
    }
}

extension UINavigationController {
    func setToNormalBar() {
        // set bar image
        // for iphoneX, navi is 44, status is 44
        let naviImage = UIImage(named:"grassland")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0), resizingMode: .stretch)
        navigationBar.setBackgroundImage(naviImage, for: .default)
        navigationBar.setBackgroundImage(naviImage, for: .compact)
    }
    
    func setClearBar() {
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
