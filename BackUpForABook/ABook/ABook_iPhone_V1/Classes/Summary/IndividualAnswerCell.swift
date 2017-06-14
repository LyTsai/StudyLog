//
//  IndividualAnswerCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/2.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation


// cell of invidual cell
let individualAnswerCellID = "Individual Answer Cell Identifier"
class IndividualAnswerCell: UITableViewCell {
 
    var answersView: AnswersCollectionView!
    
    fileprivate var titleLabel = UILabel()
    //fileprivate var promptLabel = UILabel()
    fileprivate var leftImageView = UIImageView()
    fileprivate var leftView = UIView()
    
    var withDetail = false
    class func cellWithTableView(_ tableView: IndividualAnswerTableView, row: Int, text: String?, image: UIImage?, options:[String], answerIndex: Int, withDetail: Bool) -> IndividualAnswerCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: individualAnswerCellID) as? IndividualAnswerCell
        
        if cell == nil {
            cell = IndividualAnswerCell(style: .default, reuseIdentifier: individualAnswerCellID)
            cell!.addSubs()
            cell!.answersView.hostTableView = tableView
        }
        
        // data
        cell!.titleLabel.text = text
        
        cell!.leftImageView.image = image
        let isOdd = (row % 2 == 0)
        
        cell!.leftView.backgroundColor = isOdd ? leftOdd : leftEven
        cell!.answersView.backgroundColor = isOdd ? rightOdd : UIColor.white
        cell!.answersView.tableRow = row
        cell!.answersView.options = options
        cell!.answersView.answerIndex = answerIndex
        
        cell!.withDetail = withDetail
        
        return cell!
    }
    
    fileprivate func addSubs() {
        selectionStyle = .none
        
        answersView = AnswersCollectionView.createAnswers(bounds, options: ["ab","cd"], answerIndex: -1)
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .right
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        
        leftView.addSubview(titleLabel)
        leftView.addSubview(leftImageView)
        
        contentView.addSubview(leftView)
        contentView.addSubview(answersView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // frames
        let leftWidth = (withDetail ? 200 : 80) / 365 * bounds.width
        let height = bounds.height
        
        leftView.frame = CGRect(x: 0, y: 0, width: leftWidth, height: height)
        leftImageView.frame = CGRect(x: leftWidth - 0.8 * height, y: height * 0.1, width: height * 0.7, height: height * 0.7)
        titleLabel.frame = CGRect(x: 0, y: height * 0.11, width: leftWidth - height * 0.8, height: height * 0.8)
        titleLabel.font = UIFont.systemFont(ofSize: height * 0.2)
        answersView.frame = CGRect(x: leftWidth, y: 0, width: bounds.width - leftWidth, height: height)
    }
}
