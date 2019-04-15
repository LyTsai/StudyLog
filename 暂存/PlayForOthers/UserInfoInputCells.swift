//
//  UserInfoInputCells.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let cellIDs = ["UserInfoNameCellID", "UserInfoAgeCellID","UserInfoGenderCellID", "UserInfoRaceCellID", "UserInfoOverallHealthCellID", "UserInfoRelationshipCellID"]
let processColor = UIColorFromRGB(139, green: 195, blue: 74)
let unProcessColor = UIColorGray(216)

let processImage = UIImage(named: "process_answered")
let unProcessImage = UIImage(named: "process_unAnswered")

// MARK: --------- name
class UserInfoNameCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var processImageView: UIImageView!
    @IBOutlet weak var processLineView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var hostTable: UserInfoInputTableView!
    fileprivate var name: String {
        return nameTextField.text ?? ""
    }
    
    class func cellWith(_ tableView: UITableView) -> UserInfoNameCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIDs[0]) as? UserInfoNameCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("UserInfoInputCells", owner: self, options: nil)?.first as? UserInfoNameCell
            cell?.nameTextField.delegate = cell
            cell!.hostTable = tableView as! UserInfoInputTableView
        }
        
        return cell!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endInput()
        return true
    }
    
    func endInput()  {
        processImageView.image = (name == "" ? unProcessImage : processImage)
        processLineView.backgroundColor = (name == "" ? unProcessColor : processColor)
        hostTable.userInfoResult.name = name
        endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endInput()
    }
    
}

// MARK: --------- Age
class UserInfoAgeCell: UITableViewCell {
    @IBOutlet weak var processImageView: UIImageView!
    @IBOutlet weak var processLineView: UIView!
    @IBOutlet weak var ageInputView: AgeInputView!
  
    weak var hostTable: UserInfoInputTableView!
    
    class func cellWith(_ tableView: UITableView) -> UserInfoAgeCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIDs[1]) as? UserInfoAgeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("UserInfoInputCells", owner: self, options: nil)?[1] as? UserInfoAgeCell
            cell!.ageInputView.hostCell = cell!
            cell!.hostTable = tableView as! UserInfoInputTableView
        }
        
        return cell!
    }
    
    func changeState()  {
        hostTable.userInfoResult.age = ageInputView.age
        
        if processImageView.image != processImage {
            processImageView.image = processImage
            processLineView.backgroundColor = processColor
        }
    }
}

// MARK: --------- Gender
class UserInfoGenderCell: UITableViewCell {
    @IBOutlet weak var processImageView: UIImageView!
    @IBOutlet weak var processLineView: UIView!
    @IBOutlet weak var genderInputView: GenderInputView!
    
    weak var hostTable: UserInfoInputTableView!
    
    class func cellWith(_ tableView: UITableView) -> UserInfoGenderCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIDs[2]) as? UserInfoGenderCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("UserInfoInputCells", owner: self, options: nil)?[2] as? UserInfoGenderCell
            cell!.genderInputView.hostCell = cell!
            cell!.hostTable = tableView as! UserInfoInputTableView
        }
        
        return cell!
    }
    
    func changeState()  {
        hostTable.userInfoResult.isMale = genderInputView.isMale
        if processImageView.image != processImage {
            processImageView.image = processImage
            processLineView.backgroundColor = processColor
        }
    }
}

// MARK: --------- Race
class UserInfoRaceCell: UITableViewCell {
    @IBOutlet weak var processLineView: UIView!
    @IBOutlet weak var processImageView: UIImageView!
    @IBOutlet weak var raceInputView: RaceInputCollectionView!

    weak var hostTable: UserInfoInputTableView!
    
    class func cellWith(_ tableView: UITableView) -> UserInfoRaceCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIDs[3]) as? UserInfoRaceCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("UserInfoInputCells", owner: self, options: nil)?[3] as? UserInfoRaceCell
            cell!.raceInputView.hostCell = cell!
            cell!.hostTable = tableView as! UserInfoInputTableView
        }
        
        return cell!
    }
    
    func changeState()  {
        hostTable.userInfoResult.race = raceInputView.selectedKey
        if processImageView.image != processImage {
            processImageView.image = processImage
            processLineView.backgroundColor = processColor
        }
    }
}

// MARK: --------- Overall Health
class UserInfoOverallHealthCell: UITableViewCell {
    @IBOutlet weak var processLineView: UIView!
    @IBOutlet weak var processImageView: UIImageView!
    @IBOutlet weak var overallHealthView: OverallHealthInputView!
  
    weak var hostTable: UserInfoInputTableView!
    
    class func cellWith(_ tableView: UITableView) -> UserInfoOverallHealthCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIDs[4]) as? UserInfoOverallHealthCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("UserInfoInputCells", owner: self, options: nil)?[4] as? UserInfoOverallHealthCell
            cell!.overallHealthView.hostCell = cell!
            cell!.hostTable = tableView as! UserInfoInputTableView
        }
        
        return cell!
    }
    
    func changeState()  {
        hostTable.userInfoResult.overallHealth = overallHealthView.result
        if processImageView.image != processImage {
            processImageView.image = processImage
            processLineView.backgroundColor = processColor
        }
    }
}

// MARK: --------- Relationship, placed at second row, but the last cell in XIB
class UserInfoRelationshipCell: UITableViewCell {
    @IBOutlet weak var processLineView: UIView!
    @IBOutlet weak var processImageView: UIImageView!
    @IBOutlet weak var relationshipCollectionView: AddAndChooseCollectionView!
    
    weak var hostTable: UserInfoInputTableView!
    
    class func cellWith(_ tableView: UITableView) -> UserInfoRelationshipCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIDs[5]) as? UserInfoRelationshipCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("UserInfoInputCells", owner: self, options: nil)?[5] as? UserInfoRelationshipCell
            cell!.relationshipCollectionView.hostCell = cell!
            cell!.hostTable = tableView as! UserInfoInputTableView
        }
        
        return cell!
    }
    
    func changeState() {
        hostTable.userInfoResult.relationship = relationshipCollectionView.relationship
        if relationshipCollectionView.relationship == nil {
            processImageView.image = unProcessImage
            processLineView.backgroundColor = unProcessColor
        }else if processImageView.image != processImage {
            processImageView.image = processImage
            processLineView.backgroundColor = processColor
        }
    }
}
