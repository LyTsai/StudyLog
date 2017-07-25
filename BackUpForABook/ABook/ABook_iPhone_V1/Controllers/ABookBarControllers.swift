//
//  BarControllers.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit
import ABookData

class ABookTabBarController: UITabBarController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = tabTintGreen
        
        // setup images
        let items = tabBar.items
        for (index,item) in items!.enumerated() {
            // with clear back now
            if index == 3 {
                item.image = UIImage(named: "tabbar_icon_News")
            }else {
                let title = (item.title)!
        
                item.selectedImage = UIImage(named:"tabbar_icon_\(title)_selected")?.withRenderingMode(.alwaysOriginal)
                item.image = setupBarItemImage("tabbar_icon_\(title)_unselected")
            }
        }
        
        tabBar.isTranslucent = false
        
        // callback for config files.
        //DbUtil.setConfigProtocol(self)
        
    }

    var normalLength: CGFloat = 37
    func setupBarItemImage(_ imageName: String) -> UIImage {
        let image = UIImage(named: imageName) ?? UIImage(named: "tabbar_icon_News")!
        let originalWidth = image.size.width
        let originalHeight = image.size.height
        var changedSize = CGSize.zero
        
        let ratio = originalWidth / originalHeight
        if ratio > 1 {
            changedSize = CGSize(width: normalLength, height: normalLength / ratio)
        }else {
            changedSize = CGSize(width: normalLength * ratio, height: normalLength)
        }
        
        let changedImage = image.changeImageSizeTo(changedSize)
        return changedImage.withRenderingMode(.alwaysOriginal)

    }
}

class ABookNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.white
        navigationBar.barStyle = .black
        
        // backButton
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0,vertical: -60), for: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0,vertical: -60), for: .compact)
        
        // set background image
        let naviImage = UIImage(named:"grassland")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        navigationBar.setBackgroundImage(naviImage, for: .default)
        navigationBar.setBackgroundImage(naviImage, for: .compact)
        
        navigationBar.backgroundColor = UIColor.black
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

extension ABookTabBarController: WebApiConfigProtocol {
    func didFinishLoadingConfigDataTask(_ sender: ConfigWebService, configContext : String) {
        /*        let alert = UIAlertController.init(title: "", message: "\(configContext) has been updated.", preferredStyle: .Alert)
         let ok = UIAlertAction.init(title: "OK", style: .Default, handler: nil)
         alert.addAction(ok)
         presentViewController(alert, animated: true, completion: nil)
         */
        print("Finished loading config \(configContext) ")
    }
    
    func failedLoadingConfigDataFromService(_ sender : ConfigWebService, configContext : String, errorMessage : String) {
        print("Fail loading config \(configContext) with error \(errorMessage)")
    }
    
    func didFinishLoadingAllConfigDataTask(_ sender : ConfigWebService) {
        let alert = UIAlertController.init(title: "", message: "User data has been updated from server.", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        print("Loading all configs are done")
    }
    
    func failedLoadingAllConfigDataFromService(_ sender : ConfigWebService, errorMessage : String) {
        let alert = UIAlertController.init(title: "", message: "Failed to load user's config from server.", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        print("Fail loading all config info with error \(errorMessage)")
    }
}
