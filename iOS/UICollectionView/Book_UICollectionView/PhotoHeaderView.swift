//
//  PhotoHeaderView.swift
//  Book_UICollectionView
//
//  Created by L on 2020/5/12.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit

let PhotoHeaderViewIdentifier = "Photo Header View Identifier"
class PhotoHeaderView: UICollectionReusableView {
    var text = " " {
        willSet {
            textLabel.text = newValue
        }
    }
    
    fileprivate let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        // resize
        textLabel.frame = bounds.insetBy(dx: 30, dy: 10)
        textLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(textLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = " "
    }
}
