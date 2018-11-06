//
//  MushroomViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/21.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MushroomViewController: UIViewController {
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var lineDrawView: MushroomLineDrawView!
    @IBOutlet weak var firework: UIImageView!
    @IBOutlet var topButtons: [UIButton]!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet fileprivate weak var middleImageView: UIImageView!
    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet var bottomButtons: [UIButton]!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var topArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    
    fileprivate let player = PlayerButton.createForNavigationItem()
    fileprivate var moreRisks = false
    fileprivate var firstLoad = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Action Explorer Map"
        player.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: player)
        
        let back = createBackButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
        
        // images
        
        backImageView.image = WHATIF ? ProjectImages.sharedImage.categoryBackV : ProjectImages.sharedImage.categoryBack
        firework.image = WHATIF ? #imageLiteral(resourceName: "fireworks_whatIf") : #imageLiteral(resourceName: "fireworks_baseline")
        topArrow.image = WHATIF ? #imageLiteral(resourceName: "mushroomArrow_whatIf") : #imageLiteral(resourceName: "mushroomArrow_baseline")
        middleImageView.image = WHATIF ? #imageLiteral(resourceName: "mushroom_middle_whatIf") : #imageLiteral(resourceName: "mushroom_middle")
        
        // mushroomImageView
        let baseBack = #imageLiteral(resourceName: "buttonBack_green")
        let whatIfBack = #imageLiteral(resourceName: "buttonBack_purple")
        topLabel.backgroundColor = WHATIF ? UIColorFromHex(0xC6ACFF) : UIColorFromHex(0xB8E986)
        
        // buttons
        for button in topButtons {
            let topButtonBack = WHATIF ? whatIfBack : baseBack
            button.setBackgroundImage(topButtonBack, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.font = UIFont.systemFont(ofSize: 9 * fontFactor)
            button.layer.addBlackShadow(fontFactor * 2)
        }
        topButtons[0].setBackgroundImage(WHATIF ? baseBack : whatIfBack, for: .normal)
        topButtons[0].setTitle(WHATIF ? "Play Baseline:\nReality" : "Play What-If:\nTest-drive", for: .normal)
        
        for button in bottomButtons {
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.font = UIFont.systemFont(ofSize: 9 * fontFactor)
            button.layer.addBlackShadow(fontFactor * 2)
        }
        
        topLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFont.Weight.semibold)
        bottomLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFont.Weight.semibold)
        
        topLabel.layer.borderColor = UIColor.black.cgColor
        bottomLabel.layer.borderColor = UIColor.black.cgColor
        topLabel.layer.borderWidth = fontFactor
        bottomLabel.layer.borderWidth = fontFactor
        topLabel.layer.cornerRadius = 4 * fontFactor
        topLabel.layer.masksToBounds = true
        bottomLabel.layer.masksToBounds = true
        
        stopButton.layer.borderColor = UIColorFromHex(0xD43300).cgColor
        stopButton.layer.borderWidth = fontFactor
        stopButton.titleLabel?.textAlignment = .center
        stopButton.titleLabel?.numberOfLines = 0
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: UIFont.Weight.semibold)
        
        let numberOfRisks = collection.getRiskModelKeys(cardsCursor.selectedRiskClassKey!, riskType: cardsCursor.riskTypeKey).count
        moreRisks = (numberOfRisks > 1)
        topButtons[1].isEnabled = moreRisks
        if !moreRisks {
            topButtons[1].layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomLabel.layer.cornerRadius = bottomLabel.frame.height * 0.5
        stopButton.layer.cornerRadius = stopButton.frame.height * 0.5
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            firstLoad = false
            drawLines()
            animateArrows()
        }
    }
    fileprivate var leftPath: UIBezierPath!
    fileprivate var rightPath: UIBezierPath!
    fileprivate func drawLines() {
        var drawInfo = [(UIBezierPath, UIColor)]()
        // top
        let topPath = UIBezierPath()
        
        var buttonFrame = getFrameOfButtonInStack(topButtons[1])
        topPath.move(to: CGPoint(x: buttonFrame.midX, y: buttonFrame.maxY))
        topPath.addLine(to: topLabel.center)
        buttonFrame = getFrameOfButtonInStack(topButtons[0])
        var turningY = (buttonFrame.maxY + topLabel.frame.minY) * 0.5
        topPath.move(to: CGPoint(x: buttonFrame.midX, y: buttonFrame.maxY))
        topPath.addLine(to: CGPoint(x: buttonFrame.midX, y: turningY))
        buttonFrame = getFrameOfButtonInStack(topButtons[2])
        topPath.addLine(to: CGPoint(x: buttonFrame.midX, y: turningY))
        topPath.addLine(to: CGPoint(x: buttonFrame.midX, y: buttonFrame.maxY))
        
        // with label
        leftPath = UIBezierPath()
        buttonFrame = getFrameOfButtonInStack(topButtons[0])
        let radius = min(buttonFrame.minX * 0.4, 8 * fontFactor)
        leftPath.move(to: topArrow.center)
        let offsetX = middleImageView.frame.width * 30 / 249
        let middleY = middleImageView.frame.height * 33 / 44 + middleImageView.frame.minY
        
        leftPath.addLine(to: CGPoint(x: buttonFrame.minX - radius, y: topLabel.frame.midY))
        leftPath.addArc(withCenter: CGPoint(x: buttonFrame.minX - radius, y: topLabel.frame.midY + radius), radius: radius, startAngle: -CGFloat(Double.pi * 0.5), endAngle: -CGFloat(Double.pi), clockwise: false)
        leftPath.addLine(to: CGPoint(x: buttonFrame.minX - 2 * radius, y: middleY - radius))
        leftPath.addArc(withCenter: CGPoint(x: buttonFrame.minX - radius, y: middleY - radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi) * 0.5, clockwise: false)
        leftPath.addLine(to: CGPoint(x: middleImageView.frame.minX + offsetX, y: middleY))
        leftPath = leftPath.reversing()
        
        topPath.append(leftPath)
        topPath.lineWidth = 2 * fontFactor
        topPath.lineJoinStyle = .round
        drawInfo.append((topPath, WHATIF ? UIColorFromHex(0x7D41FF) : UIColorFromHex(0x009840)))
        
        // bottom
        let bottomPath = UIBezierPath()
        buttonFrame = getFrameOfButtonInStack(bottomButtons[1])
        bottomPath.move(to: bottomLabel.center)
        bottomPath.addLine(to: CGPoint(x: buttonFrame.midX, y: buttonFrame.minY))
        // connnecting two buttons
        buttonFrame = getFrameOfButtonInStack(bottomButtons[0])
        let bRadius = 0.5 * (buttonFrame.minY - bottomLabel.frame.maxY)
        turningY = 0.5 * (bottomLabel.frame.maxY + buttonFrame.minY)
        
        bottomPath.move(to: CGPoint(x: buttonFrame.midX, y: buttonFrame.minY))
        bottomPath.addArc(withCenter: CGPoint(x: buttonFrame.midX + bRadius, y: buttonFrame.minY), radius: bRadius, startAngle: -CGFloat(Double.pi), endAngle: -CGFloat(Double.pi * 0.5), clockwise: true)
        buttonFrame = getFrameOfButtonInStack(bottomButtons[2])
        bottomPath.addLine(to: CGPoint(x: buttonFrame.midX - bRadius, y: turningY))
        bottomPath.addArc(withCenter: CGPoint(x: buttonFrame.midX - bRadius, y: buttonFrame.minY), radius: bRadius, startAngle: -CGFloat(Double.pi) * 0.5, endAngle: 0, clockwise: true)
        
        // right
        rightPath = UIBezierPath()

        buttonFrame = getFrameOfButtonInStack(topButtons[2])
        rightPath.move(to: CGPoint(x: middleImageView.frame.maxX - offsetX, y: middleY))
        rightPath.addLine(to: CGPoint(x: buttonFrame.maxX + radius, y: middleY))
        rightPath.addArc(withCenter: CGPoint(x: buttonFrame.maxX + radius, y: middleY + radius), radius: radius, startAngle: -CGFloat(Double.pi * 0.5), endAngle: 0, clockwise: true)
        rightPath.addLine(to: CGPoint(x: buttonFrame.maxX + radius * 2, y: bottomLabel.frame.midY - radius))
        rightPath.addArc(withCenter: CGPoint(x: buttonFrame.maxX + radius, y: bottomLabel.frame.midY - radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi) * 0.5, clockwise: true)
        rightPath.addLine(to: downArrow.center)
        
        bottomPath.append(rightPath)
        bottomPath.lineWidth = 2 * fontFactor
        drawInfo.append((bottomPath, UIColorFromHex(0x5590FF)))
        
        // stop
        let stopPath = UIBezierPath()
        stopPath.move(to: leftButton.center)
        stopPath.addLine(to: rightButton.center)
        stopPath.lineWidth = 2 * fontFactor
        drawInfo.append((stopPath, UIColorFromHex(0xF5A623)))
        
        lineDrawView.pathInfo = drawInfo
    }
    
    fileprivate func getFrameOfButtonInStack(_ button: UIButton) -> CGRect {
        return view.convert(button.frame, from: button.superview!)
    }
    
    fileprivate func animateArrows() {
        let leftAnimation = CAAnimationGroup()
        let leftPathAnimation = CAKeyframeAnimation(keyPath: "position")
        leftPathAnimation.path = leftPath.cgPath
        
        let leftBasic = CABasicAnimation(keyPath: "transform")
        leftBasic.fromValue = CATransform3DRotate(CATransform3DIdentity, CGFloat(Double.pi), 0, 0, 1)
        leftBasic.toValue = CATransform3DIdentity
        
        leftAnimation.animations = [leftPathAnimation, leftBasic]
        leftAnimation.duration = 1.5
        leftAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        topArrow.layer.add(leftAnimation, forKey: nil)
        
        let rightAnimation = CAAnimationGroup()
        let rightPathAnimation = CAKeyframeAnimation(keyPath: "position")
        rightPathAnimation.path = rightPath.cgPath
        
        rightAnimation.animations = [rightPathAnimation, leftBasic]
        rightAnimation.duration = 1.5
        
        downArrow.layer.add(rightAnimation, forKey: nil)
    }
    
    // actions
    override func backButtonClicked() {
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: ScoreCardViewController.self) {
                vc.hidesBottomBarWhenPushed = true
                break
            }
        }
        navigationController?.popViewController(animated: true)
//        let scoreCardVC = Bundle.main.loadNibNamed("ScoreCardViewController", owner: self, options: nil)?.first as! ScoreCardViewController
//        let lastM = selectionResults.getLastMeasurementOfUser(userCenter.currentGameTargetUser.Key(), riskKey: cardsCursor.focusingRiskKey, whatIf: WHATIF)!
//        scoreCardVC.setupWithMeasurement(lastM) 
//        scoreCardVC.usePresenet()
//        present(scoreCardVC, animated: true, completion: nil)
    }
    
    @IBAction func playNewState(_ sender: UIButton) {
        goBackToIntro()
    }
    
    @IBAction func playOtherRisk(_ sender: UIButton) {
        if !moreRisks {
            return
        }
        
        // butterfly effect
        goBackToIntro()
    }
    
    fileprivate func goBackToIntro() {
        let focusing = cardsCursor.focusingRiskKey
        if let navi = navigationController {
            if focusing == negativeBEKey || focusing == positiveBEKey {
                for vc in navi.viewControllers {
                    if vc.isKind(of: ButterflyOverallViewController.self) {
                        navi.popToViewController(vc, animated: true)
                        return
                    }
                }
            }else {
                for vc in navi.viewControllers {
                    if vc.isKind(of: IntroPageViewController.self) {
                        navi.popToViewController(vc, animated: true)
                        return
                    }
                }
            }
        }
    }
    
    
    @IBAction func choosePerson(_ sender: Any) {
        let player = ABookPlayerViewController.initFromStoryBoard()
        player.duringPlaying = true
        navigationController?.pushViewController(player, animated: true)
    }
    
    @IBAction func playNewSubject(_ sender: UIButton) {
        goBackToLanding()
    }
    
    @IBAction func recommandGame(_ sender: Any) {
        goBackToLanding()
    }
    
    
    @IBAction func newTypeGame(_ sender: Any) {
        goBackToLanding()
    }
    
    @IBAction func goToAct(_ sender: UIButton) {
        goToActViewOnTab()
    }
    

    // bottom
    @IBAction func goToList(_ sender: Any) {
        goToActViewOnTab()
    }
    @IBAction func goToCollec(_ sender: Any) {
    }
    
    fileprivate func goBackToLanding() {
        if let navi = navigationController {
            for vc in navi.viewControllers {
                if vc.isKind(of: ABookLandingPageViewController.self) {
                    navi.popToViewController(vc, animated: true)
                    return
                }
            }
            navi.pushViewController(ABookLandingPageViewController(), animated: true)
        }
    }
    
    fileprivate func goToActViewOnTab() {
        let tab = self.tabBarController
        tab?.selectedIndex = 1
        let navi = tab!.viewControllers![1] as! ABookNavigationController
        for vc in navi.viewControllers {
            if vc.isKind(of: ActToChangeViewController.self) {
                navi.popToViewController(vc, animated: true)
                break
            }
        }
    }
}
