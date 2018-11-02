//
//  ScorecardAlbumViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/7.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
enum AlbumSortRule {
    case date
    case gameSubject
    case gameType
}

//enum AlbumPlayState {
//    case all
//    case played
//    case unplayed
//}

class ScorecardAlbumViewController: UIViewController, DropdownMenuProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var gameNumberLabels: [UILabel]!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    
    @IBOutlet weak var menu: DropdownMenuView!
    @IBOutlet weak var albumTable: ScorecardAlbumTableView!
    
    var sortRule = AlbumSortRule.gameSubject
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "AnnielyticX Scorecard Album"
        
        // fonts
        titleLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: UIFontWeightSemibold)
        
        for label in gameNumberLabels {
            label.font = UIFont.systemFont(ofSize: 11 * fontFactor, weight: UIFontWeightRegular)
        }
        
        let numberFont = UIFont.systemFont(ofSize: 22 * fontFactor, weight: UIFontWeightRegular)
        totalLabel.font = numberFont
        finishedLabel.font = numberFont
        ratioLabel.font = numberFont
        
        let totalRisks = collection.getAllRisks()
        totalLabel.text = "\(totalRisks.count)"
        var playedNumber = 0
        for key in totalRisks {
            let total = collection.getSortedCardsForRiskKey(key, containBonus: false).count
            if total != 0 {
//                // data loaded
                let matched = MatchedCardsDisplayModel.getMatchedCardsOfRisk(key, forUser: userCenter.currentGameTargetUser.Key(), containBonus: false).count
                if matched != 0 {
                    playedNumber += 1
                }
            }
        }
        finishedLabel.text = "\(playedNumber)"
        let ratio = Float(playedNumber)/Float(totalRisks.count) * 100
        ratioLabel.text = String(format: ratio < 1 ? "%.2f%%" : "%.1f%%", ratio)
        
        menu.dropdownProtocol = self
        menu.titles = ["Game Subject", "Game Type", "Date"]
        menu.currentIndex = 0
      
        albumTable.sortRule = sortRule
        albumTable.risks = totalRisks
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // after play...
        albumTable.reloadData()
    }
    
    // protocol
    fileprivate var currentIndex = 0
    func dropdownMenu(_ menu: DropdownMenuView, didSelectIndex index: Int) {
        if index == currentIndex {
            return
        }
        currentIndex = index
        switch index {
        case 0: sortRule = .gameSubject
        case 1: sortRule = .gameType
        case 2: sortRule = .date
        default: break
        }
        
        albumTable.sortRule = sortRule
    }
    
    func reverseRankOfDropdownMenu(_ menu: DropdownMenuView) {
        albumTable.reverse = !albumTable.reverse
    }
}


