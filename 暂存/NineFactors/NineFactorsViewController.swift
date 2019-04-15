//
//  NineFactorsViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/14.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class NineFactorsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate var nineFactorsCollectionView: UICollectionView!
    fileprivate var factors = [NineFactorsModel]()
    fileprivate let confirm = UIButton.customThickRectButton("None")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "9 factors card game"
        view.layer.contents = UIImage(named: "landingPageBack")?.cgImage
        
        factors = NineFactorsModel.getArchivedFactors() ?? NineFactorsModel.getAllFactors()
        // collection
        let standP = min(standHP, standWP)
        let edgeInset = UIEdgeInsets(top: 60 * standP, left: 15 * standP, bottom: 68 * standP, right: 15 * standP)
        let spacing = 5 * standP
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = edgeInset
        flowLayout.itemSize = CGSize(width: (mainFrame.width - edgeInset.left - edgeInset.right - 2 * spacing) / 3, height: (mainFrame.height - edgeInset.top - edgeInset.bottom - 2 * spacing) / 3)
        
        nineFactorsCollectionView = UICollectionView(frame: mainFrame, collectionViewLayout: flowLayout)
        nineFactorsCollectionView.backgroundColor = UIColor.clear
        
        nineFactorsCollectionView.delegate = self
        nineFactorsCollectionView.dataSource = self

        nineFactorsCollectionView.register(NineFactorsCollectionViewCell.self, forCellWithReuseIdentifier: nineFactorsCellID)
        
        view.addSubview(nineFactorsCollectionView)
        
        // title and confirm
        let titleLabel = UILabel(frame: CGRect(x: edgeInset.left, y: mainFrame.minY, width: mainFrame.width - 2 * edgeInset.left, height: edgeInset.top))
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = "Choose Your Behaviors"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        view.addSubview(titleLabel)
        
        // confirm
        for factor in factors {
            if factor.checked {
                confirm.setTitle("Confirm", for: .normal)
                break
            }
        }
        
        confirm.adjustThickRectButton(CGRect(center: CGPoint(x: view.bounds.midX, y: mainFrame.maxY - 38 * standHP), width: 178 * standWP, height: 48 * standHP))
        confirm.addTarget(self, action: #selector(confirmFactors), for: .touchUpInside)
        view.addSubview(confirm)
    }
    
    func confirmFactors() {
        NineFactorsModel.archiveFactors(factors)
        let alert = UIAlertController(title: "Selections are confirmed and saved", message: nil, preferredStyle: .alert)
        let sure = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(sure)
        
        present(alert, animated: true, completion: nil)
    }
    
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return factors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nineFactorsCellID, for: indexPath) as! NineFactorsCollectionViewCell
        let factor = factors[indexPath.item]
        cell.configureCellWithText(factor.text, image: UIImage(named: factor.imageName), bannerColor: factor.bannerColor, checked: factor.checked)
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let factor = factors[indexPath.item]
        factor.checked = !factor.checked
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
        
        confirm.setTitle("None", for: .normal)
        for factor in factors {
            if factor.checked {
                confirm.setTitle("Confirm", for: .normal)
                break
            }
        }
    }
    
}
