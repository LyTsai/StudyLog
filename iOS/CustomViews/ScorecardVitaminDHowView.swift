//
//  ScorecardVitaminDHowView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/22.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation
import WebKit

// VitaminD
class ScorecardVitaminDHowView: ScorecardConcertoView {
    // main view
    fileprivate let plannersView = VitaminDPlannersView()
    fileprivate let hintButton = UIButton(type: .custom)
    
    // detail views
    fileprivate let webView = WKWebView()
    fileprivate var vtDRefView: VitaminDReferenceView!
    
    // addViews
    override func addView() {
        super.addView()
        
        hintButton.setBackgroundImage(#imageLiteral(resourceName: "button_rectMark"), for: .normal)
        hintButton.addTarget(self, action: #selector(visitAllIntroduction), for: .touchUpInside)
        hintButton.isHidden = true
        addSubview(hintButton)
        
        plannersView.showIntroduction = showIntrodution
        plannersView.showPlanner = showPlanner
        plannersView.showCompare = showCompare
        view.addSubview(plannersView)
        
        // labels
        webView.navigationDelegate = self
        view.addSubview(webView)
        hideCalendar()
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 363
        hintButton.frame = CGRect(center: CGPoint(x: bannerView.frame.maxX + 20 * one, y: bannerView.frame.midY), width: 17 * one, height: 18 * one)
        
        plannersView.layoutWithFrame(remainedFrame.insetBy(dx: 0, dy: one))
        webView.frame = CGRect(x: -remainedFrame.width, y: remainedFrame.minY, width: remainedFrame.width, height: remainedFrame.height)
    }
    

    // data actions
    fileprivate var urlStrings = [String]()
    fileprivate var riskKey = String()    // for this risk target
    fileprivate var userKey = String()    // done for this user
    
    fileprivate var measurement: MeasurementObjModel!
    
    func setupWithRiskAndUser(_ riskKey: String!, userKey: String) {
        title = "Action Planners"
        setupWithSubTitle("", concertoType: .how)
        
        self.urlStrings = collection.getRisk(riskKey).howUrls
        if self.urlStrings.count > 8 {
            self.urlStrings.removeLast()
        }
        self.riskKey = riskKey
        self.userKey = userKey
    }
    
    // actions
    var onMainRoad = true
    func goBackToLastView() {
        UIView.animate(withDuration: 0.4) {
            if self.webView.transform != .identity {
                self.onMainRoad = true
                self.title = "Action Planners"
                self.webView.transform = CGAffineTransform.identity
                self.webView.clearView()
            }else {
                if self.vtDRefView != nil {
                    if self.vtDRefView.showDosage {
                        self.vtDRefView.hideDosageView(true)
                    }else {
                        self.onMainRoad = true
                        self.title = "Action Planners"
                        self.setupWithSubTitle("", concertoType: .how)
                        self.vtDRefView.transform = CGAffineTransform.identity
                    }
                }
            }
        }
    }
    
    @objc func visitAllIntroduction() {
        let webDisplayView = WebViewDisplayViewController()
        webDisplayView.setupWithUrlString(nil)
        viewController.presentOverCurrentViewController(webDisplayView, completion: nil)
    }
    
    fileprivate func showIntrodution(_ index: Int) {
        onMainRoad = false
        
        let webDisplayView = WebViewDisplayViewController()
        webDisplayView.setupWithUrlString(urlStrings[index])
        viewController.presentOverCurrentViewController(webDisplayView, completion: nil)
    }
    
    fileprivate func showPlanner(_ index: Int) {
        onMainRoad = false
        if index == 1 {
            if vtDRefView == nil {
                vtDRefView = VitaminDReferenceView(frame: CGRect(x: remainedFrame.minX, y: bounds.height, width: remainedFrame.width, height: remainedFrame.height).insetBy(dx: 5, dy: 5))
                vtDRefView.setupWithRiskAndUser(riskKey, userKey: userKey)
                view.addSubview(vtDRefView)
            }
            
            title = "Individualized Calculator\n"
            setupWithSubTitle("For Each Individual", concertoType: .how)
            
            vtDRefView.showDosage = false
            
            UIView.animate(withDuration: 0.3) {
                self.vtDRefView.transform = CGAffineTransform(translationX: 0, y: self.remainedFrame.minY - self.vtDRefView.frame.minY)
            }
        }else {
            // urls
            showWebWithUrlString(urlStrings[index], useLeft: true)
        }
    }
    
    fileprivate func showCompare() {
        onMainRoad = false
        showWebWithUrlString(urlStrings.last!, useLeft: false)
    }
    
    var spinner: LoadingWhirlProcess!
    fileprivate func showWebWithUrlString(_ urlString: String, useLeft: Bool) {
        if useLeft {
            webView.frame.origin = CGPoint(x: -remainedFrame.width, y: remainedFrame.minY)
        }else {
            webView.frame.origin = CGPoint(x: remainedFrame.width + bounds.width, y: remainedFrame.minY)
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            spinner = LoadingWhirlProcess()
            spinner.startLoadingOnView(webView, size: CGSize(width: 80 * fontFactor, height: 80 * fontFactor))
            
            webView.load(request)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.webView.transform = CGAffineTransform(translationX: self.remainedFrame.midX - self.webView.frame.midX, y: 0)
        }
    }
}

extension ScorecardVitaminDHowView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if spinner != nil {
            spinner.loadingFinished()
            spinner = nil
        }
    }
}

extension WKWebView {
    func clearView() {
        if let url = URL(string: "about:blank") {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 1)
            print("clear current")
            load(request)
        }
    }
}
