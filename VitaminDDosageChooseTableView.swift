//
//  VitaminDDosageChooseTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/21.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class VitaminDDosageChooseTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    weak var referenceView: VitaminDReferenceView!
    fileprivate let optionsData = [(title: "My Vitamin D3 level is clinically Deficient", options: ["My current level\n <=10ng/ml", "My current level\n 11-15ng/ml"]),
                                   (title: "My Vitamin D3 level is clinically Insufficient", options: ["My current level\n 16-20ng/ml", "My current level\n 21-25ng/ml", "My current level\n 26-30ng/ml"]),
                                   (title: "My Vitamin D3 level is clinically Sufficient", options: [ "My current level\n 31-35ng/ml", "My current level\n 36-40ng/ml"]),
                                   (title: "My Vitamin D3 level is at the 'Sweet Spot'", options: ["My current level\n 41-45ng/ml", "My current level\n 46-50ng/ml", "My current level\n 51-60ng/ml"]),
                                   (title: "My Vitamin D3 level is clinically at 'Therapeutic level'", options: ["My current level\n 61-100ng/ml"]),
                                   (title: "I don't know my current Vitamin D3 level. Please help me with an estimate.", options: [])
    ]
    
    fileprivate let colorsInfo = [(UIColorFromHex(0xA70000), UIColorFromHex(0xEF5350)),
                                  (UIColorFromHex(0xDCB800), UIColorFromRGB(253, green: 213, blue: 5)),
                                  (UIColorFromHex(0x9CA91E), UIColorFromRGB(205, green: 220, blue: 57)),
                                  (UIColorFromHex(0x39B54A), UIColorFromRGB(0, green: 200, blue: 83)),
                                  (UIColorFromHex(0x0288D1), UIColorFromRGB(129, green: 212, blue: 250)),
                                  (UIColorGray(151), UIColorGray(151))]
    
    fileprivate var chosenResult: (Int, Int?)? // index
    
    func usedForVitaminD() {
        self.bounces = false
        self.backgroundColor = UIColor.clear
        self.backgroundView = nil
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false

        self.allowsSelection = false
        
        self.delegate = self
        self.dataSource = self
    }
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VitaminDDosageChooseCell.cellWithTableView(self, textData: optionsData[indexPath.row]) as! VitaminDDosageChooseCell
        let colorInfo = colorsInfo[indexPath.row]
        
        var strench = false
        var subIndex: Int!
        if chosenResult != nil {
            if chosenResult!.0 == indexPath.row {
                strench = true
                subIndex = chosenResult!.1
            }
        }
        cell.setupWithBallColor(colorInfo.0, fillColor: colorInfo.1, strench: strench, subIndex: subIndex, row: indexPath.row)
        let data = optionsData[indexPath.row]
        cell.setupWithTitle(data.title, texts: data.options)
        
        return cell
    }

    // frames
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellH = bounds.height / CGFloat(max(1, optionsData.count))
        return (indexPath.row == 5 || (chosenResult != nil && indexPath.row == chosenResult!.0)) ? cellH : cellH * 80 / 45
    }
    
    func touchRowOf(_ row: Int, subIndex: Int!) {
        if chosenResult == nil {
            chosenResult = (row, subIndex)

            reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }else {
            // change
            if chosenResult!.0 != row {
                let indexes = [IndexPath(row: row, section: 0), IndexPath(row: chosenResult!.0, section: 0)]
                chosenResult = (row, subIndex)
                reloadRows(at: indexes, with: .automatic)
            }else {
                chosenResult = (row, subIndex)
                if let index = chosenResult!.1 {
                    // choose sub, alert weight
                    var levelIndex = 0
                    for i in 0..<chosenResult!.0 {
                        levelIndex += optionsData[i].options.count
                    }
                    levelIndex += index
                    
                    let text = optionsData[row].options[index]
                    referenceView.optionIsChosen(levelIndex, cardIndex: row, withText: text, color: colorsInfo[row].1)
                }
            }
        }
        
        if row == 5 {
            estimateForUser()
        }
        
    }
    
    fileprivate func estimateForUser() {
        let userKey = referenceView.userKey
        
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
            referenceView.optionIsChosen(resultLevelIndex * 2 + 1, cardIndex: resultLevelIndex, withText: levelText, color: colorsInfo[resultLevelIndex].1)
        }else {
            if let metric = collection.getMetric(vitaminDMetricKey) {
                // unplayed
                let alert = UIAlertController(title: "To estimate your current level, you should play", message:"\(metric.name!)" , preferredStyle: .alert)
                
                let playAction = UIAlertAction(title: "Go to play", style: .default) { (action) in
                    cardsCursor.selectedRiskClassKey = vitaminDMetricKey
                    GameTintApplication.sharedTint.focusingTierIndex = 1
                    
                    for vc in self.navigation.viewControllers {
                        if vc.isKind(of: ABookLandingPageViewController.self) {
                            self.navigation.popToViewController(vc, animated: true)
                            break
                        }
                    }
                }
                
                let cancel = UIAlertAction(title: "Stay", style: .cancel, handler: nil)
                alert.addAction(playAction)
                alert.addAction(cancel)
                
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}
