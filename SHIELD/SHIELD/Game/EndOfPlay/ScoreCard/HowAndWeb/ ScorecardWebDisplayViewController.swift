//
//   ScorecardWebDisplayViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/29.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
import WebKit

class ScorecardWebDisplayViewController: UIViewController, WKNavigationDelegate {
    fileprivate let webView = WKWebView()
    fileprivate var balloon = ScorecardConcertoView()
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // dismiss
        let marginX = 5 * fontFactor
        let dismiss = UIButton(type: .custom)
        dismiss.setBackgroundImage(#imageLiteral(resourceName: "dismiss_white"), for: .normal)
        dismiss.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismiss.frame = CGRect(x: width - marginX - 35, y: topLength - 30 - marginX, width: 30, height: 30)
        view.addSubview(dismiss)
        
        // balloon back
        view.addSubview(balloon)
        balloon.hideCalendar()
        
        // web add
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        balloon.addSubview(webView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        balloon.frame = mainFrame.insetBy(dx: 5 * fontFactor, dy: 0)
        webView.frame = balloon.remainedFrame
    }
    
    func setupWithTitle(_ title: String, subTitle: String, urlString: String!) {
        balloon.title = title
        balloon.setupWithSubTitle(subTitle, concertoType: .how)
        
        // load web
        if urlString == nil {
            return
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
            webView.load(request)
            
            spinner = LoadingWhirlProcess()
        }
    }
    
    fileprivate var loadingTimer: Timer!
    fileprivate var timeInterval: Int = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if spinner != nil {
            spinner.startLoadingOnView(webView, length: 75 * fontFactor)
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true) {
            if self.spinner != nil {
                self.spinner.loadingFinished()
                self.spinner = nil
            }
        }
    }
    
    // delegate
    fileprivate var spinner: LoadingWhirlProcess!
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.spinner != nil {
            spinner.loadingFinished()
            spinner = nil
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        let catAlert = CatCardAlertViewController()
//        catAlert.addTitle("Error", subTitle: error.localizedDescription, buttonInfo: [("Got It", true, dismissVC)])
//        presentOverCurrentViewController(catAlert, completion: nil)
    }
}
