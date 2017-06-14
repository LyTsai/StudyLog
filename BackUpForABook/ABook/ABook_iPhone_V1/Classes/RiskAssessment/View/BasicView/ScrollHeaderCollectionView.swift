//
//  ScrollHeaderCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/11/16.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// ScrollHeaderCollectionView:the collection view of risk colelction for user selection.  It display array of "risk classes" or riskMetrics that represents the avialble risk model types which has many versions of specific risk models.  for example, CVD risk may have many different models for assessing CVD risks.

// MARK: ----------------- header collection cell --------------------
let headerCellID = "header cell Identifier"
/** imageWidth / cellHeight */

class HeaderCollectionViewCell: UICollectionViewCell {
    var text = "" {
        didSet{ textLabel.text = text }
    }
    
    var image = UIImage(named: "icon_risk_VD") {
        didSet{ imageView.image = image }
    }

    // private
    fileprivate var imagePro: CGFloat = 0.4
    fileprivate var imageWidth: CGFloat {
        return bounds.height * imagePro
    }

    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let shadowLayer = CALayer()
    fileprivate var imageView = UIImageView()
    fileprivate var textLabel = UILabel()
    
    // TODO: add this later
    fileprivate var algoInfo = UIView()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOpacity = 0.9
        contentView.layer.addSublayer(shadowLayer)
        
        gradientLayer.locations = [0, 0.66]
        gradientLayer.colors = [cellUpColor.cgColor, cellDownColor.cgColor]
        contentView.layer.addSublayer(gradientLayer)

        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.backgroundColor = UIColor.clear
        
        imageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(textLabel)
        contentView.addSubview(imageView)
    }
    
    // selected and unselected
    override var isSelected: Bool {
        didSet {
            textLabel.textColor = (isSelected ? selectedTextColor: unselectedTextColor)
            gradientLayer.isHidden = !isSelected
            shadowLayer.shadowColor = isSelected ? cellUpColor.cgColor : cellShadowColor.cgColor
            shadowLayer.backgroundColor = isSelected ? cellUpColor.cgColor :UIColor.white.cgColor
            imagePro = (isSelected ? 0.75 : 0.4)
            
            contentView.layer.masksToBounds = !isSelected
            
            layoutSubviews()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = ""
        isSelected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        shadowLayer.frame = isSelected ? bounds: bounds.insetBy(dx: 0.5, dy: 0.094 * bounds.height)
        shadowLayer.shadowPath = UIBezierPath(rect: shadowLayer.frame).cgPath
        
        gradientLayer.frame = bounds.insetBy(dx: 0.5, dy: 1)
        gradientLayer.cornerRadius = 5
        gradientLayer.masksToBounds = true
        
        imageView.frame = CGRect(x: 0.1 * bounds.width, y: (bounds.height - imageWidth) * 0.5, width: imageWidth, height: imageWidth)
        textLabel.frame = CGRect(x: imageView.frame.maxX, y: bounds.height * 0.1, width: 0.8 * bounds.width - imageWidth, height: bounds.height * 0.8)
        textLabel.font = UIFont.systemFont(ofSize: bounds.height / 3.06)
    }
}

// MARK: ------------ ScrollHeaderCollectionView  ----------------
/** cellWidth / bounds.width */
class ScrollHeaderCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var assessmentDelegate: AssessmentTopView!
    // collection of risk classes.  the class of risk is represented by metric since risk is a metric by itself
    fileprivate var riskClasses = [MetricObjModel]() {
        didSet { reloadData() }
    }
    
    class func createHeaderWithFrame(_ frame: CGRect, dataSource: [MetricObjModel]) -> ScrollHeaderCollectionView {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsets.zero
        collectionViewLayout.itemSize = CGSize(width: frame.width / 3, height: frame.height)
        
        let headerCollectionView = ScrollHeaderCollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        headerCollectionView.riskClasses = dataSource
        headerCollectionView.backgroundColor = UIColor.clear
        headerCollectionView.indicatorStyle = .white
        
        headerCollectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: headerCellID)
        
        headerCollectionView.dataSource = headerCollectionView
        headerCollectionView.delegate = headerCollectionView

        return headerCollectionView
    }
    
    // MARK: --------- collectionView of header -----------------
    var selectedIndexPath = Foundation.IndexPath(item: 0, section: 0) // the first as default
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return riskClasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellID, for: indexPath) as! HeaderCollectionViewCell
        configureCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: HeaderCollectionViewCell, forIndexPath indexPath: Foundation.IndexPath) {
        cell.isSelected = false
        let riskClass = riskClasses[indexPath.item]
        cell.text = riskClass.name!
        
        cell.image = riskClass.imageObj ?? UIImage(named: "icon_risk_VD")
        if indexPath == selectedIndexPath {
            cell.isSelected = true
        }
    }

    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // once clicked, show alert
        if indexPath != selectedIndexPath {
            // use alert
            let alert = UIAlertController(title: "You want To", message: nil, preferredStyle: .alert)
            let exit = UIAlertAction(title: "See the Selected Game without Saving", style: .destructive) { (action) in
                // selected
                self.getBackToIntro(indexPath.item)
            }
            let save = UIAlertAction(title: "Save and Move the Selected Game", style: .default) { (action) in
                // !!! To Do, prompt for user to register if UserCenter.sharedCenter.userState != .login since we only save the result for registered users
                
                if UserCenter.sharedCenter.userState == .login && UserCenter.sharedCenter.loginUserBackendAccess?.userKey != nil {
//                    CardSelectionResults.cachedCardProcessingResults.saveTargetUserCardResults(UserCenter.sharedCenter.currentGameTargetUser)
                }
              
                // user selected a risk class item.
                self.getBackToIntro(indexPath.item)
            }
                
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.performBatchUpdates({
                    self.reloadItems(at: [self.selectedIndexPath, indexPath])
                }, completion: { (true) in
                    self.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: true)
                })
            }
                
            alert.addAction(exit)
            alert.addAction(save)
            alert.addAction(cancel)
            
            assessmentDelegate.controllerDelegate.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func getBackToIntro(_ index: Int) {
        let cursor = RiskMetricCardsCursor.sharedCursor
//        cursor.selectedIndex = index
        
        let navi = assessmentDelegate.controllerDelegate.navigationController
        var poped = false
        
        for vc in navi!.viewControllers {
            if vc.isKind(of: IntroPageViewController.self) {
                let _ = navi?.popToViewController(vc, animated: true)
                poped = true
                break
            }
        }
        
        if !poped {
            let _ = navi?.popViewController(animated: true)
        }
    
    }

    // update UI for selected/ unselected items. when assessmentDelegate.selectedHeaderIndex is set, it is called.
    func updateUIAtItem(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        
        let lastSelectedIndexPath = self.selectedIndexPath
        self.selectedIndexPath = indexPath
        if (lastSelectedIndexPath == indexPath) { return }
        
        // new selection of risk
        performBatchUpdates({
            self.reloadItems(at: [lastSelectedIndexPath])
            self.reloadItems(at: [indexPath])
        }) { (true) in
            self.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            // put focus onto selected risk item
        }
    }
    
    // return current selected risk class
//    func focusingRiskClass()->MetricObjModel? {
//        return riskClasses[assessmentDelegate.selectedHeaderIndex]
//    }
}

