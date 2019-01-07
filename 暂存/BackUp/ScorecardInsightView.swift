//
//  ScorecardInsightView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/26.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class ScorecardInsightView: ScorecardConcertoView {
    var webView = UIWebView()
    
    
    
    var imageOn: UIImage! {
        didSet{
            if imageOn != oldValue {
                imageView.image = imageOn
                setupContentSize()
            }
        }
    }
    fileprivate let scroll = UIScrollView()
    fileprivate let imageView = UIImageView()
    override func addView() {
        super.addView()
        
        scroll.bounces = false
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)
        scroll.addSubview(imageView)
        
        imageOn = #imageLiteral(resourceName: "Insight")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("insight: 4")
        let xMargin = 10 * bounds.width / 345
        scroll.frame = remainedFrame.insetBy(dx: xMargin, dy: xMargin * 0.2)
        setupContentSize()
    }
    
    fileprivate func setupContentSize() {
        if imageOn != nil {
            let imageSize = imageOn.size
            imageView.frame = CGRect(x: 0, y: 0, width: scroll.frame.width, height: scroll.frame.width * imageSize.height / imageSize.width)
            scroll.contentSize = CGSize(width: imageView.frame.width, height: imageView.frame.height + 10)
        }
        
    }
    
    func setupWithRisk(_ riskKey: String, userKey: String) {
        let subTitle = "Insight"
        let topColor = UIColorFromRGB(255, green: 151, blue: 164)
        let bannerColor = UIColorFromRGB(0, green: 102, blue: 235)
        setupWithRisk(riskKey, subTitle: subTitle, topTintColor: topColor, decoImage: #imageLiteral(resourceName: "balloon_Insight"), bannerColor: bannerColor)
    }
}
