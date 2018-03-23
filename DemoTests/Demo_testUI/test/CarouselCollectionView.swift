//
//  CarouselCollectionView.swift
//  Demo_testUI
//
//  Created by iMac on 2018/3/19.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation

class CarouselCollectionView: UICollectionView, UICollectionViewDataSource {
    var indexes = [Int]()
    
    class func createWithFrame(_ frame: CGRect, totalNumber: Int) -> CarouselCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let carousel = CarouselCollectionView(frame: frame, collectionViewLayout: layout)
        
        
        var indexes = [totalNumber - 1]
        for i in 0..<totalNumber {
            indexes.append(i)
        }
        indexes.append(0)
        
        carousel.indexes = indexes
        
        carousel.dataSource = carousel
        
        return carousel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

