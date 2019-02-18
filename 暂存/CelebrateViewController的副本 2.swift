//
//  CelebrateViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/17.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
class CelebrateViewController: UIViewController {
    weak var presentFromVC: UIViewController!
    
    // sub
    fileprivate let dismissButton = UIButton(type: .custom)
    fileprivate let backView = UIView()
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        modalPresentationStyle = .overCurrentContext
        
        // back
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 8
        // dismiss
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.rectCrossDismiss, for: .normal)
        
        setupCelebrateView()
        
//        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // if the other tab's item is touched
        dismissVC()
    }
    
    // unloading data
    func showActivity() {
        backView.isHidden = true
    }
    
    func showCelebrate() {
        backView.isHidden = false
    }
    var score: Float = 0
    fileprivate var buttons = [UIButton]()
    fileprivate var roadView: OptionItemsRoad!
    fileprivate let riskIconView = UIImageView()
    fileprivate func setupCelebrateView() {
        // white back
        let backFrame = CGRect(x: 15 * standWP, y: 100 * standHP, width: width - 30 * standWP, height: height - bottomLength - 120 * standHP)
        backView.frame = backFrame
        view.addSubview(backView)
        
        // person
        let personImageView = UIImageView(image: UIImage(named: "celebrate_icon"))
        personImageView.frame = CGRect(x: -5 * standWP, y: -64 * standHP, width: 120 * standWP, height: 130 * standHP)
        personImageView.contentMode = .scaleAspectFit
        backView.addSubview(personImageView)
        
        // dismiss
        dismissButton.frame = CGRect(x: backFrame.width - 36 * standWP, y: 10 * standHP, width: 26 * standWP, height: 26 * standWP)
        backView.addSubview(dismissButton)
        
        // congratatulations
        let titleLabel = UILabel(frame: CGRect(x: 50 * standWP, y: 25 * standHP, width: backFrame.width - 100 * standWP, height: 60 * standHP))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Congratulations\n\(UserCenter.sharedCenter.loginUserObj.displayName ?? "To You")!\n Your score is \(score)."
        titleLabel.font = UIFont.systemFont(ofSize: 16 * standHP, weight: UIFontWeightBold)
        titleLabel.shadowColor = UIColor.white
        titleLabel.shadowOffset = CGSize(width: -1, height: 0)
        
        backView.addSubview(titleLabel)
        
        // road
        let optionsFrame = CGRect(x: 0, y: titleLabel.frame.maxY, width: backView.frame.width, height: backView.frame.height - titleLabel.frame.maxY).insetBy(dx: 5 * standWP, dy: 8 * standHP)
        roadView = OptionItemsRoad(frame: optionsFrame)
        roadView.backgroundColor = UIColor.clear
        backView.addSubview(roadView)
        
        // center risk, current
        roadView.crossCenter = CGPoint(x: roadView.bounds.midX, y: roadView.bounds.midY)
        let centerLength = min(standWP, standHP) * 45
        let cursor = RiskMetricCardsCursor.sharedCursor
        riskIconView.frame = CGRect(center: roadView.crossCenter, length: centerLength)
        riskIconView.contentMode = .scaleAspectFit
        riskIconView.backgroundColor = UIColor.white
        riskIconView.layer.cornerRadius = 5
        riskIconView.layer.borderWidth = 1
        riskIconView.layer.masksToBounds = true
        riskIconView.layer.borderColor = tabTintGreen.cgColor
        
        riskIconView.sd_setShowActivityIndicatorView(true)
        riskIconView.sd_setIndicatorStyle(.gray)
        riskIconView.sd_setImage(with: cursor.focusingRisk.imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, completed: nil)
        roadView.addSubview(riskIconView)
 
        // items on it
        let options = ["Play A New Game", "Different Options", "Play For Else", "Put Into Action"]
        let itemLength = min(optionsFrame.width, optionsFrame.height) * 0.3
        for i in 0..<options.count {
            let button = UIButton(type: .custom)
            button.setBackgroundImage(UIImage(named: "cong_\(i)"), for: .normal)
            button.tag = 100 + i
            button.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
            
            buttons.append(button)
            roadView.addSubview(button)
        }

        // layout buttons
        ButterflyLayout.layoutEvenOvalWithRootCenter(riskIconView.center, children: buttons, ovalA: optionsFrame.width * 0.5 - itemLength * 0.6, ovalB: optionsFrame.height * 0.5 - itemLength * 0.6, startAngle: CGFloat(Double.pi) * (2 - 1/5), expectedSize: CGSize(width: itemLength, height: itemLength))
        
        for (i, button) in buttons.enumerated() {
            roadView.itemCenters.append(button.center)
            let desLabel = UILabel()
            desLabel.text = options[i]
            
            button.addSubview(desLabel)
            let labelHeight = itemLength * 0.2
            desLabel.frame = CGRect(x: -labelHeight, y: -labelHeight, width: button.bounds.width + 2 * labelHeight, height: labelHeight)
            desLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.7)
            desLabel.textAlignment = .center
            desLabel.numberOfLines = 0
            if i == 1 {
                let collection = AIDMetricCardsCollection.standardCollection
                let numberOfRisks = collection.getModelsOfRiskClass(cursor.selectedRiskClassKey!, riskTypeKey: cursor.riskTypeKey).count
                if numberOfRisks == 1 {
                    desLabel.textColor = UIColorGray(187)
                    button.isEnabled = false
                    roadView.disabledNumber = i
                }
            }
        }
        
        roadView.setNeedsDisplay()
    }

    // actions
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func nextStep(_ button: UIButton)  {
        // ["Play A New Game", "Different Options", "Play For Else", "Put Into Action"]
        for item in self.buttons {
            if item.tag != button.tag {
                item.removeFromSuperview()
            }
        }
        riskIconView.removeFromSuperview()
        roadView.itemCenters.removeAll()
        roadView.setNeedsDisplay()
        
        let transform = CGAffineTransform(translationX: roadView.crossCenter.x - button.center.x, y: roadView.crossCenter.y - button.center.y)
        
        UIView.animate(withDuration: 0.5, animations: {
            button.transform = transform.scaledBy(x: 1.5, y: 1.5)
        }) { (true) in
            let index = button.tag - 100
            if index == 0 {
                self.holdAndPush(ABookLandingPageViewController())
            }else if index == 1 {
                // buttfly effect
                let focusing = RiskMetricCardsCursor.sharedCursor.focusingRiskKey
                if focusing == negativeBEKey || focusing == positiveBEKey {
                    self.holdAndPush(ButterflyOverallViewController())
                }else {
                     self.holdAndPush(IntroPageViewController())
                }
            }else if index == 2 {
                self.holdAndPush(PlayForOthersViewController())
            }else {
                let tab = self.presentFromVC.tabBarController
                tab?.selectedIndex = 1
                let navi = tab!.viewControllers![1] as! ABookNavigationController
                for vc in navi.viewControllers {
                    if vc.isKind(of: ToDoListViewController.self) {
                        navi.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    fileprivate func holdAndPush(_ vc: UIViewController) {
        if presentFromVC != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismissVC()
                self.presentFromVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

class OptionItemsRoad: UIView {
    var crossCenter = CGPoint.zero
    var itemCenters = [CGPoint]()
    var disabledNumber: Int!
    var roadWidth: CGFloat = 20
    
    // colors
    var roadLineColor = UIColorFromRGB(253, green: 255, blue: 251)
    var roadMainColor = UIColorFromRGB(204, green: 205, blue: 192)
    
    // draw rect
    override func draw(_ rect: CGRect) {
        let normalPath = UIBezierPath()
        
        for (i, itemCenters) in itemCenters.enumerated() {
            if disabledNumber != nil && disabledNumber == i {
                continue
            }
            
            normalPath.move(to: crossCenter)
            normalPath.addLine(to: itemCenters)
        }
        strokeRoadPath(normalPath, disabled: false)
        
//        if disabledNumber != nil && disabledNumber >= 0 && disabledNumber < itemCenters.count {
//            // diabled path
//            let disabledPath = UIBezierPath()
//            disabledPath.move(to: crossCenter)
//            disabledPath.addLine(to: itemCenters[disabledNumber])
//
//            // road
//            strokeRoadPath(disabledPath, disabled: true)
//        }
    }
    
    fileprivate func strokeRoadPath(_ path: UIBezierPath, disabled: Bool) {
        let roadColor = disabled ? roadMainColor.withAlphaComponent(0.5) : roadMainColor
        // draw main road
        path.lineWidth = roadWidth
        roadColor.setStroke()
        path.stroke()
        
        // coverPath
        let coverPath = path
        roadLineColor.setStroke()
        coverPath.lineWidth = roadWidth * 0.8
        coverPath.stroke()
        
        // middle path
        let middlePath = path
        roadColor.setStroke()
        middlePath.lineWidth = roadWidth * 0.6
        middlePath.stroke()
        
        // middle
        let roadLinePath = path
        roadLineColor.setStroke()
        roadLinePath.setLineDash([9, 6], count: 1, phase: 1)
        roadLinePath.lineWidth = 2
        roadLinePath.stroke()
    }
    
}
