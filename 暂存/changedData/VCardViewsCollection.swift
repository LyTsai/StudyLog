//
//  VCardViewsCollection.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 11/3/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import UIKit

// supported vaiews
enum VCardViewType{
    case CardsStack
    case WheelOfCards
}

enum MovementType {
    case NextStack
    case NextItem
    case AnotherGroup
}

class VCardViewsCollectionView: UIView {
    var cardType = VCardViewType.CardsStack
    var cardView = UIView()
    var firstCardFrame = CGRect(x: 80, y: 60, width: 270, height: 385)
    var indexPathOnShow = NSIndexPath(forItem: 0, inSection: 0)
    
    private var dataSource = [VCardModel]()
    
    // init
    func addVCardsView(vCards: [VCardModel]) {
        indexPathOnShow = NSIndexPath(forItem: 0, inSection: 0)
        switch cardType {
        case .CardsStack:
            let container = CardsContainerView()
            
            container.frame = bounds
            container.currentCardFrame = firstCardFrame
            container.loadNewCards(vCards, animated: true)
            container.addSwipeGestureRecognizers()
            
            cardView = container
        case .WheelOfCards:
            let wheelOfCardView = WheelOfCardsCollectionView.createWheelCollectionView(vCards, frame: bounds)
            wheelOfCardView.backgroundColor = UIColor.clearColor()
            wheelOfCardView.vCardsCollectionDelegate = self
        // TODO: define itemSize
            cardView = wheelOfCardView
        }
        dataSource = vCards
        addSubview(cardView)
        
        let testTap = UITapGestureRecognizer(target: self, action: #selector(moveToNext))
        addGestureRecognizer(testTap)
    }
    
    // clicked
    func moveToNext(){
        let indexPath = indexPathOnShow
        var targetSection = indexPath.section
        var targetItem = indexPath.item
        var movement: MovementType = .NextItem
        
        let maxSection = dataSource.count - 1
        let maxItem = dataSource[targetSection].count - 1
        
        if targetSection == maxSection && targetItem == maxItem {
            movement = .AnotherGroup
            print("stay")
        }else if targetSection != maxSection && targetItem == maxItem {
            // move to next section
            targetSection += 1
            targetItem = 0
            movement = .NextStack
        }else {
            // move to next item of this section
            targetItem += 1
            movement = .NextItem
        }
        
        switch cardType {
        case .CardsStack:
            let container = cardView as! CardsContainerView
            switch movement {
            case .NextItem:
                container.swipeToFly()
            case .NextStack:
                print("next stack loaded")
//                container.loadNewCards(dataSource[targetSection], animated: true)
            case .AnotherGroup:
                container.swipeToFly()
            }
            indexPathOnShow = NSIndexPath(forItem: container.currentCardIndex, inSection: targetSection)
            
        case .WheelOfCards:
            let wheelCollectionView = cardView as! WheelOfCardsCollectionView
            let targetIndexPath = NSIndexPath(forItem: targetItem, inSection: targetSection)
            wheelCollectionView.scrollToItemAtIndexPath(targetIndexPath, atScrollPosition: .CenteredHorizontally, animated: true)
            indexPathOnShow = targetIndexPath
            print(targetIndexPath)
        }
    }
}
