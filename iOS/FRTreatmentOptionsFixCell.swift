//
//  FRTreatmentOptionsFixCell.swift
//  BeautiPhi
//
//  Created by L on 2019/8/1.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

let treatmentOptionsFixCellID = "Treatment Options Fix Cell identifier"

class FRTreatmentOptionsFixCell: UITableViewCell {
    var changeSelection: (()->Void)?
    var checkFillColor = UIColorFromHex(0xFFDDDF)
    fileprivate var columnRatios = [CGFloat]()
    class func cellWithTable(_ table: UITableView, option: FRTreatmentOptionModel, forSelection: Bool, index: Int, ratios: [CGFloat], checkFillColor: UIColor) -> FRTreatmentOptionsFixCell {
        var cell = table.dequeueReusableCell(withIdentifier: treatmentOptionsFixCellID ) as? FRTreatmentOptionsFixCell
        if cell == nil {
            cell = FRTreatmentOptionsFixCell(style: .default, reuseIdentifier: treatmentOptionsFixCellID)
            cell?.addAll()
        }
        cell?.columnRatios = ratios
        cell?.setupWithOption(option, forSelection: forSelection, index: index, checkFill: checkFillColor)
        
        return cell!
    }
    
    fileprivate let checkButton = UIButton(type: .custom)
    fileprivate let unCheckButton = UIButton(type: .custom)
    fileprivate let sepLine = UIView()
    fileprivate let nameLabel = UILabel()
    fileprivate let detailButton = UIButton(type: .custom)
    fileprivate func addAll() {
        selectionStyle = .none
        
        unCheckButton.layer.borderColor = UIColor.black.cgColor
        unCheckButton.setTitleColor(UIColor.black, for: .normal)
        unCheckButton.titleLabel?.textAlignment = .center
        checkButton.setBackgroundImage(UIImage(named: "icon_productCheck"), for: .normal)

        checkButton.addTarget(self, action: #selector(cellCheckIsTouched), for: .touchUpInside)
        unCheckButton.addTarget(self, action: #selector(cellUncheckIsTouched), for: .touchUpInside)
        
        addSubview(unCheckButton)
        addSubview(checkButton)
        
        nameLabel.numberOfLines = 0
        addSubview(nameLabel)
       
        sepLine.backgroundColor = UIColorGray(151)
        addSubview(sepLine)
        // detail
        detailButton.setBackgroundImage(UIImage(named: "icon_query"), for: .normal)
        detailButton.addTarget(self, action: #selector(visitDetail), for: .touchUpInside)
        
        addSubview(detailButton)
    }
    
    fileprivate var option: FRTreatmentOptionModel!
    fileprivate func setupWithOption(_ option: FRTreatmentOptionModel, forSelection: Bool, index: Int, checkFill: UIColor) {
        self.option = option
        self.checkFillColor = checkFill
        
        if forSelection {
            unCheckButton.setTitle(nil, for: .normal)
            checkButton.isHidden = !option.isChosen
            unCheckButton.backgroundColor = option.isChosen ? checkFillColor : UIColor.white
        }else {
            checkButton.isHidden = true
            unCheckButton.setTitle("\(index + 1)", for: .normal)
        }
        unCheckButton.isUserInteractionEnabled = forSelection
        
        // product
        if let product = collection.getProductByKey(option.productKey) {
            nameLabel.text = product.name
        }
    }
    
    @objc func visitDetail() {
        viewController.showAlertMessage("", title: "NO detail", buttons: [("OK", nil)])
    }
    
    @objc func cellCheckIsTouched() {
        option.isChosen = false
        checkButton.isHidden = true
        changeSelection?()
        unCheckButton.backgroundColor = option.isChosen ? checkFillColor : UIColor.white
    }
    
    @objc func cellUncheckIsTouched() {
        option.isChosen = true
        checkButton.isHidden = false
        changeSelection?()
        unCheckButton.backgroundColor = option.isChosen ? checkFillColor : UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // layout
        let oneH = bounds.height / 40
        
        // first column
        let first = columnRatios[0] * bounds.width
        let checkLength = min(25 * oneH, first * 0.9)
        unCheckButton.frame = CGRect(center: CGPoint(x: first * 0.5, y: bounds.midY), length: checkLength)
        unCheckButton.layer.borderWidth = oneH
        let cOne = checkLength / 25
        checkButton.frame = CGRect(x: unCheckButton.frame.minX + 7 * cOne, y: unCheckButton.frame.minY - 2 * cOne, width: 27 * cOne, height: 22 * cOne)
        
        detailButton.frame = CGRect(x: bounds.width - 30 * oneH, y: bounds.height * 0.6, width: 20 * oneH, height: 20 * oneH)
        let startX = first + 10 * oneH
        nameLabel.frame = CGRect(x: startX, y: 0, width: detailButton.frame.minX - startX, height: bounds.height)
        nameLabel.font = UIFont.systemFont(ofSize: 18 * oneH)
        
        sepLine.frame = CGRect(x: bounds.width - oneH, y: 0, width: oneH, height: bounds.height)
    }
}

