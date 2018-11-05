//
//  ButterflyOverallViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class ButterflyOverallViewController: UIViewController {
//    fileprivate var riskAccess: RiskAccess!
    
    fileprivate var riskTypeKey: String! {
        return cardsCursor.riskTypeKey
    }
 
    fileprivate var riskMetric: MetricObjModel! {
        return cardsCursor.selectedRiskClass
    }
    
    fileprivate let leftButton = CustomButton(type: .custom)
    fileprivate let rightButton = CustomButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
      
        cardsCursor.riskTypeKey = iCaKey
        
        // subviews
        // back
        let bgImageView = UIImageView(frame: view.bounds)
        bgImageView.image = UIImage(named: "BE_back")
        
        // top
        let topImage = UIImage(named: "BE_top")!
        let topImageView = UIImageView(image: topImage)
        topImageView.frame = CGRect(x: width * 0.02, y: topLength + 5 * standHP, width: width * 0.96, height: topImage.size.height / topImage.size.width * width * 0.96)
        
        // bottom
        let leftBtn = UIImage(named: "positiveBE_btn")!
        let buttonSize = CGSize(width: width * 0.42, height: leftBtn.size.height / leftBtn.size.width * width * 0.42)
        
        leftButton.key = positiveBEKey
        leftButton.setBackgroundImage(leftBtn, for: .normal)
        leftButton.addTarget(self, action: #selector(goToGame(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(center: CGPoint(x: width * 0.25, y: mainFrame.maxY - buttonSize.height * 0.5), width: buttonSize.width, height: buttonSize.height)

        rightButton.key = negativeBEKey
        rightButton.setBackgroundImage(UIImage(named: "negativeBE_btn"), for: .normal)
        rightButton.addTarget(self, action: #selector(goToGame(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(center: CGPoint(x: width * 0.75, y: mainFrame.maxY - buttonSize.height * 0.5), width: buttonSize.width, height: buttonSize.height)
        
        // text
        let font = UIFont.systemFont(ofSize: 14 * maxOneP, weight: UIFont.Weight.regular)
        let pString = "How the Butterfly Effect can Nurture Slow Biological Aging and Engender Healthspan"
        let nString = "Butterfly Effect can Inflame Fast Biological Aging and Ferment Chronic inflammation and Diseases (preventable or not)"
        var textSize = CGSize(width: width * 0.4, height: rightButton.frame.minY - topImageView.frame.maxY)
        let cString = (nString.count > pString.count ? nString : pString) as NSString
        textSize = cString.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size
        let labelY = leftButton.frame.minY - textSize.height * 0.5 - 4 * standHP
        let leftLabel = UILabel(frame: CGRect(center: CGPoint(x: width * 0.25, y: labelY), width: textSize.width, height: textSize.height))
        let rightLabel = UILabel(frame: CGRect(center: CGPoint(x: width * 0.75, y: labelY), width: textSize.width, height: textSize.height))

        leftLabel.numberOfLines = 0
        leftLabel.textColor = UIColor.white
        leftLabel.font = font
        leftLabel.textAlignment = .right
        leftLabel.text = pString
        
        rightLabel.numberOfLines = 0
        rightLabel.textColor = UIColor.white
        rightLabel.font = font
        rightLabel.text = nString
        
        leftLabel.adjustWithWidthKept()
        rightLabel.adjustWithWidthKept()
        
        // center
        let centerImageY = topImageView.frame.maxY - 20 * standHP
        let centerImageView = UIImageView(frame: CGRect(x: width * 0.05, y: centerImageY, width: width * 0.9, height: rightLabel.frame.minY - centerImageY))
        centerImageView.image = UIImage(named: "BE_center")
        centerImageView.contentMode = .scaleAspectFit
        
        // add
        view.addSubview(bgImageView)
        view.addSubview(centerImageView)
        view.addSubview(topImageView)
        
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
    }
    
    
    // view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "The Butterfly Effect"
    }
    
    @objc func goToGame(_ button: CustomButton) {
        cardsCursor.focusingRiskKey = button.key
//        GameTintApplication.sharedTint.gameTopic = button.key == negativeBEKey ? .negativeBE : .normal

            let riskAssess = CategoryViewController()
            navigationController?.pushViewController(riskAssess, animated: true)
    }
}


