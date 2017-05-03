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

        let calendarView = CalendarView.showOnView(UIView.init(frame: CGRect(x: 0, y: 0, width: 350, height: 400)))
        
        view.addSubview(calendarView)
                calendarView.today = Date()
                calendarView.setMyDate(calendarView.today)
                calendarView.frame = CGRect(x: 0, y: 64, width: 350, height: 400)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        let date = dateFormatter.string(from: Date())
        
        print(date)
    }
}
