//
//  LayoutConcernedClasses.swift
//  Book_UICollectionView
//
//  Created by iMac on 16/11/23.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class AFCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let kMaxItemDimension: CGFloat = 200
    
    // custom reusableView
    let AFCollectionViewFlowLayoutBackgroundDecoration = "DecorationIdentifier"
    
    // init in OC
    func setupData() {
        sectionInset = UIEdgeInsets(top: 30, left: 80, bottom: 30, right: 20)
        minimumInteritemSpacing = 20
        minimumLineSpacing = 20
        itemSize = CGSize(width: kMaxItemDimension, height: kMaxItemDimension)
        headerReferenceSize = CGSize(width: 60, height: 70)
        register(AFDecorationView.self, forDecorationViewOfKind: AFCollectionViewFlowLayoutBackgroundDecoration)
    }
    
    // called for all types of elements, not just cells
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesArray = super.layoutAttributesForElements(in: rect)
        var newAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesArray! {
            applyLayoutAttributes(attributes)
            
//            if attributes.representedElementCategory == UICollectionElementCategorySupplementaryView {
            // checking the element category of the layout attributes was added.
            if attributes.representedElementCategory == UICollectionElementCategory.supplementaryView {
                let newAttributes = layoutAttributesForDecorationView(ofKind: AFCollectionViewFlowLayoutBackgroundDecoration, at: attributes.indexPath)
                newAttributesArray.append(newAttributes!)
            }
        }
        
        return attributesArray
    }
    
    // the default implementation returns nil
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        applyLayoutAttributes(attributes!) // ?? will crash here, nil
        return attributes
    }
    
    // decoration
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        if elementKind == AFCollectionViewFlowLayoutBackgroundDecoration {
            var tallestCellAttributes = UICollectionViewLayoutAttributes()
            let numberOfCellsInSection = collectionView!.numberOfItems(inSection: indexPath.section)
            
            for i in 0..<numberOfCellsInSection {
                let cellIndexPath = IndexPath(item: i, section: indexPath.section)
                let cellAttributes = layoutAttributesForItem(at: cellIndexPath)!
                
                if cellAttributes.frame.height > tallestCellAttributes.frame.height{
                    tallestCellAttributes = cellAttributes
                }
            }
            
            let decorationViewHeight = tallestCellAttributes.frame.height + headerReferenceSize.height
            layoutAttributes?.size = CGSize(width: collectionViewContentSize.width, height: decorationViewHeight)
            layoutAttributes?.center = CGPoint(x: collectionViewContentSize.width * 0.5, y: tallestCellAttributes.center.y)
            // Place the decoration view behind all the cells
            layoutAttributes!.zIndex = -1
        }
        
        return layoutAttributes
    }
    
    fileprivate func applyLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes){
        if attributes.representedElementKind == nil {
            let width = collectionViewContentSize.width
            let leftMargin = sectionInset.left
            let rightMargin = sectionInset.right
            
            let itemInSection = collectionView!.numberOfItems(inSection: attributes.indexPath.section)
            let firstXPosition = (width - (leftMargin + rightMargin)) / CGFloat(2 * itemInSection)
            let xPosition = firstXPosition + 2 * firstXPosition * CGFloat(attributes.indexPath.item)
            
            attributes.center = CGPoint(x: leftMargin + xPosition, y: attributes.center.y)
            attributes.frame = attributes.frame.integral // Expand `rect' to the smallest rect containing it with integral origin and size.
        }
    }
    
    // called whenever a new item is added or updated to the collection view.
    // finalLayoutAttributesForDisappearingItemAtIndexPath: for animating removal of items from the collection view.
    // The remaining problem is that we reload other sections when we insert a new one. This will cause more than just the appearing sections to animate. Let’s limit which sections we animate.
    
//    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        
//    }
}

class AFDecorationView: UICollectionReusableView {
    fileprivate var binderImageView = UIImageView(image: UIImage(named: "Back0"))
    // in init
    fileprivate func setup(){
        binderImageView.frame = CGRect(x: 10, y: 0, width: frame.width, height: frame.height)
        binderImageView.contentMode = .left
        binderImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(binderImageView)
    }
}

class AFCollectionViewController: UICollectionViewController {
    
}
