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
    @IBOutlet fileprivate weak var middleImageView: UIImageView!
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var downImageView: UIImageView!
    
    @IBOutlet weak var downDot: UIImageView!
    @IBOutlet weak var topDot: UIImageView!
    @IBOutlet var bottomButtons: [UIButton]!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    
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
        topDot.image = WHATIF ? #imageLiteral(resourceName: "mr_dot_purple") : #imageLiteral(resourceName: "mr_dot_green")
        leftArrow.image = WHATIF ? #imageLiteral(resourceName: "mr_leftArrow_whatIf") : #imageLiteral(resourceName: "mr_leftArrow")
        middleImageView.image = WHATIF ? #imageLiteral(resourceName: "mushroom_middle_whatIf") : #imageLiteral(resourceName: "mushroom_middle")
        topImageView.image = WHATIF ? #imageLiteral(resourceName: "mr_top_whatIf") : #imageLiteral(resourceName: "mr_top")
        
        // mushroomImageView
        let baseBack = #imageLiteral(resourceName: "mr_buttonBack_green")
        let whatIfBack = #imageLiteral(resourceName: "mr_buttonBack_purple")
 
        // buttons
        let buttonFont = UIFont.systemFont(ofSize: 10 * fontFactor, weight: .medium)
        for button in topButtons {
            let topButtonBack = WHATIF ? whatIfBack : baseBack
            button.setBackgroundImage(topButtonBack, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.font = buttonFont
            button.layer.addBlackShadow(fontFactor * 2)
        }
        topButtons[0].setBackgroundImage(WHATIF ? baseBack : whatIfBack, for: .normal)
        topButtons[0].setTitle(WHATIF ? "Play Baseline:\nReality" : "Play What-If:\nTest-drive", for: .normal)
        
        for button in bottomButtons {
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.font = buttonFont
            button.layer.addBlackShadow(fontFactor * 2)
            
            button.isEnabled = false
            button.layer.shadowColor = UIColor.clear.cgColor
        }
        topButtons[1].isEnabled = false
        topButtons[1].layer.shadowColor = UIColor.clear.cgColor
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            firstLoad = false
            drawLines()
            addAnimation()
        }
        
        topDot.layer.add(leftAnimation, forKey: nil)
        downDot.layer.add(rightAnimation, forKey: nil)
        // add animation
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
                self.startAnimatation()
            })
        }
    }
    fileprivate var leftPath: UIBezierPath!
    fileprivate var rightPath: UIBezierPath!
    fileprivate func drawLines() {
        var drawInfo = [(UIBezierPath, UIColor)]()
        
        // top
        var buttonFrame = getFrameOfButtonInStack(topButtons[0])
        let topLeft = CGPoint(x: buttonFrame.midX, y: buttonFrame.maxY)
        buttonFrame = getFrameOfButtonInStack(topButtons[2])
        let topRight = CGPoint(x: buttonFrame.midX, y: buttonFrame.maxY)
        let topRadius = (topImageView.frame.minY - buttonFrame.maxY) * 0.6
        let topPath = UIBezierPath.getBottomRectConnectionBetweenLeftPoint(topLeft, rightPoint: topRight, radius: topRadius)
        
        buttonFrame = getFrameOfButtonInStack(topButtons[1])
        topPath.move(to: CGPoint(x: buttonFrame.midX, y: buttonFrame.maxY))
        topPath.addLine(to: topImageView.center)
        
        // curve
        let leftStartP = CGPoint(x: leftArrow.frame.minX, y: leftArrow.frame.midY)
        leftPath = UIBezierPath()
        leftPath.move(to: leftStartP)
        
        buttonFrame = getFrameOfButtonInStack(topButtons[0])
        let radius = min((leftStartP.x - buttonFrame.minX) * 0.3, 8 * fontFactor)
        let leftX = buttonFrame.minX
        leftPath.addLine(to: CGPoint(x: leftX + radius, y: leftStartP.y))
        leftPath.addArc(withCenter: CGPoint(x: leftX + radius, y: leftStartP.y - radius), radius: radius, startAngle: CGFloat(Double.pi) * 0.5, endAngle: CGFloat(Double.pi) , clockwise: true)
        leftPath.addLine(to: CGPoint(x: leftX, y: topDot.center.y + radius))
        leftPath.addArc(withCenter: CGPoint(x: leftX + radius, y: topDot.center.y + radius), radius: radius, startAngle: -CGFloat(Double.pi), endAngle: -CGFloat(Double.pi) * 0.5, clockwise: true)
        leftPath.addLine(to: topDot.center)
        
        topPath.append(leftPath)
        topPath.lineWidth = 2 * fontFactor
        topPath.lineJoinStyle = .round
        drawInfo.append((topPath, WHATIF ? UIColorFromHex(0x7D41FF) : UIColorFromHex(0x009840)))
        
        // bottom
        let bottomPath = UIBezierPath()
        buttonFrame = getFrameOfButtonInStack(bottomButtons[1])
        bottomPath.move(to: downImageView.center)
        bottomPath.addLine(to: CGPoint(x: buttonFrame.midX, y: buttonFrame.minY))
        // connnecting two buttons
        buttonFrame = getFrameOfButtonInStack(bottomButtons[0])
        
        let bRadius = 0.6 * (buttonFrame.minY - downImageView.frame.maxY)
        
        let downLeft = CGPoint(x: buttonFrame.midX, y: buttonFrame.minY)
        buttonFrame = getFrameOfButtonInStack(bottomButtons[2])
        let downRight = CGPoint(x: buttonFrame.midX, y: buttonFrame.minY)
        
        let downPath = UIBezierPath.getTopRectConnectionBetweenLeftPoint(downLeft, rightPoint: downRight, radius: bRadius)
        bottomPath.append(downPath)
        
        // right
        let rightStartP = CGPoint(x: rightArrow.frame.maxX, y: rightArrow.frame.midY)
        let rightX = width - leftX
        
        rightPath = UIBezierPath()
        buttonFrame = getFrameOfButtonInStack(topButtons[2])
        rightPath.move(to: rightStartP)
        rightPath.addLine(to: CGPoint(x: rightX - radius, y: rightStartP.y))
        rightPath.addArc(withCenter: CGPoint(x: rightX - radius, y: rightStartP.y + radius), radius: radius, startAngle: -CGFloat(Double.pi * 0.5), endAngle: 0, clockwise: true)
        rightPath.addLine(to: CGPoint(x: rightX, y: downDot.frame.midY - radius))
        rightPath.addArc(withCenter: CGPoint(x: rightX - radius, y: downDot.frame.midY - radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi) * 0.5, clockwise: true)
        rightPath.addLine(to: downDot.center)
        
        bottomPath.append(rightPath)
        bottomPath.lineWidth = 2 * fontFactor
        drawInfo.append((bottomPath, UIColorFromHex(0x5590FF)))
        
        // stop
        let leftFrame = getFrameOfButtonInStack(leftButton)
        let rightFrame = getFrameOfButtonInStack(rightButton)
        let bottomRadius = max(leftFrame.minY - stopButton.frame.midY, 0)
        let stopPath = UIBezierPath.getTopRectConnectionBetweenLeftPoint(CGPoint(x: leftFrame.midX, y: leftFrame.minY), rightPoint: CGPoint(x: rightFrame.midX, y: rightFrame.minY), radius: bottomRadius)
        
        stopPath.lineWidth = 2 * fontFactor
        drawInfo.append((stopPath, UIColorFromHex(0xF5A623)))
        
        lineDrawView.pathInfo = drawInfo
    }
    
    fileprivate func getFrameOfButtonInStack(_ button: UIButton) -> CGRect {
        return view.convert(button.frame, from: button.superview!)
    }
    
    fileprivate let leftAnimation = CAAnimationGroup()
    fileprivate let rightAnimation = CAAnimationGroup()
    fileprivate func addAnimation() {
        let leftPathAnimation = CAKeyframeAnimation(keyPath: "position")
        leftPathAnimation.path = leftPath.cgPath
        
        let leftBasic = CABasicAnimation(keyPath: "transform")
        leftBasic.fromValue = CATransform3DRotate(CATransform3DIdentity, CGFloat(Double.pi), 0, 0, 1)
        leftBasic.toValue = CATransform3DIdentity
        
        leftAnimation.animations = [leftPathAnimation, leftBasic]
        leftAnimation.duration = 2
        leftAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        let rightPathAnimation = CAKeyframeAnimation(keyPath: "position")
        rightPathAnimation.path = rightPath.cgPath
        
        rightAnimation.animations = [rightPathAnimation, leftBasic]
        rightAnimation.duration = 2
        rightAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
    }
    fileprivate var timer: Timer!
    fileprivate func startAnimatation() {
        topDot.layer.removeAllAnimations()
        downDot.layer.removeAllAnimations()
        
        topDot.layer.add(leftAnimation, forKey: nil)
        downDot.layer.add(rightAnimation, forKey: nil)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
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
        if let navi = navigationController {
            for vc in navi.viewControllers {
                if vc.isKind(of: IntroPageViewController.self) {
                    navi.popToViewController(vc, animated: true)
                    return
                }
            }
        }
    }
    
    
    @IBAction func choosePerson(_ sender: Any) {
        let player = ABookPlayerViewController.initFromStoryBoard()
        player.backToIntroAfterChoose = true
        navigationController?.pushViewController(player, animated: true)
    }
    
//    @IBAction func playNewSubject(_ sender: UIButton) {
//        goBackToLanding()
//    }
    
//    @IBAction func recommandGame(_ sender: Any) {
//        goBackToLanding()
//    }
    
    
//    @IBAction func newTypeGame(_ sender: Any) {
//        goBackToLanding()
//    }
    
    @IBAction func goToAct(_ sender: UIButton) {
        goToActViewOnTab()
    }
    

    // bottom
    @IBAction func goToList(_ sender: Any) {
        goToActViewOnTab()
    }
    @IBAction func goToCollec(_ sender: Any) {
    }
    
//    fileprivate func goBackToLanding() {
//        if let navi = navigationController {
//            for vc in navi.viewControllers {
//                if vc.isKind(of: ABookLandingPageViewController.self) {
//                    navi.popToViewController(vc, animated: true)
//                    return
//                }
//            }
//            navi.pushViewController(ABookLandingPageViewController(), animated: true)
//        }
//    }
    
    fileprivate func goToActViewOnTab() {
        let tab = self.tabBarController
        tab?.selectedIndex = 4
        let navi = tab!.viewControllers![4] as! ABookNavigationController
        navi.popToRootViewController(animated: true)
    }
}
