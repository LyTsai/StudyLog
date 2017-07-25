//
//  TemplateCardsStack.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/11/21.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// MARK: ------------ special class for cardTemplateView ---------

class TemplateCardContainer: UIView, MetricDeckOfCardsViewProtocol {
    // view host delegate
    weak var assessmentTopDelegate: AssessmentTopView!
    
    // cards
    var currentCardFrame = CGRect.zero
    var duration: TimeInterval = 0.5
    var rotationAngle = CGFloat(M_PI) / 3
    
    fileprivate let cursor = RiskMetricCardsCursor.sharedCursor
    
    // card factory where to access all cards infromation
    fileprivate let cardFactory = VDeckOfCardsFactory.metricDeckOfCards
    
    func showDeckOfCards() {
        loadOneTemplateCards(getDataSource())
        usedForAnsweringCards()
    }
    
    var currentCardIndex: Int = 0 {
        didSet{
            cursor.focusingRiskCardIndex = currentCardIndex
            leftArrow.isHidden = (currentCardIndex == 0)
            let rightImage = (currentCardIndex == numberOfCards - 1 ? UIImage(named: "move_to_summary"): UIImage(named: "move_to_right") )
            rightArrow.setBackgroundImage(rightImage, for: .normal)
            textLabel.text = "\(currentCardIndex + 1) of \(numberOfCards)"
        }
    }
    
    // init
    // load views
    fileprivate func getDataSource() -> [CardTemplateView]{
        var cardViews = [CardTemplateView]()
        
        for i in 0..<cardFactory.totalNumberOfItems() {
            let vCard = cardFactory.getVCard(i)
            var styleKey = vCard?.cardStyleKey
            
            if cursor.focusingRiskKey == "d87662dc-9d27-11e6-80f5-76304dec7eb7" {
                styleKey = MeJudgementCardTemplateView.styleKey()
            }
            
            let card = CardTemplateManager.sharedManager.createCardTemplateWithKey(styleKey, frame: CGRect.zero)
            
            if card.isKind(of: JudgementCardTemplateView.self) {
                card.frame = getPreferedCardFrame()
                card.addActions()                
            }else {
                card.frame = bounds
                card.cardFrame = getPreferedCardFrame()
            }
            
            card.hostView = assessmentTopDelegate
            card.setCardContent(cardFactory.getVCard(i)!, defaultSelection: cardFactory.getCardOption(i))
            cardViews.append(card)
        }
        
        return cardViews
    }
    
    // return prefered card frame
    fileprivate func getPreferedCardFrame() -> CGRect {
        return CGRect(x: margin, y: margin * 0.5, width: bounds.width - 2 * margin, height: bounds.height - indicatorHeight - margin)
    }
    
    // sub
    var totalTemplateCards = [UIView]() // the totalCards, not like the "totalCards" in super class if using many cards on screen
    var numberOfCards: Int {
        return totalTemplateCards.count
    }
    
    var margin: CGFloat {
        return 15 * bounds.width / 375
    }
    
    fileprivate let textLabel = UILabel()
    func loadOneTemplateCards(_ cards: [UIView]) {
        // remove all
        for view in subviews{
            view.removeFromSuperview()
        }
        
        totalTemplateCards = cards
        currentCardIndex = 0
    
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.white

        addSubview(textLabel)
        
        // add only one card
        switch numberOfCards {
        case 0:
            textLabel.frame = bounds
            textLabel.font = UIFont.systemFont(ofSize: 20)
            textLabel.text = "No Card"
        default:
            textLabel.frame = CGRect(x: bounds.width * 0.2, y: bounds.height - indicatorHeight, width: bounds.width * 0.6, height: indicatorHeight)
            textLabel.font = UIFont.systemFont(ofSize: 10)
            let card = cards.first!
            addSubview(card)
            
            if card.isKind(of: CardTemplateView.self) {
                if card.isKind(of: JudgementCardTemplateView.self) {
                    currentCardFrame = getPreferedCardFrame()
                }else {
                    currentCardFrame = bounds
                }
            }else {
                currentCardFrame = getPreferedCardFrame()
            }
            
            card.frame = currentCardFrame
            textLabel.text = "1 of \(numberOfCards)"
        }

        addArrows()
    }
    
    
    // actions for different uses
    func usedForAnsweringCards()  {
        // gestures
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(comeBack))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        addGestureRecognizer(backSwipe)
        let skipSwipe = UISwipeGestureRecognizer(target: self, action: #selector(skipCurrentCard))
        skipSwipe.direction = UISwipeGestureRecognizerDirection.left
        addGestureRecognizer(skipSwipe)
        
        // arrows
        leftArrow.addTarget(self, action: #selector(comeBack), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(skipCurrentCard), for: .touchUpInside)
    }
    
    func usedForShowCards()  {
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(comeBack))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        addGestureRecognizer(backSwipe)
        let skipSwipe = UISwipeGestureRecognizer(target: self, action: #selector(showNextCard))
        skipSwipe.direction = UISwipeGestureRecognizerDirection.left
        addGestureRecognizer(skipSwipe)
        
        // arrows
        leftArrow.addTarget(self, action: #selector(comeBack), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(showNextCard), for: .touchUpInside)
    }
    
    
    // MARK: ---------- actions and animations
    // skip
    // only for templateview
    func skipCurrentCard()  {
        // card's process
        if numberOfCards == 0 {
            return
        }
        let card = totalTemplateCards[currentCardIndex]
        if card.isKind(of: CardTemplateView.self) {
            let tempCard = card as! CardTemplateView
            tempCard.skipCard()
        }
        
    }
    
    // go to appointed card
    fileprivate var appointedIndex = 0
    func goToCard(_ cardIndex: Int) {
        if cardIndex < 0 || cardIndex >= numberOfCards || cardIndex == currentCardIndex {
            return
        }
        
        appointedIndex = cardIndex
        let timeInterval: TimeInterval = min(2.0 / Double(numberOfCards), 0.1)
        
        if appointedIndex < currentCardIndex {
            Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(cardsFlyBack(_:)), userInfo: nil, repeats: true)
        }else {
            Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(cardsGoForward(_:)), userInfo: nil, repeats: true)
        }
    }
    
    
    func cardsFlyBack(_ timer: Timer) {
        comeBack()
        if currentCardIndex == appointedIndex {
            timer.invalidate()
        }
    }
    
    func cardsGoForward(_ timer: Timer) {
        showNextCard()
        if currentCardIndex == appointedIndex {
            timer.invalidate()
        }
    }
    
    // replay
    func getBackToFirstCard()  {
        goToCard(0)
    }

    // go to next card
    fileprivate var nextIndex: Int {
        return currentCardIndex + 1
    }
    
    func flyAwayAndPop() {
        // show next card
        if !cursor.atTheEnd() {
            showNextCard()
        }else {
            let vc = assessmentTopDelegate.controllerDelegate
            vc?.showIndividualSummary()
        }
    }
    
    func showNextCard(){
         // no card for it
        if numberOfCards != 0 && currentCardIndex != numberOfCards - 1 {
            // show the next card
            let upCard = totalTemplateCards[currentCardIndex]
            let downCard = totalTemplateCards[nextIndex]
            downCard.transform = CGAffineTransform.identity
            downCard.frame = currentCardFrame
            downCard.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            insertSubview(downCard, belowSubview: upCard)
            
            // fly away the upCard
            UIView.animate(withDuration: duration, animations: {
                let translation = CGAffineTransform(translationX: -self.currentCardFrame.width * 0.6, y: -self.currentCardFrame.height * 1.1)
                let addScale = translation.scaledBy(x: 0.5, y: 0.5)
                let combine = addScale.rotated(by: -self.rotationAngle)
                upCard.transform = combine
                upCard.alpha = 0.2
                
                // meantime, pop the downCard
                downCard.transform = CGAffineTransform.identity
                
            }, completion: { (true) in
                upCard.removeFromSuperview()
            })
            
            currentCardIndex += 1
//            pageIndicator.currentIndex = currentCardIndex
        }
    }
    
    // fly back animation, swipe gestureRecognizer
    fileprivate var lastIndex: Int {
        return currentCardIndex - 1
    }
    func comeBack(){
        if numberOfCards == 0 || currentCardIndex == 0 {
            return
        }
        
        // get the last card back
        let upCard = totalTemplateCards[lastIndex]
        let downCard = totalTemplateCards[currentCardIndex]
        addSubview(upCard)
        // fly away the upCard
        UIView.animate(withDuration: duration, animations: {
            upCard.transform = CGAffineTransform.identity
            upCard.alpha = 1
            downCard.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { (true) in
            downCard.removeFromSuperview()
        }) 

        currentCardIndex -= 1
//        pageIndicator.currentIndex = currentCardIndex
        assessmentTopDelegate.cardIndexCollection.focusOnItem(currentCardIndex)
        bringSubview(toFront: leftArrow)
        bringSubview(toFront: rightArrow)
    }
    
    // MARK: ---------- other subviews ------------------
    //use with PageIndicator
    var indicatorHeight: CGFloat {
        return 25 * bounds.width / 375
    }
    
    /*
    fileprivate var pageIndicator: StackPageControl!
    fileprivate func addPageIndicator()  {
        let frame = CGRect(x: bounds.width * 0.15, y: bounds.height - indicatorHeight, width: bounds.width * 0.7, height: indicatorHeight)
        pageIndicator = StackPageControl.createWithFrame(frame, totalNumber: numberOfCards)
        addSubview(pageIndicator)
    }
    */
    // left-right arrows
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    
    fileprivate func addArrows() {
        if numberOfCards == 0 {
            return
        }
        let arrowWidth = 31 * bounds.width / 375
        let arrowHeight = 90 * bounds.width / 375
        let arrowY = currentCardFrame.midY - arrowHeight * 0.5
        
        let leftFrame = CGRect(x: 0, y: arrowY, width: arrowWidth, height: arrowHeight)
        let rightFrame = CGRect(x: bounds.width - arrowWidth, y: arrowY, width: arrowWidth, height: arrowHeight)
        
        leftArrow.setBackgroundImage(UIImage(named: "move_to_left"), for: .normal)
        leftArrow.frame = leftFrame
        leftArrow.isHidden = true
        
        rightArrow.setBackgroundImage(UIImage(named: "move_to_right"), for: .normal)
        rightArrow.frame = rightFrame
        
        addSubview(leftArrow)
        addSubview(rightArrow)
    }
}
