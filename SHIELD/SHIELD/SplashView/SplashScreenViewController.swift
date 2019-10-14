//
//  SplashScreenViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class SplashScreenViewController: UIViewController, UIScrollViewDelegate {
    fileprivate let slide = UIScrollView()
    fileprivate let pageControl = UIPageControl()
    fileprivate let titleLabel = UILabel()
    fileprivate let tabsDisplay = AppTabsIntroCoverflowView()
    var splashIsHide: (()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back image
        view.backgroundColor = UIColor.white
        // from top down

        // scroll and pageControl
        let top = UIImageView(image: UIImage(named: "splashBack"))
        top.frame = CGRect(x: 0, y: 0, width: width, height: 280 * fontFactor)
        view.addSubview(top)
        
        let logoIcon = UIImageView(image: UIImage(named: "splash_logo"))
        logoIcon.frame = CGRect(x: 12 * fontFactor, y: topLength - 44, width: 62 * fontFactor, height: 61 * fontFactor)
        top.addSubview(logoIcon)
    
        titleLabel.font = UIFont(name: "DIN Condensed", size: 28 * fontFactor)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.frame = CGRect(x: 0, y: topLength - 44, width: width, height: 100 * fontFactor).insetBy(dx: logoIcon.frame.maxX, dy: 0)
        
        view.addSubview(titleLabel)
        setForTitle(0, sub: 0)
        
        // slide
        let bottomH = 44 * fontFactor + bottomLength - 49
        slide.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: width, height: height - titleLabel.frame.maxY - bottomH)
        slide.showsHorizontalScrollIndicator = false
        slide.isPagingEnabled = true
        slide.delegate = self
        slide.contentSize = CGSize(width: 3 * width, height: slide.frame.height)
        view.addSubview(slide)
        
        let displayFrame = slide.bounds.insetBy(dx: 35 * fontFactor, dy: 0)
        // data
//        let topicColor = UIColorFromHex(0x0288D1)
//        let firstPage = NSMutableAttributedString(string: "Lifestyle as Medicine Towards Prevention of Alzheimer’s Disease", attributes: [.font: UIFont.systemFont(ofSize: 18 * fontFactor, weight: .semibold)])
//        firstPage.append(NSAttributedString(string: "\n\nEven for those genetically susceptible to   developing Alzheimer’s dementia, enhanced lifestyle counselling can help to prevent cognitive decline, according to the two-year FINGER trial study published in Jan 2018.\n\n", attributes: [.font: UIFont.systemFont(ofSize: 16 * fontFactor, weight: .light)]))
//        firstPage.append(NSAttributedString(string: "\"Enhanced lifestyle counselling prevents cognitive decline even in people who are carriers of the APOE4 gene, a common risk factor of Alzheimer’s disease, according to a new study published in JAMA Neurology.\"\n\n", attributes: [.font: UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium), .foregroundColor: topicColor]))
//        firstPage.append(NSAttributedString(string: "Reference Source: Source: University of Eastern Finland.\n", attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor)]))
//        firstPage.append(NSAttributedString(string: "http://dx.doi.org/10.1001/jamaneurol.2017.4365", attributes: [.font: UIFont.systemFont(ofSize: 14 * fontFactor), .foregroundColor: topicColor]))
//
        // intro of dr and shield
        let centerPara = NSMutableParagraphStyle()
        centerPara.alignment = .center
        centerPara.lineSpacing = 5 * fontFactor
        
        let introPage = NSMutableAttributedString(string: "Assessment Algorithm and Model:\n\n", attributes: [.font:
        UIFont.systemFont(ofSize: 18 * fontFactor, weight: .medium)])
        let icon = UIImage(named: "icon_drTanzi")
        let iconAttach = NSTextAttachment()
        iconAttach.image = icon
        iconAttach.bounds = CGRect(x: 0, y: 0, width: 219 * fontFactor, height: 94 * fontFactor)
        introPage.append(NSAttributedString(attachment: iconAttach))
        introPage.append(NSAttributedString(string: "\n\nBased on published work of\n", attributes: [.font: UIFont.systemFont(ofSize: 14 * fontFactor, weight: .light)]))
        introPage.append(NSAttributedString(string: "Dr. Rudy Tanzi\n", attributes: [.font: UIFont.systemFont(ofSize: 28 * fontFactor, weight: .bold)]))
        introPage.addAttributes([.paragraphStyle: centerPara], range: NSMakeRange(0, introPage.length))
        
        let normalFont = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .light)
        let focusFont = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        
        let introString = NSMutableAttributedString(string: "\nDr. Rudy Tanzi", attributes: [.font: focusFont])
        introString.append(NSAttributedString(string: ", a renowned brain research scientist and a professor of neurology at Harvard University, had been thinking about an easy way to describe how we can shield our brains from Alzheimer’s disease. This led him to coining a catchy and clever acronym, ", attributes: [.font: normalFont]))
        introString.append(NSAttributedString(string:"\"SHIELD\"", attributes: [.font: focusFont]))
        introString.append(NSAttributedString(string: ", to promote the primary action steps people can take in their daily lives to keep the brain healthy. Funny enough, he came up with this acronym while taking his shower one day. Although it was only a myth that the ancient Greek polymath Archimedes coined the term \"Eureka!\" in the bath, Dr. Tanzi indeed invented the SHIELD acronym in the shower. Now you know.\n", attributes: [.font: normalFont]))
        introPage.append(introString)
        
        let introView = UITextView(frame: displayFrame)
        introView.backgroundColor = UIColor.clear
        introView.attributedText = introPage
        slide.addSubview(introView)
        
        // tab
        tabsDisplay.frame = CGRect(x: slide.frame.width + displayFrame.minX, y: displayFrame.minY, width: displayFrame.width, height: displayFrame.height)
        tabsDisplay.blockIsTouched = { (index) in
            self.subIndex = index
            self.setForTitle(1, sub: index)
            self.endTimer()
        }
        tabsDisplay.addBlocks()
        slide.addSubview(tabsDisplay)
        
        // shield
        let buttonH = 44 * fontFactor
        let detailFrame = CGRect(x: slide.frame.width * 2 + displayFrame.minX, y: displayFrame.minY, width: displayFrame.width, height: displayFrame.height - buttonH * 1.5)
        let shieldDetail = UIImageView(image: UIImage(named: "shield_detail"))
        shieldDetail.contentMode = .scaleAspectFit
        shieldDetail.frame = detailFrame
        slide.addSubview(shieldDetail)
        
        let startButton = UIButton(type: .custom)
        startButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        startButton.backgroundColor = UIColorFromHex(0x7ED321)
        startButton.setTitle("Get Started", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        let buttonW = 195 * fontFactor
        startButton.frame = CGRect(x: shieldDetail.frame.midX - 0.5 * buttonW, y: slide.frame.height - buttonH, width: buttonW, height: buttonH)
        startButton.layer.cornerRadius = 4 * fontFactor

        slide.addSubview(startButton)
        
        // page
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.setValue(UIImage(named: "pageControl_current"), forKey: "currentPageImage")
        pageControl.setValue(UIImage(named: "pageControl_other"), forKey: "pageImage")
        pageControl.addTarget(self, action: #selector(dotClicked), for: .valueChanged)
    
        pageControl.frame = CGRect(center: CGPoint(x: width * 0.5, y: 22 * fontFactor + slide.frame.maxY), width: 80 * fontFactor, height: 10 * fontFactor)
        view.addSubview(pageControl)
        
//        slide.isScrollEnabled = false
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(viewIsSwipped))
//        swipeLeft.direction = .left
//        self.view.addGestureRecognizer(swipeLeft)
//
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(viewIsSwipped))
//        swipeRight.direction = .right
//        self.view.addGestureRecognizer(swipeRight)
    }
    
    fileprivate func setForTitle(_ current: Int, sub: Int) {
        let titles = ["The Genesis of\nAlzheimer’s SHIELD", "SHIELD", "SHIELD\nYour Brain Against Alzheimer’s"]
        var title = titles[current]
        if current == 1 {
            var subTitles = [" Score", " Author\'s Forum", " Action Planning", " Curated Insight"]
            title.append(subTitles[sub])
        }
        titleLabel.text = title
    }
    
    
    @objc func dismissVC() {
//        userDefaults.set(true, forKey: splashNeverShowKey)
        splashIsHide?()
    }
    
//    @objc func viewIsSwipped(_ swipeGR: UISwipeGestureRecognizer) {
//        let current = pageControl.currentPage
//        var next = current + 1
//        if swipeGR.direction == .right {
//            next = current - 1
//        }
//
//        endTimer()
//
//        if next != -1 && next < 3 {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.slide.contentOffset.x = width * CGFloat(next)
//            }, completion: { (true) in
//                self.pageControl.currentPage = next
//
//                self.setForTitle(self.pageControl.currentPage, sub: self.subIndex)
//            })
//        }
//    }
    
    // add and set up
    @objc func dotClicked()  {
        UIView.animate(withDuration: 0.5) {
            self.slide.contentOffset.x = width * CGFloat(self.pageControl.currentPage)
//            self.endTimer()
        }
    }
    
    fileprivate var timer: Timer!
    fileprivate var subIndex = 0
//    func startTimer()  {
//        var goRight = true
//        var jump = true
//        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
//            let current = self.pageControl.currentPage
//            jump = true
//
//            // direction
//            if current == 2 {
//                goRight = false
//            }else if current == 0 {
//                goRight = true
//            }
//
//            // next
//            if current == 1 {
//                if self.subIndex == 3 {
//                    self.subIndex = 0
//                    jump = true
//                }else {
//                    jump = false
//                    self.subIndex += 1
//                }
//                self.tabsDisplay.focusOnBlock(self.subIndex)
//            }
//
//            if jump {
//                let next = goRight ? current + 1 : current - 1
//                UIView.animate(withDuration: 1, animations: {
//                    self.slide.contentOffset.x = width * CGFloat(next)
//                }, completion: { (true) in
//                    self.pageControl.currentPage = next
//
//                    self.setForTitle(self.pageControl.currentPage, sub: self.subIndex)
//                })
//            }
//        }
//    }
    func startTimer()  {
        if timer != nil {
            print("not stopped correctly")
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            // next
            if self.subIndex == 3 {
                self.subIndex = 0
            }else {
                self.subIndex += 1
            }
            
            self.tabsDisplay.focusOnBlock(self.subIndex)
        }
    }
    
    fileprivate func endTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    // delegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetX = scrollView.contentOffset.x
//        let number = Int(offsetX / width)
//
//        pageControl.currentPage = number
//        self.setForTitle(self.pageControl.currentPage, sub: subIndex)
//
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let number = Int(offsetX / width)
        
        pageControl.currentPage = number
        self.setForTitle(self.pageControl.currentPage, sub: subIndex)
        
        if number == 1 {
            startTimer()
        }else {
            endTimer()
        }
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        endTimer()
//    }
    
    
    // status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
