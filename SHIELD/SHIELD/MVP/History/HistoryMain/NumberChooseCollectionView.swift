//
//  NumberChooseCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/8.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

let textDisplayCellID = "text display cell identifier"
class TextDisplayCell: UICollectionViewCell {
    fileprivate var label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupText()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupText()
    }
    
    fileprivate func setupText() {
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
        label.font = UIFont.systemFont(ofSize: bounds.height * 0.8, weight: .semibold)
        label.layer.borderWidth = fontFactor * 0.5
    }
    
    func configureWithText(_ text: String, chosen: Bool) {
        label.text = text
        label.layer.borderColor = (chosen ? UIColor.black : UIColor.clear).cgColor
    }
}

class NumberChooseCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var chooseItem: ((Int)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(TextDisplayCell.self, forCellWithReuseIdentifier: textDisplayCellID)
        delegate = self
        dataSource = self
        
    }
    
    fileprivate var numbers = [Int]()
    fileprivate var chosen = 0
    func setupWithNumbers(_ numbers: [Int], chosen: Int)  {
        self.numbers = numbers
        self.chosen = chosen
        reloadData()
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textDisplayCellID, for: indexPath) as! TextDisplayCell
        cell.configureWithText("\(numbers[indexPath.item])", chosen: indexPath.item == chosen)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if chosen != indexPath.item {
            let need = [IndexPath(item: chosen, section: 0), indexPath]
            chosen = indexPath.item
            performBatchUpdates({
                self.reloadItems(at: need)
            }) { (true) in
                self.chooseItem?(indexPath.item)
            }
        }else {
            chooseItem?(indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let gap = bounds.width * 0.05
        let itemW = (bounds.width - 2 * gap) / 3
        let itemH = min(bounds.height, itemW / 5)
        flowLayout.minimumInteritemSpacing = 1000
        flowLayout.minimumLineSpacing = gap
        
        return CGSize(width: itemW, height: itemH)
    }
}
