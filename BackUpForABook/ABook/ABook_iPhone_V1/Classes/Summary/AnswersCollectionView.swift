//
//  AnswersCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/27.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let answerCellID = "Answer Cell Identifier"

class AnswerCollectionViewCell: UICollectionViewCell {
    var optionTitle = "" {
        didSet{
            if optionTitle != oldValue {
                textLabel.text = "\(optionTitle)"
            }
        }
    }
    
    var isAnswer = false {
        didSet{
            textLabel.textColor = (isAnswer ? UIColor.black : dashGray)
            shadowLayer.isHidden = !isAnswer
            dashLayer.isHidden = isAnswer
        }
    }
    
    private var textLabel =  UILabel()
    private var shadowLayer = CAShapeLayer()
    private var dashLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
    
        // shadow
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.strokeColor = dashGray.cgColor
        shadowLayer.lineWidth = 1
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowRadius = 3
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3)
        shadowLayer.shadowOpacity = 0.8
        
        // dash border
        dashLayer.fillColor = UIColor.clear.cgColor
        dashLayer.strokeColor = dashGreen.cgColor
        dashLayer.lineWidth = 1
        
        // label
        textLabel.textAlignment = .center
        textLabel.backgroundColor = UIColor.clear
        textLabel.numberOfLines = 0
        
        contentView.layer.addSublayer(shadowLayer)
        contentView.layer.addSublayer(dashLayer)
        contentView.addSubview(textLabel)
        
        // default
        shadowLayer.isHidden = true
        dashLayer.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let mainFrame = bounds.insetBy(dx: 1.5, dy: 0.1 * bounds.height)
        let path = UIBezierPath(roundedRect: mainFrame, cornerRadius: 3)
        
        textLabel.frame = mainFrame
        textLabel.font = UIFont.systemFont(ofSize: mainFrame.height / 2.5)
        shadowLayer.frame = bounds
        dashLayer.frame = bounds
        
        shadowLayer.path = path.cgPath
        shadowLayer.shadowPath = path.cgPath

        dashLayer.path = path.cgPath
        dashLayer.lineDashPhase = 2
        dashLayer.lineDashPattern = [4,2]
    }
}

class AnswersCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var hostTableView: IndividualAnswerTableView!
    var tableRow: Int!
    var options = [String]() {
        didSet{
            reloadData()
        }
    }
    
    // -1 is not answered
    // Answer can not be cancel by selection
    var answerIndex = -1 {
        didSet{
            if answerIndex != oldValue {
                UIView.performWithoutAnimation {
                    // update items
                    if answerIndex == -1 {
                        print("this is happening heheheheheeeeeeeeeeeeeeeeeeee")
                        performBatchUpdates({ 
                            self.reloadItems(at: [IndexPath(item: oldValue, section: 0)])
                        }, completion: nil)
                    }else if oldValue == -1 {
                        // only reload one cell
                        performBatchUpdates({
                            self.reloadItems(at: [IndexPath(item: self.answerIndex, section: 0)])
                        }, completion: nil)
                    }else {
                        performBatchUpdates({
                            self.reloadItems(at: [IndexPath(item: oldValue, section: 0), IndexPath(item: self.answerIndex, section: 0)])
                        }, completion: nil)
                    }
                    // updata data in table
                    hostTableView.answerIndexes[tableRow] = answerIndex
                }
            }
        }
    }
    
    class func createAnswers(_ frame: CGRect, options: [String], answerIndex: Int) -> AnswersCollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        let collection = AnswersCollectionView(frame: frame, collectionViewLayout: flowLayout)
        collection.options = options
        collection.answerIndex = answerIndex
        
        collection.register(AnswerCollectionViewCell.self, forCellWithReuseIdentifier: answerCellID)
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: answerCellID, for: indexPath) as! AnswerCollectionViewCell
        cell.optionTitle = options[indexPath.item]
        cell.isAnswer = false
        
        if indexPath.item == answerIndex {
            cell.isAnswer = true
        }
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        answerIndex = indexPath.item
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let num = CGFloat(options.count)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 2
        
        flowLayout.itemSize = CGSize(width: (bounds.width - 4 - (num - 1) * 2) / num , height: bounds.height * 0.8)
    }
}
