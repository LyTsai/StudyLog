//
//  PlansMadeConllectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/12.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// 0, 200, 83
let plansMadeCellID = "plans made cell identifier"
class PlansMadeCell: ImageAndTextCell {
    override var isSelected: Bool {
        didSet{
            backLayer.strokeColor = isSelected ? UIColorFromRGB(0, green: 200, blue: 83).cgColor : UIColorFromRGB(0214, green: 222, blue: 233).cgColor
            backLayer.lineWidth = isSelected ? 2 : 1
            backLayer.shadowColor = isSelected ? UIColorFromRGB(0, green: 200, blue: 83).cgColor : UIColor.clear.cgColor
            
            textLabel.textColor = isSelected ? UIColorGray(106) : UIColorGray(136).withAlphaComponent(0.5)
        }
    }

    override func updateUI() {
        super.updateUI()
        
        backLayer.cornerRadius = 5
        backLayer.shadowOpacity = 0.2
        backLayer.shadowOffset = CGSize(width: 0, height: 2)
        backLayer.shadowRadius = 10
        backLayer.fillColor = UIColor.white.cgColor
        backLayer.shadowColor = UIColor.clear.cgColor
    }
    
    // 100 * 113, iH: 70
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 70 / 113).insetBy(dx: 1, dy: 1)
        imageView.frame = topFrame.insetBy(dx: 2, dy: 2)
        
        backLayer.frame = bounds
        let path = UIBezierPath(roundedRect: topFrame, cornerRadius: 5).cgPath
        backLayer.path = path
        backLayer.shadowPath = path
        
        textLabel.frame = CGRect(x: 0, y: topFrame.maxY, width: bounds.width, height: bounds.height - topFrame.height)
        textLabel.font = UIFont.systemFont(ofSize: 10)
    }
    
}

class PlansMadeCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var hostDelegate: AllPlansMadeCell!
    var plans = [PlanModel]() {
        didSet{
            if plans != oldValue {
                reloadData()
            }
        }
    }
    
    // first one as default
    fileprivate var chosenIndex = 0 {
        didSet{
            if chosenIndex != oldValue {
                hostDelegate.tableVCDelegate.chosenIndex = chosenIndex
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(PlansMadeCell.self, forCellWithReuseIdentifier: plansMadeCellID)
        
        dataSource = self
        delegate = self
    }
    
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: plansMadeCellID, for: indexPath) as! PlansMadeCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    fileprivate func configureCell(_ cell: PlansMadeCell, indexPath: IndexPath) {
        let plan = plans[indexPath.item]
        cell.text = plan.text
        cell.image = plan.image
        cell.isSelected = false
        
        if indexPath.item == chosenIndex {
            selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            cell.isSelected = true
        }
        
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performBatchUpdates({ 
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }) { (true) in
            self.chosenIndex = indexPath.row
        }
    }
    
    // layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: bounds.width * 0.3, height: bounds.height)
    }
}
