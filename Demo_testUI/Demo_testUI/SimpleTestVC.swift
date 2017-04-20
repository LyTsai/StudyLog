//
//  SimpleTestVC.swift
//  Demo_testUI
//
//  Created by iMac on 17/4/19.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class SimpleTestVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let graph = ANNodeGraph()
        graph.frame = view.bounds
        graph.loadTestNodeTree_New()
        
        view.addSubview(graph)
    }
}
