//
//  FRDosageInputViewController.swift
//  BeautiPhi
//
//  Created by L on 2019/11/18.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

class FRDosageInputViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var rightView: UILabel!
    
    @IBOutlet weak var rightButton: CustomColorButton!
    
    class func createFromNib()-> FRDosageInputViewController {
        return Bundle.main.loadNibNamed("FRDosageInputViewController", owner: self, options: nil)?.first as! FRDosageInputViewController
    }
    
    fileprivate let typeBackLayer = CAGradientLayer()
    fileprivate let typeShape = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont.systemFont(ofSize: 24 * fontFactor, weight: .semibold)
        
        backView.layer.cornerRadius = 6 * fontFactor
        backView.layer.borderColor = UIColorFromHex(0x7ED321).cgColor
        backView.layer.borderWidth = 5 * fontFactor
        
        inputBackView.layer.cornerRadius = 2 * fontFactor
        inputBackView.layer.borderColor = UIColorFromHex(0x39B54A).cgColor
        inputBackView.layer.borderWidth = 2 * fontFactor
      
        inputTextField.delegate = self
        inputTextField.font = UIFont.systemFont(ofSize: 24 * fontFactor, weight: .medium)
        rightView.font = UIFont.systemFont(ofSize: 24 * fontFactor, weight: .medium)
        rightView.layer.masksToBounds = true
       
        rightButton.isSelected = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backView.layoutIfNeeded()
        rightView.layer.cornerRadius = rightView.frame.height * 0.5
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    fileprivate var confirmWithInput: (()->Void)?
    func setWithDose(_ dose: Float?, target: Float, confirmAction: ((Float)->Void)?) {
        if dose == nil {
            inputTextField.text = "0"
        }else {
            inputTextField.text = String(format: "%.f", dose! / target * 100)
        }
        
        confirmWithInput = {
            let input = max(Float(self.inputTextField.text ?? "0") ?? 0, 0) / 100 * target
            confirmAction?(input)
        }
    }
    
    // delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismiss(animated: true) {
            self.confirmWithInput?()
        }
        return true
    }
    
 
    @IBAction func leftButtonIsTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func rightButtonIsTouched(_ sender: Any) {
        dismiss(animated: true) {
            self.confirmWithInput?()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

