//
//  SingletonData.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/28.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

// system
let userDefaults = UserDefaults.standard

// custom
let collection = AIDMetricCardsCollection.standardCollection
let cardsCursor = RiskMetricCardsCursor.sharedCursor
let selectionResults = CardSelectionResults.cachedCardProcessingResults
let userCenter = UserCenter.sharedCenter
let localDB = LocalDatabase("ShieldLocalDB", tablesData: [(ApplicationObjModel.tableName, ApplicationObjModel.localColumns),
                                                            (RiskTypeObjModel.tableName, RiskTypeObjModel.localColumns),
                                                            (MetricGroupObjModel.tableName, MetricGroupObjModel.localColumns),
                                                            (MetricObjModel.tableName, MetricObjModel.localColumns),
                                                            (RiskObjModel.tableName, RiskObjModel.localColumns),
                                                            
                                                            // login
                                                    (UserObjModel.tableName, UserObjModel.localColumns),
                                                    (PseudoUserObjModel.tableName, PseudoUserObjModel.localColumns),
                                                    (UserGroupObjModel.tableName, UserGroupObjModel.localColumns),
                                                    
                                                    // get card
                                                    (CardInfoObjModel.tableName, CardInfoObjModel.localColumns),
                                                    (RiskFactorObjModel.tableName, RiskFactorObjModel.localColumns),
                                                    (CardOptionObjModel.tableName, CardOptionObjModel.localColumns),
                                                    (MatchObjModel.tableName, MatchObjModel.localColumns),
                                                    (ClassifierObjModel.tableName, ClassifierObjModel.localColumns),
                                                    (ClassificationObjModel.tableName, ClassificationObjModel.localColumns),
                                                    (RangeGroupObjModel.tableName, RangeGroupObjModel.localColumns),
                                                    (RangeObjModel.tableName, RangeObjModel.localColumns),
                                                    
                                                    // measurement
                                                    (MeasurementObjModel.tableName, MeasurementObjModel.localColumns)])
