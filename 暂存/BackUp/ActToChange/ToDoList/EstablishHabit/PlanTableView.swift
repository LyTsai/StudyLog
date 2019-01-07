//
//  PlanTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// MARK: -------- plan display table -------------
class PlanDisplayTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    // data
    /** total plans */
    var plans = [PlanModel]()
    
    /** dataSource of table */
    var currentPlans = [PlanModel]()
    var currentDate = Date() {
        didSet{
            if currentDate != oldValue {
                currentPlans = getPlansForDate(currentDate)
                reloadData()
            }
        }
    }
    
    func updateData() {
        reloadData()
    }
    
    weak var hostVC: EstablishAHabitViewController!
    var showAll = false {
        didSet{
            if showAll != oldValue {
                if showAll == false {
                    // back to today
                    currentDate = Date()
                }
                reloadData()
            }
        }
    }
    
    class func createWithFrame(_ frame: CGRect) -> PlanDisplayTableView {
        let table = PlanDisplayTableView(frame: frame, style: .plain)
        
        let plans = NSKeyedUnarchiver.unarchiveObject(withFile: planPath) as? [PlanModel]
        table.plans = plans ?? [PlanModel]()
        table.currentPlans = table.getPlansForDate(Date())
        
        table.dataSource = table
        table.delegate = table
        
        // UI
        table.tableFooterView = UIView(frame: CGRect.zero)
        
        // separator line
        if table.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            table.separatorInset = UIEdgeInsets.zero
        }
        if table.responds(to: #selector(setter: UIView.layoutMargins)) {
            table.layoutMargins = UIEdgeInsets.zero
        }
        
        return table
    }
    
    fileprivate func getPlansForDate(_ date: Date) -> [PlanModel] {
        var chosenPlans = [PlanModel]()
        let weekIndex = CalendarCenter.getWeekIndexOfDate(date)
        
        for plan in plans {
            if plan.chosenWeeks.contains(weekIndex) {
                chosenPlans.append(plan)
            }
        }
        
        return chosenPlans
    }
    
    // MARK: -------------------------- dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // no plans, or show the whole calendar
        if currentPlans.count == 0 || showAll {
            return 2
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // no plans, go to add
        if currentPlans.count == 0 {
            return 1
        }
        
        // has plans
        if section == 1 {
            return currentPlans.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let calendarCell = PlanCalendarCell.cellWithTableView(tableView, coreDay: Date(), showAll: showAll)
            calendarCell.calendar.hostTable = self

            return calendarCell
        }else if indexPath.section == 1 {
            if currentPlans.count == 0 {
                let cell = PlanAddCell.cellWithTableView(tableView)
                cell.hostTable = self
                
                return cell
            }
            
            // has plans
            let plan = currentPlans[indexPath.row]
            let checked = plan.isRemindedForDate(currentDate)
            
            if showAll {
                return PlanSimpleCell.cellWithTableView(tableView, text: plan.text, checked: checked)
            } else {
                return PlanDisplayCell.cellWithTableView(tableView, image: plan.image, text: plan.text, checked: checked)
            }
            
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "21 days")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "21 days")
                cell!.accessoryType = .disclosureIndicator
                cell!.contentView.backgroundColor = UIColor.clear
                cell!.backgroundColor = UIColorFromRGB(245, green: 255, blue: 234)
                cell!.selectionStyle = .none
            }
        
            cell!.textLabel?.text = "21 days plan"
            
            return cell!
        }
    }
    
    // header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0  {
            return UIView(frame: CGRect.zero)
        }
        
        // lineView
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 1))
        lineView.backgroundColor = UIColorGray(216)
        
        if showAll || currentPlans.count == 0{
            return lineView
        }
        
        // text
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: bounds.width, height: 39))
        let header = UIView(frame: CGRect.zero)
        
        label.text = section == 1 ? "Today" : "This Month"
        label.font = UIFont.systemFont(ofSize: 14)
        
        header.addSubview(label)
        header.addSubview(lineView)
        
        return header
    }
    
    // MARK: -------------------------- delegate
    // heights
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cWidth = bounds.width / 7
        let calenderHeight = showAll ? cWidth * 6.26 : cWidth * 2.26
        
        // calendar
        if indexPath.section == 0 {
            return calenderHeight
        }
        
        if currentPlans.count == 0 {
            return bounds.height - calenderHeight
        }
        
        if indexPath.section == 1 {
            return showAll ? 44 : 75
        } else {
            return 52
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        
        // a line
        if showAll || currentPlans.count == 0 {
            return 1
        }
        
        return 39
    }
   
    // selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // plan option
        if indexPath.section == 1 && currentPlans.count != 0 {
            // set option
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let opitonsVC = storyboard.instantiateViewController(withIdentifier: plansOptionsStoryboardID) as! PlansOptionsTableViewController
            opitonsVC.plan = currentPlans[indexPath.row]
            opitonsVC.tableDelegate = self
            
            hostVC.navigationController?.pushViewController(opitonsVC, animated: true)
        }else if indexPath.section == 2 {
            // 21 days plan
            let plansVC = MonthPlansTableViewController()
            hostVC.navigationController?.pushViewController(plansVC, animated: true)
        }
        
    }
    
    // delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete{
            let plan = currentPlans[indexPath.row]
            currentPlans.remove(at: indexPath.row)
            
            // data base
            plan.chosenWeeks.remove(CalendarCenter.getWeekIndexOfDate(currentDate))
            plan.remindedWeeks.remove(CalendarCenter.getWeekIndexOfDate(currentDate))
            NSKeyedArchiver.archiveRootObject(plans, toFile: planPath)
            
            if numberOfRows(inSection: 1) > 1 {
                deleteRows(at: [indexPath], with: .fade)
            } else {
                reloadData()
            }
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete Plan"
    }
    
    // UI
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
}
