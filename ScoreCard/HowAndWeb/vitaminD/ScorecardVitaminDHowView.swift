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
    fileprivate let backScrollView = UIScrollView()
    fileprivate let dosageLabel = UILabel()
    fileprivate let sourceLabel = UILabel()
    fileprivate var mainNavi: VitaminDHowMainView!
    fileprivate var dosageNavi: VitaminDDosageView!
    fileprivate var sourceNavi: VitaminDSourceView!
    
    // go back buttons
    fileprivate let dismissButton = UIButton(type: .custom)
    fileprivate let toMainButton = UIButton(type: .custom)
    
    // detail views
    fileprivate let webView = WKWebView()
    fileprivate var vtDRefView: VitaminDReferenceView!
    
    // addViews
    override func addView() {
        super.addView()
        
        // scrollView
        backScrollView.showsHorizontalScrollIndicator = false
        backScrollView.isPagingEnabled = true
        backScrollView.isScrollEnabled = false
        view.addSubview(backScrollView)
        
        dosageNavi = Bundle.main.loadNibNamed("VitaminDHowView", owner: self, options: nil)![0] as! VitaminDDosageView
        mainNavi = Bundle.main.loadNibNamed("VitaminDHowView", owner: self, options: nil)![1] as! VitaminDHowMainView
        sourceNavi = Bundle.main.loadNibNamed("VitaminDHowView", owner: self, options: nil)![2] as! VitaminDSourceView
        
        dosageNavi.howView = self
        mainNavi.howView = self
        sourceNavi.howView = self
        
        backScrollView.addSubview(mainNavi)
        backScrollView.addSubview(dosageNavi)
        backScrollView.addSubview(sourceNavi)
        
        // labels
        dosageLabel.text = "Vitamin D Daily Dosage Planner"
        dosageLabel.textAlignment = .center
        dosageLabel.backgroundColor = UIColorFromHex(0xFF9F00)
        
        sourceLabel.text = "Vitamin D Source Planner"
        sourceLabel.textAlignment = .center
        sourceLabel.backgroundColor = UIColorFromHex(0x7ED321)
        
        backScrollView.addSubview(dosageLabel)
        backScrollView.addSubview(sourceLabel)
        
        // dismissButtons
        dismissButton.setBackgroundImage(#imageLiteral(resourceName: "dismissGray"), for: .normal)
        dismissButton.addTarget(self, action: #selector(showNavi), for: .touchUpInside)
        dismissButton.isHidden = true
        view.addSubview(dismissButton)
        
        toMainButton.setBackgroundImage(#imageLiteral(resourceName: "dismissGray"), for: .normal)
        toMainButton.addTarget(self, action: #selector(toMainNavi), for: .touchUpInside)
        view.addSubview(toMainButton)
        
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 345
        
        setupScrollViewWithFrame(remainedFrame.insetBy(dx: 0, dy: one * 5))
        dismissButton.frame = CGRect(x:bounds.width - 30 * one , y: remainedFrame.minY - 31 * one, width: 25 * one, height: 25 * one)
        toMainButton.frame = CGRect(x: bounds.width - 30 * one , y: remainedFrame.minY + 10 * one, width: 25 * one, height: 25 * one)
        webView.frame = CGRect(x: -remainedFrame.width, y: remainedFrame.minY, width: remainedFrame.width, height: remainedFrame.height)
    }
    
    fileprivate func setupScrollViewWithFrame(_ scrollFrame: CGRect) {
        backScrollView.frame = scrollFrame
        backScrollView.contentSize = CGSize(width: scrollFrame.width * 3, height: scrollFrame.height)
        
        let oneSize = CGSize(width: scrollFrame.width * 0.95, height: scrollFrame.height * 0.95)
        // 334 * 503
        let naviSize = getSizeConfinedWithRatio(334/503, confine: oneSize)
        mainNavi.frame = CGRect(center: CGPoint(x: scrollFrame.width * 1.5, y: scrollFrame.height * 0.5), width: naviSize.width, height: naviSize.height)
        
        let fontOne = min(scrollFrame.height / 427, scrollFrame.width / 345)
        let topH = 42 * fontOne
        
        let sideFrame = CGRect(x: 0, y: topH, width: oneSize.width, height: oneSize.height - topH)
        // 310 * 358
        let dosageSize = getSizeConfinedWithRatio(310/358, confine: sideFrame.size)
        dosageNavi.frame = CGRect(center: CGPoint(x: scrollFrame.width * 0.5, y: sideFrame.midY), width: dosageSize.width, height: dosageSize.height)
        
        // 255 * 341
        let sourceSize = getSizeConfinedWithRatio(255/341, confine: sideFrame.size)
        sourceNavi.frame = CGRect(center: CGPoint(x: scrollFrame.width * 2.5, y: sideFrame.midY), width: sourceSize.width, height: sourceSize.height)
        
        let labelOffsetX = topH
        dosageLabel.frame = CGRect(x: 0, y: 0, width: scrollFrame.width, height: topH).insetBy(dx: labelOffsetX, dy: topH * 0.15)
        sourceLabel.frame = CGRect(x: scrollFrame.width * 2, y: 0, width: scrollFrame.width, height: topH).insetBy(dx: labelOffsetX, dy: topH * 0.15)
        
        dosageLabel.font = UIFont.systemFont(ofSize: 14 * fontOne, weight: .semibold)
        sourceLabel.font = UIFont.systemFont(ofSize: 14 * fontOne, weight: .semibold)
        
        // more setup
        dosageNavi.setup()
        mainNavi.setup()
        sourceNavi.setup()
        
        bandForView(dosageLabel)
        bandForView(sourceLabel)
        
        backScrollView.contentOffset = CGPoint(x: frame.width, y: 0)
    }
    
    fileprivate func getSizeConfinedWithRatio(_ whRatio: CGFloat, confine: CGSize) -> CGSize {
        let cWidth = min(confine.width, confine.height * whRatio)
        return CGSize(width: cWidth, height: cWidth / whRatio)
    }
    
    fileprivate func bandForView(_ view: UIView) {
        let viewBounds = view.bounds
        let maskPath = UIBezierPath()
        maskPath.move(to: viewBounds.origin)
        let offset = viewBounds.midY
        maskPath.addLine(to: CGPoint(x: offset, y: viewBounds.midY))
        maskPath.addLine(to: CGPoint(x: viewBounds.minX, y: viewBounds.maxY))
        
        maskPath.addLine(to: CGPoint(x: viewBounds.maxX, y: viewBounds.maxY))
        maskPath.addLine(to: CGPoint(x: viewBounds.maxX - offset, y: viewBounds.midY))
        maskPath.addLine(to: CGPoint(x: viewBounds.maxX, y: viewBounds.minY))
        maskPath.close()
        
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.red.cgColor
        mask.lineWidth = 0
        mask.path = maskPath.cgPath
        view.layer.mask = mask
    }
    
    
    // data actions
    fileprivate var urlStrings = [String]()
    fileprivate var measurement: MeasurementObjModel!
    func setupWithMeasurement(_ measurement: MeasurementObjModel, urlStrings: [String]) {
        let riskKey = measurement.riskKey!
        let subTitle = "Action Planning Accessories"
        setupWithRisk(riskKey, subTitle: subTitle, concertoType: .how)
        
        self.urlStrings = urlStrings
        self.measurement = measurement
        toMainButton.isHidden = true
        
        if urlStrings.count > 2 {
            mainNavi.plannerUrl = urlStrings[urlStrings.count - 2]
        }
    }

    func visitDosage(_ index: Int) {
        if index == 1 {
            if vtDRefView == nil {
                vtDRefView = VitaminDReferenceView(frame: CGRect(x: remainedFrame.minX, y: bounds.height, width: remainedFrame.width, height: remainedFrame.height))
                vtDRefView.setupWithMeasurement(measurement)
                view.addSubview(vtDRefView)
            }
            UIView.animate(withDuration: 0.3) {
                self.vtDRefView.transform = CGAffineTransform(translationX: 0, y: self.remainedFrame.minY - self.vtDRefView.frame.minY)
            }
        }else {
            // web
            showWebWithUrlString(urlStrings.first!, useLeft: true)
        }
        dismissButton.isHidden = false
    }

    func visitDosageQuestion(_ index: Int) {
        showWebWithUrlString(urlStrings[index + 1], useLeft: false)
        dismissButton.isHidden = false
    }
    
    func visitSource(_ index: Int) {
        showWebWithUrlString(urlStrings[index + 3], useLeft: false)
        dismissButton.isHidden = false
    }
    
    func showDosageComparison() {
        // url
        showWebWithUrlString(urlStrings.last!, useLeft: false)
        dismissButton.isHidden = false
    }
    
    fileprivate var spinner: UIActivityIndicatorView!
    fileprivate func showWebWithUrlString(_ urlString: String, useLeft: Bool) {
        if useLeft {
            webView.frame.origin = CGPoint(x: -remainedFrame.width, y: remainedFrame.minY)
        }else {
            webView.frame.origin = CGPoint(x: remainedFrame.width + bounds.width, y: remainedFrame.minY)
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15)
            spinner = StartSpinner(webView)
            spinner.tintColor = tabTintGreen
            
            webView.load(request)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.webView.transform = CGAffineTransform(translationX: self.remainedFrame.midX - self.webView.frame.midX, y: 0)
        }

    }
    
    @objc func showNavi() {
        dismissButton.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.webView.transform = CGAffineTransform.identity
            if self.vtDRefView != nil {
                self.vtDRefView.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc func toMainNavi() {
        toMainButton.isHidden = true
        backScrollView.scrollRectToVisible(CGRect(x: backScrollView.bounds.width, y: 0, width: backScrollView.bounds.width, height: backScrollView.bounds.height), animated: true)
    }
    
    func toDosageView() {
        toMainButton.isHidden = false
        backScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: backScrollView.bounds.width, height: bounds.height), animated: true)
    }
    
    func toSourceView() {
        toMainButton.isHidden = false
        backScrollView.scrollRectToVisible(CGRect(x: backScrollView.bounds.width * 2, y: 0, width: backScrollView.bounds.width, height: backScrollView.bounds.height), animated: true)
    }
}

extension ScorecardVitaminDHowView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        EndSpinner(spinner)
    }
}
