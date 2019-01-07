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
        if let tabbar = tabBarController as? ABookTabBarController {
            tabbar.tireIndex = 2
        }
        
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
        button.contentHorizontalAlignment = .left
        
        return button
    }
    
    func adjustActButtonWithFrame(_ frame: CGRect) {
        self.frame = frame
        let margin = frame.height * 0.15
        titleEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        titleLabel?.font = UIFont.systemFont(ofSize: frame.height * 0.4, weight: UIFontWeightSemibold)
    }
}
