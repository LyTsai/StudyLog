//
//  AutoScrollTextView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/18.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class AutoScrollTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        self.isUserInteractionEnabled = false
        self.textAlignment = .center
        self.backgroundColor = UIColor.clear
        self.bounces = false

        textColor = UIColor.black
        textContainerInset = UIEdgeInsets.zero
    }
    
    fileprivate var bounding = CGRect.zero
    fileprivate var scrollTimer: Timer!
    
    var usedH: CGFloat {
        return layoutManager.usedRect(for: textContainer).height
    }
    
    var needScroll: Bool {
        return usedH > bounding.height
    }
    
    func setupWithBounding(_ bounding: CGRect, shrink: Bool) {
        self.textContainerInset = UIEdgeInsets.zero
        self.contentOffset = CGPoint.zero
        
        self.frame = bounding
        self.bounding = bounding
        
        // adjust
        if !needScroll {
            let gap = (bounding.height - usedH) * 0.5
            if shrink {
                self.frame.size = CGSize(width: bounding.width, height: bounding.height - 2 * gap)
            }else {
                textContainerInset = UIEdgeInsets(top: gap, left: 0, bottom: gap, right: 0)
            }
        }
    }
    
    func startTimer() {
        self.contentOffset = CGPoint.zero
        
        if scrollTimer == nil {
            let offset = fontFactor
            var times = 0
            scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
                if self.contentOffset.y <= (self.usedH - self.bounds.height) {
                    self.contentOffset.y += offset
                }else {
                    times += 1
                    if times == 45 {
                        timer.invalidate()
                        self.scrollTimer = nil
                    }
                    timer.fireDate = .distantFuture
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.contentOffset = CGPoint.zero
                        timer.fireDate = Date()
                    })
                }
            })
        }
    }
    
    func stopScroll() {
        if scrollTimer != nil {
            self.contentOffset.y = 0
            scrollTimer.invalidate()
            scrollTimer = nil
        }
    }
}
