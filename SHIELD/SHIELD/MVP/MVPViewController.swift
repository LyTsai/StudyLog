//
//  MVPViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/24.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
enum MVPViewType: String {
    case myAssessments       = "My Assessments"
    case myMatches           = "My Matches"
    case historyExplorer     = "History Explorer"
    case scorecardAlbum      = "Scorecard Album"
    case scorecardExplorer   = "Scorecard Explorer"
    case patternsExplorer    = "Pattern Explorer"
}

class MVPViewController: UIViewController {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var coView: UIView!
    fileprivate let playerButton = PlayerButton.createForNavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: playerButton)
        playerButton.naviViewNavigation = navigationController
        WHATIF = false
        
        let topString = NSMutableAttributedString(string: "IAaaS®\n", attributes: [.font : UIFont.systemFont(ofSize: 24 * fontFactor, weight: .semibold), .foregroundColor: UIColor.white])
        topString.append(NSAttributedString(string: "Individualized Assessment as a Service\n", attributes: [.font : UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium), .foregroundColor: UIColor.white]))
        topString.append(NSAttributedString(string: "To Tell Stories About You, and For You, to Help You Make Informed Decisions.", attributes: [ .font : UIFont.systemFont(ofSize: 14 * fontFactor), .foregroundColor: UIColorFromHex(0xD1FF9B)]))
        topLabel.attributedText = topString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Play, Score, Discover Cycle"
        playerButton.setWithCurrentUser()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if loading != nil {
            loading.loadingFinished()
            loading = nil
        }
    }
    
    // actions
    fileprivate var mvpType = MVPViewType.myAssessments
    @IBAction func showActView(_ sender: UIButton) {
        let typeArray: [MVPViewType] = [.myAssessments, .myMatches, .scorecardAlbum, .scorecardExplorer, .patternsExplorer, .historyExplorer]
        mvpType = typeArray[sender.tag - 100]

        // others
        if userCenter.userState != .login {
            let loginVC = LoginViewController.createFromNib()
            loginVC.hidesBottomBarWhenPushed = true
            loginVC.invokeFinishedClosure = loadDataAndView
            navigationController?.pushViewController(loginVC, animated: true)
        }else {
            loadDataAndView()
        }
    }
    
    fileprivate func loadDataAndView() {
        playerButton.setWithCurrentUser()
        let keyString = "neverShowForActType\(mvpType.rawValue)"
        if userDefaults.bool(forKey: keyString) {
            self.showNextView()
        }else {
            // show about
            let aboutPage = AboutPageViewController.usedForType(self.mvpType, keyString: keyString)
            aboutPage.goToNextViewController = self.showNextView
            self.presentOverCurrentViewController(aboutPage, completion: nil)
        }
    }

    fileprivate var loading: LoadingWhirlProcess!
    fileprivate func showNextView() {
        switch mvpType {
        case .myAssessments:
            let seeHowVC = AssessmentsViewController()
            navigationController?.pushViewController(seeHowVC, animated: true)
        case .myMatches:
            let matchedOverallVC = MatchedCardsViewController()
            navigationController?.pushViewController(matchedOverallVC, animated: true)
        case .historyExplorer:
            let timeMap = Bundle.main.loadNibNamed("HistoryMapViewController", owner: self, options: nil)?.first as! HistoryMapViewController
            navigationController?.pushViewController(timeMap, animated: true)
        case .scorecardAlbum:
            let album = Bundle.main.loadNibNamed("ScorecardAlbumViewController", owner: self, options: nil)?.first as! ScorecardAlbumViewController
            navigationController?.pushViewController(album, animated: true)
        case .scorecardExplorer:
            let explorer = ScorecardExplorerViewController()
            navigationController?.pushViewController(explorer, animated: true)
        case .patternsExplorer:
            // load all record of measurement
            loading = LoadingWhirlProcess()
            mainImageView.alpha = 0.6
            let sizeL = mainImageView.bounds.width * 0.35
            loading.startLoadingOnView(coView, length: sizeL)
            view.isUserInteractionEnabled = false
            DispatchQueue.global().async {
                for riskKey in collection.getAllRisks() {
                    for userKey in userCenter.pseudoUserKeys {
                        selectionResults.getAllLocalMeasurementsForUser(userKey, riskKey: riskKey)
                    }
                }
                
                // update
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    self.mainImageView.alpha = 1
                    self.loading.loadingFinished()
                    self.loading = nil
                    
                    let treeRingMap = TreeRingMapViewController()
                    treeRingMap.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(treeRingMap, animated: true)
                })
            }
        }
    }
}
