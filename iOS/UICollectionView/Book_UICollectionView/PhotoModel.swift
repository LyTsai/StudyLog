//
//  PhotoModel.swift
//  Book_UICollectionView
//
//  Created by L on 2020/5/11.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class PhotoModel {
    var image: UIImage?
    class func defaultModels() -> [PhotoModel]{
        var models = [PhotoModel]()
        for i in 0..<12 {
            let photoModel = PhotoModel()
            photoModel.image = UIImage(named: "icon\(i)")
            models.append(photoModel)
        }
        
        return models
    }
}

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
        imageView.backgroundColor = UIColor.cyan
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        coverMaskView.backgroundColor = UIColor.black
        coverMaskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coverMaskView.alpha = 0
        contentView.insertSubview(coverMaskView, aboveSubview: imageView)
        
        backgroundColor = UIColor.white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        coverMaskView.alpha = 0
        layer.shouldRasterize = false
        
        if layoutAttributes.isKind(of: CoverFlowLayoutAttributes.self) {
            let castedLayoutAttributes = layoutAttributes as! CoverFlowLayoutAttributes
            layer.shouldRasterize = castedLayoutAttributes.shouldRasterize
            coverMaskView.alpha = castedLayoutAttributes.maskingValue
        }
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds.insetBy(dx: 10, dy: 10)
        coverMaskView.frame = bounds
    }

}
