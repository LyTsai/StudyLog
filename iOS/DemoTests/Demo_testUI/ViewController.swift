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
//    let deck = DeckCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    @IBOutlet weak var datePicker: CustomDatePicker!
//    let locationM = CLLocationManager()
//    let geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.setupMode(.time)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        deck.frame = view.bounds.insetBy(dx: 0, dy: 100)
//        deck.setupWithSize(CGSize(width: 200, height: 300))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datePicker.setWithValue(9 * 60)
    }
    
    var time = 0
    var dateString: String?
    var dateValue: Int = 0
    @IBAction func saveTouch(_ sender: Any) {

        if time % 2 == 0 {
            dateValue = datePicker.currentValue
        }else {
//            let date = convertValueToValue(dateValue ?? 0)

            datePicker.setWithValue(dateValue)
        }

        time += 1
        print(datePicker.currentValue)
    }
    

    
//    @objc func requestFor() {
//        if CLLocationManager.locationServicesEnabled() {
//            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//                locationM.startUpdatingLocation()
//            }else {
//                // is not authorized
//                locationM.requestWhenInUseAuthorization()
//            }
//        }else {
//            // not available for location service
//        }
//
//        geocoder.geocodeAddressString("Apple Inc.") { (placemarks, error) in
//            if let marks = placemarks {
//                 for placemark in marks {
//                    print(placemark.postalCode)
//                    print(placemark.name)
//                 }
//            }else {
//                print("place marks nil for apple")
//            }
//            if error != nil {
//                print("error is \(error?.localizedDescription)")
//            }
//        }
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//         print("--------------- get by location --------------")
//        if let location = locations.last {
//            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//                if let marks = placemarks {
//                    for placemark in marks {
//                        print(placemark.postalCode)
//                        print(placemark.addressDictionary)
//                    }
//                }else {
//                    print("place marks nil for current location")
//                }
//                if error != nil {
//                    print("error is \(error?.localizedDescription)")
//                }
//            }
//        }
//    }

}

