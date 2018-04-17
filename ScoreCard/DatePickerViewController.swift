//
//  DatePickerViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/31.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class DatePickerViewController: UIViewController {
    weak var presentFrom: ScoreCardViewController!
    var recordYear: Int = 0 {
        didSet{
            chosenYear = recordYear
            pickerView.selectRow(rowOfYear(recordYear), inComponent: 0, animated: true)
        }
    }
    fileprivate var chosenYear = 0
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        titleLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFontWeightBold)
        let buttonFont = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFontWeightBold)
        finishButton.titleLabel?.font = buttonFont
        cancelButton.titleLabel?.font = buttonFont
        backView.layer.cornerRadius = 8 * fontFactor
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func goBackToChange() {
        dismiss(animated: true) {
            self.presentFrom.chooseBirthYear(self.chosenYear)
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
        if self.chosenYear != self.recordYear {
            let alert = UIAlertController(title: nil, message: "You have made a change, do you want to save the date for future games", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Fine", style: .default) { (true) in
                // load
                self.updateDate()
            }
            
            let refuse = UIAlertAction(title: "No, thanks.", style: .cancel) { (true) in
                self.goBackToChange()
            }
            
            alert.addAction(refuse)
            alert.addAction(ok)

            present(alert, animated: true, completion: nil)
        }else {
            self.goBackToChange()
        }
    }
    
    fileprivate func updateDate() {
        // age
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        var dobComponents = DateComponents()
        dobComponents.year = chosenYear
        dobComponents.month = components.month
        dobComponents.day = components.day
        let dateOfBirth = calendar.date(from: dobComponents)
        let dobString = ISO8601DateFormatter().string(from: dateOfBirth!)
        
        // load
        let currentUser = userCenter.currentGameTargetUser
        currentUser.userInfo().dobString = dobString
        
        if currentUser.Key() == userCenter.loginUserObj.key {
            if self.userAccess == nil {
                let loginUser = userCenter.loginUserObj
                loginUser.dobString = dobString
                
                self.userAccess = UserAccess(callback: self)
                userAccess.updateOneByKey(key: loginUser.key, oneData: loginUser)
            }
        }else {
            goBackToChange()
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
        let font = UIFont.systemFont(ofSize: pickerView.bounds.height / 5 * 0.4, weight: UIFontWeightBold)
        return NSAttributedString(string: "\(yearOfRow(row))", attributes: [NSFontAttributeName: font])
    }
}

// delegate
extension DatePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenYear = yearOfRow(row)
    }
}

// userAcess
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

