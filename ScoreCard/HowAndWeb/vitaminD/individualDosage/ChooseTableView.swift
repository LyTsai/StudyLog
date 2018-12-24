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
    let optionsData = [(title: "My Vitamin D3 level is clinically Deficient", options: ["My current level\n <=10ng/ml", "My current level\n 11-15ng/ml"]),
                     (title: "My Vitamin D3 level is clinically Insufficient", options: ["My current level\n 16-20ng/ml", "My current level\n 21-25ng/ml", "My current level\n 26-30ng/ml"]),
                     (title: "My Vitamin D3 level is clinically Sufficient", options: [ "My current level\n 31-35ng/ml", "My current level\n 36-40ng/ml"]),
                     (title: "My Vitamin D3 level is at the 'Sweet Spot'", options: ["My current level\n 41-45ng/ml", "My current level\n 46-50ng/ml", "My current level\n 51-60ng/ml"]),
                     (title: "My Vitamin D3 level is clinically at 'Therapeutic level'", options: ["My current level\n 61-100ng/ml"]),
                     (title: "I don't know my current Vitamin D3 level. Please help me with an estimate.", options: [])
        ]
    let optionColors = [UIColorFromRGB(239, green: 83, blue: 80), UIColorFromRGB(253, green: 213, blue: 5), UIColorFromRGB(205, green: 220, blue: 57), UIColorFromRGB(0, green: 200, blue: 83), UIColorFromRGB(129, green: 212, blue: 250), UIColorGray(151)]
    
    fileprivate let sweetImageView = UIImageView(image: UIImage(named: "VitaminDsweetSpot"))
    func usedForVitaminD() {
        self.bounces = false
//        self.isScrollEnabled = false
        self.backgroundColor = UIColor.clear
        self.backgroundView = nil
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.contentInset = UIEdgeInsets.zero
        self.allowsSelection = false
        
        self.delegate = self
        self.dataSource = self
        
        sweetImageView.contentMode = .scaleAspectFit
 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return optionsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (optionsData[section].options.count != 0) ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ChooseTableCell.cellWithTableView(self, texts: optionsData[indexPath.section].options, color: optionColors[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleHeader = VitaminDLevelChooseView()
        titleHeader.tag = section + 100
        var blank = 1 - CGFloat(section + 2) / CGFloat(optionsData.count)
        if section == optionsData.count - 1 {
            blank = 1
        }

        titleHeader.setupWithColor(optionColors[section], text: optionsData[section].title, blankRatio: blank)
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerIsTapped(_ :)))
        titleHeader.addGestureRecognizer(tap)

        if section == 3 {
            sweetImageView.frame = CGRect(x: bounds.width - cellH, y: 0, width: cellH, height: cellH)
            titleHeader.addSubview(sweetImageView)
        }
        
        return titleHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    @objc func headerIsTapped(_ tap: UITapGestureRecognizer)  {
        let chosen = tap.view!.tag - 100
        
        if chosen == chosenSection {
            if optionsData[chosen].options .count == 0 {
                estimateForUser()
            }
        }else {
            var indexPaths = [IndexPath]()
    
            // others
            if chosenSection != -1 && optionsData[chosenSection].options .count != 0 {
                indexPaths = [IndexPath(row: 0, section: chosenSection)]
            }
            
            chosenSection = chosen
            
            if optionsData[chosen].options .count == 0 {
                reloadRows(at:indexPaths, with: .automatic)
                estimateForUser()
            }else {
                indexPaths.append(IndexPath(row: 0, section: chosen))
                reloadRows(at:indexPaths, with: .automatic)
                scrollToRow(at: IndexPath(row: 0, section: chosenSection), at: .middle, animated: true)
            }
        }
    }
    
    // levels: 10, 15, 20 ....... index: 0, 1, 2 .....
    func chooseSubIndex(_ index: Int) {
        var levelIndex = 0
        for i in 0..<chosenSection {
            levelIndex += optionsData[i].options.count
        }
        levelIndex += index
        
        let text = optionsData[chosenSection].options[index]
        referenceView.optionIsChosen(levelIndex, cardIndex: chosenSection, withText: text, color: optionColors[chosenSection])
    }
    
    func estimateForUser() {
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
                referenceView.optionIsChosen( resultLevelIndex * 2 + 1, cardIndex: chosenSection, withText: levelText, color: optionColors[chosenSection])
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
    
    // frames
    fileprivate var hRatio: CGFloat = 0.75
    fileprivate var cellH: CGFloat {
        return bounds.height / CGFloat(optionsData.count) * hRatio
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
}
