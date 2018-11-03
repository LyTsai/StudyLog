//
//  RaceInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

/*
 total: 257 * 58
 cell: 58 * 58
 image: 43 * 43
 radius: 4
 borderT : 0.5
 check: 7,5 * 7.5
 */

// cell
let selectionCellID = "selection cell ID"
class SelectionCell: UICollectionViewCell {
    var text = "" {
        didSet{ label.text = text }
    }
    
    var image = UIImage(named: "") {
        didSet{ imageView.image = image }
    }
    
    override var isSelected: Bool {
        didSet{
            adjustSelectionUI()
            adjustLabel()
        }
    }
    
    // private properties
    private let label = UILabel()
    private let imageBackView = UIView()
    private let imageView = UIImageView()
    private let checkImageView = UIImageView()
    
    private let activeColor = UIColorFromRGB(0, green: 200, blue: 83)
    private let inactiveColor = UIColorFromRGB(178, green: 188, blue: 202)
    private let inactiveFillColor = textTintGray
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        
        imageBackView.layer.borderWidth = 0.5
        
        checkImageView.image = UIImage(named: "process_answered")
        
        contentView.addSubview(label)
        contentView.addSubview(imageBackView)
        contentView.addSubview(imageView)
        imageView.addSubview(checkImageView)
        
        isSelected = false
    }
    
    private func adjustSelectionUI() {
        imageBackView.layer.borderColor = isSelected ? activeColor.cgColor : inactiveColor.cgColor
        imageView.alpha = isSelected ? 1 : 0.1
        imageBackView.backgroundColor = isSelected ? UIColor.clear : inactiveFillColor
        checkImageView.isHidden = !isSelected
    }
    
    private func adjustLabel(){
        let singleHeight = bounds.height - imageView.frame.maxY
        let selectedFrame = CGRect(x: 0, y: imageView.frame.maxY, width: bounds.width, height: singleHeight)
        
        label.font = UIFont.systemFont(ofSize: singleHeight / 2.2)
        label.frame = isSelected ? selectedFrame : imageView.frame
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageLength = 43 * min(bounds.width, bounds.height) / 58
        let checkLength = 7.5 * imageLength / 43
        let checkX = 34 * imageLength / 43
    
        imageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: imageLength * 0.5), length: imageLength)
        imageBackView.frame = imageView.frame
        imageBackView.layer.cornerRadius = 4 * imageLength / 43
        checkImageView.frame = CGRect(x: checkX, y: checkX, width: checkLength, height: checkLength)
        
        adjustLabel()
    }
}

// MARK: ------- collection view
class RaceInputCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var raceDictionary = ["Aboriginal": "race_aboriginal", "Hispanic": "race_hispanic", "South Asian": "race_southAsian", "Asian": "race_asian", "African descent": "race_african"]
    var selectedKey: String! {
        if selectedItem == -1 {
            print("no select yet")
            return nil
        }
        return keys[selectedItem]
    }
    
    weak var hostCell: UserInfoRaceCell!
    
    // private
    private var keys: [String] {
        return raceDictionary.keys.map{String($0)}
    }
    
    private var selectedItem: Int = -1 {
        didSet{
            if hostCell != nil {
                hostCell.changeState()
            }
            
            if selectedItem != oldValue {
                // update items
                if oldValue == -1 {
                    performBatchUpdates({
                        self.reloadItems(at: [IndexPath(item: self.selectedItem, section: 0)])
                    }, completion: nil)
                }else {
                    performBatchUpdates({
                        self.reloadItems(at: [IndexPath(item: oldValue, section: 0), IndexPath(item: self.selectedItem, section: 0)])
                    }, completion: nil)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        register(SelectionCell.self, forCellWithReuseIdentifier: selectionCellID)
        dataSource = self
        delegate = self
    }
    
    class func createWithFrame(_ frame: CGRect) -> RaceInputCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collection = RaceInputCollectionView(frame: frame, collectionViewLayout: layout)
        collection.register(SelectionCell.self, forCellWithReuseIdentifier: selectionCellID)
        collection.backgroundColor = UIColor.clear
        
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectionCellID, for: indexPath) as! SelectionCell
        
        let key = keys[indexPath.item]
        cell.text = key
        cell.image = UIImage(named: raceDictionary[key]!)
        cell.isSelected = false
        
        if indexPath.item == selectedItem {
            cell.isSelected = true
        }
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.item
    }
    
    // layout adjust
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: bounds.height , height: bounds.height)
        flowLayout.minimumLineSpacing = (bounds.width - bounds.height * CGFloat(keys.count)) / CGFloat(keys.count - 1)
    }
}
