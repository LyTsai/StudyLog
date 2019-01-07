//
//  ReminderTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/5.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ReminderTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var dailyPlans = [PlanModel]()
    weak var hostVC: DailyRemindersViewController!
    
    class func createWithFrame(_ frame: CGRect, dailyPlans: [PlanModel]) -> ReminderTableView {
        let table = ReminderTableView(frame: frame, style: .plain)
        table.dailyPlans = dailyPlans
        table.tableFooterView = UIView(frame: CGRect.zero)
        
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    // data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plan = dailyPlans[indexPath.row]
        let reminderText = plan.reminderText ?? plan.text
        
        let cell = ReminderCell.cellWithTableView(tableView, row: indexPath.row, time: plan.reminderTime, text: reminderText, isOn: plan.isRemindedForDate(Date()))
        cell.hostTable = self
            
        return cell
    }
    
    
    // delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let opitonsVC = storyboard.instantiateViewController(withIdentifier: plansOptionsStoryboardID) as! PlansOptionsTableViewController
        opitonsVC.plan = dailyPlans[indexPath.row]
        opitonsVC.dailyTable = self
        
        hostVC.navigationController?.pushViewController(opitonsVC, animated: true)
    }
    
    // data
    func saveRemind(_ row: Int, state: Bool) {
        let weekIndex = CalendarCenter.getWeekIndexOfDate(Date())
        let chosenPlan = dailyPlans[row]
        
        if state {
            chosenPlan.remindedWeeks.add(weekIndex)
        }else {
            chosenPlan.remindedWeeks.remove(weekIndex)
        }
        
        NSKeyedArchiver.archiveRootObject(hostVC.plans, toFile: easyPlanPath)
    }
}
