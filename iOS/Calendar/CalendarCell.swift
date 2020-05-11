//
//  CalendarCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/27.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// header of calendar, including the year and month
let calendarHeaderID = "calendar header identifier"
class CalendarHeader: UICollectionReusableView {
    var dateOnShow = Date() {
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            dateLabel.text = dateFormatter.string(from: dateOnShow)
        }
    }
    
    fileprivate let fontColor = UIColorFromRGB(139, green: 195, blue: 74)
    fileprivate let dateLabel = UILabel()
    fileprivate let layoutControl = UIButton(type: .custom)
    fileprivate var weekLabels = [UILabel]()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        // date
        dateLabel.textColor = fontColor
        
        // state request
        layoutControl.setTitle("收起日历", for: .normal)
        layoutControl.setTitle("展开日历", for: .selected)
        layoutControl.setTitleColor(fontColor, for: .normal)
        layoutControl.addTarget(self, action: #selector(changeLayout(_:)), for: .touchUpInside)
        
        // week
        let weeks = ["M", "T", "W", "T", "F", "S", "S"]
        for week in weeks {
            let label = UILabel()
            label.text = week
            label.textAlignment = .center
            
            if week == "S" {
                label.textColor = UIColorGray(158)
            }
            
            weekLabels.append(label)
            addSubview(label)
         }
        
        // add
        addSubview(dateLabel)
        addSubview(layoutControl)
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let standardW = bounds.width / 375
        let standardH = bounds.height / 64
        
        dateLabel.frame = CGRect(center: CGPoint(x: 55 * standardW,y: 19 * standardH), width: 80 * standardW, height: 22 * standardH)
        layoutControl.frame = CGRect(center: CGPoint(x: bounds.width - 40 * standardW, y: 19 * standardH), width: 50 * standardW, height: 20 * standardH)
        dateLabel.font = UIFont.systemFont(ofSize: 17 * standardH)
        layoutControl.titleLabel?.font = UIFont.systemFont(ofSize: 12 * standardH)
        
        // week labels
        let weekWidth = bounds.width / 7
        let weekHeight = 26 * standardH
        
        for (i, label) in weekLabels.enumerated() {
            label.frame = CGRect(x: CGFloat(i) * weekWidth, y: bounds.height - weekHeight, width: weekWidth, height: weekHeight)
            label.font = UIFont.systemFont(ofSize: weekHeight * 0.5)
        }
        
    }
    
    // action
    func changeLayout(_ button: UIButton)  {
        button.isSelected = !button.isSelected
        
        // change
    }

}


// plan state
enum PlanState {
    case none, finished, missed, planned
}

// MARK: --------------- cell -------------------
let calendarCellID = "calendar cell identifier"
class CalendarCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        backLayer.isHidden = true
        stateImageView.image = nil
    }
    
    
    // label
    var day: Int = 0 {
        didSet{
            if day > 0 && day < 32 {
                dayLabel.text = "\(day)"
            }else {
                dayLabel.text = ""
            }
        }
    }
    
    // image
    var planState = PlanState.none {
        didSet{
            if planState != oldValue && isToday == false {
                switch planState {
                case .none: stateImageView.image = nil
                case .finished: stateImageView.image = UIImage(named: "plan_finished")
                case .missed: stateImageView.image = UIImage(named: "plan_missed")
                case .planned: stateImageView.image = UIImage(named: "plan_planned")
                }
            }
        }
    }
    
    // set before isToday
    var isWeekend = false {
        didSet{
             dayLabel.textColor = isWeekend ? UIColorGray(158) : UIColor.black
        }
    }
    
    var isToday = false {
        didSet {
            if isToday != oldValue {
                if isToday {
                    stateImageView.image = UIImage(named: "icon_today")
                    dayLabel.textColor = UIColor.white
                }
                
                backLayer.isHidden = !isToday
            }
        }
    }
    
    fileprivate let missedImage = UIImage(named: "plan_missed")
    
    fileprivate let dayLabel = UILabel()
    fileprivate let stateImageView = UIImageView()
    fileprivate let backLayer = CAShapeLayer()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        backLayer.fillColor = UIColorFromRGB(240, green: 130, blue: 90).cgColor
        backLayer.isHidden = true
        
        dayLabel.textAlignment = .center
        stateImageView.contentMode = .scaleAspectFit
        
        contentView.layer.addSublayer(backLayer)
        contentView.addSubview(dayLabel)
        contentView.addSubview(stateImageView)
    }
    
    // layout
    /* 55 * 55, 30 * 30 */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellLength = min(bounds.width, bounds.height)
        let labelLength = cellLength * 30 / 55
     
        // backLayer
        backLayer.frame = bounds
        let labelFrame = CGRect(x: bounds.midX - labelLength * 0.5, y: cellLength * 3 / 55, width: labelLength, height: labelLength)
        backLayer.path = UIBezierPath(ovalIn: labelFrame).cgPath
        
        // label
        dayLabel.frame = labelFrame
        dayLabel.font = UIFont.systemFont(ofSize: labelLength * 0.52, weight: UIFontWeightMedium)
        
        // image
        let imageHeight = labelLength * 0.4
        stateImageView.frame = CGRect(x: bounds.midX - labelLength * 0.5, y: (bounds.height - labelFrame.maxY - imageHeight) * 0.5 + labelFrame.maxY, width: labelLength, height: imageHeight)
    }
}
