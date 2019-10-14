//
//  IntroInfoDisplayView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/28.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
import WebKit

class IntroInfoDisplayView: UIView, WKNavigationDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate let infoTitleLabel = UILabel()
    fileprivate let webView = WKWebView()
    fileprivate var spinner: LoadingWhirlProcess!
    
    fileprivate let moreArrow = UIImageView(image: UIImage(named: "arrow_left_black"))
    fileprivate let gotItButton = GradientBackStrokeButton(type: .custom)
    fileprivate func addBasic() {
        backgroundColor = UIColor.white
        infoTitleLabel.numberOfLines = 0
        moreArrow.contentMode = .scaleAspectFit
        
        addSubview(infoTitleLabel)
        addSubview(moreArrow)
        
        // web
        webView.layer.masksToBounds = true
        webView.layer.borderColor = UIColorFromHex(0xD6DEE9).cgColor
        webView.navigationDelegate = self
        addSubview(webView)
        // got it
        gotItButton.isHidden = true
        gotItButton.setupWithTitle("Got It")
        gotItButton.addTarget(self, action: #selector(getBack), for: .touchUpInside)
        addSubview(gotItButton)
    }
    
    fileprivate var knowledgeUrl: URL!
    func loadInfoWithMetric(_ metric: MetricObjModel)  {
        var infoTitle = metric.info_title ?? "Introduction to \(metric.name!)"
        if infoTitle.count < 3 {
            infoTitle = "Did You Know?"
        }
        infoTitleLabel.text = infoTitle
        
        knowledgeUrl = metric.knowledgeUrl
        if knowledgeUrl != nil {
            moreArrow.isHidden = false
            let request = URLRequest(url: knowledgeUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            webView.load(request)
            
            if spinner == nil {
                spinner = LoadingWhirlProcess()
                spinner.startLoadingOnView(self, length: 55 * fontFactor)
            }
            
        }else {
            moreArrow.isHidden = true
            // default
            if let comingSoon = URL(string: comingSoonUrl) {
                let request = URLRequest(url: comingSoon, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
                webView.load(request)
            }
        }
    }
    
    var strench = false {
        didSet{
            if strench != oldValue {
                backgroundColor = strench ? UIColorFromHex(0xF8FFF4) : UIColor.white
                moreArrow.isHidden = strench
                infoTitleLabel.isHidden = strench
                gotItButton.isHidden = !strench
                
                setNeedsLayout()
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if spinner != nil {
            spinner.loadingFinished()
            spinner = nil
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if strench {
            // full version
            let bottomH = 55 * fontFactor
            webView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - bottomH)
            gotItButton.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - bottomH * 0.5), width: 163 * fontFactor, height: 44 * fontFactor)
        }else {
            let margin = 8 * fontFactor
            let titleH = 41 * fontFactor
            
            webView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - titleH).insetBy(dx: margin, dy: margin)
            webView.layer.borderWidth = fontFactor
            webView.layer.cornerRadius = 6 * fontFactor
            
            let arrowW = 7 * fontFactor
            infoTitleLabel.frame = CGRect(x: margin, y: webView.frame.maxY + margin, width: webView.frame.width - arrowW, height: titleH)
            infoTitleLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
            moreArrow.frame = CGRect(x: infoTitleLabel.frame.maxX, y: infoTitleLabel.center.y - arrowW * 0.5, width: arrowW, height: arrowW)
        }
        
        if spinner != nil {
            spinner.adjustCenter(webView.center)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if knowledgeUrl == nil {
            return
        }
        
        let point = touches.first!.location(in: self)
        if !strench && point.y >= infoTitleLabel.frame.minY {
            // show detail
            let introDisplay = WebViewDisplayViewController()
            introDisplay.dismissStyle = false
            introDisplay.showGotItButton = true
            introDisplay.showGradientBorder = false
            introDisplay.webIsDismissed = moveBack
            introDisplay.loadWithUrl(knowledgeUrl)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 15 * fontFactor )
            }) { (true) in
                self.viewController.presentOverCurrentViewController(introDisplay, completion: nil)
            }
        }
    }
    
    fileprivate func moveBack()  {
        self.transform = CGAffineTransform.identity
    }
    
    @objc func getBack() {
        navigation.popViewController(animated: true)
    }
}
