//
//  CartTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/13.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CartTableView: UITableView {
    weak var hostVC: CartCardsViewController!
    var editingMode = false
    
    // create
    class func createWithFrame(_ frame: CGRect, chosenCards: [MatchedCardsDisplayModel]) -> CartTableView {
        let table = CartTableView(frame: frame, style: .plain)
        table.setupTableWithChosenCards(chosenCards)
        return table
    }

    func reloadDataWithCards(_ cards: [MatchedCardsDisplayModel]) {
        reloadCategoryResults(cards)
        reloadData()
    }
    
    // MARK: ----------- private -----------
    fileprivate var results = [(title: String, cards: [MatchedCardsDisplayModel])]()
    fileprivate var sectionFoldState = [Int: Bool]() // true for fold
    fileprivate var basicHP: CGFloat {
        return bounds.height / (667 - 49 - 64)
    }
    
    fileprivate var headerHeight: CGFloat {
        return 46 * basicHP
    }
    
    fileprivate var byRisk = false
    fileprivate func setupTableWithChosenCards(_ chosenCards: [MatchedCardsDisplayModel]) {

        reloadCategoryResults(chosenCards)
        
        separatorStyle = .none
        tableFooterView = UIView()
        
        allowsSelection = false
        dataSource = self
        delegate = self
    }
    
    // data
    fileprivate func reloadCategoryResults(_ chosenCards: [MatchedCardsDisplayModel]) {
        results.removeAll()
        sectionFoldState.removeAll()

        // display
        var categoryDic = [String: [MatchedCardsDisplayModel]]()
        for card in chosenCards {
            // orgnize
            if categoryDic[card.categoryKey] == nil {
                categoryDic[card.categoryKey] = [card]
            }else {
                categoryDic[card.categoryKey]!.append(card)
            }
        }
            
        for (key, value) in categoryDic {
            let name = AIDMetricCardsCollection.standardCollection.getMetricGroupByKey(key)?.name ?? UnGroupedCategoryKey
            results.append((name, value))
        }
        
        updateFoldForSelection()
    }
    
    func updateFoldForSelection() {
        for i in 0..<results.count {
//            sectionFoldState[i] = true
            sectionFoldState[i] = false
        }
        // first as unfolded
//        sectionFoldState[0] = false
//        
//        // with selection
//        if hostVC != nil {
//            let cardKeys = Array(hostVC.getAllSelectedCardsInfo().keys)
//            for section in 0..<results.count  {
//                let cards = results[section].cards
//                for card in cards {
//                    if cardKeys.contains(card.cardInfo.key) {
//                        sectionFoldState[section] = false
//                        break
//                    }
//                }
//            }
//        }
    }
    
    fileprivate func numberOfAssess(_ section: Int) -> Int {
        let assess = MatchedCardsDisplayModel.arrangeWithColors(results[section].cards)
        return assess.count
    }
    
    fileprivate func colorForIndexPath(_ indexPath: IndexPath) -> UIColor {
        let assess = MatchedCardsDisplayModel.arrangeWithColors(results[indexPath.section].cards)
        return assess[indexPath.row].color
    }
    fileprivate func cardsForIndexPath(_ indexPath: IndexPath) -> [MatchedCardsDisplayModel] {
        let assess = MatchedCardsDisplayModel.arrangeWithColors(results[indexPath.section].cards)
        return assess[indexPath.row].cards
    }
    
    // action
    func changeFoldState(_ button: UIButton)  {
        let section = button.tag - 100
        sectionFoldState[section] = !sectionFoldState[section]!
        reloadSections(IndexSet(integer: section), with: .automatic)
        scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
    }
}

// MARK: --------- dataSource -----------
extension CartTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfAssess(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartCell = CartTableCell.cellWithTableView(tableView, cards: cardsForIndexPath(indexPath), color: colorForIndexPath(indexPath), mode: editingMode)
        cartCell.hostTable = self
        return cartCell
    }
}

// MARK: ---------  delegate  -----------
extension CartTableView: UITableViewDelegate {
    // views
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // overall
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight))
        headerView.backgroundColor = UIColor.white
        
        // detail
        let margin: CGFloat = 15 * bounds.width / 375
        let lineHeight = headerHeight * 0.015
        let titleLabel = UILabel()
        let headerLine = UIView()
        
        // title
        let labelFrame = CGRect(x: margin, y: 0, width: bounds.width * 0.8, height: headerHeight - lineHeight)
        titleLabel.frame = labelFrame
        titleLabel.text = results[section].title
        titleLabel.font = UIFont.systemFont(ofSize: headerHeight * 0.3, weight: UIFontWeightMedium)
        titleLabel.adjustWithHeightKept()
        
        if labelFrame.width < titleLabel.frame.width {
            titleLabel.frame = labelFrame
        }
        
        // button: 12 * 8
        let foldButton = UIButton(type: .custom)
        foldButton.frame = CGRect(x: titleLabel.frame.maxX + 5, y: (headerHeight - lineHeight) * 0.5 - 8, width: 24, height: 16)
        foldButton.tag = section + 100
        foldButton.addTarget(self, action: #selector(changeFoldState), for: .touchUpInside)
        foldButton.setImage(UIImage(named: "arrow_down_green"), for: .normal)
        foldButton.transform = sectionFoldState[section]! ? CGAffineTransform(rotationAngle: CGFloat(Double.pi)): CGAffineTransform.identity
        
        // line
        headerLine.frame = CGRect(x: margin, y: titleLabel.frame.maxY, width: bounds.width - margin, height: lineHeight)
        
        titleLabel.textColor = colorPairs[section % colorPairs.count].border
        headerLine.backgroundColor = colorPairs[section % colorPairs.count].border

        headerView.addSubview(titleLabel)
        headerView.addSubview(foldButton)
        headerView.addSubview(headerLine)
        
        // if only one row
        foldButton.isHidden = (results.count == 1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // the last section
        if section == numberOfSections - 1 {
            return UIView()
        }
        
        let footerView = UIView()
        footerView.backgroundColor = UIColorGray(216)
        return footerView
    }
    
    // heights
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == numberOfSections - 1 {
            return 70 * basicHP
        }
        
        return sectionFoldState[section]! ? 0 : 6 * basicHP
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sectionFoldState[indexPath.section]! ? 0 : 165 * basicHP
    }
}
