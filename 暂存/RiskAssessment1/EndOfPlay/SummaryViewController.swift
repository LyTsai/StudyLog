//
//  SummaryViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/25.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SummaryViewController: PlayingViewController {

    var mainColor = tabTintGreen
    var summaryRoad: SummaryOfCardsRoadCollectionView!
    var cardAnswerView: CardAnswerChangeView!
    var cards = [CardInfoObjModel]()
    var forPart = false // change title during answering
    var roadTitle = ""
    
    fileprivate let buttonsView = AlignedButtons()
    fileprivate var answerHeight: CGFloat {
        return 155 * height / 667
    }
    fileprivate var remained: CGFloat {
        return 65 * height / 667
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        cartView.isHidden = true
        
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        // subviews
        addRoadViewAndButtons()
        addTitleCloud()
        addCardAnswerView()
    }
    
    fileprivate func addRoadViewAndButtons() {
        // Summaries, if "cards" is not set, use for all as default
        if cards.count == 0 {
            cards = cardCollection.getMetricCardOfRisk(dataCursor.focusingRiskKey!)
            forPart = false
        }
        
        summaryRoad = SummaryOfCardsRoadCollectionView.createWithFrame(mainFrame, cards: cards, mainColor: mainColor, forPart: forPart)
        summaryRoad.hostVC = self
        view.addSubview(summaryRoad)
        
        // save button
        if !forPart {
            buttonsView.frame = CGRect(x: 0, y: height - remained - 49, width: width, height: remained)
            let buttons = buttonsView.addButtonsWithTitles(["Restart the game", "Save"], buttonWRatio: 0.7, gap: 8, edgeInsets: UIEdgeInsets(top: 8, left: 25, bottom: 8, right: 25))
            buttons.first!.addTarget(self, action: #selector(restart), for: .touchUpInside)
            buttons.last!.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
            view.addSubview(buttonsView)
        }
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate func addTitleCloud() {
        let standW = width / 375
        
        // topLeft
        let titleImage = ProjectImages.sharedImage.roadCardTitle!
        let titleWidth = 188 * standW
        let titleImageView = UIImageView(frame : CGRect(x: 0, y: 39, width: titleWidth, height: titleImage.size.height * titleWidth / titleImage.size.width))
        titleImageView.image = titleImage
        
        // label on it
        titleLabel.frame = CGRect(x: 5 * standW, y: 67, width: 122 * standW, height: 50 * height / 667)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = forPart ? .center : .left
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        if !forPart {
            roadTitle = "Answered: \(MatchedCardsDisplayModel.getCurrentMatchedCards().count)\nTotal: \(cards.count)"
        }
        titleLabel.text = roadTitle
        
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
    }
    
    fileprivate func addCardAnswerView() {
        // answer change
        cardAnswerView = CardAnswerChangeView.createWithFrame(CGRect(x: 0, y: height - answerHeight - 49, width: width, height: answerHeight), topHeight: answerHeight / 4, card: cards.first!, mainColor: mainColor)
        cardAnswerView.layer.addBlackShadow(3)
        cardAnswerView.layer.shadowOffset = CGSize(width: 0, height: -1)

        cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight * 1.1)
        cardAnswerView.hostVC = self
        
        view.addSubview(cardAnswerView)
    }

        // tap to hide
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(drawDown))
//        view.addGestureRecognizer(tapGR)
        
   
    // MARK: --------- change state and data
    func showAnswerWithCard(_ card: CardInfoObjModel) {
        cardAnswerView.setupWithCard(card, mainColor: mainColor)
        
        UIView.animate(withDuration: 0.5) {
            self.cardAnswerView.transform = CGAffineTransform.identity
            self.buttonsView.transform = CGAffineTransform(translationX: 0, y: self.remained)
        }
    }

    func answerIsSetForCard(_ card: CardInfoObjModel, result: Int) {
        // data is changed before
        summaryRoad.changeAnswerOfCard(card, toIndex: result)
        setCartNumber()
        if !forPart {
            // change title
            titleLabel.text = "Answered: \(MatchedCardsDisplayModel.getCurrentMatchedCards().count)\nTotal: \(cards.count)"
        }
        drawDown()
    }
    
    func drawDown() {
        if cardAnswerView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
                self.cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight * 1.1)
                self.buttonsView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func updateViewAfterChange() {
        // data changed
        if !forPart {
            title = "Answered: \(MatchedCardsDisplayModel.getCurrentMatchedCards().count)\nTotal: \(cards.count)"
        }
        
        summaryRoad.reloadData()
        cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight)
    }

    override func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: ACTIONS
    //------------------ save ----------------------
    func restart() {
        let alert = UIAlertController(title: nil, message: "Do You Want to Clear Answers and Restart", preferredStyle: .alert)
        let clear = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            if self.forPart {
                // should added????
            }else {
                self.cachedResult.clearAnswerForUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), riskKey: self.dataCursor.focusingRiskKey)
                let _ = self.navigationController?.popViewController(animated: true)
            }
        })
        let giveUp = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(clear)
        alert.addAction(giveUp)
        
        // alert
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate let alertVC = CelebrateViewController()
    func saveClicked() {
        checkCart()
    }
    
  }


