//
//  ABookLandingPageViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ABookLandingPageViewController: UIViewController {
    // MARK: ------- methods ---------------
    fileprivate let user = PlayerButton.createForNavigationItem()
    fileprivate var homePageView: HomePageLandingView!
    fileprivate var galaxyRoad: GalaxyAssessmentRoadDisplayView!
    fileprivate var tabTags = TabTagsDisplayView()
    fileprivate let backButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // plate
        if GameTintApplication.sharedTint.appTopic == .SlowAgingByDesign {
            // barbuttons
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createBackButton())
            user.naviViewNavigation = navigationController
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: user)
            homePageView = HomePageLandingView()
            homePageView.createHomePlate(mainFrame)
            view.addSubview(homePageView)
            view.layer.contents = ProjectImages.sharedImage.landingBack?.cgImage
        }else {
            view.layer.contents = UIImage(named: "galaxyBackground")?.cgImage
            // back
            backButton.setBackgroundImage(UIImage(named: "present_goBack"), for: .normal)
            backButton.addTarget(self, action: #selector(showForTags), for: .touchUpInside)
            backButton.frame = CGRect(x: 5 * fontFactor, y: UIApplication.shared.statusBarFrame.height + 5, width: 35, height: 35)
            
            galaxyRoad = GalaxyAssessmentRoadDisplayView.createWithFrame(CGRect(x: 0, y: backButton.frame.midY, width: width, height: height - backButton.frame.midY - bottomLength + 49), appTopic: GameTintApplication.sharedTint.appTopic)
            view.addSubview(galaxyRoad)
            view.addSubview(backButton)
        }
        
        tabTags.createWithFrame(CGRect(x: 0, y: topLength - 44, width: width, height: height - topLength - bottomLength + 44 + 49))
        view.addSubview(tabTags)
        
        // tabTags
        if homePageFirstLaunch {
            // first view
            if homePageView != nil {
                homePageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                homePageView.isHidden = true
            }else {
                backButton.isHidden = true
                galaxyRoad.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                galaxyRoad.isHidden = true
            }
            
            tabTags.allTagIsFalling = startToShowPlate
            tabTags.tagsAreFalled = showPlateView
            
            tabBarController?.tabBar.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: true)
            
            // hint
            let tagsHintKey = "tags hint shown before key"
            if !userDefaults.bool(forKey: tagsHintKey) {
                if let firstTag = tabTags.tagViews.first {
                    let hintVC = AbookHintViewController()
                    hintVC.blankAreaIsTouched = goToFirstTag
                    hintVC.focusOnFrame(view.convert(firstTag.frame, from: tabTags), hintText: "Start SlowAging Card Matching Game\nLet’ s Go!")
                    hintVC.hintKey = tagsHintKey
                    overCurrentPresentController?.present(hintVC, animated: true, completion: nil)
                }
            }
        }else {
            tabTags.transform = CGAffineTransform(translationX: 0, y: height)
            tabTags.isHidden = true
        }
    }
    
    
    fileprivate var tabIndex = 0
    fileprivate func startToShowPlate(_ index: Int) {
        tabIndex = index
    }
    
    fileprivate func showPlateView() {
        if tabIndex == 0 {
            if homePageView != nil {
                self.homePageView.isHidden = false
                showNaviAndTabs()
                UIView.animate(withDuration: 0.1, animations: {
                    self.homePageView.transform = CGAffineTransform.identity
                }) { (true) in
                    self.checkHomePageHint()
                }
            }else {
                // show metrics
                backButton.isHidden = false
                galaxyRoad.isHidden = false
                UIView.animate(withDuration: 0.1) {
                    self.galaxyRoad.transform = CGAffineTransform.identity
                }
            }
        }else {
            showNaviAndTabs()
        }
        
        self.tabTags.isHidden = true
        if tabIndex != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.homePageView != nil {
                    self.homePageView.isHidden = false
                    self.homePageView.transform = CGAffineTransform.identity
                }else {
                    self.backButton.isHidden = false
                    self.galaxyRoad.transform = CGAffineTransform.identity
                    self.galaxyRoad.isHidden = false
                }
            }
        }
    }
    
    fileprivate func showNaviAndTabs() {
        self.tabTags.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = tabIndex
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // hint
    fileprivate func checkHomePageHint() {
        let hintKey = "tilted plate hint shown before key"
        if !userDefaults.bool(forKey: hintKey) {
            let hintVC = AbookHintViewController()
            hintVC.blankAreaIsTouched = focusOnLastTier
            let last = homePageView.landing.tierThreePlate.frame
            hintVC.focusOnFrame(view.convert(last, from: homePageView.landing), hintText: "Please tap one of the three wheel tables.")
            hintVC.hintKey = hintKey
            overCurrentPresentController?.present(hintVC, animated: true, completion: nil)
        }
    }
    fileprivate func focusOnLastTier() {
        if let landing = homePageView.landing {
            landing.focusOnTier(2, selectionIndex: nil)
        }
        homePageView.tiltButton.isHidden = false
    }
    
    // ACTIONS
    override func backButtonClicked() {
        if tabTags.isHidden {
            showForTags()
        }
    }
    
    @objc func showForTags() {
        tabTags.isHidden = false
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
        
        UIView.animate(withDuration: 0.01, animations: {
            self.tabTags.transform = CGAffineTransform.identity
            
            if self.homePageView != nil {
                self.homePageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }else {
                self.backButton.isHidden = true
                self.galaxyRoad.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
            
        }){ (true) in
            if self.homePageView != nil {
                 self.homePageView.isHidden = true
            }else {
                self.galaxyRoad.isHidden = true
            }
           
            self.tabTags.resetAll()
        }
    }

    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if homePageView != nil {
            navigationItem.title = "Home"
            
            user.setWithCurrentUser()
            homePageView.focusOnCurrentData()
            
            if !homePageView.isHidden {
                checkHomePageHint()
            }
        }else {
            tabBarController?.tabBar.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: true)
            self.setNeedsStatusBarAppearanceUpdate()
        }

    }
    
    fileprivate func goToFirstTag() {
        tabTags.selectedIndex = 0
        tabTags.tagIsTouched()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if homePageView != nil {
            homePageView.stopTimers()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return homePageFirstLaunch
    }
}
