//
//  CelebrateViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/20.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CelebrateViewController: UIViewController {
    weak var presentFromVC: UIViewController!
    var edgeInsets = UIEdgeInsets(top: 68, left: 10, bottom: 55, right: 10)
    
    // private
    fileprivate var subMainFrame: CGRect {
        return CGRect(x: edgeInsets.left, y: edgeInsets.top, width: width - edgeInsets.left - edgeInsets.right, height: height - edgeInsets.top - edgeInsets.bottom)
    }
    fileprivate let dismissButton = UIButton(type: .custom)
    fileprivate let backView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        modalPresentationStyle = .overCurrentContext
   //     modalTransitionStyle = .crossDissolve
        
        // basic views
        // back
        backView.frame = subMainFrame
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 8
        view.addSubview(backView)
        
        // dismiss
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(UIImage(named: "Button-Unselected"), for: .normal)
        dismissButton.frame = CGRect(x: subMainFrame.maxX - 44, y: 22, width: 34, height: 34)
        view.addSubview(dismissButton)
    }

    // unloading data
    func showActivity() {
//        dismissButton.removeFromSuperview()
//        backView.removeFromSuperview()
        dismissButton.isHidden = true
        backView.isHidden = true
    }
    
    // celebarete
    fileprivate let playNew = UIButton.customActButton("Play a new game")
    fileprivate let playOtherRisk = UIButton.customActButton("Different game author")
    fileprivate let playForElse = UIButton.customActButton("Play for someone")
    fileprivate let forAct = UIButton.customActButton("What is in there")
    // #imageLiteral(resourceName: "check_greenWhite")
    fileprivate var iconViews = [UIImageView(image: ProjectImages.sharedImage.roundCheck), UIImageView(image: ProjectImages.sharedImage.roundCheck), UIImageView(image: ProjectImages.sharedImage.roundCheck), UIImageView(image: ProjectImages.sharedImage.roundCheck)] // four icons
    
    fileprivate var moreRisk = false
    func showCelebrate() {
        dismissButton.isHidden = false
        backView.isHidden = false
        
        for view in backView.subviews {
            view.removeFromSuperview()
        }
        backView.layer.sublayers = nil
        
        // frame infos
        let hMargin = 10 * subMainFrame.width / 355
        let vMargin = 15 * subMainFrame.height / 544
        
        let mainLength = subMainFrame.width - 2 * hMargin
        let titleHeight = subMainFrame.height * 0.06
        // title
        let titleLabel = UILabel(frame: CGRect(x: hMargin, y: vMargin, width: mainLength, height: titleHeight))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Congratulations \(UserCenter.sharedCenter.loginUserObj.displayName ?? "To You")!"
        titleLabel.font = UIFont.systemFont(ofSize: titleHeight * 0.6, weight: UIFontWeightMedium)
        
        // image
        let picHeight = subMainFrame.height * 0.4
        let imageView = UIImageView(frame: CGRect(x: hMargin, y: titleLabel.frame.maxY, width: mainLength, height: picHeight))
        imageView.image = UIImage(named: "celebrate_person")
        imageView.contentMode = .scaleAspectFit
        
        // des
        let desLabel = UILabel(frame: CGRect(x: hMargin, y: imageView.frame.maxY, width: mainLength, height: titleHeight))
        desLabel.numberOfLines = 0
        desLabel.textAlignment = .center
        desLabel.text = "Put it into Action!"
        
        // button frames
        let remainHeight = subMainFrame.height - desLabel.frame.maxY - vMargin * 2
        let gap = 0.05 * remainHeight
        let buttonWidth = mainLength * 0.75
        let buttonHeight = (remainHeight - 2.5 * gap) * 0.25
        let buttonX = (subMainFrame.width - buttonWidth) * 0.5

        let playNewFrame = CGRect(x: buttonX, y: desLabel.frame.maxY + vMargin, width: buttonWidth, height: buttonHeight)
        let offset = vMargin * 2
        let playRiskFrame = CGRect(x: buttonX + offset, y: playNewFrame.maxY + 0.5 * gap, width: buttonWidth - offset, height: buttonHeight)
        let playElseFrame = CGRect(x: buttonX, y: playRiskFrame.maxY + gap, width: buttonWidth, height: buttonHeight)
        let forActFrame = CGRect(x: buttonX, y: playElseFrame.maxY + gap, width: buttonWidth, height: buttonHeight)
        
        playNew.adjustActButtonWithFrame(playNewFrame)
        playOtherRisk.adjustActButtonWithFrame(playRiskFrame)
        playForElse.adjustActButtonWithFrame(playElseFrame)
        forAct.adjustActButtonWithFrame(forActFrame)
        
        let startX = playNewFrame.minX + offset * 0.3
        let radius = offset * 0.1
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: playNewFrame.maxY))
        path.addLine(to: CGPoint(x: startX, y: playRiskFrame.midY - radius))
        path.addArc(withCenter: CGPoint(x: startX + radius, y: playRiskFrame.midY - radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi) / 2, clockwise: false)
        path.addLine(to: CGPoint(x: playRiskFrame.minX, y: playRiskFrame.midY))
        
        let connect = CAShapeLayer()
        connect.path = path.cgPath
        connect.strokeColor = UIColorFromRGB(57, green: 181, blue: 74).cgColor
        connect.lineWidth = 1
        connect.fillColor = UIColor.clear.cgColor
        backView.layer.addSublayer(connect)
        
        // icon frames
        let iconLength = 0.6 * buttonHeight
        let iconMidX = gap * 0.6 + playNewFrame.maxX + 0.5 * iconLength
        iconViews[0].frame = CGRect(center: CGPoint(x: iconMidX, y: playNewFrame.midY), length: iconLength)
        iconViews[1].frame = CGRect(center: CGPoint(x: iconMidX, y: playRiskFrame.midY), length: iconLength)
        iconViews[2].frame = CGRect(center: CGPoint(x: iconMidX, y: playElseFrame.midY), length: iconLength)
        iconViews[3].frame = CGRect(center: CGPoint(x: iconMidX, y: forActFrame.midY), length: iconLength)
        
        // add all
        backView.addSubview(titleLabel)
        backView.addSubview(imageView)
        backView.addSubview(desLabel)
        backView.addSubview(playNew)
        backView.addSubview(playOtherRisk)
        backView.addSubview(playForElse)
        backView.addSubview(forAct)
        for iconView in iconViews {
            backView.addSubview(iconView)
        }
        
        // add actions
        playNew.addTarget(self, action: #selector(continueNextGame), for: .touchUpInside)
        playOtherRisk.addTarget(self, action: #selector(playAnotherAuthor), for: .touchUpInside)
        playForElse.addTarget(self, action: #selector(playForOthers), for: .touchUpInside)
        forAct.addTarget(self, action: #selector(toAct), for: .touchUpInside)
        
        // buttons for change views
        playNew.isSelected = true
        playOtherRisk.isSelected = false
        playForElse.isSelected = false
        forAct.isSelected = false
        
        // only one risk for this riskClass
        let currentRiskClassKey = RiskMetricCardsCursor.sharedCursor.selectedRiskClassKey!
        let currentNumber = AIDMetricCardsCollection.standardCollection.getModelsOfRiskClass(currentRiskClassKey, riskTypeKey: RiskMetricCardsCursor.sharedCursor.riskTypeKey).count
        if currentNumber == 1 {
            moreRisk = false
            playOtherRisk.isEnabled = false
        }else {
            moreRisk = true
        }
        
        setIconsState(0)
    }
    
    // MARK: -------- new design
    func showCelebrateB() {
        for sub in view.subviews {
            sub.removeFromSuperview()
        }
        
        backView.isHidden = false
        dismissButton.isHidden = false
        
        // white back
        var backFrame = CGRect(x: 15 * standWP, y: 173 * standHP, width: width - 30 * standWP, height: 375 * standHP)
        backView.frame = backFrame
        view.addSubview(backView)
        
        // person
        let personImageView = UIImageView(image: UIImage(named: "celebrate_icon"))
        personImageView.frame = CGRect(x: 9 * standWP, y: -59 * standHP, width: 133 * standWP, height: 148 * standHP)
        personImageView.contentMode = .scaleAspectFit
        backView.addSubview(personImageView)
        
        // dismiss
        dismissButton.setBackgroundImage(UIImage(named: "riskTypes_dismiss"), for: .normal)
        dismissButton.frame = CGRect(x: backFrame.width - 36 * standWP, y: 10 * standHP, width: 26 * standWP, height: 26 * standWP)
        backView.addSubview(dismissButton)

        // congratatulations
        let titleLabel = UILabel(frame: CGRect(x: 50 * standWP, y: 20 * standHP, width: backFrame.width - 100 * standWP, height: 54 * standHP))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Congratulations\n\(UserCenter.sharedCenter.loginUserObj.displayName ?? "To You")!"
        titleLabel.font = UIFont.systemFont(ofSize: 22 * standHP, weight: UIFontWeightBold)
        titleLabel.shadowColor = UIColor.white
        titleLabel.shadowOffset = CGSize(width: -2, height: 0)

        backView.addSubview(titleLabel)
        
        // other riskType
        let promptLabel = UILabel(frame: CGRect(x: 50 * standWP, y: titleLabel.frame.maxY + 4 * standHP, width: backFrame.width - 100 * standWP, height: 54 * standHP))
        promptLabel.textAlignment = .center
        promptLabel.numberOfLines = 0
        promptLabel.font = UIFont.systemFont(ofSize: 14 * standHP, weight: UIFontWeightMedium)
        backView.addSubview(promptLabel)
        
        let collection = AIDMetricCardsCollection.standardCollection
        let cursor = RiskMetricCardsCursor.sharedCursor
        
        var currentY = promptLabel.frame.maxY + 4 * standHP
        let tab = presentFromVC.tabBarController as! ABookTabBarController
        if tab.tireIndex != 2 {
            // no other riskTypes
            promptLabel.text = "You Can"
        }else {
            // add more
            promptLabel.text = "You can keep on with games for \(cursor.selectedRiskClass!.name!) in riskTypes: "
            
            // buttons
            var buttons = [CustomButton]()
            for riskType in collection.getAllRiskTypes() {
                if riskType.key == cursor.riskTypeKey {
                    continue
                }
                
                let button = CustomButton(type: .custom)
                button.key = riskType.key
                button.backImage = UIImage(named: "buttonBack_riskType")

                // break string
                let name = riskType.name ?? "iRa Risk"
                let index = name.index(name.startIndex, offsetBy: 3)
                let typeName = name.substring(to: index)
                let leftIndex = name.index(name.startIndex, offsetBy: 4)
                let leftString = name.substring(from: leftIndex)

                button.addTitle(leftString)
                button.addPrompt(typeName)

                button.addTarget(self, action: #selector(goToGame), for: .touchUpInside)
                buttons.append(button)
            }
            
            // buttons' frames
            let buttonSize = CGSize(width: 66 * min(standWP, standHP), height: 56 * min(standWP, standHP))
            let gap = 8 * standWP
            let buttonX = (backFrame.width - (buttonSize.width + gap) * CGFloat(buttons.count) + gap) * 0.5
            for (i, button) in buttons.enumerated() {
                button.frame = CGRect(x: buttonX + (buttonSize.width + gap) * CGFloat(i),y: currentY, width: buttonSize.width, height: buttonSize.height)
                
                let xMargin = 4 * buttonSize.width / 66
                button.labelFrame = CGRect(x: xMargin, y: xMargin * 0.5, width: buttonSize.width - 2 * xMargin, height: buttonSize.height * 0.36)
                button.promptFrame = CGRect(x: xMargin * 1.6, y: buttonSize.height * 0.37, width: buttonSize.width - 3.2 * xMargin, height: buttonSize.height * 0.39)
                button.textFont = UIFont.systemFont(ofSize: buttonSize.width * 0.15, weight: UIFontWeightSemibold)
                button.promptFont = UIFont.systemFont(ofSize: buttonSize.width * 0.22, weight: UIFontWeightBold)
                
                backView.addSubview(button)
            }
            
            currentY += buttonSize.height + 4 * standHP
            
            // or
            let orLabel = UILabel(frame: CGRect(x: 0, y: currentY, width: backFrame.width, height: 25 * standHP))
            orLabel.text = "or"
            orLabel.textAlignment = .center
            orLabel.textColor = UIColorGray(155)
            orLabel.font = UIFont.systemFont(ofSize: 14 * standHP, weight: UIFontWeightMedium)
            backView.addSubview(orLabel)
            
            currentY += 4 * standHP + orLabel.frame.height
        }

        // play new
        let currentX = 68 * standWP
        playNew.adjustActButtonWithFrame(CGRect(x: currentX, y: currentY, width: backFrame.width - 2 * currentX, height: 38 * standHP))
            backView.addSubview(playNew)
        playNew.addTarget(self, action: #selector(playNewGame), for: .touchUpInside)
        
        // play other risk
        
        
        


    }
    
    func goToGame(_ button: CustomButton)  {
        RiskMetricCardsCursor.sharedCursor.riskTypeKey = button.key
        RiskTypeDisplayModel.sharedRiskType.setupWithKey(button.key)
        
        // button is selected
        button.isSelected = true
        holdAndPush(IntroPageViewController())
    }
    
    func playNewGame() {
        playNew.isSelected = true
        
        let landing = ABookLandingPageViewController()
        landing.selectedRiskClass = RiskMetricCardsCursor.sharedCursor.selectedRiskClassKey
        holdAndPush(landing)
    }
    
    // set icon state
    fileprivate func setIconsState(_ index: Int) {
        for (i, iconView) in iconViews.enumerated() {
            if i != index {
                iconView.isHidden = true
            }else {
                iconView.isHidden = false
            }
        }
        
        if !moreRisk {
            // only one risk
            iconViews[1].image = UIImage(named: "end_lock")
            iconViews[1].isHidden = false
        }
    }
    
    // actions
    // dismiss and pushVC
    fileprivate func holdAndPush(_ vc: UIViewController) {
        if presentFromVC != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismissVC()
                self.presentFromVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func continueNextGame()  {
        playNew.isSelected = true
        playOtherRisk.isSelected = false
        playForElse.isSelected = false
        forAct.isSelected = false
        
        setIconsState(0)
        
        // landing, default as tire three
        let landing = ABookLandingPageViewController()
        landing.selectedRiskClass = RiskMetricCardsCursor.sharedCursor.selectedRiskClassKey
        holdAndPush(landing)
    }
    
    func playAnotherAuthor() {
        playNew.isSelected = false
        playOtherRisk.isSelected = true
        playForElse.isSelected = false
        forAct.isSelected = false
        
        setIconsState(1)
        holdAndPush(IntroPageViewController())
    }
    
    func playForOthers() {
        playNew.isSelected = false
        playOtherRisk.isSelected = false
        playForElse.isSelected = true
        forAct.isSelected = false
        
        setIconsState(2)
        holdAndPush(PlayForOthersViewController())
    }
    
    // act
    func toAct() {
        playNew.isSelected = false
        playOtherRisk.isSelected = false
        playForElse.isSelected = false
        forAct.isSelected = true
        
        setIconsState(3)
        holdAndPush(ToDoListViewController())
    }
    
     // MARK: ----------------------------
    
    // actions
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}

// for button
extension UIButton {
    class func customActButton(_ text: String) -> UIButton {
        let normalBack = UIImage(named: "act_un")
        let selectedBack = UIImage(named: "act_selected")
        
        let button = UIButton.customCenterTextButton(text, textColor: UIColor.black, selectedTextColor: UIColor.black, backImage: normalBack, selectedBackImage: selectedBack)
        button.setTitleColor(UIColorGray(216), for: .disabled)
//        button.contentHorizontalAlignment = .left
        
        return button
    }
    
    func adjustActButtonWithFrame(_ frame: CGRect) {
        self.frame = frame
        let margin = frame.height * 0.15
        titleEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        titleLabel?.font = UIFont.systemFont(ofSize: frame.height * 0.4, weight: UIFontWeightSemibold)
    }
}
