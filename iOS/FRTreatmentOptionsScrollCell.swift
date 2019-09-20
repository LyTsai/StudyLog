//
//  FRTreatmentOptionsScrollCell.swift
//  BeautiPhi
//
//  Created by L on 2019/8/1.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

let treatmentOptionsScrollCellID = "Treatment Options Scroll Cell identifier"

class FRTreatmentOptionsScrollCell: UITableViewCell {
    var changeSelection: (()->Void)?
    
    fileprivate var columnRatios = [CGFloat]()
    class func cellWithTable(_ table: UITableView, option: FRTreatmentOptionModel, forSelection: Bool, ratios: [CGFloat]) -> FRTreatmentOptionsScrollCell {
        var cell = table.dequeueReusableCell(withIdentifier: treatmentOptionsScrollCellID ) as? FRTreatmentOptionsScrollCell
        if cell == nil {
            cell = FRTreatmentOptionsScrollCell(style: .default, reuseIdentifier: treatmentOptionsScrollCellID)
            cell?.addAll()
        }
        cell?.columnRatios = ratios
        cell?.setupWithOption(option, forSelection: forSelection)
        
        return cell!
    }
    
    fileprivate let edit = UIButton(type: .custom)
    fileprivate let priceLabel = UILabel()
    fileprivate let discountLabel = UILabel()
    fileprivate let qtyView = CustomPulldownSelectView()
    fileprivate let qtyLabel = UILabel()
    fileprivate let effectivenessLabel = UILabel()
    fileprivate let presistencyLabel = UILabel()
    fileprivate let waitTimeLabel = UILabel()
    fileprivate let recoveryTimeLabel = UILabel()
    fileprivate func addAll() {
        edit.setBackgroundImage(UIImage(named: "icon_edit"), for: .normal)
        edit.addTarget(self, action: #selector(editDiscount), for: .touchUpInside)
        
        selectionStyle = .none
        qtyView.setupWithTitle(title: "Qty", selections: ["1", "2", "3", "4", "5"], selectionIndex: 0)
        qtyView.selectIndex = qtyIsChosen
        
        // add all subViews
        addSubview(priceLabel)
        addSubview(edit)
        addSubview(discountLabel)
        addSubview(qtyLabel)
        addSubview(qtyView)
        addSubview(effectivenessLabel)
        addSubview(presistencyLabel)
        addSubview(waitTimeLabel)
        addSubview(recoveryTimeLabel)
    }
    
    
    fileprivate var option: FRTreatmentOptionModel!
    fileprivate func setupWithOption(_ option: FRTreatmentOptionModel, forSelection: Bool) {
        self.option = option
        qtyView.isHidden = !forSelection
        qtyLabel.isHidden = forSelection
        edit.isHidden = !forSelection
        
        priceLabel.text = "$ \(option.listPrice)"
        
        setDiscountLabel()
        qtyLabel.text = "\(option.qty)"
        qtyView.setSelectionIndex(option.qty - 1)
        
        if let product = collection.getProductByKey(option.productKey) {
            effectivenessLabel.text = stringDisplayForNumber(product.invasivenessDegree)
            presistencyLabel.text = stringDisplayForNumber(product.lastingDuration)
            waitTimeLabel.text = stringDisplayForNumber(product.waitTime)
            recoveryTimeLabel.text = stringDisplayForNumber(product.recoveryTime)
        }
    }
    
    fileprivate func setDiscountLabel() {
        if abs(option.discount) < 1e-6 {
            discountLabel.text = "0"
            discountLabel.textColor = UIColorGray(155)
        }else {
            discountLabel.text = "\(String(format: "%.f", option.discount * 100)) %"
            discountLabel.textColor = UIColorFromHex(0xF6A623)
        }
    }
    
    @objc func editDiscount() {
        let discountInput = Bundle.main.loadNibNamed("DiscoutInputViewController", owner: self, options: nil)?.first as! DiscoutInputViewController
        discountInput.setWithInput(option.discount, confirmAction: { (input) in
            self.option.discount = input / 100
            self.setDiscountLabel()
            if self.option.isChosen {
                self.changeSelection?()
            }
        })
        viewController.present(discountInput, animated: true, completion: nil)
    }
    
    fileprivate func stringDisplayForNumber(_ number: Any?) -> String {
        if number == nil {
            return ""
        }else {
            return "\(number!)"
        }
    }
    
    func qtyIsChosen(_ index: Int) {
        option.qty = index + 1
        qtyView.setSelectionIndex(index)
        changeSelection?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // layout
        let oneH = bounds.height / 40
        var startX: CGFloat = 0
        
        // labels
        let labels = [priceLabel, discountLabel, qtyLabel, effectivenessLabel, presistencyLabel, waitTimeLabel, recoveryTimeLabel]
        for (i, label) in labels.enumerated() {
            label.frame = CGRect(x: startX, y: 0, width: bounds.width * columnRatios[i], height: bounds.height).insetBy(dx: 10 * oneH, dy: 0)
            label.font = UIFont.systemFont(ofSize: 16 * oneH)
            
            if i == 2 {
                qtyView.frame = label.frame.insetBy(dx: 15 * fontFactor, dy: 20 * fontFactor)
            }
            
            if i == 1 {
                let editL = bounds.height * 0.25
                edit.frame = CGRect(center: CGPoint(x: label.frame.maxX - editL * 0.5, y: bounds.midY), length: editL)
                label.frame.size = CGSize(width: label.frame.size.width - editL, height: label.frame.size.height)
            }
            // for next
            startX += bounds.width * columnRatios[i]
        }
        priceLabel.font = UIFont.systemFont(ofSize: 18 * oneH, weight: .semibold)
        discountLabel.font = UIFont.systemFont(ofSize: 18 * oneH, weight: .semibold)
    }
}

