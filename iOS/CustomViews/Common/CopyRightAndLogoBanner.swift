//
//  CopyRightAndLogoBanner.swift
//  SHIELD
//
//  Created by L on 2019/11/6.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation
import UIKit

class CopyRightAndLogoBanner: UIView {
    fileprivate let companyLogo = UIImageView(image: UIImage(named: "logo_annielyticx"))
    fileprivate let logo = UIImageView(image: UIImage(named: "icon_logo_black"))
    fileprivate let sepLine = UIView()
    fileprivate let copyRightLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }
    fileprivate func addBasic() {
        self.backgroundColor = UIColor.clear
        
        // label
        copyRightLabel.numberOfLines = 0
        copyRightLabel.text = "Copyright \(CalendarCenter.getYearOfDate(Date())!) AnnielyticX® Inc.,\nan IAaaS® (Individualized Assessment as a Service) company."
        sepLine.backgroundColor = UIColorFromHex(0x828282)
        
        logo.contentMode = .scaleAspectFit
        
        // add
        addSubview(companyLogo)
        addSubview(sepLine)
        addSubview(copyRightLabel)
        addSubview(logo)
    }
    
    func setForWhiteText(_ white: Bool) {
        copyRightLabel.textColor = white ? UIColor.white : UIColor.black
        logo.image = white ? UIImage(named: "icon_logo") : UIImage(named: "icon_logo_black")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.height / 25
        companyLogo.frame = CGRect(x: 0, y: 0, width: 92 * one, height: bounds.height)
        
        let gap = 9 * one
        sepLine.frame = CGRect(x: companyLogo.frame.maxX + gap, y: 0, width: 2 * one, height: bounds.height)
        logo.frame = CGRect(x: bounds.width - 130 * one, y: 0, width: 130 * one, height: bounds.height)
        
        copyRightLabel.font = UIFont.systemFont(ofSize: 10 * one)
        copyRightLabel.frame = CGRect(x: sepLine.frame.maxX, y: 0, width: logo.frame.minX - sepLine.frame.maxX, height: bounds.height).insetBy(dx: gap, dy: 0)
    }
}
