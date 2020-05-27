//
//  ColorBackgroundFlowLayout.swift
//  BeautiPhi
//
//  Created by L on 2020/5/19.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation

class ColorBackgroundFlowLayout: UICollectionViewFlowLayout {
    var getColorOfSection: ((Int) -> UIColor)?
    
    fileprivate var decorationViewAttris = [ColorBackgroundLayoutAttributes]()
    
    override init() {
        super.init()
        self.registerDecoration()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.registerDecoration()
    }
    
    fileprivate func registerDecoration() {
        self.register(ColorBackgroundDecorationView.self, forDecorationViewOfKind: colorBackgroundDecorationViewID)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let numberOfSections = collectionView?.numberOfSections, numberOfSections > 0 else {
            return
        }
        
        self.decorationViewAttris.removeAll()
        //get layout
        for section in 0..<numberOfSections {
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection:
                section), numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at:
                    IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at:
                    IndexPath(item: numberOfItems - 1, section: section))
                else {
                    continue
            }
         
            // section frame
            var sectionFrame = firstItem.frame.union(lastItem.frame)
           
            // append edgeinsets
            let sectionInset = self.sectionInset
            sectionFrame.origin.x = 0
            sectionFrame.origin.y -= sectionInset.top
            
            if self.scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                sectionFrame.size.width = self.collectionView!.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            

             
            // layout attri
            let attr = ColorBackgroundLayoutAttributes(
                forDecorationViewOfKind: colorBackgroundDecorationViewID,
                with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = getColorOfSection?(section) ?? UIColor.clear
             
            self.decorationViewAttris.append(attr)
        }
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: self.decorationViewAttris.filter {
              return rect.intersects($0.frame)
        })
        return attrs
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == colorBackgroundDecorationViewID {
            return self.decorationViewAttris[indexPath.section]
        }
        
        return super.layoutAttributesForDecorationView(ofKind: elementKind,
                                                       at: indexPath)
    }
}
