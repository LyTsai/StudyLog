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
    
    // create
    class func createWithFrame(_ frame: CGRect, byRisk: Bool) -> CartTableView {
        let table = CartTableView(frame: frame, style: .plain)
        table.setupTable(byRisk)
        return table
    }
    
    func reloadAllInfo()  {
        reloadCategoryResults(byRisk)
        reloadData()
    }

    
    // MARK: ----------- private -----------
    fileprivate var results = [(title: String, cards: [MatchedCardsDisplayModel])]()
    fileprivate var sectionFoldState = [Int: Bool]() // true for fold
    fileprivate var basicHP: CGFloat {
        return bounds.height / (667 - 49 - 64 - 40)
    }
    
    fileprivate var headerHeight: CGFloat {
        return 46 * basicHP
    }
    
    fileprivate var byRisk = false
    fileprivate func setupTable(_ byRisk: Bool) {
        self.byRisk = byRisk
        reloadCategoryResults(byRisk)
        
        separatorStyle = .none
        tableFooterView = UIView()
        
        allowsSelection = false
        dataSource = self
        delegate = self
    }
    
    // data
    fileprivate func reloadCategoryResults(_ byRisk: Bool) {
        results.removeAll()
        sectionFoldState.removeAll()
        
        if byRisk {
            let played = MatchedCardsDisplayModel.getRiskOfCardsPlayed()
            for (key, value) in played {
                results.append((key.name, value))
            }
        }else {
            // display
            let played = MatchedCardsDisplayModel.getCategoryOfCardsPlayed()
            for (key, value) in played {
                let name = AIDMetricCardsCollection.standardCollection.getMetricGroupByKey(key)?.name ?? "Others"
                results.append((name, value))
            }
        }
        
        updateFoldForSelection()
    }
    
    func updateFoldForSelection() {
        for i in 0..<results.count {
            sectionFoldState[i] = true
        }
        // first as unfolded
        sectionFoldState[0] = false
        
        // with selection
        if hostVC != nil {
            let cardKeys = Array(hostVC.getAllSelectedCardsInfo().keys)
            for section in 0..<results.count  {
                let cards = results[section].cards
                for card in cards {
                    if cardKeys.contains(card.cardInfo.key) {
                        sectionFoldState[section] = false
                        break
                    }
                }
            }
        }
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
        let cartCell = CartTableCell.cellWithTableView(tableView, cards: cardsForIndexPath(indexPath), color: colorForIndexPath(indexPath))
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
        let labelFrame = CGRect(x: margin, y: 0, width: bounds.width * 0.6, height: headerHeight - lineHeight)
        titleLabel.frame = labelFrame
        titleLabel.text = results[section].title
        titleLabel.font = UIFont.systemFont(ofSize: headerHeight * 0.3, weight: UIFontWeightMedium)
        titleLabel.adjustWithHeightKept()
        
        if labelFrame.width < titleLabel.frame.width {
            titleLabel.frame = labelFrame
        }
        
        // button: 12 * 8
        let foldButton = UIButton(type: .custom)
        foldButton.frame = CGRect(x: titleLabel.frame.maxX + 3, y: (headerHeight - lineHeight) * 0.5 - 4, width: 12, height: 8)
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
