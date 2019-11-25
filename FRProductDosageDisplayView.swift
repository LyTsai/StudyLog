//
//  FRProductDosageDisplayView.swift
//  BeautiPhi
//
//  Created by L on 2019/11/12.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

class FRProductDosageDisplayView: UIView {
    var doseIsChanged: ((Float)->Void)?
    
    fileprivate let dosageLabel = UILabel()
    fileprivate let percentLabel = UILabel()
    fileprivate let dosageBack = CAShapeLayer()
    fileprivate let hintArrow = UIImageView(image: UIImage(named: "arrow_down"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        backgroundColor = UIColor.white
        layer.borderColor = UIColorFromHex(0xB2BCCA).cgColor
        layer.masksToBounds = true
        
        percentLabel.textColor = UIColorFromHex(0x689F38)
        
        dosageBack.strokeColor = UIColorGray(151).cgColor
        dosageBack.fillColor = UIColor.white.cgColor
        
        dosageLabel.textAlignment = .center
        percentLabel.textAlignment = .center
        
        hintArrow.contentMode = .scaleAspectFit
        
        layer.addSublayer(dosageBack)
        addSubview(dosageLabel)
        addSubview(percentLabel)
        addSubview(hintArrow)
        
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(editDose))
//        addGestureRecognizer(tapGR)
    }
    
    func setState(_ editale: Bool) {
        hintArrow.isHidden = !editale
        isUserInteractionEnabled = editale
    }
    
    var base: Float = 0
    var dose: Float = 0
    var unit: String = ""
    var percent: Float = 0
    func setupWithBase(_ base: Float, dose: Float, unit: String) {
        self.base = base
        self.dose = dose
        self.unit = unit
        
        dosageLabel.text = "\(String(format: "%.1f", dose))\(unit)"
        percent = 100
        if abs(base - 1e-6) > 0 {
            percent = dose / base * 100
        }
        percentLabel.text = "\(String(format: "%.0f", percent))%"
    }
    
//    @objc func editDose() {
//        var frameOnVC = self.frame
//        var nextView = self.superview
//        while nextView != nil {
//            if let responder = nextView!.next {
//                if let view = responder as? UIView {
//                    frameOnVC = view.convert(frameOnVC, from: nextView)
//                }else {
//                    break
//                }
//                nextView = nextView!.superview
//            }
//        }
//
//
//
//        let locationOnVC = self.viewController.view.convert(self.frame, from: self.superview!)
//        print(frameOnVC)
//        print(locationOnVC)
//
//        //        else {
//        //            let current = option == nil ? orderItem.dosage : option.dosage
//        //            let suggested = option == nil ? orderItem.suggestedDosage : option.suggestedDosage
//        //            var displayInput = suggested
//        //            if Int(displayInput ?? 0) != 0 && suggested != nil && current != nil {
//        //                displayInput = current! / displayInput!
//        //            }
//        //            inputVC.setForPercentInputWithTitle("Enter Percent for Your Dose", input: displayInput) { (input) in
//        //                let result = max(0, input * (suggested ?? 0))
//        //                if abs(result - (current ?? 0)) > 1e-6 {
//        //                    if self.option != nil {
//        //                        self.option.dosage = result
//        //                    }else {
//        //                        self.orderItem.dosage = result
//        //                    }
//        //
//        //                    self.changeIsMade?()
//        //                }
//        //            }
//        //        }
//    }
    
    func layoutWithOneH(_ oneH: CGFloat) {
      
        let radius = 2 * oneH
        layer.borderWidth = oneH
        layer.cornerRadius = radius
        
        let percentFrame =  CGRect(x: 0, y: 0, width: bounds.width * 0.46, height: bounds.height)
        let arrowL = 8 * oneH
        hintArrow.frame = CGRect(x: percentFrame.maxX - arrowL - 2 * oneH, y: bounds.midY - arrowL * 0.5, width: arrowL, height: arrowL)
        percentLabel.frame = CGRect(x: 0, y: 0, width: hintArrow.frame.minX, height: bounds.height).insetBy(dx: oneH, dy: 0)
        percentLabel.font = UIFont.systemFont(ofSize: 12 * oneH, weight: .medium)
        
        let dosageFrame = CGRect(x: percentFrame.maxX, y: 0, width: bounds.width - percentFrame.maxX, height: bounds.height)
        dosageBack.path = UIBezierPath(roundedRect: dosageFrame, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        dosageBack.lineWidth = oneH
        dosageLabel.frame = dosageFrame
        dosageLabel.font = UIFont.systemFont(ofSize: 16 * oneH)
    }
}
