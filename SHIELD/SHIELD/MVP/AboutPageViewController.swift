//
//  AboutPageViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/8/7.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class AboutPageViewController: UIViewController {
    var goToNextViewController: (()->())!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleDecoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var leftButton: GradientBackStrokeButton!
    @IBOutlet weak var rightButton: GradientBackStrokeButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalTransitionStyle = .crossDissolve
        
        titleLabel.font = UIFont.systemFont(ofSize: 24 * fontFactor, weight: .bold)
        titleDecoLabel.font = titleLabel.font
        
        leftButton.setupWithTitle("Never Show")
        leftButton.isSelected = false
        rightButton.setupWithTitle("Got It!")
        
        backView.layer.cornerRadius = 8 * fontFactor
        backView.layer.masksToBounds = true
    }
    
    class func usedForType(_ mvpType: MVPViewType, keyString: String) -> AboutPageViewController {
        let aboutPage = Bundle.main.loadNibNamed("AboutPageViewController", owner: self, options: nil)?.first as! AboutPageViewController
        aboutPage.setupForType(mvpType, keyString: keyString)
        
        return aboutPage
    }
    fileprivate var keyString = ""
    fileprivate func setupForType(_ mvpType: MVPViewType, keyString: String) {
        self.keyString = keyString
        
        let font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .light)
        var textString = "The Scorecard Explorer is an interactive collection of a player’s most recent Scorecard Concertos for all the completed games. It allows a player to browse and explore her most recent collection of Scorecard Concertos, quickly, easily, and at any time.  Upon completion of a game, AnnielyticX creates a Scorecard Concerto for the player. It tells the individualized story of how the player scores for this game, in three parts: What’s the score; why this score; and how to improve the score. In addition, it also includes curated Insight and action planning accessories.  Think of a Scorecard Concerto as a digital video of a player’s Scorecard for a completed game."
        var mainColor = UIColor.cyan
        switch mvpType {
        case .myAssessments:
            mainColor = UIColorFromHex(0x0288D1)
            textString = "“My Assessments” is the deck of cards for a game where each playing card has been assessed based on the choice you selected when you played that game. Sometimes, second opinion matters especially when the scoring assessment is not always purely objective. Currently, AnnielyticX provides “out-of-the-box” assessment adjudication for each game. In the future, AnnielyticX plans to offer alternative assessment adjudicator(s) from established domain experts for the games."
        case .myMatches:
            mainColor = UIColorFromHex(0x0288D1)
            textString = "“My Matches” is the deck of cards for a game where each playing card is the choice you selected when you played that game. This deck of cards doesn’t have any assessment adjudication and can be viewed as a snapshot of your baseline profile.  This deck of cards will be at your disposal so you can choose to seek alternative assessment adjudication from your healthcare provider(s) and/or share with others."
        case .scorecardAlbum:
            mainColor = UIColorFromHex(0x4ED8B9)
            textString = "Upon completion of a game, an AnnielyticX scorecard is created as a digital playing card much like a digital photo. The collection of scorecards is stored and organized as a digital “Scorecard Album”. A player can quickly and easily browse the Scorecard Album to review, print, and share historical or current scorecards - by game subjects and game types."
        case .scorecardExplorer:
            textString = "your collection of individualized Scorecard Concertos for all games you have completed:  each completed game comes with a Scorecard Concerto. Think of each Scorecard Summary as a digital photo while each Scorecard Concerto as a digital video. The former gives you a snapshot of the overall score while the latter tells a detailed story of your scoring – what’s your score; why this score; and how to improve this score."
        case .historyExplorer:
            textString = "Trend analysis looks at the overall ongoing characterization of your biological aging over time:  studying different characteristics and what may be influencing them. Detecting anomalies can help you take proactive actions and avoid preventable malaise."
        case .patternsExplorer:
            textString = "If a visual (picture) is worth a thousand words, a pattern is worth a thousand visuals (pictures). The Pattern Explorer helps you discover valuable (actionable insights) patterns through a variety of multi-dimensional composite visuals combining multiple individuals, multiple games, and multiple dates (over time).\nEach Pattern Visualizer Category represents a composite pattern for a player to explore by combining into a single view, the assessed scores of a specific selection of one or more individuals, one or more (time) dates, and one or more completed games.\nCategory # 1: to explore a single individual's assessed scores over time for multiple games\nObjective: to explore how a specific individual's assessed scores change over time (multiple dates) for multiple games\nCategory # 2: to explore multiple individuals’ assessed scores over time for a single game\nObjective: to explore for a specific game, how one or more individual’s assessed scores change over time or how these scores compare, correlate, and vary among the different individuals\nCategory # 3: to explore multiple individuals’ assessed scores for multiple games on the same time date\nObjective: to explore how one or more individual’s assessed scores compare, correlate, and vary over multiple games for a specific date\nCategory # 4: to explore multiple individuals’ assessed scores for multiple cards of a single game for a single time date\nObjective: to explore how one or more individual’s assessed scores compare, correlate, and vary over multiple cards of a specific game for a single time date\nCategory # 5: to explore a single individual’s assessed scores for multiple cards of one game on multiple time dates\nObjective: to explore how a specific individual’s assessed scores compare, correlate, and vary over multiple cards of a specific game and over multiple time dates."

        }
        
        // assign
        titleDecoLabel.attributedText = NSAttributedString(string: mvpType.rawValue, attributes: [.strokeColor: UIColor.black, .strokeWidth: NSNumber(value: 15)])
        titleLabel.text = mvpType.rawValue
        titleLabel.textColor = mainColor
        
        // detail
        let para = NSMutableParagraphStyle()
        para.lineSpacing = fontFactor * 8
        let textAttributedS = NSMutableAttributedString(string: textString, attributes: [ .font : font, .paragraphStyle: para])
        // color
        for index in textString.getStartIndexesOf(mvpType.rawValue) {
             textAttributedS.addAttributes([.foregroundColor: mainColor, .font: UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)], range: NSMakeRange(index, mvpType.rawValue.count))
        }
        
        if mvpType == .scorecardAlbum {
            let attach = NSTextAttachment()
            attach.image = #imageLiteral(resourceName: "about_album") // 201 * 118
            attach.bounds = CGRect(x: 0, y: 0, width: 201 * fontFactor, height: 118 * fontFactor)
            textAttributedS.append(NSAttributedString(attachment: attach))
        }
        
        aboutTextView.attributedText = textAttributedS
    }
    
    @IBAction func goToNext(_ sender: Any) {
        dismiss(animated: true) {
            self.goToNextViewController()
        }
    }
    
    
    @IBAction func nevershow(_ sender: Any) {
        userDefaults.set(true, forKey: keyString)
        userDefaults.synchronize()
        dismiss(animated: true) {
            self.goToNextViewController()
        }
    }
}
