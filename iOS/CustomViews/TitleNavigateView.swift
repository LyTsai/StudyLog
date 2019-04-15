//
//  TitleNavigateView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/30.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

let titleNavigateViewCellID = "title NavigateView Cell Identifier"
class TitleNavigateViewCell: UICollectionViewCell {
    fileprivate var cellBorderColor = UIColorFromHex(0x9F9FFF)
    fileprivate var normalBackColor = UIColorFromHex(0xEAFFC5)
    fileprivate var chosenBackColor = UIColorFromHex(0xFFEA99)
    fileprivate var chosenDecoBackColor = UIColorFromHex(0x7575BC)
    
    fileprivate let titleLabel = UILabel()
    fileprivate let decoView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func addBasic() {
        contentView.backgroundColor = UIColor.clear
        
        titleLabel.layer.masksToBounds = true
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.layer.borderColor = cellBorderColor.cgColor
        
        decoView.backgroundColor = chosenDecoBackColor
        contentView.addSubview(decoView)
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = forNumber ? bounds.height / 25 : bounds.height / 70
        
        titleLabel.frame = forNumber ? CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), length: min(bounds.width, bounds.height) - one) : CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - one)
        titleLabel.layer.borderWidth = one * 2
        
        titleLabel.font = UIFont.systemFont(ofSize: forNumber ? bounds.height * 0.8: 18 * one)
        
        decoView.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.minY, width: titleLabel.frame.width, height: titleLabel.frame.height + one)
        
        titleLabel.layer.cornerRadius = forNumber ? titleLabel.bounds.midY : 6 * one
        decoView.layer.cornerRadius = forNumber ? titleLabel.bounds.midY : 6 * one
    }
    fileprivate var forNumber = false
    func configureWithText(_ text: String, chosen: Bool, forNumber: Bool) {
        self.forNumber = forNumber
        
        titleLabel.text = text
        titleLabel.backgroundColor = chosen ? chosenBackColor : normalBackColor
        decoView.isHidden = !chosen
        
//        layoutIfNeeded()
    }
}


class TitleNavigationView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var titleIsChosen: ((Int)->Void)?
    
    fileprivate var chosenIndex = 0
    fileprivate var texts = [String]()
    fileprivate var forNumber = false
    class func createWithFrame(_ frame: CGRect, texts: [String], number: Bool) -> TitleNavigationView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let oneL = number ? frame.width / CGFloat(texts.count) : frame.width / 3
        let gap = oneL * 0.05
        layout.minimumInteritemSpacing = 1000
        layout.minimumLineSpacing = gap
        layout.itemSize = CGSize(width: oneL - gap, height: frame.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: number ? 0 : oneL, bottom: 0, right: number ? 0 : oneL)
        
        let navigaionView = TitleNavigationView(frame: frame, collectionViewLayout: layout)
        navigaionView.backgroundColor = UIColor.clear
        navigaionView.register(TitleNavigateViewCell.self, forCellWithReuseIdentifier: titleNavigateViewCellID)
        navigaionView.showsHorizontalScrollIndicator = false
        
        navigaionView.texts = texts
        navigaionView.forNumber = number
        
        navigaionView.delegate = navigaionView
        navigaionView.dataSource = navigaionView
        
        return navigaionView
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleNavigateViewCellID, for: indexPath) as! TitleNavigateViewCell
        cell.configureWithText(texts[indexPath.item], chosen: indexPath.item == chosenIndex, forNumber: forNumber)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != chosenIndex {
            let update = [IndexPath(item: chosenIndex, section: 0), indexPath]
            chosenIndex = indexPath.item
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: update)
            }) { (true) in
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.titleIsChosen?(indexPath.item)
            }
        }
    }
    
    func setIndexChosen(_ chosen: Int) {
        if chosen < texts.count && chosen != chosenIndex {
            let update = [IndexPath(item: chosenIndex, section: 0), IndexPath(item: chosen, section: 0)]
            chosenIndex = chosen
            self.performBatchUpdates({
                self.reloadItems(at: update)
            }) { (true) in
                self.scrollToItem(at: IndexPath(item: chosen, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}
