//
//  LoginViewController.swift
//  LoginView
//
//  Created by dingf on 16/11/16.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit
import ABookData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var creatAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var guestButton: UIButton!
    
    var testForSelf = true
    
    var statusBar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialGUISetup()
        
        statusBar = UIImageView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: UIScreen.main.bounds.width, height: 20)))
        statusBar.image = UIImage.init(named: "title")
        view.addSubview(statusBar)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification){
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        let topToKeyboard = view.frame.size.height - keyboardSize.height
        let topToTextField = passwordTextField.frame.origin.y + passwordTextField.frame.size.height
        if topToKeyboard < topToTextField{
            self.view.frame.origin = CGPoint.init(x: 0, y: topToKeyboard - topToTextField)
            statusBar.frame.origin = CGPoint.init(x: 0, y: topToTextField - topToKeyboard)
        }
    }
    
    func keyboardWillHide(_ notification:Notification){
        self.view.frame.origin = CGPoint.zero
        statusBar.frame.origin = CGPoint.zero
    }
    
    @IBAction func endEnterPassword(_ sender: Any) {
        login(sender as AnyObject)
    }
    func initialGUISetup(){
        creatAccountButton.layer.cornerRadius = 12.0
        loginButton.layer.cornerRadius = 12.0
        creatAccountButton.layer.borderColor = UIColorGray(155).cgColor
        creatAccountButton.layer.borderWidth = 1.0
        creatAccountButton.layer.masksToBounds = true
        loginButton.layer.masksToBounds = true
    }
    
    var userName = ""
    
    func setGUIEnable(_ value:Bool){
        creatAccountButton.isEnabled = value
        loginButton.isEnabled = value
        userNameTextField.isEnabled = value
        passwordTextField.isEnabled = value
    }
    
    func removeNameAndPassword(){
        userNameTextField.text = nil
        passwordTextField.text = nil
    }
    
    @IBAction func login(_ sender: AnyObject) {
        guard userNameTextField.text != "" else {
            message("Missing user name.", title: "Login")
            return
        }
        
        guard passwordTextField.text != "" else {
            message("Missing password.", title: "Login")
            return
        }
        
        setGUIEnable(false)
        
        let name = userNameTextField.text!
        let password = passwordTextField.text!
        userName = name
        
        //oldLoginWay(name, password: password)
        Login(name, password: password)
    }
    /*
    func oldLoginWay(_ name: String, password: String) {
        // by-pass login if you have log in before.
        let defaults = UserDefaults.standard
        let userkey = "user_\(name)"
        if let data = defaults.object(forKey: userkey) {
            let oldDic = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! Dictionary<String, Any>
            if (oldDic["password"] as! String) == password {
                
                // !!! Hui To Do,  the login process needs to be reworked
                var user_uuid = defaults.object(forKey: name) as? String
                var userInBackend = true
                
                if user_uuid == nil {
                    user_uuid = UUID().uuidString
                    defaults.set(user_uuid, forKey: name)
                    userInBackend = false
                }
                
                // load login user
                UserCenter.sharedCenter.loadUser(user_uuid!, loginID: name)
                
                if userInBackend == false {
                    UserCenter.sharedCenter.addUserToBackend(UserCenter.sharedCenter.loginUserObj)
                }
                
                print("Login success.")
                toMainScreen()
                return
            }
        }
        
        // call REST api to login
        let service = UserWebService()
        service.login(name, passwd: password, callBack: self)
    }
 */
    
    func Login(_ name: String, password: String) {
        // call REST api to login
        let encryptedPasswd = DataEncrypting.encrypt(password)
        print("EncryptedPasswd: \(encryptedPasswd)")
        
        let service = UserAccess(callback: self)
        service.beginApi(self.view)
        // Fei to Do: don't encrypt for now !!! wait for Chor-ming
        // once successful didFinishGetDataByKey event will be fired
        service.login(name: name, password: encryptedPasswd)
    }
   
    @IBAction func accessAsGuest(_ sender: Any) {
        UserCenter.sharedCenter.userState = .guest
        UserCenter.sharedCenter.loginUserObj = UserCenter.createUser(UserCenter.guestUserID())
        toMainScreen()
    }

    @IBAction func creatAccount(_ sender: AnyObject) {
        let signUpVc = SignUpViewController()
        self.present(signUpVc, animated: true, completion: nil)
    }
    
    func startSpinner() {
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
    
    func message(_ msg : String, title : String)
    {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    weak var naviDelegate: UINavigationController!
    
    func toMainScreen() {
        stopSpinner()
        
        DispatchQueue.main.async {
            //跳转主界面
            self.hidesBottomBarWhenPushed = false
            
            if self.naviDelegate != nil {
                if self.testForSelf {
                    UserCenter.sharedCenter.setLoginUserAsTarget()
                    // logged or default
                    let riskAssess = ABookRiskAssessmentViewController()
                    self.naviDelegate.pushViewController(riskAssess, animated: true)
                } else {
                    let playForOthers = PlayForOthersViewController()
                    self.naviDelegate.pushViewController(playForOthers, animated: true)
                }
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        removeNameAndPassword()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

/*
extension LoginViewController: WebApiUserProtocol {
    
    func didFinishCreateUserTask(_ sender : UserWebService, userInfo : NSDictionary) {
        if DbUtil.needRebuild() {
            let service = ConfigWebService()
            service.loadAllConfigs(self)
            print("User has login. Loading config from server.")
        } else {
            print("Loading all configs are done")
            toMainScreen()
        }
    }
    
    func didFinishAddDataByKey(_ obj: AnyObject) {
        toMainScreen()
        print("Save new user to backend successful.")
    }
    
    func failedAddDataByKey(_ error: String) {
        print("Fail to add new user to backend")
    }
    
    
    func failedCreateUserTask(_ sender : UserWebService, errorMessage : String) {
        stopSpinner()
        let alert = UIAlertController.init(title: "", message: "Fail to create user with error \(errorMessage)", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        print("Fail creating user with error \(errorMessage)")
    }
    
    func didFinishLoginUserTask(_ sender : UserWebService, userInfo : [String : Any]) {
        
        // private key which will be used to send any encrypted text
        let privateKey = userInfo["PrivateKey"] as! String
        let key = userInfo["Key"] as! String
        let timeStamp = userInfo["Timestamp"] as! String
        
        UserCenter.sharedCenter.loadUser(key, loginID: userInfo["loginId"] as! String)
        
        print("Login success.\nPrivateKey:\(privateKey)\nKey:\(key)\nTimeStamp:\(timeStamp)")
        
        toMainScreen()
    }
    
    func failedLoginUserTask(_ sender : UserWebService, errorMessage : String) {
        stopSpinner()
        print("Fail login user with error \(errorMessage)")
        let alert = UIAlertController.init(title: "", message: "User login failed.", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        setGUIEnable(true)
        removeNameAndPassword()
    }
    
}

extension LoginViewController: WebApiConfigProtocol {
    func didFinishLoadingConfigDataTask(_ sender: ConfigWebService, configContext : String) {
    }
    
    func failedLoadingConfigDataFromService(_ sender : ConfigWebService, configContext : String, errorMessage : String) {
    }
    
    func didFinishLoadingAllConfigDataTask(_ sender : ConfigWebService) {
        print("Loading all configs are done")
        toMainScreen()
    }
    
    func failedLoadingAllConfigDataFromService(_ sender : ConfigWebService, errorMessage : String) {
        let alert = UIAlertController.init(title: "", message: "Failed to load user's config from server.", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        print("Fail loading all config info with error \(errorMessage)")
    }
}
*/


extension LoginViewController: DataAccessProtocal {
    func didFinishGetDataByKey(_ obj: AnyObject) {
        
        if obj is UserLoginObjModel {
            UserCenter.sharedCenter.loadUser(obj as! UserLoginObjModel, details: nil)
            UserCenter.sharedCenter.loginKey = obj.key
        }
        
        toMainScreen()
    }
    
    func failedGetDataByKey(_ error: String) {
        message("", title: "Error:\(error)")
        setGUIEnable(true)
    }
}



