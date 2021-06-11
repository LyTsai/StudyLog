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
    
    let topLayer = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLayer.fillColor = UIColor.clear.cgColor
        topLayer.strokeColor = UIColor.black.cgColor
        
        self.view.layer.addSublayer(topLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath.getDirectionArrowFrom(CGPoint(x: 300, y: 400), end: CGPoint(x: 300, y: 500), arrowL: 10)
        path.append(UIBezierPath.getDirectionArrowFrom(CGPoint(x: 300, y: 400), end: CGPoint(x: 300, y: 200), arrowL: 10))


        path.append(UIBezierPath.getDirectionArrowFrom(CGPoint(x: 300, y: 400), end: CGPoint(x: 500, y: 500), arrowL: 10))
        path.append(UIBezierPath.getDirectionArrowFrom(CGPoint(x: 300, y: 400), end: CGPoint(x: 100, y: 500), arrowL: 10))
        topLayer.path = path.cgPath
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

