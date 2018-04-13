//
//  IntroPageTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/13.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IntroPageTableView: UITableView {
    var articles = [ArticleObjModel]()
    
    // current attached risk class (catergory)
    var riskMetric = MetricObjModel() {
        didSet{
            reloadRecordInfomation()
            reloadData()
        }
    }
    weak var hostNavi: UINavigationController!
    
    // risk models of current attached risk class
    fileprivate var riskModels = [RiskObjModel]()
    fileprivate var riskTypeKey: String!
        
    // for extension
    fileprivate var buttonState = false
    
    // cell state
    fileprivate enum IntroState {
        // 1. hide all; 2. show the "More"; 3. show all
        case hide,more,show
    }
    fileprivate var introductionState = IntroState.hide
    fileprivate var showRecord = false
//    var selectedRiskIndex = 0
    fileprivate let hitImageView = UIImageView()
    
    // sizes
    // MARK: ----------- height ---------
    fileprivate var lineInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10 * standWP, bottom: 0, right: 10 * standWP)
    }
    
    // MARK: ---------- methods -----------------------
    class func createTableViewWithFrame(_ frame: CGRect, riskMetric: MetricObjModel, riskTypeKey: String?) -> IntroPageTableView {
        let table = IntroPageTableView(frame: frame, style: .plain)
        table.backgroundColor = UIColor.white
        
        table.riskTypeKey = riskTypeKey
        table.riskMetric = riskMetric
        table.setupBasicData()
        
        // delegate
        table.dataSource = table
        table.delegate = table
        
        table.setupUI()
        
        return table
    }
    
    fileprivate func setupBasicData() {
        // data source
        riskModels = riskMetric.key == nil ? [RiskObjModel]() : AIDMetricCardsCollection.standardCollection.getModelsOfRiskClass(riskMetric.key!, riskTypeKey: riskTypeKey)
        if riskModels.count == 0 {
            print("no risk for it")
        }else {
            RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskModels.first!.key
//            selectedRiskIndex = 0
        }
    }
    
    fileprivate func reloadRecordInfomation() {
        showRecord = false
        // if user is logined
        if UserCenter.sharedCenter.userState == .login && riskModels.count > 0 {
            // check play state
            let cardResults = CardSelectionResults.cachedCardProcessingResults
            let focusingRiskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey ?? ""
            
            var isChosen = false
            for (_, risk) in riskModels.enumerated() {
                if risk.key == focusingRiskKey {
                    isChosen = true
                    break
                }
            }
            
            if !isChosen {
                print("selected riskKey is not in current type")
            }else {
                let result = cardResults.getNumberOfCardsPlayedForUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), riskKey: focusingRiskKey)
                showRecord = (result > 0)
            }
        }
        
        introductionState = showRecord ? .hide : .more
    }
    
    // frame
    fileprivate func setupUI() {
        
        // cell line
        if responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            separatorInset = lineInsets
        }
        if responds(to: #selector(setter: UIView.layoutMargins)) {
            layoutMargins = lineInsets
        }
        
        // hide lines if there is no cell
        tableFooterView = UIView()
    }
    
    // MARK: ----------- Metric.info ----------
    // text
    var needMore = true
    fileprivate var detailText: String {
        // metric.info
        let abstracts = riskMetric.info_abstract
        var texts = ""
        
        for (i, abstract) in abstracts.enumerated() {
            if i == 0 {
                // first one, no tab
                texts.append("\(abstract)\n")
            }else {
                texts.append("\t\(abstract)\n")
            }
        }
        
        if texts == "" {
            texts = "No detail information is added now, 😃."
        }
        
        return texts
    }
    
    // images
    fileprivate var metricImages: [Any] {
        return riskMetric.info_graphUrls
    }
}

// MARK: ---------------------- dataSource ----------------------
/*
 section:
 case 0: headerLine, name/picture of RiskClass
 case 1: introduction && Thumbnail views, two cells
 case 2: process of assessment
 case 3: For More: knowledge &&  news
 // discarded: case 4: alogrithm(risks), two kinds of cells
 */
extension IntroPageTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            switch introductionState {
            case .hide: return 0
            case .more: return 1
            case .show: return 2
            }
        case 2:
            return showRecord ? 1 : 0
        default: return 1
        }
    }
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // header
            let riskType = AIDMetricCardsCollection.standardCollection.getRiskTypeByKey(riskTypeKey)
            return IntroPageHeaderCell.cellWithTableView(tableView, imageUrl: riskMetric.imageUrl, name: riskMetric.name, typeName: riskType?.name)
        case 1: // introduce
            if indexPath.row == 0 {
                var hasMore = true
                let space = bounds.height - 60 * fontFactor - headerHeight * 2
                if (calculateHeight() + 20 * fontFactor < space) {
                    hasMore = false
                    needMore = false
                }
                
                if introductionState == .show {
                    hasMore = false
                }
                return IntroDetailCell.cellWithTableView(tableView, detailText: detailText, needMore: hasMore)
            }else {
                return IntroImagesDisplayCell.cellWithTableView(tableView, images: metricImages)
            }
            
        case 2:
            // cards loaded before
            // cards infomation
            let focusingKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey!
            let allCards = AIDMetricCardsCollection.standardCollection.getMetricCardOfRisk(focusingKey)
            
            // answered information
            let matched = MatchedCardsDisplayModel.getCurrentMatchedCardsOfRisk(focusingKey)
            
            // cell
            let playStateCell = IntroPlayStateCell.cellWithTableView(tableView, imageUrl: matched.first?.imageUrl, riskName: AIDMetricCardsCollection.standardCollection.getRisk(focusingKey)?.name, answerInfo: " \(UserCenter.sharedCenter.currentGameTargetUser.userInfo().name ?? "Played"): \(matched.count) / \(allCards.count)", answered: matched.count, total: allCards.count)
            playStateCell.hostTable = self
            
            return playStateCell
        default : // news
            let color = UIColorGray(155)
            var cell = tableView.dequeueReusableCell(withIdentifier: "LearnMoreCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "LearnMoreCell")
                cell?.textLabel?.text = "  Learn More about it"
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14 * fontFactor)
                cell?.textLabel?.textColor = color
                cell?.accessoryType = .disclosureIndicator
                cell?.selectionStyle = .none
                cell?.tintColor = color
            }
            
            return cell!
        }
    }
}

// MARK: ---------------------- delegate ----------------------
extension IntroPageTableView: UITableViewDelegate {
    // header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: return nil // no header for first
        case 1:
            // header for introduction
            // back
            let headerView = UIButton(frame: CGRect(x: -fontFactor, y: 0, width: bounds.width + 2 * fontFactor, height: headerHeight))
            headerView.layer.borderColor = UIColor.lightGray.cgColor
            headerView.layer.borderWidth = 0.5 * fontFactor
            headerView.backgroundColor = UIColor.white
           
            // label
            let margin: CGFloat = 24 * fontFactor // 25 in view
            let indiWidth: CGFloat = showRecord ? 60 * fontFactor : 0 // button width
            let titleColor = UIColorFromRGB(80, green: 211, blue: 135)
            
            let headerLabel = UILabel(frame: CGRect(x: margin, y: 0, width: headerView.bounds.width - 2.5 * margin - indiWidth, height: headerHeight))
            headerLabel.numberOfLines = 0
            headerLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: UIFontWeightSemibold)
            var title = riskMetric.info_title ?? "Introduction to \(riskMetric.name!)"

            if title.count < 3 {
                title = "Did You Know?"
            }
            headerLabel.text = title
            headerLabel.textColor = titleColor
            headerView.addSubview(headerLabel)
            
            // button
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: bounds.width - indiWidth - 0.6 * margin, y: 0, width: indiWidth, height: headerHeight)
            button.contentMode = .center
            button.setTitle("Show", for: .normal)
            button.setTitle("Hide", for: .selected)
            button.setTitleColor(titleColor, for: .normal)
            button.setImage(UIImage(named: "arrow_down_green"), for: .normal)
            button.setImage(UIImage(named: "arrow_up_green"), for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: headerHeight * 0.25)
            button.imageView?.contentMode = .scaleAspectFit
            
            // adjust
            let spacing: CGFloat = 2 * fontFactor
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button.imageView!.frame.width - spacing, bottom: 0, right: button.imageView!.frame.width + spacing)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: button.titleLabel!.frame.width, bottom: 0, right: -button.titleLabel!.frame.width)
            // action
            button.addTarget(self, action: #selector(changeIntroState), for: .touchUpInside)
            
            // init state
            headerView.addSubview(button)
            button.isSelected = buttonState
            button.isHidden = !showRecord

            return headerView

        default: // seperatorLine
            let seperatorView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 1))
            seperatorView.backgroundColor = UIColor.lightGray
            return seperatorView
        }
    }
    
    // header
    func changeIntroState(_ button: UIButton)  {
        button.isSelected = !button.isSelected
        buttonState = button.isSelected

        if button.isSelected {
            introductionState = .more
        }else {
            introductionState = .hide
        }
        
        beginUpdates()
        reloadSections(IndexSet(integer: 1), with: .automatic)
        endUpdates()
    }

    var headerHeight: CGFloat {
        return 50 * fontFactor
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else if section == 1 {
            return headerHeight
        }
        return 1
    }
    
    // rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let headerCellHeight = 60 * fontFactor
        let remainedHeight = bounds.height - headerCellHeight - headerHeight * 2
        switch indexPath.section {
        case 0: return headerCellHeight
        case 1:
            if indexPath.row == 0 {
                switch introductionState {
                case .hide: return 0
                case .more: return remainedHeight
                case .show: return max(calculateHeight() + 10 * fontFactor, remainedHeight)
                }
            }else {
                // images
                return metricImages.count == 0 ? 0.1 : 150 * fontFactor
            }
        case 2: return remainedHeight
        default: return headerHeight
        }
    }
    
    fileprivate func calculateHeight() -> CGFloat {
        let width = bounds.width * (1 - 0.072 * 2)
        let nsText = NSString(string: detailText)
        let size = nsText.boundingRect(with: CGSize(width: width, height: 10000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14 * fontFactor)], context: nil)
        return size.height
    }
    
    // cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // introduce
        if indexPath.section == 1 {
            // no detail, return
            if !needMore && metricImages.count == 0 {
                print("no need to unfold")
                return
            }
            
            // has detail
            if introductionState == .more {
                introductionState = .show
            }else {
                introductionState = .more
            }
        }else if indexPath.section == 3 {
            // go to article
            let articlesVC = IntroPageArticlesViewController()
            hostNavi.pushViewController(articlesVC, animated: true)
            
            introductionState = showRecord ? .hide : .more
        }else if indexPath.section == 2 {
            // risks
//            if selectedRiskIndex != indexPath.row {
//                selectedRiskIndex = indexPath.row
//                RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskModels[selectedRiskIndex].key
//
//                reloadRecordInfomation()
//                reloadData()
//                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//                return
//            }
        }
        
        // update the introduce
        beginUpdates()
        reloadSections(IndexSet(integer: 1), with: .automatic)
        endUpdates()
    }
    
    // cell line
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = lineInsets
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = lineInsets
        }
        
        if indexPath == IndexPath(row: 1, section: 4) {
            hitImageView.isHidden = true
        }
    }
}
