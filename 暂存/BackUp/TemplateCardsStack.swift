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
    var duration: TimeInterval = 0.4
    var rotationAngle = CGFloat(Double.pi) / 4
    
    fileprivate let cursor = RiskMetricCardsCursor.sharedCursor
    
    // card factory where to access all cards infromation
    fileprivate let cardFactory = VDeckOfCardsFactory.metricDeckOfCards
    
    func showDeckOfCards(_ startIndex: Int!)  {
        loadOneTemplateCards(getDataSource(), startIndex: startIndex)
        usedForAnsweringCards()
    }
    
    var currentCardIndex: Int = 0 {
        didSet{
            leftArrow.isHidden = (currentCardIndex == 0)
            let rightImage = (currentCardIndex == numberOfCards - 1 ? UIImage(named: "move_to_summary"): UIImage(named: "move_to_right") )
            rightArrow.setBackgroundImage(rightImage, for: .normal)
            textLabel.text = "\(currentCardIndex + 1) of \(numberOfCards)"
        }
    }
    
    // init
    // load views
    fileprivate func getCardWithIndex(_ index: Int) -> CardTemplateView {
        let vCard = cardFactory.getVCard(index)
        let styleKey = vCard?.cardStyleKey
        
        let card = CardTemplateManager.sharedManager.createCardTemplateWithKey(styleKey, frame: CGRect.zero)
        card.hostView = assessmentTopDelegate
        
        let cardInfo = cardFactory.getVCard(index)!
        card.setCardContent(cardInfo, defaultSelection: cardFactory.getCardOption(index))
        
        // images
        card.setupCardImages()
        
        // old values
        if card.isKind(of: JudgementCardTemplateView.self) {
            card.frame = getPreferedCardFrame()
            card.addActions()
        }else {
            card.frame = bounds
            card.cardFrame = getPreferedCardFrame()
        }
        
        card.setupCardAnswerUI()
        return card
    }
    
    
    fileprivate func getDataSource() -> [CardTemplateView]{
        var cardViews = [CardTemplateView]()
        
        for i in 0..<cardFactory.totalNumberOfItems() {
            let vCard = cardFactory.getVCard(i)
            let styleKey = vCard?.cardStyleKey
            
            let card = CardTemplateManager.sharedManager.createCardTemplateWithKey(styleKey, frame: CGRect.zero)
            card.hostView = assessmentTopDelegate
            
            let cardInfo = cardFactory.getVCard(i)!
            card.setCardContent(cardInfo, defaultSelection: cardFactory.getCardOption(i))
            
            // images
            card.setupCardImages()
            
            // old values
            if card.isKind(of: JudgementCardTemplateView.self) {
                card.frame = getPreferedCardFrame()
                card.addActions()
            }else {
                card.frame = bounds
                card.cardFrame = getPreferedCardFrame()
            }
            
            card.setupCardAnswerUI()

            cardViews.append(card)
        }
        
        return cardViews
    }
    
    // return prefered card frame
    fileprivate func getPreferedCardFrame() -> CGRect {
        return CGRect(x: margin, y: margin * 1.5, width: bounds.width - 2 * margin, height: bounds.height - 2.4 * margin)
    }
    
    // sub
    var totalTemplateCards = [UIView]() // the totalCards, not like the "totalCards" in super class if using many cards on screen
    var numberOfCards: Int {
        return totalTemplateCards.count
    }
    
    var margin: CGFloat {
        return 20 * bounds.width / 375
    }
    
    // cards
    fileprivate let textLabel = UILabel()
    func loadOneTemplateCards(_ cards: [UIView], startIndex: Int!) {
        // remove all
        for view in subviews{
            view.removeFromSuperview()
        }
        
        totalTemplateCards = cards
        
        if startIndex == nil || startIndex < 0 || startIndex >= cards.count {
            currentCardIndex = 0
        }else {
            currentCardIndex = startIndex
        }
       
        textLabel.textColor = UIColor.white
        
        // add only one card
        switch numberOfCards {
        case 0:
            textLabel.frame = bounds
            textLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightBold)
            textLabel.textAlignment = .center
            textLabel.text = "No Card"
        default:
            textLabel.frame = CGRect(x: margin, y: 0, width: bounds.width * 0.4, height: margin * 1.7)
            textLabel.font = UIFont.systemFont(ofSize: margin * 0.8, weight: UIFontWeightSemibold)
            textLabel.textAlignment = .left
            
            let card = cards[currentCardIndex]
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
        }
        
        addSubview(textLabel)
    }
    
    
    // actions for different uses
    func usedForAnsweringCards()  {
        addArrows()
        
        // arrows
        leftArrow.addTarget(self, action: #selector(comeBack), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(skipCurrentCard), for: .touchUpInside)
    }
    
    // MARK: ---------- actions and animations
    // skip
    // only for templateview
    func skipCurrentCard()  {
        showNextCard(CGSize(width: -self.currentCardFrame.width * 0.55, height: self.currentCardFrame.height * 0.55), nextIndex: currentCardIndex + 1)
    }
    
    func answerCurrentCard(_ destination: CGPoint) {
        let offset = CGSize(width: destination.x - currentCardFrame.midX, height: destination.y - currentCardFrame.midY)
        showNextCard(offset, nextIndex: currentCardIndex + 1)
        // animation for cart
    }
    
    // go to appointed card
    func goToCard(_ cardIndex: Int) {
        if cardIndex < 0 || cardIndex >= numberOfCards || cardIndex == currentCardIndex {
            return
        }
        if cardIndex < currentCardIndex {
            // go back
            comeBackTo(cardIndex)
        }else {
            // go next
            showNextCard(CGSize(width: -self.currentCardFrame.width * 0.6, height: self.currentCardFrame.height * 0.8), nextIndex: cardIndex)
        }
    }
    
    // replay
    func getBackToFirstCard() {
        goToCard(0)
    }
    
    // animation for differrent destionation
    // 1. fly away: CGAffineTransform(translationX: -self.currentCardFrame.width * 0.6, y: -self.currentCardFrame.height * 1.1)
    // 2. answered
    func showNextCard(_ offset: CGSize, nextIndex: Int){
        let upCard = totalTemplateCards[currentCardIndex]
        upCard.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        let vc = self.assessmentTopDelegate.controllerDelegate
        // fly away the upCard
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            let translation = CGAffineTransform(translationX: offset.width, y: offset.height)
            let addScale = translation.scaledBy(x: 0.09, y: 0.09)
            let combine = offset.width < 0 ? addScale.rotated(by: -self.rotationAngle) : addScale.rotated(by: self.rotationAngle)
            upCard.transform = combine
            upCard.alpha = 0.2
            
        }, completion: { (true) in
            upCard.removeFromSuperview()
            
            // go to the cart
            if offset.width > 0 {
                vc?.cartIsAdded()
            }
        })
        
        // next animation
        if numberOfCards != 0 && currentCardIndex != numberOfCards - 1 {
            // show the next card
            let downCard = totalTemplateCards[nextIndex]
            downCard.transform = CGAffineTransform.identity
            downCard.frame = currentCardFrame
            downCard.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            insertSubview(downCard, belowSubview: upCard)
            downCard.alpha = 0.5
            
            // for down
            UIView.animate(withDuration: duration * 1.3, delay: duration * 0.5, options: .curveEaseInOut, animations: {
                downCard.alpha = 1
                downCard.transform = CGAffineTransform.identity
            }, completion: { (true) in

            })
            
            // scroll current card
            self.currentCardIndex = nextIndex
            self.assessmentTopDelegate.setupProcess(nextIndex)
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2 * duration + 0.3, execute: {
                // go to next category
                vc?.navigationController?.popViewController(animated: true)
            })
        }
        
        bringSubview(toFront: leftArrow)
        bringSubview(toFront: rightArrow)
    }
    
    // fly back animation
    func comeBackTo(_ lastIndex: Int) {
        if numberOfCards == 0 || currentCardIndex == 0 {
            return
        }
        
        // get the last card back
        let upCard = totalTemplateCards[lastIndex]
        let downCard = totalTemplateCards[currentCardIndex]
        
        // in case upCard is not thrown away
        upCard.transform = CGAffineTransform(translationX: -self.currentCardFrame.width * 0.6, y: self.currentCardFrame.height * 1.1)
        
        addSubview(upCard)
        // fly away the upCard
        UIView.animate(withDuration: duration, animations: {
            upCard.transform = CGAffineTransform.identity
            upCard.alpha = 1
            downCard.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { (true) in
            downCard.removeFromSuperview()
        }) 

        currentCardIndex = lastIndex
        assessmentTopDelegate.setupProcess(lastIndex)
        
        bringSubview(toFront: leftArrow)
        bringSubview(toFront: rightArrow)
    }
    
    func comeBack() {
        comeBackTo(currentCardIndex - 1)
    }
    
    // MARK: ---------- other subviews ------------------

    // left-right arrows
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    
    fileprivate func addArrows() {
        if numberOfCards == 0 {
            return
        }
        let arrowWidth = 28 * bounds.width / 375
        let arrowHeight = 90 * bounds.width / 375
        let arrowY = currentCardFrame.midY - arrowHeight * 0.5
        
        let leftFrame = CGRect(x: 0, y: arrowY, width: arrowWidth, height: arrowHeight)
        let rightFrame = CGRect(x: bounds.width - arrowWidth, y: arrowY, width: arrowWidth, height: arrowHeight)
        
        leftArrow.setBackgroundImage(UIImage(named: "move_to_left"), for: .normal)
        leftArrow.frame = leftFrame
        leftArrow.isHidden = true
        leftArrow.layer.addBlackShadow(3)
        leftArrow.layer.shadowColor = UIColorGray(213).cgColor
        
        rightArrow.setBackgroundImage(UIImage(named: "move_to_right"), for: .normal)
        rightArrow.frame = rightFrame
        rightArrow.layer.addBlackShadow(3)
        rightArrow.layer.shadowColor = UIColorGray(213).cgColor
        
        addSubview(leftArrow)
        addSubview(rightArrow)
    }
}
