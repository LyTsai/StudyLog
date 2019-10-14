//
//  AddPeopleOrGroupView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
enum PlayerAddStyle {
    case addPeople, addGroup, addMembers
}

class AddPeopleOrGroupView: UIView {
    @IBOutlet weak var addNewButton: UIButton!
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var sepLine: UIView!
    
    @IBOutlet weak var peopleImageView: UIImageView!
    @IBOutlet weak var groupLabel: UILabel!
    
    fileprivate var addStyle: PlayerAddStyle!
    class func createFromNib() -> AddPeopleOrGroupView {
        return Bundle.main.loadNibNamed("AddPeopleOrGroupView", owner: self, options: nil)?.first as! AddPeopleOrGroupView
    }
    
    func usedToAdd(_ style: PlayerAddStyle) {
        addStyle = style
        
        var mainColor = UIColorFromHex(0xBFDEAF)
        if style == .addPeople {
            addNewButton.setBackgroundImage(#imageLiteral(resourceName: "addPeopleBack"), for: .normal)
            peopleImageView.isHidden = false
            groupLabel.isHidden = true
            backgroundColor = UIColorFromHex(0xE7F8DA)
        }else {
            addNewButton.setBackgroundImage((style == .addMembers) ? #imageLiteral(resourceName: "addMembersBack") : #imageLiteral(resourceName: "buildGroupBack"), for: .normal)
            groupLabel.text = (style == .addMembers) ? "Group Members" : "Groups"
            
            peopleImageView.isHidden = true
            groupLabel.isHidden = false
            
            backgroundColor = UIColorFromHex(0xE7FFFD)
            groupLabel.backgroundColor = backgroundColor
            mainColor = UIColorFromHex(0x9FE0DB)
        }
        
        topLine.backgroundColor = mainColor
        sepLine.backgroundColor = mainColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        groupLabel.font = UIFont.systemFont(ofSize: 12 * bounds.height / 90, weight: .medium)
    }
    
    @IBAction func addNew(_ sender: Any) {
        if addStyle == .addPeople || addStyle == .addMembers {
            let addUser = LoginUserInputViewController()
            addUser.forUser = false
            addUser.forSignUp = true
            navigation.pushViewController(addUser, animated: true)
        }else if addStyle == .addGroup {
            let addGroup = Bundle.main.loadNibNamed("UserGroupInfoViewController", owner: self, options: nil)?.first as! UserGroupInfoViewController
            addGroup.usedForAddGroup()
            navigation.pushViewController(addGroup, animated: true)
        }
    }
}
