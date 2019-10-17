//
//  AppDelegate.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        if ISPHONE, #available(iOS 11, *) {
            if window!.safeAreaInsets.bottom > CGFloat(0.0) {
                HASINSETS = true
            }
        }
     
        // load first time
        if !userDefaults.bool(forKey: loadedBeforeKey) {
            // voice is on
            userDefaults.set(true, forKey: allowVoiceKey)
            userDefaults.set(true, forKey: loadedBeforeKey)
            userDefaults.synchronize()
        }
        
        // login
//        if !userDefaults.bool(forKey: splashNeverShowKey){
            let splashVC = SplashScreenViewController()
            splashVC.splashIsHide = useLogin
            window?.rootViewController = splashVC
//        }else {
//            let loginVC = LoginViewController.createFromNib()
//            window?.rootViewController = loginVC
//            loginVC.invokeFinishedClosure = presentTabbar
//        }
        
        return true
    }
    
    fileprivate func useLogin() {
        let loginVC = LoginViewController.createFromNib()
        window?.rootViewController = loginVC
        loginVC.invokeFinishedClosure = presentTabbar
    }
    
    fileprivate func presentTabbar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = storyboard.instantiateViewController(withIdentifier: TABBARID)
//        tabbar.modalTransitionStyle = .crossDissolve
//
//        if let viewController = window?.rootViewController {
//            viewController.present(tabbar, animated: true, completion: nil)
//        }
         window?.rootViewController = tabbar
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: ------- rotation -----
    var shouldRotate = false
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return shouldRotate ? .landscapeRight : .portrait
    }
 
}

