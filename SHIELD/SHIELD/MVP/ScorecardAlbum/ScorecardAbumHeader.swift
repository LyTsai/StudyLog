//
//  ScorecardAbumHeader.swift
//  AnnielyticX
//
//  Created by iMac on 2018/8/11.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
// header view
class ScorecardAlbumHeaderView: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    fileprivate let shapeLayer = CAShapeLayer()
    
    
    class func createWithName(_ name: String, typeName: String!, typeColor: UIColor!, imageUrl: URL!) -> ScorecardAlbumHeaderView {
        let header = Bundle.main.loadNibNamed("ScorecardAlbum", owner: self, options: nil)![0] as! ScorecardAlbumHeaderView
    
        header.basicSetup()
        header.setupWithName(name, typeName: typeName, typeColor: typeColor, imageUrl: imageUrl)
        
        return header
    }
    
    fileprivate func basicSetup() {
        shapeLayer.strokeColor = UIColorFromRGB(209, green: 211, blue: 212).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
        
        typeLabel.layer.masksToBounds = true
    }
    
    fileprivate func setupWithName(_ name: String, typeName: String!, typeColor: UIColor!, imageUrl: URL!) {
        nameLabel.text = name
        iconImageView.isHidden = (imageUrl == nil)
        typeLabel.isHidden = (typeName == nil)
        
        // setup
        if imageUrl != nil {
            iconImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        
        if typeName != nil {
            typeLabel.text = typeName
            let color = typeColor ?? tabTintGreen
            typeLabel.layer.borderColor = color.cgColor
            typeLabel.backgroundColor = color.withAlphaComponent(0.8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth = bounds.height / 45
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8 * lineWidth, height: 8 * lineWidth)).cgPath
        nameLabel.font = UIFont.systemFont(ofSize: 14 * lineWidth, weight: .semibold)
        
        typeLabel.layer.cornerRadius = typeLabel.bounds.height * 0.5
        typeLabel.layer.borderWidth = lineWidth * 2
        typeLabel.font = UIFont.systemFont(ofSize: 12 * lineWidth, weight: .semibold)
    }
}
