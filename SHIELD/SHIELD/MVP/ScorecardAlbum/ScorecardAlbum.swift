//
//  ScorecardAlbum.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/7.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class ScorecardAlbumCellMain: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var riskTypeLabel: UILabel!
    
    @IBOutlet weak var resultBar: ScorecardResultBar!
    
    @IBOutlet weak var playedNumber: UILabel!
    
    fileprivate func basicSetup() {
        riskTypeLabel.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        
        riskTypeLabel.layer.shadowOffset = CGSize.zero
        riskTypeLabel.layer.shadowOpacity = 0.6
        riskTypeLabel.layer.shadowColor = UIColor.black.cgColor
        
        iconImageView.layer.shadowOffset = CGSize.zero
        iconImageView.layer.shadowOpacity = 0.6
    }
    
    func setupWithRisk(_ riskKey: String, measurement: MeasurementObjModel!, sortRule: AlbumSortRule) {
        basicSetup()
        let played = (measurement == nil ? 0 : MatchedCardsDisplayModel.getMatchedScoreCardsInMeaurement(measurement).count)
        let total = collection.getScoreCardsOfRisk(riskKey).count // collection.getNumberOfTotalCards(riskKey)//
      
        if let risk = collection.getRisk(riskKey) {
            let riskTypeKey = risk.riskTypeKey!
            riskTypeLabel.text = collection.getAbbreviationOfRiskType(riskTypeKey)
            iconImageView.sd_setImage(with: risk.metric!.imageUrl, completed: nil)
            
            let typeColor = collection.getRiskTypeByKey(riskTypeKey)!.realColor ?? tabTintGreen
            riskTypeLabel.backgroundColor = typeColor
            iconImageView.layer.borderColor = typeColor.cgColor
            iconImageView.layer.shadowColor = typeColor.cgColor
            
            playedNumber.text = "\(played)/\(total)"
            
            // bar
            resultBar.drawScore = (collection.getTierOfRisk(riskKey) != 2)
            resultBar.started = (played != 0)
            if resultBar.started {
                if !resultBar.drawScore {
                    let playResult = MatchedCardsDisplayModel.getScoredClassifiedCardsInMeasurement(measurement, badToGood: true)
//                    getAllClassifiedCardsInMeasurement(measurement, badToGood: true)
                    var drawInfo = [(color: UIColor, number: Int)]()
                    for (iden, result) in playResult {
                        drawInfo.append((MatchedCardsDisplayModel.getColorOfIden(iden), result.count))
                    }
                    resultBar.totalNumber = total
                    resultBar.drawInfo = drawInfo
                }else {
                    resultBar.score = MatchedCardsDisplayModel.getTotalScoreOfMeasurement(measurement)
                    resultBar.maxScore = MatchedCardsDisplayModel.getMaxScoreOfRisk(riskKey)
                    if let resultC = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(measurement) {
                        let classification = resultC.classification
                        resultBar.scoreClassificationName = classification?.displayName ?? "not added yet"
                        resultBar.scoreBackColor = classification?.realColor ?? tabTintGreen
                    }
                }
            }
            resultBar.setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // fonts
        resultBar.setNeedsDisplay()
        
        let lineWidth = bounds.height / 45
        iconImageView.layer.cornerRadius = iconImageView.bounds.height * 0.5
        iconImageView.layer.borderWidth = lineWidth * 1.5
        riskTypeLabel.layer.cornerRadius = riskTypeLabel.bounds.height * 0.5
        
        // fonts
        playedNumber.font =  UIFont.systemFont(ofSize: 10 * lineWidth, weight: .medium)
        riskTypeLabel.font = UIFont.systemFont(ofSize: 8 * lineWidth, weight: .semibold)
        
        // shadow
        iconImageView.layer.shadowRadius = lineWidth
        riskTypeLabel.layer.shadowOffset = CGSize(width: 0, height: lineWidth)
        riskTypeLabel.layer.shadowRadius = lineWidth
    }
    
}

// cell view
let scorecardAlbumCellID = "scorecard album cell identifier"
class ScorecardAlbumCell: UITableViewCell {
    fileprivate let dateLabel = UILabel()
    fileprivate let playButton = UIButton(type: .custom)
    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate let cellMaskLayer = CAShapeLayer()
    fileprivate var isLast = false
    
    // risk cell
    fileprivate let cellMain = Bundle.main.loadNibNamed("ScorecardAlbum", owner: self, options: nil)![1] as! ScorecardAlbumCellMain
    fileprivate let detailLabel = UILabel()
    fileprivate let detailBack = CAShapeLayer()
    fileprivate var played = 0
    fileprivate var total = 0
    fileprivate var riskKey: String!
    fileprivate var measurement: MeasurementObjModel!
    class func cellWithTableView(_ tableView: UITableView, riskKey: String, measurement: MeasurementObjModel!, sortRule: AlbumSortRule, isLast: Bool, row: Int) -> ScorecardAlbumCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: scorecardAlbumCellID) as? ScorecardAlbumCell
        
        if cell == nil {
            cell = ScorecardAlbumCell(style: .default, reuseIdentifier: scorecardAlbumCellID)
            cell?.addExtraSetup()
        }
        
        cell?.riskKey = riskKey
        cell?.measurement = measurement
        cell?.played = (measurement == nil ? 0 : measurement.values.count)
        cell?.total = collection.getAllDisplayCardsOfRisk(riskKey).count
        
        cell?.cellMain.setupWithRisk(riskKey, measurement: measurement, sortRule: sortRule)
        let mainColor = row % 2 == 0 ? UIColorFromRGB(244, green: 248, blue: 251) : UIColor.white
        cell!.backgroundColor = mainColor
        cell!.isLast = isLast
        
        if let risk = collection.getRisk(riskKey) {
            cell?.detailLabel.text = "\(risk.metric?.name ?? "")\n-\(collection.getFullNameOfRiskType(risk.riskTypeKey!))"
        }
        
        // special
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var time = Date()
        if measurement != nil {
            time = measurement.time
        }
        cell!.dateLabel.text = formatter.string(from: time)
        
        cell?.playButton.setTitle(cell?.played == 0 ? "Play" : "Continue", for: .normal)
        cell?.playButton.backgroundColor = (cell?.played == 0 ? tabTintGreen : UIColor.orange)
        cell?.detailBack.isHidden = true
        
        return cell!
    }
    
    fileprivate func addExtraSetup() {
        selectionStyle = .none
        
        detailLabel.numberOfLines = 0
        detailLabel.backgroundColor = UIColor.clear
        detailBack.fillColor = UIColorFromRGB(255, green: 253, blue: 234).cgColor
        
        contentView.addSubview(cellMain)
        contentView.addSubview(playButton)
        contentView.addSubview(dateLabel)
        
        detailBack.lineWidth = 0
        contentView.layer.addSublayer(detailBack)
        detailBack.addSublayer(detailLabel.layer)
        
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.masksToBounds = true
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColorFromRGB(209, green: 211, blue: 212).cgColor
        layer.addSublayer(shapeLayer)
        
        cellMaskLayer.fillColor = UIColor.red.cgColor
        layer.mask = cellMaskLayer
        
        playButton.setTitleColor(UIColor.white, for: .normal)
        playButton.addTarget(self, action: #selector(playGame(_:)), for: .touchUpInside)
        

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(showScorecard))
        cellMain.resultBar.addGestureRecognizer(tapGR)
        
        let showDetail = UITapGestureRecognizer(target: self, action: #selector(showOrHideDetail))
        cellMain.iconImageView.addGestureRecognizer(showDetail)
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth = bounds.height / 45
        cellMain.frame = CGRect(x: 5 * lineWidth, y: 0 , width: bounds.width * 0.8, height: bounds.height)
        
        shapeLayer.lineWidth = lineWidth * 2
        shapeLayer.path = isLast ? UIBezierPath(roundedRect: bounds.insetBy(dx: 0, dy: -lineWidth * 0.75), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8 * lineWidth, height: 8 * lineWidth)).cgPath : UIBezierPath(rect: bounds).cgPath
        cellMaskLayer.path = shapeLayer.path
        
        let leftRect = CGRect(x: cellMain.frame.maxX, y: 0, width: bounds.width - cellMain.frame.maxX, height: bounds.height).insetBy(dx: 3 * lineWidth, dy: 3 * lineWidth)
        if played == 0 {
            dateLabel.frame = CGRect.zero
            playButton.frame = leftRect.insetBy(dx: 0, dy: 5 * lineWidth)
        }else if played == total {
            dateLabel.frame = leftRect
            playButton.frame = CGRect.zero
        }else {
            dateLabel.frame = CGRect(x: leftRect.minX, y: leftRect.minY, width: leftRect.width, height: leftRect.height * 0.4)
            playButton.frame = CGRect(x: leftRect.minX, y: dateLabel.frame.maxY, width: leftRect.width, height: leftRect.maxY -  dateLabel.frame.maxY)
        }

        dateLabel.font = UIFont.systemFont(ofSize: 10 * lineWidth, weight: .medium)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 10 * lineWidth, weight: .semibold)
        playButton.layer.cornerRadius = playButton.bounds.height * 0.5
        playButton.layer.addBlackShadow(lineWidth * 1.5)
        playButton.layer.borderWidth = lineWidth
        
        
        detailLabel.font = UIFont.systemFont(ofSize: 10 * lineWidth, weight: .regular)
        let imageRect = cellMain.iconImageView.frame
        let arrowP = cellMain.convert(CGPoint(x: imageRect.maxX, y: imageRect.midX), to: self)
        let detailFrame = CGRect(x: arrowP.x, y: 0, width: bounds.width - arrowP.x, height: bounds.height).insetBy(dx: lineWidth * 4, dy: lineWidth * 3)
        detailBack.frame = detailFrame
        
        let arrowW = lineWidth * 3
        let path = UIBezierPath(roundedRect: CGRect(x: arrowW, y: 0, width: detailBack.bounds.width - arrowW, height: detailBack.bounds.height), cornerRadius: 4 * lineWidth)
        
        path.move(to: CGPoint(x: arrowW, y: detailBack.bounds.midY + arrowW))
        path.addLine(to: CGPoint(x: 0, y: detailBack.bounds.midY))
        path.addLine(to: CGPoint(x: arrowW, y: detailBack.bounds.midY - arrowW))
        
        detailBack.path = path.cgPath
        detailBack.addBlackShadow(lineWidth)
        detailLabel.frame = CGRect(x: arrowW * 2, y: lineWidth, width: detailFrame.width - arrowW * 2, height: detailFrame.height - 2 * lineWidth)
    }
    
    // actions
    @objc func showScorecard() {
        if measurement != nil {
            let scoreCardVC = SingleScorecardViewController()
            
            scoreCardVC.setupWithMeasurement(measurement)
            scoreCardVC.modalTransitionStyle = .flipHorizontal
            viewController.presentOverCurrentViewController(scoreCardVC, completion: nil)
        }
    }
    
    @objc func showOrHideDetail() {
        detailBack.isHidden = !detailBack.isHidden
    }
    
    @objc func playGame(_ sender: UIButton) {
        // focus
        let risk = collection.getRisk(riskKey)!
        cardsCursor.riskTypeKey = risk.riskTypeKey!
        cardsCursor.selectedRiskClassKey = risk.metricKey
        cardsCursor.focusingRiskKey = riskKey
        
        let categoryVC = CategoryViewController()
        navigation.pushViewController(categoryVC, animated: true)
    }
}