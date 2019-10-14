//
//  LoginViewController.swift
//  LoginView
//
//  Created by dingf on 16/11/16.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit
var SHIELDKey = "NONE"
let shieldMetricKey = "4c439706-2ead-4d2c-a595-d1a68ba9959b"
class LoginViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: GradientBackStrokeButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var rememberCheckButton: UIButton!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var loginImageBack: UIView!
    
    var invokeFinishedClosure: (() ->())?
    
    class func createFromNib() -> LoginViewController {
        let loginVC = Bundle.main.loadNibNamed("LoginViewController", owner: self, options: nil)?.first as! LoginViewController
        return loginVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Log In"
        
        setupBasicUI()
    }
    
    fileprivate func setupBasicUI() {
        // fonts
        let inputFont = UIFont.systemFont(ofSize: 16 * fontFactor)
        userNameTextField.font = inputFont
        passwordTextField.font = inputFont
        loginTitleLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor)
        
        rememberLabel.font = UIFont.systemFont(ofSize: 11 * fontFactor)
        loginButton.setupWithTitle("Log In")
        loginButton.isSelected = false
        forgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        signUpButton.setAttributedTitle(NSAttributedString(string: "Sign up for a new account", attributes: [.font: UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium), .foregroundColor: UIColorFromHex(0x7ED321), .underlineStyle: 1, .underlineColor: UIColorFromHex(0x7ED321)]), for: .normal)
        
        // user defaults
        if userDefaults.bool(forKey: rememberAccountKey) {
            if let name = userDefaults.string(forKey: userAccountNameKey) {
                userNameTextField.text = name
                rememberCheckButton.isSelected = true
            }
        }else {
            rememberCheckButton.isSelected = false
        }
        
        // delegate
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        // test
        if TARGET_OS_SIMULATOR == 1 {
            userNameTextField.text = "lydire@163.com"
            passwordTextField.text = "1234"
        }
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
        
        if userNameTextField.text != nil && passwordTextField.text != nil && userNameTextField.text != "" && passwordTextField.text != ""{
            loginButton.isSelected = true
        }else {
            loginButton.isSelected = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    
    @objc func keyboardWillShow(_ notification:Notification) {
        if self.inputBackView.transform != CGAffineTransform.identity {
            return
        }
        
        let keyboardRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue ?? CGRect.zero
        
        if keyboardRect.minY < inputBackView.frame.maxY {
            let translationY = keyboardRect.minY - inputBackView.frame.maxY
            self.inputBackView.transform = CGAffineTransform(translationX: 0, y: translationY)
            self.layoutLoginImage(true)

        }
    }
    
    fileprivate func layoutLoginImage(_ shrink: Bool) {
        loginImageBack.frame.size = CGSize(width: self.loginImageBack.frame.width, height: inputBackView.frame.minY - self.loginImageBack.frame.minY)
        loginImage.image = UIImage(named: "login_\(shrink ? "1" : "0")")
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if self.inputBackView.transform != CGAffineTransform.identity {
            self.inputBackView.transform = CGAffineTransform.identity
            self.layoutLoginImage(false)
        }
    }
    
    var userName = ""
    func removeNameAndPassword(){
        userNameTextField.text = nil
        passwordTextField.text = nil
        loginButton.isSelected = false
    }
    
    // actions
    @IBAction func login(_ sender: AnyObject) {
        guard userNameTextField.text != "" else {
            message("Missing user name.", title: "Login")
            return
        }
        
        guard passwordTextField.text != "" else {
            message("Missing password.", title: "Login")
            return
        }
        
        let name = userNameTextField.text!
        let password = passwordTextField.text!
        userName = name
        
        // login
        Login(name, password: password)
    }
    
    
    fileprivate let loading = LoadingViewController()
    func Login(_ name: String, password: String) {
        // call REST api to login
        if userCenter.userState == .login && userCenter.loginName == name {
            goBackToContinue()
        }else {
            let service = UserAccess(callback: self)
            present(loading, animated: true) {
                service.login(name: name, password: password)
            }
        }
    }
    
    fileprivate func startLoading(_ action: (()->Void)?) {
        if loading.isLoading {
            action?()
        }else {
            present(loading, animated: true) {
                action?()
            }
        }
    }
    
    fileprivate func finishLoading(_ action: (()->Void)?) {
        if loading.isLoading {
            loading.dismiss(animated: true) {
                action?()
            }
        }else {
            action?()
        }
    }
    
    
    @IBAction func rememberCheckBox(_ sender: Any) {
        rememberCheckButton.isSelected = !rememberCheckButton.isSelected
        userDefaults.set(rememberCheckButton.isSelected, forKey: rememberAccountKey)
        userDefaults.synchronize()
    }
    
    @IBAction func createAccount(_ sender: AnyObject) {
        let signUpVc = SignUpViewController.createFromNib()
        
        present(signUpVc, animated: true, completion: nil)
    }
    
    func message(_ msg : String, title : String) {
        let alert = CatCardAlertViewController()
        alert.addTitle(title, subTitle: msg, buttonInfo:[("Got It", true, nil)])
        presentOverCurrentViewController(alert, completion: nil)
    }
    
    fileprivate func goBackToContinue() {
        removeNameAndPassword()
        userCenter.userState = .login
        userCenter.setLoginUserAsTarget()
        
        if !ApplicationDataCenter.sharedCenter.loadedFromNet {
            // application keys
            let applicationAccess = ApplicationAccess(callback: self)
            // load
            applicationAccess.getOneByKey(key: AnnieLyticxSlowAgingByDesign)
        }else {
             loadMetric()
        }
    }
    
    fileprivate var metricAccess: MetricAccess!
    fileprivate var riskAccess: RiskAccess!
    fileprivate func loadMetric() {
        if collection.metricIsLoadedFromNet(shieldMetricKey) {
            loadRisk()
        }else {
            if metricAccess == nil {
                metricAccess = MetricAccess(callback: self)
            }
            
            metricAccess.getOneByKey(key: shieldMetricKey)
        }
    }
    
    fileprivate func loadRisk() {
        if collection.risksLoadedForMetric(shieldMetricKey) {
            loadRiskType()
        }else {
            if riskAccess == nil {
                riskAccess = RiskAccess(callback: self)
            }
            startLoading {
                self.riskAccess.getRisksByMetric(shieldMetricKey)
            }
        }
    }
    
    fileprivate var typeAccess: RiskTypeAccess!
    fileprivate var riskTypeKey: String?
    fileprivate func loadRiskType() {
        SHIELDKey = collection.getAllRisksOfRiskClass(shieldMetricKey).first ?? "NODATA"
//        cardsCursor.riskTypeKey = GameTintApplication.sharedTint.iCaKey
        riskTypeKey = collection.getRisk(SHIELDKey)?.riskTypeKey
        
        typeAccess = RiskTypeAccess(callback: self)
        startLoading {
            self.typeAccess.getOneByKey(key: self.riskTypeKey!)
        }
    }
    
    fileprivate func allLoaded() {
        cardsCursor.selectedRiskClassKey = shieldMetricKey
        cardsCursor.riskTypeKey = riskTypeKey
        
        finishLoading({
            self.invokeFinishedClosure?()
            
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    fileprivate var cursor: Int = 0

    fileprivate let spinner = LoadingWhirlProcess()
    @IBAction func forgetPwd(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Your Login Email", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            if self.userNameTextField.text != nil {
                textfield.text = self.userNameTextField.text
            }
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (ation) in
            let userAccess = UserAccess(callback: self)
            let loginID = alert.textFields?.first!.text ?? ""

            if loginID == "" {
                self.message("please check your login ID", title: "Invalid")
            }else {
                userAccess.forgetPwd(loginId: loginID)
                self.spinner.startLoadingOnView(self.view, length: 122 * fontFactor)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(OKAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// get data from backend
extension LoginViewController {
    func loadLocalRiskAndMeasurements(_ userKey: String) {
        if GameTintApplication.sharedTint.appTopic != .SlowAgingByDesign {
            // load risks
            collection.loadRisks([], riskTypeKey: "", fromNet: false)
            collection.updateRiskTypes([], fromNet: false)
        }
        
        // should get all risk's detail information before loading measurement, or the card will be nil
        for riskKey in collection.getAllRisks() {
            // risk detail, including cards' details
            collection.getDetailedRiskFromLocal(riskKey)
            
            // record
            selectionResults.getAllLocalMeasurementsForUser(userKey, riskKey: riskKey)
            selectionResults.useLastMeasurementForUser(userKey, riskKey: riskKey, whatIf: false)
        }
    }
}

extension LoginViewController: DataAccessProtocal {
    func didFinishGetGraphByKey(_ obj: AnyObject) {
        if obj is UserObjModel {
            let user = obj as! UserObjModel
            userCenter.loginUserObj = user
            user.password = passwordTextField.text
            
            // save
            if userDefaults.bool(forKey: rememberAccountKey) {
                userDefaults.set(userNameTextField.text, forKey: userAccountNameKey)
                userDefaults.synchronize()
            }
            
            // local data of user
            loadLocalRiskAndMeasurements(user.key)
            
            if localDB.database.open() {
                user.saveToLocalDatabase()
                
                // load group
                let groupDics = localDB.getModelDicsWithColumnName("UserKey", value: user.key!, inTable: UserGroupObjModel.tableName)
                var groups = [UserGroupObjModel]()
                for dic in groupDics {
                    if let group = UserGroupObjModel.fromSqliteDicToModel(dic) {
                        groups.append(group)
                        userCenter.addOrChangeUserGroup(group, saveToLocal: false)
                    }
                }
                localDB.database.close()
            }
            
            // get pseudo
            if user.pseudoUserKeys.isEmpty {
                goBackToContinue()
            }else {
                cursor = 0
                let pseudoUserAccess = PseudoUserAccess(callback: self)
                pseudoUserAccess.getOneGraphByKey(key: user.pseudoUserKeys.first!)
            }
        }else if obj is PseudoUserObjModel {
            userCenter.addOrChangePseudoUser(obj as! PseudoUserObjModel, saveToLocal: true)
            cursor += 1
            let keys = userCenter.loginUserObj.pseudoUserKeys
            if cursor == keys.count {
                goBackToContinue()
            }else {
                let pseudoUserAccess = PseudoUserAccess(callback: self)
                pseudoUserAccess.getOneGraphByKey(key: keys[cursor])
            }
        }
    }
    
    func didFinishGetDataByKey(_ obj: AnyObject) {
        if obj is UserLoginObjModel {
            userCenter.loadUser(obj as! UserLoginObjModel)
            userCenter.loginName = userNameTextField.text
            
            // get userInfo
            let userAccess = UserAccess(callback: self)
            userAccess.getOneGraphByKey(key: userCenter.loginKey)
        }else if obj is MetricObjModel {
            // metric
            collection.loadMetric(obj as! MetricObjModel, fromNet: true)
            cardsCursor.selectedRiskClassKey = (obj as! MetricObjModel).key
            loadRisk()
        }else if obj is RiskTypeObjModel {
            collection.updateRiskTypes([obj as! RiskTypeObjModel], fromNet: true)
            allLoaded()
        }else if obj is ApplicationObjModel {
            let application = obj as! ApplicationObjModel
            let applicationDic = application.applicationClassDic
            // show buttons
            ApplicationDataCenter.sharedCenter.updateDictionary(applicationDic)
            ApplicationDataCenter.sharedCenter.loadedFromNet = true
        
            // dataBase
            if localDB.database.open() {
                application.saveToLocalDatabase()
                localDB.database.close()
            }
            loadMetric()
        }
        
    }
    
    func failedGetDataByKey(_ error: String) {
        var recordFine = false
        if USERECORD {
            // check data, right or not
            if localDB.database.open() {
                if let userDic = localDB.getModelDicsWithColumnName("LoginID", value: userNameTextField.text ?? "", inTable: UserObjModel.tableName).first  {
                    if let user = UserObjModel.fromSqliteDicToModel(userDic) {
                        if user.password != nil && user.password! == passwordTextField.text {
                            // corrrect
                            recordFine = true
                            
                            // psedoUsers
                            let pseDics = localDB.getModelDicsWithColumnName("UserKey", value: user.key!, inTable: PseudoUserObjModel.tableName)
                            var pseudos = [PseudoUserObjModel]()
                            for dic in pseDics {
                                if let pse = PseudoUserObjModel.fromSqliteDicToModel(dic) {
                                    pseudos.append(pse)
                                    userCenter.addOrChangePseudoUser(pse, saveToLocal: false)
                                }
                            }
                            // groups
                            let groupDics = localDB.getModelDicsWithColumnName("UserKey", value: user.key!, inTable: UserGroupObjModel.tableName)
                            var groups = [UserGroupObjModel]()
                            for dic in groupDics {
                                if let group = UserGroupObjModel.fromSqliteDicToModel(dic) {
                                    groups.append(group)
                                    userCenter.addOrChangeUserGroup(group, saveToLocal: false)
                                }
                            }
                            
                            user.userGroups = groups
                            userCenter.loginUserObj = user
                            userCenter.loginName = user.name
                            loadLocalRiskAndMeasurements(user.key)
                        }
                    }
                }
                localDB.database.close()
            }
        }
        if recordFine {
            loading.dismiss(animated: true) {
                let alert = UIAlertController.init(title: "You are now using the record", message: "", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Got It", style: .default, handler: { (action) in
                    // load
                    self.goBackToContinue()
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            loading.dismiss(animated: true) {
                USERECORD = true
                self.message("Please check your account name or password and retry", title: "Try again")
            }
        }
    }
    
    // forget
    func didFinishAddDataByKey(_ obj: AnyObject) {
        if obj is UserObjModel{
            spinner.loadingFinished()
            
            let alert = UIAlertController.init(title: "Success", message:  "Now you should receive one confirming email.", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK, go to check Email", style: .default) { (action) in
                // go to check email
                
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func failedAddDataByKey(_ error: String) {
        loading.dismiss(animated: true, completion: {
            let alert = UIAlertController.init(title: "Fail to Add", message: error, preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .default) { (action) in
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
        
        func didFinishGetAttribute(_ obj: [AnyObject]) {
            if obj is [RiskObjModel] {
                let risks = obj as! [RiskObjModel]
                collection.loadRisks(risks, metricKey: shieldMetricKey, fromNet: true)
                loadRiskType()
//                SHIELDKey = risks.first?.key ?? "NODATA"
//                loadDetailRisk()
            }
        }
        
        // failed
        func failedGetAttribute(_ error: String) {
            finishLoading({
                self.showAlertMessage(error, title: "Fail to Get Risk", buttons: [("OK", nil)])
            })
        }
}
