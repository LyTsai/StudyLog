//
//  SimpleTestVC.swift
//  Demo_testUI
//
//  Created by iMac on 17/4/19.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// for test
class SimpleTestVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        let arc = CoreTextArcView(frame: view.bounds)
//        arc.backgroundColor = UIColor.cyan
//        view.addSubview(arc)
        
        let maskUsage = MaskViewUsageView(frame: view.bounds.insetBy(dx: 0, dy: 64))
        maskUsage.demoThree()
        view.backgroundColor = UIColor.white
        view.addSubview(maskUsage)
        
    }
}

