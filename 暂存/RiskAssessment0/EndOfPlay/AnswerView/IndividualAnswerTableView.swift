//
//  IndividualAnswerTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/2.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class IndividualAnswerTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    weak var hostView: IndividualAnswersView!
    var answerIndexes = [Int]()
    
    // MARK: -------- factoy
    class func createWith(_ frame: CGRect, results: [Int?]) -> IndividualAnswerTableView {
        let table = IndividualAnswerTableView(frame: frame, style: .plain)
        table.tableFooterView = UIView()
        
        if table.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            table.separatorInset = UIEdgeInsets.zero
        }
        if table.responds(to: #selector(setter: UIView.layoutMargins)) {
            table.layoutMargins = UIEdgeInsets.zero
        }
        
        // data
        table.setupAnswerIndexes(results)
        
        // delegate
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    
    // refresh data
    fileprivate let cardsFactory = VDeckOfCardsFactory.metricDeckOfCards
    fileprivate let cursor = RiskMetricCardsCursor.sharedCursor
    func setupAnswerIndexes(_ results: [Int?]) {
        answerIndexes.removeAll()
        
        for result in results {
            var answerIndex = -1
            let cardStyleKey = cardsFactory.getVCard(0)?.cardStyleKey
            if cardStyleKey == JudgementCardTemplateView.styleKey() {
                // answer index
                if result != nil {
                    switch result! {
                    case 1: answerIndex = 0
                    case -1: answerIndex = 1
                    default: break
                    }
                }
            } else if cardStyleKey == SpinningMultipleChoiceCardsTemplateView.styleKey() {
                if result != nil  {
                    answerIndex = result!
                }
            }

            answerIndexes.append(answerIndex)
        }
    }
    
    // save cached card
    func userChangeSelection(_ tableRow: Int, answerIndex: Int) {
        answerIndexes[tableRow] = answerIndex
        
        let cardsFactory = VDeckOfCardsFactory.metricDeckOfCards
        var value: Int!
        var option: CardOptionObjModel!
  
        let vCard = cardsFactory.getVCard(tableRow)!
        let cardStyleKey = vCard.cardStyleKey
    
        // judgement
        if cardStyleKey == JudgementCardTemplateView.styleKey() {
            value = (answerIndex == 0) ? 1 : -1
            option = vCard.cardOptions.first
        }
    
        // multiple
        if cardStyleKey == SetOfCardsCardTemplateView.styleKey() {
            option = vCard.cardOptions[answerIndex]
            value = answerIndex
        }
        
        CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, metricKey: vCard.metricKey!, cardKey: vCard.key, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey, selection: option, value: value as NSNumber?)
        
        hostView.setTableAnsweredNumber()
    }
    
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsFactory.totalNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vCard = cardsFactory.getVCard(indexPath.row)
    
        var cell: IndividualAnswerCell!
    
        let cardStyleKey = vCard?.cardStyleKey
        var options = [String]()
        let option = cardsFactory.getCardOption(indexPath.row)
        if cardStyleKey == JudgementCardTemplateView.styleKey() {
            options = ["Me", "Not Me"]
        
            cell = IndividualAnswerCell.cellWithTableView(tableView as! IndividualAnswerTableView, row: indexPath.row, text: "\(vCard?.metric?.name ?? "Factor"): (\(option?.match?.statement ?? "select"))", image: option?.match?.imageUrl, options:options, answerIndex: answerIndexes[indexPath.row], withDetail: true)
        }else if cardStyleKey == SpinningMultipleChoiceCardsTemplateView.styleKey() {
            let matchOptions = (cardsFactory.getVCard(indexPath.row)?.cardOptions)!
            for matchOption in matchOptions {
                options.append((matchOption.match?.statement)!)
            }
            cell = IndividualAnswerCell.cellWithTableView(tableView as! IndividualAnswerTableView, row: indexPath.row, text: vCard?.metric?.name, image: option?.match?.imageUrl, options:options, answerIndex: answerIndexes[indexPath.row], withDetail: false)
        }
        
        return cell
    }

    // delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
}
