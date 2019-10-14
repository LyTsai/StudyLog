//
//  TemplateCardsStack.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/11/21.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// MARK: ------------ special class for cardTemplateView ---------
class TemplateCardContainer: UIView {
    // view host delegate
    weak var assessmentTopDelegate: AssessmentTopView!
    fileprivate var allCards = [CardInfoObjModel]()
    fileprivate let textLabel = UILabel()
    
    // sub
    var numberOfCards: Int {
        return allCards.count
    }
    
    var margin: CGFloat {
        return 20 * bounds.width / 375
    }
    
    func loadDataWithCards(_ cards: [CardInfoObjModel], startIndex: Int) {
        // remove all
        for view in subviews {
            view.removeFromSuperview()
        }
        
        self.allCards = cards
       
        // index
        if startIndex < 0 || startIndex >= numberOfCards {
            currentCardIndex = 0
        }else {
            currentCardIndex = startIndex
        }
        
        currentCard = getCardTemplateViewAtIndex(currentCardIndex)
        addSubview(currentCard)
        currentCard.beginToShow()
        
        // number index
        textLabel.textColor = UIColor.white
        addSubview(textLabel)
        // add only one card
        textLabel.frame = CGRect(x: margin, y: 0, width: bounds.width * 0.4, height: margin * 1.7)
        textLabel.font = UIFont.systemFont(ofSize: margin * 0.8, weight: .semibold)
        textLabel.textAlignment = .left
        
        addArrows()
    }
    
    fileprivate func getCardAtIndex(_ index: Int) -> CardInfoObjModel! {
        if index < 0 || index >= numberOfCards {
            return nil
        }
        return allCards[index]
    }
    
    // card
    var currentCardFrame = CGRect.zero
    var duration: TimeInterval = 0.2
    var rotationAngle = CGFloat(Double.pi) / 4

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
    var currentCard: CardTemplateView!
    var anotherCard: CardTemplateView!
    fileprivate func getCardTemplateViewAtIndex(_ index: Int) -> CardTemplateView {
        if let card = getCardAtIndex(index) {
            let cardView = CardTemplateManager.sharedManager.createCardTemplateWithKey(card.cardStyleKey, frame: CGRect.zero)
            cardView.hostView = assessmentTopDelegate
            cardView.actionDelegate = assessmentTopDelegate
            cardView.setCardContent(card, defaultSelection: card.getDisplayOptions().first)
            // images
            cardView.setupCardBackAndStyles()
            
            // frame set up
            if cardView.isKind(of: JudgementCardTemplateView.self) {
                cardView.frame = getPreferedCardFrame()
                cardView.addActions()
            }else {
                cardView.frame = bounds
                cardView.cardFrame = getPreferedCardFrame()
            }
            
            currentCardFrame = cardView.frame
            cardView.setupCardAnswerUI()
            
            return cardView
        }
        
        return CardTemplateView()
    }

    
    // return prefered card frame
    fileprivate func getPreferedCardFrame() -> CGRect {
        return CGRect(x: margin, y: margin * 1.5, width: bounds.width - 2 * margin, height: bounds.height - 2.4 * margin)
    }

    
    // MARK: ---------- actions and animations
    // skip
    // only for templateview
    @objc func skipCurrentCard()  {
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
        currentCard.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        leftArrow.isEnabled = false
        rightArrow.isEnabled = false
        assessmentTopDelegate.cardIndexCollection.isUserInteractionEnabled = false
        
        let vc = self.assessmentTopDelegate.controllerDelegate
        // fly away the upCard
        currentCard.endShow()
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            let translation = CGAffineTransform(translationX: offset.width, y: offset.height)
            let addScale = translation.scaledBy(x: 0.09, y: 0.09)
            let combine = offset.width < 0 ? addScale.rotated(by: -self.rotationAngle) : addScale.rotated(by: self.rotationAngle)
            self.currentCard.transform = combine
            self.currentCard.alpha = 0.2
            
        }, completion: { (true) in
            self.currentCard.removeFromSuperview()
            // go to the cart
            if offset.width > 0 {
                vc?.cartIsAdded()
            }
        })
        
        // next animation
        if numberOfCards != 0 && currentCardIndex != numberOfCards - 1 {
            // show the next card
            anotherCard = getCardTemplateViewAtIndex(nextIndex)
            anotherCard.transform = CGAffineTransform.identity
            anotherCard.frame = currentCardFrame
            anotherCard.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            insertSubview(anotherCard, belowSubview: currentCard)
            anotherCard.alpha = 0.5
            
            // for down
            UIView.animate(withDuration: duration, delay: duration * 0.5, options: .curveEaseInOut, animations: {
                self.anotherCard.alpha = 1
                self.anotherCard.transform = CGAffineTransform.identity
            }, completion: { (true) in
                self.currentCard = self.anotherCard
                self.leftArrow.isEnabled = true
                self.rightArrow.isEnabled = true
                self.assessmentTopDelegate.cardIndexCollection.isUserInteractionEnabled = true
                self.currentCard.beginToShow()
            })
            
            // scroll current card
            self.currentCardIndex = nextIndex
            self.assessmentTopDelegate.setupProcess(nextIndex)
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.3, execute: {
                // go to next category
                vc?.navigationController?.popViewController(animated: true)
            })
        }
        
        bringSubviewToFront(leftArrow)
        bringSubviewToFront(rightArrow)
    }
    
    // fly back animation
    func comeBackTo(_ lastIndex: Int) {
        if numberOfCards == 0 || currentCardIndex == 0 {
            return
        }
        
        leftArrow.isEnabled = false
        rightArrow.isEnabled = false
        assessmentTopDelegate.cardIndexCollection.isUserInteractionEnabled = false
        
        // get the last card back
        anotherCard = getCardTemplateViewAtIndex(lastIndex)
       
        // in case upCard is not thrown away
        anotherCard.transform = CGAffineTransform(translationX: -self.currentCardFrame.width * 0.6, y: self.currentCardFrame.height * 1.1)
        
        addSubview(anotherCard)
        // fly away the upCard
        currentCard.endShow()
        UIView.animate(withDuration: duration, animations: {
            self.anotherCard.transform = CGAffineTransform.identity
            self.anotherCard.alpha = 1
            self.currentCard.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { (true) in
            self.currentCard.removeFromSuperview()
            self.currentCard = self.anotherCard
            self.currentCard.beginToShow()
            self.leftArrow.isEnabled = true
            self.rightArrow.isEnabled = true
            self.assessmentTopDelegate.cardIndexCollection.isUserInteractionEnabled = true
        }) 

        currentCardIndex = lastIndex
        assessmentTopDelegate.setupProcess(lastIndex)
        
        bringSubviewToFront(leftArrow)
        bringSubviewToFront(rightArrow)
    }
    
    @objc func comeBack() {
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
        let arrowY = bounds.midY - arrowHeight * 0.5
        
        let leftFrame = CGRect(x: 0, y: arrowY, width: arrowWidth, height: arrowHeight)
        let rightFrame = CGRect(x: bounds.width - arrowWidth, y: arrowY, width: arrowWidth, height: arrowHeight)
        
        leftArrow.setBackgroundImage(UIImage(named: "move_to_left"), for: .normal)
        leftArrow.frame = leftFrame
        leftArrow.layer.addBlackShadow(3)
        leftArrow.layer.shadowColor = UIColorGray(213).cgColor
        
        rightArrow.setBackgroundImage(UIImage(named: "move_to_right"), for: .normal)
        rightArrow.frame = rightFrame
        rightArrow.layer.addBlackShadow(3)
        rightArrow.layer.shadowColor = UIColorGray(213).cgColor
        
        addSubview(leftArrow)
        addSubview(rightArrow)
        
        leftArrow.addTarget(self, action: #selector(comeBack), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(skipCurrentCard), for: .touchUpInside)
    }
}
