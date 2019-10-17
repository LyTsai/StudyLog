//
//  LoginUserInputViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/5.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class LoginUserInputViewController: UIViewController {
    var forUser = true
    var pseudoUser: PseudoUserObjModel!

    var forSignUp = true
    fileprivate var user = userCenter.loginUserObj
    var userName = ""
    var password: String!

    // subviews
    fileprivate var nameInputView: UserNameInputView!
    fileprivate var dobInputView: UserBirthDateInputView!
    fileprivate var genderInputView: UserGenderInputView!
    fileprivate var overallInputView: UserOverallInputView!
 
    fileprivate var userAccountService: UserAccess!
    fileprivate var pseudoUser2Backend: PseudoUserAccess!
    
    fileprivate let topLabel = UILabel()
    fileprivate let inputScrollView = UIScrollView()
    fileprivate var inputViews = [DashBorderView]()
    fileprivate var titles = [String]()
    fileprivate let backButton = GradientBackStrokeButton()
    fileprivate let nextButton = GradientBackStrokeButton()
    fileprivate var process: CardProcessIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColorFromHex(0xFBFFF8)
        
        navigationItem.title = forUser ? "Welcome to the game" : "Other Player"
        backButton.setupWithTitle("< BACK")
        nextButton.setupWithTitle("NEXT >")
        
        // subviews
        topLabel.font = UIFont.systemFont(ofSize: 22 * fontFactor, weight: .medium)
        topLabel.textAlignment = .center
        topLabel.frame = CGRect(x: 0, y: topLength, width: width, height: 72 * standHP)
        view.addSubview(topLabel)
        
        // main
        inputScrollView.frame = CGRect(x: 0, y: topLabel.frame.maxY, width: width, height: min(height - 216 - topLabel.frame.maxY, 330 * standHP))
        inputScrollView.backgroundColor = UIColor.clear
        inputScrollView.showsHorizontalScrollIndicator = false
        inputScrollView.showsVerticalScrollIndicator = false
        inputScrollView.isPagingEnabled = true
        inputScrollView.isScrollEnabled = false
        view.addSubview(inputScrollView)
        
        let mainBounds = CGRect(x: 0, y: 0, width: width, height: inputScrollView.bounds.height - 15 * fontFactor).insetBy(dx: 20 * standWP, dy: standWP * 5)
       
        // input views
        nameInputView = UserNameInputView(frame: mainBounds)
        dobInputView = UserBirthDateInputView(frame: mainBounds)
        genderInputView = UserGenderInputView(frame: mainBounds)
        overallInputView = UserOverallInputView(frame: mainBounds)
        
        // set name
        inputViews = [nameInputView, dobInputView, genderInputView, overallInputView]
        titles = ["Name", "When were you born", "Gender", "Overall Health"]
        if !forSignUp {
            // assign data
            if forUser {
                // login User
                user = userCenter.loginUserObj
                userName = user.details().displayName ?? userCenter.loginName
                setupWithName(userName, avatar: user.imageObj, dobString: user.dobString, sex: user.sex, state: user.state)
            }else {
                // pseudoUser
                if pseudoUser != nil {
                    setupWithName(pseudoUser.name, avatar: pseudoUser.imageObj, dobString: pseudoUser.dobString, sex: pseudoUser.sex, state: pseudoUser.state)
                }
            }
        }
        
        // views
        inputScrollView.contentSize = CGSize(width: CGFloat(numberOfViews) * width, height: inputScrollView.bounds.height)
        
        // add inputs
        for (i, input) in inputViews.enumerated() {
            input.layer.addBlackShadow(5 * fontFactor)
            input.layer.shadowOffset = CGSize(width: 0, height: 8 * fontFactor)
            input.layer.shadowOpacity = 0.5
            input.frame.origin = CGPoint(x: mainBounds.minX + CGFloat(i) * width, y: mainBounds.minY)
            inputScrollView.addSubview(input)
        }
        
        // process
        let remainedH = height - inputScrollView.frame.maxY - bottomLength
        let gap = remainedH * 0.1
        process = CardProcessIndicatorView.createWithFrame(CGRect(x: mainBounds.minX, y: inputScrollView.frame.maxY + gap, width: width - 2 * mainBounds.minX, height: 30 * standHP))
        process.usedForCards = false
        process.numberOfNodes = numberOfViews
        
        view.addSubview(process)
        
        // buttons
        let remain = remainedH - process.frame.height - gap * 2
        let buttonSize = CGSize(width: (width - 2 * mainBounds.minX) * 0.4, height: remain * 0.6)
        let buttonY = (remain - buttonSize.height) * 0.5 + process.frame.maxY + gap
        
        let leftFrame = CGRect(x: mainBounds.minX, y: buttonY, width: buttonSize.width, height: buttonSize.height)
        let rightFrame = CGRect(x: width - buttonSize.width - mainBounds.minX, y: buttonY, width: buttonSize.width, height: buttonSize.height)
        
        backButton.frame = leftFrame
        nextButton.frame = rightFrame
        
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        
        // init
        currentIndex = 0
    }
    
    fileprivate func setupWithName(_ name: String!, avatar: UIImage!, dobString: String!, sex: String!, state: String!) {
        nameInputView.setName(name ?? "")
        
        if avatar != nil {
            nameInputView.setIcon(avatar)
        }
        
        if dobString != nil {
            dobInputView.setDateOfBirth(dobString)
        }
        
        // gender
        if sex != nil {
            genderInputView.isMale = !sex.localizedCaseInsensitiveContains("f")
        }
        
        // state
        if state != nil {
            overallInputView.setupWithState(state)
        }
    }
    
    // MARK: ------------- during
    var currentIndex: Int = -1 {
        didSet{
            if currentIndex != oldValue {
                if currentIndex < 0 || currentIndex >= numberOfViews {
                    return
                }
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.inputScrollView.contentOffset.x = width * CGFloat(self.currentIndex)
                })
                
                backButton.isHidden = (currentIndex == 0)
                nextButton.isSelected = (currentIndex == numberOfViews - 1)
                process.currentItem = currentIndex + 1
                topLabel.text = titles[currentIndex]
                
                nextButton.setupWithTitle(nextButton.isSelected ? "LET'S GO! >" : "NEXT >")
            }
        }
    }
    fileprivate var numberOfViews: Int {
        return inputViews.count
    }
    
    @objc func goBack() {
        if currentIndex != 0 {
            currentIndex -= 1
        }
    }
    
    @objc func goToNext() {
        if currentIndex != numberOfViews - 1 {
            currentIndex += 1
        }else {
            // the last one
            saveForNamePassword()
        }
    }
    
    // MARK: ------------- save and sign up
    fileprivate let loading = LoadingViewController()
    
    func saveForNamePassword() {
        // data assign
        // not login, new, for add
        if forSignUp {
            if forUser {
                user = UserObjModel()
            }else {
                pseudoUser = PseudoUserObjModel()
                pseudoUser.key = UUID().uuidString
            }
        }
        
        // name and icon
        if forUser {
            user.displayName = nameInputView.userName
            user.imageObj = nameInputView.userIcon
//            user.image =
        }else {
            pseudoUser.displayName = nameInputView.userName
            pseudoUser.name = nameInputView.userName
            pseudoUser.imageObj = nameInputView.userIcon
            pseudoUser.userKey = userCenter.loginUserObj.key
        }
        
        // age
        let dobString = dobInputView.dobString
        if forUser {
            user.dobString = dobString
        }else {
            pseudoUser.dobString = dobString
        }
        
        // sex, can be nil
        let gender = genderInputView.sexString
        if forUser {
            user.sex = gender
        }else {
            pseudoUser.sex = gender
        }
        
        // health state
        if forUser {
            user.state = overallInputView.result?.rawValue
        }else {
            pseudoUser.state = overallInputView.result?.rawValue
        }
     
        // local
        if localDB.database.open() {
            if forUser {
                user.saveToLocalDatabase()
            }else {
                 pseudoUser.saveToLocalDatabase()
            }
            
            localDB.database.close()
        }
        
        // upload
        if forUser {
            userAccountService = UserAccess(callback: self)
            present(loading, animated: true) {
                if self.forSignUp {
                    self.userAccountService.signUp(loginID: self.userName, password: self.password,userDetails: self.user)
                } else {
                    // change
                    self.userAccountService.updateOneByKey(key: self.user.key, oneData: self.user)
                }
            }
        }else {
            pseudoUser2Backend = PseudoUserAccess(callback: self)
            present(loading, animated: true) {
                if self.forSignUp {
                    self.pseudoUser2Backend.addOne(oneData: self.pseudoUser)
                } else {
                    // change
                    self.pseudoUser2Backend.updateOneByKey(key: self.pseudoUser.key, oneData: self.pseudoUser)
                }
            }
        }
    }
    
}

// REST
extension LoginUserInputViewController : DataAccessProtocal {
    func didFinishAddDataByKey(_ obj: AnyObject) {
        var message = "Please check the mailbox to activate"
        if !forUser {
            message = ""
            userCenter.addOrChangePseudoUser(pseudoUser, saveToLocal: true)
        }
        
        loading.dismiss(animated: true) {
            let alert = UIAlertController.init(title: "Register successfully.", message: message, preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .default) { (action) in
                // go back to login
               self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func failedAddDataByKey(_ error: String) {
        loading.dismiss(animated: true) {
            print(error)
            let alert = UIAlertController.init(title: "Failed to register.", message: "Please check your account name or net", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .default) { (action) in
                // go back to sign up
               self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didFinishUpdateDataByKey(_ obj: AnyObject) {
        loading.dismiss(animated: true) {
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    func failedUpdateDataByKey(_ error: String) {
        print(error)
        
        let alert = UIAlertController.init(title: error == unauthorized ? "You are not authorized due to overtime idleness" : "Failed to change.", message: "Please check your net", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default) { (action) in
            // go back to sign up
            if error == unauthorized {
                let login = LoginViewController.createFromNib()
                login.invokeFinishedClosure = self.saveForNamePassword
                self.dismiss(animated: true, completion: nil)
//                self.navigationController?.pushViewController(login, animated: true)
            }
        }
        
        alert.addAction(ok)
        
        loading.dismiss(animated: true) {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
