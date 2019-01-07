//
//  MatchedCardsViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardsViewController: MultipleUserViewController {
    // data
    fileprivate var keys = [String]()
    var chosenTagIndex = 0 {
        didSet{
            if chosenTagIndex != oldValue && chosenTagIndex >= 0 && chosenTagIndex < keys.count {
                cards = matchedCards[keys[chosenTagIndex]]!
                cardsDisplayView.reloadWithCards(cards)
            }
        }
    }
    
    fileprivate var cards = [MatchedCardsDisplayModel]()
    fileprivate var matchedCards = MatchedCardsDisplayModel.getCurrentCategoryOfCardsPlayed()
    // views
    fileprivate var cardsDisplayView: MatchedCardsDisplayView!
    fileprivate let shareButton = UIButton(type: .custom)
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        // bar
        addAllBarButtonItems("Matched Cards")
        
        // cards
        if matchedCards.count == 0 {
            let addView = ViewForAdd.createWithFrame(mainFrame.insetBy(dx: width * 0.15, dy: height * 0.15), topImage: UIImage(named: "icon_search"), title: "No Game Played", prompt: "please go to assessment")
            addView.personImageView.image = UIImage(named: "icon_assess")
            view.addSubview(addView)
            return
        }
        
        // has cards
        // back image
        view.layer.contents = UIImage(named: "homeBackImage")?.cgImage
        setupUIWithMatchedCards(matchedCards)
    }
    
    fileprivate func setupUIWithMatchedCards(_ matchedCards: [String: [MatchedCardsDisplayModel]]) {
        self.matchedCards = matchedCards
        
        for view in view.subviews {
            if view.isKind(of: UserSelectionTableView.self) {
                continue
            }
            
            view.removeFromSuperview()
        }
        
        // size
        let xMargin = 64 * standWP
        let yMargin = 59 * standHP
        let topHeight = 54 * standHP
        let bottomHeight = 42 * standHP
        
        // tags
        keys = Array(matchedCards.keys)
        var texts = [String]()
        for key in keys {
            texts.append(AIDMetricCardsCollection.standardCollection.getMetricGroupByKey(key)?.name ?? UnGroupedCategoryKey)
        }
        cards = matchedCards[keys.first!]!
        
        let tagPick = TagPickerView()
        tagPick.setupWithFrame(mainFrame.insetBy(dx: 0, dy: 10), margin: xMargin / 4, tagHeight: yMargin * 0.7, topNumber: 3, tagNames: texts)
        tagPick.hostVC = self
        view.addSubview(tagPick)
        
        // cards
        let displayFrame = mainFrame.insetBy(dx: 0, dy: yMargin)
        let cardEdgeInsets = UIEdgeInsets(top: topHeight, left: xMargin, bottom: bottomHeight, right: xMargin)
        cardsDisplayView = MatchedCardsDisplayView()
        cardsDisplayView.setupWithFrame(displayFrame, cardEdgeInsets: cardEdgeInsets, cards: cards, withAssess: false)
        cardsDisplayView.backgroundColor = UIColor.white
        view.addSubview(cardsDisplayView)
        
        // share
        let shareButton = UIButton(type: .custom)
        shareButton.frame = CGRect(center: CGPoint(x: displayFrame.midX, y: displayFrame.maxY - 0.5 * bottomHeight), width: width * 0.3, height: bottomHeight * 0.7)
        shareButton.setImage(UIImage(named: "icon_share_blue"), for: .normal)
        shareButton.setTitle("Sharing", for: .normal)
        shareButton.setTitleColor(UIColorGray(106), for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: bottomHeight * 0.3, weight: UIFontWeightBold)
        shareButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        view.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(shareCards), for: .touchUpInside)
        
        for subView in view.subviews {
            if subView.isKind(of: UserSelectionTableView.self) {
                view.bringSubview(toFront: subView)
                break
            }
        }
    }
    
    // action
    override func reloadWithUserKey(_ userKey: String) {
        super.reloadWithUserKey(userKey)
        
        // data source
        setupUIWithMatchedCards(MatchedCardsDisplayModel.getCategoryOfCardsPlayedForUser(userKey))
    }
    
    
    func shareCards() {
        let sharePage = Bundle.main.loadNibNamed("SharePrepareViewController", owner: self, options: nil)?.first as! SharePrepareViewController
        sharePage.modalPresentationStyle = .overCurrentContext
        present(sharePage, animated: true, completion: nil)
    }

}

