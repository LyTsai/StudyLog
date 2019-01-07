//
//  PlanCells.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// MARK: -------- calendar cell --------------
let planCalendarCellID = "plan calendar cell identifier"
class PlanCalendarCell: UITableViewCell {
    var calendar: CalendarView!
    
    class func cellWithTableView(_ tableView: UITableView, coreDay: Date, showAll: Bool) -> PlanCalendarCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: planCalendarCellID) as? PlanCalendarCell
        if cell == nil {
            cell = PlanCalendarCell(style: .default, reuseIdentifier: planCalendarCellID)
            cell!.calendar = CalendarView.createWithFrame(CGRect.zero, coreDay: coreDay, showAll: showAll)
            cell!.addSubview(cell!.calendar)
        }
        cell?.calendar.coreDay = coreDay
        cell?.calendar.reloadData()
        
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        calendar.frame = bounds
    }
}

// MARK: -------- plan add cell -----------------
let planAddCellID = "plan add cell identifier"
class PlanAddCell: UITableViewCell {
    weak var hostTable: PlanDisplayTableView!
    
    fileprivate let calendarImage = UIImage(named: "icon_calendar")
    fileprivate var viewForAdd: ViewForAdd!
    
    class func cellWithTableView(_ tableView: UITableView) -> PlanAddCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: planAddCellID) as? PlanAddCell
        if cell == nil {
            cell = PlanAddCell(style: .default, reuseIdentifier: planAddCellID)
            cell!.updateUI()
        }
        
        return cell!
    }
    
    fileprivate func updateUI() {
        viewForAdd = ViewForAdd.createWithFrame(CGRect.zero, topImage: calendarImage, title: "No plans added", prompt: "Tap to get started")
        contentView.addSubview(viewForAdd)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(goToAddPlans))
        viewForAdd.addGestureRecognizer(tapGR)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewForAdd.frame = bounds.insetBy(dx: bounds.width * 0.2, dy: bounds.height * 0.2)
    }
    
    func goToAddPlans()  {
        let doImpactfulVC = DoImpactfulViewController()
        doImpactfulVC.date = hostTable.currentDate
        hostTable.hostVC.navigationController?.pushViewController(doImpactfulVC, animated: true)
    }
}


// MARK: -------- plan display cell -------------
let planDisplayCellID = "plan display cell identifier"
class PlanDisplayCell: UITableViewCell {
    var isActive = true {
        didSet{
            activeImageView.image = isActive ? UIImage(named: "reminder_active") : UIImage(named: "reminder_inactive")
            activeImageView.transform = isActive ? CGAffineTransform.identity : CGAffineTransform(scaleX: sqrt(2), y: sqrt(2))
            inactiveMask.alpha = isActive ? 0 : 0.6
            leftLineView.isHidden = !isActive
        }
    }
    
    fileprivate let activeImageView = UIImageView()
    fileprivate let inactiveMask = UIView()
    fileprivate let leftLineView = UIView()
    
    class func cellWithTableView(_ tableView: UITableView, image: UIImage?, text: String?, checked: Bool) -> PlanDisplayCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: planDisplayCellID) as? PlanDisplayCell
        if cell == nil {
            cell = PlanDisplayCell(style: .default, reuseIdentifier: planDisplayCellID)
            cell!.setupUI()
        }
        
        cell?.imageView?.image = image
        cell?.textLabel?.text = text
        cell!.isActive = checked
        
        return cell!
    }
    
    fileprivate func setupUI() {
        selectionStyle = .none
        
        textLabel?.numberOfLines = 0
        imageView?.contentMode = .scaleAspectFit
        activeImageView.contentMode = .scaleAspectFit
        
        inactiveMask.backgroundColor = UIColor.white
        leftLineView.backgroundColor = UIColorFromRGB(126, green: 211, blue: 100)
        
        contentView.backgroundColor = UIColorFromRGB(245, green: 255, blue: 234)
        contentView.addSubview(activeImageView)
        contentView.addSubview(inactiveMask)
        contentView.addSubview(leftLineView)
    }
    
    // layout
    /*
     375 * 75
     leftImage: (20, 14, 43, 46), rightImage: 29,  30 * aqrt(2)
     gap: 10
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hGap = 10 * bounds.width / 375
        let imageLength = 46 * bounds.height / 75
        let activeLength = 29 * bounds.height / 75
        
        imageView?.frame = CGRect(x: 1.5 * hGap, y: bounds.midY - imageLength * 0.5, width: imageLength, height: imageLength)
        activeImageView.frame = CGRect(x: bounds.width - 2 * hGap - activeLength, y: bounds.midY - activeLength * 0.5, width: activeLength, height: activeLength)
        textLabel?.frame = CGRect(x: hGap + imageView!.frame.maxX, y: 0, width: activeImageView.frame.minX - 2 * hGap - imageView!.frame.maxX, height: bounds.height)
        textLabel?.font = UIFont.systemFont(ofSize: textLabel!.frame.height * 0.24)
        
        leftLineView.frame = CGRect(x: 0, y: 0, width: 2, height: bounds.height)
        inactiveMask.frame = bounds
    }
}

// MARK: -------- plan simple cell -------------
let planSimpleCellID = "plan simple cell identifier"
class PlanSimpleCell: UITableViewCell {
    var isActive = true {
        didSet{
            imageView?.image = isActive ? UIImage(named: "checkbox_yes") : UIImage(named: "checkbox_no")
        }
    }
    
    class func cellWithTableView(_ tableView: UITableView, text: String?, checked: Bool) -> PlanSimpleCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: planSimpleCellID) as? PlanSimpleCell
        if cell == nil {
            cell = PlanSimpleCell(style: .default, reuseIdentifier: planSimpleCellID)
            cell!.setupUI()
        }
        
        cell?.textLabel?.text = text
        cell!.isActive = checked
        
        return cell!
    }
    
    fileprivate func setupUI() {
        selectionStyle = .none
        
        textLabel?.numberOfLines = 0
        imageView?.contentMode = .scaleAspectFit
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 25, y: 0, width: bounds.width - 55, height: bounds.height)
        textLabel?.font = UIFont.systemFont(ofSize: bounds.height * 0.3)
        imageView?.frame = CGRect(center: CGPoint(x: bounds.width - 18, y: bounds.midY), length: 20)
    }
}


