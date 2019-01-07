//
//  CartCardsViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/13.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CartCardsViewController: UIViewController {
    weak var presentedFrom: UIViewController!
    
    // default as by risk
    fileprivate var chosenSegIndex: Int = 0
    fileprivate var segments = [CartSegmentView]()
    fileprivate var tables = [CartTableView]()
    
    fileprivate  let selectionLabel = UILabel()
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.title = "What is in the Cart"
    
        let segHeight = height * 40 / 667
        let tableFrame = CGRect(x: 0, y: 64 + segHeight, width: width, height: height - 49 - 64 - segHeight)
        // risk
        let riskSeg = CartSegmentView()
        riskSeg.setWithFrame(CGRect(x: 0, y: 64, width: width * 0.5, height: segHeight), title: "Risks", selected: true)
        let riskTap = UITapGestureRecognizer(target: self, action: #selector(changeTable))
        riskSeg.addGestureRecognizer(riskTap)
        let riskTable = CartTableView.createWithFrame(tableFrame, byRisk: true)
        riskTable.hostVC = self
        // add risk
        segments.append(riskSeg)
        tables.append(riskTable)
        
        view.addSubview(riskSeg)
        view.addSubview(riskTable)
        
        // category
        let categorySeg = CartSegmentView()
        categorySeg.setWithFrame(CGRect(x: width * 0.5, y: 64, width: width * 0.5, height: segHeight), title: "Category", selected: false)
        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(changeTable))
        categorySeg.addGestureRecognizer(categoryTap)
        let categoryTable = CartTableView.createWithFrame(tableFrame, byRisk: false)
        categoryTable.hostVC = self
        
        // add category
        segments.append(categorySeg)
        tables.append(categoryTable)
        view.addSubview(categorySeg)
        view.addSubview(categoryTable)
        
        categoryTable.isHidden = true
        
        // command bar
        let cmdHeight = 70 * height / 667
        let cmdBar = UIView(frame: CGRect(x: -1, y: height - 49 - cmdHeight ,width: width + 2, height: cmdHeight))
        cmdBar.layer.borderColor = UIColorGray(231).cgColor
        cmdBar.layer.borderWidth = 1
        cmdBar.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        // seletionInfo
        let desLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 110, height: cmdHeight))
        desLabel.text = "Number of Chosen-Cards"
        desLabel.textAlignment = .center
        desLabel.numberOfLines = 0
        desLabel.font = UIFont.systemFont(ofSize: cmdHeight * 0.21, weight: UIFontWeightMedium)
        
        selectionLabel.textColor = UIColor.red
        selectionLabel.frame = CGRect(x: desLabel.frame.maxX + 2, y: 0, width: 29, height: cmdHeight)
        selectionLabel.text = "0"
        
        // delete
        let deleteButton = UIButton.customThickRectButton("DELETE")
        deleteButton.adjustThickRectButton(CGRect(center: CGPoint(x: width - 98 * height / 667, y: cmdHeight * 0.5), width: 137 * height / 667, height: 49 * height / 667))
        deleteButton.addTarget(self, action: #selector(deleteSelectedCards), for: .touchUpInside)
        
        cmdBar.addSubview(desLabel)
        cmdBar.addSubview(selectionLabel)
        cmdBar.addSubview(deleteButton)
        view.addSubview(cmdBar)
    }
    
    // selection for all
    
    // cardKey: [risk]
    func getAllSelectedCardsInfo() -> [String: [String]] {
        var results = [String: [String]]()
        // cardInfo.key
        for card in selectedCards {
            var riskKeys = [String]()
            for risk in card.risks {
                riskKeys.append(risk.key)
            }
            
            results[card.cardInfo.key] = riskKeys
        }
        
        return results
    }
    
    var selectedCards = [MatchedCardsDisplayModel]() {
        didSet{
            selectionLabel.text = "\(selectedCards.count)"
        }
    }
    
    
    // MARK: ------------- action --------------
    func changeTable(_ tap: UITapGestureRecognizer) {
        let tapped = tap.view as! CartSegmentView
        let current = segments[chosenSegIndex]
        
        if tapped !== current {
            let oldIndex = chosenSegIndex
            current.setUIWithState(false)
            
            for (i, seg) in segments.enumerated() {
                if tapped === seg {
                    seg.setUIWithState(true)
                    chosenSegIndex = i
                    break
                }
            }
            let displayTable = tables[self.chosenSegIndex]
            
            UIView.animate(withDuration: 0.4, animations: { 
                self.tables[oldIndex].isHidden = true
                
                displayTable.isHidden = false
                displayTable.updateFoldForSelection()
                displayTable.reloadData()
            })
        }
    }
    
    func deleteSelectedCards() {
        let cardInfos = getAllSelectedCardsInfo()
        for (cardKey, riskKeys) in cardInfos {
            for riskKey in riskKeys {
                CardSelectionResults.cachedCardProcessingResults.deleteUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, cardKey: cardKey, riskKey: riskKey)
            }
        }
        
        selectedCards.removeAll()
        
        for table in tables {
            table.reloadAllInfo()
        }
        
        // anwered table
        if presentedFrom.isKind(of: ABookRiskAssessmentViewController.self) {
            let vc = presentedFrom as! ABookRiskAssessmentViewController
            if vc.answerView.superview != nil {
                vc.answerView.updateData()
            }
        }
    }

}
