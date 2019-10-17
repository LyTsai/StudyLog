//
//  SummaryViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/25.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SummaryViewController: PlayingViewController {
    override var playerReachable: Bool {
        return false
    }
    
    override var withCartIcon: Bool {
        return false
    }
    
    var mainColor = UIColor.blue
    var summaryRoad: SummaryOfCardsRoadCollectionView!
    
    var cards = [CardInfoObjModel]() {
        didSet{
            indiLabel.isHidden = true
            for card in cards {
                if !card.isJudgementCard() {
                    indiLabel.isHidden = false
                    break
                }
            }
        }
    }
    var forCart = false // change title during answering, for cart is ture: check cart
    var roadTitle = "" {
        didSet{
            titleLabel.text = "\(roadTitle)"
        }
    }
    
    var hideIndi = false {
        didSet{
            indiLabel.isHidden = hideIndi
        }
    }

    fileprivate let bottomView = UIView()
    fileprivate let bottomButton = GradientBackStrokeButton(type: .custom)
    
    fileprivate var startX: CGFloat {
        return 135 * standWP
    }
    fileprivate var cardLength: CGFloat {
        return fontFactor * 65
    }
    fileprivate var firstTop: CGFloat {
        return forCart ? 140 * fontFactor : 83 * fontFactor
    }
    
    var classificationTags = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allCards = collection.getAllDisplayCardsOfRisk(cardsCursor.focusingRiskKey)
        // Summaries, if "cards" is not set, use for all as default
        cards = forCart ? MatchedCardsDisplayModel.getCurrentMatchedCardsFromCards(allCards) : allCards
        
        classificationTags.removeAll()
        for option in cards.first!.getDisplayOptions() {
            if let classification = option.match?.classification {
                if let explain = classification.explainImageUrl {
                    classificationTags.append(explain)
                }
            }
        }
        
        // subviews
        addRoadViewAndButtons() // data loaded here
        
        addTitleCloudAndHint()
        hintDisplay(!forCart)
        
        setupWithState()
        if !forCart {
            roadTitle = "Card Selected: \(cartNumber)\nCard Total: \(cards.count)"
        }
        addClassificationLegends()
    }
    
    func setupWithState()  {
        bottomButton.backgroundColor = WHATIF ? whatIfTintColor : baselineTintColor
        bottomButton.setupWithTitle(WHATIF ? "Finish" : "Save and Finish")
        WHATIF ? summaryRoad.setForVirtual() : summaryRoad.setForReal()
        
        backImage = WHATIF ? ProjectImages.sharedImage.categoryBackV : ProjectImages.sharedImage.categoryBack
        titleImageView.image = WHATIF ? ProjectImages.sharedImage.roadCardTitleV : ProjectImages.sharedImage.roadCardTitle
        partImageView.image = WHATIF ? UIImage(named: "cart_display_part_whatIf"): UIImage(named: "cart_display_part")
    }
    
    // top
    fileprivate let cartImageView = UIImageView()
    fileprivate let partImageView = UIImageView()
    fileprivate let numberLabel = UILabel()
    fileprivate let indiLabel = UILabel()
    fileprivate func addRoadViewAndButtons() {
        mainColor = WHATIF ? UIColor.blue : UIColorFromHex(0x83F9E5)
        let roadY = classificationTags.isEmpty ? topLength : topLength + 70 * fontFactor
        summaryRoad = SummaryOfCardsRoadCollectionView.createWithFrame(CGRect(x: 0, y: roadY, width: width, height: height - roadY - bottomLength), cards: cards, mainColor: mainColor, forCart: forCart, cardLength: cardLength, startX: startX, firstTop: firstTop)
        summaryRoad.contentInsetAdjustmentBehavior = .never
        summaryRoad.hostVC = self
        view.addSubview(summaryRoad)
        
        // indi label
        indiLabel.numberOfLines = 0
        indiLabel.frame = CGRect(x: startX + cardLength, y: firstTop - 35 * fontFactor, width: 122 * fontFactor, height: 35 * fontFactor)
        
        let textSize = 16 * fontFactor
        indiLabel.font = UIFont.systemFont(ofSize: textSize, weight: .semibold)
        
        let tag = #imageLiteral(resourceName: "icon_legend")
        let imageText = NSTextAttachment()
        imageText.image = tag
        imageText.bounds = CGRect(x: 0, y: 0, width: textSize * 17 / 16, height: textSize)
        let indiAttri = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageText))
        indiAttri.append(NSAttributedString(string: "- Your match", attributes: [:]))
        
        indiLabel.attributedText = indiAttri
        summaryRoad.addSubview(indiLabel)
        
        // save button
        let remained: CGFloat = 65 * fontFactor
        bottomView.frame = CGRect(x: 0, y: mainFrame.maxY - remained, width: width, height: remained)
        bottomView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        view.addSubview(bottomView)
        
        bottomButton.frame = CGRect(center: CGPoint(x: width * 0.5, y: remained * 0.5), width: 135 * fontFactor ,height: 44 * fontFactor)
        
        bottomButton.addTarget(self, action: #selector(bottomButtonIsTouched(_:)), for: .touchUpInside)
        bottomView.addSubview(bottomButton)

        if forCart {
            // add cartView, cart_display_total
            let cartImage = UIImage(named: "cart_display")!
            let startHeight = firstTop * 0.88
            let startWidth = startHeight * cartImage.size.width / cartImage.size.height
            cartImageView.image = cartImage
            let startFrame = CGRect(x: 20 * standWP, y: roadY + 10 * fontFactor, width: startWidth, height: startHeight)
            cartImageView.frame = startFrame
            let startPoint = CGPoint(x: startFrame.minX + startWidth * 0.6, y: startFrame.maxY - startFrame.height * 0.06)
            summaryRoad.startPoint = view.convert(startPoint, to: summaryRoad)
            
            partImageView.frame = CGRect(x: startFrame.maxX - startWidth * 0.46, y: startFrame.minY + startHeight * 0.11, width: startWidth * 1.6, height: startHeight * 0.78)
            
            // label
            numberLabel.text = "total: \(cards.count)"
            numberLabel.font = UIFont.systemFont(ofSize: 14 * standWP, weight: .semibold)
            numberLabel.textAlignment = .center
            numberLabel.frame = CGRect(x: startFrame.width * 0.3, y: startFrame.height * 0.05, width: startFrame.width * 1.2, height: startFrame.height * 0.5)
            
            // add
            view.addSubview(partImageView)
            view.addSubview(cartImageView)
            partImageView.addSubview(numberLabel)
        }
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let titleImageView = UIImageView()
    fileprivate let hintView = UIView()
    fileprivate let handImageView = UIImageView()
    fileprivate func addTitleCloudAndHint() {
        // title part
        let titleImage = ProjectImages.sharedImage.roadCardTitle!
        let titleWidth = 107 * fontFactor
        titleImageView.frame = CGRect(x: width - titleWidth, y: topLength, width: titleWidth, height: titleImage.size.height * titleWidth / titleImage.size.width)
        titleImageView.image = titleImage
        
        // label on it
        let labelWidth = titleWidth * 0.82
        titleLabel.frame = CGRect(x: width - 4 * fontFactor - labelWidth, y: topLength, width: labelWidth, height: titleImageView.frame.height - fontFactor * 10)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .right
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 9 * fontFactor, weight: .medium)
        
        // hint
        hintView.frame = CGRect(x: 5 * fontFactor, y: firstTop + topLength, width: startX - 7 * fontFactor, height: cardLength)
        hintView.backgroundColor = UIColor.clear
        let backHint = UIView(frame: hintView.bounds)
        backHint.layer.borderColor = UIColorFromRGB(107, green: 130, blue: 0).cgColor
        backHint.layer.borderWidth = 2 * fontFactor
        backHint.layer.cornerRadius = 4 * fontFactor
        backHint.backgroundColor = UIColorFromRGB(194, green: 49, blue: 0)
        backHint.layer.addBlackShadow(4 * fontFactor)
        
        let hintLabel = UILabel()
        hintLabel.text = "Tap any card to change your selected match"
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
        hintLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        hintLabel.textColor = UIColor.white
        
        handImageView.image = UIImage(named: "tapHand")
        let ratio: CGFloat = 56 / 71
        let hintImageHeight = min(hintView.bounds.height * 0.8, hintView.bounds.width * 0.5 * ratio)
        handImageView.frame = CGRect(x: startX + cardLength * 0.5 - hintImageHeight / ratio, y: hintView.bounds.midY - hintImageHeight * 0.5, width: hintImageHeight / ratio, height: hintImageHeight)
        hintLabel.frame = CGRect(x: 3 * fontFactor, y: 5 * fontFactor, width: handImageView.frame.minX - 4 * fontFactor, height: hintView.bounds.height - 10 * fontFactor)
        handImageView.layer.addBlackShadow(4 * fontFactor)
        
        // set up
        setCartNumber()
        roadTitle = forCart ? "What‘s in my Cart" : "Cards Selected: \(cartNumber)\nCard Total: \(cards.count)"

        // addSubview
        view.addSubview(hintView)
        hintView.addSubview(backHint)
        hintView.addSubview(hintLabel)
        hintView.addSubview(handImageView)
        
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
    }
    
    fileprivate func addClassificationLegends() {
        for (i, legend) in classificationTags.enumerated() {
            let gap = 5 * fontFactor
            let tWidth = min( 59 * fontFactor, (width - 129 * fontFactor) / CGFloat(classificationTags.count) - gap)
 
            let imageView = UIImageView(frame: CGRect(x: gap + CGFloat(i) * (tWidth + gap), y: topLength + gap, width: tWidth, height: 68 * fontFactor))
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: legend, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, completed: nil)
            view.addSubview(imageView)
        }
    }
   
    // MARK: --------- change state and data
    func showAnswerWithCard(_ card: CardInfoObjModel) {
        hintDisplay(false)
        
        let cardChange = CardAnswerChangeViewController()
        cardChange.loadWithCard(card)
        if WHATIF {
            let baselineM = selectionResults.getLastMeasurementOfUser(userCenter.currentGameTargetUser.Key(), riskKey: cardsCursor.focusingRiskKey, whatIf: false)!
            if let index = card.getIndexChosenInMeasurement(baselineM) {
                cardChange.showBaseline(index)
            }
        }
        cardChange.summaryVC = self
        presentOverCurrentViewController(cardChange, completion: nil)
    }

    func answerIsSetForCard(_ card: CardInfoObjModel, result: Int!) {
        // data is changed before
        summaryRoad.changeAnswerOfCard(card, toIndex: result)
        if !forCart && result != nil {
            setCartNumber()
            // change title
            titleLabel.text = "Card Selected: \(cartNumber)\nCard Total: \(cards.count)"
        }
    }
    
    // MARK: ACTIONS
    //------------------ save ----------------------
    @objc func bottomButtonIsTouched(_ button: UIButton) {
        hintDisplay(false)
        
        // TODO: ------ only bonus is answered
        if cartNumber == 0 {
            presentNoAnswer()
        }else if !MatchedCardsDisplayModel.currentAllScoreCardsPlayed() {
            presentContinue()
        }else {
            saveDataAndLoad()
        }
    }

    fileprivate var timer: Timer!
    func hintDisplay(_ display: Bool) {
        if forCart {
            self.hintView.isHidden = true
        }

        let offsetY =  -(topLength + cardLength + firstTop) * 1.2
        UIView.animate(withDuration: 0.4, animations: {
            self.hintView.transform = CGAffineTransform(translationX: 0, y: display ? 0 : offsetY)
        }) { (true) in
            self.partImageView.isHidden = display
        }
        
        if display {
            // hint, animation
            if timer == nil {
                var count = 0
                var down = true
                timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
                    if count == 2 {
                        count = 0
                    }
                    self.handImageView.transform = CGAffineTransform(translationX: 0, y: count % 2 == 0 ? -4 * standWP : 4 * standWP)
                    count += 1
                    
                    // text is moving
                    if self.hintView.frame.minY <= self.firstTop + topLength {
                        down = true
                    }else if self.hintView.frame.maxY >= height - bottomLength - 80 * standHP {
                        down = false
                    }
                    
                    self.hintView.transform = self.hintView.transform.translatedBy(x: 0, y: (down ? 1 : -1) * 4 * standHP)
                })
            }
        }else {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
        }
    }
    
    // none is answered
    fileprivate func presentNoAnswer() {
        let alert = CatCardAlertViewController()
        alert.addTitle("No Card Is Answered Now", subTitle: nil, buttonInfo: [("Resume playing", true, resumePlaying)])
        
        presentOverCurrentViewController(alert, completion: nil)
    }
    
    // part answered
    fileprivate func presentContinue() {
        let alert = CatCardAlertViewController()
        alert.addTitle("You have not finished playing.", subTitle: "Do you want to", buttonInfo: [("Continue", false, saveDataAndLoad), ("Resume playing", true, resumePlaying)])
       presentOverCurrentViewController(alert, completion: nil)
    }
    
    fileprivate func resumePlaying() {
        let navi = self.navigationController!
        for vc in navi.viewControllers {
            if vc.isKind(of: CategoryViewController.self) {
                navi.popToViewController(vc, animated: true)
                return
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // save measurement
    fileprivate var loadingVC: LoadingViewController!
    fileprivate func saveDataAndLoad() {
        let userKey = userCenter.currentGameTargetUser.Key()
        let riskKey = cardsCursor.focusingRiskKey!
        measurement = selectionResults.prepareOneMeasurementForUser(userKey, ofRisk: riskKey)
        
        if measurement.values.count > 0 {
            // local
            if localDB.database.open() {
                measurement.saveToLocalDatabase()
                localDB.database.close()
            }
            selectionResults.saveAsLastRecord(measurement)
            
            if loadingVC == nil {
                loadingVC = LoadingViewController()
            }
            
            present(loadingVC, animated: true) {
                if WHATIF {
                    self.displayScoreCard()
                }else {
                    if self.measurementAccess == nil {
                        self.measurementAccess = MeasurementAccess(callback: self)
                    }
                    
                    // removeObject
                    let upload = selectionResults.changeForUpload(self.measurement)
                    self.measurementAccess?.addOne(oneData: upload)
                }
            }
        }
    }
    // MARK: ------------- save -------------------
    // for accessing the REST api backend service
    fileprivate var measurementAccess: MeasurementAccess?
    fileprivate var measurement: MeasurementObjModel!

    fileprivate func displayScoreCard() {
        DispatchQueue.global().async {
            let fulfills = selectionResults.getFulfillFromMeasurement(self.measurement)
            if !fulfills.isEmpty {
                if localDB.database.open() {
                    for fulfill in fulfills {
                        fulfill.saveToLocalDatabase()
                    }
                    localDB.database.close()
                }
            }
            
            DispatchQueue.main.async {
                if self.loadingVC != nil && self.loadingVC.isLoading {
                    self.loadingVC.dismiss(animated: true, completion: {
                         self.showScorecard()
                    })
                }else {
                     self.showScorecard()
                }
             }
        }
    }
    
    fileprivate func showScorecard() {
        let scoreCardVC = Bundle.main.loadNibNamed("ScoreCardViewController", owner: self, options: nil)?.first as! ScoreCardViewController
        scoreCardVC.setupWithMeasurement(self.measurement)
        navigationController?.pushViewController(scoreCardVC, animated: true)
    }
}

// REST
extension SummaryViewController: DataAccessProtocal {
    // measurement
    func didFinishAddDataByKey(_ obj: AnyObject) {
        self.displayScoreCard()
    }
    
    func failedAddDataByKey(_ error: String) {
        // relogin
        if error == unauthorized {
            let alert = UIAlertController(title: nil, message: "You are not authorized due to overtime idleness", preferredStyle: .alert)
            let relogin = UIAlertAction(title: "Log In", style: .default, handler: { (login) in
                let loginVC = LoginViewController.createFromNib()
                self.navigationController?.pushViewController(loginVC, animated: true)
            })
            let giveUp = UIAlertAction(title: "No", style: .destructive, handler: nil)
            
            alert.addAction(relogin)
            alert.addAction(giveUp)
            
            // alert
            if loadingVC != nil && self.loadingVC.isLoading{
                loadingVC.dismiss(animated: true, completion: {
                    self.present(alert, animated: true, completion: nil)
                })
            }
            
        }else {
            let alert = UIAlertController(title: "Net Error", message: "You can save data in local or retry", preferredStyle: .alert)
            let save = UIAlertAction(title: "Save in local", style: .default, handler: { (login) in
                self.displayScoreCard()
            })
            let retry = UIAlertAction(title: "Retry", style: .default, handler: { (login) in
                self.measurementAccess?.addOne(oneData: self.measurement)
            })
            
            alert.addAction(retry)
            alert.addAction(save)
            
            // alert
            if loadingVC != nil && self.loadingVC.isLoading {
                loadingVC.dismiss(animated: true, completion: {
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
}
