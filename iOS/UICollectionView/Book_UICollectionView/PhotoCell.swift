//
//  PhotoCell.swift
//  Book_UICollectionView
//
//  Created by L on 2020/5/12.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit

let photoCellID = "Photo Cell Identifier"
class PhotoCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{ imageView.image = image }
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate var coverMaskView = UIView() // maskView is a property of UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        imageView.backgroundColor = UIColor.purple
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        coverMaskView.backgroundColor = UIColor.black
        coverMaskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coverMaskView.alpha = 0
        contentView.insertSubview(coverMaskView, aboveSubview: imageView)
        
        // selected background
        let selectedBackgroundView = UIView(frame: CGRect.zero)
        selectedBackgroundView.backgroundColor = UIColor.orange
        self.selectedBackgroundView = selectedBackgroundView
        
        contentView.backgroundColor = UIColor.white
    }
    
    
    func setDisabled(_ disabled: Bool) {
        contentView.alpha = disabled ? 0.5 : 1
        backgroundColor = disabled ? UIColor.gray : UIColor.white
    }
    
    // default setup
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image = nil
        isSelected = false
    }
    
    // Classes that want to support custom layout attributes specific to a given UICollectionViewLayout subclass can apply them here.
    // This allows the view to work in conjunction with a layout class that returns a custom subclass of UICollectionViewLayoutAttributes from -layoutAttributesForItem: or the corresponding layoutAttributesForHeader/Footer methods.
    // -applyLayoutAttributes: is then called after the view is added to the collection view and just before the view is returned from the reuse queue.
    // Note that -applyLayoutAttributes: is only called when attributes change, as defined by -isEqual:.
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        coverMaskView.alpha = 0
        layer.shouldRasterize = false
        
        // for cover flow layout, set for mask
        if let castedLayoutAttributes = layoutAttributes as? CoverFlowLayoutAttributes {
            layer.shouldRasterize = castedLayoutAttributes.shouldRasterize
            coverMaskView.alpha = castedLayoutAttributes.maskingValue
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds.insetBy(dx: 10, dy: 10)
        coverMaskView.frame = bounds
    }

}

