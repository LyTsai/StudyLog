//
//  TabTagsDisplayView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/28.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class TabTagsDisplayView: UIView {
   
    var allTagIsFalling: ((Int)->Void)?
    var tagsAreFalled: (()->Void)?
    var tagViews = [TabTagDiscriptionView]()
    
    fileprivate let road = UIImageView(image: #imageLiteral(resourceName: "tabTagsRoad"))
    fileprivate let netLabel = UILabel()
    func createWithFrame(_ frame: CGRect) {
        self.frame = frame
        self.backgroundColor = UIColor.clear
        
        // title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 70 * fontFactor).insetBy(dx: 40 * fontFactor, dy: 0))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 26 * fontFactor, weight: .medium)
        titleLabel.text = "IAaaS® Games of\nEmpowerment"
        
        // splash
        let splash = UIButton(type: .custom)
        splash.frame = CGRect(x: titleLabel.frame.maxX + 5 * fontFactor, y: titleLabel.frame.midY - 10 * fontFactor, width: 22 * fontFactor, height: 21 * fontFactor)
        splash.setBackgroundImage(#imageLiteral(resourceName: "button_rectMark"), for: .normal)
        splash.addTarget(self, action: #selector(showSplash), for: .touchUpInside)
        addSubview(splash)
        
        // sub
        let subTitleLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 5 * fontFactor, width: bounds.width, height: bounds.height).insetBy(dx: 20 * fontFactor, dy: 0))
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .center
        let subText = "Empowering you to make individualized\nassessments with ease and confidence:\nTelling stories about you and for you.\nHelp U Care; Help Understand; Help U Act"
        let sub = NSAttributedString(string: subText, attributes: [.foregroundColor: UIColorFromHex(0xD1FFA2), .font: UIFont.systemFont(ofSize: 14 * fontFactor)])
        subTitleLabel.attributedText = sub
        subTitleLabel.adjustWithWidthKept()
        
        // road image, roadRatio: 326 * 492
        road.setScaleAspectFrameInConfine(CGRect(x: 0, y: subTitleLabel.frame.maxY - 10 * fontFactor, width: bounds.width, height: bounds.height - subTitleLabel.frame.maxY - 30 * fontFactor).insetBy(dx: 13 * fontFactor, dy: 0), widthHeightRatio: 326 / 492)

        // net label
        netLabel.textAlignment = .center
        netLabel.text = "www.AnnielyticX.com"
        netLabel.textColor = tabTintGreen
        netLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .semibold)
        netLabel.frame = CGRect(x: 0, y: road.frame.maxY, width: bounds.width, height: bounds.height - road.frame.maxY)
        
        // add
        addSubview(road)
        addSubview(subTitleLabel)
        addSubview(titleLabel)
        addSubview(netLabel)
        
        // tagViews
        setupTagViews()
        
        // tapGR
        let showPlateTap = UITapGestureRecognizer(target: self, action: #selector(viewIsTapped))
        addGestureRecognizer(showPlateTap)
    }
    
    @objc func showSplash() {
        let splash = SplashScreenViewController()
        viewController.present(splash, animated: true, completion: nil)
    }
    
    fileprivate func setupTagViews() {
        let texts = ["Game Play - Game Selection\n(individualized assessment)", "Individualized Assessment – Game Assessment and Scoring\n(MVP: Methodology, Value, Process)", "Action Planners\n(Accessories)", "Insightpedia\n(Insight)"]
        let topColors = [UIColorFromHex(0xEAFFC5), UIColorFromHex(0xFFEA99), UIColorFromHex(0xC3FFF4), UIColorFromHex(0x9DE4FF)]
        let bottomColors = [UIColorFromHex(0x7FCB61), dosageColor, UIColorFromHex(0x2ADCDB), UIColorFromHex(0x0056EB)]
        for (i, text) in texts.enumerated() {
            let tagView = TabTagDiscriptionView()
            let image = UIImage(named: "tab_\(i)_selected")
            tagView.setupWithTopColor(topColors[i], bottomColor: bottomColors[i], text: text, image: image)
            tagView.layer.addBlackShadow(8 * fontFactor)
            
            // frame
            let oneLength = road.frame.height / 5.6
            tagView.frame = CGRect(x: 0, y: road.frame.minY + oneLength * CGFloat(i) + oneLength * 0.8, width: bounds.width, height: oneLength * 0.85).insetBy(dx: bounds.width * 13 / 375, dy: 0)
            tagView.layoutSubFrames()
            
            addSubview(tagView)
            tagViews.append(tagView)
        }
    }

    var selectedIndex: Int!
    @objc func viewIsTapped(_ tap: UITapGestureRecognizer) {
        selectedIndex = nil
        let location = tap.location(in: self)
        for (i, tag) in tagViews.enumerated() {
            if tag.frame.contains(location) {
                selectedIndex = i
                break
            }
        }
        
        if selectedIndex == nil {
            return
        }

        tagIsTouched()
    }
    
    func tagIsTouched()  {
        // show detail
        isUserInteractionEnabled = false
        homePageFirstLaunch = false
        
        // animation
        UIView.animate(withDuration: 0.2, animations: {
            for (i, tagView) in self.tagViews.enumerated() {
                var ratio: CGFloat = 0.95
                if i == 2 {
                    ratio = 0.65
                }else if i == 3 {
                    ratio = 0.35
                }
                tagView.prepareForAnimation(ratio, leftFix: (i == 0), moveImage: false)
            }
        }) { (true) in
            // all become balls
            self.road.isHidden = true
            for tagView in self.tagViews {
                tagView.prepared()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                for tagView in self.tagViews {
                    tagView.duringMove()
                }
                UIView.animate(withDuration: 0.4, animations: {
                    for tagView in self.tagViews {
                        tagView.frame.origin.y = self.bounds.height
                    }
                }) { (true) in
                    self.netLabel.isHidden = true
                    // remove tails, show plate
                    UIView.animate(withDuration: 0.3, animations: {
                        for tagView in self.tagViews {
                            tagView.alpha = 0
                        }
                        
                        self.allTagIsFalling?(self.selectedIndex)
                    }, completion: { (true) in
                        self.tagsAreFalled?()
                    })
                }
            })
        }
    }
    
    func resetAll()  {
        selectedIndex = nil
        
        isUserInteractionEnabled = true
        road.isHidden = false
        netLabel.isHidden = false
     
        for tag in tagViews {
            tag.removeFromSuperview()
        }
        tagViews.removeAll()
        setupTagViews()
    }
}
