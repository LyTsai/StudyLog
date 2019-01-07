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
        
        navigationItem.title = "Individualized Assessment Explorer"
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        // for some confine
        butterflyView = ButterflyMapView.createWithFrame(mainFrame, ratio: CGFloat(554.0 / 355.0))
        butterflyView.hostVC = self
        view.addSubview(butterflyView)
    }
    
    // refresh
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
}
