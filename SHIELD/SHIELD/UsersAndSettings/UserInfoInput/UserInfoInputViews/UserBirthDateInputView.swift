//
//  UserBirthDateInputView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/16.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class UserBirthDateInputView: DashBorderView {
    var dobString: String {
        let calendar = Calendar.current
        var dobComponents = DateComponents()
        dobComponents.year = yearPicker.chosenNumber
        let dateOfBirth = calendar.date(from: dobComponents)
        
        return ISO8601DateFormatter().string(from: dateOfBirth!)
    }
    
    fileprivate let yearPicker = NumberPickerView()
    func setDateOfBirth(_ dob: String) {
        let date = CalendarCenter.getDateFromString(dob) ?? Date()
        yearPicker.setChosenNumber(CalendarCenter.getYearOfDate(date))
    }
    
    override func addBasicViews() {
        super.addBasicViews()
        
        let currentYear = CalendarCenter.getYearOfDate(Date())
        yearPicker.maxNumber = currentYear
        yearPicker.minNumber = currentYear - 100
        yearPicker.setChosenNumber(currentYear)
        
        addSubview(yearPicker)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        yearPicker.frame = bounds.insetBy(dx: bounds.width * 0.15, dy: bounds.height * 0.1)
    }
}
