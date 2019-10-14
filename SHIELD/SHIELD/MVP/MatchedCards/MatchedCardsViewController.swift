//
//  MatchedCardsViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/24.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardsViewController: UIViewController {
    enum MatchedCardsDisplayState {
        case overall, onTopic
    }
    
    
    fileprivate let user = PlayerButton.createForNavigationItem()
    fileprivate let backButterfly = UIImageView(image: #imageLiteral(resourceName: "butterfly_circle"))
    fileprivate var timer: Timer!
    fileprivate let dotView = UIView()
    fileprivate var displayState = MatchedCardsDisplayState.overall
    
    fileprivate var userkey: String {
        return userCenter.currentGameTargetUser.Key()
    }
    
    fileprivate var avatar: PlayerButton!
    fileprivate var topics = [UIButton]()
    fileprivate var topicTags = [TagLabel]()
    
    fileprivate var matched: MatchedCardsReviewCollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createBackButton())
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: user)
        
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.backImage
        view.addSubview(backImageView)
        
        // overall
        let viewCenter = CGPoint(x: mainFrame.midX, y: mainFrame.midY)
        backButterfly.frame = CGRect(center: viewCenter, length: 265 * standWP)
        view.addSubview(backButterfly)
        
        // dot
        dotView.backgroundColor = UIColorFromRGB(178, green: 255, blue: 89)
        let dotL = 10 * fontFactor
        dotView.frame.size = CGSize(width: dotL, height: dotL)
        dotView.layer.cornerRadius = dotL * 0.5
        view.addSubview(dotView)
        
        // avatar
        avatar = PlayerButton.createAsNormalView(CGRect(center: viewCenter, width: 75 * standWP, height: 69 * standWP))
        view.addSubview(avatar)
        
        // topics
        for i  in 0..<3 {
            // ia by ...
            let topic = UIButton(type: .custom)
            topic.setBackgroundImage(UIImage(named: "act_\(i)"), for: .normal)
            topic.frame = CGRect(center: viewCenter, width: 101 * standWP, height: 105 * standWP)
            topic.tag = 100 + i
            topic.addTarget(self, action: #selector(focusOnTopic), for: .touchUpInside)
            topics.append(topic)
            view.addSubview(topic)
            
            // tags
            let tag = TagLabel.createTag()
            tag.frame = CGRect(center: viewCenter, width: 55 * standWP, height: 25 * standWP)
            view.addSubview(tag)
            topicTags.append(tag)
        }
        
        matched = MatchedCardsReviewCollectionView.createWithFrame(mainFrame)
        view.addSubview(matched)
    }
    
    override func backButtonClicked() {
        switch displayState {
        case .overall: navigationController?.popViewController(animated: true)
        case .onTopic: setToOverallState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Matched Cards"
        user.setWithCurrentUser()
        
        self.setToOverallState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopDotTimer()
    }
    
    
    fileprivate func stopDotTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    
    fileprivate var angle: CGFloat = 0
    fileprivate func setToOverallState() {
        displayState = .overall
        navigationItem.title = "Matched Cards"
        
        matched.isHidden = true
        if topicCopy != nil {
            topicCopy.removeFromSuperview()
            topicCopy = nil
        }
        
        chosenTopic = nil
        hideOverallViews(false)
        
        let radius = backButterfly.bounds.width * 0.5
        let viewCenter = backButterfly.center
        dotView.center = Calculation.getPositionByAngle(self.angle, radius: radius, origin: viewCenter)
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { (timer) in
                self.dotView.center = Calculation.getPositionByAngle(self.angle, radius: radius, origin: viewCenter)
                self.angle += 0.018
                
                if self.angle > 2 * CGFloat(Double.pi) {
                    self.angle -= 2 * CGFloat(Double.pi)
                }
            })
        }
        
        UIView.animate(withDuration: 0.15, animations: {
            Calculation.placeNodes(self.topics, center: viewCenter, radius: radius, startAngle: -0.5 * CGFloatPi)
        }) { (true) in
            // labels
            for (i, tag) in self.topicTags.enumerated() {
                let topicCenter = self.topics[i].center
                tag.center = CGPoint(x: topicCenter.x, y: topicCenter.y + 20 * standWP)
                let played = MatchedCardsDisplayModel.checkPlayStateOfTier(i)
                played ? tag.setToCheckTag() : tag.setToNone()
            }
        }
    }
    
    fileprivate var topicCopy: UIButton!
    fileprivate var chosenTopic: Int!
    @objc func focusOnTopic(_ button: UIButton) {
        displayState = .onTopic
        
        for tag in topicTags {
            tag.setToNone()
        }

        // topicCopy
        topicCopy = UIButton(type: .custom)
        topicCopy.frame = button.frame
        topicCopy.setBackgroundImage(button.backgroundImage(for: .normal), for: .normal)
        topicCopy.addTarget(self, action: #selector(backToOverallState), for: .touchUpInside)
        matched.addSubview(topicCopy)
        
        // chosen
        chosenTopic = button.tag - 100
        if chosenTopic == 0 {
            navigationItem.title = "IA by Comparision"
        }else if chosenTopic == 1 {
            navigationItem.title = "IA by Prediction"
        }else {
            navigationItem.title = "IA by Stratification"
        }
        
        let topicPoint = CGPoint(x: 62 * standWP, y: 40 * standHP)
        matched.loadDataWithTopic(chosenTopic, topicPoint: topicPoint)
        matched.isHidden = false
        button.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            for topic in self.topics {
                if topic.tag != button.tag {
                    topic.center = self.backButterfly.center
                }
            }
            self.topicCopy.center = topicPoint
            let scale: CGFloat = 0.7 * (standHP / standWP)
            self.topicCopy.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { (true) in
            self.hideOverallViews(true)
            self.stopDotTimer()
            // show road
            self.matched.showRoad = true
        }
    }
    
    fileprivate func hideOverallViews(_ hide: Bool) {
        avatar.isHidden = hide
        backButterfly.isHidden = hide
        for topic in topics {
            topic.isHidden = hide
        }
        
        dotView.isHidden = hide
    }
    
    @objc func backToOverallState() {
        self.matched.showRoad = false
        UIView.animate(withDuration: 0.2, animations: {
            self.topicCopy.transform = CGAffineTransform.identity
            self.topicCopy.center = self.backButterfly.center
        }) { (true) in
            self.setToOverallState()
        }
    }
}
