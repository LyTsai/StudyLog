//
//  NineFactorsCollectionView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/14.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class NineFactorsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var factors = [CardInfoObjModel]()
    fileprivate var positive = false
    class func createwithFrame(_ frame: CGRect, factors: [CardInfoObjModel], positive: Bool) -> NineFactorsCollectionView {
        let standP = fontFactor
        let edgeInset = UIEdgeInsets(top: 10 * standP, left: 15 * standP, bottom: 10 * standP, right: 15 * standP)
        let spacing = 5 * standP
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = edgeInset
        flowLayout.itemSize = CGSize(width: (frame.width - edgeInset.left - edgeInset.right - 2 * spacing) / 3, height: (frame.height - edgeInset.top - edgeInset.bottom - 2 * spacing) / 3)
        
        let collectionView =  NineFactorsCollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.factors = factors
        collectionView.positive = positive
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = collectionView
        collectionView.dataSource = collectionView
        collectionView.register(NineFactorsCollectionViewCell.self, forCellWithReuseIdentifier: nineFactorsCellID)
        
        return collectionView
    }
    

    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return factors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nineFactorsCellID, for: indexPath) as! NineFactorsCollectionViewCell
        let factor = factors[indexPath.item]
        let match = factor.cardOptions.first!.match
        let result = getResultOfFactor(factor)
        cell.configureCellWithText(match?.name, imageUrl: match?.imageUrl, positive: (result == nil || result!) ? positive : !positive, answered: result != nil)
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let factor = factors[indexPath.item]
        
        if let result = getResultOfFactor(factor) {
            factor.saveResult(result == true ? 1 : 0)  // answered before, reverse
        }else {
            factor.saveResult(0) // ME
        }
        
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
    }
    
    fileprivate func getResultOfFactor(_ factor: CardInfoObjModel) -> Bool! {
        if let result = factor.currentSelection() {
            return result == 0 // 0, index of me
        }
        return nil
    }
}
