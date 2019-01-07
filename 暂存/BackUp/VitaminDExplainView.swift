//
//  VitaminDExplainView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/2.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
import MapKit

class VitaminDExplainView: UIView, UITextFieldDelegate, CLLocationManagerDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate let scoreTextView = UITextView()
    fileprivate let explainView = UIScrollView()
    fileprivate let chooseView = VitaminDCurrentLevelChooseView()
    fileprivate let sepLine = UIView()
    fileprivate let dosageButton = UIButton()
    fileprivate let latitudeButton = UIButton()
    fileprivate var locationManager: CLLocationManager!
    fileprivate let calendar = SunCalendarView()
    fileprivate let explainTextView = UITextView()
    
    fileprivate func updateUI() {
        backgroundColor = UIColor.clear
        
        scoreTextView.backgroundColor = UIColorFromRGB(255, green: 250, blue: 246)
        scoreTextView.isEditable = false
        scoreTextView.isScrollEnabled = false
        scoreTextView.isSelectable = false
        
        sepLine.backgroundColor = UIColorGray(222)
        
        addSubview(scoreTextView)
        addSubview(sepLine)
        
        // calculation
        dosageButton.titleLabel?.numberOfLines = 0
        dosageButton.setTitleColor(UIColor.blue, for: .normal)
        dosageButton.setTitle("Etimated daily Vitamin D dosage: ?", for: .normal)
        dosageButton.addTarget(self, action: #selector(getWeight), for: .touchUpInside)
        addSubview(dosageButton)
        
        // latitude
        latitudeButton.titleLabel?.textAlignment = .center
        latitudeButton.setTitleColor(UIColor.blue, for: .normal)
        latitudeButton.setTitle("Get sun calendar of current location", for: .normal)
        latitudeButton.addTarget(self, action: #selector(showSunCalendar), for: .touchUpInside)
        addSubview(latitudeButton)
        
        addSubview(calendar)
        
//        explainTextView.backgroundColor = UIColorFromRGB(255, green: 250, blue: 246)
        explainTextView.isEditable = false
        explainTextView.isScrollEnabled = false
        explainTextView.isSelectable = false
        explainTextView.text = "Vitamin D comes from the synthesis of UVB radiation, which is less than 5% of the sunshine. Depending on the time of day and time of year, there may not be enough UVB to produce vitamin D. The UVB strength is dependent on your latitude, and thus all cities in the same latitude have similar UVB exposure (barring pollution or fog).\n\n\tAlso, remember that you need to be out in prime hours, 10 am – 2 pm, or when your shadow is shorter than you."
        
        addSubview(explainTextView)
    }
    
    func setupWithRiskKey(_ riskKey: String, userKey: String, factor: CGFloat) {
        dosageButton.titleLabel?.font = UIFont.systemFont(ofSize: 14 * fontFactor * factor, weight: UIFontWeightMedium)
        latitudeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 * fontFactor * factor, weight: UIFontWeightMedium)
        explainTextView.font = UIFont.systemFont(ofSize: 12 * fontFactor * factor, weight: UIFontWeightMedium)
        
        if riskKey == vitaminDInKey {
            if let classifier = MatchedCardsDisplayModel.getResultClassifierOfRisk(riskKey) {
                
                let titleStyle = NSMutableParagraphStyle()
                titleStyle.alignment = .center
                
                let topString = NSMutableAttributedString(string: "\(collection.getRisk(riskKey).scoreDisplayName ?? "Vitamin D Insufficiency Score")\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14 * fontFactor * factor, weight: UIFontWeightSemibold), NSParagraphStyleAttributeName: titleStyle])
                
                let scoreNumber = MatchedCardsDisplayModel.getTotalScoreOfRisk(riskKey)
                topString.append(NSAttributedString(string: "\(String(scoreNumber))\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 28 * fontFactor * factor, weight: UIFontWeightSemibold), NSParagraphStyleAttributeName: titleStyle]))
                scoreTextView.attributedText = topString
            }
        }
    }
    
    func layoutWithFrame(_ frame: CGRect) {
        self.frame = frame
        
        let xMargin = bounds.width * 0.05
        // explain part
        // line
        sepLine.frame = CGRect(x: 0, y: 0, width: bounds.width, height: fontFactor).insetBy(dx: xMargin, dy: 0)
        
        // suggestion
        let refH = bounds.width * 0.3
        scoreTextView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 1000).insetBy(dx: xMargin, dy: 0)
        let textH = scoreTextView.layoutManager.usedRect(for: scoreTextView.textContainer).height
        scoreTextView.frame = CGRect(x: 0, y: fontFactor, width: bounds.width, height: textH)
        scoreTextView.textContainerInset = UIEdgeInsets(top: xMargin * 0.5, left: xMargin, bottom: 0, right: xMargin)
        
        dosageButton.frame = CGRect(x: 0, y: scoreTextView.frame.maxY, width: bounds.width, height: 0.4 * refH).insetBy(dx: xMargin, dy: 0)
        
        // sun calendar
        latitudeButton.frame = CGRect(x: 0, y: dosageButton.frame.maxY, width: bounds.width, height: 0.4 * refH).insetBy(dx: xMargin, dy: 0)
        
        calendar.frame = CGRect(x: 0, y: latitudeButton.frame.maxY, width: bounds.width, height: 0.4 * refH).insetBy(dx: xMargin * 0.5, dy: 0)
        
        explainTextView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 1000).insetBy(dx: xMargin * 0.5, dy: 0)
        let explainH = explainTextView.layoutManager.usedRect(for: explainTextView.textContainer).height
        explainTextView.frame = CGRect(x: 0, y: calendar.frame.maxY + xMargin * 0.5, width: bounds.width, height: explainH).insetBy(dx: xMargin * 0.5, dy: 0)
        explainTextView.textContainerInset = UIEdgeInsets.zero
   
        // adjust
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: explainTextView.frame.maxY)
    }
    
    fileprivate var dosage: Float = 0 {
        didSet{
            if abs(dosage)<1e-6 {
                dosageButton.setTitle("Touch to get the etimated daily Vitamin D dosage", for: .normal)
            }else {
                var round = Int(roundf(dosage))
                if round >= 1000 {
                    round = (round / 1000) * 1000
                }else {
                    round = (round / 100) * 100
                }
                
                dosageButton.setTitle("Etimated daily Vitamin D dosage: \(min(round, 10000)) IU/day", for: .normal)
            }
        }
    }
    
    func getWeight() {
        let alert = UIAlertController(title: "Input your weight", message: "and\n choose the unit to start calculating", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.delegate = self
            textfield.keyboardType = .decimalPad
            
        }
        let lbsAction = UIAlertAction(title: "lbs", style: .default) { (action) in
            if let result = alert.textFields?.first!.text {
                self.dosage = (Float(result) ?? 0) * 27
                
            }
        }
        let kiloAction = UIAlertAction(title: "kilo", style: .default) { (action) in
            if let result = alert.textFields?.first!.text {
                self.dosage = (Float(result) ?? 0) * 60
                
            }
        }
        
        alert.addAction(lbsAction)
        alert.addAction(kiloAction)
        
        viewController.present(alert, animated: true) {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showSunCalendar() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                if locationManager == nil {
                    locationManager = CLLocationManager()
                    locationManager.delegate = self
                }
                
                locationManager.startUpdatingLocation()
            }else {
                if locationManager == nil {
                    locationManager = CLLocationManager()
                    locationManager.delegate = self
                }
                
                locationManager.requestWhenInUseAuthorization()
            }
        }else {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let last = locations.last!.coordinate
        let latitude = Float(last.latitude)
        
        var levels = [(month: String, level: SunLevel)]()
        
        latitudeButton.setTitle("current latitude: \(String(format: "%.2f", abs(latitude))), \(latitude > 0 ? "N" : "S")", for: .normal)
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
        for (i, month) in months.enumerated() {
            if let level = VitaminDSunCalendar.getLevelOfLatitude(abs(latitude), north: latitude > 0, month: i + 1) {
                levels.append((month, level))
            }
        }
        
        levels.sort(by: {$0.level.rawValue < $1.level.rawValue})
        calendar.levels = levels
        explainTextView.transform = CGAffineTransform.identity
    }
    
    deinit {
        if locationManager != nil {
            locationManager.stopUpdatingHeading()
        }
    }
}
