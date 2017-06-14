//
//  ReminderCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/5.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let reminderCellID = "reminder cell identifier"
class ReminderCell: UITableViewCell {
    weak var hostTable: ReminderTableView!
    
    // TODO: ------ or time string, if got from plan options
    var timeToRemind: Date! {
        didSet{
            if timeToRemind != oldValue {
                if timeToRemind == nil {
                    timeLabel.text = "NOT SET"
                }
                
                let format = DateFormatter()
                format.dateFormat = "HH:mm"
                let dateString = format.string(from: timeToRemind)
                timeLabel.text = dateString
            }
        }
    }
    var reminderText = "Reminder" {
        didSet{
            if reminderText != oldValue {
                reminderTextLabel.text = reminderText
            }
        }
    }

    var isOn = true {
        didSet{
            if isOn != oldValue {
                reminderSwitch.isOn = isOn
                inactiveMask.isHidden = isOn
            }
        }
    }

    fileprivate let timeLabel = UILabel()
    fileprivate let reminderTextLabel = UILabel()
    fileprivate let reminderSwitch = UISwitch()
    fileprivate let inactiveMask = UIView()
    fileprivate var row: Int!
    
    class func cellWithTableView(_ tableView: UITableView, row: Int, time: Date?, text: String?, isOn: Bool) -> ReminderCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reminderCellID) as? ReminderCell
        
        if cell == nil {
            cell = ReminderCell(style: .default, reuseIdentifier: reminderCellID)
            cell!.updateUI()
        }
        cell!.timeToRemind = time
        cell!.reminderText = text ?? "Daily Reminder"
        cell!.isOn = isOn
        cell!.row = row
        
        return cell!
    }
    
    fileprivate func updateUI() {
        timeLabel.text = "Not Set"
        reminderTextLabel.text = reminderText
        
        reminderSwitch.isOn = true
        reminderSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
        
        inactiveMask.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        inactiveMask.isHidden = true
        
        selectionStyle = .none
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(reminderTextLabel)
        contentView.addSubview(reminderSwitch)
        contentView.addSubview(inactiveMask)
    }
    
    func changeSwitch()  {
        isOn = !isOn
        
        hostTable.saveRemind(row, state: isOn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hMargin = 15 * bounds.width / 375
        let vMargin = 5 * bounds.height / 90
        
        let switchFrame = CGRect(center: CGPoint(x: bounds.width - hMargin - 25,y: bounds.midY), width: 51, height: 31)
        let timeFrame = CGRect(x: hMargin, y: vMargin, width: switchFrame.minX - hMargin, height: bounds.height * 0.67)
        let reminderTextFrame = CGRect(x: hMargin, y: timeFrame.maxY, width: switchFrame.minX - hMargin, height: bounds.height - 2 * vMargin - timeFrame.height)
        
        timeLabel.frame = timeFrame
        reminderTextLabel.frame = reminderTextFrame
        reminderSwitch.frame = switchFrame
        inactiveMask.frame = CGRect(x: 0, y: 0, width: switchFrame.minX, height: bounds.height)
        
        timeLabel.font = UIFont.systemFont(ofSize: timeFrame.height * 0.9, weight: UIFontWeightThin)
        reminderTextLabel.font = UIFont.systemFont(ofSize: reminderTextFrame.height * 0.6)
    }
}
