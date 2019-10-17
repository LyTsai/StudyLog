//
//  ScorecardWebView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/26.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
import WebKit
import MapKit

class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler!
    
    init(_ scriptDelegate: WKScriptMessageHandler) {
        self.scriptDelegate = scriptDelegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate.userContentController(userContentController, didReceive: message)
    }
}

class ScorecardWebView: ScorecardConcertoView, WKNavigationDelegate, WKScriptMessageHandler {
    var webView = WKWebView()
    
    fileprivate var spinner: UIActivityIndicatorView!
    override func addView() {
        super.addView()
        
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
     
        messageNames.removeAll()
        
        view.addSubview(webView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        webView.frame = bounds
        spinner.center = webView.center
    }
    
    func setupWithRiskKey(_ riskKey: String, urlString: String, concertoType: ConcertoType) {
        setupWithSubTitle("", concertoType: concertoType)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            webView.load(request)
            spinner = StartSpinner(webView)
            spinner.tintColor = tabTintGreen
        }
    }
    
    
    // MARK: ------------- iOS to JS
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        EndSpinner(spinner)
        webView.allowsBackForwardNavigationGestures = false
        
        if js != nil {
            runJS()
        }
    }
    
    fileprivate var js: String!
    func evaluate(_ js: String) {
        self.js = js
        if !webView.isLoading {
            runJS()
        }
    }
    
    fileprivate func runJS() {
        webView.evaluateJavaScript(js) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: -------------  JS to iOS
    fileprivate var messageNames = Set<String>()
    func handleMethod(_ method: String) {
        messageNames.insert(method)
        webView.configuration.userContentController.add(WeakScriptMessageDelegate(self), name: method)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if (message.body as! String) == "getLocation" {
            getLocation()
        }
    }
    
    // deinit
    fileprivate var locationM: CLLocationManager!
    deinit {
        if locationM != nil {
            locationM.stopUpdatingLocation()
            locationM = nil
        }
        
        for name in messageNames {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
    }
}

// get location
extension ScorecardWebView: CLLocationManagerDelegate {
    func getLocation() {
        if CLLocationManager.locationServicesEnabled() {
        }
        
        let state = CLLocationManager.authorizationStatus()
    
        if locationM == nil {
            locationM = CLLocationManager()
        }
        
        if state != .authorizedAlways || state != .authorizedWhenInUse {
            locationM.requestWhenInUseAuthorization()
        }
        locationM.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let lo = "Latitude: \(String(format: "%.2f", abs(latitude)))°, \(latitude < 0 ? "S" : "N")"
            evaluate("fromAppLocation('\(lo)')")
        }
    }
}


