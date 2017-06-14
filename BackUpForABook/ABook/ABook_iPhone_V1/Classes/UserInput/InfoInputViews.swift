//
//  UserInfoInputViews.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class InfoInputView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//    var result: (number: Float?, unit: String?) {
//        let number = NSString(string: inputTextField.text)
//            
//            inputTextField.text as! NSString
//        String
//        return (number?.floatValue, units[unitIndex])
//    }
    weak var hostDelegate: InfoInputViewController!
    class func createWithFrame(_ frame: CGRect, title: String, units: [String]) -> InfoInputView {
        let inputView = InfoInputView(frame: frame)
        inputView.updateUI()
        inputView.setupWithTitle(title, units: units)
        
        return inputView
    }
    
    func setupWithTitle(_ title: String, units: [String]) {
        titleLabel.text = title
        unitLabel.text = units.first
        self.units = units
    }
    
    // MARK: ----------- private ---------------
    fileprivate let mainColor = UIColorFromRGB(123, green: 186, blue: 7)
    fileprivate var units = [String]() {
        didSet{
            if units != oldValue {
                unitTable.reloadData()
            }
        }
    }
    fileprivate var unitIndex = 0 {
        didSet{
            if unitIndex != oldValue {
                unitLabel.text = units[unitIndex]
                unitTable.reloadRows(at: [IndexPath(row: unitIndex, section: 0),
                                          IndexPath(row: oldValue, section: 0)],
                                     with: .automatic)
            }
        }
    }
    
    // subviews
    fileprivate let titleLabel = UILabel()
    fileprivate let inputTextField = UITextField()
    fileprivate let unitLabel = UILabel()
    fileprivate let headerBackView = UIView()
    fileprivate let headerLabel = UILabel()
    fileprivate let headerImageView = UIImageView()
    fileprivate let headerLineView = UIView()
    fileprivate var unitTable: UITableView!
    fileprivate let saveButton = UIButton.customNormalButton("Save")
    
    // methods
    fileprivate func updateUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        // title
        titleLabel.backgroundColor = UIColorGray(240)
        titleLabel.textAlignment = .center

        // input
        inputTextField.keyboardType = .decimalPad
        inputTextField.textColor = mainColor
        inputTextField.textAlignment = .center
        inputTextField.layer.borderColor = mainColor.cgColor
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.cornerRadius = 5
        
        // unitLabel
        unitLabel.textColor = mainColor
        
        // table
        // header part
        headerBackView.backgroundColor = UIColor.clear
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(changeState))
        headerBackView.addGestureRecognizer(tapGR)
        
        headerLabel.text = "Unit"
        headerLabel.textAlignment = .right
        
        headerImageView.image = UIImage(named: "arrow_down")
        headerImageView.contentMode = .scaleAspectFit
        
        headerLineView.backgroundColor = UIColorGray(193)
        
        headerBackView.addSubview(headerLabel)
        headerBackView.addSubview(headerImageView)
        headerBackView.addSubview(headerLineView)
        
        // table part
        unitTable = UITableView(frame: CGRect.zero, style: .plain)
        if unitTable.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            unitTable.separatorInset = UIEdgeInsets.zero
        }
        if unitTable.responds(to: #selector(setter: UIView.layoutMargins)) {
            unitTable.layoutMargins = UIEdgeInsets.zero
        }
        unitTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0.1))
    
        // button
        saveButton.addTarget(self, action: #selector(saveResult), for: .touchUpInside)
        
        // delegate
        inputTextField.delegate = self
        unitTable.delegate = self
        unitTable.dataSource = self
        
        // add
        addSubview(titleLabel)
        addSubview(inputTextField)
        addSubview(unitLabel)
        addSubview(unitTable)
        addSubview(headerBackView)
        addSubview(saveButton)
    }
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return units.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unitCellID = "unit cell identifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: unitCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: unitCellID)
            cell?.textLabel?.textColor = mainColor
            cell?.tintColor = UIColorFromRGB(0, green: 190, blue: 71)
            cell?.selectionStyle = .none
        }
        
        if indexPath.row == unitIndex {
            cell?.accessoryType = .checkmark
        }else {
            cell?.accessoryType = .none
        }
        cell?.textLabel?.text = units[indexPath.row]
        
        return cell!
    }
    
    // delegate
    // textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let expression = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: aString, options:.reportProgress, range: NSMakeRange(0, (aString as NSString).length))
        
        return numberOfMatches != 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    // table
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        unitIndex = indexPath.item
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // title
        let titleHeight = bounds.height * 0.154 // also the bottom height
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: titleHeight)
        titleLabel.font = UIFont.systemFont(ofSize: titleHeight * 0.35, weight: UIFontWeightSemibold)
        
        // textField
        let inputWidth = 0.43 * bounds.width
        let inputHeight = 0.135 * bounds.height
        let inputFrame = CGRect(center: CGPoint(x: bounds.midX, y: 0.3 * bounds.height), width: inputWidth, height: inputHeight)
        inputTextField.frame = inputFrame
        
        // unitLabel
        let unitLabelHeight = 0.4 * inputHeight
        unitLabel.frame = CGRect(x: inputFrame.maxX * 1.02, y: inputFrame.maxY - unitLabelHeight, width: bounds.width - inputFrame.maxX * 1.02, height: unitLabelHeight)
        unitLabel.font = UIFont.systemFont(ofSize: unitLabelHeight * 0.7)

        // table header
        let gap = 0.05 * bounds.height
        let headerHeight = inputHeight * 0.5
        headerBackView.frame = CGRect(x: bounds.midX - inputWidth * 0.5, y: gap + inputFrame.maxY, width: inputWidth, height: headerHeight)
        headerLabel.frame = CGRect(x: 0, y: 0, width: inputWidth * 0.6, height: headerHeight - 1)
        headerImageView.frame = CGRect(x: headerLabel.frame.maxX + gap * 0.5, y: headerHeight * 0.5 - 1, width: headerHeight * 0.5, height: headerHeight * 0.5)
        headerLineView.frame = CGRect(x: 0, y: headerHeight - 1, width: inputWidth, height: 1)
        
        // table
        unitTable.frame = CGRect(x: bounds.midX - inputWidth * 0.5, y: headerBackView.frame.maxY , width: inputWidth, height: bounds.height - headerBackView.frame.maxY - titleHeight)
    
        // button
        saveButton.adjustNormalButton(CGRect(x: bounds.midX - inputWidth * 0.6, y: bounds.height - titleHeight, width: inputWidth * 1.2, height: inputHeight))
    }
    
    // action
    func changeState() {
        endEditing(true)
        
        unitTable.isHidden = !unitTable.isHidden
        headerImageView.transform = headerImageView.transform.rotated(by: CGFloat(M_PI))
        headerLineView.isHidden = unitTable.isHidden
    }
    
    func saveResult()  {
        
        if inputTextField.text != nil {
            let numberString = NSString(string: inputTextField.text!)
            let number = numberString.floatValue
            
            if number == 0.0 {
                alertForInput()
            }else {
                print(number)
                print(units[unitIndex])
                if hostDelegate != nil {
                    hostDelegate.slideView.moveToNextView()
                }
            }
            
        } else {
            alertForInput()
        }
        
    }
    
    fileprivate func alertForInput() {
        print("wrong input")
    }
}
