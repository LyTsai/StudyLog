//
//  ActToChangeViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ActToChangeViewController: UIViewController {
    @IBOutlet weak var seeHowView: UIView!
    @IBOutlet weak var matchedCardsView: UIView!
    @IBOutlet weak var visualMapView: UIView!
    @IBOutlet weak var familyTreeView: UIView!
    @IBOutlet weak var timeMapView: UIView!
    @IBOutlet weak var landingLikeView: UIView!
    
    // labels
    @IBOutlet weak var seeHowDecoLabel: UILabel!
    @IBOutlet weak var seeHowLabel: UILabel!
    
    @IBOutlet weak var matchedDecoLabel: UILabel!
    @IBOutlet weak var matchedLabel: UILabel!
    
    @IBOutlet weak var visualDecoLabel: UILabel!
    @IBOutlet weak var visualLabel: UILabel!
    
    @IBOutlet weak var familyDecoLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    
    @IBOutlet weak var timeDecoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var landingDecoLabel: UILabel!
    @IBOutlet weak var landingLabel: UILabel!
    
    // data
    @IBOutlet weak var seeHowDateLabel: UILabel!
    @IBOutlet weak var matchedDateLabel: UILabel!
    @IBOutlet weak var visualMapDateLabel: UILabel!
    
    @IBOutlet weak var familyDateLabel: UILabel!
    @IBOutlet weak var timeDateLabel: UILabel!
    @IBOutlet weak var landingDateLabel: UILabel!
    
    fileprivate let seeHowDateKey = "see how check date"
    fileprivate let matchedDateKey = "matched check date"
    fileprivate let visualDateKey = "visual map check date"
    fileprivate let familyDateKey = "family check date"
    fileprivate let timeDateKey = "time check date"
    fileprivate let landingDateKey = "landing check date"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // borders and shadows
        seeHowView.addBorder(UIColorFromRGB(185, green: 235, blue: 135), cornerRadius: 8 * fontFactor, borderWidth: 3 * fontFactor, masksToBounds: false)
        seeHowView.layer.addBlackShadow(2 * fontFactor)
        
        matchedCardsView.addBorder(UIColorFromRGB(5, green: 210, blue: 235), cornerRadius: 8 * fontFactor, borderWidth: 3 * fontFactor, masksToBounds: false)
        matchedCardsView.layer.addBlackShadow(2 * fontFactor)
        
        visualMapView.addBorder(UIColorFromRGB(245, green: 160, blue: 45), cornerRadius: 8 * fontFactor, borderWidth: 3 * fontFactor, masksToBounds: false)
        visualMapView.layer.addBlackShadow(2 * fontFactor)
        
        familyTreeView.addBorder(UIColorFromRGB(194, green: 74, blue: 214), cornerRadius: 8 * fontFactor, borderWidth: 3 * fontFactor, masksToBounds: false)
        familyTreeView.layer.addBlackShadow(2 * fontFactor)
        
        timeMapView.addBorder(UIColorFromRGB(149, green: 89, blue: 255), cornerRadius: 8 * fontFactor, borderWidth: 3 * fontFactor, masksToBounds: false)
        timeMapView.layer.addBlackShadow(2 * fontFactor)
        
        landingLikeView.addBorder(UIColorFromRGB(0, green: 200, blue: 83), cornerRadius: 8 * fontFactor, borderWidth: 3 * fontFactor, masksToBounds: false)
        landingLikeView.layer.addBlackShadow(2 * fontFactor)
        
        // labels
        // top
        let font1 = UIFont.systemFont(ofSize: 20 * fontFactor, weight: UIFontWeightBold)
        let font2 = UIFont.systemFont(ofSize: 12 * fontFactor, weight: UIFontWeightBold)
        
        let dateFont = UIFont.systemFont(ofSize: 10 * fontFactor, weight: UIFontWeightLight)
        
        seeHowLabel.font = font1
        matchedLabel.font = font1
        visualLabel.font = font1
        familyLabel.font = font2
        timeLabel.font = font2
        landingLabel.font = font1
        
        // back
        let strokeA = [NSFontAttributeName: font1, NSStrokeWidthAttributeName: NSNumber(value: 15), NSStrokeColorAttributeName: UIColor.black]
        let strokeB = [NSFontAttributeName: font2, NSStrokeWidthAttributeName: NSNumber(value: 15), NSStrokeColorAttributeName: UIColor.black]
        seeHowDecoLabel.attributedText = NSAttributedString(string: "Individulized Assessments ", attributes: strokeA)
        matchedDecoLabel.attributedText = NSAttributedString(string: " Matched Cards", attributes: strokeA)
        visualDecoLabel.attributedText = NSAttributedString(string: " Visual Map", attributes: strokeA)
        landingDecoLabel.attributedText = NSAttributedString(string: " Slow Aging by design", attributes: strokeA)
        familyDecoLabel.attributedText = NSAttributedString(string: " Family tree map", attributes: strokeB)
        timeDecoLabel.attributedText = NSAttributedString(string: " Scorecard Album", attributes: strokeB)
        timeLabel.text = " Scorecard Album"
        
        // date
        seeHowDateLabel.font = dateFont
        matchedDateLabel.font = dateFont
        visualMapDateLabel.font = dateFont
        familyDateLabel.font = dateFont
        timeDateLabel.font = dateFont
        landingDateLabel.font = dateFont
        
        if userCenter.userState != .login {
            checkLogin()
        }
    }
    
    
    // actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self.view)
        
        if seeHowView.frame.contains(point) {
            userDefaults.set(Date(), forKey: seeHowDateKey)
            userDefaults.synchronize()
            
            let seeHowVC = SeeHowViewController()
            navigationController?.pushViewController(seeHowVC, animated: true)
        }else if matchedCardsView.frame.contains(point) {
            // check log in, if user touch tab "Act"
            if userCenter.userState != .login {
                checkLogin()
            }else {
                userDefaults.set(Date(), forKey: matchedDateKey)
                userDefaults.synchronize()
                
                let matchedOverallVC = MatchedCardsViewController()
                navigationController!.pushViewController(matchedOverallVC, animated: true)
            }
        }else if visualMapView.frame.contains(point) {
            if userCenter.userState != .login {
                let loginVC = LoginViewController()
                loginVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(loginVC, animated: true)
            }else {
                userDefaults.set(Date(), forKey: visualDateKey)
                userDefaults.synchronize()
                
                let visualMapVC = Bundle.main.loadNibNamed("VisualMapViewController", owner: self, options: nil)?.first as! VisualMapViewController
                visualMapVC.modalPresentationStyle = .fullScreen
                present(visualMapVC, animated: true, completion: nil)
            }
        }else if landingLikeView.frame.contains(point) {
            if userCenter.userState != .login {
                let loginVC = LoginViewController()
                loginVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(loginVC, animated: true)
            }else {
                userDefaults.set(Date(), forKey: seeHowDateKey)
                userDefaults.synchronize()
                
                let landingMapVC = LandingMapViewController()
                landingMapVC.modalPresentationStyle = .fullScreen
                present(landingMapVC, animated: true, completion: nil)
            }
        }else if timeMapView.frame.contains(point) {
            let albumVC = ScorecardAlbumViewController()
            navigationController?.pushViewController(albumVC, animated: true)
        }
        
    }
    
    fileprivate func checkLogin() {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Act To Change"
        
        // date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let noCheck = "Not Reviewed Before"
        if let date = userDefaults.object(forKey: seeHowDateKey) {
            seeHowDateLabel.text = "last reviewed at \n \(formatter.string(from: (date as! Date)))"
        }else {
            seeHowDateLabel.text = noCheck
        }
        if let date = userDefaults.object(forKey: matchedDateKey) {
            matchedDateLabel.text = "last reviewed at \n \(formatter.string(from: (date as! Date)))"
        }else {
            matchedDateLabel.text = noCheck
        }
        
        if let date = userDefaults.object(forKey: visualDateKey) {
            visualMapDateLabel.text = "last reviewed at \n \(formatter.string(from: (date as! Date)))"
        }else {
            visualMapDateLabel.text = noCheck
        }
        
        if let date = userDefaults.object(forKey: familyDateKey) {
            familyDateLabel.text = "last reviewed at \n \(formatter.string(from: (date as! Date)))"
        }else {
            familyDateLabel.text = noCheck
        }
        if let date = userDefaults.object(forKey: timeDateKey) {
            timeDateLabel.text = "last reviewed at \n \(formatter.string(from: (date as! Date)))"
        }else {
            timeDateLabel.text = noCheck
        }
        if let date = userDefaults.object(forKey: landingDateKey) {
            landingDateLabel.text = "last reviewed at \n \(formatter.string(from: (date as! Date)))"
        }else {
            landingDateLabel.text = noCheck
        }
    }
}
