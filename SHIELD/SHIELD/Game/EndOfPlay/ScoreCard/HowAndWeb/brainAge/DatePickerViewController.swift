//
//  DatePickerViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/31.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class DatePickerViewController: UIViewController {
    weak var getBrainAge: GetBrainAgeView!
    var recordYear: Int = 0 {
        didSet{
            chosenYear = recordYear
            pickerView.selectRow(rowOfYear(recordYear), inComponent: 0, animated: true)
        }
    }
    
    var userKey: String!
    
    fileprivate var chosenYear = 0
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishButton: GradientBackStrokeButton!
    @IBOutlet weak var cancelButton: GradientBackStrokeButton!
    
    // if change and save
    fileprivate var userAccess: UserAccess!
    
    fileprivate var maxYear: Int {
         return CalendarCenter.getYearOfDate(Date())
    }
    
    fileprivate let maxAge = 120
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chosenYear = recordYear
        
        // basic ui
        titleLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: .bold)
        finishButton.setupWithTitle("Finish")
        cancelButton.setupWithTitle("Cancel")
        
        finishButton.isSelected = false
        cancelButton.isSelected = false
        
        backView.layer.cornerRadius = 8 * fontFactor
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    fileprivate func goBackToChange() {
        userDefaults.set(true, forKey: ageLoadedKey)
        userDefaults.synchronize()
        dismiss(animated: true) {
            self.getBrainAge.ageIsChanged()
        }
    }
    
    fileprivate func yearOfRow(_ row: Int) -> Int {
        return row - maxAge + maxYear + 1
    }
    fileprivate func rowOfYear(_ year: Int) -> Int {
        let row = year + maxAge - maxYear - 1
        return min(max(row, 0), maxAge - 1)
    }
    
    // actions
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickFinished(_ sender: Any) {
        if chosenYear != recordYear {
            // change data of user object
            // alert to remind
            let alert = UIAlertController(title: nil, message: "You have made a change, do you want to save the date for future games", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Save", style: .default) { (true) in
                self.makeChange()
                // load
                self.updateDate()
            }
            
            let refuse = UIAlertAction(title: "Only this time.", style: .default) { (true) in
                self.makeChange()
                self.goBackToChange()
            }
            let cancel = UIAlertAction(title: "Select again.", style: .cancel) { (true) in
                
            }
            
            alert.addAction(refuse)
            alert.addAction(ok)
            alert.addAction(cancel)

            present(alert, animated: true, completion: nil)
        }else {
            self.goBackToChange()
        }
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
    
    fileprivate func updateDate() {
        // load
        if userKey == userCenter.loginUserObj.key {
            if self.userAccess == nil {
                self.userAccess = UserAccess(callback: self)
            }
            
            let loginUser = userCenter.loginUserObj
            userAccess.updateOneByKey(key: loginUser.key, oneData: loginUser)
        }else {
             // pseudoUser
            if let _ = userCenter.getPseudoUser(userKey) {
                goBackToChange()
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
        let font = UIFont.systemFont(ofSize: 20 * fontFactor, weight: .bold)
        return NSAttributedString(string: "\(yearOfRow(row))", attributes: [ .font: font])
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

// userAccess
extension DatePickerViewController: DataAccessProtocal {
    func didFinishUpdateDataByKey(_ obj: AnyObject) {
        goBackToChange()
    }
    
    func failedUpdateDataByKey(_ error: String) {
        // alert to resave
        let alert = UIAlertController(title: nil, message: "Failed to change", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "retry", style: .default) { (true) in
            // load
            self.updateDate()
        }
        
        let refuse = UIAlertAction(title: "Change Later", style: .cancel) { (true) in
            self.goBackToChange()
        }
        
        alert.addAction(refuse)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
}

