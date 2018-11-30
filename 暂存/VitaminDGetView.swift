//
//  VitaminDGetView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
import MapKit

class VitaminDGetView: UIScrollView, CLLocationManagerDelegate {

    weak var testLatitude: ScorecardWebView!
    fileprivate let topBackView = UIView()
    fileprivate let sepLine = UIView()
    fileprivate let titleLabel = UILabel()
    fileprivate let getLocation = UIButton(type: .custom)
    fileprivate let latitudeLabel = UILabel()
    
   
    fileprivate let introduceLabel = UILabel()
    fileprivate let imageTitle = UILabel()
    fileprivate let calendarImage = SunCalendarDrawView()
    fileprivate let subLabel = UILabel()
    fileprivate let adviceTextView = UITextView()
    fileprivate var calendarDetailViews = [SunCalendarDetailView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        self.backgroundColor = UIColor.white
        self.bounces = false
        
        addSubview(topBackView)
        addSubview(sepLine)
        addSubview(titleLabel)
        addSubview(getLocation)
        addSubview(latitudeLabel)
        
        addSubview(subLabel)
        addSubview(introduceLabel)
        addSubview(imageTitle)
        addSubview(calendarImage)
        
        let allLevels: [SunLevel] = [.good, .moderate, .low, .nonExistent]
        for level in allLevels {
            let calendarDetailView = SunCalendarDetailView()
            calendarDetailView.level = level
            calendarDetailViews.append(calendarDetailView)
            addSubview(calendarDetailView)
        }
        addSubview(adviceTextView)
        
        // setup
        topBackView.backgroundColor = UIColorFromRGB(255, green: 247, blue: 235)
        sepLine.backgroundColor = UIColorGray(222)
        titleLabel.textAlignment = .center
        titleLabel.text = "My current position"
        getLocation.setTitle("Get current latitude", for: .normal)
        getLocation.setTitleColor(UIColorGray(74), for: .normal)
 
        getLocation.backgroundColor = UIColor.white
        getLocation.layer.borderColor = UIColorFromRGB(245, green: 124, blue: 0).cgColor
        getLocation.layer.shadowColor = UIColorFromRGB(245, green: 124, blue: 0).cgColor
        latitudeLabel.textAlignment = .center
        latitudeLabel.text = "Latitude: ?"
        
        // calendar
        subLabel.text = ""
        introduceLabel.numberOfLines = 0
        introduceLabel.text = "The sun is your best source, follow by your diet and then supplements. However, depending on where you live, you can’t always rely on the sun alone, especially in the winter months for those living above the sunbelt. "
        introduceLabel.textColor = UIColorGray(74)
        
        imageTitle.text = "SUNSHINE CALENDAR"
        imageTitle.textColor = UIColorFromRGB(239, green: 83, blue: 80)
        imageTitle.textAlignment = .center
        imageTitle.backgroundColor = UIColor.white
        
        subLabel.textAlignment = .left
        adviceTextView.isScrollEnabled = false
        adviceTextView.isEditable = false
        adviceTextView.isSelectable = false
        
        getLocation.addTarget(self, action: #selector(getLocationAndCalculate), for: .touchUpInside)
        
        locationM.delegate = self
    }
    
    fileprivate var latitude: Float!
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupContentWithFrame(frame)
//    }
//    
    func setupContentWithFrame(_ frame: CGRect) {
        self.frame = frame
        
        let one = bounds.width / 345
        let xMargin = 8 * one
        topBackView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 120 * one)
        sepLine.frame = CGRect(x: 0, y: topBackView.frame.maxY, width: bounds.width, height: one * 1.5)
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 35 * one)
    
        titleLabel.font = UIFont.systemFont(ofSize: 14 * one, weight: UIFontWeightMedium)
        getLocation.frame = CGRect(x: bounds.midX - 95 * one, y: titleLabel.frame.maxY + one, width: 190 * one, height: 35 * one)
        getLocation.layer.borderWidth = 2 * one
        getLocation.layer.shadowOffset = CGSize(width: 0, height: 2 * one)
        getLocation.layer.shadowRadius = 6 * one
        getLocation.layer.shadowOpacity = 1
        getLocation.layer.cornerRadius = 0.5 * 35 * one
        getLocation.titleLabel?.font = UIFont.systemFont(ofSize: 14 * one, weight: UIFontWeightMedium)
        latitudeLabel.frame = CGRect(x: 0, y: topBackView.frame.maxY - 28 * one, width: bounds.width, height: 24 * one)
        latitudeLabel.font = UIFont.systemFont(ofSize: 14 * one, weight: UIFontWeightMedium)
        
        introduceLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFontWeightMedium)
        introduceLabel.frame = CGRect(x: 0, y: 8 * one + sepLine.frame.maxY, width: bounds.width, height: bounds.height).insetBy(dx: xMargin * 2, dy: 0)
        introduceLabel.adjustWithWidthKept()
        
        imageTitle.font = UIFont.systemFont(ofSize: 17 * one, weight: UIFontWeightSemibold)
        imageTitle.frame = CGRect(x: 0, y: introduceLabel.frame.maxY, width: bounds.width, height: 40 * one)
        // 335 * 136
        calendarImage.frame = CGRect(x: 0, y: imageTitle.frame.maxY, width: bounds.width, height: bounds.width * 145 / 335).insetBy(dx: xMargin, dy: 0)
        subLabel.font = UIFont.systemFont(ofSize: 14 * one)
        subLabel.frame = CGRect(x: 0, y: calendarImage.frame.maxY, width: bounds.width, height: 30 * one).insetBy(dx: xMargin, dy: 0)
        
        for detail in calendarDetailViews {
            detail.onePoint = one
        }
        
        let advice1 = "\tVitamin D comes from the synthesis of UVB radiation, which is less than 5% of the sunshine. Depending on the time of day and time of year, there may not be enough UVB to produce vitamin D. The UVB strength is dependent on your latitude, and thus all cities in the same latitude have similar UVB exposure (barring pollution or fog). Also, remember that you need to be out in prime hours, 10 am – 2 pm, or when your shadow is shorter than you.\n"

        let adviceFont = UIFont.systemFont(ofSize: 12 * one)
        let adviceS = NSMutableAttributedString(string: advice1, attributes: [NSFontAttributeName: adviceFont])
        adviceTextView.attributedText = adviceS
        adviceTextView.frame = self.bounds.insetBy(dx: xMargin, dy: 0)
        let aHeight = adviceTextView.layoutManager.usedRect(for: adviceTextView.textContainer).height
        adviceTextView.textContainerInset = UIEdgeInsets.zero
        adviceTextView.frame = CGRect(x: 0, y: calendarDetailViews.last!.frame.maxY, width: bounds.width, height: aHeight + 10 * one).insetBy(dx: xMargin, dy: 0)
        
        reloadView(latitude)
    }
    
    fileprivate func reloadView(_ latitude: Float!) {
        if latitude == nil {
            subLabel.text = ""
        }else {
            subLabel.text = "sunshine calendar for your latitude: \(String(format: "%.2f", abs(latitude)))°, \(latitude < 0 ? "S" : "N")"
        }
        
        calendarImage.latitude = latitude
        
        let one = bounds.width / 345
        let xMargin = 8 * one
        
        var maxY = subLabel.frame.maxY
        for detail in calendarDetailViews {
            detail.latitude = latitude
            detail.frame = CGRect(x: 0, y: maxY, width: bounds.width, height: bounds.height).insetBy(dx: xMargin, dy: 0)
            detail.reloadView()
            maxY += detail.frame.height + 15 * one
        }
        
        adviceTextView.frame = CGRect(x: 0, y: maxY, width: bounds.width, height: adviceTextView.frame.height).insetBy(dx: xMargin, dy: 0)
        
        self.contentSize = CGSize(width: bounds.width, height: adviceTextView.frame.maxY)
   
    }
    
    func getBackToLastPage() {
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    fileprivate let locationM = CLLocationManager()
    func getLocationAndCalculate() {
        if CLLocationManager.locationServicesEnabled() {
            
        }
        
        let state = CLLocationManager.authorizationStatus()
        if state != .authorizedAlways || state != .authorizedWhenInUse {
            locationM.requestWhenInUseAuthorization()
        }
        locationM.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            if testLatitude != nil {
                let lo = "Latitude: \(String(format: "%.2f", abs(latitude)))°, \(latitude < 0 ? "S" : "N")"
                testLatitude.evaluate("showWindow('\(lo)')")
                return
            }
            
            latitudeLabel.text = "Latitude: \(String(format: "%.2f", abs(latitude)))°, \(latitude < 0 ? "S" : "N")"
       
            
            self.getLocation.setTitle("Current", for: .normal)
            self.getLocation.setTitleColor(UIColor.white, for: .normal)
            self.getLocation.backgroundColor = UIColorFromRGB(245, green: 124, blue: 0)
            self.getLocation.layer.borderColor = UIColorFromRGB(186, green: 94, blue: 0).cgColor
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    if let city = placemark.addressDictionary!["City"] {
                        self.getLocation.setTitle(city as? String, for: .normal)
                    }else if let name = placemark.addressDictionary!["Name"] {
                        self.getLocation.setTitle(name as? String, for: .normal)
                    }else if let country = placemark.addressDictionary!["Country"] {
                        self.getLocation.setTitle(country as? String, for: .normal)
                    }
                }
               
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
            
            // change if need
            reloadView(Float(latitude))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.scrollRectToVisible(CGRect(x: 0, y: self.calendarImage.frame.minY, width: self.bounds.width, height: self.bounds.height), animated: true)
            }
        }
    }
    
    
    deinit {
        locationM.stopUpdatingLocation()
    }
}
