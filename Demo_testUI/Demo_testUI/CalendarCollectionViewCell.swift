//
//  CalendarCollectionViewCell.swift
//  ANBookPad
//
//  Created by dingf on 16/9/9.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    var dataLabel :UILabel!
    func getDataLabel() -> UILabel{
        if dataLabel == nil {
            dataLabel = UILabel.init(frame: self.bounds)
            dataLabel.textAlignment = .center
            dataLabel.font = UIFont.systemFont(ofSize: 17)
            self.addSubview(dataLabel)
        }
        return dataLabel
    }
}
