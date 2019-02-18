//
//  MonthPlansViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/3.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MonthPlansTableViewController: UITableViewController {
    
    fileprivate var dayPlans = [(date: Date, plans: [PlanModel])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "" // keep the title in center
        navigationItem.title = "21 days plan"
       
        reloadDataSource()
        tableView.dataSource = self
        
        if tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        if tableView.responds(to: #selector(setter: UIView.layoutMargins)) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    // get data source
    fileprivate func reloadDataSource() {
        dayPlans.removeAll()
        
        let plans = NSKeyedUnarchiver.unarchiveObject(withFile: planPath) as? [PlanModel]
        let days = CalendarCenter.getDaysOfMonthForDate(Date())
        
        if plans != nil {
            for day in days {
                let weekIndex = CalendarCenter.getWeekIndexOfDate(day)
                var plansOfDay = [PlanModel]()
                
                for plan in plans! {
                    if plan.chosenWeeks.contains(weekIndex) {
                        plansOfDay.append(plan)
                    }
                }
                
                if plansOfDay.count != 0 {
                    dayPlans.append((day, plansOfDay))
                }
                
            }
        }
    }
    
    
    // MARK: ---------------- dataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dayPlans.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayPlans[section].plans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plansOfDay = dayPlans[indexPath.section].plans
        let day = dayPlans[indexPath.section].date
        let plan = plansOfDay[indexPath.row]
        
        let simpleCell = PlanSimpleCell.cellWithTableView(tableView, text: plan.text, checked: plan.remindedWeeks.contains(CalendarCenter.getWeekIndexOfDate(day)))
        
        return simpleCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = CGRect(x: -1, y: 0, width: view.bounds.width + 2, height: 30)
        let header = UIView(frame: headerFrame)
        header.backgroundColor = UIColorGray(249)
        header.layer.borderColor = UIColorGray(229).cgColor
        header.layer.borderWidth = 1
        
        let label = UILabel(frame: headerFrame.insetBy(dx: 11, dy: 2))
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        
        let day = dayPlans[section].date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd MMM"
        label.text = "\(formatter.string(from: day))"
        label.textColor = (CalendarCenter.theSameDay(day1: day, day2: Date()) ? UIColorFromRGB(240, green: 130, blue: 100) : UIColor.black)
        header.addSubview(label)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }

}
