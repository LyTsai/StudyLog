//
//  NumberChooseCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/8.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

let numberChooseCellID = "number choose cell identifier"
class NumberChooseCell: UICollectionViewCell {
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



class NumberChooseCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var chooseItem: ((Int)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(TextChooseCell.self, forCellWithReuseIdentifier: textChooseCellID)
        delegate = self
        dataSource = self
        
    }
    
    fileprivate var texts = [Int]()
    fileprivate var chosen = 0
    func setupWithTexts(_ texts: [String], chosen: Int)  {
        self.texts = texts
        self.chosen = chosen
        reloadData()
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textChooseCellID, for: indexPath) as! TextChooseCell
        cell.configureWithText(texts[indexPath.item], chosen: indexPath.item == chosen)
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
}
