//
//  FRDiscountInputViewController.swift
//  BeautiPhi
//
//  Created by L on 2019/11/18.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

class FRDiscountInputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var typeHint: UILabel!
    @IBOutlet weak var rightView: UILabel!
   
    @IBOutlet weak var rightButton: CustomColorButton!
    
    class func createFromNib()-> FRDiscountInputViewController {
        return Bundle.main.loadNibNamed("FRDiscountInputViewController", owner: self, options: nil)?.first as! FRDiscountInputViewController
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
        inputBackView.layer.borderColor = UIColorFromHex(0xE67300).cgColor
        inputBackView.layer.borderWidth = 2 * fontFactor
        
        typeBackLayer.colors = [UIColorFromHex(0xF7981C).cgColor, UIColorFromHex(0xF76B1C).cgColor]
        typeBackLayer.locations = [0.01, 0.98]
        typeBackLayer.mask = typeShape
        backView.layer.insertSublayer(typeBackLayer, below: typeButton.layer)
     
        inputTextField.delegate = self
        inputTextField.font = UIFont.systemFont(ofSize: 24 * fontFactor, weight: .medium)
        rightView.font = UIFont.systemFont(ofSize: 24 * fontFactor, weight: .medium)
        rightView.layer.masksToBounds = true
        
        typeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        typeHint.font = UIFont.systemFont(ofSize: 12 * fontFactor)
        
        rightButton.isSelected = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backView.layoutIfNeeded()
        
        rightView.layer.cornerRadius = rightView.frame.height * 0.5
        typeBackLayer.frame = backView.bounds
        typeShape.path = UIBezierPath(roundedRect: typeButton.frame, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 2 * fontFactor, height: 2 * fontFactor)).cgPath
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate var confirmWithInput: (()->Void)?
    fileprivate var base: Float = 0
    func setWithDiscount(_ discount: Float?, base: Float, asDiscount: Bool, confirmAction: ((Float)->Void)?) {
        self.base = base
        typeButton.isSelected = !asDiscount
        setWithType()
        
        if asDiscount {
            if discount != nil {
                inputTextField.text = String(format: "%.f", discount! * 100)
            }else {
                inputTextField.text = "0"
            }
        }else {
            if discount != nil {
                inputTextField.text = String(format: "%.2f", base * (1 - discount!))
            }else {
                inputTextField.text = String(format: "%.2f", base)
            }
        }
       
        confirmWithInput = {
            confirmAction?(self.transferToDiscount())
        }
    }
    
    fileprivate func transferToDiscount() -> Float {
        var input = Float(self.inputTextField.text ?? "0") ?? 0
        if self.typeButton.isSelected {
            input = (base - input) / base
        }else {
            input =  input / 100
        }
        
        return min(max(input, 0), 1)
    }
    
    // delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismiss(animated: true) {
            self.confirmWithInput?()
        }
        return true
    }
    
    fileprivate func setWithType() {
        rightView.text = (typeButton.isSelected ? "$" : "%")
        titleLabel.text = (typeButton.isSelected ? "Enter Total" : "Enter Discount")
       
    }
    @IBAction func typeButtonIsTouched(_ sender: Any) {
        typeButton.isSelected.toggle()
        setWithType()
        
        // change text
        if let value = inputTextField.text {
            var input = Float(value) ?? 0
            if typeButton.isSelected {
                input = max(0, min(base * (1 - input / 100), base))
                inputTextField.text = String(format: "%.2f", input)
            }else {
                input = min(max(0,(1 - input / base)), 1) * 100
                inputTextField.text = String(format: "%.0f", input)
            }
        }
        
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
