//
//  ChooseTableCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/18.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let chooseTableCellID = "choose table cell identifier"
class ChooseTableCell: UITableViewCell {
    fileprivate var texts = [String]()
    fileprivate var mainColor = UIColor.red    
    fileprivate weak var chooseTable: ChooseTableView!
    class func cellWithTableView(_ table: ChooseTableView, texts: [String], color: UIColor) -> ChooseTableCell {
        var cell = table.dequeueReusableCell(withIdentifier: chooseTableCellID) as? ChooseTableCell
        if cell == nil {
            cell = ChooseTableCell(style: .default, reuseIdentifier: chooseTableCellID)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
        }
        
        cell?.chooseTable = table
        cell?.setupWithTexts(texts, color: color)
        
        return cell!
    }
    
    fileprivate var rects = [CGRect]()
    fileprivate var labels = [UILabel]()

    fileprivate func setupWithTexts(_ texts: [String], color: UIColor) {
        self.texts = texts
        self.mainColor = color
        
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll()
        
        for text in texts {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = UIColorGray(74)
            label.text = text
            
            addSubview(label)
            labels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rects.removeAll()
        
        let lineWidth = bounds.height / 35
        let start = bounds.height * 0.5 * 25 / 35 + bounds.height * 0.5
        let aWidth = (bounds.width - start - bounds.height) / CGFloat(texts.count)
        
        for (i, label) in labels.enumerated() {
            let rect = CGRect(x: start + aWidth * CGFloat(i),y: 0, width: aWidth, height: bounds.height)
            rects.append(rect)
            label.font = UIFont.systemFont(ofSize: 8.5 * lineWidth, weight: UIFont.Weight.semibold)
            label.frame = rect.insetBy(dx: lineWidth * 2, dy: lineWidth)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        for (i, rect) in rects.enumerated() {
            if rect.contains(point) {
                chooseTable.chooseSubIndex(i)
                break
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth = bounds.height / 35
        mainColor.setStroke()
        
        let start = bounds.height * 0.5 * 25 / 35 + bounds.height * 0.5
        let totalPath = UIBezierPath(roundedRect: CGRect(x: start, y: -lineWidth * 0.5, width: bounds.width - start - bounds.height, height: bounds.height).insetBy(dx: lineWidth * 0.5, dy: 0), cornerRadius: lineWidth * 4)
        totalPath.lineWidth = lineWidth
        totalPath.stroke()
        
        // sep lines
        for (i, area) in rects.enumerated() {
            if i != rects.count - 1 {
                let line = UIBezierPath()
                line.move(to: CGPoint(x: area.maxX, y: area.minY + lineWidth * 0.5))
                line.addLine(to: CGPoint(x: area.maxX, y: area.maxY - lineWidth * 0.5))
                line.lineWidth = lineWidth
                line.stroke()
            }
        }
    }
}
