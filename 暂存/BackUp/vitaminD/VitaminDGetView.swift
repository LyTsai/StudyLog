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
    fileprivate let backHint = UIImageView(image: UIImage(named: "suncalendar_backArrow"))
    fileprivate let topTapView = UIView()
    fileprivate let topBackView = UIView()
    fileprivate let titleLabel = UILabel()
    fileprivate let getLocation = UIButton(type: .custom)
    fileprivate let latitudeLabel = UILabel()
    
    fileprivate let subLabel = UILabel()
    fileprivate let introduceLabel = UILabel()
    fileprivate let calendarImageView = UIImageView(image: UIImage(named: "sunshineCalendar"))
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
        
        addSubview(topTapView)
        addSubview(backHint)
        addSubview(titleLabel)
        addSubview(getLocation)
        addSubview(latitudeLabel)
        
        addSubview(subLabel)
        addSubview(introduceLabel)
        addSubview(calendarImageView)
        
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
        topBackView.layer.borderColor = UIColorFromRGB(0, green: 131, blue: 154).cgColor
        
        titleLabel.textAlignment = .center
        titleLabel.text = "My current position"
        getLocation.setTitle("Get current latitude", for: .normal)
        getLocation.setTitleColor(UIColorGray(74), for: .normal)
 
        getLocation.backgroundColor = UIColor.white
        getLocation.layer.borderColor = UIColorFromRGB(245, green: 124, blue: 0).cgColor
        getLocation.layer.shadowColor = UIColorFromRGB(245, green: 124, blue: 0).cgColor
        latitudeLabel.textAlignment = .center
        latitudeLabel.text = "Latitude: ?"
        
        subLabel.text = "How do you get vitamin D?"
        introduceLabel.numberOfLines = 0
        introduceLabel.text = "There are 3 main sources: from the sun’s UVB rays, from your diet/food, and from supplements.  The sun is your best source, follow by your diet and then supplements. However, depending on where you live, you can’t always rely on the sun alone, especially in the winter months for those living above the sunbelt. "
        introduceLabel.textColor = UIColorGray(74)
        calendarImageView.contentMode = .scaleAspectFit
        
        adviceTextView.isScrollEnabled = false
        adviceTextView.isEditable = false
        adviceTextView.isSelectable = false
        
        getLocation.addTarget(self, action: #selector(getLocationAndCalculate), for: .touchUpInside)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(getBackToLastPage))
        topTapView.addGestureRecognizer(tapGR)
        
        locationM.delegate = self
    }
    
    fileprivate var latitude: Float!
    func setupContentWithFrame(_ frame: CGRect) {
        self.frame = frame
        
        let one = bounds.width / 345
        let xMargin = 8 * one
        topBackView.frame = CGRect(x: 0, y: one, width: bounds.width, height: 130 * one).insetBy(dx: -2 * one, dy: 0)
        topBackView.layer.borderWidth = 2 * one
        
        backHint.frame = CGRect(center: CGPoint(x: bounds.midX, y: 14 * one), width: 17 * one, height: 9 * one)
        titleLabel.frame = CGRect(center: CGPoint(x: bounds.midX, y: 38 * one), width: bounds.width, height: 30 * one)
        topTapView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: titleLabel.frame.maxY)
        
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
        
        subLabel.textAlignment = .center
        subLabel.font = UIFont.systemFont(ofSize: 14 * one, weight: UIFontWeightBold)
        subLabel.frame = CGRect(x: 0, y: topBackView.frame.maxY + 5 * one, width: bounds.width, height: 32 * one).insetBy(dx: xMargin, dy: 0)
        introduceLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFontWeightMedium)
        introduceLabel.frame = CGRect(x: 0, y: subLabel.frame.maxY, width: bounds.width, height: bounds.height).insetBy(dx: xMargin, dy: 0)
        introduceLabel.adjustWithWidthKept()
        
        calendarImageView.frame = CGRect(x: 0, y: introduceLabel.frame.maxY + 10 * one, width: bounds.width, height: bounds.width * 159 / 355).insetBy(dx: xMargin, dy: 0)
        
        for detail in calendarDetailViews {
            detail.onePoint = one
        }
        
        let advice1 = "Vitamin D comes from the synthesis of UVB radiation, which is less than 5% of the sunshine. Depending on the time of day and time of year, there may not be enough UVB to produce vitamin D. The UVB strength is dependent on your latitude, and thus all cities in the same latitude have similar UVB exposure (barring pollution or fog). Also, remember that you need to be out in prime hours, 10 am – 2 pm, or when your shadow is shorter than you.\n"
        let advice2 = "While there’s not a lot of disparity between your Brain Age and your chronological age, you need to understand the risks you have that increase the chances of Alzheimer’s."
        let adviceFont = UIFont.systemFont(ofSize: 12 * one)
        let adviceS = NSMutableAttributedString(string: advice1, attributes: [NSFontAttributeName: adviceFont])
        adviceS.append(NSAttributedString(string: "\nSuggestion\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16 * one), NSForegroundColorAttributeName: UIColorFromRGB(80, green: 211, blue: 135)]))
        adviceS.append(NSAttributedString(string: advice2, attributes: [NSFontAttributeName: adviceFont]))
        adviceTextView.attributedText = adviceS
        adviceTextView.frame = self.bounds.insetBy(dx: xMargin, dy: 0)
        let aHeight = adviceTextView.layoutManager.usedRect(for: adviceTextView.textContainer).height
        adviceTextView.textContainerInset = UIEdgeInsets.zero
        adviceTextView.frame = CGRect(x: 0, y: calendarDetailViews.last!.frame.maxY, width: bounds.width, height: aHeight + 10 * one).insetBy(dx: xMargin, dy: 0)
        
        reloadView(latitude)
    }
    
    fileprivate func reloadView(_ latitude: Float!) {
        let one = bounds.width / 345
        let xMargin = 8 * one
        
        var maxY = calendarImageView.frame.maxY + 15 * one
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
            latitudeLabel.text = "Latitude: \(String(format: "%.2f", abs(latitude)))°, \(latitude < 0 ? "S" : "N")"
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first {
                   print(placemark.addressDictionary)
                    if let city = placemark.addressDictionary!["City"] {
                        self.getLocation.setTitle(city as? String, for: .normal)
                    }else if let name = placemark.addressDictionary!["Name"] {
                        self.getLocation.setTitle(name as? String, for: .normal)
                    }else if let country = placemark.addressDictionary!["Country"] {
                        self.getLocation.setTitle(country as? String, for: .normal)
                    }
                }
              
                if error != nil {
                    self.getLocation.setTitle("Current", for: .normal)
                    print(error!.localizedDescription)
                }
            }
            
            // change if need
            reloadView(Float(latitude))
        }
    }
    
    
    deinit {
        locationM.stopUpdatingLocation()
    }
}
