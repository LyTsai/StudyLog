//
//  MatchedCategoriesRoadViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/14.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCategoriesRoadViewController: MultipleUserViewController {
    fileprivate var matchedCards = MatchedCardsDisplayModel.getCurrentCategoryOfCardsPlayed()
    fileprivate var roadView: MatchedCategoriesRoadCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bar
        addAllBarButtonItems("Matched Cards")
        
        // back image
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        // cards
        if matchedCards.count == 0 {
            let addView = ViewForAdd.createWithFrame(mainFrame.insetBy(dx: width * 0.15, dy: height * 0.15), topImage: UIImage(named: "icon_search"), title: "No Game Played", prompt: "please go to assessment")
            addView.personImageView.image = UIImage(named: "icon_assess")
            view.addSubview(addView)
            return
        }
        
        // has cards
        var categories = [CategoryDisplayModel]()
        for key in Array(matchedCards.keys) {
            if let category = CategoryDisplayModel.getModelWithKey(key) {
                categories.append(category)
            }
        }
        
        roadView = MatchedCategoriesRoadCollectionView.createWithFrame(mainFrame, categories: categories)
        roadView.matchedCards = matchedCards
        roadView.hostVC = self
        view.addSubview(roadView)
    }
    
    
    fileprivate func setupUIWithMatchedCards(_ matchedCards: [String: [MatchedCardsDisplayModel]]) {
        self.matchedCards = matchedCards
        roadView.matchedCards = matchedCards
        
        for view in view.subviews {
            if view.isKind(of: UserSelectionTableView.self) {
                continue
            }
            
            view.removeFromSuperview()
        }
        
        // size

        
        for subView in view.subviews {
            if subView.isKind(of: UserSelectionTableView.self) {
                view.bringSubview(toFront: subView)
                break
            }
            
        }
    }
    
    
}
