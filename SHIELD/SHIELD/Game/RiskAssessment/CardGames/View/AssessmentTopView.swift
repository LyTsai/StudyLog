//
//  AssessmentTopView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/31.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

// AssessmentTopView: AssessmentModelView navigation view over [User][riskClasses][RiskObjModel]
// MARK: ------------------ risk assessment view -----------------
// class
class AssessmentTopView: UIView, CardActionProtocol {
    var cardIndexCollection: CardIndexCollectionView!
    var bottomProcess: CardProcessIndicatorView!
    var riskHintView: RiskSelectionHintView!
    let personImageView = UIImageView()
    
    var cartCenter = CGPoint(x: 300, y: 40)
    weak var controllerDelegate: ABookRiskAssessmentViewController!
    
    fileprivate var headerHeight: CGFloat {
        return 63 * standHP
    }
    
    fileprivate var bottomHeight: CGFloat {
        return 40 * standHP
    }

    
    //////////////////////////////////////////////////////////////////////////////
    // views for presenting the data input cards.  this is the card "working" area
    // only one view can be visible at any given time
    //////////////////////////////////////////////////////////////////////////////
    // stack view.  deck of cards style
    var stackView: TemplateCardContainer!
    
    fileprivate var allCards = [CardInfoObjModel]()
    // methods
    // ---------------- init ------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUIAndData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUIAndData()
    }
    
    fileprivate func updateUIAndData() {

        // create views ready for use in the card view area
        createCardsDisplayView()
       
        // header
        let headerFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: headerHeight))
        cardIndexCollection = CardIndexCollectionView.createWithFrame(headerFrame)
       
        cardIndexCollection.assessmentViewDelegate = self
        addSubview(cardIndexCollection)
        
        // bottom
        addBottomIndicator()
        
        // init state
        
        if GameTintApplication.sharedTint.focusingTierIndex == 2 {
            setupHint()
        }
    }
    
    func loadWithCards(_ cards: [CardInfoObjModel]) {
        allCards = cards
        
        // the first unanswered card in deck
        var startIndex = 0
        for (i, card) in allCards.enumerated() {
            if card.currentSelection() == nil {
                startIndex = i
                break
            }
        }
        
        cardIndexCollection.allCards = allCards
        stackView.loadDataWithCards(allCards, startIndex: startIndex)
        bottomProcess.allCards = allCards
        
        setupProcess(startIndex)
        
        setupMaskPath(-1)
    }
    
    fileprivate func addBottomIndicator() {
        let bottomY = bounds.height - bottomHeight
        let xMargin = 10 * standWP
        let arrowWidth = 10 * standWP
        
        // two arrows
        let left = UIImageView(image: UIImage(named: "indi_left"))
        let right = UIImageView(image: UIImage(named: "indi_right"))
        left.contentMode = .scaleAspectFit
        right.contentMode = .scaleAspectFit
        
        left.frame = CGRect(x: xMargin, y: bottomY, width: arrowWidth, height: bottomHeight)
        right.frame = CGRect(x: bounds.width - xMargin - arrowWidth, y: bottomY, width: arrowWidth, height: bottomHeight)
        
        addSubview(left)
        addSubview(right)
        
        // process
        bottomProcess = CardProcessIndicatorView.createWithFrame(CGRect(x: 0, y: bottomY, width: bounds.width, height: bottomHeight).insetBy(dx: xMargin + arrowWidth, dy: 0))
        
        bottomProcess.cardPlayDelegate = self
        addSubview(bottomProcess)
    }
    
    // hint
    fileprivate func setupHint() {
        // risk hint view
        var attriString: NSAttributedString!
            if let riskHint = cardsCursor.focusingRisk.info_riskHint {
                attriString = NSAttributedString(string: riskHint, attributes: [.font: UIFont.systemFont(ofSize: 20 * maxOneP, weight: .semibold)])
            }
        
        let hPerson = UIImage(named: "card_hint")!
        riskHintView = RiskSelectionHintView.createWithFrame(bounds, hint: attriString, personImage: hPerson, color: CardViewImagesCenter.sharedCenter.mainColor)
        riskHintView.hostView = self
        addSubview(riskHintView)
        
        // 112 * 140
        personImageView.image = hPerson
        personImageView.contentMode = .scaleAspectFit
        personImageView.frame = personFrame
        addSubview(personImageView)
        
        riskHintView.isHidden = true
        personImageView.isHidden = true
        
        checkHintForRisk()
    }
    
    fileprivate var personFrame: CGRect {
        return CGRect(x: bounds.width - 132 * fontFactor, y: bounds.height * 0.5, width: 112 * fontFactor, height: 140 * fontFactor)
    }
    
    fileprivate var cardPerson: UIButton!
    var personOffset: UIOffset {
        // margin
        let desCenter = CGPoint(x: 36 * standWP, y: stackView.frame.maxY - 40 * standWP)
        return UIOffset(horizontal: desCenter.x - personFrame.midX, vertical: desCenter.y - personFrame.midY)
    }
    
    // check
    fileprivate func checkHintForRisk() {
        // MARK:---------- risk
        let key = cardsCursor.focusingRiskKey!
        let keyString = "CardHintIsShownFor\(String(describing: key))"
        
        // should show
        if !userDefaults.bool(forKey: keyString) {
            riskHintView.isHidden = false
            personImageView.isHidden = false
            personImageView.transform = CGAffineTransform.identity
            
            // save in sand box
            userDefaults.set(true, forKey: keyString)
            userDefaults.synchronize()
        }
    }
    
    func showRiskHint(_ button: UIButton) {
        if riskHintView == nil {
            return
        }
        
        cardPerson = button
        cardPerson.isHidden = true
        
        self.personImageView.transform = CGAffineTransform(translationX: personOffset.horizontal, y: personOffset.vertical)
        self.personImageView.transform = self.personImageView.transform.scaledBy(x: 0.8, y: 0.8)
        personImageView.isHidden = false
        
        self.riskHintView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
           self.personImageView.transform = CGAffineTransform.identity
             self.riskHintView.layer.transform = CATransform3DIdentity
        }, completion: { (true) in
            self.riskHintView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        })
    }
    
    func hideRiskHint() {
        riskHintView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.3, animations: {
            var transform = CATransform3DIdentity
            transform.m34 = -0.001
            transform = CATransform3DRotate(transform, CGFloat(Double.pi) / 2, 0, 1, 0)
            transform = CATransform3DScale(transform, 0.7, 0.7, 1)
            self.riskHintView.layer.zPosition = 1000
            self.personImageView.layer.zPosition = 1001
            self.riskHintView.layer.transform = transform
            
            self.personImageView.transform = CGAffineTransform(translationX: self.personOffset.horizontal, y: self.personOffset.vertical)
            self.personImageView.transform = self.personImageView.transform.scaledBy(x: 1, y: 1)
        }) { (true) in
            self.riskHintView.isHidden = true
            self.personImageView.isHidden = true
            if self.cardPerson != nil {
                self.cardPerson.isHidden = false
            }
        }
    }
    
    // cards
    fileprivate func createCardsDisplayView()  {
        let cardsViewFrame = CGRect(x: 0, y: headerHeight * 0.65, width: bounds.width, height: bounds.height - headerHeight * 0.65 - bottomHeight)
        
        // Stack
        stackView = TemplateCardContainer(frame: cardsViewFrame)
        stackView.assessmentTopDelegate = self
       
        addSubview(stackView)
    }

    // MARK: ----------- up arrow -----------------
    // set arrow
    func setupMaskPath(_ optionIndex: Int) {
        // cardsCursor
        let item = cardIndexCollection.currentItem
        if item < 0 || item >= allCards.count {
            return
        }
        
        let card = allCards[item]
        if card.isJudgementCard() {
            cardIndexCollection.cursorItem = 0
        }else if optionIndex < 0  || optionIndex >= card.getDisplayOptions().count {
            cardIndexCollection.cursorItem = 0
        }else {
            cardIndexCollection.cursorItem = optionIndex
        }
    }
    
    
    // navigate to risk model of risk class
    // riskKey - selected risk model of riskClassKey risk class
    fileprivate let userDefaults = UserDefaults.standard
    func goToCard(_ cardIndex: Int) {
        stackView.goToCard(cardIndex)
    }
    
    func setupProcess(_ cardIndex: Int) {
        cardIndexCollection.focusOnItem(cardIndex)
        bottomProcess.currentItem = cardIndex + 1
    }

    ///////////////////////////////////////////////////////////////////

    // choose answer
    func setupIndicator(_ item: Int) {
        // add answer
        setupMaskPath(item)
        cardIndexCollection.setupAnswers(stackView.currentCardIndex, value: item)
        bottomProcess.answeredForItem(stackView.currentCardIndex + 1)
    }
    
    fileprivate var cardInfoAccess: CardInfoAccess!
    func card(_ cardView: CardTemplateView, chooseItemAt item: Int) {
        setupIndicator(item)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.stackView.answerCurrentCard(self.cartCenter)
            self.cardIndexCollection.focusOnItem(self.stackView.currentCardIndex)
        }
    }
    
    
    func card(_ cardView: CardTemplateView, input value: Float) {
        setupIndicator(0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.stackView.answerCurrentCard(self.cartCenter)
            self.cardIndexCollection.focusOnItem(self.stackView.currentCardIndex)
        }
    }
}

