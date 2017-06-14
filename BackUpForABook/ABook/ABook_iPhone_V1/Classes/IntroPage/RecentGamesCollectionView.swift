//
//  ImageOnlyCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/15.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// games collection view
let imageOnlyItemID = "image only item ID"
class ImageOnlyCollectionViewCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{
            if image != oldValue { imageView.image = image }
        }
    }
    
    // UI
    private let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}

// collection
class RecentGamesCollectionView: UICollectionView, UICollectionViewDataSource {
    var games = [RiskObjModel]() {
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        dataSource = self
        register(ImageOnlyCollectionViewCell.self, forCellWithReuseIdentifier: imageOnlyItemID)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let length = bounds.height
        
        flowLayout.itemSize = CGSize(width: length, height: length)
        flowLayout.minimumInteritemSpacing = length / 5
        flowLayout.minimumLineSpacing = length / 5
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = .horizontal
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageOnlyItemID, for: indexPath) as! ImageOnlyCollectionViewCell
        cell.image = games[indexPath.row].imageObj
        
        return cell
    }
}
