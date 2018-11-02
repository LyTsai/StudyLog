//
//  ABookLearnViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/9/1.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ABookLearnViewController: UIViewController {
    var urlString: String = "http://106.14.136.77:82/v1.0/index.html"
    
    fileprivate var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.backImage
        view.addSubview(backImageView)
        
        // hide navi
        navigationController?.isNavigationBarHidden = true
        
        // webview
        let webView = UIWebView(frame: view.bounds)
        webView.backgroundColor = UIColor.clear
        view.addSubview(webView)
        
        webView.isHidden = true
        webView.delegate = self

        // status
        let statusBar = UIImageView(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width, height: 20)))
        statusBar.image = UIImage(named: "title")
        view.addSubview(statusBar)
        
        // request
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            // spinner
            spinner = StartSpinner(view)
            spinner.activityIndicatorViewStyle = .whiteLarge
            
            webView.loadRequest(request)
        }
        
        // gesture
        let downSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(showOrHideTabBar))
        downSwipeGR.delegate = self
        downSwipeGR.direction = .down
        view.addGestureRecognizer(downSwipeGR)
        
        let upSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(showOrHideTabBar))
        upSwipeGR.delegate = self
        upSwipeGR.direction = .up
        view.addGestureRecognizer(upSwipeGR)
    }
    
    // tab shows for other view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if timer != nil {
            timer.invalidate()
        }
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // gesture
    fileprivate var timer: Timer!
    func showOrHideTabBar(_ swipeGR: UISwipeGestureRecognizer)  {
        if swipeGR.direction == .down {
            tabBarController?.tabBar.isHidden = false
            
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { (timer) in
                timer.invalidate()
                
                if self.tabBarController?.selectedIndex == 2 {
                    self.tabBarController?.tabBar.isHidden = true
                }else {
                    self.tabBarController?.tabBar.isHidden = false
                }
            })
        }else if swipeGR.direction == .up {
            tabBarController?.tabBar.isHidden = true
        }
    }
}

// MARK: ----------- web view delegate ------------
extension ABookLearnViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        EndSpinner(spinner)
        
        if self.tabBarController?.selectedIndex == 2 {
            self.tabBarController?.tabBar.isHidden = true
        }else {
            self.tabBarController?.tabBar.isHidden = false
        }

        webView.isHidden = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
    }
}

// MARK: ----------- gesture ---------------------
extension ABookLearnViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    
        return true
    }
}
