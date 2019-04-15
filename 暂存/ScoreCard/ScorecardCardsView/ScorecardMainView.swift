//
//  ScorecardMainView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/12.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let scorecardMainViewCellID = "scorecard main view Cell Identifier"
class ScorecardMainViewCell: UICollectionViewCell {
    var viewOn: UIView! {
        didSet{
            for view in contentView.subviews {
                view.removeFromSuperview()
            }
            contentView.addSubview(viewOn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if viewOn != nil {
            viewOn.frame = bounds
            viewOn.layoutIfNeeded()
        }
    }
}

class ScorecardMainView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var viewsOn = [UIView]() {
        didSet{
            reloadData()
        }
    }
    class func createWithFrame(_ frame: CGRect, viewsOn: [UIView]) -> ScorecardMainView {
        let layout = ScaleLayout()
        layout.minRatio = 0.95

        // create
        let view = ScorecardMainView(frame: frame, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.viewsOn = viewsOn
        view.bounces = false
        view.register(ScorecardMainViewCell.self, forCellWithReuseIdentifier: scorecardMainViewCellID)
        view.dataSource = view
        view.delegate = view
        
        return view
    }
    
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewsOn.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: scorecardMainViewCellID, for: indexPath) as! ScorecardMainViewCell
        cell.viewOn = viewsOn[indexPath.item]
        cell.layer.addBlackShadow(2 * fontFactor)
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! ScaleLayout

        // ratio
        let itemWidth = frame.width * 0.96
        let itemHeight = frame.height * 0.98 // itemWidth / cellWHRatio
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        let marginX = (frame.width - itemWidth) * 0.5
        let marginY = (frame.height - itemHeight) * 0.5
        layout.minimumLineSpacing = -itemWidth * 0.02

        layout.sectionInset = UIEdgeInsets(top: marginY, left: marginX, bottom: marginY, right: marginX)
    
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
