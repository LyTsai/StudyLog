//
//  PlayerDisplayCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/5.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let playerDisplayCellID = "player display cell Identifier"
class PlayerDisplayCell: UITableViewCell {
    @IBOutlet weak var mainShadowView: UIView!
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var chosenBackView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    fileprivate var userKey: String!
    fileprivate var isChosen = false
    fileprivate weak var playersTable: PlayersTableView!
    
    class func cellWithTableView(_ table: PlayersTableView, userKey: String, isChosen: Bool) -> PlayerDisplayCell {
        var cell = table.dequeueReusableCell(withIdentifier: playerDisplayCellID) as? PlayerDisplayCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PlayerDisplayCell", owner: self, options: nil)?.first as? PlayerDisplayCell
            cell!.setupBasic()
        }
        cell?.setupWithUserKey(userKey, isChosen: isChosen)
        cell?.playersTable = table
        
        return cell!
    }
    
    fileprivate func setupBasic() {
        avatar.layer.masksToBounds = true
        mainBackView.layer.masksToBounds = true
        
        mainShadowView.layer.addBlackShadow(4)
    }
    
    fileprivate func setupWithUserKey(_ userKey: String, isChosen: Bool) {
        self.userKey = userKey
        self.isChosen = isChosen
        
        if userKey == userCenter.loginKey {
            // is user
            deleteButton.isHidden = true
            
            let user = userCenter.loginUserObj
            nameLabel.text = user.displayName
            subLabel.text = user.loginId
            avatar.image = user.imageObj ?? ProjectImages.sharedImage.tempAvatar
        }else {
            deleteButton.isHidden = false
            
            let pseudoUser = userCenter.getPseudoUser(userKey)!
            nameLabel.text = pseudoUser.displayName
            subLabel.text = pseudoUser.sex
            avatar.image = pseudoUser.imageObj ?? ProjectImages.sharedImage.tempAvatar
        }
        
        setupWithChosenState()
    }
    
    fileprivate func setupWithChosenState() {
        let one = fontFactor
        
        let normalColor = UIColorFromHex(0x89B371)
            
        chosenBackView.isHidden = !isChosen
        checkmarkButton.layer.borderColor = isChosen ? UIColor.clear.cgColor : UIColorGray(155).cgColor
        checkmarkButton.setBackgroundImage(isChosen ? #imageLiteral(resourceName: "player_check") : nil, for: .normal)
        mainBackView.layer.borderWidth = isChosen ? 2 * one : one
        mainBackView.layer.borderColor = isChosen ? UIColorFromHex(0x008E3B).cgColor : normalColor.cgColor
        mainShadowView.layer.shadowColor = isChosen ? UIColor.black.cgColor : normalColor.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = fontFactor
        nameLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        subLabel.font = UIFont.systemFont(ofSize: 11 * one, weight: .medium)
        
        mainBackView.layer.cornerRadius = 4 * one
        avatar.layer.cornerRadius = avatar.bounds.width * 0.5
        mainBackView.layer.shadowOffset = CGSize(width: 0, height: 2 * one)
        
        checkmarkButton.layer.cornerRadius = self.checkmarkButton.frame.width * 0.5
        checkmarkButton.layer.borderWidth = one

        setupWithChosenState()
    }
    
    // actions
    @IBAction func chooseUser(_ sender: Any) {
        playersTable.setUserChosen(userKey)
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Delete Player", message: "All data will be deleted for this player", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Continue", style: .default) { (action) in
            self.playersTable.deleteUser(self.userKey)
        }
        
        deleteAlert.addAction(cancel)
        deleteAlert.addAction(ok)
        
        viewController.present(deleteAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func editUser(_ sender: Any) {
        let addUser = LoginUserInputViewController()
        addUser.forUser = (userKey == userCenter.loginKey)
        addUser.forSignUp = false
        addUser.pseudoUser = userCenter.getPseudoUser(userKey)
        navigation?.pushViewController(addUser, animated: true)
    }
}
