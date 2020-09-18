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
    @IBOutlet weak var commentLabel: UILabel!
//    let locationM = CLLocationManager()
//    let geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textMask = UIView(frame: mainFrame)
        let top = CAGradientLayer()
        top.frame = CGRect(x: 0, y: 0, width: mainFrame.width, height: mainFrame.height * 0.5)
        top.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        top.locations = [0.4, 0.8]
        top.startPoint =  CGPoint(x: 0, y: 0.5)
        top.endPoint = CGPoint(x: 1, y: 0.5)
        textMask.layer.addSublayer(top)
        
        let bottom = CAGradientLayer()
        bottom.frame = CGRect(x: 0, y: mainFrame.height * 0.5, width: mainFrame.width, height: mainFrame.height * 0.5)
        bottom.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        bottom.locations = [0.4, 0.8]
        bottom.startPoint = CGPoint(x: 1, y: 0.5)
        bottom.endPoint = CGPoint(x: 0, y: 0.5)
        textMask.layer.addSublayer(top)
        
        self.commentLabel.mask = textMask
        
                       // animation
        //                self.commentLabel.isHidden = false
        //                // label
        //                let labelFrame = self.commentLabel.bounds
        //                let textMask = CAShapeLayer()
        //                textMask.strokeColor = UIColor.red.cgColor
        //                let maskPath = UIBezierPath()
        //                maskPath.move(to: CGPoint(x: 0, y: labelFrame.height * 0.5))
        //                maskPath.addLine(to: CGPoint(x: labelFrame.width, y: labelFrame.height * 0.5))
        //                textMask.lineWidth = labelFrame.height
        //                textMask.lineCap = .butt
        //                textMask.path = maskPath.cgPath
        //
        //                self.commentLabel.layer.mask = textMask
        //
        //                // animation
        //                let maskAni = CABasicAnimation(keyPath: "strokeEnd")
        //                maskAni.fromValue = 0
        //                maskAni.toValue = 1
        //                maskAni.duration = 1
        //
        //                textMask.add(maskAni, forKey: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    var time = 0
    var dateString: String?
    var dateValue: Int = 0
    @IBAction func saveTouch(_ sender: Any) {

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

