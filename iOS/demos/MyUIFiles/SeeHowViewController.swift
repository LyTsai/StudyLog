//
//  SeeHowViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class SeeHowViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = "See How I am doing"
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        
        // for some confine
        var bFrame = mainFrame
        let ratio: CGFloat = 1.4
        if bFrame.height / bFrame.width < ratio {
            bFrame = CGRect(center: CGPoint(x: mainFrame.midX, y: mainFrame.midY), width: bFrame.height / ratio, height: bFrame.height)
        }
        
        let butterflyView = ButterflyMapView(frame: bFrame)
        view.addSubview(butterflyView)
    }
}
