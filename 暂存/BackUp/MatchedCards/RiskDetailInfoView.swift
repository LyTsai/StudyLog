//
//  RiskDetailInfoView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class RiskDetailInfoView: UIView {
    @IBOutlet weak var riskImageView: UIImageView!
    @IBOutlet weak var riskNameLabel: UILabel!
    @IBOutlet weak var riskInfoLabel: UILabel!
    @IBOutlet weak var riskDetailLabel: UILabel!
    @IBOutlet weak var unreadLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        unreadLabel.isHidden = true
    }
    
    weak var hostVC: MatchedCardsViewController!
    class func createWithFrame(_ frame: CGRect, risk: RiskObjModel) -> RiskDetailInfoView {
        let infoView = Bundle.main.loadNibNamed("RiskDetailInfoView", owner: self, options: nil)?.first as! RiskDetailInfoView

        infoView.setupWithRisk(risk)
        infoView.frame = frame
        
        return infoView
    }
    
    // reset
    func setupWithRisk(_ risk: RiskObjModel)  {
        riskImageView.image = risk.imageObj
        riskNameLabel.text = risk.name
        riskInfoLabel.text = risk.info
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        riskDetailLabel.text = "\(risk.author.displayName ?? "") on \(formatter.string(from: Date()))"
        
        commentLabel.text = "data"
    }
    
    // action
    @IBAction func checkComments(_ sender: Any) {
        
    }
    
    @IBAction func share(_ sender: Any) {
        let sharePre = Bundle.main.loadNibNamed("SharePrepareViewController", owner: self, options: nil)?.first as! SharePrepareViewController
        sharePre.modalPresentationStyle = .overCurrentContext
        hostVC.present(sharePre, animated: true, completion: nil)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        unreadLabel.layer.cornerRadius = unreadLabel.bounds.width * 0.5
    }
}
