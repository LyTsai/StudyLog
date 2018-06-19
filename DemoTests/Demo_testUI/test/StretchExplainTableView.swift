//
//  StretchExplainTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/15.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class StretchExplainTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
//    weak var hostScroll: BrainAgeReferenceView!
    
    let colors = [(fill: UIColorFromRGB(0x7fb7e7), cBorder:UIColorFromRGB(0x70a2ca), cFill: UIColorFromRGB(0x97ceff)),
                  (fill: UIColorFromRGB(0xa08ac9), cBorder:UIColorFromRGB(0x8d78b0), cFill: UIColorFromRGB(0xc4a4ff)),
                  (fill: UIColorFromRGB(0xff8f55), cBorder:UIColorFromRGB(0xe07e4b), cFill: UIColorFromRGB(0xffa87b)),
                  (fill: UIColorFromRGB(0xeac536), cBorder:UIColorFromRGB(0xcdad2f), cFill: UIColorFromRGB(0xf7db6f)),
                  (fill: UIColorFromRGB(0x7fb7e7), cBorder:UIColorFromRGB(0x70a2ca), cFill: UIColorFromRGB(0x97ceff)),
                  (fill: UIColorFromRGB(0x7fb7e7), cBorder:UIColorFromRGB(0x70a2ca), cFill: UIColorFromRGB(0x97ceff))]
    
    fileprivate var titles = [String]()
    fileprivate var texts = [String]()
    fileprivate var cellsOnShow = Set<Int>()
    func setupWithFrame(_ frame: CGRect, titles: [String], texts: [String]) {
        self.frame = frame
        self.titles = titles
        self.texts = texts
        
        self.separatorStyle = .none
        backgroundView = nil
        backgroundColor = UIColor.clear
//        isScrollEnabled = false
        
        backgroundColor = UIColor.red
        
        dataSource = self
        delegate = self
        
        sectionFooterHeight = 0.001
        sectionHeaderHeight = 0.001
        contentInset = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    // data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "StretchExplainTableCellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "StretchExplainTableCellID")
           
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.textColor = UIColorGray(74)
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.backgroundColor = UIColor.white
        
        cell?.textLabel?.frame = cell!.bounds
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12 * bounds.width / 315, weight: UIFontWeightMedium)
        cell?.textLabel?.text = texts[indexPath.section]
        cell?.backgroundColor = colors[indexPath.section % 6].cFill.withAlphaComponent(0.8)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = StretchExplainHeaderView()
        header.tag = 100 + section
        let colorP = colors[section % 6]
        header.setupWithFillColor(colorP.fill, cBorder: colorP.cBorder, cFill: colorP.cFill, title: titles[section])
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(showOrHide))
        header.addGestureRecognizer(tapGR)
        return header
    }
    
    // delegate
    // heights
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let onShow = cellsOnShow.contains(indexPath.section)
        
        // height
        if onShow {
            let cH = NSAttributedString(string: texts[indexPath.section], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12 * bounds.width / 315, weight: UIFontWeightMedium)]).boundingRect(with: CGSize(width: bounds.width, height: height), options: .usesLineFragmentOrigin, context: nil).height + 10 * bounds.width / 315
            return cH
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.bounds.width * 55 / 315
    }
    
    
    func showOrHide(_ tap: UITapGestureRecognizer) {
        let header = tap.view as! StretchExplainHeaderView
        let section = header.tag - 100
        
        if cellsOnShow.contains(section) {
            cellsOnShow.remove(section)
        }else {
            cellsOnShow.insert(section)
        }
        
        UIView.animate(withDuration: 0.4) {
            header.reverseState()
            
            // scrollView
            self.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
//            self.hostScroll.adjustCheckFrame()
        }
        
    }

}
