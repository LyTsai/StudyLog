//
//  UserSelectCardTemplateView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/6.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class UserSelectCardTemplateView: JudgementCardTemplateView {
    override func key() -> String {
        return UserSelectCardTemplateView.styleKey()
    }
    
    override class func styleKey() -> String {
        return "d65f379a-4600-4468-af70-964be389e995"
    }
    
    // MARK: ----- init -------
    // for some extension, like change the buttons
    let picker = UIPickerView()
    
    override func addBackAndUpdateUI() {
        super.addBackAndUpdateUI()
        
        // buttons
        leftButton.setupWithTitle("I don't know")
        rightButton.setupWithTitle("OK")
        
        descriptionView.mainImageView.isHidden = true
        
        addSubview(picker)
        picker.dataSource = self
        picker.delegate = self
    }
    
    
    override func setUIForSelection(_ answer: Int?) {
        super.setUIForSelection(answer)
        
        leftButton.isSelected = false
        rightButton.isSelected = false
        descriptionView.isChosen = true
        if let input = vCard.currentInput() {
            number = input
        }
    }
    
    override func beginToShow() {
        super.beginToShow()
        
        picker.selectRow(Int(number - 1), inComponent: 0, animated: true)
    }
    
    // MARK: ---------- layout of subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        picker.frame = descriptionView.mainImageView.frame
    }
    
 
    // data
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        
        if let match = defaultSelection?.match {
            // any detail?
            descriptionView.detail = card.title
            descriptionView.title = match.name
        }
    }
    
    fileprivate var number: Float = 1
    override func rightButtonClicked() {
        vCard.saveInput(number, matchKey: option.matchKey, refValue: nil)
        
        leftButton.isSelected = false
        rightButton.isSelected = false
        descriptionView.isChosen = true
        
        if actionDelegate != nil {
            actionDelegate.card?(self, chooseItemAt: 1)
        }
    }
    
}


extension UserSelectCardTemplateView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 24 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(row + 1)" : "Hour"
    }
}

// delegate
extension UserSelectCardTemplateView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let pickerWidth = picker.bounds.width
        return component == 0 ? pickerWidth * 0.65 : pickerWidth * 0.35
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.height / 5
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let font = UIFont.systemFont(ofSize: 24 * fontFactor, weight: .medium)
        return component == 0  ? NSAttributedString(string: "\(row + 1)", attributes: [ .font: font]) : NSAttributedString(string: "Hour", attributes: [ .font: UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium), .foregroundColor: UIColorFromHex(0xFFAE00)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        number = Float(row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.attributedText = self.pickerView(pickerView, attributedTitleForRow: row, forComponent: component)
        if component == 1 {
            pickerLabel.textAlignment = .left
        }else {
            pickerLabel.textAlignment = .center
        }
        
        return pickerLabel
    }
}

