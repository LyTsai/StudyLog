//
//  AuthorPullDown.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/7.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// class of risk model selection for given risk class.  !!! risk class is defined as metric type that can be modeled, measured or computed.  The GUI will display avialible risk classes and allow user to chose specific acutal risk model for evaluation.  

let authorCellIdentifier = "RiskModelAuthorCell"
class AuthorCell: UITableViewCell {
    fileprivate var authorSelectView: AuthorSelectView!
    // riskClass - risk class
    // riskModel - risk model for riskClass
    class func cellWithTableView(_ tableView: UITableView, riskClass: MetricModel, riskModel: RiskModel) -> AuthorCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: authorCellIdentifier) as? AuthorCell
        if cell == nil {
            cell = AuthorCell(style: .default, reuseIdentifier: authorCellIdentifier)
            cell!.authorSelectView = AuthorSelectView.createAuthorSelectViewWithRisk(riskClass, riskModel: riskModel)
            cell!.authorSelectView.barLayer.isHidden = true
            cell!.authorSelectView.layer.borderColor = UIColor.lightGray.cgColor
            cell!.authorSelectView.layer.borderWidth = 1
            cell!.addSubview(cell!.authorSelectView)
        }
        
        cell!.authorSelectView.riskClass = riskClass
        cell!.authorSelectView.riskModel = riskModel
        
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorSelectView.frame = bounds.insetBy(dx: 1, dy: 0.5)
    }
    
}

class AuthorPullDownTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    weak var assessmentDelegate: AssessmentInfoView!
    
    // attached risk class
    var riskClass = MetricModel() {
        didSet{ reloadData() }
    }
    
    // attached risk models for user to select
    var riskModels = [RiskModel]() {
        didSet{ reloadData() }
    }
    
    class func createPullDownTableWithFrame(_ frame: CGRect, riskClass: MetricModel, riskModels: [RiskModel]) -> AuthorPullDownTableView {
        let table = AuthorPullDownTableView(frame: frame, style: .plain)
        
        table.dataSource = table
        table.delegate = table
        
        table.riskClass = riskClass
        table.riskModels = riskModels
        table.backgroundColor = UIColor.white
        table.separatorColor = UIColor.clear
        
        return table
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riskModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AuthorCell.cellWithTableView(tableView, riskClass: riskClass, riskModel: riskModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if riskModels.count >= 4 {
            return bounds.height / 4.0
        } else {
            return bounds.height / CGFloat(riskModels.count)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assessmentDelegate.updateWithRiskModel(riskModels[indexPath.row])
    }
    
    // Set Footer
    fileprivate let footerHeight: CGFloat = 20
    fileprivate var needFooter: Bool {
        let numberOfRows = riskModels.count
        if numberOfRows > 4 {
            return true
        }else {
            return false
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if needFooter == false {
            return nil
        }
        
        let footerFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: footerHeight))
        let footer = UIView(frame: footerFrame)
        footer.backgroundColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: bounds.midX - footerHeight * 0.5, y: 0, width: footerHeight, height: footerHeight))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pullIndicator")
        footer.addSubview(imageView)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if needFooter == false {
            return 0
        }
        return footerHeight
    }

}
