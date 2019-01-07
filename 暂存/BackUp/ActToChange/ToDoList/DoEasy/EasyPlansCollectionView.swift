//
//  EasyPlansCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class EasyPlansCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var plans: [PlanModel]!
    var date = Date()
    weak var hostVC: DoEasyViewController!
    var tempSelected = Set<Int>()
    var tempDeleted = Set<Int>()
    
    
    override var allowsSelection: Bool {
        didSet{
            if allowsSelection != oldValue {
                tempSelected.removeAll()
                tempDeleted.removeAll()
                
                allowsMultipleSelection = allowsSelection
                
                reloadData()
            }
        }
    }
    class func createWithFrame(_ frame: CGRect) -> EasyPlansCollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 4
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 10, bottom: 20, right: 10)
        flowLayout.itemSize = CGSize(width: (frame.width - 28) / 3, height: (frame.height - 20) / 3)
        
        let collection = EasyPlansCollectionView(frame: frame, collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.white
        collection.allowsSelection = false
        collection.getPlans()
        
        collection.register(EasyPlanCell.self, forCellWithReuseIdentifier: easyPlanCellID)
        
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    fileprivate func getPlans() {
        plans = NSKeyedUnarchiver.unarchiveObject(withFile: easyPlanPath) as? [PlanModel]
        if plans == nil {
            plans = PlanModel.getPlans()
        }
    }
    
    // MARK: ------------- datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: easyPlanCellID, for: indexPath) as! EasyPlanCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: EasyPlanCell, indexPath: IndexPath) {
        
        let plan = plans[indexPath.item]
        
        cell.planTitle = plan.text
        cell.planImage = plan.image
        cell.mainColor = colorPairs[indexPath.item % colorPairs.count].fill
        
        if plan.isChosenForDate(date) {
            selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        }
        cell.isSelected = plan.isChosenForDate(date)
        cell.isReminded = plan.isRemindedForDate(date)
        cell.isEditing = allowsSelection
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tempDeleted.contains(indexPath.item) {
            // record in database
            tempDeleted.remove(indexPath.item)
        }else {
            tempSelected.insert(indexPath.item)
        }
        
        hostVC.setReminderView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if tempSelected.contains(indexPath.item) {
            tempSelected.remove(indexPath.item)
        } else {
             // record in database
            tempDeleted.insert(indexPath.item)
        }
        
        if tempSelected.count == 0 && tempDeleted.count == 0 {
            hostVC.setReminderView.isHidden = true
        }else {
            hostVC.setReminderView.isHidden = false
        }
    }
}
