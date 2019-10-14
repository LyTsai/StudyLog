//
//  YearPickerView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/16.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class NumberPickerView: UIPickerView {
    var chosenYear = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupBasic() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    
    fileprivate func yearOfRow(_ row: Int) -> Int {
        return row - maxAge + maxYear + 1
    }
    fileprivate func rowOfYear(_ year: Int) -> Int {
        let row = year + maxAge - maxYear - 1
        return min(max(row, 0), maxAge - 1)
    }
    
    fileprivate func makeChange() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        var dobComponents = DateComponents()
        dobComponents.year = chosenYear
        dobComponents.month = components.month
        dobComponents.day = components.day
        let dateOfBirth = calendar.date(from: dobComponents)
        let dobString = ISO8601DateFormatter().string(from: dateOfBirth!)
        
        if userKey == userCenter.loginUserObj.key {
            let loginUser = userCenter.loginUserObj
            loginUser.dobString = dobString
        }else {
            // pseudoUser
            if let pseudoUser = userCenter.getPseudoUser(userKey) {
                pseudoUser.dobString = dobString
            }
        }
    }

}

// data source
extension DatePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxAge
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.height / 5
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let font = UIFont.systemFont(ofSize: 20 * fontFactor, weight: UIFont.Weight.bold)
        return NSAttributedString(string: "\(yearOfRow(row))", attributes: [NSAttributedStringKey.font: font])
    }
}

// delegate
extension DatePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenYear = yearOfRow(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.attributedText = self.pickerView(pickerView, attributedTitleForRow: row, forComponent: component)
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }
}

