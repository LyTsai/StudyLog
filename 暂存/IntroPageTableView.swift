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
    fileprivate var selectedRiskIndex = 0
    fileprivate let hitImageView = UIImageView()
    
    // sizes
    // MARK: ----------- height ---------
    fileprivate var standardW: CGFloat {
        return bounds.width / 375
    }
    
    fileprivate var lineInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10 * standardW, bottom: 0, right: 10 * standardW)
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
            selectedRiskIndex = 0
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
            for (i, risk) in riskModels.enumerated() {
                if risk.key == focusingRiskKey {
                    selectedRiskIndex = i
                    isChosen = true
                    break
                }
            }
            
            if !isChosen {
                print("selected riskKey is not in current type")
            }else {
                if let all = cardResults.getUserSelections(UserCenter.sharedCenter.currentGameTargetUser) {
                    if let result = all[focusingRiskKey] {
                        showRecord = (result.count > 0)
                    }
                }
            }
        }
        
        introductionState = showRecord ? .hide : .more
    }
    
    // frame
    fileprivate func setupUI() {
        // add teacher image
        let wHRatio: CGFloat = 77.09 / 96
        let imageWidth = 0.18 * bounds.width
        
        let teacher = UIImageView(frame: CGRect(x: bounds.width - imageWidth * 1.1, y: 12, width: imageWidth, height: imageWidth / wHRatio))
        teacher.image = UIImage(named: "teacher")
        teacher.contentMode = .scaleAspectFit
        addSubview(teacher)
        
        // cell line
        if responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            separatorInset = lineInsets
        }
        if responds(to: #selector(setter: UIView.layoutMargins)) {
            layoutMargins = lineInsets
        }
        
        // hide lines if there is no cell
        tableFooterView = UIView()
        
        // hitImageView
        let hitImage = UIImage(named: "arrow_hintForMore")
        hitImageView.image = hitImage
        let size = hitImage!.size
        hitImageView.frame = CGRect(x: (bounds.width - size.width) * 0.5, y: 340 * standardW, width: size.width, height: size.height)
        addSubview(hitImageView)
        hitImageView.isHidden = (riskModels.count <= 1)
    }
    
    // MARK: ----------- Metric.info ----------
    // text
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
            texts = "No detail Infomation is added Now, 😃. You can touch to see the images."
        }
        
        return texts
    }
    
    // images
    fileprivate var metricImages: [Any] {
        var images = [UIImage]()
        let urls = riskMetric.info_graphUrls

        if urls.count == 0 {
            let pageNames = ["indi_cards", "indi_summary", "indi_overall", "indi_advice"]
            for name in pageNames {
                images.append(UIImage(named: name)!)
            }
            return images
        }
        
        return urls
    }
}

// MARK: ---------------------- dataSource ----------------------
/*
 section:
 case 0: headerLine, name/picture of RiskClass
 case 1: introduction && Thumbnail views, two cells
 case 2: process of assessment
 case 3: For More: knowledge &&  news
 case 4: alogrithm(risks), two kinds of cells
 */
extension IntroPageTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
        case 4: return riskModels.count
        default: return 1
        }
    }
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // header
            let riskType = AIDMetricCardsCollection.standardCollection.getRiskTypeByKey(riskTypeKey)
            let typeName = riskType?.name ?? "Individualized Risk Assessment"
            
            return IntroPageHeaderCell.cellWithTableView(tableView, imageUrl: riskMetric.imageUrl, name: riskMetric.name, typeName: typeName, likeNumber: 1130, watchNumber: 2100)
        case 1: // introduce
            if indexPath.row == 0 {
                var needMore = true
                if introductionState == .show || (calculateHeight() + 20 * standardW < 70 * standardW) {
                    needMore = false
                }
                return IntroDetailCell.cellWithTableView(tableView, detailText: detailText, needMore: needMore)
            }else {
                return IntroImagesDisplayCell.cellWithTableView(tableView, images: metricImages)
            }
            
        case 2:
            // cards loaded before
            // cards infomation
            let focusingKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey!
            let allCards = AIDMetricCardsCollection.standardCollection.getMetricCardOfRisk(focusingKey)
            
            // answered information
            let answered = MatchedCardsDisplayModel.getCurrentMatchedCards().count
            
            // cell
            let playStateCell = IntroPlayStateCell.cellWithTableView(tableView, imageUrl: allCards.first?.cardOptions.first?.match?.imageUrl, riskName: riskModels[selectedRiskIndex].name, answerInfo: " \(UserCenter.sharedCenter.currentGameTargetUser.userInfo().name ?? "Played"): \(answered) / \(allCards.count)", answered: answered, total: allCards.count)
            playStateCell.hostTable = self
            
            return playStateCell
        case 3: // news
            let color = UIColorGray(155)
            var cell = tableView.dequeueReusableCell(withIdentifier: "LearnMoreCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "LearnMoreCell")
                cell?.textLabel?.text = "   Learn More about it"
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.textLabel?.textColor = color
                cell?.accessoryType = .disclosureIndicator
                cell?.selectionStyle = .none
                cell?.tintColor = color
            }
            
            return cell!
        default: // algorithms
            // data fill
            let riskModel = riskModels[indexPath.row]
            
            // user icons
            let usersPlayed = CardSelectionResults.cachedCardProcessingResults.gatAllUsersPlayedForRisk(riskModel.key)
            var icons = [UIImage?]()
            let textImage = UIImage(named: "userIcon") // #imageLiteral(resourceName: "userIcon")
            
            // is played
            if usersPlayed.count != 0 {
//                var psedoUsers = [PseudoUserObjModel]()
                if usersPlayed[true] != nil {
                    // login user icon
                    icons.append(textImage)
                    
                    // pseudoUsers
                    for key in usersPlayed[true]! {
                        // pseduoUsers
                        icons.append(UIImage(named: "placeHolder"))
                    }
                }else {
                    for key in usersPlayed[false]! {
                        // pseduoUsers
                        icons.append(UIImage(named: "placeHolder"))
                    }
                }
            }
            
            let cell = IntroAlgorithmCell.cellWithTableView(tableView, risk: riskModel, index: indexPath.row, selected: (selectedRiskIndex == indexPath.row), usersPlayed: icons)
            
            return cell
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
            let headerView = UIButton(frame: CGRect(x: -1, y: 0, width: bounds.width + 2, height: headerHeight))
            headerView.layer.borderColor = UIColor.lightGray.cgColor
            headerView.layer.borderWidth = 0.5
            headerView.backgroundColor = UIColor.white
           
            // label
            let margin: CGFloat = 26 * standardW // 25 in view
            let indiWidth: CGFloat = showRecord ? 60 * standardW : 0 // button width
            let titleColor = UIColorFromRGB(80, green: 211, blue: 135)
            
            let headerLabel = UILabel(frame: CGRect(x: margin, y: 0, width: headerView.bounds.width - 2.5 * margin - indiWidth, height: headerHeight))
            headerLabel.numberOfLines = 0
            headerLabel.font = UIFont.systemFont(ofSize: headerHeight * 0.32, weight: UIFontWeightSemibold)
            headerLabel.text = riskMetric.info_title ?? "Introduction to \(riskMetric.name!)"
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
            let spacing: CGFloat = 2 * standardW
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
        return 50 * standardW
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
        let riskCellFull = 180 * standardW
        let headerCellHeight = 93 * standardW
        let remainedHeight = bounds.height - headerCellHeight - riskCellFull - headerHeight * 2
        switch indexPath.section {
        case 0: return headerCellHeight
        case 1:
            if indexPath.row == 0 {
                let maxHeight = calculateHeight() + 10 * standardW
                switch introductionState {
                case .hide: return 0
                case .more: return remainedHeight
                case .show: return maxHeight
                }
            }else {
                // images
                return 150 * standardW
            }
        case 2: return remainedHeight
        case 3: return headerHeight
        default:
            if selectedRiskIndex == indexPath.row {
                return riskCellFull
            } else {
                return 71 * standardW
            }
        }
    }
    
    fileprivate func calculateHeight() -> CGFloat {
        let width = bounds.width * (1 - 0.072 * 2)
        let nsText = NSString(string: detailText)
        let size = nsText.boundingRect(with: CGSize(width: width, height: 10000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
        return size.height
    }
    
    // cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // introduce
        if indexPath.section == 1 {
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
        }else if indexPath.section == 4 {
            // risks
            if selectedRiskIndex != indexPath.row {
                selectedRiskIndex = indexPath.row
                RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskModels[selectedRiskIndex].key

                reloadRecordInfomation()
                reloadData()
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                return
            }
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
