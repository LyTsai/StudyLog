//
//  ScrollHeader.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/27.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ScrollSelectFlowLayout: UICollectionViewFlowLayout{
    
    override func prepare() {
        super.prepare()
        
        // layout
        scrollDirection = .horizontal
        minimumLineSpacing = 30
        minimumInteritemSpacing = 20
        sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
}

class ScrollSelectCollectionViewCell: UICollectionViewCell {
    
    let textLabel = UILabel()
    let shadowLayer = CAShapeLayer()
    
    func changeState(_ isChosen: Bool) {
        textLabel.backgroundColor = isChosen ? darkGreenColor : UIColor.white
        textLabel.textColor = isChosen ? UIColor.white : UIColor.darkGray
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    func updateUI() {
        backgroundColor = UIColor.clear
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        shadowLayer.shadowPath = UIBezierPath(rect: bounds.insetBy(dx: 2, dy: 0)).cgPath
        shadowLayer.shadowOpacity = 0.6
        shadowLayer.shadowRadius = 2
        layer.addSublayer(shadowLayer)
        
        textLabel.frame = bounds
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0

        textLabel.layer.masksToBounds = true
        textLabel.layer.cornerRadius = 5
        
        addSubview(textLabel)
    }
}

// MARK:----------------------- viewController For Test -----------------------
class LTScrollSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var data = [["Test", "Tree","section0","Last"],["section1"],["Test", "Tree","section2","Last"],["Test", "section3","Last"],["Test", "Tree","section4","Last"]]
    let cellID = "cellID"
    
    var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollLayout = ScrollSelectFlowLayout()
        scrollLayout.itemSize = CGSize(width: viewWidth / 4, height: 40)
        automaticallyAdjustsScrollViewInsets = false
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 64, width: viewWidth, height: 80), collectionViewLayout: scrollLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.lightGray
        
        collectionView.register(ScrollCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellID)
        
        view.addSubview(collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScrollSelectCollectionViewCell
        cell.textLabel.text = data[indexPath.section][indexPath.row]

        let itemChosen = (indexPath == chosenIndexPath) ? true : false
        cell.changeState(itemChosen)
        
        return cell
    }

    // MARK: ------------ delegate ---------------

    var chosenIndexPath = IndexPath(row: 0, section: 0)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // at least one selected, for the detail cards down
        let lastIndexPath = chosenIndexPath
        if lastIndexPath == indexPath {
            return
        }
        chosenIndexPath = indexPath
        collectionView.reloadItems(at: [lastIndexPath, chosenIndexPath])
        
        // scroll to center
        viewDidLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: viewWidth, height: 80)
        collectionView.scrollToItem(at: chosenIndexPath, at: .centeredHorizontally, animated: true)
    }
}
