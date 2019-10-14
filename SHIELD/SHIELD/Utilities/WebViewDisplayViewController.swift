//
//  WebViewDisplayViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/25.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
import WebKit

class WebViewDisplayViewController: UIViewController, WKNavigationDelegate {
    var webIsDismissed: (()->Void)?
    
    fileprivate let webView = WKWebView()
    fileprivate let backView = UIView()
    
    var showGradientBorder = true
    var dismissStyle = true
    var showGotItButton = false
    
    var gradientTopColor = UIColorFromHex(0xFFF1B9)
    var gradientBottomColor = UIColorFromHex(0xFFAB00)
    
    fileprivate var gotItButton: GradientBackStrokeButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dismiss
        let marginX = 5 * fontFactor
        let dismiss = UIButton(type: .custom)
        dismiss.setBackgroundImage(dismissStyle ? UIImage(named: "dismiss_white") : UIImage(named: "present_goBack"), for: .normal)
        dismiss.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        let buttonH = 30 * fontFactor
        dismiss.frame = CGRect(x: dismissStyle ? width - marginX - buttonH : marginX, y: topLength - 30 - marginX, width: buttonH, height: buttonH)
        view.addSubview(dismiss)
        
        // back
        var backFrame = mainFrame.insetBy(dx: marginX, dy: 0)
        if showGradientBorder {
            let gradientBack = CAGradientLayer()
            gradientBack.colors = [gradientTopColor.cgColor, gradientBottomColor.cgColor]
            gradientBack.locations = [0.05, 0.95]
            gradientBack.cornerRadius = 8 * fontFactor
            gradientBack.frame = backFrame
            view.layer.addSublayer(gradientBack)
            backFrame = gradientBack.frame.insetBy(dx: marginX, dy: marginX)
            backView.layer.borderColor = gradientBottomColor.cgColor
        }else {
            backView.layer.borderColor = UIColor.white.cgColor
        }
        
        backView.frame = backFrame
        backView.backgroundColor = UIColor.white
        backView.layer.borderWidth = 2 * fontFactor
        backView.layer.cornerRadius = 6 * fontFactor
        backView.layer.masksToBounds = true
        view.addSubview(backView)
        
        // web add
        var webFrame = backView.bounds
        if showGotItButton {
            let bottomHeight = 55 * fontFactor
            gotItButton = GradientBackStrokeButton(type: .custom)
            gotItButton.setupWithTitle("Loading")
            gotItButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            gotItButton.frame = CGRect(center: CGPoint(x: backView.bounds.midX, y: backView.bounds.height - bottomHeight * 0.5), width: 163 * fontFactor, height: 44 * fontFactor)
            backView.addSubview(gotItButton)
           
            webFrame = CGRect(x: 0, y: 0, width: backView.bounds.width, height: backView.bounds.height - bottomHeight)
        }
        webView.frame = webFrame
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        backView.addSubview(webView)
    }
    
    // data loading
    func setupWithUrlString(_ urlString: String!) {
        if urlString != nil {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
                webView.load(request)
                spinner = LoadingWhirlProcess()
            }
        }
    }
    
    func loadWithUrl(_ url: URL?)  {
        if url != nil {
            let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
            webView.load(request)
            spinner = LoadingWhirlProcess()
        }
    }
    
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
            self.webIsDismissed?()
        }
    }

    
    // delegate
    fileprivate var spinner: LoadingWhirlProcess!
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.spinner != nil {
            spinner.loadingFinished()
            spinner = nil
        }
        if gotItButton != nil {
            gotItButton.setupWithTitle("Got It")
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        let catAlert = CatCardAlertViewController()
//        catAlert.addTitle("Error", subTitle: error.localizedDescription, buttonInfo: [("Got It", true, dismissVC)])
//        presentOverCurrentViewController(catAlert, completion: nil)
    }
}
