//
//  ScorecardActionView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/14.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
import WebKit

class ScorecardActionView: ScorecardConcertoView, WKNavigationDelegate {
    fileprivate var cardsView: CardsResultDisplayTableView!
    fileprivate let legendLabel = UILabel()
    fileprivate let webView = WKWebView(frame: CGRect.zero)
    override func addView() {
        super.addView()
        
        let textSize = 12 * fontFactor
        let tag = #imageLiteral(resourceName: "icon_legend")
        let imageText = NSTextAttachment()
        imageText.image = tag
        imageText.bounds = CGRect(x: 0, y: 0, width: textSize * 17 / 16, height: textSize)
        
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(attachment:imageText))
        attributedText.append(NSAttributedString(string: "- Your match", attributes: [.font: UIFont.systemFont(ofSize: textSize, weight: .semibold)]))
        legendLabel.attributedText = attributedText
        
        cardsView = CardsResultDisplayTableView.createWithFrame(bounds, cellHeight: 65 * fontFactor, headerHeight: 80 * fontFactor, footerHeight: 20 * fontFactor)
        view.addSubview(legendLabel)
        view.addSubview(cardsView)
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        hideCalendar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        legendLabel.frame = CGRect(x: remainedFrame.minX, y: remainedFrame.minY, width: remainedFrame.width, height: 36 * fontFactor).insetBy(dx: 18 * fontFactor, dy: 0)
        cardsView.frame = CGRect(x: remainedFrame.minX, y: legendLabel.frame.maxY, width: remainedFrame.width, height: remainedFrame.height - legendLabel.frame.height)
        
        webView.frame = remainedFrame
    }
    
    // view for action view based on matched cards 
    func setupCardBasedActionView(_ measurement: MeasurementObjModel) {
        title = "Improve your score –\n"
        
        cardsView.isHidden = false
        webView.isHidden = true
        cardsView.setupWithMeasurement(measurement)
        setupWithSubTitle("Cards to Change; Cards to Keep; and Cards to Watch", concertoType: .how)
    }
    
    // view for url based action view
    // actionIndex >= 1
    func setupURLBasedActionView(_ riskKey: String, actionIndex: Int) {
        cardsView.isHidden = true
        legendLabel.isHidden = true
        
        webView.isHidden = false
        let howUrls = collection.getRisk(riskKey)!.howUrls
        var urlString: String!
        if actionIndex == 1 {
            urlString = howUrls.first!
            title = "Action Planners"
        }else {
            title = "Other Actionable Data"
            urlString = howUrls.last!
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            webView.load(request)
            spinner = LoadingWhirlProcess()
        }
        setupWithSubTitle("", concertoType: .how)
    }
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel, actionIndex: Int) {
        legendLabel.isHidden = true
        cardsView.isHidden = true
        webView.isHidden = false
        let howUrls = collection.getRisk(measurement.riskKey)!.howUrls
        var urlString: String!
        if actionIndex == 1 {
            urlString = howUrls.first!
            title = "Action Planners"
        }else {
            title = "Other Actionable Data"
            urlString = howUrls.last!
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            webView.load(request)
            spinner = LoadingWhirlProcess()
        }
        setupWithSubTitle("", concertoType: .how)
    }
    
    var spinner: LoadingWhirlProcess!
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.loadingFinished()
        spinner = nil
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.loadingFinished()
        spinner = nil
    }
}
