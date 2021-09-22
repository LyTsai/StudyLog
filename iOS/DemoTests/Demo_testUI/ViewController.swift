//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {
//    let deck = DeckCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
  
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            print(AccountAndPasswordTool.passwordContainsNumber(text))
            print(AccountAndPasswordTool.passwordContainsUpperLetter(text))
            print(AccountAndPasswordTool.passwordContainsLowerLetter(text))
            print(AccountAndPasswordTool.passwordContainsWords(text, words: ["test", "password"]))
            print("------------")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

