//
//  ChooseTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/18.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ChooseTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    weak var referenceView: VitaminDReferenceView!
    fileprivate var chosenSection = -1
    fileprivate let optionsData = [(title: "My Vitamin D3 level is clinically Deficient", options: ["My current level\n <=10ng/ml", "My current level\n 11-15ng/ml"]),
                     (title: "My Vitamin D3 level is clinically Insufficient", options: ["My current level\n 16-20ng/ml", "My current level\n 21-25ng/ml", "My current level\n 26-30ng/ml"]),
                     (title: "My Vitamin D3 level is clinically Sufficient", options: [ "My current level\n 31-35ng/ml", "My current level\n 36-40ng/ml"]),
                     (title: "My Vitamin D3 level is at the 'Sweet Spot'", options: ["My current level\n 41-45ng/ml", "My current level\n 46-50ng/ml", "My current level\n 51-60ng/ml"]),
                     (title: "My Vitamin D3 level is clinically at 'Therapeutic level'", options: ["My current level\n 61-100ng/ml"]),
                     (title: "I don't know my current Vitamin D3 level. Please help me with an estimate.", options: [])
        ]
    
    let ballColors = [UIColorFromHex(0xA70000), UIColorFromHex(0xDCB800), UIColorFromHex(0x9CA91E), UIColorFromHex(0x39B54A), UIColorFromHex(0x0288D1), UIColorGray(151)]
    let optionColors = [UIColorFromRGB(239, green: 83, blue: 80), UIColorFromRGB(253, green: 213, blue: 5), UIColorFromRGB(205, green: 220, blue: 57), UIColorFromRGB(0, green: 200, blue: 83), UIColorFromRGB(129, green: 212, blue: 250), UIColorGray(151)]
    
    fileprivate let sweetImageView = UIImageView(image: UIImage(named: "VitaminDsweetSpot"))
    fileprivate var measurement: MeasurementObjModel!
    func usedForVitaminD(_ measurement: MeasurementObjModel) {
        self.bounces = false
        self.backgroundColor = UIColor.clear
        self.backgroundView = nil
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.contentInset = UIEdgeInsets.zero
        self.allowsSelection = false
        
        self.delegate = self
        self.dataSource = self
        
        self.measurement = measurement
        sweetImageView.contentMode = .scaleAspectFit
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return optionsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (optionsData[section].options.count != 0) ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var subIndex: Int!
        if result != nil {
            if indexPath.section == result?.0 {
                subIndex = result?.1
            }
        }
        
        return ChooseTableCell.cellWithTableView(self, texts: optionsData[indexPath.section].options, color: optionColors[indexPath.section], current: (indexPath.section == chosenSection), subIndex: subIndex)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: cellH))
        header.tag = section + 100
        
        let sweetL = cellH * 0.8
        if section == 3 {
            sweetImageView.frame = CGRect(x: bounds.width - sweetL, y: 0, width: sweetL, height: sweetL)
            header.addSubview(sweetImageView)
        }
        let fillColor = optionColors[section]
        header.backgroundColor = (section == chosenSection) ? fillColor.withAlphaComponent(0.25) : UIColor.clear
        
        let chooseView = VitaminDLevelChooseView(frame: CGRect(x: sweetL * 0.5, y: 0, width: bounds.width - 1.5 * sweetL, height: cellH))
        
        var blank = 1 - CGFloat(section + 2) / CGFloat(optionsData.count)
        if section == optionsData.count - 1 {
            blank = 1
        }

        chooseView.setupWithFillColor(fillColor, ballColor: ballColors[section], text: optionsData[section].title, blankRatio: blank, chosen: (section == chosenSection))
        header.addSubview(chooseView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerIsTapped(_ :)))
        header.addGestureRecognizer(tap)
        
        chooseView.setNeedsDisplay()
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    @objc func headerIsTapped(_ tap: UITapGestureRecognizer)  {
        let chosen = tap.view!.tag - 100
        let old = chosenSection
        chosenSection = chosen
        if old != -1 && old != chosen {
            reloadSections(IndexSet(integer: old), with: .automatic)
        }
        reloadSections(IndexSet(integer: chosen) , with: .automatic)

        if optionsData[chosen].options.isEmpty {
            result = nil
            estimateForUser()
        }
    }
    
    // levels: 10, 15, 20 ....... index: 0, 1, 2 .....
    fileprivate var result: (Int, Int?)?
    func chooseSubIndex(_ index: Int) {
        result = (chosenSection, index)
        reloadRows(at: [IndexPath(row: 0, section: chosenSection)], with: .automatic)

        var levelIndex = 0
        for i in 0..<chosenSection {
            levelIndex += optionsData[i].options.count
        }
        levelIndex += index
       
        let text = optionsData[chosenSection].options[index]
        referenceView.optionIsChosen(levelIndex, cardIndex: chosenSection, withText: text, color: optionColors[chosenSection])
    }
    
    func estimateForUser() {
        let userKey = measurement.playerKey
        var resultLevelIndex = 0
        
        if let lastM = selectionResults.getLastMeasurementOfUser(userKey!, riskKey: vitaminDInKey, whatIf: WHATIF)  {
            if let cKey = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(lastM).key {
                let risk = collection.getRisk(vitaminDInKey)!
                for (i, c) in risk.classifiers.enumerated() {
                    if c.key == cKey {
                        resultLevelIndex = 2 - i
                        break
                    }
                }
            }
            
            resultLevelIndex = min(resultLevelIndex, 2)
            let options = optionsData[resultLevelIndex]
            let levelText = "\(options.options.first!)"
            referenceView.optionIsChosen( resultLevelIndex * 2 + 1, cardIndex: chosenSection, withText: levelText, color: optionColors[chosenSection])
        }else {
            if let metric = collection.getMetric(vitaminDMetricKey) {
                // unplayed
                let alert = CatCardAlertViewController()
                alert.addTitle( "To estimate your current level, you should play", subTitle: "\(metric.name!)", buttonInfo: [("Go to play", false, playIPaOfVitaminD), ("Stay", true, nil)])
                
                viewController.presentOverCurrentViewController(alert, completion: nil)
            }
        }
    }
    
    fileprivate func playIPaOfVitaminD() {
        cardsCursor.selectedRiskClassKey = vitaminDMetricKey
        GameTintApplication.sharedTint.focusingTierIndex = 1
        
        for vc in self.navigation.viewControllers {
            if vc.isKind(of: ABookLandingPageViewController.self) {
                self.navigation.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    // frames
    fileprivate var hRatio: CGFloat = 0.75
    fileprivate var cellH: CGFloat {
        return bounds.height / CGFloat(optionsData.count + 1) * hRatio
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellH
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let space = bounds.height / CGFloat(optionsData.count)
        return space * (1 - hRatio)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == chosenSection ? cellH : 0
    }
}
