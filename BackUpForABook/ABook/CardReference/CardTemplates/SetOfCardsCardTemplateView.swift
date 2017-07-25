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
    class func createWithFrame(_ frame: CGRect, image: UIImage?, text: String?, prompt: String?, side: String?) -> SingleCardView {
        let singleCard = SingleCardView(frame: frame)
        singleCard.descriptionView.title = text ?? "Question"
        singleCard.descriptionView.prompt = prompt ?? "Description"
        singleCard.descriptionView.side = side ?? "disease ?"
        singleCard.descriptionView.mainImage = image ?? UIImage(named: "Coming Soon.png")
        singleCard.addSubs()
//        singleCard.backImages = backImages
        
        return singleCard
    }
    
    fileprivate let cardIndexLabel = UILabel()
    fileprivate func addSubs() {
        
        //label
        cardIndexLabel.textColor = UIColor.white
        cardIndexLabel.backgroundColor = darkGreenColor
        cardIndexLabel.textAlignment = .center
        cardIndexLabel.layer.borderColor = UIColor.black.cgColor
        
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

        let labelLength = descriptionView.lineInsets.left * 3
        let indexOffset = descriptionView.lineInsets.left * 0.5
        
        cardIndexLabel.layer.borderWidth = labelLength * 0.05
        cardIndexLabel.frame = CGRect(x: indexOffset, y: descriptionView.lineInsets.top -  indexOffset, width: labelLength, height: labelLength)
        cardIndexLabel.font = UIFont.systemFont(ofSize: labelLength * 0.7, weight: UIFontWeightLight)
        cardIndexLabel.layer.cornerRadius = labelLength * 0.5
        cardIndexLabel.layer.masksToBounds = true
    }

    // action
    func denyAnswer() {
        denyButton.isSelected = true
        confirmButton.isSelected = false
        
        // change backImage
        backImageView.image = backImages.normal
        cardIndexLabel.isHidden = false
        
        // not the answer, go to next option
        if setOfCardsDelegate != nil {
            setOfCardsDelegate.goToNextOption()
        }
    }

    func acceptAnswer() {
        denyButton.isSelected = false
        confirmButton.isSelected = true
        
        // change badkImage
        backImageView.image = backImages.selected
        cardIndexLabel.isHidden = true
        
        // is answer, go to next card
        if setOfCardsDelegate != nil {
            setOfCardsDelegate.goToNextCard()
        }
    }
    
    func forMoreCardInfo() {
        if setOfCardsDelegate != nil {
            setOfCardsDelegate.forMoreCardInfo()
        }
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
        return vCard.cardOptions.count
    }
    var currentCardIndex = 0
    
    var duration: TimeInterval = 0.5
    
    // subviews
    var cardViews = [SingleCardView]()
    
    // init
    class func createWithFrame(_ frame: CGRect) -> SetOfCardsCardTemplateView {
        let cardView = SetOfCardsCardTemplateView(frame: frame)
        cardView.backImageView.removeFromSuperview()
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
    override var vCard: CardInfoObjModel! {
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
        
     
        // new cards
        let options = vCard.cardOptions
        if options.isEmpty {
            demoToShow()
        }else {
            // create views
            for i in 0..<numberOfOptions {
                let option = options[i]
                let cardView = SingleCardView.createWithFrame(cardFrame, image: option.match?.imageObj, text: vCard.metric?.name, prompt: option.match?.statement, side: option.match?.info)
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
    
    fileprivate func demoToShow() {
        for i in 0..<3 {
            let cardView = SingleCardView.createWithFrame(cardFrame, image: UIImage(named: "Coming Soon.png"), text: "Set of Cards", prompt: "card statement", side: "the label")
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
    var backTransform: CGAffineTransform {
        var randomAngle: CGFloat = 0
        while randomAngle == 0 {
            randomAngle = CGFloat(M_PI) / 40 * (CGFloat(arc4random() % 7) - 3)
        }
        let rotation = CGAffineTransform(rotationAngle: randomAngle)
        
        return rotation.scaledBy(x: 0.6, y: 0.6)
    }
}
