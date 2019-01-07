//
//  MatchedCardsViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/24.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Matched Cards"
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.backImage
        view.addSubview(backImageView)
        
        // for some confine
        let mapView = MatchedCardsMapView.createWithFrame(mainFrame, ratio: CGFloat(554.0 / 375.0))
        mapView.hostVC = self
        view.addSubview(mapView)
    }
}
