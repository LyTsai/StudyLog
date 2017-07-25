//
//  SignUpViewController.swift
//  SignUpView
//
//  Created by dingf on 16/11/16.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit
import ABookData

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var statusBar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        // set status bar background image
        statusBar = UIImageView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: UIScreen.main.bounds.width, height: 20)))
        statusBar.image = UIImage.init(named: "title")
        view.addSubview(statusBar)
        
        // keyboard show or hide notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // keyboard show
    func keyboardWillShow(_ notification:Notification){
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        let topToKeyboard = view.frame.size.height - keyboardSize.height
        let topToTextField = confirmPasswordTextField.frame.origin.y + confirmPasswordTextField.frame.size.height
        if topToKeyboard < topToTextField{
            self.view.frame.origin = CGPoint.init(x: 0, y: topToKeyboard - topToTextField)
            statusBar.frame.origin = CGPoint.init(x: 0, y: topToTextField - topToKeyboard)
        }
    }
    
    // keyboard hide
    func keyboardWillHide(_ notification:Notification){
        self.view.frame.origin = CGPoint(x: 0, y: 0)
        statusBar.frame.origin = CGPoint.init(x: 0, y: 0)
    }
    
    @IBAction func confirmPasswordGo(_ sender: Any) {
        signUp(sender as AnyObject)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initialSetup(){
        signUpButton.layer.cornerRadius = 12.0
        signUpButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 12.0
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.init(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0).cgColor
        loginButton.layer.masksToBounds = true
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGUIEnable(_ value: Bool){
        userNameTextField.isEnabled = value
        passwordTextField.isEnabled = value
        confirmPasswordTextField.isEnabled = value
        signUpButton.isEnabled = value
        loginButton.isEnabled = value
    }
    
    func removeNameAndPassword(){
        userNameTextField.text = nil
        passwordTextField.text = nil
        confirmPasswordTextField.text = nil
    }
    @IBAction func signUp(_ sender: AnyObject) {
        guard userNameTextField.text != "" else {
            message("Missing user name.", title: "Login")
            return
        }
        guard passwordTextField.text != "" else {
            message("Missing password.", title: "Login")
            return
        }
        guard confirmPasswordTextField.text != "" else {
            message("Please confirm password.", title: "Login")
            return
        }
        guard passwordTextField.text! == confirmPasswordTextField.text! else{
            message("Two passwords don't match.", title: "Login")
            return
        }
        
        setGUIEnable(false)
        let name = userNameTextField.text!
        let password = passwordTextField.text!
        
        let userAccountService = UserAccess(callback: self)
        userAccountService.beginApi(self.view)
        
        // !!! Fei To DO: wait for Chor-ming to decide when to use encrypted password and add displayName as required plus user details as part of yser creation payload
        userAccountService.signUp(displayName: name, loginID: name, password: password, userDetails: nil)
        
        /*
        service.createUser(name, userPassword: DataEncrypting.encrypt(password), isSystemUser: true, isApplicationUser: true, callBack: self)
         */
    }
    
    func message(_ msg : String, title : String){
        let alert = UIAlertController.init(title: "", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func startSpinner(){
        let spinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        let rect2 = self.view.bounds
        spinner.center = CGPoint(x: rect2.size.width / 2.0, y: rect2.size.height / 2.0)
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        for view in self.view.subviews {
            if view .isKind(of: UIActivityIndicatorView.self) {
                let spinner = view as! UIActivityIndicatorView
                spinner.stopAnimating()
                spinner.removeFromSuperview()
            }
        }
    }
}

extension SignUpViewController : DataAccessProtocal {
//    func didFinishCreateUserTask(_ sender : UserWebService, userInfo : NSDictionary) {
//        if DbUtil.needRebuild() {
//            stopSpinner()
//            let alert = UIAlertController.init(title: "Register successfully.", message: "Click OK to login and load config from server automatically...", preferredStyle: .alert)
//            let ok = UIAlertAction.init(title: "OK", style: .default) { (action) in
//                DispatchQueue.main.async {
//                    self.startSpinner()
//                    //
//                    let service = ConfigWebService()
//                    service.loadAllConfigs(self)
//                    print("User has login. Loading config from server...")
//                }
//            }
//            alert.addAction(ok)
//            present(alert, animated: true, completion: nil)
//        } else {
//            print("Loading all configs are done")
//        }
//    }
    
    func didFinishAddDataByKey(_ obj: AnyObject) {
        
        let alert = UIAlertController.init(title: "Register successfully.", message: "Click Go to login", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Go", style: .default) { (action) in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let tabbar = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! ABookTabBarController
            self.present(tabbar, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.setGUIEnable(true)
        }
 
        // !!! To Do, since the addOne function returns "entities" instead of payload returned from server
        if let userInfo = obj as? UserObjModel {
            let usserAccess = UserLoginObjModel()
            
            usserAccess.displayname = userInfo.displayName
            usserAccess.userKey = userInfo.key
            usserAccess.privateKey = "To DO"    // !!! Fei To Do: wait for Chor-ming to return PrivateKey also
            
            UserCenter.sharedCenter.loadUser(usserAccess, details: userInfo)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
    func failedAddDataByKey(_ error: String) {
        stopSpinner()
        message("'", title: "Error:\(error)")
        setGUIEnable(true)
        removeNameAndPassword()
    }
    
    func failedCreateUserTask(_ sender : UserWebService, errorMessage : String) {
        stopSpinner()
        message("'", title: "Error:\(errorMessage)")
        setGUIEnable(true)
        removeNameAndPassword()
    }
    
    func didFinishLoginUserTask(_ sender : UserWebService, userInfo : [String : Any]) {
    }
    
    func failedLoginUserTask(_ sender : UserWebService, errorMessage : String) {
    }
    
}

extension SignUpViewController: WebApiConfigProtocol {
    func didFinishLoadingConfigDataTask(_ sender: ConfigWebService, configContext : String) {
    }
    
    func failedLoadingConfigDataFromService(_ sender : ConfigWebService, configContext : String, errorMessage : String) {
    }
    
    func didFinishLoadingAllConfigDataTask(_ sender : ConfigWebService) {
//        print("Loading all configs are done")
//        stopSpinner()
//        // We have all the user data updated
//        // Now, add the newly created user to user Info
//        // Collect user info, currently put some default value
//        var dic = [String :Any]()
//        let userName : String = userNameTextField.text!
//        dic["address"] = "Solar System";
//        dic["city"] = "Earth";
//        dic["country"] = "Human"
//        dic["user"] = userName
//        dic["age"] = 18
//        dic["name"] = userName
//        dic["email"] = userName
//        dic["sex"] = "Female"
//        dic["race"] = "Pure"
//        dic["state"] = "Mammalia"
//        dic["profession"] = "Archor"
//        let userInfo = UserInfo.fromDictionary(dic) as! UserInfo
//        let user = User.addUser(userName, displayName: userName )!
//        user.loginID = userName
//        user.userInfo = userInfo
//        DbUtil.manager.saveContext()
//        DbUtil.saveUserData()
//        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let tabbar = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! ABookTabBarController
//        self.present(tabbar, animated: true, completion: nil)
        
        print("Loading all configs are done")
        stopSpinner()
        // We have all the user data updated
        // Now, add the newly created user to user Info
        // Collect user info, currently put some default value
        
        let inputUserInfoVc = InputUserInfoViewController()
        inputUserInfoVc.userName = userNameTextField.text!
        self.present(inputUserInfoVc, animated: true, completion: nil)
    }
    func failedLoadingAllConfigDataFromService(_ sender : ConfigWebService, errorMessage : String) {
        let alert = UIAlertController.init(title: "", message: "Failed to load user's config from server.", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        print("Fail loading all config info with error \(errorMessage)")
    }
}
