//
//  PickWeightViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/15.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class PickWeightViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var weightPickerView: UIPickerView!
    
    @IBOutlet weak var lbsButton: UIButton!
    @IBOutlet weak var kiloButton: UIButton!
    
    @IBOutlet weak var calculationButton: UIButton!
//    fileprivate var weight:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fonts
        titleLabel.font = UIFont.systemFont(ofSize: 22 * fontFactor, weight: .medium)
        promptLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor)
        lbsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        kiloButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        calculationButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calculate(_ sender: Any) {
    }
    
    
}

// data source
extension PickWeightViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 999
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 51 * fontFactor
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let font = UIFont.systemFont(ofSize: 40 * fontFactor, weight: .light)
        return NSAttributedString(string: "\(row + 1)", attributes: [ .font: font])
    }
}

// delegate
extension PickWeightViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.attributedText = self.pickerView(pickerView, attributedTitleForRow: row, forComponent: component)
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }
}
