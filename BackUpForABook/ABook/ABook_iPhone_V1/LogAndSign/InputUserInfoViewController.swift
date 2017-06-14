//
//  InputUserInfoViewController.swift
//  ABook_iPhone_V1
//
//  Created by dingf on 17/1/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import ABookData

class InputUserInfoViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var profession: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var race: UITextField!
    @IBOutlet weak var sex: UITextField!
    
    
    fileprivate var infoDic = [String: Any]()
    var userName: String?
    var statusBar: UIImageView!
    var editingTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        GUIInit()
        address.delegate = self
        country.delegate = self
        city.delegate = self
        user.delegate = self
        age.delegate = self
        name.delegate = self
        email.delegate = self
        profession.delegate = self
        state.delegate = self
        race.delegate = self
        sex.delegate = self
        
        user.text = userName
        name.text = userName
        email.text = userName
        
        infoDic["user"] = userName
        infoDic["name"] = userName
        infoDic["email"] = userName
        
        // keyboard show or hide notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        editingTextField = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        editingTextField = nil
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func GUIInit(){
        statusBar = UIImageView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: UIScreen.main.bounds.width, height: 20)))
        statusBar.image = UIImage.init(named: "title")
        
        view.addSubview(statusBar)
        saveButton.layer.cornerRadius = 5.0
        saveButton.layer.masksToBounds = true
        
        user.isEnabled = false
        name.isEnabled = false
        email.isEnabled = false
    }
    
    // keyboard show
    func keyboardWillShow(_ notification:Notification){
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        let topToKeyboard = view.frame.size.height - keyboardSize.height
        let topToTextField = editingTextField.frame.origin.y + editingTextField.frame.size.height
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
    
    @IBAction func save(_ sender: Any) {
        infoDic["address"] = address.text
        infoDic["city"] = city.text
        infoDic["country"] = country.text
        infoDic["age"] = age.text
        infoDic["sex"] = sex.text
        infoDic["race"] = race.text
        infoDic["state"] = state.text
        infoDic["profession"] = profession.text
        let userinfo = UserInfo.fromDictionary(infoDic) as! UserInfo
        let user = User.addUser(userName!, displayName: userName!)
        user?.loginID = userName
        user?.userInfo = userinfo
        DbUtil.saveContext()
        DbUtil.saveUserData()
        
        //
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tabbar = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! ABookTabBarController
        self.present(tabbar, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
 }
