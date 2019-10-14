//
//  StrengthInputViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/3.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class StrengthInputViewController: UIViewController, UITextFieldDelegate {
    weak var strengthCardView: StrengthInputCardTemplateView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var inputTextFields: [UITextField]!
    
    @IBOutlet var indexLabels: [UILabel]!
    
    @IBOutlet weak var leftButton: GradientBackStrokeButton!
    @IBOutlet weak var rightButton: GradientBackStrokeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        
        for label in indexLabels {
            label.layer.borderWidth = fontFactor
            label.layer.cornerRadius = fontFactor * 4
            label.font = UIFont.systemFont(ofSize: 20 * fontFactor)
        }
        
        for (i, textField) in inputTextFields.enumerated() {
            textField.delegate = self
            textField.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
            let rightView = UILabel(frame: CGRect(x: 0, y: 0, width: 20 * fontFactor, height: 35 * fontFactor))
            rightView.text = "kg"
            rightView.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .light)
            textField.rightView = rightView
            textField.rightViewMode = .always
            
            if i != 0 {
                textField.isUserInteractionEnabled = false
            }
        }
        
        leftButton.setupWithTitle("Skip")
        leftButton.isSelected = false
        rightButton.setupWithTitle("Average measure")
    }
    
    fileprivate func setupState(_ currentIndex: Int) {
        for i in 0..<3 {
            let label = indexLabels[i]
            let isCurrent = (i == currentIndex)
            
            let grayColor = UIColorGray(153)
            let chosenColor = UIColorFromHex(0x50D387)
            
            label.textColor = isCurrent ? chosenColor : grayColor
            label.layer.borderColor = label.textColor.cgColor
            label.backgroundColor = isCurrent ? UIColorFromHex(0xEAFFF3) : UIColor.clear
            
            if i != 2 {
                inputTextFields[i + 1].isUserInteractionEnabled = true
            }
        }
    }
    
    // delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setupState(textField.tag - 100)
    }
    
    // actions
    @IBAction func leftButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightButtonTouched(_ sender: Any) {
        var average: Float = 0
        for textField in inputTextFields {
            average += Float(textField.text ?? "") ?? 0
        }
        average /= 3
        
        dismiss(animated: true) {
            if self.strengthCardView != nil {
                // card
                self.strengthCardView.saveWithAverage(average)
            }
        }
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
