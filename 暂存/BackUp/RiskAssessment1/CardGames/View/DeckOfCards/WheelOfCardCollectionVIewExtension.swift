
//  WheelOfCardCollectionVIewExtension.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/28.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
extension WheelOfCardsCollectionView: UICollectionViewDelegate {
    
    func scrollCard()  {
        let layout = self.collectionViewLayout as! CircularCollectionViewLayout
        
        // get current focusing item
        var curItem = self.contentOffset.x / (layout.itemSize.width * (1.0 - layout.overlap))
        if (2.0 * (curItem - CGFloat(Int(curItem))) > 1.0) {
            curItem += 1.0
        }
        
        curItem = CGFloat(Int(curItem))
        
        var assessmentTopDelegate: AssessmentTopView!
        if topDelegate.isKind(of: AssessmentTopView.self) {
            assessmentTopDelegate = topDelegate as! AssessmentTopView
        }
        
        let maxItem = cardFactory.totalNumberOfItems() - 1
//        let currentRiskIndex = assessmentTopDelegate.selectedHeaderIndex
        
        if Int(curItem) == maxItem {
            print("last item of this risk now")
//            if currentRiskIndex == assessmentTopDelegate.numberOfHeaderItems - 1 {
//                print("the last risk, data completed")
                // go to summary
                
//            }else {
                // move to next risk
//                assessmentTopDelegate.selectedHeaderIndex += 1
                //assessmentTopDelegate.showTheSummary()
//            }
        } else {
            // move to next item, scroll the cards
            var itemRect = CGRect(origin: CGPoint.zero, size: layout.itemSize)
            itemRect.origin.x += CGFloat(Int(curItem) + 1) * layout.itemSize.width * (1.0 - layout.overlap)
            
            self.scrollRectToVisible(itemRect, animated: true)
        }
    }
}

extension WheelOfCardsCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.frame.size.width
        let scrollContentSizeWidth = scrollView.contentSize.width
        let scrollOffsetX = scrollView.contentOffset.x
        
        let margin: CGFloat = 20.0
        
        var assessmentTopDelegate: AssessmentTopView!
        if topDelegate.isKind(of: AssessmentTopView.self) {
            assessmentTopDelegate = topDelegate as! AssessmentTopView
        }
        
        if (scrollOffsetX + margin < 0.0) {
            // over the begin edge
            assessmentTopDelegate.onBegin()
        }
        else if (scrollOffsetX + scrollViewWidth - margin > scrollContentSizeWidth)
        {
            // over the end
            assessmentTopDelegate.onEnd()
        }
    }
}
