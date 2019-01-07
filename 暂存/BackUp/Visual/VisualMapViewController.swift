//
//  VisualMapViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VisualMapViewController: UIViewController {
    
    var visualMap: VisualMapView!
    let ira = IRAMatchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        ira.frame = mainFrame
        view.addSubview(ira)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ira.loadTwoParts()
    }
}
