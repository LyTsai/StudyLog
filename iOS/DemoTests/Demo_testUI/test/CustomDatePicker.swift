//
//  CustomDatePicker.swift
//  Demo_testUI
//
//  Created by L on 2020/8/21.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation

class CustomDatePicker: UIPickerView {
    var currentValue: Int {
        var value = selectedRow(inComponent: 0)
        switch datePickerMode {
        case .countDownTimer:
            value = value * 60 + selectedRow(inComponent: 2)
        default:
            // hour
            value += 1
            
            let isAM = selectedRow(inComponent: 2) == 0
            if value == 12 {
                if isAM {
                    // AM
                    value = 0
                }
            }else {
                // other, PM
                if !isAM {
                    value += 12 * 60
                }
            }
            
            // real
            value = value * 60 + selectedRow(inComponent: 1)
        }
        
        return value
    }
    
    var datePickerMode = UIDatePicker.Mode.countDownTimer {
        didSet {
            if datePickerMode != oldValue {
                self.reloadAllComponents()
            }
        }
    }
    
    var rowsOnDisplay = 3 {
        didSet {
            if rowsOnDisplay != oldValue {
                self.reloadAllComponents()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        self.dataSource = self
        self.delegate = self
    }
    
    func setCurrentValue(_ value: Int) {
        let hour = value / 60
        let minute = value % 60
        
        // value
        if self.datePickerMode == .time {
            var displayRow = (hour > 12 ? hour - 12 : hour) - 1
            if hour == 0 {
                displayRow = 11
            }
            // set rows
            self.selectRow(displayRow, inComponent: 0, animated: true)
            self.selectRow(minute, inComponent: 1, animated: true)
            // >= 12 PM
            self.selectRow((hour < 12) ? 0 : 1, inComponent: 2, animated: true)
        }else {
            self.selectRow(hour, inComponent: 0, animated: true)
            self.selectRow(minute, inComponent: 3, animated: true)
        }
    }
    
    
    func getTimeDisplayString() -> String {
        var hour = currentValue / 60
        let minute = currentValue % 60
        // special
//        if minute == 0 {
//            if hour == 24 {
//                return "Midnight"
//            }
//        }

        // normal
        let timeTag = hour >= 12 ? "P" : "A"
        hour = hour > 12 ? hour - 12 : hour
        if hour == 0 {
            hour += 12
        }

        return String(format: "%02d:%02d\(timeTag)M",hour, minute)
    }
}

extension CustomDatePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    // data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch datePickerMode {
        case .countDownTimer:  return 4
        default: return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch datePickerMode {
        case .countDownTimer:
            if component == 0 {
                return 24
            }else if component == 2 {
                return 60
            }else {
                return 1
            }
        default:
            if component == 0 {
                return 12
            }else if component == 1 {
                return 60
            }else {
                return 2
            }
        }
    }
    
    fileprivate func getTitleForRow(_ row: Int, forComponent component: Int) -> String {
        switch datePickerMode {
        case .countDownTimer:
            if component == 1 {
                return "hours"
            }else if component == 3 {
                return "min"
            }else {
               return "\(row)"
            }
        default:
            if component == 0 {
                return "\(row + 1)"
            }else if component == 1 {
                return String(format: "%02d", row)
            }else {
                return row == 0 ? "AM" : "PM"
            }
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return getTitleForRow(row, forComponent: component)
//    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return bounds.width / CGFloat(numberOfComponents(in: pickerView))
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return bounds.height / CGFloat(rowsOnDisplay)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        let title = getTitleForRow(row, forComponent: component)
        let attri = NSAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: bounds.height / CGFloat(rowsOnDisplay) * 0.6, weight: .medium)])
        
        titleLabel.attributedText = attri
        
        return titleLabel
    }

//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let title = getTitleForRow(row, forComponent: component)
//        return NSAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: bounds.height / 3, weight: .medium)])
//    }
}
