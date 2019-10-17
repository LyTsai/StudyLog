//
//  NumberPickerView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/16.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class NumberPickerView: UIPickerView {
    var minNumber: Int = 0
    var maxNumber: Int = 0
    var rowNumberOnShow: Int = 5
    
    var chosenNumber: Int {
        return _chosenNumber
    }
    fileprivate var _chosenNumber: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        delegate = self
        dataSource = self
    }
    fileprivate var record: Int = 0
    func setChosenNumber(_ chosen: Int) {
        _chosenNumber = chosen
        record = chosen
        self.selectRow((chosen - minNumber), inComponent: 0, animated: true)
    }
}

extension NumberPickerView : UIPickerViewDataSource, UIPickerViewDelegate {
    // data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (maxNumber - minNumber) + 1
    }
    
    // delegate
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return bounds.height / CGFloat(rowNumberOnShow)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + minNumber)"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let number = row + minNumber
        let font = UIFont.systemFont(ofSize: bounds.height / CGFloat(rowNumberOnShow) * 0.55, weight: .light)
        var foregroundColor = UIColor.black
        
        if row == (record - minNumber) {
            foregroundColor = tabTintGreen
        }

        return NSAttributedString(string: "\(number)", attributes: [ .font: font, .foregroundColor : foregroundColor])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        for line in pickerView.subviews {
            if line.frame.height < 1 {
                line.backgroundColor = tabTintGreen
            }
        }
        
        let pickerLabel = UILabel()
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.attributedText = self.pickerView(pickerView, attributedTitleForRow: row, forComponent: component)
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _chosenNumber = row + minNumber
    }
}

