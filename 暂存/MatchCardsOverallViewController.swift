//
//  MatchCardsOverallViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardsOverallViewController: UIViewController {

    var lastRiskKey: String!
    var lastGame: RiskObjModel!
    var gamesPlayed = [RiskObjModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        automaticallyAdjustsScrollViewInsets = false
        
        // data set up
        if checkPlayedGames() {
            showCardsOnView()
        } else{
            let addView = ViewForAdd.createWithFrame(CGRect(x: 0, y: 64, width: width, height: height - 64 - 49).insetBy(dx: width * 0.15, dy: height * 0.15), topImage: UIImage(named: "icon_search"), title: "No Game Played", prompt: "please go to assessment")
            addView.personImageView.image = UIImage(named: "icon_assess")
            view.addSubview(addView)
        }
    }
    
    // data Source
    fileprivate func checkPlayedGames() -> Bool {
        let currentPlayer = UserCenter.sharedCenter.currentGameTargetUser
        gamesPlayed = MatchedCardsData.getAllRisksPlayedOfUser(currentPlayer.Key())
        
        if gamesPlayed.count == 0 {
            return false
        }
        
        let lastRiskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey
        lastGame = AIDMetricCardsCollection.standardCollection.getRisk(lastRiskKey)
        
        if lastGame == nil {
            // TODO: ------- get the real last game by date
            lastGame = gamesPlayed.first
        }
        
        // remove the last game, show on top
        for (i, game) in gamesPlayed.enumerated() {
            if game.key == lastGame.key {
                gamesPlayed.remove(at: i)
                break
            }
        }
        
        return true
    }
    
    fileprivate var played: MatchedCardsOverallCollectoinView!
    fileprivate func showCardsOnView()  {
        // remove other views
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        // last
        let lastHeight = 214 * height / 667
        let playNewHeight = 64 * height / 667
        let lastGameFrame = CGRect(x: 0, y: 64, width: width, height: lastHeight)
        
        let lastGameView = LastGameView.createWithFrame(lastGameFrame, risk: lastGame)
        lastGameView.hostVC = self
        view.addSubview(lastGameView)
        
        let lineView = UIView(frame: CGRect(x: 5, y: lastGameFrame.maxY + 1, width: width - 10, height: 0.5))
        lineView.backgroundColor = UIColorGray(151)
        view.addSubview(lineView)
        
        // played
        played = MatchedCardsOverallCollectoinView.createWithFrame(CGRect(x: 0, y: lineView.frame.maxY, width: width, height: height - lineView.frame.maxY - 49 - 0.4 * playNewHeight), playedGames: gamesPlayed)
        played.hostVC = self
        view.addSubview(played)
        
        // play new
        let playNewView = UIView(frame: CGRect(x: 0, y: height - 49 - playNewHeight, width: width, height: playNewHeight))
        playNewView.backgroundColor = UIColor.clear
        view.addSubview(playNewView)
        
        let playNewImage = UIImage(named: "playNew")
        let imageWidth = playNewHeight * 108 / 57
        
        let playNewImageView = UIImageView(frame: CGRect(x: width - imageWidth, y: 0, width: imageWidth, height: playNewHeight))
        playNewImageView.contentMode = .scaleAspectFit
        playNewImageView.image = playNewImage
        playNewView.addSubview(playNewImageView)
        
        let tapToNewGR = UITapGestureRecognizer(target: self, action: #selector(playNew))
        playNewImageView.isUserInteractionEnabled = true
        playNewImageView.addGestureRecognizer(tapToNewGR)
    }
    // action
    func playNew() {
        let landingVC = ABookLandingPageViewController()
        navigationController?.pushViewController(landingVC, animated: true)
    }
    
    func goToSelectedMatchedCards(_ risk: RiskObjModel) {
        let matchedVC = MatchedCardsViewController()
        matchedVC.risk = risk
        navigationController?.pushViewController(matchedVC, animated: true)
    }
    
    // MARK: ------ view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Matched Cards"
        if played != nil {
            played.isEditing = false
        }
    }
}

