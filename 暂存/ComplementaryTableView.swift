//
//  ComplementaryTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/10/25.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class ComplementaryTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    class func createWithFrame(_ frame: CGRect) -> ComplementaryTableView {
        let table = ComplementaryTableView(frame: frame, style: .plain)
        table.delegate = table
        table.dataSource = table
        table.separatorStyle = .none
        
        return table
    }
    
    fileprivate var cards = [CardInfoObjModel]()
    fileprivate var measurement: MeasurementObjModel!
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        self.measurement = measurement
        self.cards = MatchedCardsDisplayModel.getMatchedComplementaryCardsInMeaurement(measurement)
        reloadData()
    }
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = cards[indexPath.row]
        let match = card.getMatchInMeasurement(measurement)!
        var imageUrl = match.imageUrl
        if card.isJudgementCard() && imageUrl == nil {
            imageUrl = card.cardOptions.first?.match?.imageUrl
        }
        
        let cell = ComplementaryCardCell.cellWithTable(tableView, imageUrl: imageUrl, color: match.classification?.realColor, name: match.classification?.displayName, detail: match.name)
        
        return cell
    }
    
    // delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bounds.width / 344 * 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
        let reviewVC = PlayedCardsReviewViewController()
        reviewVC.loadWithCards(cards, index: indexPath.row, withDistribution: false)
        reviewVC.modalPresentationStyle = .overCurrentContext
        self.viewController.present(reviewVC, animated: true, completion: nil)
    }
}
