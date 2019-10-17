//
//  MetricIntroductionViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class MetricIntroductionViewController: UIViewController {
  
    var buttonIsSelected: (() ->Void)?
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var imageBack: UIView!
    @IBOutlet weak var hintImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleStrokeLabel: UILabel!
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var detailBackView: UIView!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var bottomAssist: UIView!
    @IBOutlet weak var leftButton: GradientBackStrokeButton!
    @IBOutlet weak var rightButton: GradientBackStrokeButton!
    
    
    
    override func viewDidLoad() {
        backView.layer.cornerRadius = 8 * fontFactor
        bottomAssist.layer.cornerRadius = 8 * fontFactor
        bottomAssist.layer.masksToBounds = true
        
        imageBack.layer.borderWidth = 3 * fontFactor
        imageBack.layer.borderColor = UIColorFromHex(0xFFAB00).cgColor
        promptLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        introTextView.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
        
        detailBackView.layer.addBlackShadow(5 * fontFactor)
        detailBackView.layer.cornerRadius = 8 * fontFactor
        detailTextView.layer.borderWidth = 2 * fontFactor
        detailTextView.layer.cornerRadius = 4 * fontFactor
        
        let inset = 12 * fontFactor
        detailTextView.textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        detailTextView.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
        
        // bottom
        leftButton.setupWithTitle("Never Show")
        rightButton.setupWithTitle("Got It!")
        leftButton.isSelected = false
    }
    fileprivate var keyString = ""
    func setupWithRiskType(_ riskTypeKey: String, metricKey: String, keyString: String) {
        self.keyString = keyString
        let riskType = collection.getRiskTypeByKey(riskTypeKey)!
        let typeColor = riskType.realColor ?? tabTintGreen

        detailTextView.layer.borderColor = typeColor.cgColor
        titleLabel.textColor = typeColor
        
        // title
        let typeName = riskType.name!
        let titleAttributedString = NSMutableAttributedString(string: typeName[0..<3], attributes: [ .font : UIFont.systemFont(ofSize: 35 * fontFactor, weight: .heavy)])
        titleLabel.attributedText = titleAttributedString
        titleAttributedString.addAttributes([ .strokeColor: UIColor.black, .strokeWidth: NSNumber(value: 15)], range: NSMakeRange(0, 3))
        titleStrokeLabel.attributedText = titleAttributedString
        
        // prompt, 16Medium
        let mainName = typeName[4..<typeName.count]
        let promptAttributedString = NSMutableAttributedString(string: "individualized \(mainName) assessment", attributes: [ .font : UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)])
        promptAttributedString.addAttributes([.foregroundColor: typeColor], range: NSMakeRange(15, mainName.count))
        promptLabel.attributedText = promptAttributedString
        
        // 14 medium + heavy
        let riskTypeType = RiskTypeType.getTypeOfRiskType(riskTypeKey)
        var introDetail = ""
        var coreString = ""
        switch riskTypeType {
        case .iKa:
            introDetail = "Knowledge is power and empowering. Take back control with confidence."
            coreString = "quiz question"
        case .iRa:
            introDetail = "Ideally, prevention is primordial and begins with identifying your risk factors and how big are the risks to you. Assessing your individualized risk factors that accelerate your biological aging and predisposing you to a higher risk of age-related chronic diseases, you can take more targeted prevention actions."
            coreString = "risk factor"
        case .iAa, .iFa:
            introDetail = "Health is the sum of habits repeated everyday. Everyday is essentially a series of habits. Even small or mundane actions can have impact on your healthspan and how fast or slow you age, biologically. “Slow Aging By Design” is the accumulation of habits repeated daily."
            coreString = "corrective action"
        case .iSa:
            introDetail = "Do not focus on treating symptoms with drugs but Do focus on identifying them to provide clues and ferret out the underlying cause(s)."
            coreString = "symptom"
        case .iIa:
            introDetail = "Age-related diseases are often interconnected or clustered and can impact other diseases. The degree of the clustering impact varies by individuals. "
            coreString = "impact or clustering"
        case .iPa:
            introDetail = "Predictive scores are computed from analytical predictive models formulated by scientific or clinical studies."
            coreString = "predictive"
        case .iCa:
            introDetail = "Each individual can play an active role, starting as early as possible in life, to preventing or delaying the disease by adopting brain/heart healthy habits."
            coreString = "primary entry"
        default: break
        }
        
        var firstNumber = 0
        for (i, c) in introDetail.enumerated() {
            if c == "." || c == "," {
                firstNumber = i + 1
                break
            }
        }
        
        let introAttributedString = NSMutableAttributedString(string: introDetail, attributes: [ .font : UIFont.systemFont(ofSize: 16 * fontFactor, weight: .light)])
        introAttributedString.addAttributes([.foregroundColor: typeColor], range: NSMakeRange(0, firstNumber))
        introTextView.attributedText = introAttributedString
        
        // 14 medium + heavy
        let firstLine = "• In this game, each \(coreString) is a playing card.\n"
        let subStrings = ["• Each card will have multiple choice of descriptions.\n", "• Choose one of the descriptions for each card that best matches you.\n", "• Viola. It’s that easy."]
        let detailAttributedString = NSMutableAttributedString(string: firstLine, attributes: [ .font : UIFont.systemFont(ofSize: 14 * fontFactor, weight: .semibold)])
        detailAttributedString.addAttributes([.foregroundColor: typeColor], range: NSMakeRange(16, firstLine.count - 16))
        for subString in subStrings {
            detailAttributedString.append(NSAttributedString(string: subString, attributes: [.font : UIFont.systemFont(ofSize: 14 * fontFactor, weight: .bold)]))
        }
        detailTextView.attributedText = detailAttributedString
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomAssist.layoutSubviews()
        detailBackView.layoutSubviews()
        
        imageBack.layer.cornerRadius = imageBack.frame.width * 0.5
        
        let margin = 15 * fontFactor
        introTextView.placeTextMiddle(margin, right: margin)
        detailTextView.placeTextMiddle(margin, right: margin)
    }
    
    // never
    @IBAction func leftButtonTouched(_ sender: Any) {
        userDefaults.set(true, forKey: keyString)
        userDefaults.synchronize()
        goToIntro()
    }
    
    @IBAction func rightButtonTouched(_ sender: Any) {
        goToIntro()
    }
    
    fileprivate func goToIntro() {
        dismiss(animated: true) {
            self.buttonIsSelected?()
        }
    }
}
