//
//  CategoryViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// for test only now
class CategoryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // backImage, gradient
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        // collection
        automaticallyAdjustsScrollViewInsets = false
        let cateFrame = CGRect(x: 0, y: 64, width: width, height: height - 64 - 49)
        let category = WindingCategoryCollectionView.createWithFrame(cateFrame)
        view.addSubview(category)
    }
}
