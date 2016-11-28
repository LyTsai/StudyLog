//
//  CoverFlowLayout.swift
//  Book_UICollectionView
//
//  Created by iMac on 16/11/28.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit
//import QuartzCore

class PhotoModel {
    var name = "Leaves"
    var image: UIImage!
    
    class func photoModelWithName(name: String, image: UIImage) -> PhotoModel {
        let photeModel = PhotoModel()
        photeModel.name = name
        photeModel.image = image
        
        return photeModel
    }
    
    class func defaultModel() -> [PhotoModel]{
        var model = [PhotoModel]()
        
        for i in 0..<3 {
            let name = "back\(i)"
            model.append(PhotoModel.photoModelWithName(name, image: UIImage(named: name)!))
        }
        
        for i in 0..<12 {
            let name = "icon\(i)"
            model.append(PhotoModel.photoModelWithName(name, image: UIImage(named: name)!))
        }
        
        return model
    }
    
}

class CoverFlowLayoutViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var photoModelArray = PhotoModel.defaultModel()
    var layoutChangeSegmentedControl = UISegmentedControl(items: ["Boring", "Cover Flow"])
    var coverFlowCollectionViewLayout = AFCoverFlowFlowLayout()
    var boringCollectionViewLayout = UICollectionViewFlowLayout()
    
    let CellIdentifier = "CellIdentifier"
    
    // there is a method called "loadView" in UIViewController
    override func loadView() {
        boringCollectionViewLayout.itemSize = CGSize(width: 140, height: 140)
        boringCollectionViewLayout.minimumLineSpacing = 10
        boringCollectionViewLayout.minimumInteritemSpacing = 10
        
        let photoCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: boringCollectionViewLayout)
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
        photoCollectionView.registerClass(AFCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
        
        photoCollectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        photoCollectionView.allowsSelection = false
        photoCollectionView.indicatorStyle = .White
        
        self.collectionView = photoCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutChangeSegmentedControl.selectedSegmentIndex = 0
//        layoutChangeSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar
        layoutChangeSegmentedControl.addTarget(self, action: #selector(layoutChangeSegmentedControlDidChangeValue), forControlEvents: .ValueChanged)
    }
    
    func layoutChangeSegmentedControlDidChangeValue() {
        if layoutChangeSegmentedControl.selectedSegmentIndex == 0 {
            collectionView!.setCollectionViewLayout(boringCollectionViewLayout, animated: true)
        }else {
            collectionView!.setCollectionViewLayout(coverFlowCollectionViewLayout, animated: true)
        }
        // Invalidate the new layout
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    // flowLayoutDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if collectionViewLayout == boringCollectionViewLayout {
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }else {
            if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
                return UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 70)
            }else {
                if UIScreen.mainScreen().bounds.height > 480 {
                    return UIEdgeInsets(top: 0, left: 190, bottom: 0, right: 190)
                }else {
                    return UIEdgeInsets(top: 0, left: 150, bottom: 0, right: 150)
                }
            }
        }
    }
}

class AFCollectionViewCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{
            imageView.image = image
        }
    }
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        imageView.frame = CGRectZero
        imageView.backgroundColor = UIColor.cyanColor()
        contentView.addSubview(imageView)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
    }
    
    override func layoutSubviews() {
        imageView.frame = CGRectInset(bounds, 10, 10)
    }
}

class AFCoverFlowFlowLayout: UICollectionViewFlowLayout {
    func setupInit() {
        scrollDirection = .Horizontal
        itemSize = CGSize(width: 180, height: 180)
        
        minimumLineSpacing = -60  // Gets items up close to one another
        minimumInteritemSpacing = 200 // only one row
    }
    
    /*
     +(Class)layoutAttributesClass
     {
     return [AFCollectionViewLayoutAttributes class];
     }
     
     */
    
    //  re-layout the cells when scrolling
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesArray = super.layoutAttributesForElementsInRect(rect)!
        let visibleRect = CGRect(x: collectionView!.contentOffset.x, y: collectionView!.contentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        
        for attributes in layoutAttributesArray {
            if CGRectIntersectsRect(attributes.frame, rect) {
                applyLayoutAttributes(attributes, forVisibleRect: visibleRect)
            }
        }
        
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)!
        let visibleRect = CGRect(x: collectionView!.contentOffset.x, y: collectionView!.contentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        applyLayoutAttributes(attributes, forVisibleRect: visibleRect)
        
        return attributes
    }
    
    func applyLayoutAttributes(attributes: UICollectionViewLayoutAttributes, forVisibleRect: CGRect)  {
        // skip supplementary views
        if (attributes.representedElementKind != nil) {
            return
        }
    }
}

class CoverFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    var shouldRasterize = true
    var maskingValue: CGFloat = 1.0
    
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let attributes = super.copyWithZone(zone) as! CoverFlowLayoutAttributes
        attributes.shouldRasterize = shouldRasterize
        attributes.maskingValue = maskingValue
        
        return attributes
    }
    override func isEqual(object: AnyObject?) -> Bool {
        let other = object as! CoverFlowLayoutAttributes
        return super.isEqual(other) && (shouldRasterize == other.shouldRasterize) && (maskingValue == other.maskingValue)
    }
}