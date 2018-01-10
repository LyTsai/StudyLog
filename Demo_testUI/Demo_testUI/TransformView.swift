//
//  TransformView.swift
//  Demo_testUI
//
//  Created by Lydire on 2017/12/17.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class TransformView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("layout")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print("Needed")
    }
}
