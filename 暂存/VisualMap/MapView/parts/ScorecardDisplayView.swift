//
//  ScorecardDisplayView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardDisplayView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var riskKeys = [String]() {
        didSet{
            if riskKeys != oldValue {
                reloadData()
            }
        }
    }
    class func createWithFrame(_ frame: CGRect, riskKeys: [String]) -> ScorecardDisplayView {
        let layout = ScaleLayout()
        layout.minRatio = 0.9
        
        // 345 * 518

        let itemWidth = min(frame.height * 0.96 * 345 / 630, frame.width * 0.96)
        let itemHeight = itemWidth * 630 / 345
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = -itemWidth * 0.9
        
        let marginX = (frame.width - itemWidth) * 0.5
        let marginY = (frame.height - itemHeight) * 0.5
        layout.sectionInset = UIEdgeInsets(top: marginY, left: marginX, bottom: marginY, right: marginX)
        
        // create
        let view = ScorecardDisplayView(frame: frame, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.riskKeys = riskKeys
        view.register(ScorecardCell.self, forCellWithReuseIdentifier: scorecardCellID)
        view.dataSource = view
        view.delegate = view
//        view.isScrollEnabled = false
    
        return view
    }
    
    // database
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return riskKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: scorecardCellID, for: indexPath) as! ScorecardCell
        cell.riskKey = riskKeys[indexPath.item]
        cell.layer.addBlackShadow(2 * fontFactor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performBatchUpdates({
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }, completion: nil)
    }
}
