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
//        gestureRecognizers?.removeAll()
        
        if confirmButton == nil || denyButton == nil {
            return
        }
        
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(denyButtonClicked), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
//        flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
    }
    
    // agree with the tatement shown on the card or user selectd a value for input
    func confirmButtonClicked() {
        setUIForSelection(1)

        if option == nil {
            print("no value, please check")
            return
        }
        
        // notify the host
        if hostView != nil && hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostView as! AssessmentTopView
            // cache the result
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: vCard.key, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey!, selection: option, value: 1)
            topView.setupIndicator(1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                topView.onValueSet(1)
            }
        }
    }
    
    // disagree with the statement shown on the card
    func denyButtonClicked() {
        // cause this card to be disappeared from user
        setUIForSelection(-1)
        
        // notify the host
        if hostView != nil && hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostView as! AssessmentTopView
            // cache the result
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: vCard.key, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey!, selection: option, value: -1)
            
            topView.setupIndicator(0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                topView.onValueSet(-1)
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
                    topView.onValueSet(nil)
                    return
                }
            } else if styleKey == SpinningMultipleChoiceCardsTemplateView.styleKey() {
                if chosenIndex != -1 {
                    // with answer
                    topView.onValueSet(Double(chosenIndex))
                    return
                }
            }
            
            // skip the card
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: vCard.key, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey!, selection: nil, value: nil)
            topView.onValueSet(nil)
        }
    }

    // flip card
    func flipCard() {
        // switch card and infoDetail
        
        //test
        infoDetailView.backgroundColor = UIColor.cyan
        
        if cardOnShow {
            UIView.transition(from: backImageView, to: infoDetailView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
        }else {
            UIView.transition(from: infoDetailView, to: backImageView, duration: 0.5, options: .transitionFlipFromLeft, completion: nil)
        }
       
        cardOnShow = !cardOnShow
    }
    
    func showHint() {
        if hostView != nil && hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostView as! AssessmentTopView
            topView.showRiskHint()
        }
    }
}

/******************************* Multiple *********************************/
// MARK: --------------------- MultipleChoiceCardsView
extension MultipleChoiceCardsView {
    // choose, 100
    func chosenAsAnswer(_ button: UIButton) {
        let item = button.tag - 100
        setUIForChosenItem(item)
    
        // cache the result
        let vCard = self.hostCardTemplateView.vCard
        let option = vCard?.cardOptions[item]
        CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: (vCard?.key)!, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey!, selection: option, value: NSNumber(value: item))
        
        // UI
        if self.hostCardTemplateView.hostView != nil && self.hostCardTemplateView.hostView.isKind(of: AssessmentTopView.self) {
            let topView = self.hostCardTemplateView.hostView as! AssessmentTopView
            self.hostCardTemplateView.chosenIndex = item

            topView.setupIndicator(item)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                topView.onValueSet(Double(item))
            }
        }
    }
    
    func setUIForChosenItem(_ item: Int) {
        let oldValue = chosenItem
        chosenItem = item
        
        if chosenItem != oldValue {
            UIView.performWithoutAnimation {
                // new choice
                let currentIndexPath = IndexPath(item: chosenItem, section: 0)
                let currentCell = cellForItem(at: currentIndexPath) as! CardTemplateViewCell
                
                // button state
                currentCell.chooseButton.isSelected = true
                currentCell.singleCard.backImageView.image = currentCell.singleCard.selectedBackImage
                
                // TODO: -------------------- a bad way...
                if oldValue != -1 {
                    let oldIndexPath = IndexPath(item: oldValue, section: 0)
                    if let old = cellForItem(at: oldIndexPath) {
                        let oldCell = old as! CardTemplateViewCell
                        // button state
                        oldCell.chooseButton.isSelected = false
                        oldCell.singleCard.backImageView.image = oldCell.singleCard.normalBackImage
                    }
                }
            }
        }
    }

    // swipe cards
    func cardIsSwiped(_ swipeGR: UISwipeGestureRecognizer)  {
        if swipeGR.state == .ended {
            if swipeGR.direction == .right {
                // last
                if currentItem != 0 {
                    goToAdjacentCard(false, targetItem: currentItem - 1)
                }
            }else if swipeGR.direction == .left {
                // next
                if currentItem != 2 {
                    goToAdjacentCard(true, targetItem: currentItem + 1)
                }
            }
        }
    }
    
    
    // last, 200
    func goBackToLastOption(_ button: UIButton) {
        goToAdjacentCard(false, targetItem: button.tag - 200 - 1)
    }
    
    // next, 300
    func goToNextOption(_ button: UIButton) {
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
        
        currentItem = targetItem
    }
    
    func showRiskHint() {
        if hostCardTemplateView.hostView != nil && hostCardTemplateView.hostView.isKind(of: AssessmentTopView.self) {
            let topView = hostCardTemplateView.hostView as! AssessmentTopView
            topView.showRiskHint()
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

// MARK: -------- set of cards
extension SetOfCardsCardTemplateView {
    // action and animataion
    // next
    func goToNextOption() {
        let currentCard = cardViews[currentCardIndex]
        
        if currentCardIndex == numberOfOptions - 1 {
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) )
            })
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = CGAffineTransform(rotationAngle: 2 * CGFloat(Double.pi))
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
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: vCard.key, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey!, selection: option, value: chosenIndex as NSNumber?)
            topView.setupIndicator(chosenIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                topView.onValueSet(Double(self.chosenIndex))
            }
        }
    }
    
    // last
    func backToLastOption() {
        let currentCard = cardViews[currentCardIndex]
        
        if currentCardIndex == 0 {
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) )
            })
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = CGAffineTransform(rotationAngle: 2 * CGFloat(Double.pi))
            })
        } else {
            let lastIndex = currentCardIndex - 1
            let currentCard = cardViews[currentCardIndex]
            let lastCard = cardViews[lastIndex]
            
            UIView.animate(withDuration: duration, animations: {
                currentCard.transform = self.backTransform
                currentCard.alpha = 0.4
                
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
        transition.duration = 0.3
        
        layer.add(transition, forKey: nil)
    }
}

