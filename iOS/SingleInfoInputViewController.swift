//
//  SingleInfoInputViewController.swift
//  BeautiPhi
//
//  Created by L on 2019/9/2.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

class SingleInfoInputViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var rightView: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var rightButton: CustomColorButton!
    
    class func createFromNib()-> SingleInfoInputViewController {
        return Bundle.main.loadNibNamed("SingleInfoInputViewController", owner: self, options: nil)?.first as! SingleInfoInputViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        backView.layer.cornerRadius = 6 * fontFactor
        inputTextField.delegate = self
        
        titleLabel.font = UIFont.systemFont(ofSize: 22 * fontFactor, weight: .medium)
        
        inputTextField.clearButtonMode = .always
        inputTextField.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        
        rightView.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: .semibold)
        
        rightButton.isSelected = true
        
//        rightView.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismiss(animated: true, completion: nil)
    }
    
//    fileprivate var confirmWithInput: (()->Void)?
//    func setForNumberInputWithTitle(_ title: String?, input: Float?, confirmAction: ((Float)->Void)?) {
//        rightView.text = ""
//        titleLabel.text = title
//        if input == nil {
//            inputTextField.text = title
//        }else {
//            inputTextField.text = String(format: "%.1f", input!)
//        }
//        inputTextField.keyboardType = .numberPad
//        confirmWithInput = {
//            let input = Float(self.inputTextField.text ?? "0") ?? 0
//            confirmAction?(input)
//        }
//    }
//
//    func setForPercentInputWithTitle(_ title: String?, input: Float?, confirmAction: ((Float)->Void)?) {
//        rightView.text = "%"
//        titleLabel.text = title
//        if input == nil {
//            inputTextField.text = title
//        }else {
//            inputTextField.text = String(format: "%.1f", input! * 100)
//        }
//
//        inputTextField.keyboardType = .numberPad
//        confirmWithInput = {
//            let input = Float(self.inputTextField.text ?? "0") ?? 0
//            confirmAction?(input / 100)
//        }
//    }
    
    fileprivate var confirmIsTouched: ((String) -> Void)?
    func setForEmailInput(_ email: String?, confirmAction: ((String)->Void)?) {
        titleLabel.text = "Email Address"
        inputTextField.text = email ?? "example@address"
        inputTextField.keyboardType = .emailAddress
        rightView.text = ""
        
        self.confirmIsTouched = confirmAction
        
//        confirmWithInput = {
//            let input = self.inputTextField.text ?? ""
//            if !input.isEmailAddress() {
//                self.showAlertMessage("Check and Input again", title: "Invaild Email Address", buttons: [("Got It", nil)])
//            }else {
//                confirmAction?(input)
//            }
//        }
    }
    
    // delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rightButtonIsTouched(rightButton!)
        return true
    }
    
    @IBAction func leftButtonIsTouched(_ sender: Any) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func rightButtonIsTouched(_ sender: Any) {
        self.view.endEditing(true)
        
        let input = self.inputTextField.text ?? ""
        if !input.isEmailAddress() {
           self.showAlertMessage("Check and Input again", title: "Invaild Email Address", buttons: [("Got It", nil)])
        }else {
            dismiss(animated: true) {
                self.confirmIsTouched?(input)
            }
        }
    }
}
