//
//  HomeTypesDescriptionViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/15.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
class HomeTypesDescriptionViewController: UIViewController {
    
    fileprivate var applicationClassAccess: ApplicationClassAccess!
    fileprivate var spinner: UIActivityIndicatorView!
    
    fileprivate var riskTypes: [RiskTypeObjModel] {
        return collection.getAllRiskTypes()
    }
    fileprivate var descriptions = [(title: String, des: NSMutableAttributedString)]()
    func reloadData() {
        descriptions = [("Slow Aging by Design", NSMutableAttributedString())]
        
        let titlePara = NSMutableParagraphStyle()
        titlePara.lineSpacing = 3
        titlePara.paragraphSpacing = 15


        let detaildPara = NSMutableParagraphStyle()
        detaildPara.lineSpacing = 6
        detaildPara.paragraphSpacing = 15
      
        for type in riskTypes {
            if let title = type.name {
                var display = NSMutableAttributedString()
                
                // type.info
                if let _ = type.info {
                    // info.title
                    var des = type.title ?? title
                    des.append("\n")
                    
                    display = NSMutableAttributedString(string: des, attributes: [.foregroundColor: UIColorFromRGB(180, green: 237, blue: 80), .font: UIFont.systemFont(ofSize: 16 * standWP, weight: .bold), .kern: NSNumber(value: -0.3), .paragraphStyle: titlePara])
                    
                    // paragraph
                    var para = ""
                    for ab in type.abstract {
                        para.append("\t\(ab)")
                    }
                    if type.abstract.isEmpty {

                        para = "There is no information for \(title) now 😃. You can check the website for more details."
                    }
                    
                    display.append(NSAttributedString(string: para, attributes: [ .foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14 * standWP), .paragraphStyle: detaildPara]))
                    
                    // image
//                    let attachment = NSTextAttachment()
                    
                }
                
                descriptions.append((title, display))
            }
        }
    }
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        spinner = StartSpinner(view)
        spinner.style = .whiteLarge
        
        // no data
        if  !collection.riskTypeLoadedFromNet {
            if applicationClassAccess == nil {
                applicationClassAccess = ApplicationClassAccess(callback: self)
            }
            
            if let riskTypeKey = ApplicationDataCenter.sharedCenter.riskTypeKey {
                applicationClassAccess.getRiskTypesByKey(riskTypeKey)
            }
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.showDescriptions()
            })
        }
    }
    
    // set up all subviews
    fileprivate let titleScrollView = UIScrollView()
    fileprivate let desScrollView = UIScrollView()
    
    fileprivate let transformView = UIView()
    fileprivate let pageControl = UIPageControl()
    fileprivate let leftButton = UIButton(type: .custom)
    fileprivate let rightButton = UIButton(type: .custom)
    
    fileprivate func showDescriptions() {
        // data source
        reloadData()
        
        // basic UI
        EndSpinner(spinner)
        transformView.frame = view.bounds
        transformView.backgroundColor = UIColor.clear
        view.addSubview(transformView)
        
        // header
        let headerImage = UIImage(named: "riskDes_header")! // 345 * 92
        let xMargin = 15 * standWP
        let mainWidth = width - 2 * xMargin
        let headerImageView = UIImageView(frame: CGRect(x: xMargin, y: 26 * standHP, width: mainWidth, height: headerImage.size.height / headerImage.size.width * mainWidth))
        headerImageView.image = headerImage
        headerImageView.isUserInteractionEnabled = true
        
        // dismiss
        let dismissButton = UIButton(type: .custom)
        let buttonHeight = 26 * standHP
        dismissButton.frame = CGRect(center: CGPoint(x: mainWidth - buttonHeight * 0.9, y: headerImageView.bounds.height * 0.42), length: buttonHeight)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.rectCrossDismiss, for: .normal)
        headerImageView.addSubview(dismissButton)
        
        // titleBar
        // 365 * 53, edgeInsets: 2, 10, 11, 10
        let barImageView = UIImageView(frame: CGRect(x: 5 * standWP - 0.5, y: headerImageView.frame.maxY + 5 * standHP, width: width - 10 * standWP + 1, height: 53 * standHP))
        barImageView.image = UIImage(named: "riskDes_titleBar")
        barImageView.isUserInteractionEnabled = true
        
        // subviews on bar
        let barMainRect = CGRect(x: 10 * standHP, y: 2 * standHP, width: mainWidth, height: 40 * standHP)
        // 30 * 35
        let buttonSize = CGSize(width: 30 * fontFactor, height: 35 * fontFactor)
        // left, last page
        leftButton.setBackgroundImage(UIImage(named: "riskDes_lastPage"), for: .normal)
        leftButton.frame = CGRect(center: CGPoint(x: 30 * standWP, y: barMainRect.midY), width: buttonSize.width, height: buttonSize.height)
        leftButton.addTarget(self, action: #selector(seeLastPage), for: .touchUpInside)
        // right, next page
        rightButton.setBackgroundImage(UIImage(named: "riskDes_nextPage"), for: .normal)
        rightButton.frame = CGRect(center: CGPoint(x: width - 10 * standWP - 30 * standWP, y: barMainRect.midY), width: buttonSize.width, height: buttonSize.height)
        barImageView.addSubview(leftButton)
        barImageView.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(seeNextPage), for: .touchUpInside)
        // middle, title
        let titleFrame = barMainRect.insetBy(dx: 40 * standWP, dy: 0)
        titleScrollView.frame = titleFrame
        titleScrollView.contentSize = CGSize(width: titleFrame.width * CGFloat(descriptions.count), height: titleFrame.width)
        titleScrollView.isScrollEnabled = false
        barImageView.addSubview(titleScrollView)
        
        // mainView
        let mainY = headerImageView.frame.maxY - headerImageView.frame.height * 0.8
        let mainBackView = UIView(frame: CGRect(x: xMargin - 0.5, y: mainY, width: mainWidth + 1, height: height - mainY - 15 * standHP))
        
        // layer
        let mainRadius = 12 * fontFactor
        mainBackView.layer.cornerRadius = mainRadius
        mainBackView.layer.borderColor = UIColorFromRGB(100, green: 221, blue: 23).cgColor
        mainBackView.layer.borderWidth = 1
        mainBackView.layer.shadowColor = UIColorFromRGB(57, green: 255, blue: 0).cgColor
        mainBackView.layer.shadowRadius = 4
        mainBackView.layer.shadowOffset = CGSize(width: 0, height:1)
        mainBackView.layer.shadowOpacity = 0.5
        mainBackView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // links
        let bottomHeight = 51 * standHP
        // line
        let sepLine = UIView(frame: CGRect(x: xMargin, y: mainBackView.frame.maxY - bottomHeight, width: mainWidth, height: 1))
        sepLine.backgroundColor = UIColorFromRGB(126, green: 211, blue: 33).withAlphaComponent(0.5)
        // shade
        let shadeHeight = 15 * standHP
        let shadeLayer = CAShapeLayer()
        shadeLayer.fillColor = UIColorFromRGB(180, green: 237, blue: 80).cgColor
        
        // height is too small for radii
        shadeLayer.path = UIBezierPath(roundedRect: mainBackView.frame, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: mainRadius, height: mainRadius)).cgPath
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: xMargin, y: mainBackView.frame.maxY - shadeHeight, width: mainWidth, height:shadeHeight)
        maskLayer.backgroundColor = UIColor.red.cgColor
        maskLayer.borderWidth = 1
        maskLayer.borderColor = UIColor.clear.cgColor
        shadeLayer.mask = maskLayer
        
        // button
        let linkButton = UIButton(type: .custom)
        linkButton.contentHorizontalAlignment = .left
        linkButton.setImage(UIImage(named: "riskDes_link"), for: .normal)
        linkButton.setTitle("   www.AnnielyticX.com", for: .normal)
        linkButton.setTitleColor(UIColorFromRGB(189, green: 255, blue: 170), for: .normal)
        linkButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 * standHP)
        linkButton.frame = CGRect(x: xMargin * 2.5, y: sepLine.frame.maxY, width: 200 * standWP, height: bottomHeight - shadeHeight - 2)
        
        // descriptions
        pageControl.frame = CGRect(x: xMargin * 2, y: barImageView.frame.maxY + 4 * standHP, width: mainWidth - 2 * xMargin, height: 25 * standHP)
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = descriptions.count
        
        // texts
        let desFrame = CGRect(x: xMargin * 2, y: pageControl.frame.maxY, width: mainWidth - 2 * xMargin, height: sepLine.frame.minY - pageControl.frame.maxY)
        desScrollView.frame = desFrame
        desScrollView.contentSize = CGSize(width: CGFloat(descriptions.count) * desFrame.width, height: desFrame.height)
        desScrollView.isPagingEnabled = true
        desScrollView.showsHorizontalScrollIndicator = false
        desScrollView.delegate = self
        
        // the first one
        let slowAging = NSTextAttachment()
        slowAging.image = #imageLiteral(resourceName: "home_slow")
        slowAging.bounds = CGRect(x: 0, y: 0, width: desFrame.width, height: desFrame.width * 528 / 282)
        let slowAgingAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: slowAging))
        descriptions[0].des = slowAgingAttributedString
        
        // data
        for (i, detail) in descriptions.enumerated() {
            // title
            let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: CGFloat(i) * titleFrame.width, y: 0), size: titleFrame.size))
            titleLabel.text = detail.title
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 20 * standWP, weight: .bold)
            titleScrollView.addSubview(titleLabel)
            
            // textView
            let textView = UITextView(frame: CGRect(origin: CGPoint(x: CGFloat(i) * desFrame.width, y: 0), size: desFrame.size))
            textView.indicatorStyle = .white
            textView.backgroundColor = UIColor.clear
            textView.attributedText = detail.des
            textView.isEditable = false
            desScrollView.addSubview(textView)
        }
        
        // add views
        transformView.addSubview(mainBackView)
        transformView.addSubview(headerImageView)
        transformView.addSubview(barImageView)
        transformView.addSubview(pageControl)
        transformView.addSubview(desScrollView)
        transformView.addSubview(sepLine)
        transformView.layer.addSublayer(shadeLayer)
        transformView.addSubview(linkButton)
    
        // animation
        transformView.alpha = 0.5
        transformView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        UIView.animate(withDuration: 0.45) {
            self.transformView.alpha = 1
            self.transformView.transform = CGAffineTransform.identity
        }
        
        // init index
        currentPageIndex = 0
        leftButton.isHidden = true
        rightButton.isHidden = (currentPageIndex == descriptions.count - 1)
    }
    
    fileprivate var currentPageIndex = 0 {
        didSet{
            if currentPageIndex != oldValue {
                pageControl.currentPage = currentPageIndex
                leftButton.isHidden = (currentPageIndex == 0)
                rightButton.isHidden = (currentPageIndex == descriptions.count - 1)
            }
        }
    }
    @objc func seeNextPage()  {
        currentPageIndex += 1
        scroll()
    }
    
    @objc func seeLastPage()  {
        currentPageIndex -= 1
        scroll()
    }
    
    fileprivate func scroll() {
        // better visaul than "scrollRectTo"
        UIView.animate(withDuration: 0.4) {
            self.titleScrollView.contentOffset.x = CGFloat(self.currentPageIndex) * self.titleScrollView.bounds.width
            self.desScrollView.contentOffset.x = CGFloat(self.currentPageIndex) * self.desScrollView.bounds.width
        }
    }
    
    @objc func dismissVC() {
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseOut, animations: {
            self.transformView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            self.transformView.alpha = 0.5
        }, completion: { (true) in
            self.transformView.alpha = 0
            self.dismiss(animated: true, completion: nil)
        })
    }
}

// delegate for scroll view
extension HomeTypesDescriptionViewController: UIScrollViewDelegate {
    // page enabled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let number = Int(offsetX) / Int(scrollView.bounds.width)
        if number != currentPageIndex {
            currentPageIndex = number
            titleScrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: CGFloat(currentPageIndex) * titleScrollView.bounds.width, y: 0), size: titleScrollView.bounds.size), animated: true)
        }
    }
}

// RiskTypes
extension HomeTypesDescriptionViewController: DataAccessProtocal {
    // riskClasses
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [RiskTypeObjModel] {
            collection.updateRiskTypes(obj as! [RiskTypeObjModel], fromNet: true)
            showDescriptions()
        }else {
            print("type is wrong")
        }
    }
    
    func failedGetAttribute(_ error: String) {
        let errorAlert = UIAlertController(title: "Error!!!", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        errorAlert.addAction(cancelAction)
        present(errorAlert, animated: true, completion: {
            self.showDescriptions()
        })
    }
}
