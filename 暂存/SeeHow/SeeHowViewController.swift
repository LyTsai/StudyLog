//
//  SeeHowViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class SeeHowViewController: UIViewController {
    fileprivate var butterflyView: ButterflyMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: user)
        
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        // for some confine
        butterflyView = ButterflyMapView.createWithFrame(mainFrame, ratio: CGFloat(554.0 / 355.0))
        butterflyView.hostVC = self
        view.addSubview(butterflyView)
    }
    
    // refresh
    fileprivate let user = PlayerButton.createForNavigationItem()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Individualized Assessment Board"
        user.setWithCurrentUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if butterflyView.cardTimer != nil {
            butterflyView.cardTimer.invalidate()
            butterflyView.cardTimer = nil
        }
    }
}
