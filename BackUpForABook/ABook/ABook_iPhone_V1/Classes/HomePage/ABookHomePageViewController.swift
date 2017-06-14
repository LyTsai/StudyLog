//
//  ABookHomePageViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ABookHomePageViewController: UIViewController {
    
    @IBOutlet weak var understandButton: UIButton!
    @IBOutlet weak var careButton: UIButton!
    @IBOutlet weak var actButton: UIButton!
    
    fileprivate var launched = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        launched = UserDefaults.standard.bool(forKey: "launched")
        if !launched {
            understandButton.isHidden = true
            careButton.isHidden = true
            actButton.isHidden = true
            
            userDefaults.set(true, forKey: "launched")
            userDefaults.synchronize()
        }
    }
    
    @IBAction func helpYouUnderstand(_ sender: Any) {
        let tabbar = storyboard?.instantiateViewController(withIdentifier: "TabbarController") as! ABookTabBarController
        tabbar.selectedIndex = 2
        self.present(tabbar, animated: true, completion: nil)
        
    }
    
    @IBAction func helpYouCare(_ sender: Any) {
        let tabbar = storyboard?.instantiateViewController(withIdentifier: "TabbarController") as! ABookTabBarController
        tabbar.selectedIndex = 0
        self.present(tabbar, animated: true, completion: nil)
    }
    
    @IBAction func helpYouAct(_ sender: Any) {
        let tabbar = storyboard?.instantiateViewController(withIdentifier: "TabbarController") as! ABookTabBarController
        tabbar.selectedIndex = 1
        self.present(tabbar, animated: true, completion: nil)
    }
 
    @IBAction func goToNext() {
        
        if launched {
            // go to landing page
            let tabbar = storyboard?.instantiateViewController(withIdentifier: "TabbarController") as! ABookTabBarController
            tabbar.selectedIndex = 0
            self.present(tabbar, animated: true, completion: nil)
        }else{
            // go to splash page
            let splash = SplashScreenViewController()
            splash.presenetedFromVC = self
            launched = true
            present(splash, animated: true, completion: nil)
       
        }
    }
}
