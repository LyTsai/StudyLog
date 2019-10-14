//
//  UserGroupInfoViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class UserGroupInfoViewController: UIViewController, UITextViewDelegate {
 
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var groupMemberTable: ChangeGroupMemberTableView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: GradientBackStrokeButton!
    @IBOutlet weak var finishButton: GradientBackStrokeButton!
    
    fileprivate var forAdd = true
    fileprivate var group = UserGroupObjModel()
    
    class func initFromNib() -> UserGroupInfoViewController {
        let vc = Bundle.main.loadNibNamed("UserGroupInfoViewController", owner: self, options: nil)?.first as! UserGroupInfoViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextView.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .semibold)
        detailTextView.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        
        cancelButton.setupWithTitle("Cancel")
        cancelButton.isSelected = false
        finishButton.setupWithTitle("Finish")
        
        nameTextView.delegate = self
        detailTextView.delegate = self
       
    }
    
    func usedForAddGroup() {
        forAdd = true
        
        navigationItem.title = "Add Group"
        editButton.isHidden = true
        bottomView.isHidden = false
        nameTextView.isEditable = true
        detailTextView.isEditable = true
        groupMemberTable.setForReadOnly(false)
        groupMemberTable.updateWithMembers([])
    }
    
    func setupGroup(_ group: UserGroupObjModel) {
        self.group = group
        self.forAdd = false
        
        navigationItem.title = group.name
        editButton.isHidden = false
        bottomView.isHidden = true
        nameTextView.text = group.name
//        detailTextView.text = group.info
        groupMemberTable.setForReadOnly(true)
        groupMemberTable.updateWithMembers(group.members)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if forAdd {
            groupMemberTable.updateWithMembers([])
        }else {
            groupMemberTable.updateWithMembers(group.members)
        }
    }
    
    @IBAction func chooseIcon(_ sender: Any) {
        
    }
    
    @IBAction func cancelIsTouched(_ sender: Any) {
        // do nothing
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishIsTouched(_ sender: Any) {
        if forAdd {
            group = UserGroupObjModel()
            group.key = UUID().uuidString
            group.userKey = userCenter.loginKey
        }
        
        group.name = nameTextView.text
        group.members = groupMemberTable.members
        
        userCenter.addOrChangeUserGroup(group, saveToLocal: true)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startToEdit(_ sender: Any) {
        nameTextView.isEditable = true
        detailTextView.isEditable = true
        bottomView.isHidden = false
        groupMemberTable.setForReadOnly(false)
        groupMemberTable.reloadData()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if forAdd {
            textView.text = ""
        }
        duringEdit = true
        groupMemberTable.isUserInteractionEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if forAdd && textView.text == "" {
            if textView.tag == 100 {
                textView.text = "Input the name of group..."
            }else {
                textView.text = "Add description here...\nChoose members from the list below"
            }
        }
    }
    fileprivate var duringEdit = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if duringEdit {
            self.view.endEditing(true)
            groupMemberTable.isUserInteractionEnabled = true
        }

    }
}
