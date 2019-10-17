//
//  CardsResultDisplayTableViewCell.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/13.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

let cardsResultDisplayTableViewCellID = "cardsResult Display Table View Cell Identifier"

class CardsResultDisplayTableViewCell: UITableViewCell {
    fileprivate let displayView = CardResultDisplayView()
    class func cellWithTableView(_ table: UITableView, imageUrl: URL?, borderColor: UIColor, attributedText: NSAttributedString, factorType: FactorType) -> CardsResultDisplayTableViewCell {
        var cell = table.dequeueReusableCell(withIdentifier: cardsResultDisplayTableViewCellID) as? CardsResultDisplayTableViewCell
        if cell == nil {
            cell = CardsResultDisplayTableViewCell(style: .default, reuseIdentifier: cardsResultDisplayTableViewCellID)
            cell!.selectionStyle = .none
            cell!.contentView.addSubview(cell!.displayView)
        }
        
        cell?.displayView.setupWithImageUrl(imageUrl, borderColor: borderColor, attributedText: attributedText, factorType: factorType)
        
        return cell!
    }
    
    class func cellWithTable(_ table: UITableView, card: CardInfoObjModel, measurement: MeasurementObjModel, color: UIColor, fontSize: CGFloat) -> CardsResultDisplayTableViewCell {
        let measurementValue = card.getMeasurementValueInMeasurement(measurement)!
        
        let cardTitle = card.title ?? "No Title"
        let cardMatch = card.getOriginalMatchInMeasurement(measurement)
        
        var cardAnswer = cardMatch?.name
        var imageUrl = cardMatch?.imageUrl
        if card.isInputCard() || card.isJudgementCard() {
            imageUrl = card.getDisplayOptions().first?.match?.imageUrl
            let measurementValue = card.getMeasurementValueInMeasurement(measurement)!
            if card.isInputCard() {
                cardAnswer = "Input: \(String(format: "%.2f", measurementValue.value ?? 0))"
            }else {
                // ME, NOT ME
                cardAnswer = (Int(measurementValue.value) == 0 ? "ME" : "NOT ME")
            }
        }else {
            let match = collection.getMatch(measurementValue.matchKey)!
            if match.key != cardMatch?.key {
                cardAnswer?.append(": \(match.statement ?? "")")
                if match.suggestion != nil {
                    //  if match.info[“Suggestion”] is not empty then display this string after the match statement
                    cardAnswer?.append("\n\(match.suggestion!)")
                }
            }
        }
        
        // text
        let text = NSMutableAttributedString(string: "\(cardTitle)\n", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .light)])
        let tag = #imageLiteral(resourceName: "icon_legend")
        let imageText = NSTextAttachment()
        imageText.image = tag
        imageText.bounds = CGRect(x: 0, y: 0, width: fontSize * 17 / 16, height: fontSize)
        
        text.append(NSAttributedString(attachment: imageText))
        text.append(NSMutableAttributedString(string: "\(cardAnswer ?? "")", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .medium)]))
        
        // cell
        var factorType = FactorType.score
        if card.isComplementaryCardInRisk(measurement.riskKey!) {
            factorType = .complementary
        }else if card.isBonusCardInRisk(measurement.riskKey!) {
            factorType = .bonus
        }
        
        return cellWithTableView(table, imageUrl: imageUrl, borderColor: color, attributedText: text, factorType: factorType)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        displayView.frame = bounds.insetBy(dx: bounds.height * 0.1, dy: bounds.height * 0.05)
    }
}
