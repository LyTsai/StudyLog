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
  
    @IBOutlet weak var background: UIImageView!
    //    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topLayer = CAShapeLayer()
        let viewPath = UIBezierPath(roundedRect: CGRect(x: 100, y: 100, width: 500, height: 600), cornerRadius: 4)
        viewPath.append(UIBezierPath(ovalIn: CGRect(x: 110, y: 300, width: 40, height: 40)))
        viewPath.append(UIBezierPath(ovalIn: CGRect(x: 410, y: 300, width: 40, height: 40)))
        
        topLayer.fillRule = .evenOdd
        topLayer.path = viewPath.cgPath
        topLayer.fillColor = UIColor.clear.cgColor
        topLayer.lineWidth = 4
        topLayer.strokeColor = UIColor.cyan.cgColor
        
        topLayer.addBlackShadow(4)
        
        self.view.layer.addSublayer(topLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
   
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

