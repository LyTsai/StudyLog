//
//  ImageReviewScrollView.swift
//  Demo_testUI
//
//  Created by L on 2020/5/11.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ImageReviewScrollView: UIScrollView, UIScrollViewDelegate {
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
        self.delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 4
        imageView.contentMode = .scaleAspectFit
        
        addSubview(imageView)
        
        // zoom in
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tapGR.numberOfTapsRequired = 2
        addGestureRecognizer(tapGR)
    }
    
    func layoutImageView() {
//        if let image = imageView.image {
//            self.setScaleAspectFrameInConfine(self.frame, widthHeightRatio: image.size.width / image.size.height)
//        }
        
        self.contentSize = self.frame.size
        imageView.frame = self.bounds
        
    }
    
    // tap back
    @objc func doubleTap() {
        let zoomRect = self.bounds
        self.zoom(to: zoomRect, animated: true)
    }
    
    func setReviewForImage( _ image: UIImage) {
        imageView.image = image
//        layoutImageView()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
}
