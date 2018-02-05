//
//  CardsStack.swift
//  UIDesignCollection
//
//  Created by iMac on 16/9/29.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: ------- one card ----------
class SingleCardView: UIView {
    
    var indexLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    // set the layout and properties of one card (not consider about the index)
    // to set the detail concerned with index, set when creating cards Array(except from the card's frame)
    func updateUI() {
        backgroundColor = UIColor.randomColor()
        
        layer.cornerRadius = 10
        layer.borderColor = UIColor.yellow.cgColor
        layer.borderWidth = 1
        
        indexLabel.textColor = UIColor.white
        indexLabel.textAlignment = .center
        addSubview(indexLabel)
    }
}


// MARK: --------- Cards and Animation --------------
enum CardsStackStyle {
    case perspective    // the first is largest
    case queue          // the same size
    case lastTilt       // the last card is tilt
    case centerRandom
}

class CardsContainerView: UIView{
    
    /** array to save all the views */
    var totalCards = [SingleCardView]()
    
    /** the index of current card on show*/
    var currentCardIndex: Int = 0
    
    /** the defalt frame of the first card on show */
    var currentCardFrame = CGRect(origin: CGPoint(x: 50, y: 180), size: CGSize(width: 200, height: 140))
    var stackStyle = CardsStackStyle.lastTilt
    var stackOffset = UIOffset(horizontal: 1, vertical: -1)
    var gap: CGFloat = 5
    var tiltAngle = CGFloat(M_PI) / 6
    var marginAngle = CGFloat(M_PI) / 10
    
    fileprivate var randomAngles: [CGFloat] {
        var angles = [CGFloat]()
        for _ in 0..<numberOfCards {
            angles.append(CGFloat(arc4random() % 100) / 100 * 2 * marginAngle - marginAngle)
        }
        return angles
    }
    
    
    // properties for animation
    var duration: TimeInterval = 0.6
    var rotationAngle = CGFloat(M_PI) / 3
    
    // calculated properties
    var numberOfCards: Int {
        return totalCards.count
    }
    var cardsOnShow: [SingleCardView] {
        var remainedCards = [SingleCardView]()
        for i in currentCardIndex..<numberOfCards {
            remainedCards.append(totalCards[i])
        }
        return remainedCards
    }
    
    // frames of cards without transform
    func frameOfCardAtIndex(_ index: Int) -> CGRect {
        if index < currentCardIndex {
            return CGRect.zero
        }else {
            let dx = gap * stackOffset.horizontal
            let dy = gap * stackOffset.vertical
            let grade = CGFloat(index - currentCardIndex)
            
            var changedX = currentCardFrame.minX + dx * grade
            var changedY = currentCardFrame.minY + dy * grade
            
            switch stackStyle {
            case .queue:
                return CGRect(origin: CGPoint(x: changedX, y: changedY) , size: currentCardFrame.size)
            case .perspective:
                let changedWidth = currentCardFrame.width - 2 * dx * grade
                let changedHeight = currentCardFrame.height + 2 * dy * grade
                return CGRect(x: changedX, y: changedY, width: changedWidth, height: changedHeight)
            case .lastTilt:
                if index == numberOfCards - 1 && index > 0{
                    changedX -= dx
                    changedY -= dy
                }
                return CGRect(origin: CGPoint(x: changedX, y: changedY) , size: currentCardFrame.size)
            case .centerRandom:
                return currentCardFrame
            }
        }
    }
    
    func transformOfCardAtIndex(_ index: Int) -> CGAffineTransform {
        switch stackStyle {
        case .lastTilt:
            if index == numberOfCards - 1 {
                let lastFrame = frameOfCardAtIndex(index)
                totalCards[index].layer.anchorPoint = CGPoint(x: 1, y: 1)
                totalCards[index].center = CGPoint(x: lastFrame.maxX, y: lastFrame.maxY)
                return CGAffineTransform(rotationAngle: tiltAngle)
            }else {
                return CGAffineTransform.identity
            }
        case .centerRandom:
            return CGAffineTransform(rotationAngle: randomAngles[index])
        default:
            return CGAffineTransform.identity
        }
    }
    
    func resetVisibleFrames() {
        for i in currentCardIndex..<numberOfCards {
            let card = totalCards[i]
            card.transform = CGAffineTransform.identity
            card.frame = frameOfCardAtIndex(i)
            card.transform = transformOfCardAtIndex(i)
        }
        
        let currentCard = totalCards[currentCardIndex]
        currentCard.transform = CGAffineTransform.identity
        currentCard.frame = currentCardFrame
    }
    
    // MARK: -------- init cards ---------------------
    func reloadViewsWithCards(_ totalCards: [SingleCardView], currentCardIndex: Int)  {
        // assign properties
        self.totalCards = totalCards
        self.currentCardIndex = currentCardIndex
        
        // clear old views and gesture(s) that may exist
        for view in subviews {
            view.removeFromSuperview()
        }
        gestureRecognizers = nil
        
        // add new views
        resetVisibleFrames()
        for j in 0..<numberOfCards {
            let i = numberOfCards - j - 1
            addSubview(totalCards[i])
        }
        
        // add gestures
        // swipeGR
        let directions = [UISwipeGestureRecognizerDirection.left, UISwipeGestureRecognizerDirection.right,UISwipeGestureRecognizerDirection.up, UISwipeGestureRecognizerDirection.down]
        for direction in directions {
            let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeCards(_:)))
            swipeGR.direction = direction
            addGestureRecognizer(swipeGR)
        }
        // tapGR
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
        addGestureRecognizer(tapGR)
    }
    
    // up & right, flip away; down & left, add back
    func swipeCards(_ swipeGR: UISwipeGestureRecognizer)  {
        switch swipeGR.direction {
        case UISwipeGestureRecognizerDirection.up, UISwipeGestureRecognizerDirection.right: swipeToFly()
        case UISwipeGestureRecognizerDirection.down, UISwipeGestureRecognizerDirection.left: swipeToAdd()
        default: break      // it is a struct, not enum, so, default is needed
        }
    }
    
    // FLY AWAY
    fileprivate func swipeToFly(){
        needAdd = false
        let currentCardView = totalCards[currentCardIndex]
        // for the last one
        if currentCardIndex == (numberOfCards - 1) {
            turningAround(currentCardView)
            print("last card") // or show the first one ?
            return
        }
        // swipe to fly away
        flyArrayToUpRightAndReset(currentCardView)
    }
    
    // ADD BACK
    fileprivate func swipeToAdd(){
        needAdd = true
        let currentCardView = totalCards[currentCardIndex]
        if currentCardIndex == 0 {
            turningAround(currentCardView)
            print("first card")
            return
        }
        // swipe to add back
        addBackFromUpRightAndReset(currentCardView)
    }
    
    // tapGR
    fileprivate var needAdd = false // if true, add cards
    func tapCard(_: UITapGestureRecognizer){
        if currentCardIndex == (numberOfCards - 1) {
            needAdd = true
        } else if currentCardIndex == 0 {
            needAdd = false
        }
        
        needAdd ? addBackFromUpRightAndReset(totalCards[currentCardIndex]): flyArrayToUpRightAndReset(totalCards[currentCardIndex])
    }
    
    
    // MARK: ---------- animation code-blocks -----------
    // for the card should not be removed
    fileprivate func turningAround(_ cardView: SingleCardView) {
        //        cardView.transform = CGAffineTransformIdentity
        //        cardView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        UIView.animate(withDuration: duration, animations: {
            cardView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) )
        }) 
        UIView.animate(withDuration: duration, animations: {
            cardView.transform = CGAffineTransform(rotationAngle: 2 * CGFloat(M_PI))
        }) 
    }
    
    // moving cards
    fileprivate func flyArrayToUpRightAndReset(_ currentCardView: SingleCardView){
        UIView.animate(withDuration: duration, animations: {
            let currentRect = currentCardView.frame
            currentCardView.frame.origin = CGPoint(x: currentRect.minX + currentRect.width * 0.5 , y: currentRect.minY - currentRect.height * 0.5)
            currentCardView.transform = CGAffineTransform(rotationAngle: self.rotationAngle)
        })
        
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseIn, animations: {
            currentCardView.alpha = 0.2
            let currentRect = currentCardView.frame
            currentCardView.frame = CGRect(x: currentRect.midX + currentRect.width, y: currentRect.minY - currentRect.height * 0.4, width: 0, height: 0)
        }) { (false) in }
        
        currentCardIndex += 1
        UIView.animate(withDuration: duration, animations: {
            self.resetVisibleFrames()
        }) 
    }
    
    fileprivate func addBackFromUpRightAndReset(_ currentCardView: SingleCardView){
        currentCardIndex -= 1
        
        let cardViewOnShow = totalCards[currentCardIndex]
        UIView.animate(withDuration: duration, animations: {
            cardViewOnShow.transform = CGAffineTransform(rotationAngle: 0)
            cardViewOnShow.alpha = 1
        })
        
        UIView.animate(withDuration: duration, animations: {
            self.resetVisibleFrames()
        }) 
    }
}

// MARK: ----------- viewController for test -------------
class CardsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CardsContainerView(frame: view.bounds)
        var cards = [SingleCardView]()
        
        for i in 0..<8 {
            let card = SingleCardView()
            // set card
            card.updateUI()
            
            let size = container.frameOfCardAtIndex(i).size
            card.indexLabel.frame = CGRect(origin: CGPoint.zero, size: size)
            card.indexLabel.text = "\(i)"
            
            cards.append(card)
        }
        container.reloadViewsWithCards(cards, currentCardIndex: 0)
        
        view.addSubview(container)
    }
}

