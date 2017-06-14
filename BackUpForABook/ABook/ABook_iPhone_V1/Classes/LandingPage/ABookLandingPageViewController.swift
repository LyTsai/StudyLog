//
//  ABookLandingPageViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ABookLandingPageViewController: UIViewController {
    var landingModel = LandingModel()
    fileprivate var landing: LandingPageTireView!
    fileprivate var landingFrame: CGRect {
        return CGRect(x: 0, y: 64, width: width, height: height - 64 - 49)
    }
    
    // ------------- cloud object store access -------------
    var riskAccess: RiskAccess?
    var metricAccess: MetricAccess?   // <- the metrics tier will be removed later
    
    // MARK: ------- methods ---------------
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.contents = ProjectImages.sharedImage.backImage?.cgImage
        
        ///* removed as part of using REST api backend
        if AIDMetricCardsCollection.standardCollection.bNeed2ReloadModels {
            // load risk indexes
            if riskAccess == nil {
                riskAccess = RiskAccess(callback: self)
            }
            // !!! Hui: Don't comment out this for now since we need it for getting the class of each risk (currently the REST api doesn't include the full metric object for us to get risk type information).  Once the risk objects returned by the backend include the metric as class information we will remove the metricAccess here
            if metricAccess == nil {
                metricAccess = MetricAccess(callback: self)
            }
            
            riskAccess?.beginApi(view)
            riskAccess?.getAll()
        } else {
            // create landing model if needed
            landingModel.reloadDataForLanding()
            landing = LandingPageTireView.createWithFrame(landingFrame, landingModel: landingModel)
            landing.hostVC = self
            
            view.addSubview(landing)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "Home"
    }
}

extension ABookLandingPageViewController: DataAccessProtocal {
    
    func didFinishGetAllData(_ objs: [AnyObject]) {
        if objs is [RiskObjModel] {
            // got risk indexes.  updata disk indexes
            AIDMetricCardsCollection.standardCollection.updateRiskMap(objs as! [RiskObjModel])
        }
        // mark as up to date
        AIDMetricCardsCollection.standardCollection.bNeed2ReloadModels = false
        
        // create landing model if needed
        landingModel.reloadDataForLanding()
        landing = LandingPageTireView.createWithFrame(landingFrame, landingModel: landingModel)
        landing.hostVC = self
        view.addSubview(landing)
    }
    
    func failedGetAllData(_ error: String) {
        
        //alertMsg(error)
    }
}

