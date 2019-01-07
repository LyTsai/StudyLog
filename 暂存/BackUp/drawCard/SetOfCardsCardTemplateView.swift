//
//  SetOfCardsCardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: ---------------- single card view -------------------------------
class SingleCardView: JudgementCardTemplateView {
    // properties
    var cardIndex = 0 {
        didSet{
            cardIndexLabel.text = "\(cardIndex)"
        }
    }

    // delegate
    weak var setOfCardsDelegate: SetOfCardsCardTemplateView!
    
    // methods
    class func createWithFrame(_ frame: CGRect, image: UIImage?, text: String?,  prompt: String?) -> SingleCardView {
        let singleCard = SingleCardView(frame: frame)
        singleCard.descriptionView.title = text ?? ""
        singleCard.descriptionView.prompt = prompt ?? ""
        singleCard.descriptionView.mainImage = image
        singleCard.addSubs()
        
        return singleCard
    }
    
    fileprivate let cardIndexLabel = UILabel()
    fileprivate func addSubs() {
//        backImage.image = UIImage(named: "card_mu_normalBack")
        
        //label
        cardIndexLabel.textColor = UIColor.white
        cardIndexLabel.backgroundColor = darkGreenColor
        cardIndexLabel.textAlignment = .center
        cardIndexLabel.layer.borderWidth = 1.4
        cardIndexLabel.layer.borderColor = UIColorFromRGB(104, green: 159, blue: 56).cgColor
        
        // buttons
        denyButton.addTarget(self, action: #selector(denyAnswer), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(acceptAnswer), for: .touchUpInside)

        flipButton.setBackgroundImage(UIImage(named: "cardInfo"), for: .normal)
        flipButton.addTarget(self, action: #selector(forMoreCardInfo), for: .touchUpInside)

        // add
        addSubview(flipButton)
        addSubview(cardIndexLabel)
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hMargin = descriptionView.hMargin
        let labelLength = hMargin * 0.8
        cardIndexLabel.frame = CGRect(x: 0.1 * hMargin, y: 0.1 * hMargin, width: labelLength, height: labelLength)
        cardIndexLabel.font = UIFont.systemFont(ofSize: labelLength * 0.7)
        cardIndexLabel.layer.cornerRadius = labelLength * 0.5
        cardIndexLabel.layer.masksToBounds = true
//        descriptionView.titleLabel.backgroundColor = UIColor.red
    }

    // action
    func denyAnswer() {
        denyButton.isSelected = true
        confirmButton.isSelected = false
        selected = false
        
        // change backImage
//        backImage.image = UIImage(named: "card_mu_normalBack")
        cardIndexLabel.isHidden = false
        
        // not the answer, go to next option
        if setOfCardsDelegate != nil {
            setOfCardsDelegate.goToNextOption()
        }
    }

    func acceptAnswer() {
        denyButton.isSelected = false
        confirmButton.isSelected = true
        
        selected = true
        
        // change badkImage
//        backImage.image = UIImage(named: "card_mu_selected_\(cardIndex - 1)") ?? UIImage(named: "card_mu_selected_0")
        cardIndexLabel.isHidden = true
        
        // is answer, go to next card
        if setOfCardsDelegate != nil {
            setOfCardsDelegate.goToNextCard()
        }
    }
    
    func forMoreCardInfo() {
        print("filp for detail")
    }
}

// MARK: ---------------- card template view -------------------------------
class SetOfCardsCardTemplateView: CardTemplateView {
    // keys
    override func key() -> String {
        return SetOfCardsCardTemplateView.styleKey()
    }
    
    class func styleKey() -> String {
        // TODO: ---------- spinning wheel key
        return "4094702e-bb0c-11e6-a4a6-cec0c932ce01"
    }
    
    // properties about size
    var numberOfOptions: Int {
        return (vCard.matchOptions?.count)!
    }
    var currentCardIndex = 0
    
    var duration: TimeInterval = 0.5
    
    // subviews
//    fileprivate var cardTitleLabel = UILabel()
    fileprivate var cardViews = [SingleCardView]()
    
    // init
    class func createWithFrame(_ frame: CGRect) -> SetOfCardsCardTemplateView {
        let cardView = SetOfCardsCardTemplateView(frame: frame)
//        cardView.addSubview(cardView.cardTitleLabel)
        cardView.reloadCards()
        
        let upSwipeGR = UISwipeGestureRecognizer()
        upSwipeGR.direction = .up
        upSwipeGR.addTarget(cardView, action: #selector(cardView.backToLastOption))
        
        cardView.addGestureRecognizer(upSwipeGR)

        let downSwipeGR = UISwipeGestureRecognizer()
        downSwipeGR.direction = .down
        downSwipeGR.addTarget(cardView, action: #selector(cardView.goToNextOption))
        
        cardView.addGestureRecognizer(downSwipeGR)
        
        return cardView
    }
    
    // layout

    
    // content
    override var vCard: VCardModel! {
        didSet{
            if vCard != oldValue {
                reloadCards()
            }
        }
    }

    fileprivate func reloadCards() {
        // clear current cards
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews.removeAll()

        if vCard == nil {
            return
        }
        
        // title
//        cardTitleLabel.text = vCard.info
        
        // new cards
        let options = vCard.matchOptions
        if options == nil || numberOfOptions == 0{
            demoToShow()
        }else {
            // create views
            for i in 0..<numberOfOptions {
                let option = options![i]
                let cardView = SingleCardView.createWithFrame(cardFrame, image: option.image, text: vCard.ofMetric!.name,  prompt: option.statement)
                cardView.cardIndex = i + 1
                cardView.transform = (i == 0 ? CGAffineTransform.identity : backTransform)
                cardView.isUserInteractionEnabled = (i == 0)
                
                cardView.setOfCardsDelegate = self
                
                cardViews.append(cardView)
                
//                print("顶头:\(vCard.displayName!)，侧边：\(vCard.ofMetric!.name!)，主要：\(option.statement!)")
            }
            
            // reverse add
            for i in 0..<numberOfOptions {
                let j = numberOfOptions - 1 - i
                let cardView = cardViews[j]
                
                addSubview(cardView)
            }
        }
    }
    
    fileprivate func demoToShow() {
        for i in 0..<3 {
            let cardView = SingleCardView.createWithFrame(cardFrame, image: UIImage(named: "Coming Soon.png"), text: "Set of Cards",  prompt: "card statement")
            cardView.cardIndex = i + 1
            cardView.transform = (i == 0 ? CGAffineTransform.identity : backTransform)
            cardView.isUserInteractionEnabled = (i == 0)
            
            cardView.setOfCardsDelegate = self
            
            cardViews.append(cardView)
        }
        
        // reverse add
        for i in 0..<3 {
            let j = numberOfOptions - 1 - i
            let cardView = cardViews[j]
            
            addSubview(cardView)
        }

    }
    
    // frame and transform
    // angle: (-3 ~ 3) * 180 / 40
    fileprivate var backTransform: CGAffineTransform {
        var randomAngle: CGFloat = 0
        while randomAngle == 0 {
            randomAngle = CGFloat(M_PI) / 40 * (CGFloat(arc4random() % 7) - 3)
        }
        let rotation = CGAffineTransform(rotationAngle: randomAngle)
        
        return rotation.scaledBy(x: 0.6, y: 0.6)
    }

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
            
            option = vCard.matchOptions?[currentCardIndex]
            // cache the result
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, metricKey: (vCard.ofMetric?.key)!, cardKey: vCard.key!, riskKey: VDeckOfCardsFactory.metricDeckOfCards.riskKey, selection: option, value: chosenIndex as NSNumber?)
            topView.onValueSet(vCard, selection: option)
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
            }) { (true) in
                currentCard.isUserInteractionEnabled = false
                lastCard.isUserInteractionEnabled = true
                self.currentCardIndex -= 1
            }
        }
    }
}
