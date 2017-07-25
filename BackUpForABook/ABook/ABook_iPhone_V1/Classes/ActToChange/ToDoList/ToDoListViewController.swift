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
        automaticallyAdjustsScrollViewInsets = false
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Act To Change"
    }
    
    var todoList = [ToDoListDetailView]()
    
    fileprivate func updateUI() {
        // for fit
        let standardW = width / 375
        let standardH = height / 667
    
        let margin = 7 * standardW
        let backHeight = height - 64 - 49
        let backWidth = width - 2 * margin
        
        // scroll view
        let backScroll = UIScrollView(frame: CGRect(x: margin, y: 64, width: backWidth, height: backHeight))
        backScroll.contentSize = CGSize(width: backWidth, height: backHeight)
        view.addSubview(backScroll)
        
        // headerView
        let headerHeight = (backWidth - 2 * margin) * 118 / 348
        let headerView = UIImageView(frame: CGRect(x: margin, y: 0, width: (backWidth - 2 * margin) , height: headerHeight))
        headerView.image = UIImage(named: "toDoListHeader")
        backScroll.addSubview(headerView)
        
        // list
        let items = ToDoListItem.getCurrentData()
        
        // first row
        let firstWRatio: CGFloat = 243 / 123
        let width1 = backWidth / (firstWRatio + 1)
        let imageSize1 = items[1].image.size
        let height1 = imageSize1.height * width1 / imageSize1.width
        let imageSize0 = items[0].image.size
        let width0 = width1 * firstWRatio
        let height0 = imageSize0.height * width0 / imageSize0.width
        
        let itemView1 = ToDoListDetailView.createWithFrame(CGRect(x: width0, y: headerHeight, width: width1, height: height1), item: items[1])
        let itemView0 = ToDoListDetailView.createWithFrame(CGRect(x: 0, y: itemView1.frame.maxY - height0, width: width0, height: height0), item: items[0])
        itemView0.labelFrame = CGRect(x: width0 * 0.68, y: height0 * 0.2, width: width0 * 0.3, height: height0 * 0.3)
        
        todoList.append(itemView0)
        todoList.append(itemView1)
        
        // match-card
        var height3 = width1
        let leftGap = 4 * standardH
        let leftHeight = backHeight - itemView1.frame.maxY - leftGap
        
        if (leftHeight - 2 * width1) < 0 {
            height3 = leftHeight * 0.5
        }
        
        let vGap = (leftHeight - 2 * height3) * 0.5
        let imageSize3 = items[3].image.size
        let width3 = imageSize3.width * height3 / imageSize3.height
        let itemView3 = ToDoListDetailView.createWithFrame(CGRect(x: backWidth - width3, y: itemView1.frame.maxY, width: width3, height: height3), item: items[3])
        itemView3.labelFrame = CGRect(x: 15, y: height3 * 0.37, width: width3 * 0.5, height: 24)
        
        // first col, 2 and 4
        let width2 = backWidth - width3 - 2 * leftGap
        let imageSize2 = items[2].image.size
        let height2 = min(height3 * 75 / 115, width2 * imageSize2.height / imageSize2.width)
        let itemView2 = ToDoListDetailView.createWithFrame(CGRect(x: leftGap, y: itemView1.frame.maxY, width: width2, height: height2), item: items[2])
        
        let labelFrame24 = CGRect(x: width2 * 0.05, y: height2 * 0.45, width: width2 * 0.6, height: height2 * 0.5)
        itemView2.labelFrame = labelFrame24
        
        todoList.append(itemView2)
        todoList.append(itemView3)
        
        let itemView4 = ToDoListDetailView.createWithFrame(CGRect(x: leftGap, y: itemView2.frame.maxY + leftGap, width: width2, height: height2), item: items[4])
        itemView4.labelFrame = labelFrame24
        todoList.append(itemView4)
        
        // 5 and 6
        let width5 = min(height3, (width3 - leftGap) * 0.5)
        let y5 = itemView3.frame.maxY + vGap
        let itemView5 = ToDoListDetailView.createWithFrame(CGRect(x: itemView3.frame.minX, y: y5, width: width5, height: height3), item: items[5])
        let itemView6 = ToDoListDetailView.createWithFrame(CGRect(x: backWidth - width5, y: y5, width: width5, height: height3), item: items[6])
        
        let labelFrame56 = CGRect(x: width5 * 0.05, y: height3 * 0.55, width: width5 * 0.75, height: height3 * 0.4)
        itemView5.labelFrame = labelFrame56
        itemView6.labelFrame = labelFrame56
        
        todoList.append(itemView5)
        todoList.append(itemView6)


        // 7 and 8
        let height7 = (leftHeight - height2 * 2 - leftGap * 3) * 0.5
        let itemView7 = ToDoListDetailView.createWithFrame(CGRect(x: leftGap, y: itemView4.frame.maxY + leftGap, width: width2, height: height7), item: items[7])
        
        let labelFrame78 = CGRect(x: width2 * 0.05, y: height7 * 0.1, width: width2 * 0.7, height: height7 * 0.9)
        itemView7.labelFrame = labelFrame78
        
        
        let itemView8 = ToDoListDetailView.createWithFrame(CGRect(x: leftGap, y: itemView7.frame.maxY + leftGap, width: width2, height: height7), item: items[8])
        itemView8.labelFrame = labelFrame78
        todoList.append(itemView7)
        todoList.append(itemView8)
        
        // add to scroll
        for (itemView) in todoList{
            backScroll.addSubview(itemView)
        }
        
        // use gestures
        let tapGR0 = UITapGestureRecognizer(target: self, action: #selector(seeHow))
        itemView0.addGestureRecognizer(tapGR0)
        
        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(seeTreeRingMap))
        itemView1.addGestureRecognizer(tapGR1)

        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(setDailyReminders))
        itemView2.addGestureRecognizer(tapGR2)
        
        let tapGR3 = UITapGestureRecognizer(target: self, action: #selector(seeMatchedCards))
        itemView3.addGestureRecognizer(tapGR3)

        let tapGR4 = UITapGestureRecognizer(target: self, action: #selector(establishHabit))
        itemView4.addGestureRecognizer(tapGR4)
        
        let tapGR5 = UITapGestureRecognizer(target: self, action: #selector(doEasy))
        itemView5.addGestureRecognizer(tapGR5)
        
        let tapGR6 = UITapGestureRecognizer(target: self, action: #selector(doImpactful))
        itemView6.addGestureRecognizer(tapGR6)
        
        let tapGR7 = UITapGestureRecognizer(target: self, action: #selector(shareInfo))
        itemView7.addGestureRecognizer(tapGR7)
        
        let tapGR8 = UITapGestureRecognizer(target: self, action: #selector(getOthersInvolved))
        itemView8.addGestureRecognizer(tapGR8)
    }
    
    // actions
    // 0
    func seeHow() {
        let seeHowVC = SeeHowViewController()
        navigationController?.pushViewController(seeHowVC, animated: true)
    }
    
    // 1
    func seeTreeRingMap() {
        if UserCenter.sharedCenter.userState != .login {
            let login = LoginViewController()
            present(login, animated: true, completion: nil)
            return
        }
        
        let allMeasurements = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurementsByCard()
        let measurements = allMeasurements[UserCenter.sharedCenter.loginUserObj.key]?[RiskMetricCardsCursor.sharedCursor.currentFocusingRisk()!]
        
        let vc = ABookTreeRingViewController()
        if measurements != nil {
            vc.showTRMapOfMode_5([measurements!])
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // 2
    func setDailyReminders() {
        let remindersVC = DailyRemindersViewController()
        navigationController?.pushViewController(remindersVC, animated: true)
    }
    
    // 3
    func seeMatchedCards() {
        // check log in, if user touch tab "Act"
        let matchedOverallVC = MatchedCardsViewController()
        navigationController!.pushViewController(matchedOverallVC, animated: true)
    }
    
    // 4
    func establishHabit() {
        let establishVC = EstablishAHabitViewController()
        navigationController?.pushViewController(establishVC, animated: true)
    }
    
    // 5
    func doEasy() {
        let doEasy = DoEasyViewController()
        navigationController?.pushViewController(doEasy, animated: true)
    }
    
    // 6
    func doImpactful() {
        let doImpactfulVC = DoImpactfulViewController()
        navigationController?.pushViewController(doImpactfulVC, animated: true)
    }
    
    // 7
    func shareInfo() {
        
    }
    
    // 8
    func getOthersInvolved() {
        let getInvolved = GetOthersInvolvedViewController()
        navigationController?.pushViewController(getInvolved, animated: true)
        
    }
    
}
