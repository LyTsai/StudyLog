//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        let table1 = TestTableView(frame: CGRect(x: 0, y: 120, width: 200, height: 55))
        table1.add()
        view.addSubview(table1)

        table1.frame = CGRect(x: 0, y: 120, width: 350, height: 55)

        let table3 = TestTableView(frame: CGRect(x: 0, y: 200, width: 200, height: 55))
        table1.add()
        view.addSubview(table3)
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}
