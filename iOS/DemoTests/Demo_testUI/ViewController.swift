//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationM = CLLocationManager()
    let geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = UIButton(frame: CGRect(x: 50, y: 100, width: 200, height: 100))
        request.backgroundColor = UIColor.magenta
        request.setTitle("TestLocation", for: .normal)
        request.addTarget(self, action: #selector(requestFor), for: .touchUpInside)
        locationM.delegate = self
        
        view.addSubview(request)
    }
    
    @objc func requestFor() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationM.startUpdatingLocation()
            }else {
                // is not authorized
                locationM.requestWhenInUseAuthorization()
            }
        }else {
            // not available for location service
        }
        
        geocoder.geocodeAddressString("Apple Inc.") { (placemarks, error) in
            if let marks = placemarks {
                 for placemark in marks {
                    print(placemark.postalCode)
                    print(placemark.name)
                 }
            }else {
                print("place marks nil for apple")
            }
            if error != nil {
                print("error is \(error?.localizedDescription)")
            }
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         print("--------------- get by location --------------")
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let marks = placemarks {
                    for placemark in marks {
                        print(placemark.postalCode)
                        print(placemark.addressDictionary)
                    }
                }else {
                    print("place marks nil for current location")
                }
                if error != nil {
                    print("error is \(error?.localizedDescription)")
                }
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}
