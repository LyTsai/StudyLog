//
//  ImageReviewScrollView.swift
//  Demo_testUI
//
//  Created by L on 2020/3/24.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation

class ImageReviewScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBasic()
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate func setupBasic() {
        addSubview(imageView)
    }
}
