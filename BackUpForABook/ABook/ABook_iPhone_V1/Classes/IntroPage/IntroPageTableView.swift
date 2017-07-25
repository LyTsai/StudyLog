//
//  IntroPageTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/13.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IntroPageTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    // current attached risk class (catergory)
    var riskMetric = MetricObjModel() {
        didSet{
            loadRiskAlgorithms()
            adjustUI()
            reloadData()
        }
    }
    weak var hostNavi: UINavigationController!
    
    // risk models of current attached risk class
    fileprivate var riskModels = [RiskObjModel]()
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 5)
    fileprivate var foldState: [Int: Bool] = [1: false, 3: true, 4: true]
    
    // MARK: ---------- methods -----------------------
    class func createTableViewWith(_ frame: CGRect, riskMetric: MetricObjModel) -> IntroPageTableView {
        let table = IntroPageTableView(frame: frame, style: .plain)
        table.riskMetric = riskMetric
        table.setupUI()
        
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    fileprivate func loadRiskAlgorithms() {
        riskModels = riskMetric.key == nil ? [RiskObjModel]() : AIDMetricCardsCollection.standardCollection.getModelsOfRiskClass(riskMetric.key!)
    }
    
    fileprivate func adjustUI() {
        let userDefault = UserDefaults.standard
        let stateKey = "\(riskMetric.key!) is checked"
        
        if userDefault.value(forKey: stateKey) == nil {
            foldState[1] = false
            userDefault.set(true, forKey: stateKey)
            userDefault.synchronize()
        }else {
            foldState[1] = true
        }

        // TODO: is the algo checked by user? can be get from user recent checked
        selectedIndexPath = IndexPath(row: 0, section: 5)
    }
    
    
    // frame
    fileprivate func setupUI() {
        // add teacher image
        let wHRatio: CGFloat = 77.09 / 96
        let width = 0.18 * bounds.width
        let marginGap = bounds.width / 75.0
        
        let teacher = UIImageView(frame: CGRect(x: bounds.width - width * 1.1, y: marginGap, width: width, height: width / wHRatio))
        teacher.image = UIImage(named: "teacher")
        teacher.contentMode = .scaleAspectFit
        addSubview(teacher)
        
        // hide lines if there is no cell
        tableFooterView = UIView()
    }
    
    // MARK: ----------- fake data ----------
    fileprivate var detailText: String {
        return "this is a test for long text and short this is a test for long text and short this is a test for long text and short this is a test for long tet for long text and short short this is a test for long text and short this is a test for long"
    }
    
    fileprivate func testedUserImages(_ index: Int) -> [UIImage] {
        var images = [UIImage]()
        
        if index < 3 {
            return images
        }
        
        // ------- test ---------
        if index == 3 {
            // do nothing
            return images
        }
        
         if index == 4 {
            for _ in 0..<3 {
                let image = UIImage(named: "userIcon")!
                images.append(image)
            }
        }
        
        if index == 5 {
            for _ in 0..<6 {
                let image = UIImage(named: "userIcon")!
                images.append(image)
            }
        }
        
        return images
    }
    
    // MARK: ----------- dataSource
    /*
     section:
     case 0: headerLine, name/picture of RiskClass
     case 1: introduction
     case 2: Thumbnail views
     case 3: knowledge
     case 4: news
     case 5: alogrithm(risks)
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1, 2: return foldState[1] == true ? 0 : 1
        // TODO: news and so on
        case 3: return foldState[3] == true ? 2 : 4
        case 4: return foldState[4] == true ? 0 : 1
        case 5: return riskModels.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // header
            return IntroPageHeaderCell.cellWithTableView(tableView, image: riskMetric.imageObj, name: riskMetric.name, likeNumber: 1130, watchNumber: 2100)
        case 1: // introduce
            var needMore = true
            if selectedIndexPath.section == 1 || (calculateHeight() + 20 * standardW < 70 * standardW ){
                needMore = false
            }
            return IntroDetailCell.cellWithTableView(tableView, detailText: detailText, needMore: needMore)
        case 2: // buttons
            return IntroIndicatorsCell.cellWithTableView(tableView)
        case 3: return IntroRiskClassKnowledgeCell.cellWithTableView(tableView, articalImage: nil, title: nil, publishDate: nil
        , authorName: nil)
        case 4: return IntroRiskClassKnowledgeCell.cellWithTableView(tableView, articalImage: nil, title: "This is about News", publishDate: nil
            , authorName: nil)
        default: // algorithms
            // data fill
            let isSelected = (selectedIndexPath == indexPath ? true : false)
            let riskModel = riskModels[indexPath.row]

            let cell = IntroAlgorithmCell.cellWithTableView(tableView, algoKey: riskModel.key!, name: riskModel.name!, authorName: riskModel.author.displayName ?? "unknown", latesetDate: Date(), liked: 930, played: 1000, selected: isSelected, testedUsers: testedUserImages(indexPath.row))
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    // header
    var headerHeight: CGFloat {
        return 40 * standardW
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        if section == 2 || section == 5 {
            return 0.5
        }
        
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // no header
        if section == 0{
            return nil
        }
        if section == 2   || section == 5 {
            let seperatorView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.5))
            seperatorView.backgroundColor = UIColor.lightGray
            return seperatorView
        }
        // super for add
        let headerView = UIButton(frame: CGRect(x: -1, y: 0, width: bounds.width + 2, height: headerHeight))
        headerView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.layer.borderWidth = 0.5
        headerView.backgroundColor = UIColor.white
        headerView.addTarget(self, action: #selector(changeFoldState(_:)), for: .touchUpInside)
        
        let margin: CGFloat = 26 // 25 in view
        let indiWidth: CGFloat = 56 * bounds.width / 365
        
        let headerLabel = UILabel(frame: CGRect(x: margin, y: 0, width: headerView.bounds.width - 2 * margin - indiWidth, height: headerHeight))
        headerLabel.numberOfLines = 0
        headerLabel.font = UIFont.systemFont(ofSize: headerHeight / 2.5, weight: UIFontWeightSemibold)
        headerView.addSubview(headerLabel)
        
        let indiLabel = UILabel()
        indiLabel.textAlignment = .center
        indiLabel.font = UIFont.systemFont(ofSize: headerHeight / 3.5)
        headerView.addSubview(indiLabel)
        
        let maxX = headerView.bounds.width - margin
        let imageLength = 13.5 * headerHeight / 40
        let indiImageView = UIImageView(frame: CGRect(x: maxX - imageLength, y: (headerHeight - imageLength) * 0.5, width: imageLength, height: imageLength))
        indiImageView.image = UIImage(named: "arrow_down_green")
        indiImageView.contentMode = .scaleAspectFit
        headerView.addSubview(indiImageView)
        
        if section == 1 {
            headerView.tag = 1
            let titleColor = UIColorFromRGB(57, green: 181, blue: 74)
            let indiColor = UIColorFromRGB(0, green: 200, blue: 83)
            
            headerLabel.text = "Introduction to \(riskMetric.name!)"
            headerLabel.textColor = titleColor
            
//            indiLabel.isHidden = !foldState[1]!
//            indiImageView.isHidden = !foldState[1]!
            
            indiLabel.frame = CGRect(x: headerLabel.frame.maxX, y: 0, width: indiWidth - imageLength, height: headerHeight)
            indiLabel.text = foldState[1] == true ? "展开" : "收起"
            indiLabel.textColor = indiColor
            
            indiImageView.transform = (foldState[1] == true ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: -CGFloat(M_PI)))
            
        } else if section == 3 {
            headerView.tag = 3
            headerLabel.text = "与 \(riskMetric.name!) 相关的知识"
            
            indiLabel.frame = CGRect(x: headerLabel.frame.maxX, y: headerHeight * 0.25, width: indiWidth, height: headerHeight * 0.5)
            indiLabel.backgroundColor = UIColorGray(216)
            indiLabel.textColor = UIColorGray(155)
            indiLabel.layer.borderWidth = 0.4
            indiLabel.layer.borderColor = UIColorGray(155).cgColor
            indiLabel.layer.cornerRadius = 5
            indiLabel.layer.masksToBounds = true
            
            indiLabel.text = "更多内容"
       
            indiImageView.isHidden = true
            
        } else if section == 4 {
            headerView.tag = 4
            headerLabel.text = "与 \(riskMetric.name!) 相关的新闻"
            
            indiLabel.isHidden = true
            
            indiImageView.transform = (foldState[4] == true ? CGAffineTransform(rotationAngle: -CGFloat(M_PI_2)) : CGAffineTransform.identity)
        }
        return headerView
    }
    
    // MARK: ----------- height ---------
    fileprivate var standardW: CGFloat {
        return bounds.width / 375
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 92 * standardW
        case 1:
            // show for the first time
            if selectedIndexPath.section != 1 {
                return 70 * standardW
            }
            // show
            let maxHeight = calculateHeight() + 20 * standardW
            return min(400 * standardW, maxHeight)
        case 2: return 150 * standardW
        case 3: return 90 * standardW
        case 4: return 90 * standardW
        default:
            if selectedIndexPath == indexPath {
                return 134 * standardW
            } else {
                return 70 * standardW
            }
        }
    }
    
    fileprivate func calculateHeight() -> CGFloat {
        let width = bounds.width * (1 - 0.072 * 2)
        let nsText = NSString(string: detailText)
        let size = nsText.boundingRect(with: CGSize(width: width, height: 10000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
        return size.height
    }
    
    // select
    func changeFoldState(_ button: UIButton) {
        let tag = button.tag
        foldState[tag] = !foldState[tag]!
        
        if tag == 1 {
            beginUpdates()

            reloadSections(IndexSet(integer: 1), with: .automatic)
            reloadSections(IndexSet(integer: 2), with: .automatic)
            
            endUpdates()
        } else {
            reloadSections(IndexSet(integer: tag), with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 || indexPath.section == 5 {
            if selectedIndexPath == indexPath {
                selectedIndexPath = IndexPath(row: 0, section: 0)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }else {
                let lastIndexPath = selectedIndexPath
                if lastIndexPath.section == 1 && foldState[1] == true {
                    selectedIndexPath = indexPath
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }else {
                    selectedIndexPath = indexPath
                    tableView.reloadRows(at: [lastIndexPath, indexPath], with: .automatic)
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                }
            }
        }
    }
}
