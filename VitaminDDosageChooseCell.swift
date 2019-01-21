//
//  VitaminDDosageChooseCell.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/21.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

let vitaminDDosageChooseCellID = "Vitamin D Dosage Choose Cell Identifier"
class VitaminDDosageChooseCell: UITableViewCell {
    fileprivate weak var table: VitaminDDosageChooseTableView!
    class func cellWithTableView(_ tableView: VitaminDDosageChooseTableView, textData: (String, [String])) -> VitaminDDosageChooseCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: vitaminDDosageChooseCellID) as? VitaminDDosageChooseCell
        if cell == nil {
            cell = VitaminDDosageChooseCell(style: .default, reuseIdentifier: vitaminDDosageChooseCellID)
            cell?.table = tableView
            cell?.addBasic()
        }
        
        return cell!
    }

    fileprivate let label = UILabel()
    fileprivate let sweetSpot = UIImageView(image: #imageLiteral(resourceName: "VitaminDsweetSpot"))
    fileprivate func addBasic() {
        label.textAlignment = .center
        label.numberOfLines = 0
        addSubview(label)
        sweetSpot.contentMode = .scaleAspectFit
        addSubview(sweetSpot)
    }
    
    fileprivate var strench = false
    fileprivate var row: Int!
    fileprivate var ballColor = UIColor.red
    fileprivate var fillColor = UIColor.white
    func setupWithBallColor(_ ballColor: UIColor, fillColor: UIColor, strench: Bool, subIndex: Int!, row: Int) {
        self.strench = strench
        self.row = row
        self.ballColor = ballColor
        self.fillColor = fillColor
        
        self.backgroundColor = strench ? fillColor.withAlphaComponent(0.5) : UIColor.clear
        self.label.backgroundColor = strench ? UIColor.clear : UIColor.white
        
        sweetSpot.isHidden = (row != 4)
    }
    
    func setupWithTitle(_ title: String, texts: [String]) {
        label.text = title
        
        setNeedsDisplay()
    }
    fileprivate var subRects = [CGRect]()
    fileprivate var subIndex: Int!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        if !strench {
            subIndex = nil
        }else {
            // choose detail
            for (i, rect) in subRects.enumerated() {
                if rect.contains(point) {
                    subIndex = i
                    break
                }
            }
        }
        
        setNeedsDisplay()
        table.touchRowOf(row, subIndex: subIndex)
    }
    
    override func draw(_ rect: CGRect) {
        var oneH = bounds.height / 45
        if strench {
            oneH = bounds.height / 80
        }
        
        let cellH = 35 * oneH
        sweetSpot.frame = CGRect(x: bounds.width - cellH, y: 0, width: cellH, height: cellH)
        
        
    }
}
