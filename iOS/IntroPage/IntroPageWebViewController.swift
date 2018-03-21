//
//  IntroPageWebViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/25.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IntroPageWebViewController: UIViewController, UIWebViewDelegate {
    var urlString: String = "http://106.14.136.77:82/v1.0/index.html"
    
    fileprivate var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = ProjectImages.sharedImage.backImage?.cgImage
        if urlString == "http://106.14.136.77:82/v1.0/index.html" {
            // hide navi
            navigationController?.isNavigationBarHidden = true
        }
        let webView = UIWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.delegate = self
//        webView.backgroundColor = UIColor.cyan
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            // spinner
            spinner = StartSpinner(view)
            spinner.activityIndicatorViewStyle = .gray
            
            webView.loadRequest(request)
        }
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        EndSpinner(spinner)
        print("finished")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
    }
}
