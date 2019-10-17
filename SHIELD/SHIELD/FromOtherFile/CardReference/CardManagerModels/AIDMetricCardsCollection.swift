//
//  AIDMetricCardsCollection.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// AIDMetricCardsCollection - collection of all models (risk, metrics etc)
// MARK: ------------ Singleton Class --------------
// 5.5.2017 - migrate to REST api backend access
class AIDMetricCardsCollection {
    // MARK: ---------- singleton
    static let standardCollection = AIDMetricCardsCollection()
    
    // MARK: ---------- readonly public dictionaries -----------
    // MARK: ---------------- key to object ---------------------
    // collectio of all groups {Key, categories}
    fileprivate var key2Group = [String: MetricGroupObjModel]()
    // collection of all MetricObjModels: {key, MetricObjModel}
    fileprivate var key2Metric = [String: MetricObjModel]()
    // riks models mapped by risk model key: {risk key, RiskObjModel} of ALL risks.  here is ALL risk object models regardless their classes (types or topics)
    fileprivate var key2Risk = [String: RiskObjModel]()
    fileprivate var key2RiskType = [String: RiskTypeObjModel]()
    // collection of all cards {key, cardInfo}
    fileprivate var key2Card = [String: CardInfoObjModel]()
    // collection of all riskFactor {key, RIskFactor}
    fileprivate var key2Factor = [String: RiskFactorObjModel]()
    // collection of all match options {key, options}
    fileprivate var key2Match = [String: MatchObjModel]()
    // collection of all classifications {key, Classification}
    fileprivate var key2Classification = [String: ClassificationObjModel]()
    
    // MARK: ----------- sorted dictionary --------------
    // mapping of risk models: {risk key, array(RiskFactorObjModel)}
    
    // riskClass category
    // secondary group
    // !!! map risk metric (representing the type or topic of risk, "CVD" for example) to list of avialible models: {riskMetricKey, [riskKey]}.  riskMetricKey can be thought as defining the topic this risk about.  For the same risk class there are can be more than one risk objects published by various sources.  Fro example, there are at least 3 risk models for the "CVD" risk assessment etc.  !!! note that in the new versions the RiskObjModel.metricKey is treated as the "topic" or model target etc
    // [metricKey: [riskTypeKey: Set<riskKey>]]
  
    // MARK: ----------------- home page, load grouped riskClassses
    func loadMetricGroupsFromLocal(_ appplicationClassKey: String) {
        if localDB.database.open() {
            let all = localDB.getModelDicsWithColumnName("ApplicationClassKey", value: appplicationClassKey, inTable: MetricGroupObjModel.tableName)
            for one in all {
                if let group = MetricGroupObjModel.fromSqliteDicToModel(one) {
                    key2Group[group.key] = group
                }else {
                    print("not saved")
                }
            }
    
            localDB.database.close()
        }
    }
    
    // [AppTopicCategroy: loaded]
    fileprivate var applicationMetricGroupLoaded = [String: Bool]()
    func metricGroupsLoadedForApplicationClass(_ applicationClassKey: String) -> Bool {
        return applicationMetricGroupLoaded[applicationClassKey] ?? false
    }
    func loadMetricGroups(_ metricGroups: [MetricGroupObjModel], applicationClassKey: String, fromNet: Bool) {
        if fromNet {
            applicationMetricGroupLoaded[applicationClassKey] = true
            for group in metricGroups {
                key2Group[group.key] = group
            }
            
            if localDB.database.open() {
                for category in metricGroups {
                    category.saveToLocalDatabase()
                }
                localDB.database.close()
            }
        }else {
            if localDB.database.open() {
                let all = localDB.getModelDicsWithColumnName("ApplicationClassKey", value: applicationClassKey, inTable: MetricGroupObjModel.tableName)
                for one in all {
                    if let group = MetricGroupObjModel.fromSqliteDicToModel(one) {
                        key2Group[group.key] = group
                    }
                }
                localDB.database.close()
            }
        }
    }
    
    // [group: loaded]
    fileprivate var metricsLoaded = [String: Bool]()
    func metricsLoadedForGroup(_ metricGroupKey: String) -> Bool {
        return metricsLoaded[metricGroupKey] ?? false
    }
    
    func updateRiskClasses(_ metrics: [MetricObjModel], withMetricGroup groupKey: String, fromNet: Bool) {
        if let group = getMetricGroupByKey(groupKey) {
            if fromNet {
                metricsLoaded[group.key] = true
                USERECORD = false
                
                var metricKeys = [String]()
                for metric in metrics {
                    key2Metric[metric.key] = metric
                    metricKeys.append(metric.key)
                }
                
                group.metricKeys = metricKeys
                
                if fromNet && localDB.database.open() {
                    group.saveToLocalDatabase()
                    for metric in metrics {
                        metric.saveToLocalDatabase()
                    }
                    localDB.database.close()
                }
            }else {
                if localDB.database.open() {
                    for metricKey in group.metricKeys {
                        let _ = getMetricWithLocalKey(metricKey)
                    }
                    localDB.database.close()
                }
            }
        }else {
            print("Data not loaded for metricGroup: \(groupKey)")
        }
       
    }
    
    fileprivate func tempIconForRisk(_ riskKey: String) {
        if let risk = getRisk(riskKey) {
            if risk.imageUrl == nil {
                risk.imageUrl = risk.metric?.imageUrl
            }
        }
    }
    
    // metric
    fileprivate var metricLoaded = [String: Bool]()
    func metricIsLoadedFromNet(_ key: String) -> Bool {
        return metricLoaded[key] ?? false
    }
    func loadMetric(_ metric: MetricObjModel, fromNet: Bool) {
        key2Metric[metric.key] = metric
        metricLoaded[metric.key] = fromNet
        
        // local
        if fromNet && localDB.database.open() {
            metric.saveToLocalDatabase()
            localDB.database.close()
        }
    }
    // risk
  
    

    // category and risk
    fileprivate var risksLoadedForType = [String: Bool]()
    func risksLoadedForTypeFromNet(_ riskTypeKey: String) -> Bool {
        return risksLoadedForType[riskTypeKey] ?? false
    }
    func loadRisks(_ risks: [RiskObjModel], riskTypeKey: String, fromNet: Bool) {
        if fromNet {
            USERECORD = false
            if riskTypeKey != "" {
                risksLoadedForType[riskTypeKey] = true
            }
            
            var fineRisks = [RiskObjModel]()
            for risk in risks {
                if let metric = getMetric(risk.metricKey ?? "") {
                    risk.metric = metric
                    key2Risk[risk.key] = risk
                    fineRisks.append(risk)
                    tempIconForRisk(risk.key)
                }else {
                    print("this risk has no metric for this game")
                }
            }
            
            if localDB.database.open() {
                for risk in fineRisks {
                    risk.saveToLocalDatabase()
                }
                localDB.database.close()
            }
        }else {
            if localDB.database.open() {
                let allRisks = localDB.getAllModels(RiskObjModel.tableName)
                for one in allRisks {
                    if let risk = RiskObjModel.fromSqliteDicToModel(one) {
                        if let metric = getMetric(risk.metricKey ?? "") {
                            risk.metric = metric
                            key2Risk[risk.key] = risk
                            tempIconForRisk(risk.key)
                        }
                    }
                }
                localDB.database.close()
            }
        }
    }

    fileprivate var risksLoadedForMetric = [String: Bool]()
    func risksLoadedForMetric(_ metricKey: String) -> Bool {
        return risksLoadedForMetric[metricKey] ?? false
    }
    func loadRisks(_ risks: [RiskObjModel], metricKey: String, fromNet: Bool) {
        if fromNet {
            USERECORD = false
            risksLoadedForMetric[metricKey] = true
            for risk in risks {
                key2Risk[risk.key] = risk
            }
            
            if localDB.database.open() {
                for risk in risks {
                    risk.saveToLocalDatabase()
                }
                localDB.database.close()
            }
        }else {
            if localDB.database.open() {
                let allRisks = localDB.getAllModels(RiskObjModel.tableName)
                for one in allRisks {
                    if let risk = RiskObjModel.fromSqliteDicToModel(one) {
                        if let metric = getMetric(risk.metricKey ?? "") {
                            risk.metric = metric
                            key2Risk[risk.key] = risk
                        }
                    }
                }
                localDB.database.close()
            }
        }
    }
    
    // MARK: ------- risk----------------
    ///////////////////////////////////////////////////////////
    // load one risk model object.
    ///////////////////////////////////////////////////////////
    // Connnected
    // check risk model object for given class
    fileprivate var riskDetailLoadFromNet = [String: Bool]()
    func checkRiskObject(_ riskKey: String) -> Bool {
        return riskDetailLoadFromNet[riskKey] ?? false
    }
    
    /*
     updated:
     risk.metric
     risk.author(NA)
     risk.classifers (classfier.classification)
     risk.riskFactors (riskFactor.card -> card.cardOptions -> cardOption.match -> match.classification)
     */
    func updateRiskModelFromList(_ risk: RiskObjModel) {
        riskDetailLoadFromNet[risk.key] = true
       
        // objects created by RiskObjList, need to be saved by local
        var updatedCards = [CardInfoObjModel]()
        var updatedOptions = [CardOptionObjModel]()
        var updatedMatches = [MatchObjModel]()
        var updatedClassifications = Set<String>()
    
        // risk.classifiers
        for classifier in risk.classifiers {
            if let classification = classifier.classification {
                key2Classification[classification.key] = classification
                updatedClassifications.insert(classification.key)
            }
        }
       
        // sort
        risk.classifiers.sort(by: {($0.rangeGroup?.groupRanges.first?.max ?? 0)
            < ($1.rangeGroup?.groupRanges.first?.max ?? 0)})
        
        var classifierKeys = [String]()
        for classifier in risk.classifiers {
            classifierKeys.append(classifier.key)
        }
        risk.classifierKeys = classifierKeys
        
        // riskFactors
        var factorArray = [RiskFactorObjModel]()
        for riskFactor in risk.riskFactors {
            if riskFactor.card == nil {
                continue
            }
            
            // MARK: -------- since local data is loaded before, always get the lateset data
            key2Factor[riskFactor.key] = riskFactor
            
            // card
            let card = riskFactor.card!
        
            // seqNumber
            card.cardOptions.sort(by: {($0.seqNumber ?? 0) < ($1.seqNumber ?? 0)})
            
            var optionKeys = [String]()
            for option in card.cardOptions {
                optionKeys.append(option.key)
                
                if let match = option.match {
                    key2Match[match.key] = match
                    if let classification = match.classification {
                        if !updatedClassifications.contains(classification.key) {
                            key2Classification[classification.key] = classification
                            updatedClassifications.insert(classification.key)
                        }
                    }
                    
                    updatedMatches.append(match)
                }
            }
                
            card.cardOptionKeys = optionKeys
            updatedOptions.append(contentsOf: card.cardOptions)
            
            // add
            key2Card[card.key] = card
            updatedCards.append(card)
            
            factorArray.append(riskFactor)
        }
    
        // reset filted factors
        factorArray.sort(by: {$0.seqNumber ?? 0 < $1.seqNumber ?? 0 })
        risk.riskFactors = factorArray
        var factorKeys = [String]()
        for risk in factorArray {
            factorKeys.append(risk.key)
        }
        
        risk.riskFactorKeys = factorKeys
        
        key2Risk[risk.key] = risk
        tempIconForRisk(risk.key)
        
        // local
        if localDB.database.open() {
            risk.saveToLocalDatabase()
            
            for factor in factorArray {
                factor.saveToLocalDatabase()
            }
            
            for card in updatedCards {
                card.saveToLocalDatabase()
            }
            
            for option in updatedOptions {
                option.saveToLocalDatabase()
            }
            for match in updatedMatches {
                match.saveToLocalDatabase()
            }
            
            // classification
            for classification in updatedClassifications {
                key2Classification[classification]!.saveToLocalDatabase()
            }
            
            // classifiers
            for classifier in risk.classifiers {
                classifier.saveToLocalDatabase()
                
                if let rangeGroup = classifier.rangeGroup {
                    rangeGroup.saveToLocalDatabase()
                    for range in rangeGroup.groupRanges {
                        range.rangeTypeSymbol = range.rangeType?.symbol
                        range.saveToLocalDatabase()
                    }
                }
            }

            localDB.database.close()
        }
    }
    
    fileprivate var riskLoadedFromLocal = [String: Bool]()
    func getDetailedRiskFromLocal(_ riskKey: String) {
        // loaded from local or net before
        if riskLoadedFromLocal[riskKey] != nil || riskDetailLoadFromNet[riskKey] != nil {
            return
        }
        
        // load from local database
        if localDB.database.open() {
            let dic = localDB.getModelDicWithPrimaryKey(riskKey, inTable: RiskObjModel.tableName)
            if let risk = RiskObjModel.fromSqliteDicToModel(dic) {
                
                if let metricKey = risk.metricKey {
                    if key2Metric[metricKey] != nil {
                        risk.metric = key2Metric[metricKey]
                    }else {
                        let metricDic = localDB.getModelDicWithPrimaryKey(metricKey, inTable: MetricObjModel.tableName)
                        if let metric = MetricObjModel.fromSqliteDicToModel(metricDic) {
                            risk.metric = metric
                            key2Metric[metricKey] = metric
                        }
                    }
                }
                
                // classifiers
                var classifiers = [ClassifierObjModel]()
                for key in risk.classifierKeys {
                    let classifierDic = localDB.getModelDicWithPrimaryKey(key, inTable: ClassifierObjModel.tableName)
                    if let classifier = ClassifierObjModel.fromSqliteDicToModel(classifierDic) {
                        // classification
                        if let cfKey = classifier.classificationKey {
                            classifier.classification = getClassificationWithLocalKey(cfKey)
                        }
                        
                        // range
                        if let rangeGroupKey = classifier.rangeGroupKey {
                            let groupDic = localDB.getModelDicWithPrimaryKey(rangeGroupKey, inTable: RangeGroupObjModel.tableName)
                            if let group = RangeGroupObjModel.fromSqliteDicToModel(groupDic) {
                                var ranges = [RangeObjModel]()
                                for rangeKey in group.rangeKeys {
                                    let rangeDic = localDB.getModelDicWithPrimaryKey(rangeKey, inTable: RangeObjModel.tableName)
                                    if let range = RangeObjModel.fromSqliteDicToModel(rangeDic) {
                                        ranges.append(range)
                                    }
                                }
                                group.groupRanges = ranges
    
                                classifier.rangeGroup = group
                            }
                        }
                        
                        classifiers.append(classifier)
                    }
                }
                risk.classifiers = classifiers
                
                // riskFactors
                var factors = [RiskFactorObjModel]()
                for factorKey in risk.riskFactorKeys {
                    if key2Factor[factorKey] != nil {
                        factors.append(key2Factor[factorKey]!)
                    }else {
                        let factorDic = localDB.getModelDicWithPrimaryKey(factorKey, inTable: RiskFactorObjModel.tableName)
                        if let factor = RiskFactorObjModel.fromSqliteDicToModel(factorDic) {
                            factors.append(factor)
                            key2Factor[factorKey] = factor
                        }
                    }
                }
                
                factors.sort(by: {$0.seqNumber ?? 0 < $1.seqNumber ?? 0})
                
                for factor in factors {
                    // card, option, match, classification
                    if let cardKey = factor.cardInfoKey {
                        if key2Card[cardKey] != nil {
                            factor.card = key2Card[cardKey]
                        }else {
                            let cardDic = localDB.getModelDicWithPrimaryKey(cardKey, inTable: CardInfoObjModel.tableName)
                            if let card = CardInfoObjModel.fromSqliteDicToModel(cardDic) {
                                factor.card = card
                                key2Card[cardKey] = card
                                
                                var cardOptions = [CardOptionObjModel]()
                                for optionKey in card.cardOptionKeys {
                                    let optionDic = localDB.getModelDicWithPrimaryKey(optionKey, inTable: CardOptionObjModel.tableName)
                                    if let option = CardOptionObjModel.fromSqliteDicToModel(optionDic) {
                                        // option.match
                                        if let matchKey = option.matchKey {
                                            option.match = getMatchWithLocalKey(matchKey)
                                        }
                                        
                                        cardOptions.append(option)
                                    }
                                }
                                
                                factor.card?.cardOptions = cardOptions
                            }
                        }
                    }
                }
                
                risk.riskFactors = factors
                
                // use the detailed data
                key2Risk[riskKey] = risk
                riskLoadedFromLocal[riskKey] = true
            }
            
            localDB.database.close()
        }
    }
    
    // MARK: -------------------------- category ------------------------------
    // [categoryKey: [MetricKey]]
    // read only
    var categoryLoaded: Bool {
        return categoryIsLoaded
    }
    fileprivate var categoryIsLoaded = false
    fileprivate var localCategoryIsLoad = false
    func updateCategory(_ categories: [MetricGroupObjModel], fromNet: Bool) {
        categoryIsLoaded = fromNet
        if fromNet {
            for category in categories {
                if key2Group[category.key] == nil {
                    key2Group[category.key] = category
                }
            }
            
            if localDB.database.open() {
                for category in categories {
                    category.saveToLocalDatabase()
                }
                localDB.database.close()
            }
        }else if !localCategoryIsLoad {
            if let riskFactorCategoryKey = ApplicationDataCenter.sharedCenter.riskFactorCategoryKey {
                if localDB.database.open() {
                    let all = localDB.getModelDicsWithColumnName("ApplicationClassKey", value: riskFactorCategoryKey, inTable: MetricGroupObjModel.tableName)
                    for one in all {
                        if let group = MetricGroupObjModel.fromSqliteDicToModel(one) {
                            key2Group[group.key] = group
                        }
                    }
                    localCategoryIsLoad = true
                    localDB.database.close()
                }
            }
        }
    }

    // MARK: ------------------------ RiskType ------------------------------
    var riskTypeLoadedFromNet = false
    
    fileprivate var riskTypeLoaded = [String: Bool]()
    func riskTypeIsLoaded(_ riskTypeKey: String) -> Bool {
        return riskTypeLoaded[riskTypeKey] ?? false
    }
    func updateRiskTypes(_ riskTypes: [RiskTypeObjModel], fromNet: Bool) {
        riskTypeLoadedFromNet = fromNet
        
        var allRiskTypes = riskTypes
        if localDB.database.open() {
            if fromNet {
                for type in riskTypes {
                    riskTypeLoaded[type.key] = true
                    type.saveToLocalDatabase()
                }
            }else {
                allRiskTypes.removeAll()
                let all = localDB.getAllModels(RiskTypeObjModel.tableName)
                for one in all {
                    if let type = RiskTypeObjModel.fromSqliteDicToModel(one) {
                         allRiskTypes.append(type)
                    }else {
                        print("not saved")
                    }
                }
            }
            localDB.database.close()
        }
        
        for riskType in allRiskTypes {
            key2RiskType[riskType.key] = riskType
            let typeType = RiskTypeType.getTypeOfRiskType(riskType.key)
            switch typeType {
            case .iCa: GameTintApplication.sharedTint.iCaKey = riskType.key
            case .iPa: GameTintApplication.sharedTint.iPaKey = riskType.key
                
            case .iRa: GameTintApplication.sharedTint.iRaKey = riskType.key
            case .iAa: GameTintApplication.sharedTint.iAaKey = riskType.key

            default: break
            }
        }
    }

}

// sorted data for display
extension AIDMetricCardsCollection {
    func getMetricGroupsForApplicationClassKey(_ applicationClassKey: String?) -> [MetricGroupObjModel]  {
        if applicationClassKey == nil {
            return []
        }
        
        var groups = [MetricGroupObjModel]()
        for group in key2Group.values {
            if group.applicationClassKey != nil && group.applicationClassKey == applicationClassKey {
                groups.append(group)
            }
        }
        
        groups.sort(by: {$0.seqNumber ?? 0 < $1.seqNumber ?? 0})
        
        return groups
    }
    
    func getLoadedRisks() -> [RiskObjModel] {
        return Array(key2Risk.values)
    }
    
    func getAllRisks() -> [String] {
        return Array(key2Risk.keys)
    }
    
    func getAbbreviationOfRiskType(_ key: String) -> String {
        if let riskType = getRiskTypeByKey(key) {
            let name = riskType.name!
            return String(name[0..<3])
        }
  
        return ""
    }
    
    func getMiddleNameOfRiskType(_ key: String) -> String {
        if let riskType = getRiskTypeByKey(key) {
            let name = riskType.name!
            return String(name[4..<name.count])
        }
        
        return ""
    }
    
    func getFullNameOfRiskType(_ key: String) -> String {
        return "Individualized \(getMiddleNameOfRiskType(key)) Assessment"
    }
    
    func getAllRiskTypes() -> [RiskTypeObjModel] {
        // get with topic
    
        
        return Array(key2RiskType.values).sorted(by: {$0.seqNumber ?? 0 < $1.seqNumber ?? 0})
    }
    
    
    // filter data
    func getRiskTypesFromRisks(_ riskKeys: [String]) -> [String] {
        var riskTypes = Set<String>()
        let maxNumber = key2RiskType.values.count
        for key in riskKeys {
            if let risk = key2Risk[key] {
                riskTypes.insert(risk.riskTypeKey!)
            
                if riskTypes.count == maxNumber {
                    break
                }
            }
        }
        
        return Array(riskTypes).sorted(by:  {key2RiskType[$0]!.seqNumber ?? 0 < key2RiskType[$1]!.seqNumber ?? 0})
    }
    
    func getRiskClassesFromRisks(_ riskKeys: [String]) -> [String] {
        var riskClasses = Set<String>()
        for key in riskKeys {
            if let risk = key2Risk[key] {
                riskClasses.insert(risk.metricKey!)
            }
        }
        
        return Array(riskClasses)
    }

    // an extended version that group "bonus", "complementary" cards togather regardless metricGroupKey
    func getCategoryToCardsOfRiskKeyEx(_ riskKey: String) -> [String: [CardInfoObjModel]] {
        var sortedDic = [String: [CardInfoObjModel]]()
        var ungroupedCards = [CardInfoObjModel]()
        
        if let risk = getRisk(riskKey) {
            for factor in risk.riskFactors {
                if let card = factor.card {
                    if factor.isDetails {
                        // not display
                        continue
                    } else if factor.isComplementary {
                        // is complementary card
                        if sortedDic[ComplementaryCategoryKey] == nil {
                            sortedDic[ComplementaryCategoryKey] = [card]
                        }else {
                            sortedDic[ComplementaryCategoryKey]!.append(card)
                        }
                    }else if factor.isBonus {
                        // is bonus card
                        if sortedDic[BonusCategoryKey] == nil {
                            sortedDic[BonusCategoryKey] = [card]
                        }else {
                            sortedDic[BonusCategoryKey]!.append(card)
                        }
                    }else {
                        if let groupKey = factor.metricGroupKey {
                            if sortedDic[groupKey] == nil {
                                sortedDic[groupKey] = [card]
                            }else {
                                sortedDic[groupKey]!.append(card)
                            }
                        }else {
                            ungroupedCards.append(card)
                        }
                    }
                }
            }
            
            if ungroupedCards.count != 0 {
                sortedDic[UnGroupedCategoryKey] = ungroupedCards
            }
        }
        return sortedDic
    }
    
    func getCategoryOfCard(_ cardKey: String, inRisk riskKey: String) -> String? {
        if let risk = getRisk(riskKey) {
            for factor in risk.riskFactors {
                if factor.card?.key == cardKey {
                    if factor.isComplementary {
                        // is complementary card
                        return ComplementaryCategoryKey
                    }else if factor.isBonus {
                        return BonusCategoryKey
                    }else {
                        return factor.metricGroupKey
                    }
                }
            }
        }
        
        return nil
    }
    
    func getAllDisplayCardsOfRisk(_ riskKey: String) -> [CardInfoObjModel] {
        var cards = [CardInfoObjModel]()
        if let risk = getRisk(riskKey) {
            for factor in risk.riskFactors {
                if let card = factor.card {
                    if !factor.isDetails {
                        cards.append(card)
                    }
                }
            }
        }
        return cards
    }
    
    func getNumberOfDisplayCards(_ riskKey: String) -> Int {
        return getAllDisplayCardsOfRisk(riskKey).count
    }
    
    func getScoreCardsOfRisk(_ riskKey: String) -> [CardInfoObjModel] {
        var cards = [CardInfoObjModel]()
        if let risk = getRisk(riskKey) {
            for factor in risk.riskFactors {
                if factor.isScore {
                    cards.append(factor.card!)
                }
            }
        }
        return cards
    }
    
    func getBonusCardsOfRisk(_ riskKey: String) -> [CardInfoObjModel] {
        var cards = [CardInfoObjModel]()
        if let risk = getRisk(riskKey) {
            for factor in risk.riskFactors {
                if factor.isBonus {
                    cards.append(factor.card!)
                }
            }
        }
        return cards
    }
    
    func getComplementaryCardsOfRisk(_ riskKey: String) -> [CardInfoObjModel] {
        var cards = [CardInfoObjModel]()
        if let risk = getRisk(riskKey) {
            for factor in risk.riskFactors {
                if factor.isComplementary {
                    cards.append(factor.card!)
                }
            }
        }
        return cards
    }
    
    func getRisksContainsCard(_ cardKey: String) -> [String] {
        var risks = [String]()
        for factor in Array(key2Factor.values) {
            if let card = factor.cardInfoKey {
                if card == cardKey {
                    risks.append(factor.riskKey)
                }
            }
        }
        
        return risks
    }
    
    
    func getRiskTypeOfCard(_ cardKey: String) -> String! {
        if let riskKey = getRisksContainsCard(cardKey).first {
            return getRisk(riskKey).riskTypeKey
        }
        
        return nil
    }
    
    // return all risk classes (catergories)
    func getSlowAgingMetricGroupOfMetric(_ metricKey: String) -> MetricGroupObjModel! {
        let slowAgingClassKey = AppTopic.SlowAgingByDesign.getTopicKey()
        let slowAgingGroup = getMetricGroupsForApplicationClassKey(slowAgingClassKey)
        for group in slowAgingGroup {
            if group.metricKeys.contains(metricKey) {
                return group
            }
        }
        
        return nil
    }

    func getTierOfRisk(_ riskKey: String) -> Int {
        if let risk = getRisk(riskKey) {
            if let type = risk.riskTypeKey {
                let riskTypeType = RiskTypeType.getTypeOfRiskType(type)
                if riskTypeType == .iCa {
                    return 0
                }else if riskTypeType == .iPa {
                    return 1
                }else {
                    return 2
                }
            }
        }
        
        return -1
    }
    
    // MARK: --------------- for save -------
    // the metricKey in factor is used for save measurement
    func getRiskFactorOfCard(_ cardKey: String, inRisk riskKey: String) -> String! {
        if let risk = getRisk(riskKey) {
            for factor in risk.riskFactors {
                if factor.card?.key == cardKey {
                    return factor.key
                }
            }
        }
        
        return nil
    }
    
    // metricKey - measurementValue.metricKey, the metricKey that card is representing
    // !!! there will be NO duplicated metrics in any given risk game.  the backend will ensure this
    // return the found card
    // find the card used for the given meteric-match pair
    // (1) a card has to be used for user to select match to given metric:
    // (2) card = collection of matches + metric
    // (3) a card is presented as part of risk game as riskfactor
    // metricKey - the metricKey being matched
    // matchKey - match key
    func getCardOfMetric(_ metricKey: String, matchKey: String, inRisk: String) -> CardInfoObjModel? {
        for card in getAllDisplayCardsOfRisk(inRisk) {
            if card.metricKey == metricKey {
                // normal card
                for option in card.cardOptions {
                    if option.matchKey == matchKey {
                        // this is the hosting card
                        return card
                    }
                }
                
                // chained or not
                for option in card.cardOptions {
                    if let chainedKey = option.match?.classification?.chainedCardKey {
                        if let chained = getCard(chainedKey) {
                            for chainedOption in chained.cardOptions {
                                if chainedOption.matchKey == matchKey {
                                    // this is the hosting card
                                    return card
                                }
                            }
                        }
                    }
                }
                print("for card: \(card.key!) with this metric, no match is fit")
            }
        }
        
        print("Data is changed, does not exist in this risk")
        
        return nil
    }
    
    
    func matchExistInCard(_ cardKey: String, matchKey: String) -> Bool {
        if let card = collection.getCard(cardKey) {
            for option in card.cardOptions {
                if option.matchKey == matchKey {
                    // this is the hosting card
                    return true
                }
            }
            
            // chained or not
            for option in card.cardOptions {
                if let chainedKey = option.match?.classification?.chainedCardKey {
                    if let chained = getCard(chainedKey) {
                        for chainedOption in chained.cardOptions {
                            if chainedOption.matchKey == matchKey {
                                // this is the hosting card
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }

    // return array of risk key for the given risk class (such as CVD risk)
    func getRiskModelKeys(_ riskClassKey:String, riskType: String?) -> [String] {
        var riskKeys = [String]()
        var risks = [RiskObjModel]()
        for risk in Array(key2Risk.values) {
            if risk.metricKey == riskClassKey {
                if riskType == nil {
                    risks.append(risk)
                }else {
                    if risk.riskTypeKey == riskType {
                        risks.append(risk)
                    }
                }
            }
        }
        
        risks.sort(by: {$0.seqNumber ?? 0 < $1.seqNumber ?? 0})
        for risk in risks {
            riskKeys.append(risk.key)
        }
        
        return riskKeys
    }
    
    func getAllRisksOfRiskClass(_ riskClassKey: String) -> [String] {
        var risks = [String]()
        for risk in Array(key2Risk.values) {
            if risk.metricKey == riskClassKey {
                risks.append(risk.key)
            }
        }
        
        return risks
    }
    
    ///////////////////////////////////////////////////////////
    // access VCard
    ///////////////////////////////////////////////////////////
    func getMetricCardOfRisk(_ riskKey: String) -> [CardInfoObjModel] {
        var riskDeckOfCards = [CardInfoObjModel]()
        if let risk = getRisk(riskKey) {
            for factor in risk.riskFactors {
                riskDeckOfCards.append(factor.card!)
            }
        }
        
        return riskDeckOfCards
    }
}

// get object by the object's key
extension AIDMetricCardsCollection {
    func getMetricGroupByKey(_ key: String!) -> MetricGroupObjModel? {
        if key == nil {
            return nil
        }
        return key2Group[key]
    }
    
    func getRiskTypeByKey(_ key: String!) -> RiskTypeObjModel? {
        if key == nil {
            return nil
        }
        return key2RiskType[key]
    }

    func getClassificationByKey(_ key: String!) -> ClassificationObjModel? {
        if key == nil {
            return nil
        }
        return key2Classification[key]
    }

    func getRisk(_ riskKey: String!) -> RiskObjModel! {
        if riskKey == nil {
            return nil
        }
        return key2Risk[riskKey]
    }
    
    func getRiskFactorByKey(_ key: String!) -> RiskFactorObjModel! {
        if key == nil {
            return nil
        }
        return key2Factor[key]
    }
    
    // return card
    func getCard(_ cardKey: String!) -> CardInfoObjModel? {
        if cardKey == nil {
            return nil
        }
        return key2Card[cardKey]
    }
    
    // get MetricObjModel by given metric key
    func getMetric(_ metricKey: String?) -> MetricObjModel? {
        if metricKey == nil {
            return nil
        }
        return key2Metric[metricKey!]
    }
    
    // return match object for the given match key
    func getMatch(_ matchKey: String?)->MatchObjModel? {
        if matchKey == nil {
            return nil
        }
        return key2Match[matchKey!]
    }
}

// MARK: --------------- load data from local
extension AIDMetricCardsCollection {
    func getApplicationFromLocal() {
        if localDB.database.open() {
            // load all data, key to object
            // application
            if let result = localDB.getAllModels(ApplicationObjModel.tableName).first {
                if let application = ApplicationObjModel.fromSqliteDicToModel(result) {
                    ApplicationDataCenter.sharedCenter.updateDictionary(application.applicationClassDic)
                }
            }else {
                print("not added")
            }
            localDB.database.close()
        }
    }
    
    // database is opened
    func getMetricWithLocalKey(_ metricKey: String!) -> MetricObjModel? {
        guard metricKey != nil else {
            print("key is nil")
            return nil
        }
        
        if key2Metric[metricKey] != nil {
            return key2Metric[metricKey]
        }else {
            let metricDic = localDB.getModelDicWithPrimaryKey(metricKey, inTable: MetricObjModel.tableName)
            if let metric = MetricObjModel.fromSqliteDicToModel(metricDic) {
                key2Metric[metricKey] = metric
                return metric
            }
        }
        
        return nil
    }
    
    func getClassificationWithLocalKey(_ cKey: String) -> ClassificationObjModel? {
        if key2Classification[cKey] != nil {
            return key2Classification[cKey]
        }else {
            let classificationDic = localDB.getModelDicWithPrimaryKey(cKey, inTable: ClassificationObjModel.tableName)
            if let classifiction = ClassificationObjModel.fromSqliteDicToModel(classificationDic) {
                key2Classification[cKey] = classifiction
                return classifiction
            }
        }
        
        return nil
    }
    
    func getMatchWithLocalKey(_ matchKey: String!) -> MatchObjModel? {
        guard matchKey != nil else {
            print("key is nil")
            return nil
        }
        
        if key2Match[matchKey] != nil {
            return key2Match[matchKey]
        }else {
            let matchDic = localDB.getModelDicWithPrimaryKey(matchKey, inTable: MatchObjModel.tableName)
            if let match = MatchObjModel.fromSqliteDicToModel(matchDic) {
                // match.classification
                if let cKey = match.classificationKey {
                    match.classification = getClassificationWithLocalKey(cKey)
                }
                
                key2Match[matchKey] = match
                return match
            }
        }
        
        return nil
    }
}
