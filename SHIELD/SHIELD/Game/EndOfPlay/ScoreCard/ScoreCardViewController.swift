//
//  ScoreCardViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/12.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScoreCardViewController: UIViewController {
    
    @IBOutlet weak var scorecardBackImageView: UIImageView!
    // on view
    @IBOutlet weak var decoration: UIImageView!
    @IBOutlet weak var dancing: UIImageView!
    
    @IBOutlet weak var cloudTop: CloudTopView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDecoLabel: UILabel!
    @IBOutlet weak var melodyBack: UIView!
    @IBOutlet weak var melody: UIImageView!

    @IBOutlet weak var nextButton: UIButton!
    
    // on
    @IBOutlet weak var displayView: UIView!

    @IBOutlet var balloons: [UIButton]!
    // main
    var scorecardAll = ScorecardDisplayAllView()
    
    @IBOutlet weak var allBackImageView: UIImageView!
    // properties
    fileprivate var letterOnShow = false

    
    // view did load
    fileprivate var showTimer: Timer!
    fileprivate var withFYI = false
    fileprivate let titleView = StrokeLabel()
    override func viewDidLoad() {
        hidesBottomBarWhenPushed = true
        view.isUserInteractionEnabled = false
        
        navigationItem.hidesBackButton = true
        
        let playerButton = PlayerButton.createForNavigationItem()
        playerButton.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: playerButton)
        // middle
        titleView.frontColor = UIColor.black
        titleView.strokeColor = UIColor.white
        
        navigationItem.titleView = titleView
    
        // prepare
        decoration.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        dancing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
   
        melody.transform = CGAffineTransform(translationX: -width, y: 0)
        nextButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 0.5)
        for balloon in balloons {
            balloon.transform = CGAffineTransform(translationX: 0, y: height * 0.5)
        }
        // display
        displayView.addSubview(scorecardAll)
        
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      
//        navigationController.kCVPixelBufferOpenGLESTextureCacheCompatibilityKey
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if !hidesBottomBarWhenPushed {
            tabBarController?.tabBar.isHidden = true
        }
        
        if firstLoad {
            navigationController?.setClearBar()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if !hidesBottomBarWhenPushed {
            tabBarController?.tabBar.isHidden = false
        }
    
        navigationController?.setToNormalBar()
    }

    fileprivate var forWhatIf = false
  
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        // title, 17 + 14
        let risk = collection.getRisk(measurement.riskKey!)!
        titleView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleView.text = risk.name
        
        forWhatIf = (measurement.whatIfFlag == 1)
        setupDefaultTitle()
        
        scorecardBackImageView.image = forWhatIf ? #imageLiteral(resourceName: "scorecardBack_whatIf") : #imageLiteral(resourceName: "scorecard_warmBack")
        decoration.image = forWhatIf ? #imageLiteral(resourceName: "decoration_whatIf") : #imageLiteral(resourceName: "scorecard_decoration")
        
        // data
        scorecardAll.setupWithMeasurement(measurement)
        withFYI = (risk.fyiUrls.count != 0)
        balloons.last?.isHidden = !withFYI
    }
    
    fileprivate func setupDefaultTitle() {
        let mainColor = forWhatIf ? UIColorFromHex(0x2500CF) : UIColor.red
        let title = "Your Scorecard is here.\n"
        let sub = "Scorecard Concerto: 3 Movements\n- What, Why, and How"
        let topString = NSMutableAttributedString(string: title, attributes: [ .font: UIFont.systemFont(ofSize: 38 * fontFactor, weight: .heavy),  .foregroundColor: mainColor])
        topString.append(NSAttributedString(string: sub, attributes: [ .font: UIFont.systemFont(ofSize: 18 * fontFactor, weight: .medium),  .foregroundColor: UIColor.black]))
        titleLabel.attributedText = topString
        
        topString.addAttributes([ .strokeColor: UIColor.white,.strokeWidth: NSNumber(value: 15)], range: NSMakeRange(0, title.count + sub.count))
        titleDecoLabel.attributedText = topString
    }
    
    fileprivate var firstLoad = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            firstLoad = false
            scorecardAll.frame = CGRect(x: 0, y: topLength , width: width, height: mainFrame.height + 49)
            scorecardAll.transform = CGAffineTransform(scaleX: 0.4, y: 0.4).translatedBy(x: 0, y: height)
        
            displayView.setNeedsDisplay()
            
            UIView.animate(withDuration: 0.3) {
                self.melody.transform = CGAffineTransform.identity
                self.dancing.transform = CGAffineTransform.identity
                self.decoration.transform = CGAffineTransform.identity
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.05, usingSpringWithDamping: 0.6, initialSpringVelocity: fontFactor * 4, options: .curveEaseIn, animations: {
                for balloon in self.balloons {
                    balloon.transform = CGAffineTransform.identity
                }
            }) { (true) in
                self.view.isUserInteractionEnabled = true
                let images = [UIImage(named: "scorecard_dancing_0") ?? #imageLiteral(resourceName: "mushroomHouse"), UIImage(named: "scorecard_dancing_1") ?? #imageLiteral(resourceName: "mushroomHouse")]
                self.dancing.image = UIImage.animatedImage(with: images, duration: 0.6)
                self.animateBalloons()
            }
        }
    }
    
    fileprivate var balloonTimer: Timer!
    fileprivate func animateBalloons() {
        var current = 0
        if balloonTimer == nil {
            balloonTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (timer) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.focusOnBalloon(current)
                }, completion: { (true) in
                    current += 1
                    if current == (self.withFYI ? self.balloons.count : self.balloons.count - 1) {
                        // go to next view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            self.showScorecard("cover")
                        })
                    }
                })
            })
        }
    }
    
    fileprivate func focusOnBalloon(_ current: Int) {
        if current > 4 {
            print("index is wrong")
            return
        }
        let titles = ["What's your score?", "Why this score?", "How to improve your score?", "Your curated insight at anytime", "For Your Information"]
        let topics = ["What", "Why","How", "insight", "F"]
        for (i, balloon) in self.balloons.enumerated() {
            balloon.transform = CGAffineTransform.identity
            if i == current {
                balloon.transform = CGAffineTransform(scaleX: 2.4, y: 2.4)
                melodyBack.bringSubviewToFront(balloon)
            }
        }
        
        let title = titles[current]
        let topString = NSMutableAttributedString(string: title, attributes: [ .font:  UIFont.systemFont(ofSize: 30 * fontFactor, weight: .medium),  .foregroundColor: UIColor.red])
        let length = topics[current].count
        topString.addAttributes([ .foregroundColor: UIColor.black,  .font: UIFont.systemFont(ofSize: 38 * fontFactor, weight: .heavy)], range: NSMakeRange(current != 3 ? 0 : 13, length))
        
        self.titleLabel.attributedText = topString
        
        topString.addAttributes([ .strokeColor: UIColor.white,  .strokeWidth: NSNumber(value: 15)], range: NSMakeRange(0, title.count))
        
        self.titleDecoLabel.attributedText = topString
    }
    fileprivate var display = false
    fileprivate func showScorecard(_ typeValue: String) {
        if display {
            return
        }
        display = true
        
        if showTimer != nil {
            showTimer.invalidate()
            showTimer = nil
        }
        
        if balloonTimer != nil {
            balloonTimer.invalidate()
            balloonTimer = nil
            for ballloon in balloons {
                ballloon.transform = CGAffineTransform.identity
            }
            setupDefaultTitle()
        }
        
        let offsetY = displayView.frame.minY
        UIView.animate(withDuration: 0.4, animations: {
            self.cloudTop.transform = CGAffineTransform(translationX: 0, y: -offsetY)
            self.displayView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
            self.scorecardAll.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (true) in
            self.melodyBack.isHidden = true
            
            self.allBackImageView.image = (WHATIF ? ProjectImages.sharedImage.categoryBackV : ProjectImages.sharedImage.categoryBack)
            self.navigationController?.setToNormalBar()
            UIView.animate(withDuration: 0.3, animations: {
                self.scorecardAll.transform = CGAffineTransform.identity
            }, completion: { (true) in
                self.scorecardAll.scrollToIndicatorOfType(typeValue)
            })
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
         showScorecard("cover")
    }
    
    @IBAction func balloonIsTouched(_ sender: UIButton) {
        if balloonTimer != nil {
            balloonTimer.invalidate()
            balloonTimer = nil
        }
        
        let balloonIndex = sender.tag - 100
        focusOnBalloon(balloonIndex)
        
        let balloons = ["what", "why", "how", "insight", "fyi"]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showScorecard(balloons[balloonIndex])
        }
    }
}
