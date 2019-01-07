//
//  ScoreCardViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/12.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScoreCardViewController: UIViewController {
//    var scoreStyle = CardViewBackStyle.iiaBack
    
    // on view
    @IBOutlet weak var mailBox: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    // outlets
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var letterView: UIView!
    
    // top
//    @IBOutlet weak var userAvatar: UIImageView!
//    @IBOutlet weak var userNameLabel: UILabel!
//    @IBOutlet weak var userGenderLabel: UILabel!
//
//    @IBOutlet weak var monthLabel: UILabel!
//    @IBOutlet weak var dayLabel: UILabel!
    
    // main
    // ---- top
    @IBOutlet weak var scorecardMain: ScorecardDisplayAllView!
    
    // bottom
    @IBOutlet weak var cardNoteLabel: UILabel!
    @IBOutlet weak var noteHideButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // envelope
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var letterImageView: UIImageView!
    @IBOutlet weak var toLabel: UILabel!
    
    // properties
    weak var presentFrom: SummaryViewController!

    fileprivate var letterOnShow = false
    fileprivate var shownBefore: Bool {
        return userDefaults.bool(forKey: "LetterShownBefore")
    }
    
    fileprivate var withNote = true {
        didSet{
            if !withNote {
                cardNoteLabel.isHidden = true
                noteLabel.isHidden = true
                noteHideButton.isHidden = true
            }
        }
    }
    fileprivate var forDetail = true
    fileprivate var referenceValue: Float = 0

    
    // view did load
    fileprivate var timer: Timer!
    override func viewDidLoad() {
        adjustUI()
        adjustFont()
        fillData()
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
           self.showLetter()
        })
    }
    
    // ui adjust
    fileprivate func adjustUI() {
        // state
        backView.transform = CGAffineTransform(translationX: 0, y: height * 0.5).scaledBy(x: 0.7, y: 0.7)
        backView.isHidden = true
        letterView.isHidden = true
        
        // tap
        let showLetterGR = UITapGestureRecognizer(target: self, action: #selector(showLetter))
        mailBox.addGestureRecognizer(showLetterGR)
    }

    fileprivate func adjustFont() {
//        let subFont = UIFont.systemFont(ofSize: 12 * fontFactor)
        // sizes
        noteLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFontWeightSemibold)
       
        // user part
//        userNameLabel.font = mediumFontOfPoint(18)
//        userGenderLabel.font = subFont
//
//        monthLabel.font = mediumFontOfPoint(9)
//        dayLabel.font = mediumFontOfPoint(18)

        // sharePart
        cardNoteLabel.font = mediumFontOfPoint(14)
    }
    
    fileprivate func mediumFontOfPoint(_ point: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: point * fontFactor, weight: UIFontWeightMedium)
    }
    
    fileprivate func layScoreCard() {
        continueButton.adjustThickRectButton(continueButton.frame)
        backButton.adjustThickRectButton(backButton.frame)
        
        scorecardMain.layoutSubviews()
    }
    
    // data
    fileprivate var ratio: CGFloat = 0
    fileprivate var tempPanel = [(cards: [CardInfoObjModel], color: UIColor, seqNumber: Int)]()
    
    fileprivate var risk: RiskObjModel {
        return cardsCursor.focusingRisk!
    }
    fileprivate var riskTypeKey: String {
        return cardsCursor.riskTypeKey
    }
    fileprivate func fillData() {
//        let displayedUser = userCenter.currentGameTargetUser.userInfo()!
        // note
        withNote = (MatchedCardsDisplayModel.getNumberOfAnsweredCardsForCurrent() != collection.getSortedCardsForRiskKey(risk.key).count)

        // userInfo
//        let toName = "To \(displayedUser.displayName!)"
//        let nameAttrString = NSMutableAttributedString(string: toName, attributes: [NSFontAttributeName: mediumFontOfPoint(22), NSForegroundColorAttributeName: UIColor.black])
//        nameAttrString.addAttributes([NSForegroundColorAttributeName: UIColorFromRGB(104, green: 159, blue: 56)], range: NSMakeRange(3, toName.count - 3))
//
//        toLabel.attributedText = nameAttrString
//        userAvatar.image = displayedUser.imageObj ?? ProjectImages.sharedImage.maleAvatar
//        userNameLabel.text = displayedUser.displayName
//        userGenderLabel.text = "\(displayedUser.sex ?? "Not told")"
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM"
//        monthLabel.text = dateFormatter.string(from: Date())
//        dateFormatter.dateFormat = "dd"
//        dayLabel.text = dateFormatter.string(from: Date())
        
        // card
        // brain age
        scorecardMain.setupWithRisk(risk.key, userKey: userCenter.currentGameTargetUser.Key())

    }
    
    // MAKR: ----------------- touches and actions -------------------------
    func showLetter() {
        if !letterOnShow {
            timer.invalidate()
            mailBox.isUserInteractionEnabled = false
            let mailT = -height * 0.24
            let desPoint = self.letterImageView.center
            
            // letterView
            let startTransform = CGAffineTransform(scaleX: 0.4, y: 0.4).rotated(by: CGFloat(Double.pi) * 0.6)
            let startCenter = CGPoint(x: self.letterView.frame.midX, y: -mailT * 0.8)
//            self.letterView.center = startCenter
            self.letterView.transform = startTransform
            
            let keyFrame = CAKeyframeAnimation(keyPath: "position")
            let path = UIBezierPath()
            path.move(to: startCenter)
            path.addCurve(to: desPoint, controlPoint1: CGPoint(x: width * 0.1, y: mailT), controlPoint2: CGPoint(x: width * 0.15, y: desPoint.y))
            keyFrame.path = path.cgPath
//            keyFrame.timingFunctions = [kCAMediaTimingFunctionEaseIn]
            keyFrame.rotationMode = "auto"
            
            
            let basicAnimation = CABasicAnimation(keyPath: "transform")
//            basicAnimation.fromValue = startTransform
//            basicAnimation.toValue = CGAffineTransform.identity
//            basicAnimation.duration = 2
            
            let animations = CAAnimationGroup()
            animations.animations = [keyFrame, basicAnimation]
            animations.duration = 0.6
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.letterView.isHidden = false
                self.letterView.layer.add(animations, forKey: nil)
                UIView.animate(withDuration: 0.6, animations: {
                    self.letterView.transform = CGAffineTransform.identity
                })
            }

            // mailBox
            UIView.animate(withDuration: 0.8, animations: {
                self.mailBox.transform = CGAffineTransform(translationX: 0, y: mailT).scaledBy(x: 0.65, y: 0.65)
            }, completion: { (true) in
                DispatchQueue.main.asyncAfter(deadline: .now() + (self.shownBefore ? 0.5 : 1), execute: {
                    self.openLetter()
                })
            })
        }
    }

    fileprivate func openLetter() {
        layScoreCard()
        dismissButton.isHidden = true
        UIView.transition(with: letterImageView, duration: 0.4, options: .transitionFlipFromLeft, animations: {
            self.toLabel.isHidden = true
            self.letterImageView.image = UIImage(named: "envelope_back")
        }) { (true) in
            self.view.sendSubview(toBack: self.mailBox)
            UIView.animate(withDuration: 0.3, delay: self.shownBefore ? 0.7 : 1, options: .curveEaseIn, animations: {
                self.letterView.transform = CGAffineTransform(translationX: 0, y: height - bottomLength - self.letterImageView.frame.maxY)
            }, completion: { (true) in
                self.backView.isHidden = false
                self.letterImageView.image = UIImage(named: "envelope_open_front")
                
                // reduce animation duration for the next display
                if !self.shownBefore {
                    userDefaults.set(true, forKey: "LetterShownBefore")
                    userDefaults.synchronize()
                }
                
                // show score card
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    self.backView.transform = CGAffineTransform.identity
                    self.letterView.transform = CGAffineTransform(translationX: 0, y: height)
                }, completion: { (true) in
                    self.letterOnShow = true
                })
            })
        }
    }

    
    func showDetailCardsOfIndex(_ index: Int) {
        if index < 0 || index > tempPanel.count - 1 {
            return
        }
        
        let cardsVC = CardAnswerChangeViewController()
        cardsVC.modalPresentationStyle = .overCurrentContext
        cardsVC.loadWithCards(tempPanel[index].cards, riskTypeKey: riskTypeKey, borderColor: tempPanel[index].color)
        
        present(cardsVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func showSplash() {
        let splashVC = SplashScreenViewController()
        splashVC.modalPresentationStyle = .overFullScreen
        present(splashVC, animated: true, completion: nil)
    }

    
    @IBAction func hideNote(_ sender: UIButton) {
        sender.isHidden = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.cardNoteLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (true) in
            self.cardNoteLabel.isHidden = true
        }
    }

    @IBAction func saveAndContinue(_ sender: Any) {
        dismiss(animated: true) {
            if self.presentFrom != nil {
                let mushroomVC = Bundle.main.loadNibNamed("MushroomViewController", owner: self, options: nil)?.first as! MushroomViewController
                self.presentFrom.navigationController?.pushViewController(mushroomVC, animated: true)
            }
        }
    }
    
    // status bar hidden
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
