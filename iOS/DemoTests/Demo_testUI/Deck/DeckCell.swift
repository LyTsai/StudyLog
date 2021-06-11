//
//  DeckCell.swift
//  WholeSHIELD
//
//  Created by L on 2020/7/16.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation

let deckCellID = "DeckCell identifier"
class DeckCell: UICollectionViewCell {
    fileprivate var singleView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        basicSetup()
    }
    
    fileprivate func basicSetup() {
        self.backgroundColor = UIColor.clear
        // view
        singleView = UIView()
        contentView.addSubview(singleView)
    }
    
    // setup
    func configureWithModel() {
        self.singleView.backgroundColor = UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        singleView.frame = bounds
    }
    
}
