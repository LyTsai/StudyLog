//
//  StretchExplainTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/15.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class StretchExplainTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    weak var hostScroll: BrainAgeReferenceView!
    
    let colors = [(fill: UIColorFromHex(0x7FB7E7), cBorder:UIColorFromHex(0x70a2ca), cFill: UIColorFromHex(0x97ceff)),
                  (fill: UIColorFromHex(0xa08ac9), cBorder:UIColorFromHex(0x8d78b0), cFill: UIColorFromHex(0xc4a4ff)),
                  (fill: UIColorFromHex(0xff8f55), cBorder:UIColorFromHex(0xe07e4b), cFill: UIColorFromHex(0xffa87b)),
                  (fill: UIColorFromHex(0xeac536), cBorder:UIColorFromHex(0xcdad2f), cFill: UIColorFromHex(0xf7db6f)),
                  (fill: UIColorFromHex(0x9BC280), cBorder:UIColorFromHex(0x88AA70), cFill: UIColorFromHex(0xBDE6A0)),
                  (fill: UIColorFromHex(0x80CBD8), cBorder:UIColorFromHex(0x6FB1BC), cFill: UIColorFromHex(0x92DEEB))]
    
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
        isScrollEnabled = false
        
        dataSource = self
        delegate = self
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            viewController.automaticallyAdjustsScrollViewInsets = false
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
        return StretchExplainCell.cellWithTable(tableView, text: texts[indexPath.section], backgroundColor: colors[indexPath.section % 6].cFill.withAlphaComponent(0.8))
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // delegate
    // heights
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let onShow = cellsOnShow.contains(indexPath.section)
        
        // height
        if onShow {
            let cH = NSAttributedString(string: texts[indexPath.section], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12 * bounds.width / 315, weight: UIFont.Weight.medium)]).boundingRect(with: CGSize(width: bounds.width - bounds.width / 315 * 20, height: height), options: .usesLineFragmentOrigin, context: nil).height + 15 * bounds.width / 315
            return cH
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.bounds.width * 55 / 315
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == texts.count - 1) ? 0.001 : frame.width / 315
    }
    
    @objc func showOrHide(_ tap: UITapGestureRecognizer) {
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
            self.frame = CGRect(origin: self.frame.origin, size: self.contentSize)
//            self.hostScroll.adjustFrame()
        }
        
    }

}
