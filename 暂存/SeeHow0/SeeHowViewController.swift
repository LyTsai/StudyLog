//
//  SeeHowViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SeeHowViewController: UIViewController, DataAccessProtocal {
    var container: TemplateCardContainer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""

        // title
        let topHeight: CGFloat = 0
        
        let userKey = UserCenter.sharedCenter.currentGameTargetUser.Key()
        let risks = MatchedCardsData.getAllRisksPlayedOfUser(userKey)
        let cardsFrame = CGRect(x: 0, y: 64 + topHeight, width: width, height: height - 64 - 49 - topHeight)
        
        // subviews
        if risks.count == 0 {
            let addView = ViewForAdd.createWithFrame(cardsFrame.insetBy(dx: 40, dy: 70), topImage: UIImage(named: "icon_search"), title: "No Assessment to Check", prompt: "please go to assessment you are interested in")
            addView.personImageView.image = UIImage(named: "icon_assess")
            view.addSubview(addView)
        } else{
            // back
            let backImageView = UIImageView(frame: view.bounds)
            backImageView.image = UIImage(named: "homeBackImage")
            view.addSubview(backImageView)
        
            // collection
            let collection = MatchedCardsCollectionView.createWithFrame(cardsFrame, risks: risks, withAssessment: true)
            
            view.addSubview(collection)
        }
        
        
        
//         container
//        let bottomHeight = 60 * height / 667
//        container = TemplateCardContainer(frame: CGRect(x: 0, y: 64 + topHeight, width: width, height: height - 64 - 49 - bottomHeight - topHeight))
        
        // !!! Lisa: not with risk factors but with the measurements
//        let access = RiskFactorAccess(callback: self as DataAccessProtocal)
//        access.getAll()
//        access.beginApi(view)
//        
//        view.addSubview(container)
//        
//        // buttons
//        let doEasyButton = UIButton.customNormalButton("Do What's easy")
//        let doImpactfulButton = UIButton.customNormalButton("Do What's Impactful")
//        doEasyButton.adjustNormalButton(CGRect(x: 15, y: container.frame.maxY + bottomHeight * 0.1, width: width * 0.45, height: bottomHeight * 0.8))
//        doImpactfulButton.adjustNormalButton(CGRect(x: doEasyButton.frame.maxX, y: container.frame.maxY + bottomHeight * 0.1, width: width - 15 - doEasyButton.frame.maxX, height: bottomHeight * 0.8))
//        
//        doEasyButton.addTarget(self, action: #selector(goToDoEasy), for: .touchUpInside)
//        doImpactfulButton.addTarget(self, action: #selector(goToDoImpactful), for: .touchUpInside)
//        
//        view.addSubview(doEasyButton)
//        view.addSubview(doImpactfulButton)
    }
    
//    func goToDoEasy()  {
//        let doEasyVC = DoEasyViewController()
//        navigationController?.pushViewController(doEasyVC, animated: true)
//    }
//    
//    func goToDoImpactful()  {
//        let doImpactfulVC = DoImpactfulViewController()
//        navigationController?.pushViewController(doImpactfulVC, animated: true)
//    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = "See How I am Doing"
    }
    
}

    

