//
//  AssessGuideAletrts.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/17.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// factroy for guide alert
class AssessGuideAlertController: UIViewController{
    
    var alertLength: CGFloat {
        return 335 / 667 * height
    }
    
    var alertView = UIView()
    
    fileprivate var standardOneP : CGFloat {
        return alertLength / 335
    }
    
    var mainAreaFrame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        modalPresentationStyle = .overCurrentContext
        
        mainAreaFrame = CGRect(x: (width - alertLength) * 0.5, y: 140 * height / 667, width: alertLength, height: alertLength)
        alertView.frame = mainAreaFrame
        alertView.layer.cornerRadius = 10
        alertView.backgroundColor = UIColorGray(252)
        
        view.addSubview(alertView)
        alertView.clipsToBounds = true
    }
    
    fileprivate var standardHeight: CGFloat {
        return 44 * standardOneP
    }
    fileprivate var margin: CGFloat {
        return 10 * standardOneP
    }
    
    // kinds of alerts
    func useWelcomeAlert() {
        alertView.backgroundColor = UIColor.white
        
        let titleLabel = createTitleWithText("Welcome to the Game")
        let downFrame = CGRect(x: -1, y: alertLength - standardHeight, width: alertLength + 2, height: standardHeight + 1)
        let downButton = createButton(downFrame, text: "Never Remind")
        
        let upFrame = CGRect(x: -1 , y: alertLength - 2 * standardHeight, width: alertLength + 2, height: standardHeight + 0.5)
        let upButton = createButton(upFrame, text: "I understand")
        
        let teacher = UIImageView(frame: CGRect(x: margin, y: 117 * standardOneP, width: 97.97 * standardOneP, height: 122 * standardOneP))
        teacher.image = UIImage(named: "teacher_left")
        let computer = UIImageView(frame: CGRect(x: 184 * standardOneP, y: 61 * standardOneP, width: 63 * standardOneP, height: 50 * standardOneP))
        computer.image = UIImage(named: "computer_arrow")
        let desLabel = UILabel(frame: CGRect(x: 130 * standardOneP, y: 130 * standardOneP, width: 176 * standardOneP, height: 80 * standardOneP))
        desLabel.text = "Some cards maight be skiped based on other games you played"
        desLabel.numberOfLines = 0
        
        // add views and actions
        alertView.addSubview(titleLabel)
        
        alertView.addSubview(teacher)
        alertView.addSubview(computer)
        alertView.addSubview(desLabel)
        
        alertView.addSubview(upButton)
        alertView.addSubview(downButton)
        
        downButton.addTarget(self, action: #selector(notShowAgain), for: .touchUpInside)
        upButton.addTarget(self, action: #selector(showGuidesOfCards), for: .touchUpInside)
    }
    
    func useJudgementGuide() {
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        view.gestureRecognizers = nil
        
        let topHeight = mainAreaFrame.maxY / 2
        
        let teacherView = UIImageView(frame: CGRect(x: 2 * margin, y: margin + topHeight, width: 77.09 * standardOneP , height: 96 * standardOneP))
        teacherView.image = UIImage(named: "teacher_left")
        teacherView.contentMode = .scaleAspectFit
        
        let guideLength = 60 * standardOneP
        
        let guideView = UIImageView(frame: CGRect(x: (width - guideLength) * 0.5, y: margin * 0.5 + topHeight, width: guideLength, height: guideLength))
        guideView.image = UIImage(named: "horizontalIndi")
        
        let labelWidth = 198 * standardOneP
        let label = UILabel(frame: CGRect(x: (width - labelWidth) * 0.5, y: guideView.frame.maxY + margin, width: labelWidth, height: 50 * standardOneP))
        label.text = "可左右滑动切换卡片\n Tap to Hide Guide"
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        view.addSubview(teacherView)
        view.addSubview(guideView)
        view.addSubview(label)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        view.addGestureRecognizer(tapGR)
    }
    
    func useStackMultipleGuide() {
        for view in view.subviews {
            view.removeFromSuperview()
        }
        view.gestureRecognizers = nil
        
        let topHeight = mainAreaFrame.minY
        
        let teacherView = UIImageView(frame: CGRect(x: 2 * margin, y: margin + topHeight, width: 77.09 * standardOneP , height: 96 * standardOneP))
        teacherView.image = UIImage(named: "teacher_left")
        teacherView.contentMode = .scaleAspectFit
        
        let guideLength = 60 * standardOneP
        
        let guideView = UIImageView(frame: CGRect(x: (width - guideLength) * 0.5, y: margin * 0.5 + topHeight, width: guideLength, height: guideLength))
        guideView.image = UIImage(named: "verticalIndi")
        
        let labelWidth = 200 * standardOneP
        let label = UILabel(frame: CGRect(x: (width - labelWidth) * 0.5, y: guideView.frame.maxY + margin, width: labelWidth, height: 200 * standardOneP))
        label.text = "Answer until you choose \"Yes\"\n swipe up to get card back\n Tap to Hide Guide"
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        view.addSubview(teacherView)
        view.addSubview(guideView)
        view.addSubview(label)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        view.addGestureRecognizer(tapGR)
    }
    
    
    // MARK: ------------------ use for answers
    
    fileprivate var mainLength: CGFloat {
        return width - 2 * margin
    }
    
    fileprivate let dismissButton = UIButton(type: .custom)
    
    // MARK: -----------------------------------
    func useInterruptAlert() {
        alertView.backgroundColor = UIColor.white
        
        let oldFrame = alertView.frame
        alertView.frame = CGRect(x: oldFrame.minX, y: oldFrame.midY, width: alertLength, height: alertLength * 0.5)
        
        // teacher_left
        let margin =  20 * standardOneP
        let imageView = UIImageView(frame: CGRect(x: margin, y: margin, width: 77.09 * standardOneP , height: 96 * standardOneP))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "teacher_left")

        let desX = margin * imageView.frame.maxX
        
        let desLabel = UILabel(frame: CGRect(x: desX, y: margin, width: alertLength - desX - margin, height: alertLength * 0.5 - margin - standardHeight))
        desLabel.numberOfLines = 0
        desLabel.text = "\"This game is not completed yet,Do you still want to exit?\""
        
        let buttons = createHorizontalButtonsWith("Cancel", rightText: "OK", superHeight: alertLength * 0.5)
        buttons.left.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        buttons.right.addTarget(self, action: #selector(exitGame), for: .touchUpInside)
        
        alertView.addSubview(imageView)
        alertView.addSubview(desLabel)
        
        alertView.addSubview(buttons.left)
        alertView.addSubview(buttons.right)
    }

    // MARK: ----------------------------
    // title
    fileprivate func createTitleWithText(_ text: String) -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: margin, width: alertLength, height: standardHeight))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = text
        titleLabel.font = UIFont.systemFont(ofSize: standardHeight * 0.5, weight: UIFontWeightSemibold)
        
        return titleLabel
    }
    
    // buttons with same style
    fileprivate func createButton(_ frame: CGRect, text: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.setTitle(text, for: .normal)
        button.setTitleColor(lightGreenColor, for: .normal)
        
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: frame.height / 3)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        return button
    }
    
    // two horizontal buttons
    fileprivate func createHorizontalButtonsWith(_ leftText: String, rightText: String, superHeight: CGFloat) -> (left: UIButton, right: UIButton) {
        let leftFrame = CGRect(x: -1, y: superHeight - standardHeight, width: alertLength / 2 + 1, height: standardHeight + 1)
        let rightFrame = CGRect(x: alertLength / 2 - 0.5, y: superHeight - standardHeight - 1, width: alertLength / 2 + 1, height: standardHeight + 1)
        
        let leftButton = createButton(leftFrame, text: leftText)
        let rightButton = createButton(rightFrame, text: rightText)
        
        return (left: leftButton, right: rightButton)
    }

    // actions
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    func notShowAgain() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(false, forKey: "welcome never Shows")
        userDefaults.synchronize()
        
        showGuidesOfCards()

    }
    
    func showGuidesOfCards() {
        let userDefaults = UserDefaults.standard
        let stackjudgementKey = "stack judgement card showed"
        let stackMultipleChoiceKey = "stack MultipleChoice card showed"
     
        let factory = VDeckOfCardsFactory.metricDeckOfCards
        if factory.totalNumberOfItems() != 0 {
            let cardStyle = factory.getVCard(0)
            if cardStyle?.cardStyleKey == JudgementCardTemplateView.styleKey() && userDefaults.object(forKey: stackjudgementKey) == nil {
                useJudgementGuide()
                
                userDefaults.set(true, forKey: stackjudgementKey)
                userDefaults.synchronize()
                return
            }else if cardStyle?.cardStyleKey == SpinningMultipleChoiceCardsTemplateView.styleKey() && userDefaults.object(forKey: stackMultipleChoiceKey) == nil  {
                useStackMultipleGuide()
                
                userDefaults.set(true, forKey: stackMultipleChoiceKey)
                userDefaults.synchronize()
            }
        }
        
        dismissVC()
    }
    
    func exitGame() {
        dismissVC()
    }
}
