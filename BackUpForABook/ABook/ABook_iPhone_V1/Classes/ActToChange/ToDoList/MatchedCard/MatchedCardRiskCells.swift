//
//  MatchedCardRiskCells.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let matchedRiskID = "matched risk identifier"
class MatchedCardRiskCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var riskDetailView: MatchedRiskDetailCollectionView!
    
    class func cellWithTableView( _ tableView: UITableView, metric: MetricObjModel, risks: [RiskObjModel]) -> MatchedCardRiskCell {
        var riskCell = tableView.dequeueReusableCell(withIdentifier: matchedRiskID) as? MatchedCardRiskCell
        
        if riskCell == nil {
            riskCell = Bundle.main.loadNibNamed("MatchedCardRiskCells", owner: self, options: nil)?[0] as? MatchedCardRiskCell
            riskCell!.iconImageView.layer.cornerRadius = 4
        }
        
        riskCell!.iconImageView.image = metric.imageObj
        riskCell!.titleLabel.text = metric.name
        riskCell!.riskDetailView.risks = risks
        
        return riskCell!
    }
}

let matchedRiskDetailID = "matched Risk Detail Identifier"
class MatchedRiskDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var riskIndexLabel: UILabel!
    @IBOutlet weak var riskNameLabel: UILabel!
    @IBOutlet weak var riskInfoLabel: UILabel!
    
    func setupWithIndex(_ index: Int, risk: RiskObjModel) {
        riskIndexLabel.text = "\(index + 1)"
        riskNameLabel.text = risk.name
        // TODO: ------- author info + created date
        riskInfoLabel.text = risk.info
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        riskIndexLabel.layer.masksToBounds = true
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        riskIndexLabel.layer.cornerRadius = riskIndexLabel.bounds.width * 0.5
        
        // font adjust
        riskIndexLabel.font = UIFont.systemFont(ofSize: riskIndexLabel.bounds.width * 0.75, weight: UIFontWeightLight)
        riskNameLabel.font = UIFont.systemFont(ofSize: riskNameLabel.bounds.height * 0.8, weight: UIFontWeightLight)
    }
}

class MatchedRiskDetailCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var risks = [RiskObjModel]() {
        didSet{
            if risks != oldValue {
                reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        register(UINib.init(nibName: "MatchedRiskDetailCell", bundle: Bundle.main), forCellWithReuseIdentifier: matchedRiskDetailID)
        
        self.dataSource = self
        self.delegate = self
    }
    
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return risks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let riskDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedRiskDetailID, for: indexPath) as! MatchedRiskDetailCell
        riskDetailCell.layoutIfNeeded()
        riskDetailCell.setupWithIndex(indexPath.item, risk: risks[indexPath.item])
        
        return riskDetailCell
    }
    
    // size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width * 0.5 - 5, height: bounds.height)
    }

}
		
