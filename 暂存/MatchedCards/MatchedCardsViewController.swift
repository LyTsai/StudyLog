//
//  MatchedCardsViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/24.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardsViewController: UIViewController {
    fileprivate let user = PlayerButton.createForNavigationItem()
    fileprivate var mapView: MatchedCardsMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: user)
        
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.backImage
        view.addSubview(backImageView)
        
        // for some confine
        mapView = MatchedCardsMapView.createWithFrame(mainFrame, ratio: CGFloat(554.0 / 375.0))
        mapView.hostVC = self
        view.addSubview(mapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Matched Cards"
        user.setWithCurrentUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView.stopDotTimer()
        mapView.endCardDisplay()
    }
}
