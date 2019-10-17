//
//  SignUpViewController.swift
//  SignUpView
//
//  Created by dingf on 16/11/16.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var logoCenterImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: GradientBackStrokeButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var term: UITextView!
    @IBOutlet weak var termCheckButton: UIButton!
    
    class func createFromNib() -> SignUpViewController {
        let signUpVC = Bundle.main.loadNibNamed("SignUpViewController", owner: self, options: nil)?.first as! SignUpViewController
        return signUpVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBasicUI()
    }
    
    fileprivate func setupBasicUI() {
        // fonts
        let inputFont = UIFont.systemFont(ofSize: 16 * fontFactor)
        userNameTextField.font = inputFont
        passwordTextField.font = inputFont
        confirmPasswordTextField.font = inputFont
        
        signUpButton.setupWithTitle("Sign Up")
        signUpButton.isSelected = false
       
        loginButton.setAttributedTitle(NSAttributedString(string: "I already have an account", attributes: [.font: UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium), .foregroundColor: UIColorFromHex(0x7ED321), .underlineStyle: 1, .underlineColor: UIColorFromHex(0x7ED321)]), for: .normal)
        
        // term
        termCheckButton.isSelected = true
        let termFont = UIFont.systemFont(ofSize: 12 * fontFactor)
        let termString = NSMutableAttributedString(string: "By creating an account, I agree to ", attributes:[.font: termFont])
        termString.append(NSAttributedString(string: "AnnielyticX’s terms of use and privacy policy.", attributes: [.font: termFont, .link: "\(pagesBaseUrl)public/About_1/"]))
        term.attributedText = termString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showTerm))
        term.addGestureRecognizer(tap)
        
        signUpButton.isEnabled = termCheckButton.isSelected
        signUpButton.alpha = signUpButton.isEnabled ? 1 : 0.6
    
        // delegate
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    
    @IBAction func checkTerm(_ sender: Any) {
        termCheckButton.isSelected = !termCheckButton.isSelected
        signUpButton.isEnabled = termCheckButton.isSelected
        signUpButton.alpha = signUpButton.isEnabled ? 1 : 0.6
    }
    @objc func showTerm() {
        let urlString = "\(pagesBaseUrl)public/About_1/"
        let webVC = WebViewDisplayViewController()
        webVC.showGradientBorder = false
        webVC.setupWithUrlString(urlString)
        presentOverCurrentViewController(webVC, completion: nil)
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
  
    
    @IBAction func confirmPasswordGo(_ sender: Any) {
        signUp(sender as AnyObject)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    @IBAction func signUp(_ sender: AnyObject) {
        
        guard userNameTextField.text != "" else {
            message("Missing email.", title: "")
            return
        }
        guard passwordTextField.text != "" else {
            message("Missing password.", title: "")
            return
        }
        guard confirmPasswordTextField.text != "" else {
            message("Please confirm password.", title: "")
            return
        }
        guard passwordTextField.text! == confirmPasswordTextField.text! else{
            message("Two passwords don't match.", title: "")
            return
        }
        
        if !isValidateEmail(userNameTextField.text!){
            message("The mailbox format is incorrect", title: "")
            return
        }
        
        let inputUserInfoVC = createLoginController(userNameTextField.text!, passwordTextField.text!)
        pushLoginViewController(inputUserInfoVC)
    }
    
    func createLoginController(_ name : String, _ password : String) -> LoginUserInputViewController {
        // fill information
        let inputUserInfoVC = LoginUserInputViewController()
        inputUserInfoVC.userName = name
        inputUserInfoVC.password = password
        return inputUserInfoVC
    }
    
    func pushLoginViewController(_ inputUserInfoVC : LoginUserInputViewController) {
        present(inputUserInfoVC, animated: true, completion: nil)
//        navigationController?.pushViewController(inputUserInfoVC, animated: true)
    }
    
    func isValidateEmail(_ email: String) -> Bool{
        let emailRegex = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        return emailTest.evaluate(with:email)
    }
    
    func message(_ msg : String, title: String){
        let alert = CatCardAlertViewController()
        alert.addTitle(title, subTitle: msg, buttonInfo:[("Got It", true, nil)])
        presentOverCurrentViewController(alert, completion: nil)
    }
    
    @IBAction func login(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
    
    
    // account hold
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "Sign Up"
    }
    
}
