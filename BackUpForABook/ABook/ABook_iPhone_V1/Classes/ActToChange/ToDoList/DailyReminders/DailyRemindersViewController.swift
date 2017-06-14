//
//  DailyRemindersViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/20.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class DailyRemindersViewController: UIViewController {
    
    var dailyPlans = [PlanModel]()
    var plans: [PlanModel]!
    
    func updateData()  {
//        dailyPlans = getRemindedPlans()
        
        if dailyPlans.count == 0 {
            reminderTable.isHidden = true
            viewForAdd.isHidden = false
        }else {
            viewForAdd.isHidden = true
            reminderTable.isHidden = false
            reminderTable.reloadData()
        }
    }
    
    // view did load
    fileprivate var viewForAdd: ViewForAdd!
    fileprivate var reminderTable: ReminderTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = ""
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        
        // data
        // --------- easy or ------------
        if plans == nil {
            plans = NSKeyedUnarchiver.unarchiveObject(withFile: easyPlanPath) as? [PlanModel]
        }
        
        dailyPlans = getRemindedPlans()
        viewForAdd = ViewForAdd.createWithFrame(CGRect(x: 0, y: 64, width: width, height: 370), topImage: UIImage(named: "reminder_golden"), title: "No active plans", prompt: "start one from \"all plans\"")
        view.addSubview(viewForAdd)
        
        reminderTable = ReminderTableView.createWithFrame(CGRect(x: 0, y: 64, width: width, height: height - 64 - 49), dailyPlans: dailyPlans)
        reminderTable.hostVC = self
        view.addSubview(reminderTable)
        
        if dailyPlans.count == 0 {
            reminderTable.isHidden = true
            viewForAdd.isHidden = false
        }else {
            viewForAdd.isHidden = true
            reminderTable.isHidden = false
        }
    }
    
    // check data
    fileprivate func getRemindedPlans() -> [PlanModel] {
        var chosenPlans = [PlanModel]()
    
        if plans != nil {
            let weekIndex = CalendarModel.getWeekIndexOfDate(Date())
            for plan in plans! {
                if plan.chosenWeeks.contains(weekIndex) {
                     chosenPlans.append(plan)
                }
            }
        }
        
        return chosenPlans
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Daily Reminders"
    }

}
