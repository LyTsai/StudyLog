//
//  CardsResultDisplayTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/13.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class CardsResultDisplayTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    // data
    fileprivate var measurement: MeasurementObjModel!
    fileprivate var cardsGroup = [(String, [CardInfoObjModel])]()
    
    // UI
    fileprivate var cellHeight: CGFloat = 0
    fileprivate var headerHeight: CGFloat = 0
    fileprivate var footerHeight: CGFloat = 0
    
    fileprivate var focusedSection: Int = -1
    fileprivate let maxRowNumber: Int = 5
    fileprivate let positiveNonModifiableKey = "Non-modifiable with positive impact"
    fileprivate let negativeNonModifiableKey = "Non-modifiable with negative impact"
    fileprivate let transientKey = "Non-modifiable but only transient"
    class func createWithFrame(_ frame: CGRect, cellHeight: CGFloat, headerHeight: CGFloat, footerHeight: CGFloat) -> CardsResultDisplayTableView {
        let table = CardsResultDisplayTableView(frame: frame, style: .plain)
        
        // UI
        table.bounces = false
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .none
        
        // size
        table.cellHeight = cellHeight
        table.headerHeight = headerHeight
        table.footerHeight = footerHeight
        
        // data
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel ) {
        self.measurement = measurement
        
        let lowGood = MatchedCardsDisplayModel.checkLowHighOfRisk(measurement.riskKey!)
        var positive = [CardInfoObjModel]()
        var negative = [CardInfoObjModel]()
        var transient = [CardInfoObjModel]()
        var sortedDic = [String : [CardInfoObjModel]]()
        for value in measurement.values {
            if let match = collection.getMatch(value.matchKey) {
                // if match.info[“NonActionable”] = false then do not display this card match at all
                if match.nonActionable != nil && match.nonActionable! {
                    continue
                }
            }
            
            if let card = collection.getCardOfMetric(value.metricKey, matchKey: value.matchKey, inRisk: measurement.riskKey!) {
                // not score card, ignore
                if !card.isScorecardInRisk(measurement.riskKey!) {
                    continue 
                }
                
                // sort
                // transient
                if let match = collection.getMatch(value.matchKey) {
                    if match.transient != nil && match.transient! {
                        transient.append(card)
                        continue
                    }
                }
                
        
                // other
                if let iden = card.getIdenInMeasurement(measurement) {
                    // non modifible
                    if card.nonModifiable != nil && card.nonModifiable! {
                        let score = Int(MatchedCardsDisplayModel.getValueOfIden(iden))
                        if score == 0 {
                            lowGood ? positive.append(card) : negative.append(card)
                        }else {
                            lowGood ? negative.append(card) : positive.append(card)
                        }
                    }else {
                        // normal
                        if sortedDic[iden] == nil {
                            sortedDic[iden] = [card]
                        }else {
                            sortedDic[iden]!.append(card)
                        }
                    }
                }
            }
        }
        
        // assign
        cardsGroup.removeAll()
    
        for (key, value) in sortedDic {
            cardsGroup.append((key, value))
        }
        if lowGood {
            cardsGroup.sort(by: { MatchedCardsDisplayModel.getValueOfIden($0.0) < MatchedCardsDisplayModel.getValueOfIden($1.0)})
        }else {
            // from high score to low score
            cardsGroup.sort(by: { MatchedCardsDisplayModel.getValueOfIden($0.0) > MatchedCardsDisplayModel.getValueOfIden($1.0)})
        }
        
        if positive.count != 0 {
            cardsGroup.append((positiveNonModifiableKey, positive))
        }
        
        if negative.count != 0 {
            cardsGroup.append((negativeNonModifiableKey, negative))
        }
        
        
        if transient.count != 0 {
            cardsGroup.append((transientKey, transient))
        }
        
        headerHeights.removeAll()
        for i in 0..<cardsGroup.count {
            headerHeights[i] = headerHeight
        }
        
        reloadData()
    }
    
    // dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return cardsGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == focusedSection ? cardsGroup[section].1.count : min(maxRowNumber, cardsGroup[section].1.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = cardsGroup[indexPath.section].1[indexPath.row]
        // draw the assessment color regardless the card types (regular, transient, non-modifiable etc)
        let iden = card.getIdenInMeasurement(self.measurement)
        // this code only draw color for regular cards
        //let iden = cardsGroup[indexPath.section].0
        // cell
        let color = MatchedCardsDisplayModel.getColorOfIden(iden)
        let cell = CardsResultDisplayTableViewCell.cellWithTable(tableView, card: card, measurement: measurement, color: color, fontSize: cellHeight * 12 / 65)
        
        return cell
    }
    
    // delegate
    fileprivate var headerHeights = [Int: CGFloat]()
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight))
        header.backgroundColor = UIColor.white
        
        // bar
        let imageL = headerHeight * 0.6
        let barMargin = imageL * 0.7
        let barFrame = CGRect(x: 0, y: headerHeight * 0.06, width: bounds.width - barMargin, height: headerHeight * 0.3)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = barFrame
        gradientLayer.locations = [0.3, 1]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
    
        // fill
        let iden = cardsGroup[section].0
        var color = MatchedCardsDisplayModel.getColorOfIden(iden)
        if iden == negativeNonModifiableKey {
            color = UIColor.red
        }else if iden == positiveNonModifiableKey {
            color = UIColor.green
        }else if iden == transientKey {
            color = UIColor.purple
        }
        gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0.01).cgColor]
        
        header.layer.addSublayer(gradientLayer)
        
        // image
        let iconImage = UIImageView(frame: CGRect(x: bounds.width - imageL * 0.5 - barMargin, y: 0, width: imageL, height: imageL))
        iconImage.contentMode = .scaleAspectFit
        let imageIden = (iden == negativeNonModifiableKey || iden == positiveNonModifiableKey || iden == transientKey) ? notFeasibleKey : iden
        let recommendationImageUrl = collection.getClassificationByKey(imageIden)?.recommendationImageUrl
        iconImage.sd_setImage(with: recommendationImageUrl, placeholderImage: nil, options: .refreshCached, completed: nil)
        header.addSubview(iconImage)
        
        // title
        let leftL = bounds.width * 0.045
        let text = MatchedCardsDisplayModel.getRecomendataionOfIden(iden)
        let titleBackLabel = UILabel(frame: CGRect(x: leftL, y: barFrame.minY, width: iconImage.frame.minX - leftL, height: barFrame.height))
        let titleFont = UIFont.systemFont(ofSize: min(barFrame.height * 0.6,titleBackLabel.frame.width * 0.045), weight: .medium)
        titleBackLabel.attributedText = NSAttributedString(string: text, attributes: [.strokeWidth: NSNumber(value: -15), .font: titleFont])
        header.addSubview(titleBackLabel)
        
        let titleLabel = UILabel(frame: titleBackLabel.frame)
        titleLabel.textColor = UIColor.white
        titleLabel.text = text
        titleLabel.font = titleFont
        header.addSubview(titleLabel)
        
        // objective
        let detailLabel = UILabel(frame: CGRect(x: leftL, y: barFrame.maxY, width: titleLabel.frame.width, height: bounds.height))
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: barFrame.height * 0.45)
        
        var objectiveString = collection.getClassificationByKey(iden)?.objective ?? "Coming soon."
        let positiveObjective = "Congratulations! But don’t let up on your effort to invest in modifiable changes with positive impact"
        let negativeObjective = "Not your destiny! Consider them as powerful incentive for you to invest in modifiable changes with positive impact"
        if iden == positiveNonModifiableKey {
            objectiveString = positiveObjective
        }else if iden == negativeNonModifiableKey {
            objectiveString = negativeObjective
        }else if iden == transientKey {
            objectiveString = "For precaution, consider consulting with your doctor if any action needs to be taken."
        }
        
        detailLabel.text = objectiveString
        header.addSubview(detailLabel)
        detailLabel.adjustWithWidthKept()
        
        // tap
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(headerIsTapped))
        header.tag = 100 + section
        header.addGestureRecognizer(tapGR)
        
        let assume = max(headerHeight, detailLabel.frame.maxY + 10 * fontFactor)
        // assign back
        detailLabel.frame = CGRect(x: leftL, y: barFrame.maxY, width: titleLabel.frame.width, height: assume - barFrame.maxY)
        
        if let old = headerHeights[section] {
            if abs(old - assume) < 2 {
                return header
            }
        }
        
        headerHeights[section] = assume
        reloadData()
        
        return header
    }
    
    @objc func headerIsTapped(_ tapGR: UITapGestureRecognizer) {
        let section = tapGR.view!.tag - 100
        scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if  cardsGroup[section].1.count > maxRowNumber {
            // see more
            let seeMoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: footerHeight))
            seeMoreLabel.backgroundColor = UIColor.white
            seeMoreLabel.textColor = UIColorFromHex(0x00C853)
            
            seeMoreLabel.textAlignment = .center
            seeMoreLabel.font = UIFont.systemFont(ofSize: footerHeight * 0.5, weight: .medium)
            seeMoreLabel.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(showMore))
            seeMoreLabel.tag = section + 200
            seeMoreLabel.addGestureRecognizer(tap)
            
            if section != focusedSection {
                seeMoreLabel.text = "See More ⌵"
            }else {
                seeMoreLabel.text = "Hide ⌃"
            }
            
            return seeMoreLabel
        }else {
            return UIView()
        }
    }
    
    @objc func showMore(_ tapGR: UITapGestureRecognizer) {
        let section = tapGR.view!.tag - 200
        if section == focusedSection {
            focusedSection = -1
            beginUpdates()
            reloadSections(IndexSet(integer: section), with: .automatic)
            endUpdates()
        }else {
            if focusedSection == -1 {
                focusedSection = section
                beginUpdates()
                reloadSections(IndexSet(integer: section), with: .automatic)
                endUpdates()
            }else {
                focusedSection = section
                reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeights[section] ?? headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    // action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cardsGroup[indexPath.section].1[indexPath.item]
        let cardVC = CardAnswerChangeViewController()
        cardVC.forChange = false
        cardVC.loadWithCard(card)
        viewController.presentOverCurrentViewController(cardVC, completion: nil)
    }
}
