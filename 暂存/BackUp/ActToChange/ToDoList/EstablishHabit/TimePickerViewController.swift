//
//  TimePickerViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class TimePickerViewController: UIViewController {
    var lastDate = Date()
    weak var hostTable: PlansOptionsTableViewController!
    
    fileprivate let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "Pick Time"
        
        // date picker
        datePicker.frame = CGRect(x: 0, y: topLength, width: width, height: 250)
        datePicker.datePickerMode = .time
        datePicker.date = lastDate
        
        view.addSubview(datePicker)
        
        // add
        let addButton = UIButton.customThickRectButton("Add Time")
        addButton.adjustThickRectButton(CGRect(x: 120, y: 360, width: 120, height: 60))

        addButton.addTarget(self, action: #selector(finishSelection), for: .touchUpInside)
        
        view.addSubview(addButton)
        
    }
    
    func finishSelection() {
        hostTable.reminderTime = datePicker.date
        
        let _ = navigationController?.popViewController(animated: true)
    }
}
