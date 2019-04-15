//
//  LoginUserAgeInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/5.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class LoginUserAgeInputView: DashBorderView, UITextFieldDelegate {
    var userAge: Int {
        return value
    }
    
    // create
    var minNumber: Int = 0
    var maxNumber: Int = 100
   
    fileprivate let slider = CustomSlider()
    fileprivate let displayTextField = UITextField()
    fileprivate let hintLabel = UILabel()
    fileprivate let stateImageView = UIImageView(image: ProjectImages.sharedImage.roundCheck)
    fileprivate let minLabel = UILabel()
    fileprivate let maxLabel = UILabel()
    
    fileprivate var value: Int = 0 {
        didSet{
            displayTextField.text = "\(value)"
            
            // set up
            let baseColor = (value == 0) ? textTintGray : tabTintGreen
            displayTextField.layer.borderColor = baseColor.cgColor
            displayTextField.textColor = baseColor
            stateImageView.isHidden = (value == 0)
        }
    }
    
    override func addBasicViews() {
        super.addBasicViews()
    
        // detail views
        displayTextField.textAlignment = .center
        displayTextField.layer.borderWidth = fontFactor
        displayTextField.layer.borderColor = textTintGray.cgColor
        displayTextField.textColor = textTintGray
        displayTextField.text = "0"
        stateImageView.isHidden = true
        
        hintLabel.text = "Or Input"
        hintLabel.textAlignment = .center
        hintLabel.textColor = UIColorGray(155)
        
        // slider
        slider.thumbImage = UIImage(named: "sliderMiddle")
        slider.leftTrackImage = UIImage(named: "sliderMin")
        slider.rightTrackImage = UIImage(named: "sliderMax")
        slider.addTarget(self, action: #selector(slideToChoose), for: .valueChanged)
        slider.minimumValue = Float(minNumber)
        slider.maximumValue = Float(maxNumber)
        maxLabel.textAlignment = .right
        minLabel.text = "\(minNumber)"
        maxLabel.text = "\(maxNumber)"
        
        // add subviews
        addSubview(displayTextField)
        addSubview(hintLabel)
        addSubview(stateImageView)
        addSubview(slider)
        addSubview(minLabel)
        addSubview(maxLabel)
    }
    
    func setAge(_ age: Int) {
        value = age
        slider.value = Float(age)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // label part
        let displayLength = min((bounds.height) * 0.6, bounds.width * 0.6)
        let labelFrame = CGRect(center: CGPoint(x: bounds.midX, y: displayLength * 0.5 + 15 * fontFactor), length: displayLength)
        displayTextField.frame = labelFrame
        displayTextField.keyboardType = .numberPad
        displayTextField.layer.cornerRadius = displayLength * 0.5
        displayTextField.font = UIFont.systemFont(ofSize: displayLength * 0.5, weight: UIFont.Weight.ultraLight)
        displayTextField.clearButtonMode = .whileEditing
        displayTextField.delegate = self
        
        hintLabel.frame = CGRect(center: CGPoint(x: bounds.midX, y: labelFrame.maxY - displayLength * 0.2), width: displayLength * 0.5, height: displayLength * 0.15)
        hintLabel.font = UIFont.systemFont(ofSize: displayLength * 0.08)
        
        let stateLength = 25 * fontFactor
        stateImageView.frame = CGRect(x: labelFrame.maxX - stateLength, y: labelFrame.maxY - stateLength, width: stateLength, height: stateLength)
        
        // slider part
        let sliderFrame = CGRect(x: bounds.width * 0.1, y: labelFrame.maxY + 10 * fontFactor, width: bounds.width * 0.8, height: 50 * fontFactor)
        slider.frame = sliderFrame
        
        minLabel.frame = CGRect(x: sliderFrame.minX + 2 * fontFactor, y: sliderFrame.maxY, width: 30 * fontFactor, height: 18 * fontFactor)
        maxLabel.frame = CGRect(x: sliderFrame.maxX - 30 * fontFactor, y: sliderFrame.maxY, width: 30 * fontFactor, height: 18 * fontFactor)
        minLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor)
        maxLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor)
        
    }
    
    // actions
    @objc func slideToChoose() {
        value = Int(slider.value)
    }
    
    func setByInput()  {
        if displayTextField.text == nil {
            value = 0
        }else {
            value = min(Int((displayTextField.text!)) ?? 0, maxNumber)
        }
        
        slider.value = Float(value)
    }
    
  
    // keyboard
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let aString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            let expression = "^(0|[1-9][0-9]*)$" // fromYu: /^\+?(0|[1-9][0-9]*)$
//        let regex = try! NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
//        let numberOfMatches = regex.numberOfMatches(in: aString, options:.reportProgress, range: NSMakeRange(0, (aString as NSString).length))
//        return numberOfMatches != 0
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayTextField.endEditing(true)
        setByInput()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setByInput()
        return true
    }
    
}
