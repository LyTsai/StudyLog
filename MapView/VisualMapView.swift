//
//  VisualMapView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/28.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VisualMapView: UIView {
    let iSaView = VisualMapBoardView()
    let metricView = VisualMapBoardView()
    let iRaView = VisualMapBoardView()
    
    fileprivate var boards = [VisualMapBoardView]()
    fileprivate let labels = [UILabel(), UILabel(), UILabel()]
    
    // init state
    func loadBoards()  {
        // three boards
        let boardSize = CGSize(width: bounds.width, height: bounds.height * 0.84)
        let labelSize = CGSize(width: boardSize.width, height: boardSize.height * 0.08)
        
        iSaView.setupWithFrame(CGRect(center: CGPoint(x: bounds.midX, y: bounds.height * 0.2), width: boardSize.width, height: boardSize.height), fillColor: UIColorFromRGB(137, green: 191, blue: 160), borderColor: UIColorFromRGB(95, green: 167, blue: 125), shadowColor: UIColorFromRGB(146, green: 130, blue: 0), mapType: .symptoms)
        
        metricView.setupWithFrame(CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), width: boardSize.width, height: boardSize.height), fillColor: UIColorFromRGB(255, green: 138, blue: 79), borderColor: UIColorFromRGB(255, green: 85, blue: 0), shadowColor: UIColorFromRGB(148, green: 49, blue: 0), mapType: .riskClass)
        iRaView.setupWithFrame(CGRect(center: CGPoint(x: bounds.midX, y: bounds.height * 0.8), width: boardSize.width, height: boardSize.height), fillColor: UIColorFromRGB(74, green: 143, blue: 254), borderColor: UIColorFromRGB(2, green: 136, blue: 209), shadowColor: UIColorFromRGB(0, green: 78, blue: 120), mapType: .riskFactors)
        
        addSubview(iRaView)
        addSubview(metricView)
        addSubview(iSaView)
        boards = [iSaView, metricView, iRaView]
        
        // labels
        for (i, label) in labels.enumerated() {
            boards[i].setupTilted(true)
            
            label.textAlignment = .center
            label.frame = CGRect(x: bounds.midX - boardSize.width * 0.5, y: boards[i].frame.minY - labelSize.height, width: labelSize.width, height: labelSize.height)
            label.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: UIFontWeightBold)
            addSubview(label)
        }
        
        labels[0].text = "Symptoms"
        labels[1].text = "Disease Risks"
        labels[2].text = "Risk Factors"
    }
 
    fileprivate var firstTouch = true
    fileprivate var focusingIndex = -1
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if firstTouch {
            for (i, aBoard) in boards.enumerated() {
                if aBoard.frame.contains(location) {
                    firstTouch = false
                    UIView.animate(withDuration: 0.5, animations: {
                        for board in self.boards {
                            board.setupTilted(false)
                        }
                        self.focusOnBoard(i)
                    })
                    break
                }
            }
        }else {
            // switch boards
            for (i, label) in labels.enumerated() {
                if label.frame.contains(location) {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.focusOnBoard(i)
                    })
                    break
                }
            }
        }
    }
    
    fileprivate func focusOnBoard(_ index: Int) {
        if focusingIndex == index {
            return
        }
        
        focusingIndex = index
        let topCenter = CGPoint(x: bounds.midX, y: bounds.height * 0.42)
        let offsetY = labels[0].frame.height
        
        var nCenterY = topCenter.y
        for (i, board) in self.boards.enumerated() {
            if i == index {
                board.center = topCenter
                board.alpha = 1
            }else {
                nCenterY += offsetY
                board.center = CGPoint(x: topCenter.x, y: nCenterY)
                board.alpha = 0.7
                sendSubview(toBack: board)
            }
            
            labels[i].center = CGPoint(x: topCenter.x, y: board.frame.maxY - offsetY * 0.5)
        }
    }
}
