//
//  ABookActToChangeViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: -------- storyboard ID: ActToChange
class ABookActToChangeViewController: UIViewController {
    
    var table: MetricInfoTableView!
    var collection: MetricInfoCollectionView!
    var selectedMetric = MetricObjModel()
    
    let infoHeight: CGFloat = 50
    var userDisplayView: UserDisplayView!
    
    var currentUserInfo = UserCenter.sharedCenter.loginUserObj.details() {
        didSet {
            // if changed to pseudoUser
            if currentUserInfo !== oldValue {
                userDisplayView.fillUserInfoData(currentUserInfo)
            }
        }
    }
    
    fileprivate var tableOnShow = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Your Health Risk Factors Summary"
        automaticallyAdjustsScrollViewInsets = false
        
        // add views
        addHeader()
        addSummary()
    }
    
    // updateUI
    fileprivate var headerFrame: CGRect {
        return CGRect(x: 0, y: 64, width: width, height: infoHeight)
    }

    // header: user and summary
    fileprivate func addHeader() {
        let imageLength = 0.7 * infoHeight
        
        let totalInfo = UIView(frame: headerFrame)
        totalInfo.backgroundColor = UIColor.white
        
        userDisplayView = UserDisplayView.createWithFrame(CGRect(x: imageLength / 2, y: 0.15 * infoHeight, width: 5 * imageLength, height: imageLength), userInfo: currentUserInfo)
        
        let headerLabel = UILabel(frame: totalInfo.bounds.insetBy(dx: imageLength * 3 / 2, dy: 0))
        headerLabel.text = "Risk Factors"
        headerLabel.textAlignment = .center
        headerLabel.backgroundColor = UIColor.clear
        
        // add
        totalInfo.addSubview(headerLabel)
        totalInfo.addSubview(userDisplayView)
        view.addSubview(totalInfo)
    }
    
    
    // table / collection
    fileprivate func addSummary() {
        let infoFrame = CGRect(x: 0, y: headerFrame.maxY, width: width, height: height - 64 - 49 - infoHeight)
        let summaryView = UIView(frame: infoFrame)
        table = MetricInfoTableView.createTableViewWithFrame(summaryView.bounds)
        collection = MetricInfoCollectionView.createCollectionViewWithFrame(summaryView.bounds, autoCellSize: true, scrollDirection: .vertical)
        table.scrollTableToMetric(selectedMetric.key)
        
        summaryView.addSubview(table)
        view.addSubview(summaryView)
        
        // tap to flip
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipToNext(_:)))
        tapGR.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGR)
    }

    // actions
    func flipToNext(_ tapGR: UITapGestureRecognizer)  {
        let fromView = tableOnShow ? table : collection
        let toView = tableOnShow ? collection : table
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
        collection.scrollCollectionToMetric(selectedMetric.key)
        table.scrollTableToMetric(selectedMetric.key)
        
        tableOnShow = !tableOnShow
    }
}
