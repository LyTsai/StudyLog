//
//  HabitViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class EstablishAHabitViewController: UIViewController {
    
    var plansTable: PlanDisplayTableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.topItem?.title = ""

        plansTable = PlanDisplayTableView.createWithFrame(CGRect(x: 0, y: 64 , width: width, height: height - 64 - 49))
        plansTable.hostVC = self
        view.addSubview(plansTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Establish a Habit"
    }
}
