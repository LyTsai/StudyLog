//
//  DoEasyViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/20.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class DoEasyViewController: UIViewController {
    
    var easyPlansCollection: EasyPlansCollectionView!
    let setReminderView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        // bar
        navigationController?.navigationBar.topItem?.title = ""
        let rightItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editPlans))
        navigationItem.rightBarButtonItem = rightItem
        
        // title
        let titleHeight = 56 * height / 667
        let titleLabel = UILabel(frame: CGRect(x: 0, y: topLength, width: width, height: titleHeight))
        titleLabel.text = "你每天可以进行的内容"
        titleLabel.font = UIFont.systemFont(ofSize: titleHeight * 0.35, weight: UIFontWeightSemibold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        
        // collection
        easyPlansCollection = EasyPlansCollectionView.createWithFrame(CGRect(x: 0, y: titleLabel.frame.maxY, width: width, height: height - titleLabel.frame.maxY - 49))
        easyPlansCollection.hostVC = self
        view.addSubview(easyPlansCollection)
        
        // button
        setReminderView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        setReminderView.frame = CGRect(x: 0, y: height - 49 - titleHeight, width: width, height: titleHeight)
        
        let setButton = UIButton.customThickRectButton("Set Daily Reminders")
        setButton.adjustThickRectButton(CGRect(center: CGPoint(x: setReminderView.bounds.midX, y: setReminderView.bounds.midY), width: width * 0.5, height: titleHeight * 0.8))
        setButton.addTarget(self, action: #selector(setDailyReminder), for: .touchUpInside)
        view.addSubview(setReminderView)
        setReminderView.addSubview(setButton)
        
        setReminderView.isHidden = true
    }
    
    // actions
    func editPlans(_ barButtonItem: UIBarButtonItem) {
        let allow =  !easyPlansCollection.allowsSelection
        barButtonItem.title = allow ? "Cancel" : "Edit"
        easyPlansCollection.allowsSelection = allow
        
        if !allow {
            setReminderView.isHidden = true
        }
    }
    
    func setDailyReminder() {
        // save
        let plans = easyPlansCollection.plans!
        
        let weekIndex = CalendarCenter.getWeekIndexOfDate(easyPlansCollection.date)
        for item in easyPlansCollection.tempSelected {
            plans[item].chosenWeeks.add(weekIndex)
        }
        
        for item in easyPlansCollection.tempDeleted {
            plans[item].chosenWeeks.remove(weekIndex)
//            plans[item].remindedWeeks.remove(weekIndex)
        }
        
        NSKeyedArchiver.archiveRootObject(plans, toFile: easyPlanPath)
        
        // UI
        editPlans(navigationItem.rightBarButtonItem!)
        
        // push
        let setVC = DailyRemindersViewController()
        setVC.plans = plans
        navigationController?.pushViewController(setVC, animated: true)
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Do What's Easy"
    }
    
}
