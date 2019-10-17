//
//  SlideDisplayView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/11.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class  SlideDisplayView: UIView, UIScrollViewDelegate {
    var currentIndex: Int {
        return pageControl.currentPage
    }
    
    var isFirst: Bool {
        return currentIndex == 0
    }
    
    var isLast: Bool {
        return currentIndex == topNumber - 1
    }

    
    fileprivate var pageControl = UIPageControl()
    fileprivate var scrollView = UIScrollView()
    fileprivate var label = UILabel()
    
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    
    class func createWithFrame(_ frame: CGRect, topViews: [UIView], descriptions: [String], heightPros: (top: CGFloat, bottom: CGFloat), hMargin: CGFloat) -> SlideDisplayView {
        let slideView = SlideDisplayView(frame: frame)
        slideView.setupWithTopViews(topViews, descriptions: descriptions, heightPros: heightPros, hMargin: hMargin)
        
        return slideView
    }
    
    
    // add and set up
    fileprivate var topNumber = 0
    fileprivate var texts = [String]()
    fileprivate func setupWithTopViews(_ topViews: [UIView], descriptions: [String], heightPros: (top: CGFloat, bottom: CGFloat), hMargin: CGFloat) {
        
        // data check
        topNumber = topViews.count
        texts = descriptions
        if descriptions.count < topNumber {
            for _ in descriptions.count..<topNumber {
                texts.append("")
            }
        }
        
        // heights, set pageControl as 0.1 pro
        var topPro = heightPros.top
        var bottomPro = heightPros.bottom
        if topPro + bottomPro > 0.9 {
            topPro = min(0.9, topPro)
            bottomPro = 0.9 - topPro
        }
        
        let topHeight = topPro * bounds.height
        let bottomHeight = bottomPro * bounds.height
        let pageControlHeight = 0.1 * bounds.height
        
        // scrollView
        scrollView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: topHeight)
        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(topNumber), height: topHeight)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        for (i, topView) in topViews.enumerated() {
            topView.frame = CGRect(x: hMargin + CGFloat(i) * bounds.width, y: 0, width: bounds.width - 2 * hMargin, height: topHeight)
            scrollView.addSubview(topView)
        }
        
        // pageControl
        let vMargin = (bounds.height - topHeight - bottomHeight - pageControlHeight) * 0.5
        let pageControlWidth = CGFloat(topNumber * 3 - 2) * bounds.width * 0.02
        pageControl.frame = CGRect(x: bounds.midX - pageControlWidth * 0.5, y: topHeight + vMargin, width: pageControlWidth, height: pageControlHeight)
        pageControl.numberOfPages = topNumber
        pageControl.currentPage = 0
        pageControl.setValue(UIImage(named: "pageControl_current"), forKey: "currentPageImage")
        pageControl.setValue(UIImage(named: "pageControl_other"), forKey: "pageImage")
//        pageControl.addTarget(self, action: #selector(gotoNextView), for: .valueChanged)
        
        // label
        label.frame = CGRect(x: hMargin, y: bounds.height - bottomHeight, width: bounds.width - 2 * hMargin, height: bottomHeight)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: min(bottomHeight / 5, 12))
        label.text = descriptions.first
        
        // add
        addSubview(scrollView)
        addSubview(pageControl)
        addSubview(label)
        
        // arrows
        let arrowWidth = 28 * bounds.width / 375
        let arrowHeight = 90 * bounds.width / 375
        let arrowY = topHeight * 0.5 - arrowHeight * 0.5
        
        let leftFrame = CGRect(x: 0, y: arrowY, width: arrowWidth, height: arrowHeight)
        let rightFrame = CGRect(x: bounds.width - arrowWidth, y: arrowY, width: arrowWidth, height: arrowHeight)
        
        leftArrow.setBackgroundImage(UIImage(named: "move_to_left"), for: .normal)
        leftArrow.frame = leftFrame
        leftArrow.isHidden = true
        
        rightArrow.setBackgroundImage(UIImage(named: "move_to_right"), for: .normal)
        rightArrow.frame = rightFrame
        rightArrow.isHidden = (topNumber == 1)
        
        leftArrow.addTarget(self, action: #selector(goBackToLastView), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
        
        addSubview(leftArrow)
        addSubview(rightArrow)
    }
    
    @objc func moveToNextView()  {
        if isLast {
            print("This is the last page")
        } else {
            let nextN = currentIndex + 1
            UIView.animate(withDuration: 0.5) {
                self.scrollView.contentOffset.x = self.bounds.width * CGFloat(nextN)
            }
        }
        
    }
    
    @objc func goBackToLastView() {
        if isFirst {
            print("This is the first page")
        } else {
            let lastN = currentIndex - 1
            UIView.animate(withDuration: 0.5) {
                self.scrollView.contentOffset.x = self.bounds.width * CGFloat(lastN)
            }
        }
    }
    
    // delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let number = Int(offsetX / bounds.width)
        pageControl.currentPage = number
        label.text = texts[number]
        
        leftArrow.isHidden = isFirst
        rightArrow.isHidden = isLast
    }
}
