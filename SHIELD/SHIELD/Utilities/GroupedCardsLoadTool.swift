//
//  GroupedCardsLoadTool.swift
//  SHIELD
//
//  Created by L on 2019/10/10.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class GroupedCardsAndRecordLoadTool: NSObject, DataAccessProtocal {
    fileprivate var loadingVC: LoadingViewController!
    
    // REST api model source
    fileprivate var applicationClassAccess: ApplicationClassAccess!
    fileprivate var riskListAccess: RiskListAccess!
    fileprivate var gameAccess: GameDataAccess!
    
    fileprivate var loadIsFinished: ((Bool)->Void)?
    fileprivate weak var loadingOn: UIViewController!
    fileprivate var riskKey: String!
    
    func loadForRisk(_ riskKey: String?, loadingOn: UIViewController!, completion: ((Bool)->Void)?) {
        if riskKey == nil {
            return
        }
        
        self.loadIsFinished = completion
        self.loadingOn = loadingOn
        self.riskKey = riskKey
        
        if !collection.categoryLoaded {
            // no data for group
            if let riskFactorCategoryKey = ApplicationDataCenter.sharedCenter.riskFactorCategoryKey {
                self.applicationClassAccess = ApplicationClassAccess(callback: self)
                
                startLoading({
                    self.applicationClassAccess.getMetricGroupsByKey(riskFactorCategoryKey)
                })
            }
        }else {
            // has data
            self.checkAndGetCards()
        }
    }

    fileprivate func checkAndGetCards() {
        // do we have data?
        // focusDeckOfCardViewsOnRiskClass(riskClassKey) <- assumes risk model object was already loaded
        // do we have risk model object loaded aready?
        if collection.checkRiskObject(riskKey) {
            // have the risk object already
            loadIsFinished?(true)
        }else {
            // no.  need to load the object
            riskListAccess = RiskListAccess(callback: self)
            
            startLoading({
                self.riskListAccess.getOneGraphByKey(key: self.riskKey)
            })
        }
    }
    
    
    fileprivate func checkRecord() {
        let userKey = userCenter.currentGameTargetUser.Key()
        if WHATIF {
            // from local
            selectionResults.getAllLocalMeasurementsForUser(userKey, riskKey: riskKey)
            loadIsFinished?(true)
        }else {
            // measurement
            if !selectionResults.measurementLoadedFromBackendForUser(userKey, riskKey: riskKey) {
                gameAccess = GameDataAccess(callback: self)
                
                // get measurements
                let gameInput = GameRiskInput()
                gameInput.riskKey = riskKey
                gameInput.userKey = userKey
                
                startLoading({
                    self.gameAccess.riskMeasurementList(gameInput)
                })
            }else {
                loadIsFinished?(true)
            }
        }
    }
    
    fileprivate func startLoading(_ action: (()->Void)?) {
        if loadingVC == nil {
            loadingVC = LoadingViewController()
        }
        
        if !loadingVC.isLoading && loadingOn != nil {
            loadingOn.present(loadingVC, animated: true) {
                action?()
            }
        }else {
            action?()
        }
    }
    
    fileprivate func finshLoadingRecord(_ success: Bool) {
        if loadingVC != nil && loadingVC.isLoading {
            loadingVC.dismiss(animated: true, completion: {
                self.loadIsFinished?(success)
            })
        }else {
            loadIsFinished?(success)
        }
    }
    ////////////////////////////////////////////////////////////////////////////
    
    // metric group ---- the category
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [MetricGroupObjModel] {
            collection.updateCategory(obj as! [MetricGroupObjModel], fromNet: true)
        }
        
        // get risks
        checkAndGetCards()
    }
    
    // set risk focus cursor position
    // !!! load a risk "game" and attach it to navigation cursor for card matching "game"
    // riskFactors
    func didFinishGetGraphByKey(_ obj: AnyObject) {
        if obj is RiskObjListModel {
            collection.updateRiskModelFromList((obj as! RiskObjListModel).risk)
        }
        
        checkRecord()
    }

    
    // failed
    func failedGetDataByKey(_ error: String) {
        if USERECORD {
            finshLoadingRecord(true)
        }else {
            finshLoadingRecord(false)
//            if error == unauthorized {
//                let alert = UIAlertController(title: nil, message: "You are not authorized due to overtime idleness", preferredStyle: .alert)
//                let relogin = UIAlertAction(title: "Log In", style: .default, handler: { (login) in
//                    let loginVC = LoginViewController.createFromNib()
//
//                    self.navigationController?.pushViewController(loginVC, animated: true)
//                })
//
//                let giveUp = UIAlertAction(title: "No", style: .destructive, handler: nil)
//
//                alert.addAction(relogin)
//                alert.addAction(giveUp)
//
//                // alert
//                present(alert, animated: true, completion: nil)
//            }else {
//                let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "Go Back and Retry", style: .cancel, handler: {
//                    (reload) in
//
//                    for vc in self.navigationController!.viewControllers {
//                        if vc.isKind(of: IntroPageViewController.self) {
//                            self.navigationController?.popToViewController(vc, animated: true)
//                            return
//                        }
//                    }
//
//                    self.navigationController?.popViewController(animated: true)
//                })
//                errorAlert.addAction(cancelAction)
//                present(errorAlert, animated: true, completion: nil)
//            }
        }
    }
    
    func failedGetAttribute(_ error: String) {
        if USERECORD {
            collection.updateCategory([], fromNet: false)
            finshLoadingRecord(true)
        }
    }
    
    // measurement
    func didFinishGetDataByKey(_ obj: AnyObject) {
        if obj is MeasurementListObjModel {
            let measurementList = (obj as! MeasurementListObjModel).measurementList
            if let measurement = measurementList.first {
                selectionResults.loadMeasurementFromBackend(measurement)
                selectionResults.useLastMeasurementForUser(userCenter.currentGameTargetUser.Key(), riskKey: riskKey, whatIf: false)
            }
            
            finshLoadingRecord(true)
        }
    }

}
