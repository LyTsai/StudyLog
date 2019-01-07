//
//  SetOfCardsCardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: ---------------- single card view -------------------------------
class SingleCardView: UIView {
    // properties
    let denyButton = UIButton.customNormalButton("No")
    let yesButton = UIButton.customNormalButton("Yes")
    let flipButton = UIButton(type: .custom)
    
    var cardIndex = 0 {
        didSet{
            cardIndexLabel.text = "\(cardIndex)"
        }
    }
    
    var plainCard: PlainCardView!
    
    // delegate
    weak var setOfCardsDelegate: SetOfCardsCardTemplateView!
    
    // methods
    class func createWithFrame(_ frame: CGRect, image: UIImage?, text: String?,  prompt: String?) -> SingleCardView {
        let singleCard = SingleCardView(frame: frame)
        singleCard.plainCard = PlainCardView.createWithText(text, prompt: prompt, image: image)
        singleCard.addSubs()
        
        return singleCard
    }
    
    fileprivate let cardIndexLabel = UILabel()
    fileprivate func addSubs() {
        // colors
        backgroundColor = UIColor.white
        layer.borderColor = darkGreenColor.cgColor
        layer.masksToBounds = true
        cardIndexLabel.textColor = UIColor.white
        cardIndexLabel.backgroundColor = darkGreenColor
        
        //label
        cardIndexLabel.textAlignment = .center
        
        // buttons
        denyButton.addTarget(self, action: #selector(denyAnswer), for: .touchUpInside)
        yesButton.addTarget(self, action: #selector(acceptAnswer), for: .touchUpInside)

        flipButton.setBackgroundImage(UIImage(named: "cardInfo"), for: .normal)
        flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)

        // add
        addSubview(plainCard)
        addSubview(denyButton)
        addSubview(yesButton)
        addSubview(flipButton)
        addSubview(cardIndexLabel)
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        plainCard.frame = bounds
        
        let bottom = plainCard.bottomForMore * bounds.height
        // size
        let buttonGap = 0.012 * bounds.width
        
        let buttonWidth = (bounds.width - 5 * buttonGap) * 0.5
        let ratio: CGFloat = 444 / 117
        let buttonHeight = min(buttonWidth / ratio, bottom)
        let buttonY = bounds.height - buttonGap - buttonHeight
        
        // buttons
        yesButton.frame = CGRect(x: 2 * buttonGap, y: buttonY, width: buttonWidth, height: buttonHeight)
        denyButton.frame = CGRect(x: yesButton.frame.maxX + buttonGap, y: buttonY, width: buttonWidth, height: buttonHeight)
        let font = UIFont.systemFont(ofSize: buttonHeight / 2.5)
        denyButton.titleLabel?.font = font
        yesButton.titleLabel?.font = font
        
        let hMargin = plainCard.marginPros.horizontal * bounds.width
        let infoLength = 0.83 * hMargin
        
        flipButton.frame = CGRect(x: bounds.width - hMargin, y: 1.5 * hMargin, width: infoLength, height: infoLength)
        cardIndexLabel.frame = CGRect(x: 0.14 * hMargin, y: 0.2 * hMargin, width: infoLength, height: infoLength)
        cardIndexLabel.font = UIFont.systemFont(ofSize: infoLength * 0.5)
        cardIndexLabel.layer.cornerRadius = infoLength * 0.5
        cardIndexLabel.layer.masksToBounds = true
        
        // border
        layer.cornerRadius = buttonGap // backLayer's radius
        layer.borderWidth = 0.12 * hMargin
    }

    // action
    func denyAnswer()  {
        denyButton.isSelected = true
        yesButton.isSelected = false
        
        // not the answer, go to next option
        if setOfCardsDelegate != nil {
            setOfCardsDelegate.goToNextOption()
        }
    }

    func acceptAnswer()  {
        denyButton.isSelected = false
        yesButton.isSelected = true
        
        // is answer, go to next card
        if setOfCardsDelegate != nil {
            setOfCardsDelegate.goToNextCard()
        }
    }
    
    func flipCard() {
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
    var numberOfOptions = 3
    var currentCardIndex = 0
    
    var duration: TimeInterval = 0.5
    
    // subviews
    fileprivate var cardTitleLabel = UILabel()
    fileprivate var cardViews = [SingleCardView]()
    
    // init
    class func createWithFrame(_ frame: CGRect) -> SetOfCardsCardTemplateView {
        let cardView = SetOfCardsCardTemplateView(frame: frame)
        cardView.addSubview(cardView.cardTitleLabel)
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
        if options == nil {
            print("no options")
        }else {
            numberOfOptions = options!.count
            
            // create views
            for i in 0..<numberOfOptions {
                let option = options![i]
                let cardView = SingleCardView.createWithFrame(cardFrame, image: option.image, text: vCard.info,  prompt: option.statement)
                cardView.cardIndex = i + 1
                cardView.transform = (i == 0 ? CGAffineTransform.identity : backTransform)
                cardView.isUserInteractionEnabled = (i == 0)
                
                cardView.setOfCardsDelegate = self
                
                cardViews.append(cardView)
            }
            
            // reverse add
            for i in 0..<numberOfOptions {
                let j = numberOfOptions - 1 - i
                let cardView = cardViews[j]
                
                addSubview(cardView)
            }
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
                currentCard.alpha = 0.2
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
