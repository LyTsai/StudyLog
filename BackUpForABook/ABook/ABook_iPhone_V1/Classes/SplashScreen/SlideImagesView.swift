//
//  SlideImagesScrollView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class SlideImagesView: UIView, UIScrollViewDelegate {
    var pageControl = UIPageControl()
    var scrollView = UIScrollView()
    
    weak var hostVC: SplashScreenViewController!
    
    class func createWithFrame(_ frame: CGRect, images: [UIImage], margin: CGFloat, pageControlHeight: CGFloat) -> SlideImagesView {
        let slideView = SlideImagesView(frame: frame)
        slideView.setupWithImages(images, margin: margin, pageControlHeight: pageControlHeight)
        
        return slideView
    }
    
    // add and set up
    fileprivate func setupWithImages(_ images: [UIImage], margin: CGFloat, pageControlHeight: CGFloat) {
        let imageNumber = images.count
        
        // scrollView
        let scrollFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - pageControlHeight)
        scrollView.frame = scrollFrame
        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(imageNumber), height: scrollFrame.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        let imageLength = min(bounds.width - 2 * margin, scrollFrame.height)
        let hMargin = (bounds.width - imageLength) * 0.5
        for (i, image) in images.enumerated() {
            let currentX = hMargin + CGFloat(i) * (imageLength + 2 * hMargin)
            let imageView = UIImageView(frame: CGRect(x: currentX, y: 0, width: imageLength, height: imageLength))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
        }
        
        // pageControl
        let pageControlWidth = CGFloat(imageNumber * 3 - 2) * margin * 2
        pageControl.frame = CGRect(x: bounds.midX - pageControlWidth * 0.5, y: bounds.height - pageControlHeight, width: pageControlWidth, height: pageControlHeight)
        pageControl.numberOfPages = imageNumber
        pageControl.currentPage = 0
        pageControl.setValue(UIImage(named: "pageControl_current"), forKey: "currentPageImage")
        pageControl.setValue(UIImage(named: "pageControl_other"), forKey: "pageImage")
        pageControl.addTarget(self, action: #selector(dotClicked), for: .valueChanged)
        
        addSubview(scrollView)
        addSubview(pageControl)
    }
    
    func dotClicked()  {
        UIView.animate(withDuration: 0.5) { 
            self.scrollView.contentOffset.x = self.bounds.width * CGFloat(self.pageControl.currentPage)
        }
    }
    
    // delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let number = Int(offsetX / bounds.width)
        pageControl.currentPage = number
        
        if hostVC != nil {
            hostVC.promptLabel.text = hostVC.promptTexts[number]
            let titleLabel = hostVC.titleLabel
            
            titleLabel.text = hostVC.titles[number]
            let fontSize: CGFloat = titleLabel.frame.height / (number == 0 ? 2.4: 3.8)
            titleLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
}
