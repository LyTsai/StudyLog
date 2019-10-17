//
//  CardTemplateViewAction .swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/26.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// MARK: -------- only for saving data, if you want to custom the actions of buttons, please do not import this file ---------------
// actions for use, file seperated
extension CardTemplateView {
    // for all
    // set images with riskType
    func setupCardBackAndStyles() {
        if vCard == nil || option == nil {
            print("data missing")
            return
        }
        
        if vCard.isJudgementCard() {
            if let riskType = collection.getRiskTypeOfCard(vCard.key) {
                if RiskTypeType.getTypeOfRiskType(riskType) == .iKa {
                    leftButton.setupWithTitle("YES")
                    rightButton.setupWithTitle("NO")
                }
            }
        }

    }
    
    // set answer view
    func setupCardAnswerUI() {
        // old values
        if let result = vCard.currentSelection() {
            setUIForSelection(result)
        }
        
        if vCard.currentInput() != nil && vCard.isInputCard()  {
            setUIForSelection(1)
        }
    }
    
    func showHint() {
        if hostView != nil && hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostView as! AssessmentTopView
            
            if key() == JudgementCardTemplateView.styleKey() {
                let card = self as! JudgementCardTemplateView
                topView.showRiskHint(card.hintButton)
            }
        }
    }
    
    // MARK: ------- for part
    // action just for judgement cards, when used as single card
    func addActions()  {
        if leftButton == nil || rightButton == nil {
            return
        }
        
        leftButton.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonClicked), for: .touchUpInside)
    }
    
    // agree with the tatement shown on the card or user selectd a value for input
    @objc func leftButtonClicked() {
        setUIForSelection(0)

        if option == nil {
            print("no value, please check")
            return
        }
        
        // cache the result
        vCard.saveResult(nil, answerIndex: 0)
        
        // notify the host
        if actionDelegate != nil {
            actionDelegate.card?(self, chooseItemAt: 0)
        }
    }
    
    // disagree with the statement shown on the card
    @objc func rightButtonClicked() {
        // MARK: ------------ not me is 1
        // cause this card to be disappeared from user
        setUIForSelection(1)
        vCard.saveResult(nil, answerIndex: 1)
        
        // notify the host
        if actionDelegate != nil {
            actionDelegate.card?(self, chooseItemAt: 1)
        }
    }
}

extension JudgementCardTemplateView {
    // flip card
    func flipCard() {
        // switch card and infoDetail
        if cardOnShow {
            UIView.transition(from: descriptionView, to: infoDetailView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
        }else {
            UIView.transition(from: infoDetailView, to: descriptionView, duration: 0.5, options: .transitionFlipFromLeft, completion: nil)
        }
        
        cardOnShow = !cardOnShow
    }
}

/******************************* Multiple *********************************/
// MARK: --------------------- MultipleChoiceCardsView
extension MultipleChoiceCardsView {
    // choose, 100
    @objc func chosenAsAnswer(_ button: UIButton) {
        let item = button.tag - 100
        changeSelectedButton(button)
        
        // cache the result
        // UI
        if self.hostCardTemplateView != nil && self.hostCardTemplateView.actionDelegate != nil {
            if let card = self.hostCardTemplateView.vCard {
                let displayOptions = card.getDisplayOptions()
                if let classification = displayOptions[item].match?.classification {
                    if let chainedCardKey = classification.chainedCardKey {
                        if let chained = collection.getCard(chainedCardKey) {
                            let singleVC = ChainedCardViewController()
                            singleVC.hostCardCardView = self.hostCardTemplateView
                            singleVC.loadWithCard(chained, hostCard: card, hostItem: item)
                            self.viewController.presentOverCurrentViewController(singleVC, completion: nil)
                            
                            return
                        }
                    }
                }
                if self.hostCardTemplateView.hostCard == nil {
                    card.saveResult(nil, answerIndex: item)
                }
                self.hostCardTemplateView.actionDelegate.card?(self.hostCardTemplateView, chooseItemAt: item)
            }
            
        }
    }
    
    fileprivate func changeSelectedButton(_ button: UIButton) {
        if button.isSelected {
            // current selected button
            return
        }
        
        let item = button.tag - 100
        let oldValue = chosenItem
        chosenItem = item
        let currentIndexPath = IndexPath(item: chosenItem, section: 0)
        let oldIndexPath = IndexPath(item: oldValue, section: 0)
        
        // button state and card border
        button.isSelected = true
      
        // new choice
        let currentCell = self.cellForItem(at: currentIndexPath) as! CardTemplateViewCell
        currentCell.singleCard.descriptionView.isChosen = true
                
        if oldValue != -1 {
            if let old = self.cellForItem(at: oldIndexPath) {
                let oldCell = old as! CardTemplateViewCell
                // button state
                oldCell.chooseButton.isSelected = false
                oldCell.chooseButton.backgroundColor = UIColor.white
                currentCell.singleCard.descriptionView.isChosen = false
            }
        }
    }
    
    func cardIsChosenAt(_ item: Int) {
        self.hostCardTemplateView.actionDelegate.card?(self.hostCardTemplateView, chooseItemAt: item)
    }

    // swipe cards
    @objc func cardIsSwiped(_ swipeGR: UISwipeGestureRecognizer)  {
        if swipeGR.state == .ended {
            if swipeGR.direction == .right {
                // last
                if currentItem != 0 {
                    goToAdjacentCard(false, targetItem: currentItem - 1)
                }
            }else if swipeGR.direction == .left {
                // next
                if currentItem != numberOfItems(inSection: 0) - 1 {
                    goToAdjacentCard(true, targetItem: currentItem + 1)
                }
            }
        }
    }
    
    // last, 200
    @objc func goBackToLastOption(_ button: UIButton) {
        goToAdjacentCard(false, targetItem: button.tag - 200 - 1)
    }
    
    // next, 300
    @objc func goToNextOption(_ button: UIButton) {
        goToAdjacentCard(true, targetItem: button.tag - 300 + 1)
    }
    // move to adjacent card
    func goToAdjacentCard(_ isNext: Bool, targetItem: Int) {
        let sign: CGFloat = isNext ? 1 : -1
        
        let layout = self.collectionViewLayout as! CircularCollectionViewLayout
        let roughOffsetX = sign * layout.itemSize.width * (1.0 - layout.overlap) * 0.4 + contentOffset.x
        let offset = layout.targetContentOffset(forProposedContentOffset: CGPoint(x: roughOffsetX, y: 0), withScrollingVelocity: CGPoint(x: 0.3, y: 0) )
        
        var itemRect = CGRect(origin: CGPoint.zero, size: bounds.size)
        itemRect.origin.x = abs(offset.x)
        self.scrollRectToVisible(itemRect, animated: true)
        
        if hostCardTemplateView.hostView != nil && hostCardTemplateView.hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostCardTemplateView.hostView as! AssessmentTopView
            topView.setupMaskPath(targetItem)
        }
        
        endCard()
        
        // current card
        currentItem = targetItem
        showCard()
    }
    
    
    func showCard() {
        if let cell = cellForItem(at: IndexPath(item: currentItem, section: 0)) {
            let currentCell = cell as! CardTemplateViewCell
            currentCell.onShow = true
        }
    }
    
    func endCard() {
        if let cell = cellForItem(at: IndexPath(item: currentItem, section: 0)) {
            let currentCell = cell as! CardTemplateViewCell
            currentCell.onShow = false
        }

    }
    
    func showRiskHint(_ button: UIButton) {
        if hostCardTemplateView.hostView != nil && hostCardTemplateView.hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostCardTemplateView.hostView as! AssessmentTopView
            let plainView = button.superview!.superview as! JudgementCardTemplateView
            topView.showRiskHint(plainView.hintButton)
        }
    }
}

// scroll
extension MultipleChoiceCardsView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // get the current card on view
        let layout = self.collectionViewLayout as! CircularCollectionViewLayout
        let roughOffsetX = layout.itemSize.width * (1.0 - layout.overlap) * 0.4 + contentOffset.x
        let item = Int(roughOffsetX / layout.itemSize.width)
        if hostCardTemplateView.hostView != nil && hostCardTemplateView.hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostCardTemplateView.hostView as! AssessmentTopView
            topView.setupMaskPath(item)
        }
    }
}
