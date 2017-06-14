//
//  PlansCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/20.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// FlowLayout
class PlanLayout: UICollectionViewFlowLayout {
    var maxYs = [Int: CGFloat]() // colNumber: colHeight(maxY)
    var attriArray = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 20, right: 5)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        let cellWidth = (collectionView!.bounds.width - 10) / 3
        itemSize = CGSize(width: cellWidth, height: cellWidth * 1.1)
        
        maxYs[0] = 20
        maxYs[1] = 5
        maxYs[2] = 20
        
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        for i in 0..<itemCount {
            let attributes = layoutAttributesForItem(at: IndexPath(item: i, section: 0))
            attriArray.append(attributes!)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // if not set, can not scroll
    override var collectionViewContentSize: CGSize {
        var maxYItem = 0
        for (key, value) in maxYs {
            if maxYs[maxYItem]! < value {
                maxYItem = key
            }
        }
        return CGSize(width: 0, height: maxYs[maxYItem]! + sectionInset.bottom)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let colNumber = indexPath.item % 3
        let itemX = sectionInset.left + itemSize.width * CGFloat(colNumber)
        let itemY = maxYs[colNumber]!
        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.frame = CGRect(x: itemX, y: itemY, width: itemSize.width, height: itemSize.height)
        maxYs[colNumber] = attributes?.frame.maxY
        
        return attributes
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attriArray
    }
    
}

// view
class PlansCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var plans = [PlanModel]()
    var date = Date()

    var week: Int {
        return CalendarModel.getWeekIndexOfDate(date)
    }
    
    weak var hostVCDelegate: DoImpactfulViewController!
    
    class func createWithFrame(_ frame: CGRect, plans: [PlanModel], date: Date) -> PlansCollectionView {
        let collection = PlansCollectionView(frame: frame, collectionViewLayout: PlanLayout())
        collection.backgroundColor = UIColor.clear
        collection.allowsMultipleSelection = true
        collection.plans = plans
        collection.date = date
        
        collection.register(PlanCell.self, forCellWithReuseIdentifier: planCellID)
        
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: planCellID, for: indexPath) as! PlanCell
        configureCell(cell, indexPath: indexPath)

        return cell
    }
    
    fileprivate func configureCell(_ cell: PlanCell, indexPath: IndexPath) {
        let plan = plans[indexPath.row]
        
        let colorIndex = indexPath.row % colorPairs.count
        let fillColor = colorPairs[colorIndex].fill
        let borderColor = colorPairs[colorIndex].border
        
        cell.image = plan.image
        cell.text = plan.text
        cell.index = indexPath.row + 1
        cell.borderColor = borderColor
        cell.fillColor = fillColor
        
        if plan.isChosenForDate(date) {
            self.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
            cell.isSelected = true
        }
    }
    
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        plans[indexPath.row].chosenWeeks.add(date)
        plans[indexPath.row].chosenWeeks.add(week)
        hostVCDelegate.addView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        plans[indexPath.row].chosenWeeks.remove(week)

        var flag = true
        for plan in plans {
            if plan.isChosenForDate(date) == true {
                flag = false
                break
            }
        }
        hostVCDelegate.addView.isHidden = flag
    }
}
