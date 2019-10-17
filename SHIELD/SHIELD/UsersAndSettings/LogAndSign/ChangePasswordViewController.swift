//
//  ChangePasswordViewController.swift
//  AnnielyticX
//
//  Created by L on 2019/5/5.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var logoCenterImage: UIImageView!
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmButton: GradientBackStrokeButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    class func createFromNib() -> ChangePasswordViewController {
        let changeVC = Bundle.main.loadNibNamed("ChangePasswordViewController", owner: self, options: nil)?.first as! ChangePasswordViewController
        return changeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Change Password"
        setupBasicUI()
    }
    
    fileprivate func setupBasicUI() {
        // fonts
        let inputFont = UIFont.systemFont(ofSize: 16 * fontFactor)
        oldPasswordTextField.font = inputFont
        passwordTextField.font = inputFont
        confirmPasswordTextField.font = inputFont
        
        confirmButton.setupWithTitle("Confirm")
        confirmButton.isSelected = false
        
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
  
        // delegate
        oldPasswordTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }

    // delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification){
        if self.logoCenterImage.isHidden {
            return
        }
        
        let keyboardRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue ?? CGRect.zero
        if keyboardRect.minY < inputBackView.frame.maxY {
            let translationY = logoCenterImage.frame.minY - inputBackView.frame.minY
            self.inputBackView.transform = CGAffineTransform(translationX: 0, y: translationY)
            self.logoCenterImage.isHidden = true
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        self.inputBackView.transform = CGAffineTransform.identity
        self.logoCenterImage.isHidden = false
    }
    
    
    func message(_ msg: String, title: String)
    {
        let alert = CatCardAlertViewController()
        alert.addTitle(title, subTitle: msg, buttonInfo:[("Got It", true, nil)])
        presentOverCurrentViewController(alert, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    fileprivate var userAccess: UserAccess!
    @IBAction func confirmChange(_ sender: Any) {
        guard oldPasswordTextField.text != "" else {
            message("", title: "Enter Old Password.")
            return
        }
        guard passwordTextField.text != "" else {
            message("", title: "Enter New Password.")
            return
        }
        guard confirmPasswordTextField.text != "" else {
            message("", title: "Enter Confirm Password.")
            return
        }
        
        guard passwordTextField.text == confirmPasswordTextField.text else {
            message("", title: "The password for two time is inconsistent.")
            return
        }
       
        guard oldPasswordTextField.text != confirmPasswordTextField.text else {
            message("", title: "The new password should be different from the old.")
            return
        }
        
        
        // login first
        if userCenter.userState == .login {
            if userAccess == nil {
                userAccess = UserAccess(callback: self)
            }
            
            userAccess.changePwd(oldPwd: oldPasswordTextField.text!, newPwd: passwordTextField.text!, confirmNewPwd: confirmPasswordTextField.text!)
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

// user access
extension ChangePasswordViewController : DataAccessProtocal {
    func didFinishAddDataByKey(_ obj: AnyObject) {
        if obj is UserObjModel {
             message("Your password is changed now.", title: "Success")
            if localDB.database.open() {
                (obj as! UserObjModel).saveToLocalDatabase()
                localDB.database.close()
            }
        }
    }
    
    func failedAddDataByKey(_ error: String) {
        let alert = UIAlertController.init(title: "Fail", message: error, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Ok", style: .default) { (action) in
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

