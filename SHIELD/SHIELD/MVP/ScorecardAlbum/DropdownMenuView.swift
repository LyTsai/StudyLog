//
//  DropdownMenuView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

@objc protocol DropdownMenuProtocol {
    @objc optional func dropdownMenu(_ menu: DropdownMenuView, didSelectIndex index: Int)
    @objc optional func reverseRankOfDropdownMenu(_ menu: DropdownMenuView)
}

class DropdownMenuView: UIView, UITableViewDataSource, UITableViewDelegate {
    weak var dropdownProtocol: DropdownMenuProtocol!
    
    var titles = [String]() {
        didSet{
            setupTableFrame(false)
            menuTable.reloadData()
        }
    }
    var currentIndex = 0 {
        didSet{
            displayLabel.text = titles[currentIndex]
        }
    }
    fileprivate var dropdown = false
    fileprivate var cellHeight: CGFloat = 44
    
    fileprivate let displayView = UIView()
    fileprivate let displayLabel = UILabel()
    fileprivate let menuTable = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate let reverseButton = UIButton(type: .custom)
    fileprivate let arrow = UIImageView(image: UIImage(named: "dropdownMenu_down"))
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
        reverseButton.setBackgroundImage(UIImage(named: "dropdownMenu_reverse"), for: .normal)
        reverseButton.addTarget(self, action: #selector(reverseCurrentRank(_:)), for: .touchUpInside)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(changeMenuState))
        displayView.addGestureRecognizer(tapGR)
        
        menuTable.separatorStyle = .none
        menuTable.bounces = false
        menuTable.dataSource = self
        menuTable.delegate = self
        
        displayLabel.textColor = UIColorGray(88)
        arrow.contentMode = .scaleAspectFit
        displayView.layer.borderColor = UIColorGray(91).cgColor
        displayView.backgroundColor = UIColor.white
        menuTable.layer.borderColor = UIColorGray(91).cgColor
        
        addSubview(displayView)
        addSubview(reverseButton)
        addSubview(displayLabel)
        addSubview(arrow)
        addSubview(menuTable)
    }
    
    // setup
    fileprivate var touchTo = false
    func setupFrames() {
        cellHeight = bounds.height
        reverseButton.frame = CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
        
        let lineWidth = bounds.height / 35
        let displayFrame = CGRect(x: 0, y: 0, width: bounds.width - bounds.height - lineWidth, height: bounds.height)
        displayView.frame = displayFrame
        displayLabel.frame = displayFrame.insetBy(dx: bounds.height * 0.5, dy: lineWidth * 0.5)
        arrow.frame = CGRect(x: displayFrame.maxX - bounds.height * 0.5, y: 0, width: bounds.height * 0.2, height: displayFrame.height)
        
        displayView.layer.borderWidth = lineWidth
        displayView.layer.cornerRadius = lineWidth * 2
        menuTable.layer.borderWidth = lineWidth
        menuTable.layer.cornerRadius = lineWidth * 2
        
        displayLabel.font = UIFont.systemFont(ofSize: bounds.height / 3, weight: .semibold)
        
        menuTable.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if !touchTo {
            setupFrames()
        }
    }
    
    // table data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DropdownMenuTableCell.cellWithTableView(tableView, title: titles[indexPath.item], checked: indexPath.item == currentIndex)
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColorGray(246) : UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // actions
    @objc func changeMenuState() {
        touchTo = true
        dropdown = !dropdown
        UIView.animate(withDuration: 0.3) {
            self.setupTableFrame(self.dropdown)
        }
    }
    fileprivate func setupTableFrame(_ show: Bool)  {
        if show {
            menuTable.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: cellHeight * CGFloat(titles.count))
        }else {
            menuTable.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0)
        }
        
        arrow.transform = show ? CGAffineTransform(rotationAngle: CGFloat(Double.pi)) : CGAffineTransform.identity
    }
    
    @objc func reverseCurrentRank(_ button: UIButton) {
        if dropdownProtocol != nil {
            dropdownProtocol.reverseRankOfDropdownMenu?(self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item != currentIndex {
            let old = currentIndex
            currentIndex = indexPath.item
            tableView.reloadRows(at: [indexPath, IndexPath(item: old, section: 0)], with: .automatic)
           
            if dropdownProtocol != nil {
                dropdownProtocol.dropdownMenu?(self, didSelectIndex: currentIndex)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.changeMenuState()
            }
        }else {
            self.changeMenuState()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == nil {
            if menuTable.frame.contains(point) {
                return menuTable
            }
        }
        
        return view
    }
    
}

let dropdownMenuTableCellID = "dropdown Menu Table Cell Identifier"
class DropdownMenuTableCell: UITableViewCell {
    
    fileprivate let label = UILabel()
//    fileprivate let checkImage = UIImageView(image: )
    class func cellWithTableView(_ tableView: UITableView, title: String, checked: Bool) -> DropdownMenuTableCell {
        var menuCell = tableView.dequeueReusableCell(withIdentifier: dropdownMenuTableCellID) as? DropdownMenuTableCell
        if menuCell == nil {
            menuCell = DropdownMenuTableCell(style: .default, reuseIdentifier: dropdownMenuTableCellID)
            menuCell!.setBasic()
        }
        
        menuCell?.label.text = title
        menuCell?.accessoryType = checked ? .checkmark : .none
        menuCell?.label.textColor = checked ? UIColorGray(88) : UIColorFromRGB(189, green: 192, blue: 194)
       
        return menuCell!
    }
    
    fileprivate func setBasic() {
        self.selectionStyle = .none
        self.tintColor = UIColorFromRGB(246, green: 166, blue: 35)
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: bounds.height * 0.5, y: 0, width: bounds.width * 0.5, height: bounds.height)
        label.font = UIFont.systemFont(ofSize: bounds.height / 3, weight: .semibold)
        
        accessoryView?.frame = CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
    }
}