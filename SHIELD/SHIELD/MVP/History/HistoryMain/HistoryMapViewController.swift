//
//  HistoryMapViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/19.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class HistoryMapViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearArrow: UILabel!
    @IBOutlet weak var yearCollectionView: NumberChooseCollectionView!
    
    @IBOutlet weak var riskTypeCollectionView: UICollectionView!
    fileprivate let chosenTypeView = HistoryTypeCell()
    
    @IBOutlet weak var tableScroll: UIScrollView!
    @IBOutlet weak var monthTimelineTable: TimelineTableView!
    @IBOutlet weak var dayTimelineTable: TimelineTableView!
    
    @IBOutlet weak var assistView: UIView!
    fileprivate let gradientMaskLayer = CAGradientLayer()
    
    @IBOutlet weak var leftItemLabel: UILabel!
    @IBOutlet weak var rightItemLabel: UILabel!
    
    @IBOutlet weak var leftCheck: UIImageView!
    @IBOutlet weak var rightCheck: UIImageView!
    
    @IBOutlet weak var leftDash: UIImageView!
    @IBOutlet weak var leftItem: RiskDisplayItem!
    @IBOutlet weak var rightDash: UIImageView!
    @IBOutlet weak var rightItem: RiskDisplayItem!
    @IBOutlet weak var compareButton: UIButton!
    
    // riskType
    
    fileprivate var chosenTypeKey: String! {
        didSet{
            chosenTypeView.configureWithRiskType(chosenTypeKey)
        }
    }
    fileprivate var playedRiskTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsCursor.comparisonRiskKey = nil
        navigationItem.title = "History"
        
        yearCollectionView.chooseItem = setupWithYearIndex
        
        riskTypeCollectionView.register(HistoryTypeCell.self, forCellWithReuseIdentifier: historyTypeCellID)
        riskTypeCollectionView.delegate = self
        riskTypeCollectionView.dataSource = self
        
        leftMeasurement = nil
        rightMeasurement = nil
        
        // add gradient
        gradientMaskLayer.startPoint = CGPoint.zero
        gradientMaskLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientMaskLayer.colors = [UIColor.white.withAlphaComponent(0.01).cgColor, UIColor.white.cgColor]
        gradientMaskLayer.locations = [0.1, 0.95]
        
        view.layer.addSublayer(gradientMaskLayer)
        
        view.addSubview(chosenTypeView)
        
        // fonts
        yearLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        yearArrow.font = UIFont.systemFont(ofSize: 16 * fontFactor)
        leftItemLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor)
        rightItemLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor)
        
        // data
        prepareTimeRecord()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientMaskLayer.frame = CGRect(x: 0, y: assistView.frame.minY, width: width, height: assistView.frame.height)
    }
    
    @IBAction func tapToChooseYear(_ sender: Any) {
        if !yearArrow.isHidden && yearCollectionView.isHidden {
            yearArrow.transform = CGAffineTransform.identity
            yearCollectionView.isHidden = false
        }
    }
    // year, month
    fileprivate var yearRecord = [Int: [MeasurementObjModel]]()
    fileprivate var years = [Int]()
    fileprivate var yearIndex = 0
    fileprivate var chosenYear: Int {
        if yearIndex >= years.count || yearIndex < 0 {
            return CalendarCenter.getYearOfDate(Date())
        }
        return years[yearIndex]
    }
    fileprivate func prepareTimeRecord() {
        yearRecord.removeAll()
        
        let userKey = userCenter.currentGameTargetUser.Key()
        var all = selectionResults.getAllBaselineMeasurementsForUser(userKey)
        all.sort(by: {$0.timeString > $1.timeString})
        for one in all {
            let timeString = one.timeString!
            let date = ISO8601DateFormatter().date(from: timeString)!
            let year = CalendarCenter.getYearOfDate(date)
            
            if yearRecord[year] == nil {
                yearRecord[year] = [one]
            }else {
                yearRecord[year]!.append(one)
            }
        }
        
        let current = CalendarCenter.getYearOfDate(Date())
        if yearRecord.isEmpty {
            yearRecord[current] = []
        }
        
        years = Array(yearRecord.keys).sorted(by: {$0 < $1})
        yearIndex = years.count - 1
        
        // collectionView
        if years.count > 1 {
            yearArrow.isHidden = false
        }else {
            yearArrow.isHidden = true
        }
        yearCollectionView.setupWithNumbers(years, chosen: yearIndex)
        setupWithYearIndex(yearIndex)
    }
    
    fileprivate func setupWithYearIndex(_ yearIndex: Int) {
        self.yearIndex = yearIndex
        
        yearLabel.text = "\(chosenYear)"
        yearArrow.transform = CGAffineTransform(rotationAngle: CGFloatPi)
        yearCollectionView.isHidden = true
        
        playedRiskTypes = getRiskTypesPlayedInYear(chosenYear)
        riskTypeCollectionView.reloadData()
        
        chosenTypeKey = playedRiskTypes.first
        let month = getMeasurementsInYear(chosenYear, riskTypeKey: chosenTypeKey)
        monthTimelineTable.setupWithMeasurements(month, timelineType: .monthline)
        monthTimelineTable.reloadData()
        
        // add gradient
        chosenTypeView.isChosen = true
        chosenTypeView.isHidden = true
    }
    
    fileprivate func getRiskTypesPlayedInYear(_ year: Int) -> [String] {
        var types = Set<String>()
        if let played = yearRecord[year] {
            for one in played {
                if let risk = collection.getRisk(one.riskKey) {
                    if let typeKey = risk.riskTypeKey {
                        types.insert(typeKey)
                    }
                }
            }
        }
        
        var typesArray = Array(types)
        typesArray.sort(by: {collection.getRiskTypeByKey($0)!.seqNumber ?? 0 < collection.getRiskTypeByKey($1)!.seqNumber ?? 0 })
        
        return typesArray
    }
    
    fileprivate func getMeasurementsInYear(_ year: Int, riskTypeKey: String!) -> [MeasurementObjModel] {
        if riskTypeKey == nil {
            return []
        }
        
        var all = [MeasurementObjModel]()
        if let played = yearRecord[year] {
            for one in played {
                if let risk = collection.getRisk(one.riskKey) {
                    if let typeKey = risk.riskTypeKey {
                        if typeKey == riskTypeKey {
                            all.append(one)
                        }
                    }
                }
            }
        }
        
        return all
    }

    
    // MARK: ------------ collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playedRiskTypes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let typeKey = playedRiskTypes[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyTypeCellID, for: indexPath) as! HistoryTypeCell
        cell.configureWithRiskType(typeKey)
        cell.isChosen = (typeKey == chosenTypeKey)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var left = assistView.frame.minX
        let itemH = collectionView.frame.height
        let itemW = (width - left) / 8
        left -= itemW * 0.5
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = itemW / 6
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        
        chosenTypeView.frame = CGRect(x: left, y: collectionView.frame.minY, width: itemW, height: itemH)
        
        return CGSize(width: itemW, height: itemH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosen = playedRiskTypes[indexPath.item]
        if chosenTypeKey != chosen {
            var old: IndexPath!
            for (i, typekey) in playedRiskTypes.enumerated() {
                if typekey == chosenTypeKey {
                    old = IndexPath(item: i, section: 0)
                    break
                }
            }
            chosenTypeKey = chosen
            riskTypeCollectionView.reloadItems(at: [indexPath, old])
            
            // reset table
            cardsCursor.comparisonRiskKey = nil
            let month = getMeasurementsInYear(chosenYear, riskTypeKey: chosenTypeKey)
            monthTimelineTable.setupWithMeasurements(month, timelineType: .monthline)
            monthTimelineTable.reloadData()
            
            leftMeasurement = nil
            rightMeasurement = nil
        }
    }
    
    // MARK: ------------ choose and compare
    fileprivate var leftMeasurement: MeasurementObjModel! {
        didSet{
            leftCheck.isHidden = (leftMeasurement == nil)
            leftItem.isHidden = (leftMeasurement == nil)
            if leftMeasurement != nil {
                leftItem.setupWithRisk(leftMeasurement.riskKey!)
                leftItemLabel.text = itemText(leftMeasurement.timeString)
            }else {
                leftItemLabel.text = "Not Choose"
            }
            
            compareButton.isSelected = (leftMeasurement != nil && rightMeasurement != nil)
            
        }
    }
    
    fileprivate var rightMeasurement: MeasurementObjModel! {
        didSet{
            rightCheck.isHidden = (rightMeasurement == nil)
            rightItem.isHidden = (rightMeasurement == nil)
            if rightMeasurement != nil {
                rightItem.setupWithRisk(rightMeasurement.riskKey!)
                rightItemLabel.text = itemText(rightMeasurement.timeString)
            }else {
                rightItemLabel.text = "Not Choose"
            }
            
            compareButton.isSelected = (leftMeasurement != nil && rightMeasurement != nil)
        }
    }
    
    fileprivate func itemText(_ timeString: String) -> String {
        let date = ISO8601DateFormatter().date(from: timeString)!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func compare(_ sender: Any) {
        if compareButton.isSelected {
            let compare = Bundle.main.loadNibNamed("HistoryCompareViewController", owner: self, options: nil)?.first as! HistoryCompareViewController
            compare.setupWithFirstMeasurement(leftMeasurement, second: rightMeasurement)
            navigationController?.pushViewController(compare, animated: true)
        }
    }
    
    func chooseMeasurements(_ measurements: [MeasurementObjModel]) {
        // all chosen, and not for cancel
        if leftMeasurement != nil && rightMeasurement != nil {
            if !measurements.contains(leftMeasurement) && !measurements.contains(rightMeasurement) {
                // alert, removeOne, or replace one
                let alert = UIAlertController(title: nil, message: "Two records are chosen now, you can touch to cancel one or just compare", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: {
                })
                return
            }
        }
        
        // cancel or add
        if measurements.count == 1 {
            let measurement = measurements.first!
            
            // use for cancel
            if leftMeasurement != nil && leftMeasurement == measurement {
                leftMeasurement = nil
                if rightMeasurement == nil {
                    cardsCursor.comparisonRiskKey = nil
                }
            }else if rightMeasurement != nil && rightMeasurement == measurement {
                rightMeasurement = nil
                if leftMeasurement == nil {
                    cardsCursor.comparisonRiskKey = nil
                }
            }else {
                // select
                if leftMeasurement == nil {
                    leftMeasurement = measurement
                }else if rightMeasurement == nil {
                    rightMeasurement = measurement
                }
                cardsCursor.comparisonRiskKey = measurement.riskKey
            }
            
            
            var chosen = [MeasurementObjModel]()
            if leftMeasurement != nil {
                chosen.append(leftMeasurement)
            }
            if rightMeasurement != nil {
                chosen.append(rightMeasurement)
            }
            
            // reload
            if chosenTypeView.isHidden {
                // on month page
                monthTimelineTable.setupChosenInfo(chosen)
                monthTimelineTable.reloadData()
            }else {
                dayTimelineTable.setupChosenInfo(chosen)
                monthTimelineTable.setupChosenInfo(chosen)
                monthTimelineTable.reloadData()
                dayTimelineTable.reloadData()
            }
        }else {
            var chosen = [MeasurementObjModel]()
            if leftMeasurement != nil {
                chosen.append(leftMeasurement)
            }
            if rightMeasurement != nil {
                chosen.append(rightMeasurement)
            }
            
            // go to next page
            dayTimelineTable.setupWithMeasurements(measurements, timelineType: .dayline)
            dayTimelineTable.setupChosenInfo(chosen)
            dayTimelineTable.reloadData()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableScroll.contentOffset = CGPoint(x: width, y: 0)
            }) { (true) in
                self.chosenTypeView.isHidden = false
                self.riskTypeCollectionView.isHidden = true
            }
        }
    }
    
    
    func backToMonthTable() {
        var chosen = [MeasurementObjModel]()
        if leftMeasurement != nil {
            chosen.append(leftMeasurement)
        }
        if rightMeasurement != nil {
            chosen.append(rightMeasurement)
        }
        
        monthTimelineTable.setupChosenInfo(chosen)
        monthTimelineTable.reloadData()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tableScroll.contentOffset = CGPoint.zero
        }) { (true) in
            self.chosenTypeView.isHidden = true
            self.riskTypeCollectionView.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        backToMonthTable()
    }
}
