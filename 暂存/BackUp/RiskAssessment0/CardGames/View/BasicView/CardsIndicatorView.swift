//
//  CardsIndicatorView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: --------- view of indicator -------------
class CardsIndicatorView: UICollectionView, UICollectionViewDataSource {
    var answerIndex: Int = -1
    var cursorIndex: Int = 0
    
    fileprivate var optionCount: Int = 0
    fileprivate var answerState: CardAnswerState = .unanswered
    
    class func createWithFrame( _ frame: CGRect, answerIndex: Int, optionCount: Int, answerState: CardAnswerState) -> CardsIndicatorView{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collection = CardsIndicatorView(frame: frame, collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.clear
        collection.answerIndex = answerIndex
        collection.optionCount = optionCount
        collection.answerState = answerState
        collection.isUserInteractionEnabled = false
        
        // register
        collection.register(CardsIndicatorCell.self, forCellWithReuseIdentifier: cardsIndicatorCellID)
        
        // delegate
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    func resetData(answerIndex: Int, optionCount: Int, answerState: CardAnswerState) {
        self.answerIndex = answerIndex
        self.optionCount = optionCount
        self.answerState = answerState
        reloadData()
    }

    // MARK: -------------------- data source -------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsIndicatorCellID, for: indexPath) as! CardsIndicatorCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: CardsIndicatorCell, indexPath: IndexPath) {
        if optionCount == 1 {
            cell.state = .normal
            if answerState == .current {
                cell.state = .highlighted
            }
            if answerIndex == 0 {
                cell.state = .answerNo
            }else if answerIndex == 1 {
                cell.state = .selected
            }
        }else {
            if answerState == .current {
                cell.state = .unselected
                if cursorIndex == indexPath.item {
                    cell.state = .highlighted
                }
                if answerIndex == indexPath.item {
                    cell.state = .selected
                }
            }else {
                cell.state = .normal
                if answerIndex == indexPath.item {
                    cell.state = .isAnswer
                }
            }

        }
    }
}

// layout delegate
extension CardsIndicatorView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width / CGFloat(optionCount), height: bounds.height)
    }
}
