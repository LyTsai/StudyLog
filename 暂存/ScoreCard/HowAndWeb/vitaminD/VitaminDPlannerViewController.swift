//
//  VitaminDPlannerViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/5.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation
import WebKit

class VitaminDPlannerViewController: UIViewController, WKNavigationDelegate {
    
    weak var howView: ScorecardVitaminDHowView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet var buttonLabels: [UILabel]!
    fileprivate let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 8 * fontFactor
        backView.layer.masksToBounds = true
        
        // bottom
        for label in buttonLabels {
            label.font =  UIFont.systemFont(ofSize: 16 * fontFactor, weight: .bold)
            label.layer.addBlackShadow(2 * fontFactor)
        }
        
        leftButton.layer.borderWidth = fontFactor
        leftButton.layer.cornerRadius = 8 * fontFactor
        rightButton.layer.borderWidth = fontFactor
        rightButton.layer.cornerRadius = 8 * fontFactor
        
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        
        backView.addSubview(webView)
        
        bottomView.transform = CGAffineTransform(translationX: 0, y: height * 0.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backView.layoutSubviews()
        webView.frame = CGRect(x: 0, y: 0, width: backView.bounds.width, height: backView.bounds.height - bottomView.frame.height)
        
    }
    
    fileprivate var keyString: String!
    func setupWithUrl(_ urlString: String, keyString: String) {
        self.keyString = keyString
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15)
            webView.load(request)
            
            spinner = LoadingWhirlProcess()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if spinner != nil {
            spinner.startLoadingOnView(webView, size: CGSize(width: 55 * fontFactor, height: 55 * fontFactor))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leftButtonTouched(_ sender: Any) {
        if keyString != nil {
            userDefaults.set(true, forKey: keyString)
            userDefaults.synchronize()
        }
        
        goToDosage()
    }
    
    @IBAction func rightButtonTouched(_ sender: Any) {
        goToDosage()
    }
    
    fileprivate func goToDosage() {
        dismiss(animated: true) {
            self.howView.toDosageView()
        }
    }
    
    // delegate
    fileprivate var spinner: LoadingWhirlProcess!
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.loadingFinished()
        spinner = nil
        
        UIView.animate(withDuration: 0.2) {
            self.bottomView.transform = CGAffineTransform.identity
        }
    }
}
