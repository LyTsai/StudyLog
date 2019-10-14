//
//  WebViewViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/9.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate {
    fileprivate var spinner: LoadingWhirlProcess!
    fileprivate var webView: WKWebView!
    var url: URL! {
        return URL(string: blankUrl)
    }
    
//    fileprivate let assistImageView = UIImageView(image: ProjectImages.sharedImage.landingBack)
    var withTab = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = ProjectImages.sharedImage.landingBack?.cgImage
        
        let webHeight = withTab ? height - bottomLength - (topLength - 44) : height - bottomLength - (topLength - 44) + 49
        webView = WKWebView(frame: CGRect(x: 0, y: topLength - 44, width: width, height: webHeight))
        webView.navigationDelegate = self
        view.addSubview(webView)
        
//        assistImageView.frame = view.bounds
//        view.addSubview(assistImageView)
        
        loadWebData()
        
        if !withTab {
            let dismissButton = UIButton(type: .custom)
            dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
            dismissButton.frame = CGRect(x: width - 50, y: topLength - 42, width: 40, height: 40)
            
            view.addSubview(dismissButton)
        }
    }

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if url != nil && webView != nil {
            if webView.isLoading && spinner == nil {
                spinner = LoadingWhirlProcess()
                spinner.startLoadingOnView(webView, length: 75 * fontFactor)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if spinner != nil {
            spinner.loadingFinished()
            spinner = nil
        }
//        assistImageView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        let catAlert = CatCardAlertViewController()
//        catAlert.addTitle("Error", subTitle: error.localizedDescription, buttonInfo: [("Reload", true, loadWebData)])
//        presentOverCurrentViewController(catAlert, completion: nil)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let urlStr: String=navigationAction.request.url!.absoluteString
        if (urlStr.hasPrefix("js://showWeb")){
            let targetUrlStr: String =  urlStr.components(separatedBy: "?")[1]
            openUrl(urlStr: targetUrlStr)
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func openUrl(urlStr: String){
        let targetUrl:URL?=URL.init(string: urlStr)
        UIApplication.shared.open(targetUrl!, options: [:], completionHandler: nil)
    }

    fileprivate func loadWebData() {
        spinner = LoadingWhirlProcess()
        
        if url != nil {
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
            webView.load(request)
            spinner.startLoadingOnView(webView, length: 75 * fontFactor)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if spinner != nil {
            spinner.loadingFinished()
            spinner = nil
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
