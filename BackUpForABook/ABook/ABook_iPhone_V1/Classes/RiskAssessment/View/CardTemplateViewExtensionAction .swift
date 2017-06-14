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
    // action just for judgement cards, when used as single card
    func addActions()  {
        if confirmButton == nil || denyButton == nil {
            return
        }
        
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(denyButtonClicked), for: .touchUpInside)
        flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
    }
    
    // agree with the tatement shown on the card or user selectd a value for input
    func confirmButtonClicked() {
        confirmButton.isSelected = true
        denyButton.isSelected = false
    
        backImageView.image = backImages.selected

        if option == nil {
            print("no value, please check")
            return
        }
        
        // notify the host
        if hostView != nil && hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostView as! AssessmentTopView
            
            // cache the result
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, metricKey: vCard.metricKey!, cardKey: vCard.key, riskKey: VDeckOfCardsFactory.metricDeckOfCards.riskKey, selection: option, value: 1)
            topView.setupIndicator(0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                topView.onValueSet()
            }
            
        }
    }
    
    // disagree with the statement shown on the card
    func denyButtonClicked() {
        // cause this card to be disappeared from user
        confirmButton.isSelected = false
        denyButton.isSelected = true
        backImageView.image = backImages.selected
        
        // notify the host
        if hostView != nil && hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostView as! AssessmentTopView
            // cache the result
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, metricKey: vCard.metricKey!, cardKey: vCard.key, riskKey: VDeckOfCardsFactory.metricDeckOfCards.riskKey, selection: option, value: -1)
            
            topView.setupIndicator(1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                topView.onValueSet()
            }
        }
    }
    
    // skip this metric
    func skipCard() {
        
        // cause this card to be disappeared from user
        // if the card is answered before, do not change answer
        // notify the host
        if hostView != nil && hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostView as! AssessmentTopView
            
            let styleKey = vCard.cardStyleKey
            if styleKey == JudgementCardTemplateView.styleKey() {
                // judgement
                if confirmButton.isSelected == true || denyButton.isSelected == true {
                    topView.onValueSet()
                    return
                }
            } else if styleKey == SetOfCardsCardTemplateView.styleKey() {
                if chosenIndex != -1 {
                    topView.onValueSet()
                    return
                }
            }
            
            // skip the card
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, metricKey: vCard.metricKey!, cardKey: vCard.key, riskKey: VDeckOfCardsFactory.metricDeckOfCards.riskKey, selection: nil, value: nil)
            topView.onValueSet()
        }

    }

    // flip card
    func flipCard() {
         // “flip” the card to the “metric - risks” view
        let metricKey = vCard.metricKey
        if metricKey == nil {
            print("no keys")
            return
        }
        
        for view in subviews {
            if view.isKind(of: TwoLevelsGraphView.self) {
                // already added
                layer.removeAllAnimations()
                return
            }
        }
        
        let graph = TwoLevelsGraphView.createWithMetricKey(metricKey!, frame: bounds)
        graph.backgroundColor = UIColor.white
        graph.layer.cornerRadius = 5
        addSubview(graph)
        
        let transition = CATransition()
        transition.type = "flip"
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.5
        
        layer.add(transition, forKey: nil)
        
    }
}

/******************************* Multiple *********************************/
// MARK: --------------------- MultipleChoiceCardsView
extension MultipleChoiceCardsView {
    func chosenAsAnswer( _ button: UIButton) {
        button.isSelected = true
        let item = button.tag - 100
        chosenItem = item
        // if using yes-no
        let currenIndexPath = IndexPath(item: item, section: 0)
        let cell = cellForItem(at: currenIndexPath) as! CardTemplateViewCell
        if cell.singleCard.isKind(of: JudgementCardTemplateView.self) {
            let judgement = cell.singleCard as! JudgementCardTemplateView
            judgement.denyButton.isSelected = false
            judgement.backImageView.image = judgement.backImages.selected
        }
    
        // save result
        if self.hostCardTemplateView.hostView != nil && self.hostCardTemplateView.hostView.isKind(of: AssessmentTopView.self) {
            let topView = self.hostCardTemplateView.hostView as! AssessmentTopView
            self.hostCardTemplateView.chosenIndex = item
            // cache the result
            let vCard = self.hostCardTemplateView.vCard
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, metricKey: (vCard?.metricKey)!, cardKey: (vCard?.key)!, riskKey: VDeckOfCardsFactory.metricDeckOfCards.riskKey, selection: self.hostCardTemplateView.option, value: NSNumber(value: item))

            topView.setupIndicator(item)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                topView.onValueSet()
            }
            
        }
    }
    
    
    // new actions for judgement cards
    func goToNextOption(_ button: UIButton) {
        var item = button.tag - 200
        
        // button state
        button.isSelected = true
        let currenIndexPath = IndexPath(item: item, section: 0)
        let cell = cellForItem(at: currenIndexPath) as! CardTemplateViewCell
        if cell.singleCard.isKind(of: JudgementCardTemplateView.self) {
            let judgement = cell.singleCard as! JudgementCardTemplateView
            judgement.confirmButton.isSelected = false
            judgement.denyButton.isSelected = true
            judgement.backImageView.image = judgement.backImages.normal
        }
        
        // last card
        let layout = self.collectionViewLayout as! CircularCollectionViewLayout
        
        let roughOffsetX = layout.itemSize.width * (1.0 - layout.overlap) * 0.4 + contentOffset.x
        var offset = layout.targetContentOffset(forProposedContentOffset: CGPoint(x: roughOffsetX, y: 0), withScrollingVelocity: CGPoint(x: 0.3, y: 0) )
        
        var itemRect = CGRect(origin: CGPoint.zero, size: bounds.size)
        
        if item == numberOfItems(inSection: 0) - 1 {
            item = 0
            offset = CGPoint.zero
        }else {
            item += 1
        }
        
        itemRect.origin.x = abs(offset.x)
        
        self.scrollRectToVisible(itemRect, animated: true)
        
        if hostCardTemplateView.hostView != nil && hostCardTemplateView.hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostCardTemplateView.hostView as! AssessmentTopView
            topView.setupMaskPath(item)
        }
    }
    
    func flipItem(_ button: UIButton)  {
        let metricKey = hostCardTemplateView.vCard.metricKey
        if metricKey == nil {
            print("no keys")
            return
        }
        
        for view in subviews {
            if view.isKind(of: TwoLevelsGraphView.self) {
                // already added
                layer.removeAllAnimations()
                return
            }
        }
        
        let graph = TwoLevelsGraphView.createWithMetricKey(metricKey!, frame: button.superview!.bounds)
        graph.backgroundColor = UIColor.white
        button.superview!.addSubview(graph)
        
        let transition = CATransition()
        transition.type = "flip"
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.5
        
        button.superview!.layer.add(transition, forKey: nil)
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

// MARK: -------- set of cards
extension SetOfCardsCardTemplateView {
    // action and animataion
    // next
    func goToNextOption() {
        let currentCard = cardViews[currentCardIndex]
        
        if currentCardIndex == numberOfOptions - 1 {
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) )
            })
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = CGAffineTransform(rotationAngle: 2 * CGFloat(M_PI))
            })
        } else {
            let nextIndex = currentCardIndex + 1
            let nextCard = cardViews[nextIndex]
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = self.backTransform
                currentCard.transform = currentCard.transform.translatedBy(x: 0, y: self.bounds.height / 0.6)
                currentCard.alpha = 0
                nextCard.transform = CGAffineTransform.identity
                nextCard.alpha = 1
                
                if self.hostView != nil && self.hostView.isKind(of: AssessmentTopView.self) {
                    let topView = self.hostView as! AssessmentTopView
                    topView.setupMaskPath(nextIndex)
                }
                
            }) { (true) in
                currentCard.isUserInteractionEnabled = false
                nextCard.isUserInteractionEnabled = true
                self.currentCardIndex += 1
             }
        }
    }
    
    func goToNextCard() {
        // save and go to next
        chosenIndex = currentCardIndex
        
        // notify the host
        if hostView != nil && hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostView as! AssessmentTopView
            
            option = vCard.cardOptions[currentCardIndex]
            // cache the result
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, metricKey: vCard.metricKey!, cardKey: vCard.key, riskKey: VDeckOfCardsFactory.metricDeckOfCards.riskKey, selection: option, value: chosenIndex as NSNumber?)
            topView.setupIndicator(chosenIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                topView.onValueSet()
            }
        }
    }
    
    // last
    func backToLastOption() {
        let currentCard = cardViews[currentCardIndex]
        
        if currentCardIndex == 0 {
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) )
            })
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = CGAffineTransform(rotationAngle: 2 * CGFloat(M_PI))
            })
        } else {
            let lastIndex = currentCardIndex - 1
            let currentCard = cardViews[currentCardIndex]
            let lastCard = cardViews[lastIndex]
            
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = self.backTransform
                currentCard.alpha = 0.5
                
                lastCard.alpha = 1
                lastCard.transform = CGAffineTransform.identity
                
                if self.hostView != nil && self.hostView.isKind(of: AssessmentTopView.self) {
                    let topView = self.hostView as! AssessmentTopView
                    topView.setupMaskPath(lastIndex)
                }
                
            }) { (true) in
                currentCard.isUserInteractionEnabled = false
                lastCard.isUserInteractionEnabled = true
                self.currentCardIndex -= 1
            }
        }
    }
    
    func forMoreCardInfo() {
        print("filp for detail")
        // “flip” the card to the “metric - risks” view
        
        let metricKey = vCard.metricKey
        if metricKey == nil {
            print("no keys")
            return
        }
        
        for view in subviews {
            if view.isKind(of: TwoLevelsGraphView.self) {
                // already added
                layer.removeAllAnimations()
                return
            }
        }
        
        let graph = TwoLevelsGraphView.createWithMetricKey(metricKey!, frame: cardFrame)
        graph.backgroundColor = UIColor.white
        addSubview(graph)
        
        let transition = CATransition()
        transition.type = "flip"
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.5
        
        layer.add(transition, forKey: nil)
    }
}

