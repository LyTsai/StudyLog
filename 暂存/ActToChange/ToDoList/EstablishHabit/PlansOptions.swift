//
//  PlansOptions.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let plansOptionsStoryboardID = "plans options"

class PlansOptionsTableViewController: UITableViewController {
    
    @IBOutlet var weeks: [UIButton]!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bellNameLabel: UILabel!
    @IBOutlet weak var planTextField: UITextField!
    
    var plan: PlanModel!
    
    weak var tableDelegate: PlanDisplayTableView!
    weak var dailyTable: ReminderTableView!

    var reminderTime: Date! {
        didSet{
            if reminderTime != oldValue {
                if reminderTime != nil {
                    let format = DateFormatter()
                    format.dateFormat = "HH:mm"
                    timeLabel.text = format.string(from: reminderTime)
                }else {
                    timeLabel.text = "not set"
                }
            }
        }
    }
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = ""
        
        let rightBarItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addweeks))
        navigationItem.rightBarButtonItem = rightBarItem
        
        planTextField.placeholder = "\(plan.reminderText ?? plan.text ?? "Add Reminder Name")"
    
        reminderTime = plan.reminderTime
        
        for (i, week) in weeks.enumerated() {
            week.isSelected = plan.isRemindedForWeek(i)
            week.tag = 100 + i
            week.setBackgroundImage(UIImage(named: "week_selected"), for: .selected)
            week.addTarget(self, action: #selector(weekTouched(_:)), for: .touchUpInside)
        }
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Plans Options"
    }
    
    // MARK: -------------- actions -----------
    func weekTouched(_ button: UIButton)  {
        button.isSelected = !button.isSelected
    }
    
    @IBAction func changeVolume(_ sender: UISlider) {
        print(sender.value)
    }
    
    
    // add plan
    func addweeks() {
        // reminder weeks
        plan.remindedWeeks.removeAllObjects()
        for week in weeks {
            if week.isSelected {
                let weekIndex = week.tag - 100
                plan.chosenWeeks.add(weekIndex)
                plan.remindedWeeks.add(weekIndex)
            }
        }
    
        // reminder title
        if planTextField.text != "" && planTextField.text != nil {
            plan.reminderText = planTextField.text
        }else {
            plan.reminderText = planTextField.placeholder
        }
        
        // reminder time
        plan.reminderTime = reminderTime
        
        // bell
        
        // voice
        
        // save data
        if tableDelegate != nil {
            // do impactful
            NSKeyedArchiver.archiveRootObject(tableDelegate.plans, toFile: planPath)
            tableDelegate.updateData()
        
        } else if dailyTable != nil {
            // do esay
            NSKeyedArchiver.archiveRootObject(dailyTable.hostVC.plans, toFile: easyPlanPath)
            dailyTable.hostVC.updateData()
        }
        
        // VC
        navigationController!.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let timePickerVC = TimePickerViewController()
            timePickerVC.lastDate = reminderTime ?? Date()
            timePickerVC.hostTable = self
            
            navigationController?.pushViewController(timePickerVC, animated: true)
        }
    }
}

