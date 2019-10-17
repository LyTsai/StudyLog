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

class ScorecardAlbumViewController: UIViewController, DropdownMenuProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var gameNumberLabels: [UILabel]!
    
    @IBOutlet weak var totalButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var playedButton: UIButton!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    
    @IBOutlet weak var menu: DropdownMenuView!
    @IBOutlet weak var albumTable: ScorecardAlbumTableView!
    
//    var forWhatIf = WHATIF
    var sortRule = AlbumSortRule.gameSubject
    fileprivate let user = PlayerButton.createForNavigationItem()
    
    fileprivate var totalRisks = [String]()
    fileprivate var playedRisks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: user)
        
        // fonts
        titleLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .semibold)
        
        for label in gameNumberLabels {
            label.font = UIFont.systemFont(ofSize: 11 * fontFactor, weight: .regular)
        }
        
        let numberFont = UIFont.systemFont(ofSize: 22 * fontFactor, weight: .regular)
        totalLabel.font = numberFont
        finishedLabel.font = numberFont
        ratioLabel.font = numberFont
        
        showButton.titleLabel?.numberOfLines = 0
        showButton.titleLabel?.font = UIFont.systemFont(ofSize: 10 * fontFactor, weight: .medium)
        showButton.titleLabel?.textAlignment = .center
        showButton.layer.borderColor = UIColorGray(155).cgColor
        showButton.layer.borderWidth = fontFactor * 2
        
        totalRisks = collection.getAllRisks()
        totalLabel.text = "\(totalRisks.count)"

        menu.dropdownProtocol = self
        menu.titles = ["Game Subject", "Game Type", "Date"]
        menu.currentIndex = 0
      
        albumTable.sortRule = sortRule
        albumTable.risks = totalRisks
        
        user.userIsChanged = userIsChanged
        
        totalButton.layer.borderColor = UIColor.black.cgColor
        totalButton.layer.borderWidth = 2 * fontFactor
        
        playedButton.layer.borderColor = UIColor.black.cgColor
        playedButton.layer.borderWidth = 2 * fontFactor
        totalButton.titleLabel?.font = UIFont.systemFont(ofSize: 11 * fontFactor, weight: .regular)
        playedButton.titleLabel?.font = UIFont.systemFont(ofSize: 11 * fontFactor, weight: .regular)
        
        totalButton.backgroundColor = WHATIF ? UIColorFromHex(0x8469FF) : UIColorFromHex(0x00991C)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        totalButton.layer.cornerRadius = totalButton.frame.height * 0.5
        playedButton.layer.cornerRadius = playedButton.frame.height * 0.5
    }
    
    fileprivate func reloadView() {
        getPlayedRisks()
        let playedNumber = playedRisks.count
        finishedLabel.text = "\(playedNumber)"
        let ratio = Float(playedNumber)/Float(totalRisks.count) * 100
        ratioLabel.text = String(format: ratio < 1 ? "%.2f%%" : "%.1f%%", ratio)
        
        albumTable.risks = showAll ? totalRisks : playedRisks
        albumTable.reloadData()
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "AnnielyticX Scorecard Album"
        
        reloadView()
    }
    
    fileprivate func getPlayedRisks() {
        playedRisks.removeAll()
        for riskKey in totalRisks {
            if let measurement = selectionResults.getLastMeasurementOfUser(userCenter.currentGameTargetUser.Key(), riskKey: riskKey, whatIf: WHATIF) {
                let matched = MatchedCardsDisplayModel.getMatchedScoreCardsInMeaurement(measurement)
                if matched.count != 0 {
                    playedRisks.append(riskKey)
                }
            }
        }
    }
    
    fileprivate func userIsChanged() {
        user.setWithCurrentUser()
        let userKey = userCenter.currentGameTargetUser.Key()
        for riskKey in totalRisks {
            selectionResults.getAllLocalMeasurementsForUser(userKey, riskKey: riskKey)
        }
    }
    
    fileprivate var mainColor: UIColor {
        return WHATIF ? UIColorFromHex(0x8469FF) : UIColorFromHex(0x00991C)
    }
    @IBAction func switchBaselineWhatIfState(_ sender: Any) {
        WHATIF = !WHATIF
        showButton.isSelected = WHATIF
        
        if showAll {
            totalButton.backgroundColor = mainColor
        }else {
            playedButton.backgroundColor = mainColor
        }
        
        albumTable.forWhatIf = WHATIF
        reloadView()
    }
    
    fileprivate var showAll = true
    @IBAction func showAll(_ sender: Any) {
        if !showAll {
            showAll = !showAll
            
            totalButton.isSelected = true
            playedButton.isSelected = false
    
            totalButton.backgroundColor = mainColor
            playedButton.backgroundColor = UIColor.white
            
            albumTable.risks = totalRisks
            albumTable.reloadData()
        }
    }
    
   
    @IBAction func showPlayed(_ sender: Any) {
        if showAll {
            showAll = !showAll
            totalButton.isSelected = false
            playedButton.isSelected = true
            
            totalButton.backgroundColor = UIColor.white
            playedButton.backgroundColor = mainColor
            
            getPlayedRisks()
            albumTable.risks = playedRisks
            albumTable.reloadData()
        }
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
