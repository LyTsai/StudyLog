//
//  ToDoListViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/12.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ToDoListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Act To Change"
    }
    
    
    // new design
    fileprivate var otherViews = [UIView]()
    func setupItems()  {
        // for fit
        let gap = 8 * max(standWP, standHP)
        let margin = 15 * max(standWP, standHP)
        let backWidth = width - 2 * margin
        
        // headerView
        let headerHeight = (backWidth - 2 * margin) * 97 / 319
        let headerView = UIImageView(frame: CGRect(x: 2 * margin, y: gap * 0.6 + topLength, width: (backWidth - 2 * margin) , height: headerHeight))
        headerView.image = UIImage(named: "toDoListHeader")
        view.addSubview(headerView)
        
        // first three
        // 223 * 188, 112 * 188
        // 345 * 83
        let firstWRatio: CGFloat = 223 / 112
        let width1 = (backWidth - gap) / (firstWRatio + 1)
        let width0 = width1 * firstWRatio
        let height0 = width0 * 188 / 223
        
        // 0. see how
        let seeHowView = UIImageView(image: UIImage(named: "See How I am Doing"))
        seeHowView.isUserInteractionEnabled = true
        seeHowView.frame = CGRect(x: margin, y: headerView.frame.maxY + gap, width: width0, height: height0)
        seeHowView.layer.addBlackShadow(4)
        seeHowView.layer.shadowColor = UIColorFromRGB(140, green: 195, blue: 75).cgColor
        view.addSubview(seeHowView)
        
        // 1. tree ring map
        let treeRingMap = UIImageView(image: UIImage(named: "Tree Ring Map"))
        treeRingMap.isUserInteractionEnabled = true
        treeRingMap.frame = CGRect(x: seeHowView.frame.maxX + gap, y: headerView.frame.maxY + gap, width: width1, height: height0)
        treeRingMap.layer.addBlackShadow(3)
        treeRingMap.layer.shadowColor = UIColorFromRGB(245, green: 160, blue: 45).cgColor
        view.addSubview(treeRingMap)
        
        // 2. matched card
        let matchedCards = UIImageView(image: UIImage(named: "Matched Cards"))
        matchedCards.isUserInteractionEnabled = true
        matchedCards.frame = CGRect(x: margin, y: seeHowView.frame.maxY + gap, width: backWidth, height: backWidth * 83 / 345)
        matchedCards.layer.addBlackShadow(4)
        matchedCards.layer.shadowColor = UIColorFromRGB(178, green: 188, blue: 202).cgColor
        view.addSubview(matchedCards)

        // 3. share
        let shareButton = UIButton(type: .custom)
        let buttonHeight = 50 * standHP
        shareButton.frame = CGRect(x: -1, y: height - bottomLength - buttonHeight, width: width + 2, height: buttonHeight)
        shareButton.setImage(UIImage(named: "icon_share_blue"), for: .normal)
        shareButton.setTitle("Sharing", for: .normal)
        shareButton.setTitleColor(UIColorGray(106), for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonHeight * 0.3, weight: UIFontWeightBold)
        shareButton.contentMode = .center
        shareButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        view.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(shareInfo), for: .touchUpInside)
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = UIColorGray(231).cgColor
        
        // 4. others
        let items = ToDoListItem.getCurrentData()
        let othersY = matchedCards.frame.maxY + gap
        let remainedHeight = shareButton.frame.minY - othersY - gap
        let othersSize = CGSize(width: remainedHeight, height: remainedHeight)
        
        for (i, item) in items.enumerated() {
            // if total is zero, will not be called
            let covered = remainedHeight - (backWidth - remainedHeight) / CGFloat(items.count)
            if covered < 0 {
                print("may try to add width")
            }
            
            let todo = ToDoListDetailView.createWithFrame(CGRect(origin: CGPoint(x: margin + CGFloat(i) * (remainedHeight - covered),y: othersY), size: othersSize), item: item, covered: covered)
            todo.layer.cornerRadius = remainedHeight * 0.1
            todo.layer.addBlackShadow(3)
            todo.layer.shadowOpacity = 0.2
            todo.layer.zPosition = CGFloat(i)
            view.addSubview(todo)
            otherViews.append(todo)
        }
        
        // more
        let moreFrame = CGRect(origin: CGPoint(x: backWidth + margin - remainedHeight, y: othersY), size: othersSize)
        let moreView = UIImageView(image: UIImage(named: "item_more"))
        moreView.isUserInteractionEnabled = true
        moreView.frame = moreFrame
        moreView.layer.addBlackShadow(3)
        moreView.layer.shadowOpacity = 0.2
        moreView.layer.zPosition = CGFloat(items.count)
        view.addSubview(moreView)
        otherViews.append(moreView)

        // use gestures
        let tapGR0 = UITapGestureRecognizer(target: self, action: #selector(seeHow))
        seeHowView.addGestureRecognizer(tapGR0)
        
        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(seeTreeRingMap))
        treeRingMap.addGestureRecognizer(tapGR1)
        
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(seeMatchedCards))
        matchedCards.addGestureRecognizer(tapGR2)
        
        // others
        for (i, other) in otherViews.enumerated() {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(performOthers))
            other.tag = 100 + i
            other.addGestureRecognizer(tapGR)
        }
    }
    
    // actions
    // 0
    func seeHow() {
        let seeHowVC = SeeHowViewController()
        navigationController?.pushViewController(seeHowVC, animated: true)
    }
    
    fileprivate func checkLogin() {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // 1
    func seeTreeRingMap() {
        if userCenter.userState != .login {
            let loginVC = LoginViewController()
            loginVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(loginVC, animated: true)
        }else {
            let visualMapVC = Bundle.main.loadNibNamed("VisualMapViewController", owner: self, options: nil)?.first as! VisualMapViewController
            visualMapVC.modalPresentationStyle = .fullScreen
            present(visualMapVC, animated: true, completion: nil)
        }
    }
    
    // 2
    func seeMatchedCards() {
        // check log in, if user touch tab "Act"
        if userCenter.userState != .login {
            checkLogin()
        }else {
            let matchedOverallVC = MatchedCardsViewController()
                
//                MatchedCategoriesRoadViewController() //
            navigationController!.pushViewController(matchedOverallVC, animated: true)
        }
    }
    
    // others
    func performOthers(_ tapGR: UITapGestureRecognizer) {
        let selectedIndex = tapGR.view!.tag - 100

        UIView.animate(withDuration: 0.6, animations: {
            for (i, otherView) in self.otherViews.enumerated() {
                if i == selectedIndex {
                    continue
                }
                
                // transform
                var transform = CATransform3DIdentity
                transform.m34 = -0.006
                transform = CATransform3DRotate(transform, CGFloat(Double.pi) / 6, 0, 1, 0)
                transform = CATransform3DScale(transform, 0.9, 0.9, 1)
                if i > selectedIndex {
                    transform = CATransform3DTranslate(transform, otherView.frame.width * 0.11, 0, 0)
                }
                otherView.layer.transform = transform
            }
        }, completion: { (true) in
            switch selectedIndex {
            case 0: self.doEasy()
            case 1: self.doImpactful()
            case 2: self.establishHabit()
            case 3: self.setDailyReminders()
            default: self.showMore()
            }
            
            // original transform
            for otherView in self.otherViews {
                otherView.layer.transform = CATransform3DIdentity
            }
        })
    }
    
    // others: 0
    func doEasy() {
        let doEasy = DoEasyViewController()
        navigationController?.pushViewController(doEasy, animated: true)
    }
    
    // others: 1
    func doImpactful() {
        let doImpactfulVC = DoImpactfulViewController()
        navigationController?.pushViewController(doImpactfulVC, animated: true)
    }
    
    // others: 2
    func establishHabit() {
        let establishVC = EstablishAHabitViewController()
        navigationController?.pushViewController(establishVC, animated: true)
    }
    
    // others: 3
    func setDailyReminders() {
        let remindersVC = DailyRemindersViewController()
        navigationController?.pushViewController(remindersVC, animated: true)
    }
    
    // others: more
    func showMore() {
        
    }
    
    // 8
    func shareInfo() {
        
    }
    
}
