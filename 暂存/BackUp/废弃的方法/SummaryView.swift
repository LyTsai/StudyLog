//
//  SummaryView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/8.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// with images
enum AnswerState {
    case none
    case lowOrNo
    case medium
    case highOrGood
}

let summaryCellIdentifier = "summary Cell Identifier"
class SummaryCell: UITableViewCell {
    fileprivate var answerState = AnswerState.none
    fileprivate var numberOfColumn: Int = 1
    
    class func cellWithTableView(_ tableView: UITableView, metricName: String, answer: AnswerState, numberOfColumn: Int) -> SummaryCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: summaryCellIdentifier) as? SummaryCell
        if cell == nil {
            cell = SummaryCell(style: .default, reuseIdentifier: summaryCellIdentifier)
            // label
            cell!.textLabel?.textAlignment = .center
            cell!.textLabel?.font = UIFont.boldSystemFont(ofSize: 8)
            cell!.textLabel?.textColor = UIColorFromRGB(135, green: 135, blue: 135)
            cell!.textLabel?.backgroundColor = UIColorFromRGB(242, green: 242, blue: 242)
            
            // image
            cell!.imageView?.contentMode = .center
        }
        
        cell!.answerState = answer
        cell!.numberOfColumn = numberOfColumn
        
        cell!.textLabel!.text = metricName
        let image = cell!.imageForAnswer()
        if image != nil {
            cell!.imageView?.image = image!
        }
        
        return cell!
    }
    
    fileprivate func imageForAnswer() -> UIImage? {
        switch answerState {
        case .none: return nil
        case .highOrGood:
            return UIImage(named: "checkMark_green")
        case .medium:
            return UIImage(named: "checkMark_yellow")
        case .lowOrNo:
            return UIImage(named: "checkMark_red")
        }
    }
    
    var labelPro: CGFloat = 0.28
    var labelWidth: CGFloat {
        return bounds.width * labelPro
    }
    
    var imageWidth: CGFloat {
        return bounds.width * (1 - labelPro) / CGFloat(numberOfColumn)
    }
    
    // calculate for better view
    fileprivate func xPositionForImage() -> CGFloat {
        switch answerState {
        case .none: return 0
        case .highOrGood:
            return labelWidth
        case .medium:
            return labelWidth + imageWidth
        case .lowOrNo:
            return labelWidth + 2 * imageWidth
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 0, y: 0, width: labelWidth, height: bounds.height)
        imageView?.frame = CGRect(x: xPositionForImage(), y: 0, width: imageWidth, height: bounds.height)
    }
}

class SummaryTableView: UITableView {
    
}

class SummaryView: UIView {
    // to get all the information needed, including the risk, user, result
    var measurements = MeasurementModel.takeOutAllMeasurementsInCoreData()

    // views
    weak var hostViewDelegate: AssessmentTopView!
    var RiskView: UIView!
    var summaryTable: SummaryTableView!
    
    func loadSummaryView()  {
        if hostViewDelegate == nil {
            return
        }     
        
        let remove = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRemove))
        remove.direction = UISwipeGestureRecognizerDirection.right
        addGestureRecognizer(remove)
        
    }
    // height = 36
    
    func swipeToRemove()  {
        removeFromSuperview()
    }
    
}
