//
//  CustomTabbarController.swift
//  Demo_testUI
//
//  Created by L on 2019/9/25.
//  Copyright © 2019 LyTsai. All rights reserved.
//

import Foundation

class CustomTabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var root = [UIViewController]()
        for i in 0..<6 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
            root.append(vc)
        }
        
        self.viewControllers = root
        
    }
}
