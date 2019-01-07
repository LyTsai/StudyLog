//
//  DoImpactfulViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/20.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class DoImpactfulViewController: UIViewController {
    var addView: UIView!
    var collection: PlansCollectionView!
    
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.topItem?.title = ""
        
        var plans = NSKeyedUnarchiver.unarchiveObject(withFile: planPath) as? [PlanModel]
        if plans == nil {
            plans = PlanModel.getPlans()
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: topLength, width: width, height: 48 * height / 667))
        titleLabel.text = "\(plans!.count) TIPS TO BE HEALTHY"
        titleLabel.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightHeavy)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    
        collection = PlansCollectionView.createWithFrame(CGRect(x: 0, y: titleLabel.frame.maxY, width: width, height: height - titleLabel.frame.maxY - bottomLength), plans: plans!, date: date)
        collection.hostVCDelegate = self
        view.addSubview(collection)
        
        let addHeight = 64 * height / 667
        addView = UIView(frame: CGRect(x: 0, y: height - bottomLength - addHeight, width: width, height: addHeight))
        addView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.addSubview(addView)
        addView.isHidden = true
        
        let addButton = UIButton.customThickRectButton("Add plans")
        addButton.adjustThickRectButton(CGRect(center: CGPoint(x: addView.frame.midX,y: addHeight * 0.55), width: 168, height: addHeight * 0.8))
        addView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addPlans), for: .touchUpInside)
    }
    
    func addPlans() {
        // store
        NSKeyedArchiver.archiveRootObject(collection.plans, toFile: planPath)

        // push
//        for vc in navigationController!.viewControllers {
//            if vc.isKind(of: ToDoListViewController.self) {
//                let _ = navigationController?.popToViewController(vc, animated: true)
//                break
//            }
//        }
        
        let habitVC = EstablishAHabitViewController()
        navigationController?.pushViewController(habitVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Do What's Impactful"
    }
}
