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
    let deck = DeckCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let locationM = CLLocationManager()
    let geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let arc = CoreTextArcView(frame: CGRect(x: 50, y: 100, width: 600, height: 300))
//        arc.backgroundColor = UIColor.clear
//
//        arc.radius = 220
//        arc.arcCenter = CGPoint(x: 300, y: 300)
//        view.addSubview(arc)
//
//        arc.setNeedsDisplay()
        
        deck.setupBasic()
        view.addSubview(deck)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        deck.frame = view.bounds.insetBy(dx: 0, dy: 100)
        deck.setupWithSize(CGSize(width: 200, height: 300))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
//


    
}
