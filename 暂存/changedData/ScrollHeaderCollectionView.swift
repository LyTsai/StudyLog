//
//  ScrollHeaderCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/11/16.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: ----------------- header collection view --------------------
class HeaderCollectionViewCell: UICollectionViewCell {
    var text = "" {
        didSet{
            textLabel.text = text
        }
    }
    
    var imageNamed = "icon_risk_heart" {
        didSet{
            imageView.image = UIImage(named: imageNamed)
        }
    }
    
    private var imageView = UIImageView()
    private var textLabel = UILabel()
    private var shadowLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clearColor()
//        setShadowBack()

    }
    
    private func setTextAndImage(){
        textLabel.textAlignment = .Center
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.boldSystemFontOfSize(12)
        textLabel.backgroundColor = UIColor.clearColor()
        
        contentView.addSubview(textLabel)
        contentView.addSubview(imageView)
    }
    
    private func setShadowBack(){
        shadowLayer.shadowOffset = CGSizeMake(0, 5)
        shadowLayer.shadowColor = UIColor.darkGrayColor().CGColor
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowRadius = 5
        contentView.layer.addSublayer(shadowLayer)
        
        textLabel.frame = CGRectZero
        textLabel.backgroundColor = UIColor.whiteColor()
        textLabel.textColor = UIColor.lightGrayColor()
        textLabel.textAlignment = .Center
        textLabel.adjustFontToFit()
        textLabel.layer.cornerRadius = 4
        textLabel.layer.masksToBounds = true
        
        contentView.addSubview(textLabel)
    }
    
    override var selected: Bool {
        didSet {
//            textLabel.textColor = (selected ? selectedTextColor: unselectedTextColor)
//            textLabel.backgroundColor = (selected ? selectedCellBackColor: UIColor.whiteColor())
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = ""
        selected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
//        textLabel.frame = CGRectInset(bounds, 4, 4)
//        shadowLayer.frame = bounds
//        shadowLayer.shadowPath = UIBezierPath(rect: CGRectInset(bounds, 3, 3)).CGPath
    }
}

// used as seperator
//class HeaderView: UICollectionReusableView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupUI()
//    }
//    
//    func setupUI() {
//        backgroundColor = UIColor.darkGrayColor()
//    }
//}


let headerCellID = "CellIdentifier"
let headerViewID = "HeaderView Identifier"
class ScrollHeaderCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var assessmentDelegate: AssessmentTopView!
    private var titles = [String]() {
        didSet {
            reloadData()
        }
    }
    
    class func createHeaderWithFrame(frame: CGRect, dataSource: [String]) -> ScrollHeaderCollectionView {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionViewLayout.scrollDirection = .Horizontal
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 3.5
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        collectionViewLayout.itemSize = CGSize(width: 106, height: 60)
//        collectionViewLayout.headerReferenceSize = CGSize(width: 3, height: 10)
        
        let headerCollectionView = ScrollHeaderCollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        headerCollectionView.titles = dataSource
        headerCollectionView.backgroundColor = UIColor.lightGrayColor()
        
        headerCollectionView.registerClass(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: headerCellID)
//        headerCollectionView.registerClass(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewID)
        
        headerCollectionView.dataSource = headerCollectionView
        headerCollectionView.delegate = headerCollectionView

        return headerCollectionView
    }
    
    // MARK: --------- collectionView of header -----------------
    var selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0) // the first as default
    // dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(headerCellID, forIndexPath: indexPath) as! HeaderCollectionViewCell
        configureCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: HeaderCollectionViewCell, forIndexPath indexPath: NSIndexPath) {
        cell.selected = false
        cell.text = titles[indexPath.item]
        if indexPath == selectedIndexPath {
            cell.selected = true
        }
    }

    // header
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerViewID, forIndexPath: indexPath) as! HeaderView
//        return header
//    }
    
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        updateUIAtItem(indexPath.item)
        assessmentDelegate.selectedHeaderIndex = indexPath.item
    }
    
    func updateUIAtItem(index: Int) {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        
        let lastSelectedIndexPath = self.selectedIndexPath
        self.selectedIndexPath = indexPath
        if (lastSelectedIndexPath == indexPath) { return }
        
        // new selection of risk
        performBatchUpdates({
            self.reloadItemsAtIndexPaths([lastSelectedIndexPath])
            self.reloadItemsAtIndexPaths([indexPath])
        }) { (true) in
            self.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
            // put focus onto selected risk item
        }
    }
    
}