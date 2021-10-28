//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import MapKit

func UIColorFromHex(_ rgbValue: Int) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha: 1)
}

class ViewController: UIViewController, UITextFieldDelegate {
//    let deck = DeckCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
  
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for seqNumber in 0..<6 {
            if seqNumber % 2 == 0 {
                print(seqNumber / 2)
            }else {
                let totalNumber = 6
                print(totalNumber - (seqNumber / 2) - 1)
            }
        }
    }
    
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
 

}

